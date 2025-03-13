# Prog. Version..: '5.30.06-13.03.28(00004)'     #
#
# Pattern name...: aicr054.4gl
# Descriptions...: WIP報表(依料件)
# Date & Author..: 100/05/04 by jason (FUN-B10066)
# Modify.........: No.TQC-B80207 11/08/29 By Jason 清空temptable
# Modify.........: No.FUN-BB0047 11/12/30 By fengrui  調整時間函數問題
# Modify.........: No.MOD-CC0078 12/12/11 By Elise 調整sql

DATABASE ds

#FUN-B10066
GLOBALS "../../config/top.global"

GLOBALS
  DEFINE g_sql_1 STRING
  DEFINE g_sql_2 STRING
  DEFINE g_sql_3 STRING
  DEFINE g_sql_4 STRING
  DEFINE g_sql_5 STRING
  DEFINE g_sql_6 STRING
  DEFINE g_opd06 LIKE opd_file.opd06
  DEFINE g_opd07 LIKE opd_file.opd07

  DEFINE g_rep_data RECORD
          id_wafer    LIKE imaicd_file.imaicd00,    #Wafer料號
          wafer_desc  LIKE ima_file.ima02,          #Wafer品名
          id_cp       LIKE imaicd_file.imaicd00,    #CP 料號
          cp_desc     LIKE ima_file.ima02,          #CP品名
          id_as       LIKE imaicd_file.imaicd00,    #AS 料號
          as_desc     LIKE ima_file.ima02,          #AS品名
          id_ft       LIKE imaicd_file.imaicd00,    #FT料號
          ft_desc     LIKE ima_file.ima02,          #FT品名
          wip_wafer   LIKE img_file.img10,          #Wafer P/O量
          wip_cp      LIKE img_file.img10,          #CP在製量
          wip_as      LIKE img_file.img10,          #AS在製量
          wip_ft      LIKE img_file.img10,          #FT在製量
          stk_wafer   LIKE img_file.img10,          #Wafer庫存量
          stk_cp      LIKE img_file.img10,          #CP庫存量
          stk_as      LIKE img_file.img10,          #AS庫存量
          stk_ft      LIKE img_file.img10,          #BIN1庫存
          bin_02      LIKE img_file.img10,          #BIN03庫存
          bin_03      LIKE img_file.img10,          #BIN04庫存
          bin_04      LIKE img_file.img10,          #BIN05庫存
          bin_05      LIKE img_file.img10,          #BIN06庫存
          bin_06      LIKE img_file.img10,          #BIN07庫存
          bin_07      LIKE img_file.img10,          #BIN08庫存
          bin_08      LIKE img_file.img10,          #BIN09庫存
          bin_09      LIKE img_file.img10,          #BINxx庫存
          bin_xx      LIKE img_file.img10,          #BIN02庫存
          wafer_yield LIKE imaicd_file.imaicd15,    #Wafer良率
          cp_yield    LIKE imaicd_file.imaicd15,    #cP良率
          as_yield    LIKE imaicd_file.imaicd15,    #AS良率
          ft_yield    LIKE imaicd_file.imaicd15,    #FT良率
          so_not      LIKE oeb_file.oeb12,          #S/O未交量
          forecast    LIKE oeb_file.oeb12,          #Forecast數量
          goodqty     LIKE oeb_file.oeb12,          #預計可用量
          gross_die   LIKE imaicd_file.imaicd14     #Gross Die
       END RECORD
END GLOBALS

#註：stk_ft 即為BIN01量,BIN02,BIN03...BIN09,BINXX的量皆給0

DEFINE   g_sql           STRING
DEFINE   l_table         STRING
DEFINE   g_str           STRING

