# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: cfaq100.4gl
# Descriptions...: 固资财务帐跟踪查询
# Date & Author..: 22/04/02  add by darcy

DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
#模組變數(Module Variables)
   TYPE type_faj_file RECORD 
               pmm04_o    LIKE pmm_file.pmm04,
               pmc03_o    LIKE pmc_file.pmc03,
               pmm01_o    LIKE pmm_file.pmm01,
               pmn02_o    LIKE pmn_file.pmn02,
               faj02_o    LIKE faj_file.faj02,
               faj26_o    LIKE faj_file.faj26,
               rvu01_o    LIKE rvu_file.rvu01,
               rvv02_o    LIKE rvv_file.rvv02,
               apa01_o    LIKE apa_file.apa01,
               pmm01      LIKE pmm_file.pmm01,
               pmm04      LIKE pmm_file.pmm04,
               pmm09      LIKE pmm_file.pmm09,
               pmc03      LIKE pmc_file.pmc03,
               pmn02      LIKE pmn_file.pmn02,
               pmn04      LIKE pmn_file.pmn04,
               ima02      LIKE ima_file.ima02,
               ima021     LIKE ima_file.ima021,
               pmn20      LIKE pmn_file.pmn20,               #TAG:入库
               rvu00      LIKE rvu_file.rvu00,
               rvu01      LIKE rvu_file.rvu01,
               rvu03      LIKE rvu_file.rvu03,
               rvv02      LIKE rvv_file.rvv02,
               rvv17      LIKE rvv_file.rvv17,
               rvv38      LIKE rvv_file.rvv38,
               rvv39      LIKE rvv_file.rvv39,               #TAG:入库               #TAG:固资
               faj02      LIKE faj_file.faj02,
               faj06      LIKE faj_file.faj06,
               faj04      LIKE faj_file.faj04,
               faj43      LIKE faj_file.faj43,
               faj26      LIKE faj_file.faj26,
               faj20      LIKE faj_file.faj20,
               faj52      LIKE faj_file.faj52,
               faj14      LIKE faj_file.faj14,               #TAG:固资               #TAG:预付
               apa01      LIKE apa_file.apa01,
               apa02      LIKE apa_file.apa02,
               apa31      LIKE apa_file.apa31,
               apa44      LIKE apa_file.apa44,               #TAG:预付               #TAG:请款
               apa01_1    LIKE apa_file.apa01,
               apa02_1    LIKE apa_file.apa02,
               apa08_1    LIKE apa_file.apa08,
               apa31_1    LIKE apa_file.apa31,
               apa32_1    LIKE apa_file.apa32,
               apa44_1    LIKE apa_file.apa44,
               apb02_1    LIKE apb_file.apb02,
               apb10_1    LIKE apb_file.apb10,               #TAG:请款               #TAG:付款
               apf01      LIKE apf_file.apf01,
               apf02      LIKE apf_file.apf02,
               apf44      LIKE apf_file.apf44,
               apg05      LIKE apg_file.apg05,               #TAG:付款               #TAG:暂估
               apa01_2    LIKE apa_file.apa01,
               apa02_2    LIKE apa_file.apa02,
               apa44_2    LIKE apa_file.apa44,
               apb10_2    LIKE apb_file.apb10               #TAG:暂估
   END RECORD
DEFINE g_tc_faj DYNAMIC ARRAY OF  type_faj_file
DEFINE g_tc_faj_excel DYNAMIC ARRAY OF  type_faj_file
DEFINE   l_table         STRING                  #No.FUN-770033
DEFINE 
     tm  RECORD
                wc     LIKE type_file.chr1000,  # Head Where condition   #No.FUN-680098  VARCHAR(600)
                wc2    LIKE type_file.chr1000   # Body Where condition   #No.FUN-680098  VARCHAR(600)
        END RECORD,
    g_unpay         LIKE abg_file.abg071,
    g_tc_faj09tot      LIKE abh_file.abh09,
    g_argv1         LIKE abg_file.abg01,
    g_argv2         LIKE abg_file.abg02,
    g_query_flag    LIKE type_file.num5,   #第一次進入程式時即進入Query之後進入next  #No.FUN-680098 smallint
    g_wc,g_wc2,g_sql,g_cmd string, #WHERE CONDITION  #No.FUN-580092 HCN
    g_rec_b  LIKE type_file.num10        #單身筆數    #No.FUN-680098   integer       
 
 
