-- ==============================================================
-- Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2023.2 (64-bit)
-- Tool Version Limit: 2023.10
-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
-- 
-- ==============================================================
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity ADCCountsToFloat8_control_s_axi is
generic (
    C_S_AXI_ADDR_WIDTH    : INTEGER := 10;
    C_S_AXI_DATA_WIDTH    : INTEGER := 32);
port (
    ACLK                  :in   STD_LOGIC;
    ARESET                :in   STD_LOGIC;
    ACLK_EN               :in   STD_LOGIC;
    AWADDR                :in   STD_LOGIC_VECTOR(C_S_AXI_ADDR_WIDTH-1 downto 0);
    AWVALID               :in   STD_LOGIC;
    AWREADY               :out  STD_LOGIC;
    WDATA                 :in   STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH-1 downto 0);
    WSTRB                 :in   STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH/8-1 downto 0);
    WVALID                :in   STD_LOGIC;
    WREADY                :out  STD_LOGIC;
    BRESP                 :out  STD_LOGIC_VECTOR(1 downto 0);
    BVALID                :out  STD_LOGIC;
    BREADY                :in   STD_LOGIC;
    ARADDR                :in   STD_LOGIC_VECTOR(C_S_AXI_ADDR_WIDTH-1 downto 0);
    ARVALID               :in   STD_LOGIC;
    ARREADY               :out  STD_LOGIC;
    RDATA                 :out  STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH-1 downto 0);
    RRESP                 :out  STD_LOGIC_VECTOR(1 downto 0);
    RVALID                :out  STD_LOGIC;
    RREADY                :in   STD_LOGIC;
    reset                 :out  STD_LOGIC_VECTOR(31 downto 0);
    pointOffset           :out  STD_LOGIC_VECTOR(31 downto 0);
    iCurrentRange_address0 :in   STD_LOGIC_VECTOR(2 downto 0);
    iCurrentRange_ce0     :in   STD_LOGIC;
    iCurrentRange_q0      :out  STD_LOGIC_VECTOR(31 downto 0);
    iOverloadCount_address0 :in   STD_LOGIC_VECTOR(2 downto 0);
    iOverloadCount_ce0    :in   STD_LOGIC;
    iOverloadCount_we0    :in   STD_LOGIC;
    iOverloadCount_d0     :in   STD_LOGIC_VECTOR(31 downto 0);
    OLValid_address0      :in   STD_LOGIC_VECTOR(2 downto 0);
    OLValid_ce0           :in   STD_LOGIC;
    OLValid_we0           :in   STD_LOGIC;
    OLValid_d0            :in   STD_LOGIC_VECTOR(31 downto 0);
    gainChanged_address0  :in   STD_LOGIC_VECTOR(2 downto 0);
    gainChanged_ce0       :in   STD_LOGIC;
    gainChanged_we0       :in   STD_LOGIC;
    gainChanged_d0        :in   STD_LOGIC_VECTOR(31 downto 0);
    status_address0       :in   STD_LOGIC_VECTOR(2 downto 0);
    status_ce0            :in   STD_LOGIC;
    status_we0            :in   STD_LOGIC;
    status_d0             :in   STD_LOGIC_VECTOR(31 downto 0);
    cal_step_address0     :in   STD_LOGIC_VECTOR(5 downto 0);
    cal_step_ce0          :in   STD_LOGIC;
    cal_step_q0           :out  STD_LOGIC_VECTOR(31 downto 0);
    cal_offset_address0   :in   STD_LOGIC_VECTOR(5 downto 0);
    cal_offset_ce0        :in   STD_LOGIC;
    cal_offset_q0         :out  STD_LOGIC_VECTOR(31 downto 0)
);
end entity ADCCountsToFloat8_control_s_axi;

-- ------------------------Address Info-------------------
-- Protocol Used: ap_ctrl_none
--
-- 0x000 : reserved
-- 0x004 : reserved
-- 0x008 : reserved
-- 0x00c : reserved
-- 0x010 : Data signal of reset
--         bit 31~0 - reset[31:0] (Read/Write)
-- 0x014 : reserved
-- 0x018 : Data signal of pointOffset
--         bit 31~0 - pointOffset[31:0] (Read/Write)
-- 0x01c : reserved
-- 0x020 ~
-- 0x03f : Memory 'iCurrentRange' (8 * 32b)
--         Word n : bit [31:0] - iCurrentRange[n]
-- 0x040 ~
-- 0x05f : Memory 'iOverloadCount' (8 * 32b)
--         Word n : bit [31:0] - iOverloadCount[n]
-- 0x060 ~
-- 0x07f : Memory 'OLValid' (8 * 32b)
--         Word n : bit [31:0] - OLValid[n]
-- 0x080 ~
-- 0x09f : Memory 'gainChanged' (8 * 32b)
--         Word n : bit [31:0] - gainChanged[n]
-- 0x0a0 ~
-- 0x0bf : Memory 'status' (8 * 32b)
--         Word n : bit [31:0] - status[n]
-- 0x100 ~
-- 0x1ff : Memory 'cal_step' (64 * 32b)
--         Word n : bit [31:0] - cal_step[n]
-- 0x200 ~
-- 0x2ff : Memory 'cal_offset' (64 * 32b)
--         Word n : bit [31:0] - cal_offset[n]
-- (SC = Self Clear, COR = Clear on Read, TOW = Toggle on Write, COH = Clear on Handshake)