DEFINE tm  RECORD
        wc      STRING,
        more    LIKE type_file.chr1          # Input more condition(Y/N)
      END RECORD

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                 # Supress DEL key function

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF NOT s_industry("icd") THEN
      CALL cl_err('','aic-999',1)
      EXIT PROGRAM
   END IF

   IF (NOT cl_setup("AIC")) THEN
      EXIT PROGRAM
   END IF

   #CALL cl_used(g_prog,g_time,1) RETURNING  g_time   #TQC-B80207 #FUN-BB0047 mark

   LET g_sql = "id_wafer.imaicd_file.imaicd00,",
               "wafer_desc.ima_file.ima02,",
               "id_cp.imaicd_file.imaicd00,",
               "cp_desc.ima_file.ima02,",
               "id_as.imaicd_file.imaicd00,",
               "as_desc.ima_file.ima02,",
               "id_ft.imaicd_file.imaicd00,",
               "ft_desc.ima_file.ima02,",
               "wip_wafer.img_file.img10,",
               "wip_cp.img_file.img10,",
               "wip_as.img_file.img10,",
               "wip_ft.img_file.img10,",
               "stk_wafer.img_file.img10,",
               "stk_cp.img_file.img10,",
               "stk_as.img_file.img10,",
               "stk_ft.img_file.img10,",
               "bin_02.img_file.img10,",
               "bin_03.img_file.img10,",
               "bin_04.img_file.img10,",
               "bin_05.img_file.img10,",
               "bin_06.img_file.img10,",
               "bin_07.img_file.img10,",
               "bin_08.img_file.img10,",
               "bin_09.img_file.img10,",
               "bin_xx.img_file.img10,",
               "wafer_yield.imaicd_file.imaicd15,",
               "cp_yield.imaicd_file.imaicd15,",
               "as_yield.imaicd_file.imaicd15,",
               "ft_yield.imaicd_file.imaicd15,",
               "so_not.oeb_file.oeb12,",
               "forecast.oeb_file.oeb12,",
               "goodqty.oeb_file.oeb12,",
               "gross_die.imaicd_file.imaicd14"

   LET l_table = cl_prt_temptable('aicr054',g_sql) CLIPPED
   IF  l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?",
                        ",?,?,?,?,?,?,?,?,?,?,?) "
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1)RETURNING g_time  #FUN-BB0047 add
   CALL r054_tm(0,0)
   CALL cl_used(g_prog,g_time,2) RETURNING g_time   #TQC-B80207
END MAIN

FUNCTION r054_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01
   DEFINE p_row,p_col    LIKE type_file.num5
   DEFINE l_cmd          LIKE type_file.chr1000
   DEFINE l_sql STRING

   LET p_row = 4 LET p_col = 15

   OPEN WINDOW r054_w AT p_row,p_col WITH FORM "aic/42f/aicr054"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition

   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET g_opd06 = NULL
   LET g_opd07 = NULL