DEFINE   g_cnt           LIKE type_file.num10    #No.FUN-680098  integer
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose    #No.FUN-680098 smallint
DEFINE   g_msg           LIKE ze_file.ze03       #No.FUN-680098   VARCHAR(72)
 
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680098  integer
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680098  integer
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680098  integer
DEFINE   mi_no_ask      LIKE type_file.num5         #No.FUN-680098  smallint
MAIN
#     DEFINE   l_time LIKE type_file.chr8            #No.FUN-6A0073
     DEFINE     l_sl          LIKE type_file.num5          #No.FUN-680098  smallint
   DEFINE p_row,p_col   LIKE type_file.num5          #No.FUN-680098  smallint
 
   OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                         #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("CFA")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
 
 
     LET g_argv1      = ARG_VAL(2)     #No.MOD-4C0171          #參數值(1) Part#傳票編號
     LET g_argv2      = ARG_VAL(3)     #No.MOD-4C0171          #參數值(2) Part#傳票項次
    LET g_query_flag =1
    LET p_row = 3 LET p_col = 2
    OPEN WINDOW q100_w AT p_row,p_col
         WITH FORM "cfa/42f/cfaq100"  
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
    CALL q100_show_field()  # FUN-5C0015 add
    LET g_sql= "pmm04_o.pmm_file.pmm04,",
               "pmc03_o.pmc_file.pmc03,",
               "pmm01_o.pmm_file.pmm01,",
               "pmn02_o.pmn_file.pmn02,",
               "faj02_o.faj_file.faj02,",
               "faj26_o.faj_file.faj26,",
               "rvu01_o.rvu_file.rvu01,",
               "rvv02_o.rvv_file.rvv02,",
               "apa01_o.apa_file.apa01,",
               "pmm01.pmm_file.pmm01,",
               "pmm04.pmm_file.pmm04,",
               "pmm09.pmm_file.pmm09,",
               "pmc03.pmc_file.pmc03,",
               "pmn02.pmn_file.pmn02,",
               "pmn04.pmn_file.pmn04,",
               "ima02.ima_file.ima02,",
               "ima021.ima_file.ima021,",
               "pmn20.pmn_file.pmn20,",
               "rvu00.rvu_file.rvu00,",
               "rvu01.rvu_file.rvu01,",
               "rvu03.rvu_file.rvu03,",
               "rvv02.rvv_file.rvv02,",
               "rvv17.rvv_file.rvv17,",
               "rvv38.rvv_file.rvv38,",
               "rvv39.rvv_file.rvv39,",
               "faj02.faj_file.faj02,",
               "faj06.faj_file.faj06,",
               "faj04.faj_file.faj04,",
               "faj43.faj_file.faj43,",
               "faj26.faj_file.faj26,",
               "faj20.faj_file.faj20,",
               "faj52.faj_file.faj52,",
               "faj14.faj_file.faj14,",
               "apa01.apa_file.apa01,",
               "apa02.apa_file.apa02,",
               "apa31.apa_file.apa31,",
               "apa44.apa_file.apa44,",
               "apa01_1.apa_file.apa01,",
               "apa02_1.apa_file.apa02,",
               "apa08_1.apa_file.apa08,",
               "apa31_1.apa_file.apa31,",
               "apa32_1.apa_file.apa32,",
               "apa44_1.apa_file.apa44,",
               "apb02_1.apb_file.apb02,",
               "apb10_1.apb_file.apb10,",
               "apf01.apf_file.apf01,",
               "apf02.apf_file.apf02,",
               "apf44.apf_file.apf44,",
               "apg05.apg_file.apg05,",
               "apa01_2.apa_file.apa01,",
               "apa02_2.apa_file.apa02,",
               "apa44_2.apa_file.apa44,",
               "apb10_2.apb_file.apb10"                                                                                  
                                                                                                                                    
     LET l_table = cl_prt_temptable('cfar100',g_sql) CLIPPED                                                                        
     IF l_table= -1 THEN EXIT PROGRAM END IF                                                                                        
     LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                            
               " VALUES(?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?,",
               "        ?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?,",
               "        ?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?, ?,?,?,?,? ,?,?,?)"                                                                                     
    PREPARE insert_prep FROM g_sql 

 
    IF NOT cl_null(g_argv1) THEN CALL q100_q() END IF
    CALL q100_menu()
    CLOSE WINDOW q100_w
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
#QBE 查詢資料
FUNCTION q100_cs()
   DEFINE   l_cnt LIKE type_file.num5           #No.FUN-680098  smallint 

   CONSTRUCT tm.wc ON pmn01,pmm09,faj02,faj26,faj20,pmm04,pmn04,faj04,faj43
    FROM pmn01_h,pmm09_h,faj02_h,faj26_h,faj20_h,pmm04_h,pmn04_h,faj04_h,faj43_h


         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON ACTION locale
          #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