architecture behave of ADCCountsToFloat8_control_s_axi is
    type states is (wridle, wrdata, wrresp, wrreset, rdidle, rddata, rdreset);  -- read and write fsm states
    signal wstate  : states := wrreset;
    signal rstate  : states := rdreset;
    signal wnext, rnext: states;
    constant ADDR_RESET_DATA_0        : INTEGER := 16#010#;
    constant ADDR_RESET_CTRL          : INTEGER := 16#014#;
    constant ADDR_POINTOFFSET_DATA_0  : INTEGER := 16#018#;
    constant ADDR_POINTOFFSET_CTRL    : INTEGER := 16#01c#;
    constant ADDR_ICURRENTRANGE_BASE  : INTEGER := 16#020#;
    constant ADDR_ICURRENTRANGE_HIGH  : INTEGER := 16#03f#;
    constant ADDR_IOVERLOADCOUNT_BASE : INTEGER := 16#040#;
    constant ADDR_IOVERLOADCOUNT_HIGH : INTEGER := 16#05f#;
    constant ADDR_OLVALID_BASE        : INTEGER := 16#060#;
    constant ADDR_OLVALID_HIGH        : INTEGER := 16#07f#;
    constant ADDR_GAINCHANGED_BASE    : INTEGER := 16#080#;
    constant ADDR_GAINCHANGED_HIGH    : INTEGER := 16#09f#;
    constant ADDR_STATUS_BASE         : INTEGER := 16#0a0#;
    constant ADDR_STATUS_HIGH         : INTEGER := 16#0bf#;
    constant ADDR_CAL_STEP_BASE       : INTEGER := 16#100#;
    constant ADDR_CAL_STEP_HIGH       : INTEGER := 16#1ff#;
    constant ADDR_CAL_OFFSET_BASE     : INTEGER := 16#200#;
    constant ADDR_CAL_OFFSET_HIGH     : INTEGER := 16#2ff#;
    constant ADDR_BITS         : INTEGER := 10;

    signal waddr               : UNSIGNED(ADDR_BITS-1 downto 0);
    signal wmask               : UNSIGNED(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal aw_hs               : STD_LOGIC;
    signal w_hs                : STD_LOGIC;
    signal rdata_data          : UNSIGNED(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal ar_hs               : STD_LOGIC;
    signal raddr               : UNSIGNED(ADDR_BITS-1 downto 0);
    signal AWREADY_t           : STD_LOGIC;
    signal WREADY_t            : STD_LOGIC;
    signal ARREADY_t           : STD_LOGIC;
    signal RVALID_t            : STD_LOGIC;
    -- internal registers
    signal int_reset           : UNSIGNED(31 downto 0) := (others => '0');
    signal int_pointOffset     : UNSIGNED(31 downto 0) := (others => '0');
    -- memory signals
    signal int_iCurrentRange_address0 : UNSIGNED(2 downto 0);
    signal int_iCurrentRange_ce0 : STD_LOGIC;
    signal int_iCurrentRange_q0 : UNSIGNED(31 downto 0);
    signal int_iCurrentRange_address1 : UNSIGNED(2 downto 0);
    signal int_iCurrentRange_ce1 : STD_LOGIC;
    signal int_iCurrentRange_we1 : STD_LOGIC;
    signal int_iCurrentRange_be1 : UNSIGNED(3 downto 0);
    signal int_iCurrentRange_d1 : UNSIGNED(31 downto 0);
    signal int_iCurrentRange_q1 : UNSIGNED(31 downto 0);
    signal int_iCurrentRange_read : STD_LOGIC;
    signal int_iCurrentRange_write : STD_LOGIC;
    signal int_iOverloadCount_address0 : UNSIGNED(2 downto 0);
    signal int_iOverloadCount_ce0 : STD_LOGIC;
    signal int_iOverloadCount_be0 : UNSIGNED(3 downto 0);
    signal int_iOverloadCount_d0 : UNSIGNED(31 downto 0);
    signal int_iOverloadCount_address1 : UNSIGNED(2 downto 0);
    signal int_iOverloadCount_ce1 : STD_LOGIC;
    signal int_iOverloadCount_q1 : UNSIGNED(31 downto 0);
    signal int_iOverloadCount_read : STD_LOGIC;
    signal int_iOverloadCount_write : STD_LOGIC;
    signal int_OLValid_address0 : UNSIGNED(2 downto 0);
    signal int_OLValid_ce0     : STD_LOGIC;
    signal int_OLValid_be0     : UNSIGNED(3 downto 0);
    signal int_OLValid_d0      : UNSIGNED(31 downto 0);
    signal int_OLValid_address1 : UNSIGNED(2 downto 0);
    signal int_OLValid_ce1     : STD_LOGIC;
    signal int_OLValid_q1      : UNSIGNED(31 downto 0);
    signal int_OLValid_read    : STD_LOGIC;
    signal int_OLValid_write   : STD_LOGIC;
    signal int_gainChanged_address0 : UNSIGNED(2 downto 0);
    signal int_gainChanged_ce0 : STD_LOGIC;
    signal int_gainChanged_be0 : UNSIGNED(3 downto 0);
    signal int_gainChanged_d0  : UNSIGNED(31 downto 0);
    signal int_gainChanged_address1 : UNSIGNED(2 downto 0);
    signal int_gainChanged_ce1 : STD_LOGIC;
    signal int_gainChanged_q1  : UNSIGNED(31 downto 0);
    signal int_gainChanged_read : STD_LOGIC;
    signal int_gainChanged_write : STD_LOGIC;
    signal int_status_address0 : UNSIGNED(2 downto 0);
    signal int_status_ce0      : STD_LOGIC;
    signal int_status_be0      : UNSIGNED(3 downto 0);
    signal int_status_d0       : UNSIGNED(31 downto 0);
    signal int_status_address1 : UNSIGNED(2 downto 0);
    signal int_status_ce1      : STD_LOGIC;
    signal int_status_q1       : UNSIGNED(31 downto 0);
    signal int_status_read     : STD_LOGIC;
    signal int_status_write    : STD_LOGIC;
    signal int_cal_step_address0 : UNSIGNED(5 downto 0);
    signal int_cal_step_ce0    : STD_LOGIC;
    signal int_cal_step_q0     : UNSIGNED(31 downto 0);
    signal int_cal_step_address1 : UNSIGNED(5 downto 0);
    signal int_cal_step_ce1    : STD_LOGIC;
    signal int_cal_step_we1    : STD_LOGIC;
    signal int_cal_step_be1    : UNSIGNED(3 downto 0);
    signal int_cal_step_d1     : UNSIGNED(31 downto 0);
    signal int_cal_step_q1     : UNSIGNED(31 downto 0);
    signal int_cal_step_read   : STD_LOGIC;
    signal int_cal_step_write  : STD_LOGIC;
    signal int_cal_offset_address0 : UNSIGNED(5 downto 0);
    signal int_cal_offset_ce0  : STD_LOGIC;
    signal int_cal_offset_q0   : UNSIGNED(31 downto 0);
    signal int_cal_offset_address1 : UNSIGNED(5 downto 0);
    signal int_cal_offset_ce1  : STD_LOGIC;
    signal int_cal_offset_we1  : STD_LOGIC;
    signal int_cal_offset_be1  : UNSIGNED(3 downto 0);
    signal int_cal_offset_d1   : UNSIGNED(31 downto 0);
    signal int_cal_offset_q1   : UNSIGNED(31 downto 0);
    signal int_cal_offset_read : STD_LOGIC;
    signal int_cal_offset_write : STD_LOGIC;

    component ADCCountsToFloat8_control_s_axi_ram is
        generic (
            MEM_STYLE : STRING :="auto";
            MEM_TYPE  : STRING :="S2P";
            BYTES   : INTEGER :=4;
            DEPTH   : INTEGER :=256;
            AWIDTH  : INTEGER :=8);
        port (
            clk0    : in  STD_LOGIC;
            address0: in  UNSIGNED(AWIDTH-1 downto 0);
            ce0     : in  STD_LOGIC;
            we0     : in  UNSIGNED(BYTES-1 downto 0);
            d0      : in  UNSIGNED(BYTES*8-1 downto 0);
            q0      : out UNSIGNED(BYTES*8-1 downto 0);
            clk1    : in  STD_LOGIC;
            address1: in  UNSIGNED(AWIDTH-1 downto 0);
            ce1     : in  STD_LOGIC;
            we1     : in  UNSIGNED(BYTES-1 downto 0);
            d1      : in  UNSIGNED(BYTES*8-1 downto 0);
            q1      : out UNSIGNED(BYTES*8-1 downto 0));
    end component ADCCountsToFloat8_control_s_axi_ram;

    function log2 (x : INTEGER) return INTEGER is
        variable n, m : INTEGER;
    begin
        n := 1;
        m := 2;
        while m < x loop
            n := n + 1;
            m := m * 2;
        end loop;
        return n;
    end function log2;

begin
-- ----------------------- Instantiation------------------
-- int_iCurrentRange
int_iCurrentRange : ADCCountsToFloat8_control_s_axi_ram
generic map (
     MEM_STYLE => "auto",
     MEM_TYPE  => "2P",
     BYTES     => 4,
     DEPTH     => 8,
     AWIDTH    => log2(8))
port map (
     clk0      => ACLK,
     address0  => int_iCurrentRange_address0,
     ce0       => int_iCurrentRange_ce0,
     we0       => (others=>'0'),
     d0        => (others=>'0'),
     q0        => int_iCurrentRange_q0,
     clk1      => ACLK,
     address1  => int_iCurrentRange_address1,
     ce1       => int_iCurrentRange_ce1,
     we1       => int_iCurrentRange_be1,
     d1        => int_iCurrentRange_d1,
     q1        => int_iCurrentRange_q1);
-- int_iOverloadCount
int_iOverloadCount : ADCCountsToFloat8_control_s_axi_ram
generic map (
     MEM_STYLE => "auto",
     MEM_TYPE  => "S2P",
     BYTES     => 4,
     DEPTH     => 8,
     AWIDTH    => log2(8))
port map (
     clk0      => ACLK,
     address0  => int_iOverloadCount_address0,
     ce0       => int_iOverloadCount_ce0,
     we0       => int_iOverloadCount_be0,
     d0        => int_iOverloadCount_d0,
     q0        => open,
     clk1      => ACLK,
     address1  => int_iOverloadCount_address1,
     ce1       => int_iOverloadCount_ce1,
     we1       => (others=>'0'),
     d1        => (others=>'0'),
     q1        => int_iOverloadCount_q1);
-- int_OLValid
int_OLValid : ADCCountsToFloat8_control_s_axi_ram
generic map (
     MEM_STYLE => "auto",
     MEM_TYPE  => "S2P",
     BYTES     => 4,
     DEPTH     => 8,
     AWIDTH    => log2(8))
port map (
     clk0      => ACLK,
     address0  => int_OLValid_address0,
     ce0       => int_OLValid_ce0,
     we0       => int_OLValid_be0,
     d0        => int_OLValid_d0,
     q0        => open,
     clk1      => ACLK,
     address1  => int_OLValid_address1,
     ce1       => int_OLValid_ce1,
     we1       => (others=>'0'),
     d1        => (others=>'0'),
     q1        => int_OLValid_q1);
-- int_gainChanged
int_gainChanged : ADCCountsToFloat8_control_s_axi_ram
generic map (
     MEM_STYLE => "auto",
     MEM_TYPE  => "S2P",
     BYTES     => 4,
     DEPTH     => 8,
     AWIDTH    => log2(8))
port map (
     clk0      => ACLK,
     address0  => int_gainChanged_address0,
     ce0       => int_gainChanged_ce0,
     we0       => int_gainChanged_be0,
     d0        => int_gainChanged_d0,
     q0        => open,
     clk1      => ACLK,
     address1  => int_gainChanged_address1,
     ce1       => int_gainChanged_ce1,
     we1       => (others=>'0'),
     d1        => (others=>'0'),
     q1        => int_gainChanged_q1);
-- int_status
int_status : ADCCountsToFloat8_control_s_axi_ram
generic map (
     MEM_STYLE => "auto",
     MEM_TYPE  => "S2P",
     BYTES     => 4,
     DEPTH     => 8,
     AWIDTH    => log2(8))
port map (
     clk0      => ACLK,
     address0  => int_status_address0,
     ce0       => int_status_ce0,
     we0       => int_status_be0,
     d0        => int_status_d0,
     q0        => open,
     clk1      => ACLK,
     address1  => int_status_address1,
     ce1       => int_status_ce1,
     we1       => (others=>'0'),
     d1        => (others=>'0'),
     q1        => int_status_q1);
-- int_cal_step
int_cal_step : ADCCountsToFloat8_control_s_axi_ram
generic map (
     MEM_STYLE => "auto",
     MEM_TYPE  => "2P",
     BYTES     => 4,
     DEPTH     => 64,
     AWIDTH    => log2(64))
port map (
     clk0      => ACLK,
     address0  => int_cal_step_address0,
     ce0       => int_cal_step_ce0,
     we0       => (others=>'0'),
     d0        => (others=>'0'),
     q0        => int_cal_step_q0,
     clk1      => ACLK,
     address1  => int_cal_step_address1,
     ce1       => int_cal_step_ce1,
     we1       => int_cal_step_be1,
     d1        => int_cal_step_d1,
     q1        => int_cal_step_q1);
-- int_cal_offset
int_cal_offset : ADCCountsToFloat8_control_s_axi_ram
generic map (
     MEM_STYLE => "auto",
     MEM_TYPE  => "2P",
     BYTES     => 4,
     DEPTH     => 64,
     AWIDTH    => log2(64))
port map (
     clk0      => ACLK,
     address0  => int_cal_offset_address0,
     ce0       => int_cal_offset_ce0,
     we0       => (others=>'0'),
     d0        => (others=>'0'),
     q0        => int_cal_offset_q0,
     clk1      => ACLK,
     address1  => int_cal_offset_address1,
     ce1       => int_cal_offset_ce1,
     we1       => int_cal_offset_be1,
     d1        => int_cal_offset_d1,
     q1        => int_cal_offset_q1);


-- ----------------------- AXI WRITE ---------------------
    AWREADY_t <=  '1' when wstate = wridle else '0';
    AWREADY   <=  AWREADY_t;
    WREADY_t  <=  '1' when wstate = wrdata and ar_hs = '0' else '0';
    WREADY    <=  WREADY_t;
    BRESP     <=  "00";  -- OKAY
    BVALID    <=  '1' when wstate = wrresp else '0';
    wmask     <=  (31 downto 24 => WSTRB(3), 23 downto 16 => WSTRB(2), 15 downto 8 => WSTRB(1), 7 downto 0 => WSTRB(0));
    aw_hs     <=  AWVALID and AWREADY_t;
    w_hs      <=  WVALID and WREADY_t;

    -- write FSM
    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                wstate <= wrreset;
            elsif (ACLK_EN = '1') then
                wstate <= wnext;
            end if;
        end if;
    end process;

    process (wstate, AWVALID, w_hs, BREADY)
    begin
        case (wstate) is
        when wridle =>
            if (AWVALID = '1') then
                wnext <= wrdata;
            else
                wnext <= wridle;
            end if;
        when wrdata =>
            if (w_hs = '1') then
                wnext <= wrresp;
            else
                wnext <= wrdata;
            end if;
        when wrresp =>
            if (BREADY = '1') then
                wnext <= wridle;
            else
                wnext <= wrresp;
            end if;
        when others =>
            wnext <= wridle;
        end case;
    end process;

    waddr_proc : process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ACLK_EN = '1') then
                if (aw_hs = '1') then
                    waddr <= UNSIGNED(AWADDR(ADDR_BITS-1 downto 0));
                end if;
            end if;
        end if;
    end process;

-- ----------------------- AXI READ ----------------------
    ARREADY_t <= '1' when (rstate = rdidle) else '0';
    ARREADY <= ARREADY_t;
    RDATA   <= STD_LOGIC_VECTOR(rdata_data);
    RRESP   <= "00";  -- OKAY
    RVALID_t  <= '1' when (rstate = rddata) and (int_iCurrentRange_read = '0') and (int_iOverloadCount_read = '0') and (int_OLValid_read = '0') and (int_gainChanged_read = '0') and (int_status_read = '0') and (int_cal_step_read = '0') and (int_cal_offset_read = '0') else '0';
    RVALID    <= RVALID_t;
    ar_hs   <= ARVALID and ARREADY_t;
    raddr   <= UNSIGNED(ARADDR(ADDR_BITS-1 downto 0));

    -- read FSM
    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                rstate <= rdreset;
            elsif (ACLK_EN = '1') then
                rstate <= rnext;
            end if;
        end if;
    end process;

    process (rstate, ARVALID, RREADY, RVALID_t)
    begin
        case (rstate) is
        when rdidle =>
            if (ARVALID = '1') then
                rnext <= rddata;
            else
                rnext <= rdidle;
            end if;
        when rddata =>
            if (RREADY = '1' and RVALID_t = '1') then
                rnext <= rdidle;
            else
                rnext <= rddata;
            end if;
        when others =>
            rnext <= rdidle;
        end case;
    end process;

    rdata_proc : process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ACLK_EN = '1') then
                if (ar_hs = '1') then
                    rdata_data <= (others => '0');
                    case (TO_INTEGER(raddr)) is
                    when ADDR_RESET_DATA_0 =>
                        rdata_data <= RESIZE(int_reset(31 downto 0), 32);
                    when ADDR_POINTOFFSET_DATA_0 =>
                        rdata_data <= RESIZE(int_pointOffset(31 downto 0), 32);
                    when others =>
                        NULL;
                    end case;
                elsif (int_iCurrentRange_read = '1') then
                    rdata_data <= int_iCurrentRange_q1;
                elsif (int_iOverloadCount_read = '1') then
                    rdata_data <= int_iOverloadCount_q1;
                elsif (int_OLValid_read = '1') then
                    rdata_data <= int_OLValid_q1;
                elsif (int_gainChanged_read = '1') then
                    rdata_data <= int_gainChanged_q1;
                elsif (int_status_read = '1') then
                    rdata_data <= int_status_q1;
                elsif (int_cal_step_read = '1') then
                    rdata_data <= int_cal_step_q1;
                elsif (int_cal_offset_read = '1') then
                    rdata_data <= int_cal_offset_q1;
                end if;
            end if;
        end if;
    end process;