WHILE TRUE
   DIALOG ATTRIBUTES(UNBUFFERED)
      CONSTRUCT g_sql_1 ON imaicd00 FROM imaicd00_01
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
      END CONSTRUCT

      CONSTRUCT g_sql_2 ON ima01 FROM imaicd00_02
         BEFORE CONSTRUCT
       CALL cl_qbe_display_condition(lc_qbe_sn)
      END CONSTRUCT

      CONSTRUCT g_sql_3 ON ima01 FROM imaicd00_03
         BEFORE CONSTRUCT
       CALL cl_qbe_display_condition(lc_qbe_sn)
      END CONSTRUCT

      CONSTRUCT g_sql_4 ON ima01 FROM imaicd00_04
         BEFORE CONSTRUCT
       CALL cl_qbe_display_condition(lc_qbe_sn)
      END CONSTRUCT

      CONSTRUCT BY NAME g_sql_5 ON pmm04
         BEFORE CONSTRUCT
       CALL cl_qbe_display_condition(lc_qbe_sn)
      END CONSTRUCT

      CONSTRUCT BY NAME g_sql_6 ON sfb81
         BEFORE CONSTRUCT
       CALL cl_qbe_display_condition(lc_qbe_sn)
      END CONSTRUCT

      INPUT g_opd06,g_opd07,tm.more FROM FORMONLY.opd06,FORMONLY.opd07,FORMONLY.more
         ATTRIBUTES(WITHOUT DEFAULTS=TRUE)

         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         AFTER FIELD more
         IF tm.more NOT MATCHES "[YN]"
            THEN NEXT FIELD more
         END IF
         IF tm.more = 'Y' THEN
            CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                            g_bgjob,g_time,g_prtway,g_copies)
                  RETURNING g_pdate,g_towhom,g_rlang,
                            g_bgjob,g_time,g_prtway,g_copies
         END IF
      END INPUT

      ON ACTION CONTROLP
         CASE WHEN INFIELD(sfp01)
           WHEN INFIELD(imaicd00_01)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_imaicd"
              LET g_qryparam.state = "c"
              LET g_qryparam.WHERE = "imaicd04='1'"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO imaicd00_01
              NEXT FIELD imaicd00_01
           WHEN INFIELD(imaicd00_02)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_imaicd"
              LET g_qryparam.state = "c"
              LET g_qryparam.WHERE = "imaicd04='2'"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO imaicd00_02
              NEXT FIELD imaicd00_02
           WHEN INFIELD(imaicd00_03)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_imaicd"
              LET g_qryparam.state = "c"
              LET g_qryparam.WHERE = "imaicd04='3'"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO imaicd00_03
              NEXT FIELD imaicd00_02
           WHEN INFIELD(imaicd00_04)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_imaicd"
              LET g_qryparam.state = "c"
              LET g_qryparam.WHERE = "imaicd04='4'"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO imaicd00_04
              NEXT FIELD imaicd00_02
         END CASE

      ON ACTION locale
         CALL cl_show_fld_cont()
         LET g_action_choice = "locale"
         EXIT DIALOG

      ON ACTION accept
         EXIT DIALOG

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG

      ON ACTION about
         CALL cl_about()

      ON ACTION help
         CALL cl_show_help()

      ON ACTION controlg
         CALL cl_cmdask()

      ON ACTION exit
         LET INT_FLAG = 1
         EXIT DIALOG

      ON ACTION qbe_SELECT
         CALL cl_qbe_SELECT()

      ON ACTION qbe_save
         CALL cl_qbe_save()

      ON ACTION cancel
         LET INT_FLAG = TRUE
         EXIT DIALOG
   END DIALOG

   IF g_action_choice = "locale" THEN
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF

   IF INT_FLAG THEN      
      LET INT_FLAG = 0
      CLOSE WINDOW r054_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time   #TQC-B80207 
      EXIT PROGRAM
   END IF

   #IF tm.wc=" 1=1 " THEN
   #   CALL cl_err(' ','9046',0)
   #   CONTINUE WHILE
   #END IF
   IF (g_sql_1 = ' 1=1') AND
      (g_sql_2 = ' 1=1') AND
      (g_sql_3 = ' 1=1') AND
      (g_sql_4 = ' 1=1') AND
      (g_sql_5 = ' 1=1') AND
      (g_sql_6 = ' 1=1') THEN
      CALL cl_err('','art-121',1)
      CONTINUE WHILE
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='aicr054'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aicr054','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,          #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", #No:FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",
                         " '",g_rep_clas CLIPPED,"'",
                         " '",g_template CLIPPED,"'"
         CALL cl_cmdat('aicr054',g_time,l_cmd)      # Execute cmd at later time
      END IF
      CLOSE WINDOW r054_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time   #TQC-B80207
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL aicr054()
   ERROR ""
   LET l_sql= "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   CALL cl_prt_cs3('aicr054','aicr054',l_sql,g_str)
END WHILE
CLOSE WINDOW r054_w
END FUNCTION