#No.TQC-780067--begin
      ON ACTION controlp
         CASE
           WHEN INFIELD(pmn01_h) 
              CALL cl_init_qry_var()
              LET g_qryparam.state ='c' 
              LET g_qryparam.form ='q_pmm01_1'
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO pmn01_h
              NEXT FIELD pmn01_h
            #pmn01,pmm09,faj02,pmm04,faj20 

            WHEN INFIELD(faj02_h) 
              CALL cl_init_qry_var()
              LET g_qryparam.state ='c' 
              LET g_qryparam.form ='q_faj02_1'
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO faj02_h
              NEXT FIELD faj02_h
            
            WHEN INFIELD(faj20_h) 
              CALL cl_init_qry_var()
              LET g_qryparam.state ='c' 
              LET g_qryparam.form ='q_faj20'
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO faj20_h
              NEXT FIELD faj20_h

            WHEN INFIELD(pmn04_h) 
              CALL cl_init_qry_var()
              LET g_qryparam.state ='c' 
              LET g_qryparam.form ='q_ima'
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO pmn04_h
              NEXT FIELD pmn04_h

            WHEN INFIELD(pmn09_h) 
              CALL cl_init_qry_var()
              LET g_qryparam.state ='c' 
              LET g_qryparam.form ='q_pmc01_1'
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO pmn09_h
              NEXT FIELD pmn09_h

           OTHERWISE EXIT CASE
          END CASE  

         CONTINUE CONSTRUCT

         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
   
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
   
         ON ACTION controlg      #MOD-4C0121
            CALL cl_cmdask()     #MOD-4C0121
   
   
            ON ACTION exit
            LET INT_FLAG = 1
            EXIT CONSTRUCT
            #No.FUN-580031 --start--
            ON ACTION qbe_select
               CALL cl_qbe_select()
            #No.FUN-580031 ---end---
         ON ACTION cancel
            EXIT PROGRAM
 
      END CONSTRUCT

   IF g_action_choice = "locale" THEN
      LET g_action_choice = ""
      CALL cl_dynamic_locale() 
   END IF

   IF INT_FLAG THEN RETURN END IF

   MESSAGE ' WAIT ' 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW cfar100_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN
      CALL cl_err('','9046',0) 
   END IF

   CALL q100_cursor() 

END FUNCTION 