-- ----------------------- Register logic ----------------
    reset                <= STD_LOGIC_VECTOR(int_reset);
    pointOffset          <= STD_LOGIC_VECTOR(int_pointOffset);

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_RESET_DATA_0) then
                    int_reset(31 downto 0) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_reset(31 downto 0));
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ACLK_EN = '1') then
                if (w_hs = '1' and waddr = ADDR_POINTOFFSET_DATA_0) then
                    int_pointOffset(31 downto 0) <= (UNSIGNED(WDATA(31 downto 0)) and wmask(31 downto 0)) or ((not wmask(31 downto 0)) and int_pointOffset(31 downto 0));
                end if;
            end if;
        end if;
    end process;


-- ----------------------- Memory logic ------------------
    -- iCurrentRange
    int_iCurrentRange_address0 <= UNSIGNED(iCurrentRange_address0);
    int_iCurrentRange_ce0 <= iCurrentRange_ce0;
    iCurrentRange_q0     <= STD_LOGIC_VECTOR(RESIZE(int_iCurrentRange_q0, 32));
    int_iCurrentRange_address1 <= raddr(4 downto 2) when ar_hs = '1' else waddr(4 downto 2);
    int_iCurrentRange_ce1 <= '1' when ar_hs = '1' or (int_iCurrentRange_write = '1' and WVALID  = '1') else '0';
    int_iCurrentRange_we1 <= '1' when int_iCurrentRange_write = '1' and w_hs = '1' else '0';
    int_iCurrentRange_be1 <= UNSIGNED(WSTRB) when int_iCurrentRange_we1 = '1' else (others=>'0');
    int_iCurrentRange_d1 <= UNSIGNED(WDATA);
    -- iOverloadCount
    int_iOverloadCount_address0 <= UNSIGNED(iOverloadCount_address0);
    int_iOverloadCount_ce0 <= iOverloadCount_ce0;
    int_iOverloadCount_be0 <= (others => iOverloadCount_we0);
    int_iOverloadCount_d0 <= RESIZE(UNSIGNED(iOverloadCount_d0), 32);
    int_iOverloadCount_address1 <= raddr(4 downto 2) when ar_hs = '1' else waddr(4 downto 2);
    int_iOverloadCount_ce1 <= '1' when ar_hs = '1' or (int_iOverloadCount_write = '1' and WVALID  = '1') else '0';
    -- OLValid
    int_OLValid_address0 <= UNSIGNED(OLValid_address0);
    int_OLValid_ce0      <= OLValid_ce0;
    int_OLValid_be0      <= (others => OLValid_we0);
    int_OLValid_d0       <= RESIZE(UNSIGNED(OLValid_d0), 32);
    int_OLValid_address1 <= raddr(4 downto 2) when ar_hs = '1' else waddr(4 downto 2);
    int_OLValid_ce1      <= '1' when ar_hs = '1' or (int_OLValid_write = '1' and WVALID  = '1') else '0';
    -- gainChanged
    int_gainChanged_address0 <= UNSIGNED(gainChanged_address0);
    int_gainChanged_ce0  <= gainChanged_ce0;
    int_gainChanged_be0  <= (others => gainChanged_we0);
    int_gainChanged_d0   <= RESIZE(UNSIGNED(gainChanged_d0), 32);
    int_gainChanged_address1 <= raddr(4 downto 2) when ar_hs = '1' else waddr(4 downto 2);
    int_gainChanged_ce1  <= '1' when ar_hs = '1' or (int_gainChanged_write = '1' and WVALID  = '1') else '0';
    -- status
    int_status_address0  <= UNSIGNED(status_address0);
    int_status_ce0       <= status_ce0;
    int_status_be0       <= (others => status_we0);
    int_status_d0        <= RESIZE(UNSIGNED(status_d0), 32);
    int_status_address1  <= raddr(4 downto 2) when ar_hs = '1' else waddr(4 downto 2);
    int_status_ce1       <= '1' when ar_hs = '1' or (int_status_write = '1' and WVALID  = '1') else '0';
    -- cal_step
    int_cal_step_address0 <= UNSIGNED(cal_step_address0);
    int_cal_step_ce0     <= cal_step_ce0;
    cal_step_q0          <= STD_LOGIC_VECTOR(RESIZE(int_cal_step_q0, 32));
    int_cal_step_address1 <= raddr(7 downto 2) when ar_hs = '1' else waddr(7 downto 2);
    int_cal_step_ce1     <= '1' when ar_hs = '1' or (int_cal_step_write = '1' and WVALID  = '1') else '0';
    int_cal_step_we1     <= '1' when int_cal_step_write = '1' and w_hs = '1' else '0';
    int_cal_step_be1     <= UNSIGNED(WSTRB) when int_cal_step_we1 = '1' else (others=>'0');
    int_cal_step_d1      <= UNSIGNED(WDATA);
    -- cal_offset
    int_cal_offset_address0 <= UNSIGNED(cal_offset_address0);
    int_cal_offset_ce0   <= cal_offset_ce0;
    cal_offset_q0        <= STD_LOGIC_VECTOR(RESIZE(int_cal_offset_q0, 32));
    int_cal_offset_address1 <= raddr(7 downto 2) when ar_hs = '1' else waddr(7 downto 2);
    int_cal_offset_ce1   <= '1' when ar_hs = '1' or (int_cal_offset_write = '1' and WVALID  = '1') else '0';
    int_cal_offset_we1   <= '1' when int_cal_offset_write = '1' and w_hs = '1' else '0';
    int_cal_offset_be1   <= UNSIGNED(WSTRB) when int_cal_offset_we1 = '1' else (others=>'0');
    int_cal_offset_d1    <= UNSIGNED(WDATA);

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_iCurrentRange_read <= '0';
            elsif (ACLK_EN = '1') then
                if (ar_hs = '1' and raddr >= ADDR_ICURRENTRANGE_BASE and raddr <= ADDR_ICURRENTRANGE_HIGH) then
                    int_iCurrentRange_read <= '1';
                else
                    int_iCurrentRange_read <= '0';
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_iCurrentRange_write <= '0';
            elsif (ACLK_EN = '1') then
                if (aw_hs = '1' and UNSIGNED(AWADDR(ADDR_BITS-1 downto 0)) >= ADDR_ICURRENTRANGE_BASE and UNSIGNED(AWADDR(ADDR_BITS-1 downto 0)) <= ADDR_ICURRENTRANGE_HIGH) then
                    int_iCurrentRange_write <= '1';
                elsif (w_hs = '1') then
                    int_iCurrentRange_write <= '0';
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_iOverloadCount_read <= '0';
            elsif (ACLK_EN = '1') then
                if (ar_hs = '1' and raddr >= ADDR_IOVERLOADCOUNT_BASE and raddr <= ADDR_IOVERLOADCOUNT_HIGH) then
                    int_iOverloadCount_read <= '1';
                else
                    int_iOverloadCount_read <= '0';
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_OLValid_read <= '0';
            elsif (ACLK_EN = '1') then
                if (ar_hs = '1' and raddr >= ADDR_OLVALID_BASE and raddr <= ADDR_OLVALID_HIGH) then
                    int_OLValid_read <= '1';
                else
                    int_OLValid_read <= '0';
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_gainChanged_read <= '0';
            elsif (ACLK_EN = '1') then
                if (ar_hs = '1' and raddr >= ADDR_GAINCHANGED_BASE and raddr <= ADDR_GAINCHANGED_HIGH) then
                    int_gainChanged_read <= '1';
                else
                    int_gainChanged_read <= '0';
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_status_read <= '0';
            elsif (ACLK_EN = '1') then
                if (ar_hs = '1' and raddr >= ADDR_STATUS_BASE and raddr <= ADDR_STATUS_HIGH) then
                    int_status_read <= '1';
                else
                    int_status_read <= '0';
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_cal_step_read <= '0';
            elsif (ACLK_EN = '1') then
                if (ar_hs = '1' and raddr >= ADDR_CAL_STEP_BASE and raddr <= ADDR_CAL_STEP_HIGH) then
                    int_cal_step_read <= '1';
                else
                    int_cal_step_read <= '0';
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_cal_step_write <= '0';
            elsif (ACLK_EN = '1') then
                if (aw_hs = '1' and UNSIGNED(AWADDR(ADDR_BITS-1 downto 0)) >= ADDR_CAL_STEP_BASE and UNSIGNED(AWADDR(ADDR_BITS-1 downto 0)) <= ADDR_CAL_STEP_HIGH) then
                    int_cal_step_write <= '1';
                elsif (w_hs = '1') then
                    int_cal_step_write <= '0';
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_cal_offset_read <= '0';
            elsif (ACLK_EN = '1') then
                if (ar_hs = '1' and raddr >= ADDR_CAL_OFFSET_BASE and raddr <= ADDR_CAL_OFFSET_HIGH) then
                    int_cal_offset_read <= '1';
                else
                    int_cal_offset_read <= '0';
                end if;
            end if;
        end if;
    end process;

    process (ACLK)
    begin
        if (ACLK'event and ACLK = '1') then
            if (ARESET = '1') then
                int_cal_offset_write <= '0';
            elsif (ACLK_EN = '1') then
                if (aw_hs = '1' and UNSIGNED(AWADDR(ADDR_BITS-1 downto 0)) >= ADDR_CAL_OFFSET_BASE and UNSIGNED(AWADDR(ADDR_BITS-1 downto 0)) <= ADDR_CAL_OFFSET_HIGH) then
                    int_cal_offset_write <= '1';
                elsif (w_hs = '1') then
                    int_cal_offset_write <= '0';
                end if;
            end if;
        end if;
    end process;


end architecture behave;

library IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;

entity ADCCountsToFloat8_control_s_axi_ram is
    generic (
        MEM_STYLE : STRING :="auto";
        MEM_TYPE  : STRING :="S2P";
        BYTES   : INTEGER :=4;
        DEPTH   : INTEGER :=256;
        AWIDTH  : INTEGER :=8);
    port (
        clk0    : in  STD_LOGIC;
        address0: in  UNSIGNED(AWIDTH-1 downto 0);
        ce0     : in  STD_LOGIC;
        we0     : in  UNSIGNED(BYTES-1 downto 0);
        d0      : in  UNSIGNED(BYTES*8-1 downto 0);
        q0      : out UNSIGNED(BYTES*8-1 downto 0);
        clk1    : in  STD_LOGIC;
        address1: in  UNSIGNED(AWIDTH-1 downto 0);
        ce1     : in  STD_LOGIC;
        we1     : in  UNSIGNED(BYTES-1 downto 0);
        d1      : in  UNSIGNED(BYTES*8-1 downto 0);
        q1      : out UNSIGNED(BYTES*8-1 downto 0));

end entity ADCCountsToFloat8_control_s_axi_ram;

architecture behave of ADCCountsToFloat8_control_s_axi_ram is
    signal address0_tmp : UNSIGNED(AWIDTH-1 downto 0);
    signal address1_tmp : UNSIGNED(AWIDTH-1 downto 0);
    type RAM_T is array (0 to DEPTH - 1) of UNSIGNED(BYTES*8 - 1 downto 0);
    shared variable mem : RAM_T := (others => (others => '0'));
    attribute ram_style: string;
    attribute ram_style of mem: variable is MEM_STYLE;
    constant BYTE_WIDTH :INTEGER := 8;

    function port_type_gen( MEM_TYPE: STRING; MEM_STYLE: STRING; PORT_NAME: STRING) return STRING is
    begin
        if (MEM_TYPE = "S2P") and (PORT_NAME = "PORT0") then
            return "WO";
        elsif((MEM_TYPE = "S2P") and (PORT_NAME = "PORT1")) or ((MEM_TYPE = "2P") and (PORT_NAME = "PORT0")) then
            return "RO";
        elsif (MEM_STYLE = "hls_ultra") then
            return "RWNC";
        else
            return "RWRF";
        end if;
    end port_type_gen;
    constant PORT0 :STRING := port_type_gen(MEM_TYPE, MEM_STYLE, "PORT0");
    constant PORT1 :STRING := port_type_gen(MEM_TYPE, MEM_STYLE, "PORT1");

    function or_reduce( V: UNSIGNED) return std_logic is
    variable result: std_logic;
    begin
        for i in V'range loop
            if i = V'left then
                result := V(i);
            else
                result := result OR V(i);
            end if;
            exit when result = '1';
        end loop;
        return result;
    end or_reduce;

begin

    process (address0)
    begin
    address0_tmp <= address0;
    --synthesis translate_off
        if (address0 > DEPTH-1) then
            address0_tmp <= (others => '0');
        else
            address0_tmp <= address0;
        end if;
    --synthesis translate_on
    end process;

    process (address1)
    begin
    address1_tmp <= address1;
    --synthesis translate_off
        if (address1 > DEPTH-1) then
            address1_tmp <= (others => '0');
        else
            address1_tmp <= address1;
        end if;
    --synthesis translate_on
    end process;

    --read port 0
    read_p0_rf : if (PORT0 = "RO" or PORT0 = "RWRF") generate
        process (clk0) begin
            if (clk0'event and clk0 = '1') then
                if (ce0 = '1') then
                    q0 <= mem(to_integer(address0_tmp));
                end if;
            end if;
        end process;
    end generate read_p0_rf;

    read_p0_nc : if (PORT0 = "RWNC") generate
        process (clk0) begin
            if (clk0'event and clk0 = '1') then
                if (ce0 = '1') then
                    if (we0 = (we0'range => '0')) then
                        q0 <= mem(to_integer(address0_tmp));
                    end if;
                end if;
            end if;
        end process;
    end generate read_p0_nc;

    --read port 1
    read_p1_rf : if (PORT1 = "RO" or PORT1 = "RWRF") generate
        process (clk1) begin
            if (clk1'event and clk1 = '1') then
                if (ce1 = '1') then
                    q1 <= mem(to_integer(address1_tmp));
                end if;
            end if;
        end process;
    end generate read_p1_rf;

    read_p1_nc : if (PORT1 = "RWNC") generate
        process (clk1) begin
            if (clk1'event and clk1 = '1') then
                if (ce1 = '1') then
                    if (we1 = (we1'range => '0')) then
                        q1 <= mem(to_integer(address1_tmp));
                    end if;
                end if;
            end if;
        end process;
    end generate read_p1_nc;

    --write port 0
    write_p0 : if (PORT0 /= "RO") generate
        process (clk0)
        begin
            if (clk0'event and clk0 = '1') then
                if (ce0 = '1') then
                for i in 0 to BYTES - 1 loop
                    if (we0(i) = '1') then
                        mem(to_integer(address0_tmp))((i+1)*BYTE_WIDTH-1 downto i*BYTE_WIDTH) := d0((i+1)*BYTE_WIDTH-1 downto i*BYTE_WIDTH);
                    end if;
                end loop;
                end if;
            end if;
        end process;
    end generate write_p0;

    --write port 1
    write_p1 : if (PORT1 /= "RO") generate
        process (clk1)
        begin
            if (clk1'event and clk1 = '1') then
                if (ce1 = '1') then
                for i in 0 to BYTES - 1 loop
                    if (we1(i) = '1') then
                        mem(to_integer(address1_tmp))((i+1)*BYTE_WIDTH-1 downto i*BYTE_WIDTH) := d1((i+1)*BYTE_WIDTH-1 downto i*BYTE_WIDTH);
                    end if;
                end loop;
                end if;
            end if;
        end process;
    end generate write_p1;

end architecture behave;