FUNCTION aicr054()

   DEFINE l_imaicd00 LIKE imaicd_file.imaicd00
   DEFINE l_imaicd04 LIKE imaicd_file.imaicd04
   DEFINE l_imaicd08 LIKE imaicd_file.imaicd08
   DEFINE l_imaicd14 LIKE imaicd_file.imaicd14
   DEFINE l_imaicd15 LIKE imaicd_file.imaicd15
   DEFINE l_ima02    LIKE ima_file.ima02

   CALL cl_del_data(l_table)   #TQC-B80207

   LET g_sql = "SELECT imaicd00,imaicd04,imaicd08,imaicd14,imaicd15,ima02",
               "  FROM imaicd_file LEFT OUTER JOIN ima_file ON (ima01=imaicd00)",
               " WHERE imaicd04='1' AND ", g_sql_1
   PREPARE r054_p1 FROM g_sql
   DECLARE r054_c1 CURSOR FOR r054_p1

   FOREACH r054_c1 INTO l_imaicd00,l_imaicd04,l_imaicd08,l_imaicd14,l_imaicd15,l_ima02

       INITIALIZE g_rep_data.* TO NULL

       LET g_rep_data.id_wafer = l_imaicd00
       LET g_rep_data.wafer_desc   = l_ima02
       LET g_rep_data.wafer_yield  = l_imaicd15
       LET g_rep_data.bin_02  = 0
       LET g_rep_data.bin_03  = 0
       LET g_rep_data.bin_04  = 0
       LET g_rep_data.bin_05  = 0
       LET g_rep_data.bin_06  = 0
       LET g_rep_data.bin_07  = 0
       LET g_rep_data.bin_08  = 0
       LET g_rep_data.bin_09  = 0
       LET g_rep_data.bin_xx  = 0
       IF l_imaicd14 > 0 THEN
          LET g_rep_data.gross_die = l_imaicd14
       END IF
       LET g_rep_data.goodqty = 0
       CALL r054_stk(l_imaicd00,l_imaicd04)
       CALL r054_wip(l_imaicd00,l_imaicd04)
       CALL r054_up_loop(l_imaicd00,l_imaicd04)
       CALL r054_goodqty(l_imaicd00)
       CALL r054_ins_temp()
   END FOREACH
END FUNCTION

FUNCTION r054_stk(l_bmb01,l_imaicd04)
   DEFINE l_bmb01    LIKE bmb_file.bmb01
   DEFINE l_imaicd04 LIKE imaicd_file.imaicd04
   DEFINE l_img10    LIKE img_file.img10

   SELECT SUM(img10*img21) INTO l_img10 FROM img_file WHERE img01=l_bmb01

   CASE l_imaicd04
      WHEN "1"
         LET g_rep_data.stk_wafer=l_img10
      WHEN "2"
         LET g_rep_data.stk_cp=l_img10
      WHEN "3"
         LET g_rep_data.stk_as=l_img10
      WHEN "4"
         LET g_rep_data.stk_ft=l_img10
   END CASE
END FUNCTION