FUNCTION q100_cursor()
   DEFINE l_sql      STRING 

   #NOTE:固资编号
   LET l_sql = "SELECT faj02,faj06,faj04,faj43,faj26,faj20,faj52,faj14 
                  FROM faj_file WHERE faj47 = ? AND faj471=? AND fajconf ='Y' "
   PREPARE r100_i100 FROM l_sql 
   DECLARE r100_i100_d CURSOR FOR r100_i100
   #NOTE:预付
   LET l_sql = "SELECT UNIQUE apa01,apa02,apa31,apa44 FROM apa_file,apb_file
               WHERE apa01 = apb01 AND apa41='Y'  AND apa00='15'
               AND apb06 = ? ORDER BY apa02,apa01 "
   PREPARE r100_t150 FROM l_sql 
   DECLARE r100_t150_d CURSOR FOR r100_t150
   #NOTE:入库单
   LET l_sql ="SELECT rvu00,rvu01,rvu03,rvv02,
               CASE rvu00 WHEN '1' THEN rvv17 ELSE -1*rvv17 END rvv17,
               CASE rvu00 WHEN '1' THEN rvv38 ELSE -1*rvv38 END rvv38,
               CASE rvu00 WHEN '1' THEN rvv39 ELSE -1*rvv39 END rvv39  FROM rvv_file,rvu_file                
               WHERE rvu01 =rvv01 AND rvuconf ='Y'
               AND rvv36 = ? AND rvv37 = ? ORDER BY rvu00，rvu01"
   PREPARE r100_t720 FROM l_sql
   DECLARE r100_t720_d CURSOR FOR r100_t720 
   #NOTE:暂估单
   LET l_sql = "SELECT apa01,apa02,apa44,apb10 FROM apa_file,apb_file
                WHERE apa01=apb01 AND apa41 ='Y' AND apa00='16'
                AND apb21 = ? AND apb22= ? ORDER BY apa02,apa01"
   PREPARE r100_t160 FROM l_sql
   DECLARE r100_t160_d CURSOR FOR r100_t160
   #NOTE:请款单
   LET l_sql = "SELECT apa01,apa02,apa08,apa31,apa32,apa44,apb02,apb10 FROM apa_file,apb_file
                WHERE apa01=apb01 AND apa41 ='Y' AND apa00='11'
                AND apb21 = ? AND apb22= ? ORDER BY apa02,apa01"
   PREPARE r100_t110 FROM l_sql
   DECLARE r100_t110_d CURSOR FOR r100_t110
   #NOTE:付款单
   LET l_sql = "SELECT apf01,apf02,apf44,apg05 FROM apg_file,apf_file
                WHERE apg01 = apf01 AND apf41 ='Y' 
                AND apg04 = ? ORDER BY apf02,apf01"
   PREPARE r100_t330 FROM l_sql 
   DECLARE r100_t330_d CURSOR FOR r100_t330

END FUNCTION
 
 
FUNCTION q100_menu()
 
   WHILE TRUE
      CALL q100_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL q100_q()
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"   #No.FUN-4B0010
            IF cl_chk_act_auth() THEN
             #CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_abg),'','')  #MOD-BA0092 mark
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_tc_faj),'','')  #MOD-BA0092 add
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q100_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
   #DISPLAY '   ' TO FORMONLY.cnt  
    CALL q100_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL q100_b_fill()
    MESSAGE ''
END FUNCTION 