FUNCTION r054_wip(l_bmb01,l_imaicd04)
   DEFINE l_bmb01    LIKE bmb_file.bmb01
   DEFINE l_imaicd04 LIKE imaicd_file.imaicd04
   DEFINE l_img10    LIKE img_file.img10
   DEFINE l_sfb09    LIKE sfb_file.sfb09
   DEFINE l_sql STRING

   LET l_img10 = 0
   LET l_sfb09 = 0
   CASE l_imaicd04
      WHEN "1"
         LET l_sql = "SELECT SUM(pmn20-pmn50+pmn55+pmn58)FROM pmn_file,pmm_file",
                        " WHERE pmn01=pmm01 AND pmn04='", l_bmb01, "' AND pmm18<>'X'",
                        " AND pmmacti='Y' AND pmm02 in ('WB0','WB1') AND ", g_sql_5  #MOD-CC0078 add AND
         PREPARE r054_p01 FROM l_sql
         EXECUTE r054_p01 INTO l_img10
         IF l_img10 IS NULL THEN LET l_img10 = 0 END IF
         LET g_rep_data.wip_wafer=l_img10
      WHEN "2"
         LET l_sql ="SELECT SUM(pmn20-pmn50+pmn55+pmn58) FROM pmn_file,pmm_file",
                       " WHERE pmn01=pmm01 AND pmn04='", l_bmb01, "' AND pmm18<>'X'",
                       " AND pmmacti='Y' AND ", g_sql_5  #MOD-CC0078 add AND
         PREPARE r054_p02 FROM l_sql
         EXECUTE r054_p02 INTO l_img10
         IF l_img10 IS NULL THEN LET l_img10 = 0 END IF
         LET g_rep_data.wip_cp=l_img10
      WHEN "3"
         LET l_sql = "SELECT SUM(pmn20-pmn50+pmn55+pmn58) FROM pmn_file,pmm_file",
                        " WHERE pmn01=pmm01 AND pmn04='", l_bmb01, "' AND pmm18<>'X'",
                        " AND pmmacti='Y' AND ", g_sql_5  #MOD-CC0078 add AND
         PREPARE r054_p03 FROM l_sql
         EXECUTE r054_p03 INTO l_img10
         IF l_img10 IS NULL THEN LET l_img10 = 0 END IF

         LET l_sql = "SELECT SUM(sfb08-sfb09) FROM sfb_file ",
                        " WHERE sfb02='1' AND sfb05='", l_bmb01, "' AND sfb04<>'8'",
                        " AND sfbacti='Y' AND sfb87<>'X' AND ", g_sql_6  #MOD-CC0078 add AND
         PREPARE r054_p03_2 FROM l_sql
         EXECUTE r054_p03_2 INTO l_sfb09
         IF l_sfb09 IS NULL THEN LET l_sfb09 = 0 END IF
         LET g_rep_data.wip_as=l_img10+l_sfb09
      WHEN "4"
         LET l_sql = "SELECT SUM(pmn20-pmn50+pmn55+pmn58) FROM pmn_file,pmm_file",
                        " WHERE pmn01=pmm01 AND pmn04='", l_bmb01, "' AND pmm18<>'X'",
                        " AND pmmacti='Y' AND ", g_sql_5  #MOD-CC0078 add AND
         PREPARE r054_p04 FROM l_sql
         EXECUTE r054_p04 INTO l_img10
         IF l_img10 IS NULL THEN LET l_img10 = 0 END IF

         LET l_sql = "SELECT SUM(sfb08-sfb09) FROM sfb_file",
                        " WHERE sfb02='1' AND sfb05='", l_bmb01, "' AND sfb04<>'8'",
                        " AND sfbacti='Y' AND sfb87<>'X' AND ", g_sql_6  #MOD-CC0078 add AND
         PREPARE r054_p04_2 FROM l_sql
         EXECUTE r054_p04_2 INTO l_sfb09
         IF l_sfb09 IS NULL THEN LET l_sfb09 = 0 END IF
         LET g_rep_data.wip_ft=l_img10+l_sfb09
   END CASE
END FUNCTION

FUNCTION r054_soqty(l_bmb01,l_imaicd04)
   DEFINE l_bmb01    LIKE bmb_file.bmb01
   DEFINE l_imaicd04 LIKE imaicd_file.imaicd04
   DEFINE l_oeb12    LIKE oeb_file.oeb12
   DEFINE l_opd09    LIKE opd_file.opd09
   DEFINE l_sql STRING

   IF l_imaicd04 <>'4' THEN RETURN END IF

   #未交量=訂單量-已出貨+已銷退-被結案
   SELECT SUM(oeb12-oeb24+oeb25-oeb26) INTO l_oeb12 FROM oeb_file,oea_file
    Where oea01=oeb01 AND oeb04=l_bmb01 AND oeaconf='Y' AND oeb70='N'

   IF l_oeb12 IS NULL THEN LET l_oeb12=0 END IF

   LET g_rep_data.so_not = l_oeb12

   #Forecast數量
   Select Sum(opd09) INTO l_opd09 FROM opc_file,opd_file,ima_file
    WHERE opd01=opc01 AND opc11='Y' AND opc12='Y'
      AND (opc01=ima01 OR opc01=ima133) AND ima01=l_bmb01
      AND opd06 >= g_opd06
      AND opd07 <= g_opd07

   IF l_opd09 IS NULL THEN LET l_opd09=0 END IF
   LET g_rep_data.forecast=l_opd09
END FUNCTION