FUNCTION q100_b_fill()              #BODY FILL UP
   DEFINE l_sql      LIKE type_file.chr1000,  #No.FUN-680098 VARCHAR(1000)
          g_gen02         LIKE gen_file.gen02,
          g_abaconf       LIKE aba_file.aba19,
          g_abauser       LIKE aba_file.abauser 
   
   CALL q100_get_data()
  
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " ORDER BY pmm04_o,pmc03_o,pmm01_o,pmn02_o,rvu01_o,rvv02_o,apa01_o,faj02_o,faj26_o"
 
    PREPARE q100_pb FROM l_sql
    DECLARE q100_bcs                       #BODY CURSOR
        CURSOR WITH HOLD FOR q100_pb
   
    CALL g_tc_faj.clear()  
    LET g_cnt = 1
    FOREACH q100_bcs INTO g_tc_faj[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('Foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF 
      LET g_cnt = g_cnt + 1
      IF g_cnt <= 15000  THEN 
	      # EXIT FOREACH
      END IF 
    END FOREACH
   #  IF g_cnt > g_max_rec THEN
   #    CALL cl_err("","cfa-001",1)
   #    LET g_rec_b=g_max_rec
   #  ELSE 
   LET g_rec_b=g_cnt-1
   #  END IF 
    DISPLAY g_rec_b TO FORMONLY.cn2 
 
END FUNCTION
 
FUNCTION q100_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_tc_faj TO s_tc_faj.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
     #BEFORE ROW
         #LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         #LET l_sl = SCR_LINE()
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY 
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY 
 
   ON ACTION accept
     #LET l_ac = ARR_CURR()
      EXIT DISPLAY
 
   ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
      LET g_action_choice="exit"
      EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
   
      ON ACTION exporttoexcel   #No.FUN-4B0010
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
  
FUNCTION  q100_show_field() 
END FUNCTION 
 
FUNCTION q100_get_data()
   DEFINE l_name    LIKE type_file.chr20,
          l_sql     LIKE type_file.chr1000,
          l_chr     LIKE type_file.chr1,
          l_za05    LIKE type_file.chr1000,
          l_order   ARRAY[5] OF LIKE fak_file.fak53,
          sr        RECORD
                  pmm01      LIKE pmm_file.pmm01,
                  pmm04      LIKE pmm_file.pmm04,
                  pmm09      LIKE pmm_file.pmm09,
                  pmc03      LIKE pmc_file.pmc03,
                  pmn02      LIKE pmn_file.pmn02,
                  pmn04      LIKE pmn_file.pmn04,
                  ima02      LIKE ima_file.ima02,
                  ima021     LIKE ima_file.ima021,
                  pmn20      LIKE pmn_file.pmn20
               END RECORD,
          l_faj     DYNAMIC ARRAY OF type_faj_file,
          l_t160_t  RECORD
                  apa01_2    LIKE apa_file.apa01,
                  apa02_2    LIKE apa_file.apa02,
                  apa44_2    LIKE apa_file.apa44,
                  apb10_2    LIKE apb_file.apb10
                  END RECORD,
          l_t720_t   RECORD
                  rvu00      LIKE rvu_file.rvu00,
                  rvu01      LIKE rvu_file.rvu01,
                  rvu03      LIKE rvu_file.rvu03,
                  rvv02      LIKE rvv_file.rvv02,
                  rvv17      LIKE rvv_file.rvv17,
                  rvv38      LIKE rvv_file.rvv38,
                  rvv39      LIKE rvv_file.rvv39
                  END RECORD,
          l_t110_t RECORD
                  apa01_1    LIKE apa_file.apa01,
                  apa02_1    LIKE apa_file.apa02,
                  apa08_1    LIKE apa_file.apa08,
                  apa31_1    LIKE apa_file.apa31,
                  apa32_1    LIKE apa_file.apa32,
                  apa44_1    LIKE apa_file.apa44,
                  apb02_1    LIKE apb_file.apb02,
                  apb10_1    LIKE apb_file.apb10
                  END RECORD,
          l_t330_t RECORD
                  apf01      LIKE apf_file.apf01,
                  apf02      LIKE apf_file.apf02,
                  apf44      LIKE apf_file.apf44,
                  apg05      LIKE apg_file.apg05
                  END RECORD
   DEFINE l_gen02  LIKE gen_file.gen02
   DEFINE l_pmc03  LIKE pmc_file.pmc03
   DEFINE l_cnt    LIKE type_file.num5  #一笔采购单的遍历下标
   DEFINE i,j,k,l,m,n    LIKE type_file.num5
   DEFINE l_i100,l_t150,l_t720,l_t160,l_t160_i,l_t110,l_t110_i,l_t330,l_t330_i LIKE type_file.num5
   DEFINE l_t160_s DYNAMIC ARRAY OF INTEGER #保存暂估单项次 
 
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog     
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   CALL cl_del_data(l_table) 

   CALL q100_cursor()         

   LET g_sql = "DELETE FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                          
   PREPARE q100_dele FROM g_sql
   EXECUTE q100_dele
   
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('fakuser', 'fakgrup')
   #TODO:采购明细
   LET l_sql = "SELECT pmm01,pmm04,pmm09,pmc03,pmn02,pmn04,ima02,ima021,pmn20
                  FROM pmn_file,pmm_file ,faj_file ,pmc_file,ima_file
                 WHERE pmm01 = pmn01 AND pmm18 ='Y' and pmc01 = pmm09  AND ima01 = pmn04
                   AND faj47 = pmn01 AND faj471=pmn02 AND ",tm.wc 
   PREPARE cfar100_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
      EXIT PROGRAM
   END IF
   DECLARE cfar100_curs1 CURSOR FOR cfar100_prepare1
 
   FOREACH cfar100_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      #TAG: 固资编号前处理
      CALL l_faj.clear()
      LET l_i100 = 0
      LET l_t150 = 0
      LET l_t720 = 0
      LET l_t160 = 0
      LET l_t110 = 0
      LET l_t330 = 0
      LET l_cnt = 1
      #DONE:固资编号
      FOREACH r100_i100_d USING  sr.pmm01,sr.pmn02
        INTO l_faj[l_cnt].faj02,l_faj[l_cnt].faj06,l_faj[l_cnt].faj04,l_faj[l_cnt].faj43,l_faj[l_cnt].faj26,l_faj[l_cnt].faj20,l_faj[l_cnt].faj52,l_faj[l_cnt].faj14
         IF STATUS THEN 
            CALL cl_err("r100_i100_d","!",1)
            RETURN
         END IF 

         #TAG: 排序字段都有值
         LET l_faj[l_cnt].pmm04_o = sr.pmm04
         LET l_faj[l_cnt].pmc03_o = sr.pmc03
         LET l_faj[l_cnt].pmm01_o = sr.pmm01
         LET l_faj[l_cnt].pmn02_o = sr.pmn02
         LET l_faj[l_cnt].faj02_o = l_faj[l_cnt].faj02
         LET l_faj[l_cnt].faj26_o = l_faj[l_cnt].faj26
         #TAG:只有第一笔,不可能没有
         IF l_cnt = 1 THEN 
            LET l_faj[l_cnt].pmm01 = sr.pmm01
            LET l_faj[l_cnt].pmm04 = sr.pmm04
            LET l_faj[l_cnt].pmm09 = sr.pmm09
            LET l_faj[l_cnt].pmc03 = sr.pmc03
            LET l_faj[l_cnt].pmn02 = sr.pmn02
            LET l_faj[l_cnt].pmn04 = sr.pmn04
            LET l_faj[l_cnt].ima02 = sr.ima02
            LET l_faj[l_cnt].ima021 =sr.ima021
            LET l_faj[l_cnt].pmn20 = sr.pmn20
         END IF 
         LET l_cnt = l_cnt + 1
      END FOREACH
      CALL l_faj.deleteElement(l_cnt)
      LET l_i100 = l_cnt - 1 #固定资产笔数
      LET l_cnt = 1
      #DONE:预付
      FOREACH r100_t150_d USING sr.pmm01 INTO l_faj[l_cnt].apa01,l_faj[l_cnt].apa02,l_faj[l_cnt].apa31,l_faj[l_cnt].apa44
         IF STATUS THEN
            CALL cl_err("r100_t150_d","!",1)
            RETURN
         END IF
         IF l_cnt > l_i100 THEN 
            #超过最大长度,需要给采购信息，不关联固资和采购项次
            LET l_faj[l_cnt].pmm04_o = sr.pmm04
            LET l_faj[l_cnt].pmc03_o = sr.pmc03
            LET l_faj[l_cnt].pmm01_o = sr.pmm01
            LET l_faj[l_cnt].pmn02_o = sr.pmn02
         END IF 
         LET l_cnt = l_cnt + 1
      END FOREACH
      CALL l_faj.deleteElement(l_cnt)
      LET l_t150 = l_cnt -1
      # IF l_t150 > l_i100 THEN
      #    CALL l_faj.deleteElement(l_cnt)
      # END IF
      LET l_cnt = 1
      
      #DONE:入库单
      LET l_t720 = 0
      LET i = 0
      LET j = 1 
      LET l_t110 = 0
      LET l_t330 = 0 
      FOREACH r100_t720_d USING sr.pmm01,sr.pmn02
         INTO l_t720_t.*
         IF STATUS THEN
            CALL cl_err("r100_t720_d","!",1)
            RETURN 
         END IF   
         LET l_t720 = l_t720 + 1    
         # FIXME: 判断方式错误
         # FIXME: 增加若笔数已经等于入库单笔数也要新增
         IF l_t720 <= IIF(l_i100>l_t150,l_i100,l_t150) 
         AND ( l_t720 <= l_faj.getLength() ) THEN 
         #不需要新增
            LET i = i + 1
            LET l_faj[i].rvu01_o = l_t720_t.rvu01
            LET l_faj[i].rvv02_o = l_t720_t.rvv02

            LET l_faj[i].rvu00 = l_t720_t.rvu00
            LET l_faj[i].rvu01 = l_t720_t.rvu01
            LET l_faj[i].rvu03 = l_t720_t.rvu03
            LET l_faj[i].rvv02 = l_t720_t.rvv02
            LET l_faj[i].rvv17 = l_t720_t.rvv17
            LET l_faj[i].rvv38 = l_t720_t.rvv38
            LET l_faj[i].rvv39 = l_t720_t.rvv39
            LET k = i
         ELSE 
         #需要新增一行 
            LET j = l_faj.getLength() + 1
            
            # FIXME: 固资资料需要写入
            LET l_faj[j].faj02_o = "ZMISC"
            LET l_faj[j].faj26_o = g_today
            # FIXME: 采购料需要写入
            LET l_faj[j].pmm04_o = sr.pmm04
            LET l_faj[j].pmc03_o = sr.pmc03
            LET l_faj[j].pmm01_o = sr.pmm01
            LET l_faj[j].pmn02_o = sr.pmn02
            LET l_faj[j].pmm01 = sr.pmm01
            LET l_faj[j].pmm04 = sr.pmm04
            LET l_faj[j].pmm09 = sr.pmm09
            LET l_faj[j].pmc03 = sr.pmc03
            LET l_faj[j].pmn02 = sr.pmn02
            LET l_faj[j].pmn04 = sr.pmn04
            LET l_faj[j].ima02 = sr.ima02
            LET l_faj[j].ima021 =sr.ima021
            LET l_faj[j].pmn20 = sr.pmn20
 
            LET l_faj[j].rvu01_o = l_t720_t.rvu01
            LET l_faj[j].rvv02_o = l_t720_t.rvv02
            
            LET l_faj[j].rvu00 = l_t720_t.rvu00
            LET l_faj[j].rvu01 = l_t720_t.rvu01
            LET l_faj[j].rvu03 = l_t720_t.rvu03
            LET l_faj[j].rvv02 = l_t720_t.rvv02
            LET l_faj[j].rvv17 = l_t720_t.rvv17
            LET l_faj[j].rvv38 = l_t720_t.rvv38
            LET l_faj[j].rvv39 = l_t720_t.rvv39

            LET k = j
         END IF 
         #DONE:暂估单 
         LET l_t160 = 0
         LET l_t160_i = 0
         CALL l_t160_s.clear()
         FOREACH r100_t160_d USING l_t720_t.rvu01,l_t720_t.rvv02 #darcy:2022/04/02 传值错误
            INTO l_t160_t.*
            IF STATUS THEN 
               CALL cl_err("r100_t160_d","!",1)
            END IF
            LET l_t160 = l_t160 + 1
            LET l_t160_i = l_t160_i + 1
            
            IF l_t160_i > 1 THEN 
               #新增空行
               LET j = l_faj.getLength() + 1

               LET l_faj[j].pmm04_o = sr.pmm04
               LET l_faj[j].pmc03_o = sr.pmc03
               LET l_faj[j].pmm01_o = sr.pmm01
               LET l_faj[j].pmn02_o = sr.pmn02
               LET l_faj[j].rvu01_o = l_t720_t.rvu01
               LET l_faj[j].rvv02_o = l_t720_t.rvv02

               LET l_faj[j].apa01_2 = l_t160_t.apa01_2
               LET l_faj[j].apa02_2 = l_t160_t.apa02_2
               LET l_faj[j].apa44_2 = l_t160_t.apa44_2
               LET l_faj[j].apb10_2 = l_t160_t.apb10_2
               LET l_t160_s[l_t160_i] = j

            ELSE 
               #入库单当前行
               LET l_faj[k].apa01_2 = l_t160_t.apa01_2
               LET l_faj[k].apa02_2 = l_t160_t.apa02_2
               LET l_faj[k].apa44_2 = l_t160_t.apa44_2
               LET l_faj[k].apb10_2 = l_t160_t.apb10_2
               LET l_t160_s[l_t160_i] = k
            END IF 
         END FOREACH
         #DONE:请款单
         LET l_t110_i = 1
         LET l = 1 
         FOREACH r100_t110_d USING l_t720_t.rvu01,l_t720_t.rvv02
            INTO l_t110_t.*
            IF STATUS THEN 
               CALL cl_err("r100_t110_d","!",1)
            END IF
            LET l_t110 = l_t110 + 1 
            LET m = IIF(l_t160>1,l_t160,1)
            IF l_t110_i > IIF(l_t160>1,l_t160,1)  THEN 
               #大于暂估单，或者大于1笔，需要另起一行
               LET j = l_faj.getLength() + 1
               
               LET l_faj[j].pmm04_o = sr.pmm04
               LET l_faj[j].pmc03_o = sr.pmc03
               LET l_faj[j].pmm01_o = sr.pmm01
               LET l_faj[j].pmn02_o = sr.pmn02
               LET l_faj[j].rvu01_o = l_t720_t.rvu01
               LET l_faj[j].rvv02_o = l_t720_t.rvv02
               LET l_faj[j].apa01_o = l_t110_t.apa01_1

               LET l_faj[j].apa01_1 = l_t110_t.apa01_1
               LET l_faj[j].apa02_1 = l_t110_t.apa02_1
               LET l_faj[j].apa08_1 = l_t110_t.apa08_1
               LET l_faj[j].apa31_1 = l_t110_t.apa31_1
               LET l_faj[j].apa32_1 = l_t110_t.apa32_1
               LET l_faj[j].apa44_1 = l_t110_t.apa44_1
               LET l_faj[j].apb02_1 = l_t110_t.apb02_1
               LET l_faj[j].apb10_1 = l_t110_t.apb10_1

               LET m = j
            ELSE 
               #FIXME: 要考虑没有暂估单情况
               IF l_t160 > 0 THEN 
                  LET m = l_t160_s[m]
                  #在暂估单后面赋值 
               ELSE 
                  LET m = k
               END IF
               LET l_faj[m].apa01_o = l_t110_t.apa01_1
               LET l_faj[m].apa01_1 = l_t110_t.apa01_1
               LET l_faj[m].apa02_1 = l_t110_t.apa02_1
               LET l_faj[m].apa08_1 = l_t110_t.apa08_1
               LET l_faj[m].apa31_1 = l_t110_t.apa31_1
               LET l_faj[m].apa32_1 = l_t110_t.apa32_1
               LET l_faj[m].apa44_1 = l_t110_t.apa44_1
               LET l_faj[m].apb02_1 = l_t110_t.apb02_1
               LET l_faj[m].apb10_1 = l_t110_t.apb10_1 
            END IF 

            #DONE:付款单
            LET l_t330_i = 0
            FOREACH r100_t330_d USING l_t110_t.apa01_1
               INTO l_t330_t.*
               IF STATUS THEN 
                  CALL cl_err("r100_t330_d","!",1)
                  RETURN
               END IF
               LET l_t330 = l_t330 + 1
               LET l_t330_i = l_t330_i +1

               IF l_t330_i > 1 THEN 
                  #另起一行
                  LET j = l_faj.getLength() + 1

                  LET l_faj[j].pmm04_o = sr.pmm04
                  LET l_faj[j].pmc03_o = sr.pmc03
                  LET l_faj[j].pmm01_o = sr.pmm01
                  LET l_faj[j].pmn02_o = sr.pmn02
                  LET l_faj[j].rvu01_o = l_t720_t.rvu01
                  LET l_faj[j].rvv02_o = l_t720_t.rvv02
                  LET l_faj[j].apa01_o = l_t110_t.apa01_1

                  LET l_faj[j].apf01 = l_t330_t.apf01
                  LET l_faj[j].apf02 = l_t330_t.apf02
                  LET l_faj[j].apf44 = l_t330_t.apf44
                  LET l_faj[j].apg05 = l_t330_t.apg05

               ELSE
                  #跟随请款单后面
                  LET l_faj[m].apf01 = l_t330_t.apf01
                  LET l_faj[m].apf02 = l_t330_t.apf02
                  LET l_faj[m].apf44 = l_t330_t.apf44
                  LET l_faj[m].apg05 = l_t330_t.apg05

               END IF 

            END FOREACH

            LET l_t110_i = l_t110_i + 1
         END FOREACH
      END FOREACH 
      # IF l_t720 > l_i100 AND l_t720 >l_t150 THEN 
      #    CALL l_faj.deleteElement(l_cnt)
      # END IF 
      # EXECUTE insert_prep USING
      FOR m =1 TO l_faj.getLength()
            EXECUTE insert_prep USING l_faj[m].*
            IF STATUS THEN
               CALL cl_err("insert_prep","!",1)
               RETURN
            END IF 
      END FOR 
          
   END FOREACH 
                                                                                                           
   # LET g_str = tm.s[1,1],";",tm.s[2,2],";",tm.t[1,1],";",tm.t[2,2],";",g_azi04,";",tm.sum,";",g_str                                                                                                                 
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED 
   # CALL cl_prt_cs3('cfar100','cfar100',g_sql,g_str) 
END FUNCTION