FUNCTION r054_goodqty(l_bmb01)
   DEFINE l_bmb01    LIKE bmb_file.bmb01
   DEFINE l_imaicd04 LIKE imaicd_file.imaicd04
   DEFINE l_wip LIKE img_file.img10
   DEFINE l_stk LIKE img_file.img10
   DEFINE l_i   LIKE type_file.num5

   #預計可用量＝Wafer P/O量 * Gross Die *良率＋
   #Wafer庫存量*Gross Die*CP良率*AS良率*FT良率＋
   #CP在製量*Gross Die*CP良率*AS良率*FT良率＋
   #CP庫存量*Gross Die*AS良率*FT良率＋
   #AS在製量*AS良率*FT良率＋
   #AS庫存量*FT良率＋
   #FT在製量*FT良率＋
   #FT庫存量

   FOR l_i = 1 TO 4
      LET l_wip = 0
      LET l_stk = 0
      CASE l_i
        WHEN 1
           LET l_wip=g_rep_data.wip_wafer * g_rep_data.gross_die
                     * g_rep_data.wafer_yield/100
                     * g_rep_data.cp_yield/100
                     * g_rep_data.as_yield/100
                     * g_rep_data.ft_yield/100
           LET l_stk=g_rep_data.stk_wafer * g_rep_data.gross_die
                     * g_rep_data.cp_yield/100
                     * g_rep_data.as_yield/100
                     * g_rep_data.ft_yield/100
        WHEN 2
           LET l_wip=g_rep_data.wip_cp * g_rep_data.gross_die
                     * g_rep_data.cp_yield/100
                     * g_rep_data.as_yield/100
                     * g_rep_data.ft_yield/100
           LET l_stk=g_rep_data.stk_cp * g_rep_data.gross_die
                     * g_rep_data.as_yield/100
                     * g_rep_data.ft_yield/100
        WHEN 3
           LET l_wip=g_rep_data.wip_as
                     * g_rep_data.as_yield/100
                     * g_rep_data.ft_yield/100
           LET l_stk=g_rep_data.stk_as
                     * g_rep_data.ft_yield/100
        WHEN 4
           LET l_wip=g_rep_data.wip_ft
                     * g_rep_data.ft_yield/100
           LET l_stk=g_rep_data.stk_ft
        OTHERWISE RETURN
      END CASE
   END FOR
   LET g_rep_data.goodqty=g_rep_data.goodqty+l_wip+l_stk
END FUNCTION

FUNCTION r054_up_loop(p_imaicd00,p_imaicd04)
   DEFINE p_imaicd00 LIKE imaicd_file.imaicd00
   DEFINE p_imaicd04 LIKE imaicd_file.imaicd04
   DEFINE l_bmb01    LIKE bmb_file.bmb01
   DEFINE l_imaicd04 LIKE imaicd_file.imaicd04
   DEFINE l_imaicd08 LIKE imaicd_file.imaicd08
   DEFINE l_imaicd14 LIKE imaicd_file.imaicd14
   DEFINE l_imaicd15 LIKE imaicd_file.imaicd15
   DEFINE l_ima02    LIKE ima_file.ima02
   DEFINE l_where STRING
   DEFINE l_i LIKE type_file.num5
   DEFINE la_bmb DYNAMIC ARRAY OF RECORD
             bmb01      LIKE bmb_file.bmb01,
             imaicd04   LIKE imaicd_file.imaicd04,
             imaicd08   LIKE imaicd_file.imaicd08,
             imaicd14   LIKE imaicd_file.imaicd14,
             imaicd15   LIKE imaicd_file.imaicd15,
             ima02      LIKE ima_file.ima02
   END RECORD
   CASE p_imaicd04
      WHEN '1'  LET l_where=g_sql_2
      WHEN '2'  LET l_where=g_sql_3
      WHEN '3'  LET l_where=g_sql_4
      OTHERWISE LET l_where=''
   END CASE
   LET l_imaicd14 = 0
   LET l_imaicd15 = 0

   LET g_sql = "SELECT bmb01,imaicd04,imaicd08,imaicd14,imaicd15,ima02",
               "  FROM bmb_file LEFT OUTER JOIN imaicd_file ON (imaicd00 = bmb01)",
               "  LEFT OUTER JOIN ima_file ON (ima01 = bmb01)",
               " WHERE bmb03 = '", p_imaicd00, "' AND ", l_where
   PREPARE r054_p6 FROM g_sql
   DECLARE r054_c2 CURSOR FOR r054_p6
   LET l_i = 1
   FOREACH r054_c2 INTO l_bmb01,l_imaicd04,l_imaicd08,l_imaicd14,l_imaicd15,l_ima02
      IF l_imaicd04 NOT MATCHES '[1234]' THEN CONTINUE FOREACH END IF
      IF l_imaicd14 IS NULL THEN LET l_imaicd14 = 0 END IF
      IF l_imaicd15 IS NULL THEN LET l_imaicd15 = 0 END IF
      LET l_i = la_bmb.getlength() + 1
      LET la_bmb[l_i].bmb01    = l_bmb01
      LET la_bmb[l_i].imaicd04 = l_imaicd04
      LET la_bmb[l_i].imaicd08 = l_imaicd08
      LET la_bmb[l_i].imaicd14 = l_imaicd14
      LET la_bmb[l_i].imaicd15 = l_imaicd15
      LET la_bmb[l_i].ima02    = l_ima02
      LET l_i = l_i + 1
   END FOREACH

   CALL la_bmb.deleteElement(l_i)

   FOR l_i = 1 TO la_bmb.getlength()
      CASE la_bmb[l_i].imaicd04
         WHEN '1' LET g_rep_data.id_wafer     = la_bmb[l_i].bmb01
                  LET g_rep_data.wafer_desc   = la_bmb[l_i].ima02
                  LET g_rep_data.wafer_yield  = la_bmb[l_i].imaicd15
                  IF la_bmb[l_i].imaicd14 > 0 THEN
                     LET g_rep_data.gross_die = la_bmb[l_i].imaicd14
                  END IF
         WHEN '2' LET g_rep_data.id_cp        = la_bmb[l_i].bmb01
                  LET g_rep_data.cp_desc      = la_bmb[l_i].ima02
                  LET g_rep_data.cp_yield     = la_bmb[l_i].imaicd15
                  IF la_bmb[l_i].imaicd14 > 0 THEN
                     LET g_rep_data.gross_die = la_bmb[l_i].imaicd14
                  END IF
         WHEN '3' LET g_rep_data.id_as        = la_bmb[l_i].bmb01
                  LET g_rep_data.as_desc      = la_bmb[l_i].ima02
                  LET g_rep_data.as_yield     = la_bmb[l_i].imaicd15
         WHEN '4' LET g_rep_data.id_ft        = la_bmb[l_i].bmb01
                  LET g_rep_data.ft_desc      = la_bmb[l_i].ima02
                  LET g_rep_data.ft_yield     = la_bmb[l_i].imaicd15
                  CALL r054_soqty(la_bmb[l_i].bmb01,la_bmb[l_i].imaicd04)
      END CASE
      CALL r054_stk(la_bmb[l_i].bmb01,la_bmb[l_i].imaicd04)
      CALL r054_wip(la_bmb[l_i].bmb01,la_bmb[l_i].imaicd04)
      CALL r054_up_loop(la_bmb[l_i].bmb01,la_bmb[l_i].imaicd04)
   END FOR
END FUNCTION

FUNCTION r054_ins_temp()
   EXECUTE insert_prep USING g_rep_data.id_wafer,g_rep_data.wafer_desc,
                             g_rep_data.id_cp,g_rep_data.cp_desc,
                             g_rep_data.id_as,g_rep_data.as_desc,
                             g_rep_data.id_ft,g_rep_data.ft_desc,
                             g_rep_data.wip_wafer,g_rep_data.wip_cp,
                             g_rep_data.wip_as,g_rep_data.wip_ft,
                             g_rep_data.stk_wafer,g_rep_data.stk_cp,
                             g_rep_data.stk_as,g_rep_data.stk_ft,
                             g_rep_data.bin_02,g_rep_data.bin_03,
                             g_rep_data.bin_04,g_rep_data.bin_05,
                             g_rep_data.bin_06,g_rep_data.bin_07,
                             g_rep_data.bin_08,g_rep_data.bin_09,
                             g_rep_data.bin_xx,g_rep_data.wafer_yield,
                             g_rep_data.cp_yield,g_rep_data.as_yield,
                             g_rep_data.ft_yield,g_rep_data.so_not,
                             g_rep_data.forecast,g_rep_data.goodqty,
                             g_rep_data.gross_die
END FUNCTION
