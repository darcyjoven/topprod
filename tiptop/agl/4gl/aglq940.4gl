# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: aglq940.4gl
# Descriptions...: 現金流量表列印
# Date & Author..: 00/06/21 By Hamilton
# Modify.........: 01/02/02 By Kammy(按群組科目彙總)
# Modify.........: No.MOD-530385 05/03/23 By Echo 現金流量表表頭將表頭與幣別及單位緊接著印在一起
# Modify.........: NO.MOD-5B0309 05/12/26 BY yiting 現金流量表中RUN當月數字都OK但RUN累計時就會有差異
# Modify.........: No.FUN-640004 06/04/05 By ice 新增傳參供gglp160(會計核算接口程序)調用
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-660060 06/06/29 By Rainy 表頭期間置於中間
# Modify.........: No.FUN-670005 06/07/07 By Hellen 帳別權限修改
# Modify.........: No.FUN-680098 06/09/04 By yjkhero  欄位類型轉換為 LIKE型   
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-6A0080 06/11/08 By cheunl 報表名稱修改
# Modify.........: No.FUN-710056 07/02/05 By Carrier rep1()不需要打印公司等內容,此為特定格式
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-740020 07/04/12 By bnlent 會計科目加帳套
# Modify.........: No.MOD-730146 07/04/12 By claire zo12改zo02
# Modify.........: No.FUN-7C0064 07/12/25 By Carrier 報表格式轉CR
# Modify.........: No.MOD-820135 08/02/25 By Smapmin 修改報表名稱預設值.修改幣別位數取位
# Modify.........: No.MOD-840620 08/04/24 By Smapmin 修改變數定義大小
# Modify.........: No.FUN-850030 08/05/09 By dxfwo   報表查詢化
# Modify.........: NO.FUN-970068 09/07/21 By hongmei gis_file--->gin_file,git_file--->gio_file 
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-A70007 10/07/13 By Summer 多帳期改用s_azmm,並依據畫面上的帳別傳遞使用
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No.FUN-B80180 11/09/02 By xuxz 程序中涉及到gim_file的sql加上條件:AND gim04 = tm.y1 AND gim05 = tm.m2
# Modify.........: No:FUN-BC0027 11/12/08 By lilingyu 原本取aaz31~aaz33,改取aaa14~aaa16
# Modify.........: No:TQC-C70083 12/07/12 By lujh 1397行SUM(gio05) 應該從gio_file表中取值  
#                                                 SUM(gio05)部分需要加上"gio00 = tm.b"的條件
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
              title   LIKE type_file.chr50,  #輸入報表名稱   #No.FUN-680098 VARCHAR(20)   #MOD-840620 chr20->chr50
              y1      LIKE aah_file.aah02,   #輸入起始年度   #No.FUN-680098 smallint   
              m1      LIKE aah_file.aah03,   #Begin 期別     #No.FUN-680098 smallint   
              y2      LIKE aah_file.aah02,   #輸入截止年度   #No.FUN-680098 smallint   
              m2      LIKE aah_file.aah03,   #End   期別     #No.FUN-680098 smallint   
              b       LIKE aaa_file.aaa01,   #帳別編號       #No.FUN-640004
              c       LIKE type_file.chr1,   #異動額及餘額為0者是否列印 #No.FUN-680098 VARCHAR(1)
              e       LIKE azi_file.azi05,   #小數位數      #No.FUN-680098   smallint
              d       LIKE type_file.chr1,   #金額單位      #No.FUN-680098   VARCHAR(1)
              o       LIKE type_file.chr1,   #轉換幣別否    #No.FUN-680098   VARCHAR(1)
              r       LIKE azi_file.azi01,   #總帳幣別
              p       LIKE azi_file.azi01,   #轉換幣別
              q       LIKE azj_file.azj03,   #匯率
              amt     LIKE type_file.num20_6,        #現金流量期初餘額#No.FUN-680098   DEC(20,6)
              s       LIKE type_file.chr1,           #是否有揭露事項  #No.FUN-680098  VARCHAR(1)
              t       LIKE type_file.chr1     #FUN-970068
              END RECORD,
          bdate,edate LIKE type_file.dat,           #No.FUN-680098 DATE
          i,j,k       LIKE type_file.num5,          #No.FUN-680098 SMALLINT
          g_unit      LIKE type_file.num10,        #金額單位基數 #No.FUN-680098 INTEGER
          l_za05      LIKE za_file.za05,        #No.FUN-680098 VARCHAR(40)
          g_bookno    LIKE aah_file.aah00, #帳別
          g_mai02     LIKE mai_file.mai02,
          g_mai03     LIKE mai_file.mai03,
          g_gim       DYNAMIC ARRAY OF RECORD
               gim02   LIKE gim_file.gim02,
               gim03   LIKE gim_file.gim03,
               gim01   LIKE gim_file.gim01
                      END RECORD,
          g_tot1      ARRAY[100] OF  LIKE type_file.num20_6, #No.FUN-680098 dec(20,6)
          g_tot1_1    ARRAY[100] OF  LIKE type_file.num20_6  #No.FUN-680098 dec(20,6)
 
DEFINE   g_aaa03         LIKE aaa_file.aaa03
DEFINE   g_cnt           LIKE type_file.num10    #No.FUN-680098 integer
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680098 smallint
DEFINE   g_msg           LIKE type_file.chr1000  #No.FUN-680098 VARCHAR(72)
DEFINE   g_name          LIKE type_file.chr20    #FILENAME FUN-640004        #No.FUN-680098    VARCHAR(60)
DEFINE   g_flag          LIKE type_file.chr1     #Y:產生接口數據 N:正常打印 FUN-640004   #No.FUN-680098 VARCHAR(1)
DEFINE   g_ym            LIKE type_file.chr6     #年期 FUN-640004    #No.FUN-680098   VARCHAR(6)
DEFINE   l_table         STRING                  #No.FUN-7C0064
DEFINE   g_str           STRING                  #No.FUN-7C0064
DEFINE   g_sql           STRING                  #No.FUN-7C0064
 
#No.FUN-850030  --Begin
DEFINE   g_yy2      LIKE type_file.num5
DEFINE   g_rec_b    LIKE type_file.num10
DEFINE   g_gir      DYNAMIC ARRAY OF RECORD
                    gir02  LIKE gir_file.gir02,
                    gir05  LIKE gir_file.gir05,
                    sum1   LIKE type_file.chr50,
                    sum2   LIKE type_file.chr50 
                    END RECORD
DEFINE   g_pr_ar    DYNAMIC ARRAY OF RECORD
                    line   LIKE type_file.num10,
                    gir02  LIKE gir_file.gir02,
                    gir05  LIKE gir_file.gir05,
                    sum1   LIKE type_file.chr50,
                    sum2   LIKE type_file.chr50 
                    END RECORD
#No.FUN-850030   --End

DEFINE  g_aaa       RECORD LIKE aaa_file.*        #FUN-BC0027
  
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                 # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
 
   LET tm.b = ARG_VAL(1)           #No.FUN-740020
   LET g_pdate = ARG_VAL(2)        # Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   #No.FUN-640004 --start--
   INITIALIZE tm.* TO NULL
   LET tm.y1 = ARG_VAL(8)
   LET tm.m1 = ARG_VAL(9)
   LET g_name= ARG_VAL(10)
   IF NOT (cl_null(tm.y1) OR cl_null(tm.m1)) THEN
      LET g_flag = 'Y'
      IF cl_null(g_bookno) THEN LET g_bookno = g_aaz.aaz64 END IF
      IF cl_null(tm.b) THEN LET tm.b = g_aza.aza81 END IF     #No.FUN-740020
      LET g_ym = tm.y1 USING '&&&&',tm.m1 USING '&&'
      SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = tm.b   #No.FUN-740020 
      SELECT azi05 INTO tm.e FROM azi_file WHERE azi01 = g_aaa03
      IF cl_null(tm.m2) THEN LET tm.m2 = tm.m1 END IF
      IF cl_null(tm.title) THEN LET tm.title = g_name END IF
      #LET tm.b = g_bookno    #No.FUN-740020
      LET tm.r = g_aaa03
      LET tm.c = 'Y'
      LET tm.d = '1'
      LET tm.o = 'N'
      LET tm.p = tm.r
      LET tm.q = 1
      LET tm.amt  = 0
      LET g_pdate  = g_today
      LET g_bgjob  = 'N'
      LET g_copies = '1'
      IF tm.d = '1' THEN LET g_unit = 1 END IF
      IF tm.d = '2' THEN LET g_unit = 1000 END IF
      IF tm.d = '3' THEN LET g_unit = 1000000 END IF
   ELSE
      LET g_flag = 'N'
   END IF
 
   LET g_rlang  = g_lang
   IF g_flag = 'N' THEN
      IF cl_null(g_bookno) THEN LET g_bookno = g_aaz.aaz64 END IF
 
      #No.FUN-850030  --Begin
      OPEN WINDOW q940_w AT 5,10                                                   
           WITH FORM "agl/42f/aglq940" ATTRIBUTE(STYLE = g_win_style)              
                                                                                
      CALL cl_ui_init() 
 
      IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
         THEN CALL q940_tm()         # Input print condition
         ELSE CALL q940()            # Read data and create out-file
      END IF
 
      CALL q940_menu()                                                             
      CLOSE WINDOW q940_w                                                          
      #No.FUN-850030  --End  
 
   ELSE
      CALL q940()                    # Read data and create out-file
   END IF
   #No.FUN-640004 --end--
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
FUNCTION q940_menu()
   WHILE TRUE
      CALL q940_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q940_tm()
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL q940_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"   #No.FUN-4B0021
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_gir),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q940_tm()
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680098 SMALLINT
          l_sw      LIKE type_file.chr1,     #重要欄位是否空白 #No.FUN-680098 VARCHAR(1) 
          l_cmd     LIKE type_file.chr1000       #No.FUN-680098  VARCHAR(400)
   DEFINE li_chk_bookno  LIKE type_file.num5     #No.FUN-670005   #No.FUN-680098  smallint
   CALL s_dsmark(tm.b)            #No.FUN-740020
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 3 LET p_col = 20
   ELSE LET p_row = 4 LET p_col = 12
   END IF
   OPEN WINDOW q940_w1 AT p_row,p_col
        WITH FORM "agl/42f/aglr940"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
   
   CALL cl_set_comp_visible("t",FALSE)  #FUN-970068
 
   CALL  s_shwact(0,0,tm.b)           #No.FUN-740020
   CALL cl_opmsg('p')
 
   INITIALIZE tm.* TO NULL            # Default condition
   #使用預設帳別之幣別
   IF cl_null(tm.b) THEN LET tm.b = g_aza.aza81 END IF           #No.FUN-740020
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = tm.b    #No.FUN-740020 
   IF SQLCA.sqlcode THEN
#       CALL cl_err('sel aaa:',SQLCA.sqlcode,0) # NO.FUN-660123
        CALL cl_err3("sel","aaa_file",g_bookno,"",SQLCA.sqlcode,"","sel aaa:",0)  # NO.FUN-660123 
   END IF
   #使用預設帳別之幣別之小數位數
   SELECT azi05 INTO tm.e FROM azi_file WHERE azi01 = g_aaa03
   IF SQLCA.sqlcode THEN 
#      CALL cl_err('sel azi:',SQLCA.sqlcode,0)  # NO.FUN-660123 
       CALL cl_err3("sel","azi_file",g_aaa03,"",SQLCA.sqlcode,"","sel azi:",0)  # NO.FUN-660123 
   END IF
   #LET tm.b = g_bookno       #No.FUN-740020
   LET tm.c = 'Y'
   LET tm.d = '1'
   LET tm.o = 'N'
   LET tm.r = g_aaa03
   LET tm.p = g_aaa03
   LET tm.q = 1
   LET tm.amt  = 0
   LET tm.s    = 'N'
   LET g_pdate  = g_today
   LET g_bgjob  = 'N'
   LET g_copies = '1'
WHILE TRUE
    LET l_sw = 1
    INPUT BY NAME tm.title,tm.y1,tm.m1,tm.m2,
                  tm.b,tm.e,tm.d,tm.c,tm.s,tm.o,
                  tm.r,tm.p,tm.q
                  WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
       ON ACTION locale
           #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT INPUT
 
      BEFORE FIELD title
         #-----MOD-820135---------
         #LET tm.title = g_x[1]   
         IF cl_null(tm.title) THEN 
            SELECT gaz06 INTO tm.title FROM gaz_file
              WHERE gaz01=g_prog AND gaz02=g_lang AND gaz05='Y'
            IF cl_null(tm.title) THEN
               SELECT gaz06 INTO tm.title FROM gaz_file
                 WHERE gaz01=g_prog AND gaz02=g_lang AND gaz05='N'
            END IF
         END IF
         #-----END MOD-820135-----
 
      AFTER FIELD title
# genero  script marked          IF cl_ku() THEN NEXT FIELD PREVIOUS END IF
         IF tm.title IS NULL THEN NEXT FIELD title END IF
 
      AFTER FIELD y1
# genero  script marked          IF cl_ku() THEN NEXT FIELD PREVIOUS END IF
         IF tm.y1 IS NULL OR tm.y1 = 0 THEN
            NEXT FIELD y1
         END IF
         IF tm.y1 > YEAR(g_pdate) THEN
            CALL cl_err('','agl-920',0)
            NEXT FIELD y1
         END IF
         LET tm.y2=tm.y1
         LET g_yy2 = tm.y1 - 1
 
      AFTER FIELD m1
#No.TQC-720032 -- begin --
         IF NOT cl_null(tm.m1) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.y1
            IF g_azm.azm02 = 1 THEN
               IF tm.m1 > 12 OR tm.m1 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m1
               END IF
            ELSE
               IF tm.m1 > 13 OR tm.m1 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m1
               END IF
            END IF
         END IF
#No.TQC-720032 -- end --
# genero  script marked          IF cl_ku() THEN NEXT FIELD PREVIOUS END IF
         IF tm.m1 IS NULL THEN NEXT FIELD m1 END IF
#No.TQC-720032 -- begin --
#         IF tm.m1 <1 OR tm.m1 > 13 THEN
#            CALL cl_err('','agl-013',0)
#            NEXT FIELD m1
#         END IF
#No.TQC-720032 -- end --
         IF tm.y1 = YEAR(g_pdate) AND tm.m1 > MONTH(g_pdate) THEN
            CALL cl_err('','agl-920',0)
            NEXT FIELD m1
         END IF
 
      AFTER FIELD m2
#No.TQC-720032 -- begin --
         IF NOT cl_null(tm.m2) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.y1
            IF g_azm.azm02 = 1 THEN
               IF tm.m2 > 12 OR tm.m2 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m2
               END IF
            ELSE
               IF tm.m2 > 13 OR tm.m2 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m2
               END IF
            END IF
         END IF
#No.TQC-720032 -- end --
         IF tm.m2 IS NULL THEN NEXT FIELD m2 END IF
#No.TQC-720032 -- begin --
#         IF tm.m2 <1 OR tm.m2 > 13 THEN
#            CALL cl_err('','agl-013',0) NEXT FIELD m2
#         END IF
#No.TQC-720032 -- end --
         IF tm.y2 = YEAR(g_pdate) AND tm.m2 > MONTH(g_pdate) THEN
            CALL cl_err('','agl-920',0)
            NEXT FIELD m2
         END IF
         IF tm.y1 = tm.y2 AND tm.m1 > tm.m2 THEN
            CALL cl_err('','9011',0) NEXT FIELD m1
         END IF
 
      AFTER FIELD b
# genero  script marked          IF cl_ku() THEN NEXT FIELD PREVIOUS END IF
         IF tm.b IS NULL THEN NEXT FIELD b END IF
         #No.FUN-670005--begin
             CALL s_check_bookno(tm.b,g_user,g_plant) 
                  RETURNING li_chk_bookno
             IF (NOT li_chk_bookno) THEN
                  NEXT FIELD b 
             END IF 
         #No.FUN-670005--end  
         SELECT aaa02 FROM aaa_file WHERE aaa01=tm.b AND aaaacti IN ('Y','y')
         IF STATUS THEN
#             CALL cl_err('sel aaa:',STATUS,0) # NO.FUN-660123
              CALL cl_err3("sel","aaa_file",tm.b,"",STATUS,"","sel aaa:",0)  # NO.FUN-660123
             NEXT FIELD b
         END IF
 
      AFTER FIELD c
# genero  script marked          IF cl_ku() THEN NEXT FIELD PREVIOUS END IF
         IF tm.c IS NULL OR tm.c NOT MATCHES "[YN]" THEN NEXT FIELD c END IF
 
      AFTER FIELD e
# genero  script marked          IF cl_ku() THEN NEXT FIELD PREVIOUS END IF
         IF tm.e < 0 THEN
            LET tm.e = 0
            DISPLAY BY NAME tm.e
         END IF
 
      AFTER FIELD d
# genero  script marked          IF cl_ku() THEN NEXT FIELD PREVIOUS END IF
         IF tm.d IS NULL OR tm.d NOT MATCHES'[123]'  THEN
            NEXT FIELD d
         END IF
 
      AFTER FIELD o
# genero  script marked          IF cl_ku() THEN NEXT FIELD PREVIOUS END IF
         IF tm.o IS NULL OR tm.o NOT MATCHES'[YN]' THEN NEXT FIELD o END IF
         IF tm.o = 'N' THEN
            LET tm.p = g_aaa03
            LET tm.q = 1
            DISPLAY g_aaa03 TO p
            DISPLAY BY NAME tm.q
         END IF
 
      AFTER FIELD p
         SELECT azi01 FROM azi_file WHERE azi01 = tm.p
         IF SQLCA.sqlcode THEN  
#           CALL cl_err(tm.p,'agl-109',0)  # NO.FUN-660123 
            CALL cl_err3("sel","azi_file",tm.p,"","agl-109","","sel azi:",0)  # NO.FUN-660123 
           NEXT FIELD p
         END IF
 
      AFTER FIELD q
         IF tm.q <= 0 THEN
            NEXT FIELD q
         END IF
 
      AFTER FIELD s
         IF tm.s IS NULL OR tm.s NOT MATCHES "[YN]" THEN NEXT FIELD s END IF
        #IF tm.s = 'Y' THEN
        #   LET g_msg='agli920'
        #   CALL cl_cmdrun(g_msg)
        #END IF
 
      AFTER INPUT
         IF INT_FLAG THEN EXIT INPUT END IF
         IF tm.d = '1' THEN LET g_unit = 1 END IF
         IF tm.d = '2' THEN LET g_unit = 1000 END IF
         IF tm.d = '3' THEN LET g_unit = 1000000 END IF
         IF tm.o = 'N' THEN
            LET tm.p = g_aaa03
            LET tm.q = 1
         END IF
 
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
      ON ACTION CONTROLG CALL cl_cmdask()     # Command execution
 
      ON ACTION mntn_labor_amount
         CALL cl_cmdrun("agli932")
 
      ON ACTION mntn_expose_item
         CALL cl_cmdrun("agli920")
 
      ON ACTION CONTROLP
         IF INFIELD(p) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = 'q_azi'
            LET g_qryparam.default1 = tm.p
            CALL cl_create_qry() RETURNING tm.p
#            CALL FGL_DIALOG_SETBUFFER( tm.p )
            DISPLAY BY NAME tm.p
            NEXT FIELD p
         END IF
         IF INFIELD(b) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = 'q_aaa'
            LET g_qryparam.default1 = tm.b
            CALL cl_create_qry() RETURNING tm.b
#            CALL FGL_DIALOG_SETBUFFER( tm.b )
            DISPLAY BY NAME tm.b
            NEXT FIELD b
         END IF
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
          ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
 
   IF g_action_choice = "locale" THEN
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW q940_w1
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
         
   END IF
   CALL cl_wait()
   CALL q940()
   ERROR ""
   EXIT WHILE
END WHILE
   CLOSE WINDOW q940_w1
END FUNCTION
 
FUNCTION q940()
     DEFINE l_name    LIKE type_file.chr20         #No.FUN-680098 VARCHAR(20)
#     DEFINE     l_time LIKE type_file.chr8        #No.FUN-6A0073
     DEFINE l_chr     LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
     DEFINE amt1      LIKE type_file.num20_6       #No.FUN-680098 dec(20,6)
     DEFINE amt1_1    LIKE type_file.num20_6       #No.FUN-680098 dec(20,6)
     DEFINE l_tmp     LIKE type_file.num20_6       #No.FUN-680098 dec(20,6)
     DEFINE l_i       LIKE type_file.num10
 
     #移至前面主要因為tm.title 多語言的關係
 
     LET g_prog = 'aglr940'
      SELECT aaf03 INTO g_company FROM aaf_file WHERE aaf01 = tm.b  #No.MOD-530385
            AND aaf02 = g_rlang
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'aglr940'

    SELECT * INTO g_aaa.* FROM aaa_file WHERE aaa01 = tm.b     #FUN-BC0027
         
      IF g_len = 0 OR g_len IS NULL THEN LET g_len = 132 END IF
     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR  
     #No.FUN-640004 --start--
     CALL cl_outnam('aglr940') RETURNING l_name
     IF g_flag = 'Y' THEN
        LET l_name = g_name
        START REPORT q940_rep1 TO l_name
        OUTPUT TO REPORT q940_rep1()
        FINISH REPORT q940_rep1
     ELSE
        LET g_rec_b = 1
        CALL g_gir.clear()
        START REPORT q940_rep TO l_name
        OUTPUT TO REPORT q940_rep()
        FINISH REPORT q940_rep
        FOR l_i = 1 TO g_rec_b
            LET g_gir[l_i].gir02 = g_pr_ar[l_i].gir02 
            LET g_gir[l_i].gir05 = g_pr_ar[l_i].gir05 
            LET g_gir[l_i].sum1  = g_pr_ar[l_i].sum1  
            LET g_gir[l_i].sum2  = g_pr_ar[l_i].sum2  
        END FOR
        #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     END IF
     #No.FUN-640004 --end--
 
END FUNCTION
 
REPORT q940_rep()
   DEFINE l_sql         LIKE type_file.chr1000        # RDSQL STATEMENT   #No.FUN-680098 VARCHAR(1000)
   DEFINE l_last_sw     LIKE type_file.chr1           #No.FUN-680098  VARCHAR(1)
   DEFINE l_unit        LIKE zaa_file.zaa08           #No.FUN-680098  VARCHAR(4)
   DEFINE l_per1        LIKE fid_file.fid03           #No.FUN-680098  decimal(8,3)
   DEFINE l_d1          LIKE type_file.num5,          #No.FUN-680098  smallint
          l_d2          LIKE type_file.num5,          #No.FUN-680098  smallint
          l_flag        LIKE type_file.chr1,          #No.FUN-680098  VARCHAR(1)
          l_str         LIKE type_file.chr21,         #No.FUN-680098  VARCHAR(1)
          l_bdate,l_edate   LIKE type_file.dat,       #No.FUN-680098  date
          l_type        LIKE aag_file.aag06,          #正常餘額型態(1.借餘/2.貨餘) #No.FUN-680098  VARCHAR(1)
          l_cnt         LIKE type_file.num5,          #揭露事項筆數        #No.FUN-680098 smallint
          l_last_y      LIKE type_file.num5,          #期初年份 #No.FUN-680098  smalint
          l_last_m      LIKE type_file.num5,          #期初月份 #No.FUN-680098  smallint
          l_this        LIKE type_file.num20_6,       #本期餘額 #No.FUN-680098  dec(20,6)
          l_last        LIKE type_file.num20_6,       #期初餘額 #No.FUN-680098  dec(20,6)
          l_diff        LIKE type_file.num20_6,       #差異 #No.FUN-680098   dec(20,6)
          l_amt         LIKE type_file.num20_6,       #科目現金流量 #No.FUN-680098  dec(20,6)
          l_amt_s       LIKE type_file.num20_6,       #群組現金流量 #No.FUN-680098  dec(20,6)
          l_sub_amt     LIKE type_file.num20_6,       #各活動產生之淨現金 #No.FUN-680098  dec(20,6)
          l_tot_amt     LIKE type_file.num20_6,       #本期現金淨增數 #No.FUN-680098    dec(20,6)
          l_tmp_amt     LIKE type_file.num20_6        #折舊科目之合計 #No.FUN-680098    dec(20,6)
   DEFINE l_d11         LIKE type_file.num5,          #No.FUN-680098  smallint
          l_d21         LIKE type_file.num5,          #No.FUN-680098  smallint
          l_last_y1     LIKE type_file.num5,          #期初年份 #No.FUN-680098  smalint
          l_last_m1     LIKE type_file.num5,          #期初月份 #No.FUN-680098  smallint
          l_this1       LIKE type_file.num20_6,       #本期餘額 #No.FUN-680098  dec(20,6)
          l_last1       LIKE type_file.num20_6,       #期初餘額 #No.FUN-680098  dec(20,6)
          l_diff1       LIKE type_file.num20_6,       #差異 #No.FUN-680098   dec(20,6)
          l_amt1        LIKE type_file.num20_6,       #科目現金流量 #No.FUN-680098  dec(20,6)
          l_amt_s1      LIKE type_file.num20_6,       #群組現金流量 #No.FUN-680098  dec(20,6)
          l_sub_amt1    LIKE type_file.num20_6,       #各活動產生之淨現金 #No.FUN-680098  dec(20,6)
          l_tot_amt1    LIKE type_file.num20_6,       #本期現金淨增數 #No.FUN-680098    dec(20,6)
          l_tmp_amt1    LIKE type_file.num20_6        #折舊科目之合計 #No.FUN-680098    dec(20,6)
   DEFINE tmp RECORD
          aag01      LIKE aag_file.aag01,
          aag02      LIKE aag_file.aag02,
        # gis03      LIKE gis_file.gis03,  #FUN-970068
        # gis04      LIKE gis_file.gis04   #FUN-970068
          gin03      LIKE gin_file.gin03,  #FUN-970068
          gin04      LIKE gin_file.gin04   #FUN-970068
          END RECORD
   DEFINE gir RECORD                     #群組代號
          gir01      LIKE gir_file.gir01,
          gir02      LIKE gir_file.gir02,
          gir05      LIKE gir_file.gir05
          END RECORD
 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  FORMAT
   PAGE HEADER
      #報表結構,報表名稱,幣別,單位
      CASE tm.d
           WHEN '1'  LET l_unit = g_x[31]
           WHEN '2'  LET l_unit = g_x[32]
           WHEN '3'  LET l_unit = g_x[33]
           OTHERWISE LET l_unit = ' '
      END CASE
 
      LET g_x[1] = g_mai02
 
      #製表日期,期間,頁次
      #CALL s_azm(tm.y1,tm.m1) RETURNING l_flag,l_bdate,l_edate #CHI-A70007 mark
      #CHI-A70007 add --start--
      IF g_aza.aza63 = 'Y' THEN
         CALL s_azmm(tm.y1,tm.m1,g_plant,tm.b) RETURNING l_flag,l_bdate,l_edate
      ELSE
         CALL s_azm(tm.y1,tm.m1) RETURNING l_flag,l_bdate,l_edate
      END IF
      #CHI-A70007 add --end--
      LET l_d1 = DAY(l_bdate)
      #CALL s_azm(tm.y2,tm.m2) RETURNING l_flag,l_bdate,l_edate #CHI-A70007 mark
      #CHI-A70007 add --start--
      IF g_aza.aza63 = 'Y' THEN
         CALL s_azmm(tm.y2,tm.m2,g_plant,tm.b) RETURNING l_flag,l_bdate,l_edate
      ELSE
         CALL s_azm(tm.y2,tm.m2) RETURNING l_flag,l_bdate,l_edate
      END IF
      #CHI-A70007 add --end--
      LET l_d2 = DAY(l_edate)
 
      #CALL s_azm(g_yy2,tm.m1) RETURNING l_flag,l_bdate,l_edate #CHI-A70007 mark
      #CHI-A70007 add --start--
      IF g_aza.aza63 = 'Y' THEN
         CALL s_azmm(g_yy2,tm.m1,g_plant,tm.b) RETURNING l_flag,l_bdate,l_edate
      ELSE
         CALL s_azm(g_yy2,tm.m1) RETURNING l_flag,l_bdate,l_edate
      END IF
      #CHI-A70007 add --end--
      LET l_d11 = DAY(l_bdate)
      #CALL s_azm(g_yy2,tm.m2) RETURNING l_flag,l_bdate,l_edate #CHI-A70007
      #CHI-A70007 add --start--
      IF g_aza.aza63 = 'Y' THEN
         CALL s_azmm(g_yy2,tm.m2,g_plant,tm.b) RETURNING l_flag,l_bdate,l_edate
      ELSE
         CALL s_azm(g_yy2,tm.m2) RETURNING l_flag,l_bdate,l_edate
      END IF
      #CHI-A70007 add --end--
      LET l_d21 = DAY(l_edate)
 
      IF tm.m1=1 THEN
         LET l_last_y = tm.y1 - 1
         LET l_last_m = 12
         LET l_last_y1= g_yy2 - 1
         LET l_last_m1= 12
      ELSE
         LET l_last_y = tm.y1
         LET l_last_m = tm.m1 - 1
         LET l_last_y1= g_yy2
         LET l_last_m1= tm.m1 - 1
      END IF
 
   ON EVERY ROW
      LET l_amt = 0
      LET l_amt_s = 0
      LET l_this = 0
      LET l_last = 0
      LET l_sub_amt = 0
      LET l_tot_amt = 0
      LET l_tmp_amt = 0
 
      LET l_amt1= 0
      LET l_amt_s1= 0
      LET l_this1= 0
      LET l_last1= 0
      LET l_sub_amt1= 0
      LET l_tot_amt1= 0
      LET l_tmp_amt1= 0
 
      #營業活動之現金流量
      INITIALIZE g_pr_ar[g_rec_b].* TO NULL
      LET g_pr_ar[g_rec_b].line = g_rec_b
      LET g_pr_ar[g_rec_b].gir02 = g_x[14]
      LET g_rec_b = g_rec_b + 1
 
      #---------------------本期淨利(損)------------------------------
#     CALL q940_aah(g_aaz.aaz31,tm.y1,tm.m2,l_amt) RETURNING l_amt #FUN-BC0027
      CALL q940_aah(g_aaa.aaa14,tm.y1,tm.m2,l_amt) RETURNING l_amt #FUN-BC0027
      IF cl_null(l_amt) THEN LET l_amt = 0 END IF
      LET l_amt=l_amt*-1
      LET l_tot_amt = l_tot_amt + l_amt        #計算本期現金淨增數
      LET l_amt = l_amt*tm.q/g_unit            #依匯率及單位換算
 
#      CALL q940_aah(g_aaz.aaz31,g_yy2,tm.m2,l_amt1) RETURNING l_amt1             #FUN-BC0027
       CALL q940_aah(g_aaa.aaa14,g_yy2,tm.m2,l_amt1) RETURNING l_amt1             #FUN-BC0027
      IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF                             
      LET l_amt1=l_amt1*-1                                                      
      LET l_tot_amt1 = l_tot_amt1 + l_amt1       #計算本期現金凈增數           
      LET l_amt1 = l_amt1*tm.q/g_unit            #依匯率及單位換算 
 
      INITIALIZE g_pr_ar[g_rec_b].* TO NULL
      LET g_pr_ar[g_rec_b].line = g_rec_b
      LET g_pr_ar[g_rec_b].gir02 = g_x[15]
 
      IF l_amt >= 0 THEN
         LET g_pr_ar[g_rec_b].sum1 = cl_numfor(l_amt,20,tm.e)
      ELSE
         CALL q940_str(l_amt,l_str) RETURNING l_str
         LET g_pr_ar[g_rec_b].sum1 = l_str CLIPPED,')'
      END IF
 
      IF l_amt1 >= 0 THEN                                                       
         LET g_pr_ar[g_rec_b].sum2 = cl_numfor(l_amt1,20,tm.e) 
      ELSE                                                                      
         CALL q940_str(l_amt1,l_str) RETURNING l_str                            
         LET g_pr_ar[g_rec_b].sum2 = l_str CLIPPED,')'
      END IF 
      LET g_rec_b = g_rec_b + 1
 
      #調整項目
      INITIALIZE g_pr_ar[g_rec_b].* TO NULL
      LET g_pr_ar[g_rec_b].line = g_rec_b
      LET g_pr_ar[g_rec_b].gir02 = g_x[16]
      LET g_rec_b = g_rec_b + 1
      
      #-------------------------營業科目-------------------------------
      LET l_amt = 0
      LET l_amt1 = 0
      LET l_sql="SELECT gir01,gir02,gir05 FROM gir_file ",
                " WHERE gir03 = '1' AND gir04 = 'N'"
      PREPARE q940_gir_p1 FROM l_sql
      DECLARE q940_gir_cs1 CURSOR FOR q940_gir_p1
 
     #FUN-970068---Begin
     #LET l_sql="SELECT aag01,aag02,gis03,gis04 ",  
     #          "  FROM aag_file,gis_file,gir_file",
     #          " WHERE aag01=gis02 AND gir01=gis01 ",
     #          "   AND aag00=gis00 AND aag00 = '",tm.b,"' ",  #No.FUN-740020
     #          "   AND gir04='N' AND gis01 = ? "
      LET l_sql="SELECT aag01,aag02,gin03,gin04 ",  
                "  FROM aag_file,gin_file,gir_file",
                " WHERE aag01=gin02 AND gir01=gin01 ",
                "   AND aag00=gin00 AND aag00 = '",tm.b,"' ",   
                "   AND gir04='N' AND gin01 = ? " 
     #FUN-970068---End
      PREPARE q940_p3 FROM l_sql
      DECLARE q940_cu3 CURSOR FOR q940_p3
      FOREACH q940_gir_cs1 INTO gir.*
        LET l_amt_s = 0
        LET l_amt_s1= 0
        FOREACH q940_cu3 USING gir.gir01 INTO tmp.*
         # CASE tmp.gis04  #FUN-970068
           CASE tmp.gin04  #FUN-970068
             WHEN '1'
               CALL q940_aah(tmp.aag01,tm.y2,tm.m2,l_amt) RETURNING l_amt
               IF cl_null(l_amt) THEN LET l_amt = 0 END IF
               CALL q940_aah(tmp.aag01,g_yy2,tm.m2,l_amt1) RETURNING l_amt1     
               IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
             WHEN '2'
               CALL q940_aah2(tmp.aag01,l_last_y,l_last_m) RETURNING l_amt
               CALL q940_aah2(tmp.aag01,l_last_y1,l_last_m1) RETURNING l_amt1
             WHEN '3'
               CALL q940_aah2(tmp.aag01,tm.y2,tm.m2) RETURNING l_amt
               CALL q940_aah2(tmp.aag01,g_yy2,tm.m2) RETURNING l_amt1
             WHEN '4'
             #FUN-970068---Begin
             # SELECT SUM(git05) INTO l_amt FROM git_file,gir_file
             #  WHERE git01 = gir.gir01 AND git02 = tmp.aag01
             #    AND git06 = tm.y1 AND git07 BETWEEN tm.m1 AND tm.m2
             #    AND git01 = gir01 AND gir04 = 'N'
             # IF cl_null(l_amt) THEN LET l_amt = 0 END IF
             # SELECT SUM(git05) INTO l_amt1 FROM git_file,gir_file             
             #  WHERE git01 = gir.gir01 AND git02 = tmp.aag01                   
             #    AND git06 = g_yy2 AND git07 BETWEEN tm.m1 AND tm.m2           
             #    AND git01 = gir01 AND gir04 = 'N'                             
             # IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
               SELECT SUM(gio05) INTO l_amt FROM gio_file,gir_file
                WHERE gio01 = gir.gir01 AND gio02 = tmp.aag01
                  AND gio06 = tm.y1 AND gio07 BETWEEN tm.m1 AND tm.m2
                  AND gio01 = gir01 AND gir04 = 'N'
                  AND gio00 = tm.b                                            #TQC-C70083  add
               IF cl_null(l_amt) THEN LET l_amt = 0 END IF
               SELECT SUM(gio05) INTO l_amt1 FROM gio_file,gir_file             
                WHERE gio01 = gir.gir01 AND gio02 = tmp.aag01                   
                  AND gio06 = g_yy2 AND gio07 BETWEEN tm.m1 AND tm.m2           
                  AND gio01 = gir01 AND gir04 = 'N'                             
                  AND gio00 = tm.b                                            #TQC-C70083  add
               IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF 
             #FUN-970068---End                           
               IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
             WHEN '5'  #借方異動
               SELECT SUM(aah04) INTO l_amt FROM aah_file
                WHERE aah00=tm.b AND aah01=tmp.aag01
                    AND aah02=tm.y1 AND aah03 BETWEEN tm.m1 AND tm.m2
               IF cl_null(l_amt) THEN LET l_amt = 0 END IF
               SELECT SUM(aah04) INTO l_amt1 FROM aah_file                      
                WHERE aah00=tm.b AND aah01=tmp.aag01                            
                    AND aah02=g_yy2 AND aah03 BETWEEN tm.m1 AND tm.m2           
               IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
             WHEN '6'  #貸方異動
               SELECT SUM(aah05) INTO l_amt FROM aah_file
                WHERE aah00=tm.b AND aah01=tmp.aag01
                    AND aah02=tm.y1 AND aah03 BETWEEN tm.m1 AND tm.m2
               IF cl_null(l_amt) THEN LET l_amt = 0 END IF
               SELECT SUM(aah05) INTO l_amt1 FROM aah_file                      
                WHERE aah00=tm.b AND aah01=tmp.aag01                            
                    AND aah02=g_yy2 AND aah03 BETWEEN tm.m1 AND tm.m2           
               IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
           END CASE
           #若為減項
          #IF tmp.gis03 = '-' THEN LET l_amt  = l_amt * -1 END IF  #FUN-970068
           IF tmp.gin03 = '-' THEN LET l_amt  = l_amt * -1 END IF  #FUN-970068
           LET l_amt_s = l_amt_s + l_amt
          #IF tmp.gis03 = '-' THEN LET l_amt1  = l_amt1 * -1 END IF #FUN-970068             
           IF tmp.gin03 = '-' THEN LET l_amt1  = l_amt1 * -1 END IF #FUN-970068        
           LET l_amt_s1 = l_amt_s1 + l_amt1
        END FOREACH
 
        IF l_amt_s = 0 AND l_amt_s1 = 0 AND tm.c = 'N' THEN
           CONTINUE FOREACH
        END IF
 
        INITIALIZE g_pr_ar[g_rec_b].* TO NULL
        LET g_pr_ar[g_rec_b].line = g_rec_b
        LET g_pr_ar[g_rec_b].gir02 = 8 SPACES,gir.gir02
        LET g_pr_ar[g_rec_b].gir05 = gir.gir05
   
        Let l_sub_amt = l_sub_amt + l_amt_s      #計算營業活動產生之淨現金
        LET l_amt_s = l_amt_s*tm.q/g_unit     #依匯率及單位換算
        IF l_amt_s >= 0 THEN
           LET g_pr_ar[g_rec_b].sum1 = cl_numfor(l_amt_s,20,tm.e)
        ELSE
           CALL q940_str(l_amt_s,l_str) RETURNING l_str
           LET g_pr_ar[g_rec_b].sum1 = l_str CLIPPED,')'
        END IF
 
        Let l_sub_amt1 = l_sub_amt1 + l_amt_s1   #計算營業活動產生之凈現金      
        LET l_amt_s1 = l_amt_s1*tm.q/g_unit     #依匯率及單位換算               
        IF l_amt_s1 >= 0 THEN                                                   
           LET g_pr_ar[g_rec_b].sum2 = cl_numfor(l_amt_s1,20,tm.e)                          
        ELSE                                                                    
           CALL q940_str(l_amt_s1,l_str) RETURNING l_str                        
           LET g_pr_ar[g_rec_b].sum2 = l_str CLIPPED,')'
        END IF 
        LET g_rec_b = g_rec_b + 1
 
      END FOREACH
 
      #營業活動產生之淨現金
      LET l_tot_amt = l_tot_amt + l_sub_amt  #計算本期現金淨增數
      LET l_tot_amt1 = l_tot_amt1 + l_sub_amt1  #計算本期現金凈增數             
      LET l_sub_amt = l_sub_amt*tm.q/g_unit  #依匯率及單位換算
      LET l_sub_amt1 = l_sub_amt1*tm.q/g_unit  #依匯率及單位換算                
      INITIALIZE g_pr_ar[g_rec_b].* TO NULL
      LET g_pr_ar[g_rec_b].line = g_rec_b
      LET g_pr_ar[g_rec_b].gir02 = g_x[20]
      IF l_sub_amt >= 0 THEN
         LET g_pr_ar[g_rec_b].sum1 = cl_numfor(l_sub_amt,20,tm.e)
      ELSE
         CALL q940_str(l_sub_amt,l_str) RETURNING l_str
         LET g_pr_ar[g_rec_b].sum1 = l_str CLIPPED,')' 
      END IF
 
      IF l_sub_amt1 >= 0 THEN                                                   
         LET g_pr_ar[g_rec_b].sum2 = cl_numfor(l_sub_amt1,20,tm.e)                          
      ELSE                                                                      
         CALL q940_str(l_sub_amt1,l_str) RETURNING l_str                        
         LET g_pr_ar[g_rec_b].sum2 = l_str CLIPPED,')'
      END IF                                                                    
      LET g_rec_b = g_rec_b + 1
      LET l_sub_amt = 0
      LET l_amt_s = 0
      LET l_sub_amt1 = 0                                                        
      LET l_amt_s1 = 0                                                          
 
      #----------------------投資活動之現金流量-----------------------
      INITIALIZE g_pr_ar[g_rec_b].* TO NULL
      LET g_pr_ar[g_rec_b].line = g_rec_b
      LET g_pr_ar[g_rec_b].gir02= g_x[21]
      LET g_rec_b = g_rec_b + 1
 
      LET l_amt = 0
      LET l_amt1 = 0
 
      LET l_sql="SELECT gir01,gir02,gir05 FROM gir_file ",
                " WHERE gir03 = '2' AND gir04 = 'N'"
      PREPARE q940_gir_p2 FROM l_sql
      DECLARE q940_gir_cs2 CURSOR FOR q940_gir_p2
 
     #FUN-970068---Begin  
     #LET l_sql="SELECT aag01,aag02,gis03,gis04 ",
     #          " FROM aag_file,gis_file,gir_file",
     #          " WHERE aag01=gis02 AND gis01=gir01 ",
     #          "   AND aag00=gis00 AND aag00 = '",tm.b,"' ",  #No.FUN-740020
     #          "   AND gir04='N' AND gis01 = ? "
      LET l_sql="SELECT aag01,aag02,gin03,gin04 ",
                " FROM aag_file,gin_file,gir_file",
                " WHERE aag01=gin02 AND gin01=gir01 ",
                "   AND aag00=gin00 AND aag00 = '",tm.b,"' ",   
                "   AND gir04='N' AND gin01 = ? "
     #FUN-970068---End
      PREPARE q940_p4 FROM l_sql
      DECLARE q940_cu4 CURSOR FOR q940_p4
      FOREACH q940_gir_cs2 INTO gir.*
 
         LET l_amt_s = 0
         LET l_amt_s1 = 0
         FOREACH q940_cu4 USING gir.gir01 INTO tmp.*
          #CASE tmp.gis04  #FUN-970068
           CASE tmp.gin04  #FUN-970068
             WHEN '1'
               CALL q940_aah(tmp.aag01,tm.y2,tm.m2,l_amt)
                           RETURNING l_amt
               IF cl_null(l_amt) THEN LET l_amt = 0 END IF
               CALL q940_aah(tmp.aag01,g_yy2,tm.m2,l_amt1)                      
                           RETURNING l_amt1                                     
               IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
             WHEN '2'
               CALL q940_aah2(tmp.aag01,l_last_y,l_last_m) RETURNING l_amt
               CALL q940_aah2(tmp.aag01,l_last_y1,l_last_m1) RETURNING l_amt1
             WHEN '3'
               CALL q940_aah2(tmp.aag01,tm.y2,tm.m2) RETURNING l_amt
               CALL q940_aah2(tmp.aag01,g_yy2,tm.m2) RETURNING l_amt1 
             WHEN '4'
             #FUN-970068---Begin
             # SELECT SUM(git05) INTO l_amt FROM git_file,gir_file
             #  WHERE git01 = gir.gir01 AND git02 = tmp.aag01
             #    AND git06 = tm.y1 AND git07 BETWEEN tm.m1 AND tm.m2
             #    AND git01 = gir01 AND gir04 = 'N'
             # IF cl_null(l_amt) THEN LET l_amt = 0 END IF
             # SELECT SUM(git05) INTO l_amt1 FROM git_file,gir_file             
             #  WHERE git01 = gir.gir01 AND git02 = tmp.aag01                   
             #    AND git06 = g_yy2 AND git07 BETWEEN tm.m1 AND tm.m2           
             #    AND git01 = gir01 AND gir04 = 'N'                             
             # IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
               SELECT SUM(gio05) INTO l_amt FROM gio_file,gir_file
                WHERE gio01 = gir.gir01 AND gio02 = tmp.aag01
                  AND gio06 = tm.y1 AND gio07 BETWEEN tm.m1 AND tm.m2
                  AND gio01 = gir01 AND gir04 = 'N'
                  AND gio00 = tm.b                                            #TQC-C70083  add
               IF cl_null(l_amt) THEN LET l_amt = 0 END IF
               SELECT SUM(gio05) INTO l_amt1 FROM gio_file,gir_file             
                WHERE gio01 = gir.gir01 AND gio02 = tmp.aag01                   
                  AND gio06 = g_yy2 AND gio07 BETWEEN tm.m1 AND tm.m2           
                  AND gio01 = gir01 AND gir04 = 'N'        
                  AND gio00 = tm.b                                            #TQC-C70083  add                     
               IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
             #FUN-970068---End                             
               IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
             WHEN '5'  #借方異動
               SELECT SUM(aah04) INTO l_amt FROM aah_file
                WHERE aah00=tm.b AND aah01=tmp.aag01
                    AND aah02=tm.y1 AND aah03 BETWEEN tm.m1 AND tm.m2
               IF cl_null(l_amt) THEN LET l_amt = 0 END IF
               SELECT SUM(aah04) INTO l_amt1 FROM aah_file                      
                WHERE aah00=tm.b AND aah01=tmp.aag01                            
                    AND aah02=g_yy2 AND aah03 BETWEEN tm.m1 AND tm.m2           
               IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
             WHEN '6'  #貸方異動
               SELECT SUM(aah05) INTO l_amt FROM aah_file
                WHERE aah00=tm.b AND aah01=tmp.aag01
                    AND aah02=tm.y1 AND aah03 BETWEEN tm.m1 AND tm.m2
               IF cl_null(l_amt) THEN LET l_amt = 0 END IF
               SELECT SUM(aah05) INTO l_amt1 FROM aah_file                      
                WHERE aah00=tm.b AND aah01=tmp.aag01                            
                    AND aah02=g_yy2 AND aah03 BETWEEN tm.m1 AND tm.m2           
               IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
           END CASE
           #若為減項
         # IF tmp.gis03 = '-' THEN LET l_amt  = l_amt * -1 END IF  #FUN-970068
           IF tmp.gin03 = '-' THEN LET l_amt  = l_amt * -1 END IF  #FUN-970068
           LET l_amt_s = l_amt_s + l_amt
         # IF tmp.gis03 = '-' THEN LET l_amt1  = l_amt1 * -1 END IF #FUN-970068             
           IF tmp.gin03 = '-' THEN LET l_amt1  = l_amt1 * -1 END IF #FUN-970068          
           LET l_amt_s1 = l_amt_s1 + l_amt1 
         END FOREACH
 
         IF l_amt_s = 0 AND l_amt_s1 = 0 AND tm.c = 'N' THEN
            CONTINUE FOREACH
         END IF
         #計算投資活動產生之淨現金
         LET l_sub_amt = l_sub_amt + l_amt_s
         LET l_amt_s = l_amt_s*tm.q/g_unit       #依匯率及單位換算
         INITIALIZE g_pr_ar[g_rec_b].* TO NULL
         LET g_pr_ar[g_rec_b].line = g_rec_b
         LET g_pr_ar[g_rec_b].gir02 = 8 SPACES,gir.gir02
         LET g_pr_ar[g_rec_b].gir05= gir.gir05
         IF l_amt_s >= 0 THEN
            LET g_pr_ar[g_rec_b].sum1 = cl_numfor(l_amt_s,20,tm.e)
         ELSE
            CALL q940_str(l_amt_s,l_str) RETURNING l_str
            LET g_pr_ar[g_rec_b].sum1 = l_str CLIPPED,")"
         END IF
 
         LET l_sub_amt1 = l_sub_amt1 + l_amt_s1                                 
         LET l_amt_s1 = l_amt_s1*tm.q/g_unit       #依匯率及單位換算            
         IF l_amt_s1 >= 0 THEN                                                  
            LET g_pr_ar[g_rec_b].sum2 = cl_numfor(l_amt_s1,20,tm.e)                         
         ELSE                                                                   
            CALL q940_str(l_amt_s1,l_str) RETURNING l_str                       
            LET g_pr_ar[g_rec_b].sum2 = l_str CLIPPED,")"
         END IF
         LET g_rec_b = g_rec_b + 1
      END FOREACH
 
      LET l_tot_amt = l_tot_amt + l_sub_amt  #計算本期現金淨增數
      INITIALIZE g_pr_ar[g_rec_b].* TO NULL
      LET g_pr_ar[g_rec_b].line = g_rec_b
      LET g_pr_ar[g_rec_b].gir02 = g_x[22]
      LET l_sub_amt = l_sub_amt*tm.q/g_unit  #依匯率及單位換算
      IF l_sub_amt >= 0 THEN
         LET g_pr_ar[g_rec_b].sum1 = cl_numfor(l_sub_amt,20,tm.e)
      ELSE
         CALL q940_str(l_sub_amt,l_str) RETURNING l_str
         LET g_pr_ar[g_rec_b].sum1 = l_str CLIPPED,')' 
      END IF
 
      LET l_tot_amt1 = l_tot_amt1 + l_sub_amt1  #計算本期現金凈增數             
      LET l_sub_amt1 = l_sub_amt1*tm.q/g_unit  #依匯率及單位換算                
      IF l_sub_amt1 >= 0 THEN                                                   
         LET g_pr_ar[g_rec_b].sum2 = cl_numfor(l_sub_amt1,20,tm.e)                          
      ELSE                                                                      
         CALL q940_str(l_sub_amt1,l_str) RETURNING l_str                        
         LET g_pr_ar[g_rec_b].sum2 = l_str CLIPPED,')'
      END IF                                                                    
      LET g_rec_b = g_rec_b + 1
      LET l_sub_amt = 0
      LET l_amt_s = 0
      LET l_sub_amt1 = 0                                                        
      LET l_amt_s1 = 0 
 
      #-------------------理財活動之現金流量------------------------------
      #理財活動之現金流量
      INITIALIZE g_pr_ar[g_rec_b].* TO NULL
      LET g_pr_ar[g_rec_b].line = g_rec_b
      LET g_pr_ar[g_rec_b].gir02 = g_x[23]
      LET g_rec_b = g_rec_b + 1
 
      LET l_amt = 0
      LET l_amt1 = 0
      LET l_sql="SELECT gir01,gir02,gir05 FROM gir_file ",
                " WHERE gir03 = '3' AND gir04='N'"
      PREPARE q940_gir_p3 FROM l_sql
      DECLARE q940_gir_cs3 CURSOR FOR q940_gir_p3
 
     #FUN-970068---Begin
     #LET l_sql="SELECT aag01,aag02,gis03,gis04 ",
     #          " FROM aag_file,gis_file,gir_file",
     #          " WHERE aag01=gis02 AND gis01=gir01 ",
     #          "   AND aag00=gis00 AND aag00 = '",tm.b,"' ",  #No.FUN-740020
     #          "   AND gir04='N' AND gis01 = ? "
      LET l_sql="SELECT aag01,aag02,gin03,gin04 ",
                " FROM aag_file,gin_file,gir_file",
                " WHERE aag01=gin02 AND gin01=gir01 ",
                "   AND aag00=gin00 AND aag00 = '",tm.b,"' ",  
                "   AND gir04='N' AND gin01 = ? " 
     #FUN-970068---End
      PREPARE q940_p5 FROM l_sql
      DECLARE q940_cu5 CURSOR FOR q940_p5
      FOREACH q940_gir_cs3 INTO gir.*
         LET l_amt_s = 0
         LET l_amt_s1 = 0
         FOREACH q940_cu5 USING gir.gir01 INTO tmp.*
         # CASE tmp.gis04 #FUN-970068
           CASE tmp.gin04 #FUN-970068
             WHEN '1'
               CALL q940_aah(tmp.aag01,tm.y2,tm.m2,l_amt)
                           RETURNING l_amt
               IF cl_null(l_amt) THEN LET l_amt = 0 END IF
               CALL q940_aah(tmp.aag01,g_yy2,tm.m2,l_amt1)                      
                           RETURNING l_amt1                                     
               IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF 
             WHEN '2'
               CALL q940_aah2(tmp.aag01,l_last_y,l_last_m) RETURNING l_amt
               CALL q940_aah2(tmp.aag01,l_last_y1,l_last_m1) RETURNING l_amt1 
             WHEN '3'
               CALL q940_aah2(tmp.aag01,tm.y2,tm.m2) RETURNING l_amt
               CALL q940_aah2(tmp.aag01,g_yy2,tm.m2) RETURNING l_amt1
             WHEN '4'
             #FUN-970068---Begin
             # SELECT SUM(git05) INTO l_amt FROM git_file,gir_file
             #  WHERE git01 = gir.gir01 AND git02 = tmp.aag01
             #    AND git06 = tm.y1 AND git07 BETWEEN tm.m1 AND tm.m2
             #    AND git01 = gir01 AND gir04 = 'N'
             # IF cl_null(l_amt) THEN LET l_amt = 0 END IF
             # SELECT SUM(git05) INTO l_amt1 FROM git_file,gir_file             
             #  WHERE git01 = gir.gir01 AND git02 = tmp.aag01                   
             #    AND git06 = g_yy2 AND git07 BETWEEN tm.m1 AND tm.m2           
             #    AND git01 = gir01 AND gir04 = 'N'                             
             # IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
               SELECT SUM(gio05) INTO l_amt FROM gio_file,gir_file
                WHERE gio01 = gir.gir01 AND gio02 = tmp.aag01
                  AND gio06 = tm.y1 AND gio07 BETWEEN tm.m1 AND tm.m2
                  AND gio01 = gir01 AND gir04 = 'N'
                  AND gio00 = tm.b                                            #TQC-C70083  add
               IF cl_null(l_amt) THEN LET l_amt = 0 END IF
               SELECT SUM(gio05) INTO l_amt1 FROM gio_file,gir_file             
                WHERE gio01 = gir.gir01 AND gio02 = tmp.aag01                   
                  AND gio06 = g_yy2 AND gio07 BETWEEN tm.m1 AND tm.m2           
                  AND gio01 = gir01 AND gir04 = 'N'                             
                  AND gio00 = tm.b                                            #TQC-C70083  add
               IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
             #FUN-970068---End
             WHEN '5'  #借方異動
               SELECT SUM(aah04) INTO l_amt FROM aah_file
                WHERE aah00=tm.b AND aah01=tmp.aag01
                    AND aah02=tm.y1 AND aah03 BETWEEN tm.m1 AND tm.m2
               IF cl_null(l_amt) THEN LET l_amt = 0 END IF
               SELECT SUM(aah04) INTO l_amt1 FROM aah_file                      
                WHERE aah00=tm.b AND aah01=tmp.aag01                            
                    AND aah02=g_yy2 AND aah03 BETWEEN tm.m1 AND tm.m2           
               IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
             WHEN '6'  #貸方異動
               SELECT SUM(aah05) INTO l_amt FROM aah_file
                WHERE aah00=tm.b AND aah01=tmp.aag01
                    AND aah02=tm.y1 AND aah03 BETWEEN tm.m1 AND tm.m2
               IF cl_null(l_amt) THEN LET l_amt = 0 END IF
               SELECT SUM(aah05) INTO l_amt1 FROM aah_file                      
                WHERE aah00=tm.b AND aah01=tmp.aag01                            
                    AND aah02=g_yy2 AND aah03 BETWEEN tm.m1 AND tm.m2           
               IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF 
           END CASE
           #若為減項
         # IF tmp.gis03 = '-' THEN LET l_amt  = l_amt * -1 END IF  #FUN-970068
           IF tmp.gin03 = '-' THEN LET l_amt  = l_amt * -1 END IF  #FUN-970068
           LET l_amt_s = l_amt_s + l_amt
         # IF tmp.gis03 = '-' THEN LET l_amt1  = l_amt1 * -1 END IF #FUN-970068           
           IF tmp.gin03 = '-' THEN LET l_amt1  = l_amt1 * -1 END IF #FUN-970068     
           LET l_amt_s1 = l_amt_s1 + l_amt1
         END FOREACH
         IF l_amt_s = 0 AND l_amt_s1 = 0 AND tm.c = 'N' THEN
            CONTINUE FOREACH
         END IF
         #計算理財活動產生之淨現金
         LET l_sub_amt = l_sub_amt + l_amt_s
         INITIALIZE g_pr_ar[g_rec_b].* TO NULL
         LET g_pr_ar[g_rec_b].line = g_rec_b
         LET g_pr_ar[g_rec_b].gir02 = 8 SPACES,gir.gir02
         LET g_pr_ar[g_rec_b].gir05= gir.gir05
         LET l_amt_s= l_amt_s*tm.q/g_unit       #依匯率及單位換算
         IF l_amt_s >= 0 THEN
            LET g_pr_ar[g_rec_b].sum1 = cl_numfor(l_amt_s,20,tm.e)
         ELSE
            CALL q940_str(l_amt_s,l_str) RETURNING l_str
            LET g_pr_ar[g_rec_b].sum1 = l_str CLIPPED,")"
         END IF
 
         #計算理財活動產生之凈現金                                              
         LET l_sub_amt1 = l_sub_amt1 + l_amt_s1                                 
         LET l_amt_s1= l_amt_s1*tm.q/g_unit       #依匯率及單位換算             
         IF l_amt_s1 >= 0 THEN                                                  
            LET g_pr_ar[g_rec_b].sum2 = cl_numfor(l_amt_s1,20,tm.e)                         
         ELSE                                                                   
            CALL q940_str(l_amt_s1,l_str) RETURNING l_str                       
            LET g_pr_ar[g_rec_b].sum2 = l_str CLIPPED,")"
         END IF
         LET g_rec_b = g_rec_b + 1
      END FOREACH
 
      LET l_tot_amt = l_tot_amt + l_sub_amt  #計算本期現金淨增數
      INITIALIZE g_pr_ar[g_rec_b].* TO NULL
      LET g_pr_ar[g_rec_b].line = g_rec_b
      LET g_pr_ar[g_rec_b].gir02 = g_x[24]
      LET l_sub_amt = l_sub_amt*tm.q/g_unit  #依匯率及單位換算
      IF l_sub_amt >= 0 THEN
         LET g_pr_ar[g_rec_b].sum1 = cl_numfor(l_sub_amt,20,tm.e)
      ELSE
         CALL q940_str(l_sub_amt,l_str) RETURNING l_str
         LET g_pr_ar[g_rec_b].sum1 = l_str CLIPPED,')'
      END IF
 
      LET l_tot_amt1 = l_tot_amt1 + l_sub_amt1  #計算本期現金凈增數             
      LET l_sub_amt1 = l_sub_amt1*tm.q/g_unit  #依匯率及單位換算                
      IF l_sub_amt1 >= 0 THEN                                                   
         LET g_pr_ar[g_rec_b].sum2 = cl_numfor(l_sub_amt1,20,tm.e)                          
      ELSE                                                                      
         CALL q940_str(l_sub_amt1,l_str) RETURNING l_str                        
         LET g_pr_ar[g_rec_b].sum2 = l_str CLIPPED,')'
      END IF                                                                    
      LET g_rec_b = g_rec_b + 1
 
##########################################################################
      INITIALIZE g_pr_ar[g_rec_b].* TO NULL
      LET g_pr_ar[g_rec_b].line = g_rec_b
      LET g_pr_ar[g_rec_b].gir02 = g_x[25]
      LET l_amt = l_tot_amt                  #本期現金淨增數
      LET l_amt = l_amt*tm.q/g_unit          #依匯率及單位換算
      IF l_amt >=0 THEN
         LET g_pr_ar[g_rec_b].sum1 = cl_numfor(l_amt,20,tm.e)
      ELSE
         CALL q940_str(l_amt,l_str) RETURNING l_str
         LET g_pr_ar[g_rec_b].sum1 = l_str CLIPPED,')'
      END IF
 
      LET l_amt1 = l_tot_amt1                  #本期現金凈增數                  
      LET l_amt1 = l_amt1*tm.q/g_unit          #依匯率及單位換算                
      IF l_amt1 >=0 THEN                                                        
         LET g_pr_ar[g_rec_b].sum2 = cl_numfor(l_amt1,20,tm.e)                              
      ELSE                                                                      
         CALL q940_str(l_amt1,l_str) RETURNING l_str                            
         LET g_pr_ar[g_rec_b].sum2 = l_str CLIPPED,')'
      END IF                                                                    
      LET g_rec_b = g_rec_b + 1                                                 
                    
      #-------------------期初現金及約當現金餘額 -------------------------
      LET l_amt = 0
      LET l_amt1 = 0
      LET l_sql="SELECT gir01,gir02 FROM gir_file ",
                " WHERE gir03 = '4' AND gir04='N'"
      PREPARE q940_gir_p4 FROM l_sql
      DECLARE q940_gir_cs4 CURSOR FOR q940_gir_p4
 
    #FUN-970068---Begin
    # LET l_sql="SELECT aag01,aag02,gis03,gis04 ",
    #           " FROM aag_file,gis_file,gir_file",
    #           " WHERE aag01=gis02 AND gir01=gis01 ",
    #           "   AND aag00=gis00 AND aag00 = '",tm.b,"' ",  #No.FUN-740020
    #           "  AND gir04='N' AND gis01 = ? "
      LET l_sql="SELECT aag01,aag02,gin03,gin04 ",
                " FROM aag_file,gin_file,gir_file",
                " WHERE aag01=gin02 AND gir01=gin01 ",
                "   AND aag00=gin00 AND aag00 = '",tm.b,"' ",  
                "  AND gir04='N' AND gin01 = ? "
    #FUN-970068---End
      PREPARE q940_p6 FROM l_sql
      DECLARE q940_cu6 CURSOR FOR q940_p6
      FOREACH q940_gir_cs4 INTO gir.*
         LET l_amt_s = 0
         LET l_amt_s1 = 0
         FOREACH q940_cu6 USING gir.gir01 INTO tmp.*
         # CASE tmp.gis04  #FUN-970068
           CASE tmp.gin04  #FUN-970068
             WHEN '1'
               CALL q940_aah(tmp.aag01,tm.y2,tm.m2,l_amt)
                           RETURNING l_amt
               IF cl_null(l_amt) THEN LET l_amt = 0 END IF
               CALL q940_aah(tmp.aag01,g_yy2,tm.m2,l_amt1)                      
                           RETURNING l_amt1                                     
               IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
             WHEN '2'
               CALL q940_aah2(tmp.aag01,l_last_y,l_last_m) RETURNING l_amt
               IF cl_null(l_amt) THEN LET l_amt = 0 END IF
               CALL q940_aah2(tmp.aag01,l_last_y1,l_last_m1) RETURNING l_amt1   
               IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF 
             WHEN '3'
               CALL q940_aah2(tmp.aag01,tm.y2,tm.m2) RETURNING l_amt
               IF cl_null(l_amt) THEN LET l_amt = 0 END IF
               CALL q940_aah2(tmp.aag01,g_yy2,tm.m2) RETURNING l_amt1           
               IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
             WHEN '4'
             #FUN-970068---Begin
             # SELECT SUM(git05) INTO l_amt FROM git_file,gir_file
             #  WHERE git01 = gir.gir01 AND git02 = tmp.aag01
             #    AND git06 = tm.y1 AND git07 BETWEEN tm.m1 AND tm.m2
             #    AND git01 = gir01 AND gir04 = 'N'
             # IF cl_null(l_amt) THEN LET l_amt = 0 END IF
             # SELECT SUM(git05) INTO l_amt1 FROM git_file,gir_file             
             #  WHERE git01 = gir.gir01 AND git02 = tmp.aag01                   
             #    AND git06 = g_yy2 AND git07 BETWEEN tm.m1 AND tm.m2           
             #    AND git01 = gir01 AND gir04 = 'N'                             
             # IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
               SELECT SUM(gio05) INTO l_amt FROM gio_file,gir_file
                WHERE gio01 = gir.gir01 AND gio02 = tmp.aag01
                  AND gio06 = tm.y1 AND gio07 BETWEEN tm.m1 AND tm.m2
                  AND gio01 = gir01 AND gir04 = 'N'
                  AND gio00 = tm.b                                            #TQC-C70083  add
               IF cl_null(l_amt) THEN LET l_amt = 0 END IF
               SELECT SUM(gio05) INTO l_amt1 FROM gio_file,gir_file             
                WHERE gio01 = gir.gir01 AND gio02 = tmp.aag01                   
                  AND gio06 = g_yy2 AND gio07 BETWEEN tm.m1 AND tm.m2           
                  AND gio01 = gir01 AND gir04 = 'N'                             
                  AND gio00 = tm.b                                            #TQC-C70083  add
               IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF 
             #FUN-970068--End
             WHEN '5'  #借方異動
               SELECT SUM(aah04) INTO l_amt FROM aah_file
                WHERE aah00=tm.b AND aah01=tmp.aag01
                    AND aah02=tm.y1 AND aah03 BETWEEN tm.m1 AND tm.m2
               IF cl_null(l_amt) THEN LET l_amt = 0 END IF
               SELECT SUM(aah04) INTO l_amt1 FROM aah_file                      
                WHERE aah00=tm.b AND aah01=tmp.aag01                            
                    AND aah02=g_yy2 AND aah03 BETWEEN tm.m1 AND tm.m2           
               IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF 
             WHEN '6'  #貸方異動
               SELECT SUM(aah05) INTO l_amt FROM aah_file
                WHERE aah00=tm.b AND aah01=tmp.aag01
                    AND aah02=tm.y1 AND aah03 BETWEEN tm.m1 AND tm.m2
               IF cl_null(l_amt) THEN LET l_amt = 0 END IF
               SELECT SUM(aah05) INTO l_amt1 FROM aah_file                      
                WHERE aah00=tm.b AND aah01=tmp.aag01                            
                    AND aah02=g_yy2 AND aah03 BETWEEN tm.m1 AND tm.m2           
               IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
           END CASE
           #若為減項
         # IF tmp.gis03 = '-' THEN LET l_amt  = l_amt * -1 END IF  #FUN-970068
           IF tmp.gin03 = '-' THEN LET l_amt  = l_amt * -1 END IF  #FUN-970068
           LET l_amt_s = l_amt_s + l_amt
         # IF tmp.gis03 = '-' THEN LET l_amt1  = l_amt1 * -1 END IF #FUN-970068            
           IF tmp.gin03 = '-' THEN LET l_amt1  = l_amt1 * -1 END IF #FUN-970068         
           LET l_amt_s1 = l_amt_s1 + l_amt1
         END FOREACH
         IF l_amt_s = 0 AND l_amt_s1 = 0 AND tm.c = 'N' THEN
            CONTINUE FOREACH
         END IF
         INITIALIZE g_pr_ar[g_rec_b].* TO NULL
         LET g_pr_ar[g_rec_b].line = g_rec_b
         LET g_pr_ar[g_rec_b].gir02 = 8 SPACES,gir.gir02
         LET g_pr_ar[g_rec_b].gir05 = gir.gir05
         LET l_amt_s= l_amt_s*tm.q/g_unit       #依匯率及單位換算
         LET l_this  = l_amt_s
         IF l_amt_s >= 0 THEN
            LET g_pr_ar[g_rec_b].sum1 = cl_numfor(l_amt_s,20,tm.e)
         ELSE
            CALL q940_str(l_amt_s,l_str) RETURNING l_str
            LET g_pr_ar[g_rec_b].sum1 = l_str CLIPPED,")"
         END IF
 
         LET l_amt_s1= l_amt_s1*tm.q/g_unit       #依匯率及單位換算             
         LET l_this1  = l_amt_s1                                                
         IF l_amt_s1 >= 0 THEN                                                  
            LET g_pr_ar[g_rec_b].sum2 = cl_numfor(l_amt_s1,20,tm.e)                         
         ELSE                                                                   
            CALL q940_str(l_amt_s1,l_str) RETURNING l_str                       
            LET g_pr_ar[g_rec_b].sum2 = l_str CLIPPED,")"
         END IF 
         LET g_rec_b = g_rec_b + 1
      END FOREACH
 
      #--------------------期未現金及約當現金餘額---------------------
      INITIALIZE gir.* TO NULL
      LET l_amt = 0
      LET l_amt1 = 0
      LET l_sql="SELECT gir01,gir02,gir05 FROM gir_file ",
                " WHERE gir03 = '5' AND gir04='N'"
      PREPARE q940_gir_p5 FROM l_sql
      DECLARE q940_gir_cs5 CURSOR FOR q940_gir_p5
 
     #FUN-970068---Begin
     #LET l_sql="SELECT aag01,aag02,gis03,gis04 ",
     #          " FROM aag_file,gis_file,gir_file",
     #          " WHERE aag01=gis02 AND gir01=gis01 ",
     #          "   AND aag00=gis00 AND aag00 = '",tm.b,"' ",  #No.FUN-740020
     #          "   AND gir04='N' AND gis01 = ? "
      LET l_sql="SELECT aag01,aag02,gin03,gin04 ",
                " FROM aag_file,gin_file,gir_file",
                " WHERE aag01=gin02 AND gir01=gis01 ",
                "   AND aag00=gin00 AND aag00 = '",tm.b,"' ",  
                "   AND gir04='N' AND gin01 = ? "
     #FUN-970068---End
      PREPARE q940_p7 FROM l_sql
      DECLARE q940_cu7 CURSOR FOR q940_p7
      FOREACH q940_gir_cs5 INTO gir.*
         LET l_amt_s = 0
         LET l_amt_s1 = 0
         FOREACH q940_cu7 USING gir.gir01 INTO tmp.*
         # CASE tmp.gis04  #FUN-970068
           CASE tmp.gin04  #FUN-970068
             WHEN '1'
               CALL q940_aah(tmp.aag01,tm.y2,tm.m2,l_amt)
                           RETURNING l_amt
               IF cl_null(l_amt) THEN LET l_amt = 0 END IF
               CALL q940_aah(tmp.aag01,g_yy2,tm.m2,l_amt1)                      
                           RETURNING l_amt1                                     
               IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
             WHEN '2'
               CALL q940_aah2(tmp.aag01,l_last_y,l_last_m) RETURNING l_amt
               IF cl_null(l_amt) THEN LET l_amt = 0 END IF
               CALL q940_aah2(tmp.aag01,l_last_y1,l_last_m1) RETURNING l_amt1   
               IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
             WHEN '3'
               CALL q940_aah2(tmp.aag01,tm.y2,tm.m2) RETURNING l_amt
               IF cl_null(l_amt) THEN LET l_amt = 0 END IF
               CALL q940_aah2(tmp.aag01,g_yy2,tm.m2) RETURNING l_amt1           
               IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
             WHEN '4'
             #FUN-970068---Begin
             # SELECT SUM(git05) INTO l_amt FROM git_file,gir_file
             #  WHERE git01 = gir.gir01 AND git02 = tmp.aag01
             #    AND git06 = tm.y1 AND git07 BETWEEN tm.m1 AND tm.m2
             #    AND git01 = gir01 AND gir04 = 'N'
             # IF cl_null(l_amt) THEN LET l_amt = 0 END IF
             # SELECT SUM(git05) INTO l_amt1 FROM git_file,gir_file             
             #  WHERE git01 = gir.gir01 AND git02 = tmp.aag01                   
             #    AND git06 = g_yy2 AND git07 BETWEEN tm.m1 AND tm.m2           
             #    AND git01 = gir01 AND gir04 = 'N'                             
             # IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF 
               SELECT SUM(gio05) INTO l_amt FROM gio_file,gir_file
                WHERE gio01 = gir.gir01 AND gio02 = tmp.aag01
                  AND gio06 = tm.y1 AND gio07 BETWEEN tm.m1 AND tm.m2
                  AND gio01 = gir01 AND gir04 = 'N'
                  AND gio00 = tm.b                                            #TQC-C70083  add
               IF cl_null(l_amt) THEN LET l_amt = 0 END IF
               #SELECT SUM(gio05) INTO l_amt1 FROM git_file,gir_file          #TQC-C70083  mark
               SELECT SUM(gio05) INTO l_amt1 FROM gio_file,gir_file           #TQC-C70083  add
                WHERE gio01 = gir.gir01 AND gio02 = tmp.aag01                   
                  AND gio06 = g_yy2 AND gio07 BETWEEN tm.m1 AND tm.m2           
                  AND gio01 = gir01 AND gir04 = 'N'                             
                  AND gio00 = tm.b                                            #TQC-C70083  add
               IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
             #FUN-970068---End 
             WHEN '5'  #借方異動
               SELECT SUM(aah04) INTO l_amt FROM aah_file
                WHERE aah00=tm.b AND aah01=tmp.aag01
                    AND aah02=tm.y1 AND aah03 BETWEEN tm.m1 AND tm.m2
               IF cl_null(l_amt) THEN LET l_amt = 0 END IF
               SELECT SUM(aah04) INTO l_amt1 FROM aah_file                      
                WHERE aah00=tm.b AND aah01=tmp.aag01                            
                    AND aah02=g_yy2 AND aah03 BETWEEN tm.m1 AND tm.m2           
               IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
             WHEN '6'  #貸方異動
               SELECT SUM(aah05) INTO l_amt FROM aah_file
                WHERE aah00=tm.b AND aah01=tmp.aag01
                    AND aah02=tm.y1 AND aah03 BETWEEN tm.m1 AND tm.m2
               IF cl_null(l_amt) THEN LET l_amt = 0 END IF
               SELECT SUM(aah05) INTO l_amt1 FROM aah_file                      
                WHERE aah00=tm.b AND aah01=tmp.aag01                            
                    AND aah02=g_yy2 AND aah03 BETWEEN tm.m1 AND tm.m2           
               IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
           END CASE
           #若為減項
         # IF tmp.gis03 = '-' THEN LET l_amt  = l_amt * -1 END IF  #FUN-970068
           IF tmp.gin03 = '-' THEN LET l_amt  = l_amt * -1 END IF  #FUN-970068
           LET l_amt_s = l_amt_s + l_amt
         # IF tmp.gis03 = '-' THEN LET l_amt1  = l_amt1 * -1 END IF  #FUN-970068             
           IF tmp.gin03 = '-' THEN LET l_amt1  = l_amt1 * -1 END IF  #FUN-970068            
           LET l_amt_s1 = l_amt_s1 + l_amt1
         END FOREACH
         IF l_amt_s = 0 AND l_amt_s1 = 0 AND tm.c = 'N' THEN
            CONTINUE FOREACH
         END IF
         INITIALIZE g_pr_ar[g_rec_b].* TO NULL
         LET g_pr_ar[g_rec_b].line = g_rec_b
         LET g_pr_ar[g_rec_b].gir02 = 8 SPACES,gir.gir02
         LET g_pr_ar[g_rec_b].gir05 = gir.gir05
         LET l_amt_s= l_amt_s*tm.q/g_unit       #依匯率及單位換算
         LET l_last = l_amt_s
         IF l_amt_s >= 0 THEN
            LET g_pr_ar[g_rec_b].sum1 = cl_numfor(l_amt_s,20,tm.e)
         ELSE
            CALL q940_str(l_amt_s,l_str) RETURNING l_str
            LET g_pr_ar[g_rec_b].sum1 = l_str CLIPPED,")"
         END IF
         LET l_amt_s1= l_amt_s1*tm.q/g_unit       #依匯率及單位換算             
         LET l_last1 = l_amt_s1                                                 
         IF l_amt_s1 >= 0 THEN                                                  
            LET g_pr_ar[g_rec_b].sum2 = cl_numfor(l_amt_s1,20,tm.e)                         
         ELSE                                                                   
            CALL q940_str(l_amt_s1,l_str) RETURNING l_str                       
            LET g_pr_ar[g_rec_b].sum2 = l_str CLIPPED,")"
         END IF
         LET g_rec_b = g_rec_b + 1
      END FOREACH
 
      LET l_amt = l_tot_amt                  #本期現金淨增數
      LET l_amt = l_amt*tm.q/g_unit          #依匯率及單位換算
      LET l_amt1 = l_tot_amt1                  #本期現金凈增數                  
      LET l_amt1 = l_amt1*tm.q/g_unit          #依匯率及單位換算                
 
      #若期未餘額 !=期初餘額+本期現金淨增數 show 緊告訊息 ....
      IF l_last != l_this  + l_amt OR
         l_last1 != l_this1  + l_amt1 THEN                                      
 
         LET l_diff = l_last - (l_this  + l_amt)
         LET l_diff1 = l_last1 - (l_this1  + l_amt1)                            
 
         INITIALIZE g_pr_ar[g_rec_b].* TO NULL
         LET g_pr_ar[g_rec_b].line = g_rec_b
         LET g_pr_ar[g_rec_b].gir02 = g_x[35] CLIPPED,g_x[36] CLIPPED
         LET g_pr_ar[g_rec_b].sum1 = cl_numfor(l_diff,20,tm.e)
         LET g_pr_ar[g_rec_b].sum2 = cl_numfor(l_diff1,20,tm.e)
         LET g_rec_b = g_rec_b + 1
      END IF
                                                                                
      IF tm.s = 'Y' THEN
         INITIALIZE g_pr_ar[g_rec_b].* TO NULL
         LET g_pr_ar[g_rec_b].line = g_rec_b
         LET g_pr_ar[g_rec_b].gir02 = g_x[34]
         LET g_rec_b = g_rec_b + 1 
 
         LET g_cnt = 1
         DECLARE q940_gim CURSOR FOR
          SELECT gim02,gim03,gim01 FROM gim_file  
           WHERE gim00='N'
             AND gim04=tm.y1  #No:FUN-B80180 add
             AND gim05=tm.m2  #No:FUN-B80180 add
         FOREACH q940_gim INTO g_gim[g_cnt].*
           IF SQLCA.sqlcode THEN
               CALL cl_err('foreach:',SQLCA.sqlcode,1)  
               EXIT FOREACH
           END IF
           LET g_cnt = g_cnt + 1
           IF g_cnt > g_max_rec THEN
              CALL cl_err('','9035',0)
              EXIT FOREACH
           END IF
         END FOREACH
         LET g_cnt = g_cnt - 1
         FOR i = 1 TO g_cnt
             INITIALIZE g_pr_ar[g_rec_b].* TO NULL
             LET g_pr_ar[g_rec_b].line = g_rec_b
             LET g_pr_ar[g_rec_b].gir02 = 8 SPACES,g_gim[i].gim02
             LET g_pr_ar[g_rec_b].gir05 = g_gim[i].gim01
             LET g_pr_ar[g_rec_b].sum1 = g_gim[i].gim03
             LET g_rec_b = g_rec_b + 1
         END FOR
      END IF
 
   ON LAST ROW
      LET g_rec_b = g_rec_b - 1
 
END REPORT
 
FUNCTION q940_aah(p_aah01,p_aah02,p_aah03,p_value)
   DEFINE p_aah01     LIKE aah_file.aah01,
          p_aah02     LIKE aah_file.aah02,
          p_aah03     LIKE aah_file.aah03,
          p_value     LIKE aah_file.aah04      #No.FUN-680098  dec(20,6)
   DEFINE l_type      LIKE aag_file.aag06      #No.FUN-680098   VARCHAR(1)
 
   LET p_value = 0
   SELECT aag06 INTO l_type FROM aag_file WHERE aag01=p_aah01
                                            AND aag00= tm.b  #No.FUN-740020
 
   IF l_type = '1' THEN
      SELECT SUM(aah04-aah05) INTO p_value FROM aah_file
         WHERE aah00=tm.b AND aah01=p_aah01 AND
               aah02=p_aah02 AND aah03 BETWEEN tm.m1 AND tm.m2
   ELSE
      SELECT SUM(aah05-aah04) INTO p_value FROM aah_file
         WHERE aah00=tm.b AND aah01=p_aah01 AND
               aah02=p_aah02 AND aah03 BETWEEN tm.m1 AND tm.m2
   END IF
   RETURN p_value
END FUNCTION
 
FUNCTION q940_aah2(p_aah01,p_aah02,p_aah03)
   DEFINE p_aah01     LIKE aah_file.aah01,
          p_aah02     LIKE aah_file.aah02,
          p_aah03     LIKE aah_file.aah03,
          p_value     LIKE aah_file.aah04      #No.FUN-680098   dec(20,6)
   DEFINE l_type      LIKE aag_file.aag06      #No.FUN-680098   VARCHAR(1)
 
   LET p_value = 0
   SELECT aag06 INTO l_type FROM aag_file WHERE aag01=p_aah01
                                            AND aag00=tm.b     #No.FUN-740020
 
   IF l_type = '1' THEN
      SELECT SUM(aah04-aah05) INTO p_value FROM aah_file
         WHERE aah00=tm.b AND aah01=p_aah01 AND
               aah02=p_aah02 AND aah03 <= p_aah03
   ELSE
      SELECT SUM(aah05-aah04) INTO p_value FROM aah_file
         WHERE aah00=tm.b AND aah01=p_aah01 AND
               aah02=p_aah02 AND aah03 <= p_aah03
   END IF
   IF cl_null(p_value) THEN LET p_value = 0 END IF
   RETURN p_value
END FUNCTION
 
FUNCTION q940_str(p_amt,p_str)
   DEFINE p_amt LIKE type_file.num20_6,   #No.FUN-680098  dec(20,6)
          p_str LIKE type_file.chr1000,   #No.FUN-680098  VARCHAR(21) 
          l_x   LIKE type_file.num5       #No.FUN-680098  smallint
 
   LET p_str = cl_numfor(p_amt*(-1),20,tm.e)
   FOR l_x = 1 TO 20
       IF cl_null(p_str[l_x,l_x]) THEN
           LET l_x = l_x - 1
           EXIT FOR
       END IF
   END FOR
   IF l_x != 0 THEN
      LET p_str[l_x,l_x] = '('
   ELSE
      LET p_str[1,1] = '('
   END IF
 
   RETURN p_str
 
END FUNCTION
#Patch....NO.TQC-610035 <001,002> #
 
#No.FUN-640004 --start--
REPORT q940_rep1()
   DEFINE l1_sql        LIKE type_file.chr1000 # RDSQL STATEMENT    #No.FUN-680098 VARCHAR(1000)
   DEFINE l1_last_sw    LIKE type_file.chr1    #No.FUN-680098  VARCHAR(1)
   DEFINE l1_unit       LIKE zaa_file.zaa08    #No.FUN-680098  VARCHAR(4) 
   DEFINE l1_per1       LIKE fid_file.fid03    #No.FUN-680098  dec(8,3)
   DEFINE l1_d1         LIKE type_file.num5,           #No.FUN-680098    smallint
          l1_d2         LIKE type_file.num5,           #No.FUN-680098    smallint
          l1_flag       LIKE type_file.chr1,           #No.FUN-680098    VARCHAR(1)
          l1_str        LIKE type_file.chr1000,        #No.FUN-680098    VARCHAR(21)
          l1_bdate,l1_edate   LIKE type_file.dat,      #No.FUN-680098  date
          l1_type       LIKE type_file.chr1,           #正常餘額型態(1.借餘/2.貨餘) #No.FUN-680098  VARCHAR(1)
          l1_cnt        LIKE type_file.num5,           #揭露事項筆數         #No.FUN-680098  smallint
          l1_last_y     LIKE type_file.num5,           #期初年               #No.FUN-680098  smallint
          l1_last_m     LIKE type_file.num5,           #期初月份             #No.FUN-680098  smallint
          l1_this       LIKE type_file.num20_6,        #本期餘額              #No.FUN-680098  dec(20,6)
          l1_last       LIKE type_file.num20_6,        #期初餘額              #No.FUN-680098  dec(20,6)
          l1_diff       LIKE type_file.num20_6,        #差異                  #No.FUN-680098  dec(20,6)
          l1_amt        LIKE type_file.num20_6,        #科目現金流量          #No.FUN-680098 dec(20,6)
          l1_amt_s      LIKE type_file.num20_6,        #群組現金流量          #No.FUN-680098 dec(20,6)
          l1_sub_amt    LIKE type_file.num20_6,        #各活動產生之淨現金    #No.FUN-680098 dec(20,6)
          l1_tot_amt    LIKE type_file.num20_6,        #本期現金淨增數        #No.FUN-680098 dec(20,6)
          l1_tmp_amt    LIKE type_file.num20_6         #折舊科目之合計        #No.FUN-680098 dec(20,6)
   DEFINE tmp RECORD
          aag01      LIKE aag_file.aag01,
          aag02      LIKE aag_file.aag02,
        # gis03      LIKE gis_file.gis03,  #FUN-970068
        # gis04      LIKE gis_file.gis04   #FUN-970068
          gin03      LIKE gin_file.gin03,  #FUN-970068
          gin04      LIKE gin_file.gin04   #FUN-970068
          END RECORD
   DEFINE gir RECORD                          #群組代號
          gir01      LIKE gir_file.gir01,
          gir02      LIKE gir_file.gir02
          END RECORD
   DEFINE l_gir05    LIKE gir_file.gir05      #行次
   DEFINE l_sharp    LIKE type_file.num5      #No.FUN-680098   smallint
 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  FORMAT
     PAGE HEADER
      #No.FUN-710056  --Begin
      #PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED                                                     
      #IF g_towhom IS NULL OR g_towhom = ' '                                                                                         
      #   THEN PRINT '';                                                                                                             
      #   ELSE PRINT 'TO:',g_towhom;                                                                                                 
      #END IF                                                                                                                        
      #                                                                                                                              
      #PRINT COLUMN (g_len-FGL_WIDTH(g_user CLIPPED)-6),' FROM:',g_user CLIPPED                                                              
      #PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1 ,g_x[1] CLIPPED  
      #No.FUN-710056  --End  
        #報表結構,報表名稱,幣別,單位
        CASE tm.d
             WHEN '1'  LET l1_unit = g_x[31]
             WHEN '2'  LET l1_unit = g_x[32]
             WHEN '3'  LET l1_unit = g_x[33]
             OTHERWISE LET l1_unit = ' '
        END CASE
  
      LET g_pageno = g_pageno + 1
      #製表日期,期間,頁次
      #CALL s_azm(tm.y1,tm.m1) RETURNING l1_flag,l1_bdate,l1_edate #CHI-A70007 mark
      #CHI-A70007 add --start--
      IF g_aza.aza63 = 'Y' THEN
         CALL s_azmm(tm.y1,tm.m1,g_plant,tm.b) RETURNING l1_flag,l1_bdate,l1_edate
      ELSE
         CALL s_azm(tm.y1,tm.m1) RETURNING l1_flag,l1_bdate,l1_edate
      END IF
      #CHI-A70007 add --end--
      LET l1_d1 = DAY(l1_bdate)
      #CALL s_azm(tm.y2,tm.m2) RETURNING l1_flag,l1_bdate,l1_edate #CHI-A70007 mark
      #CHI-A70007 add --start--
      IF g_aza.aza63 = 'Y' THEN
         CALL s_azmm(tm.y2,tm.m2,g_plant,tm.b) RETURNING l1_flag,l1_bdate,l1_edate
      ELSE
         CALL s_azm(tm.y2,tm.m2) RETURNING l1_flag,l1_bdate,l1_edate
      END IF
      #CHI-A70007 add --end--
      LET l1_d2 = DAY(l1_edate)
      IF tm.m1=1 THEN
         LET l1_last_y = tm.y1 - 1
         LET l1_last_m = 12
      ELSE
         LET l1_last_y = tm.y1
         LET l1_last_m = tm.m1 - 1
      END IF
      LET tm.e = 2    #取兩位小數
      SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang  #MOD-730146
      LET l1_last_sw = 'n'
      LET g_x[14] = g_x[37]
      LET g_x[21] = g_x[38]
      LET g_x[23] = g_x[39]
 
   ON EVERY ROW
      LET l1_amt = 0
      LET l1_amt_s = 0
      LET l1_this = 0
      LET l1_last = 0
      LET l1_sub_amt = 0
      LET l1_tot_amt = 0
      LET l1_tmp_amt = 0
      #補充資料
      PRINT '\"',g_x[41] CLIPPED,'\"',     #報表編號    #No.TQC-6A0080
#     PRINT '\"',g_x[41] ,'\"',     #報表編號    #No.TQC-6A0080
            '\t',
            '\"',g_company CLIPPED,'\"',  #編制單位
            '\t',
            '\"',g_ym CLIPPED,'\"',       #報告期
            '\t',
            '\"',l1_unit CLIPPED,'\"',     #貨幣單位
            '\t',
            '\"',g_x[40] CLIPPED,'\"',    #項目
            '\t','\t'
      #營業活動之現金流量
      PRINT '\"',g_x[41] CLIPPED,'\"',     #報表編號    #No.TQC-6A0080
#     PRINT '\"',g_x[41] ,'\"',     #報表編號    #No.TQC-6A0080 
            '\t',
            '\"',g_company CLIPPED,'\"',  #編制單位
            '\t',
            '\"',g_ym CLIPPED,'\"',       #報告期
            '\t',
            '\"',l1_unit CLIPPED,'\"',     #貨幣單位
            '\t',
            '\"',g_x[14] CLIPPED,'\"',    #項目
            '\t','\t'
      #---------------------本期淨利(損)------------------------------
#     CALL q940_aah(g_aaz.aaz31,tm.y1,tm.m2,l1_amt) RETURNING l1_amt #FUN-BC0027
      CALL q940_aah(g_aaa.aaa14,tm.y1,tm.m2,l1_amt) RETURNING l1_amt #FUN-BC0027
      IF cl_null(l1_amt) THEN LET l1_amt = 0 END IF
      LET l1_amt=l1_amt*-1
   #  CALL q940_aah(g_aaz.aaz31,l_last_y,l_last_m,l_last) RETURNING l1_last
   #  CALL q940_aah(g_aaz.aaz31,tm.y2-1,tm.m2,l_last) RETURNING l1_last
   #  Let l1_amt = l1_this - l1_last
      LET l1_tot_amt = l1_tot_amt + l1_amt        #計算本期現金淨增數
#     PRINT '\"',g_x[41],'\"',            #報表編號
#           '\t',
#           '\"',g_company CLIPPED,'\"',  #編制單位
#           '\t',
#           '\"',g_ym CLIPPED,'\"',       #報告期
#           '\t',
#           '\"',l1_unit CLIPPED,'\"',     #貨幣單位
#           '\t',
#           '\"',g_x[15] CLIPPED,'\"',    #項目
#           '\t',
#           '\"','\"',                    #行次
#           '\t';
#     LET l1_amt = l1_amt*tm.q/g_unit       #依匯率及單位換算
#     IF l1_amt < 0 THEN
#        LET l1_amt = l1_amt * -1
#     END IF
#     PRINT q940_numfor(l1_amt,tm.e)      #金額
#     #調整項目
#     PRINT '\"',g_x[41],'\"',            #報表編號
#           '\t',
#           '\"',g_company CLIPPED,'\"',  #編制單位
#           '\t',
#           '\"',g_ym CLIPPED,'\"',       #報告期
#           '\t',
#           '\"',l1_unit CLIPPED,'\"',    #貨幣單位
#           '\t',
#           '\"',g_x[16] CLIPPED,'\"',    #項目
#           '\t','\t'
      #-------------------------營業科目-------------------------------
      LET l1_amt = 0
      LET l1_sql="SELECT gir01,gir02 FROM gir_file ",
                " WHERE gir03 = '1' AND gir04 = 'N' ",
                " ORDER BY gir01 "
      PREPARE q940_gir_p11 FROM l1_sql
      DECLARE q940_gir_cs11 CURSOR FOR q940_gir_p11
 
     #FUN-970068---Begin
     #LET l1_sql="SELECT aag01,aag02,gis03,gis04 ",
     #          "  FROM aag_file,gis_file,gir_file",
     #          " WHERE aag01=gis02 AND gir01=gis01 ",
     #          "   AND aag00=gis00 AND aag00='",tm.b,"' ",   #No.FUN-740020
     #          "   AND gir04='N' AND gis01 = ? "
      LET l1_sql="SELECT aag01,aag02,gin03,gin04 ",
                 "  FROM aag_file,gin_file,gir_file",
                 " WHERE aag01=gin02 AND gir01=gin01 ",
                 "   AND aag00=gin00 AND aag00='",tm.b,"' ", 
                 "   AND gir04='N' AND gin01 = ? "
     #FUN-970068---End 
      PREPARE q940_p31 FROM l1_sql
      DECLARE q940_cu31 CURSOR FOR q940_p31
      FOREACH q940_gir_cs11 INTO gir.*
        LET l1_amt_s = 0
        FOREACH q940_cu31 USING gir.gir01 INTO tmp.*
         # CASE tmp.gis04  #FUN-970068
           CASE tmp.gin04  #FUN-970068
             WHEN '1'
               CALL q940_aah(tmp.aag01,tm.y2,tm.m2,l1_amt) RETURNING l1_amt
               IF cl_null(l1_amt) THEN LET l1_amt = 0 END IF
             WHEN '2'
               CALL q940_aah2(tmp.aag01,l1_last_y,l1_last_m) RETURNING l1_amt
             WHEN '3'
               CALL q940_aah2(tmp.aag01,tm.y2,tm.m2) RETURNING l1_amt
             WHEN '4'
             #FUN-970068---Begin
             # SELECT SUM(git05) INTO l1_amt FROM git_file,gir_file
             #  WHERE git01 = gir.gir01 AND git02 = tmp.aag01
#NO.MOD-5B0309 START-----------------------
             #    #AND git06 = tm.y1 AND git07 = tm.m2
             #    AND git06 = tm.y1 AND git07 BETWEEN tm.m1 AND tm.m2
#NO.MOD-5B0309 END------------------------
             #    AND git01 = gir01 AND gir04 = 'N'
               SELECT SUM(gio05) INTO l1_amt FROM gio_file,gir_file
                WHERE gio01 = gir.gir01 AND gio02 = tmp.aag01
                  AND gio06 = tm.y1 AND gio07 BETWEEN tm.m1 AND tm.m2
                  AND gio01 = gir01 AND gir04 = 'N'
                  AND gio00 = tm.b                                            #TQC-C70083  add 
             #FUN-970068---End
               IF cl_null(l1_amt) THEN LET l1_amt = 0 END IF
             WHEN '5'  #借方異動
               SELECT SUM(aah04) INTO l1_amt FROM aah_file
                WHERE aah00=tm.b AND aah01=tmp.aag01
                    AND aah02=tm.y1 AND aah03 BETWEEN tm.m1 AND tm.m2
               IF cl_null(l1_amt) THEN LET l1_amt = 0 END IF
             WHEN '6'  #貸方異動
               SELECT SUM(aah05) INTO l1_amt FROM aah_file
                WHERE aah00=tm.b AND aah01=tmp.aag01
                    AND aah02=tm.y1 AND aah03 BETWEEN tm.m1 AND tm.m2
               IF cl_null(l1_amt) THEN LET l1_amt = 0 END IF
           END CASE
           #若為減項
         # IF tmp.gis03 = '-' THEN LET l1_amt  = l1_amt * -1 END IF   #FUN-970068
           IF tmp.gin03 = '-' THEN LET l1_amt  = l1_amt * -1 END IF   #FUN-970068
           LET l1_amt_s = l1_amt_s + l1_amt
        END FOREACH
 
        IF l1_amt_s = 0 AND tm.c = 'N' THEN
           CONTINUE FOREACH
        END IF
        LET l1_sub_amt = l1_sub_amt + l1_amt_s   #計算營業活動產生之淨現金
        SELECT gir05 INTO l_gir05 FROM gir_file WHERE gir01 = gir.gir01
        IF NOT cl_null(l_gir05) THEN
           LET l_sharp = FGL_WIDTH(l_gir05)
        END IF
        PRINT '\"',g_x[41] CLIPPED,'\"',   #報表編號   #No.TQC-6A0080
#       PRINT '\"',g_x[41] ,'\"',     #報表編號    #No.TQC-6A0080 
             '\t',
             '\"',g_company CLIPPED,'\"',  #編制單位
             '\t',
             '\"',g_ym CLIPPED,'\"',       #報告期
             '\t',
             '\"',l1_unit CLIPPED,'\"',     #貨幣單位
             '\t',
             '\"',gir.gir02 CLIPPED,'\"',    #項目
             '\t';
        IF cl_null(l_gir05) THEN
           PRINT '\"','\"',                    #行次
                 '\t';
        ELSE
           CASE l_sharp
              WHEN "1"
                 PRINT '\"',l_gir05 USING '#','\"',  #行次
                       '\t';
              WHEN "2"
                 PRINT '\"',l_gir05 USING '##','\"',  #行次
                       '\t';
              WHEN "3"
                 PRINT '\"',l_gir05 USING '###','\"',  #行次
                       '\t';
              WHEN "4"
                 PRINT '\"',l_gir05 USING '####','\"',  #行次
                       '\t';
              WHEN "5"
                 PRINT '\"',l_gir05 USING '#####','\"',  #行次
                       '\t';
              OTHERWISE 
                 PRINT ;
           END CASE
        END IF
        LET l1_amt_s = l1_amt_s*tm.q/g_unit     #依匯率及單位換算
#       IF l1_amt_s < 0 THEN
#          LET l1_amt_s = l1_amt_s * -1
#       END IF
        PRINT q940_numfor(l1_amt_s,tm.e)
      END FOREACH
 
      #營業活動產生之淨現金
      LET l1_tot_amt = l1_tot_amt + l1_sub_amt  #計算本期現金淨增數
#     PRINT '\"',g_x[41],'\"',            #報表編號
#          '\t',
#          '\"',g_company CLIPPED,'\"',  #編制單位
#          '\t',
#          '\"',g_ym CLIPPED,'\"',       #報告期
#          '\t',
#          '\"',l1_unit CLIPPED,'\"',     #貨幣單位
#          '\t',
#          '\"',g_x[20] CLIPPED,'\"',    #項目
#          '\t',
#          '\"','\"',                    #行次
#          '\t';
#     LET l1_sub_amt = l1_sub_amt*tm.q/g_unit  #依匯率及單位換算
#     IF l1_sub_amt < 0 THEN
#        LET l1_sub_amt = l1_sub_amt * -1
#     END IF
#     PRINT q940_numfor(l1_sub_amt,tm.e)
      LET l1_sub_amt = 0
      LET l1_amt_s = 0
#     SKIP 1 LINE
 
      #----------------------投資活動之現金流量-----------------------
      PRINT '\"',g_x[41] CLIPPED,'\"',    #報表編號   #No.TQC-6A0080
#     PRINT '\"',g_x[41] ,'\"',     #報表編號    #No.TQC-6A0080 
           '\t',
           '\"',g_company CLIPPED,'\"',  #編制單位
           '\t',
           '\"',g_ym CLIPPED,'\"',       #報告期
           '\t',
           '\"',l1_unit CLIPPED,'\"',     #貨幣單位
           '\t',
           '\"',g_x[21] CLIPPED,'\"',    #項目
           '\t','\t'
      LET l1_amt = 0
 
      LET l1_sql="SELECT gir01,gir02 FROM gir_file ",
                " WHERE gir03 = '2' AND gir04 = 'N'"
      PREPARE q940_gir_p21 FROM l1_sql
      DECLARE q940_gir_cs21 CURSOR FOR q940_gir_p21
 
     #FUN-970068---Begin
     #LET l1_sql="SELECT aag01,aag02,gis03,gis04 ",
     #          " FROM aag_file,gis_file,gir_file",
     #          " WHERE aag01=gis02 AND gis01=gir01 ",
     #          "   AND aag00=gis00 AND aag00='",tm.b,"' ",   #No.FUN-740020
     #          "   AND gir04='N' AND gis01 = ? "
      LET l1_sql="SELECT aag01,aag02,gin03,gin04 ",
                " FROM aag_file,gin_file,gir_file",
                " WHERE aag01=gin02 AND gin01=gir01 ",
                "   AND aag00=gin00 AND aag00='",tm.b,"' ",   
                "   AND gir04='N' AND gin01 = ? " 
     #FUN-970068---Begin
      PREPARE q940_p41 FROM l1_sql
      DECLARE q940_cu41 CURSOR FOR q940_p41
      FOREACH q940_gir_cs21 INTO gir.*
 
         LET l1_amt_s = 0
         FOREACH q940_cu41 USING gir.gir01 INTO tmp.*
         # CASE tmp.gis04  #FUN-970068
           CASE tmp.gin04  #FUN-970068
             WHEN '1'
               CALL q940_aah(tmp.aag01,tm.y2,tm.m2,l1_amt)
                           RETURNING l1_amt
               IF cl_null(l1_amt) THEN LET l1_amt = 0 END IF
             WHEN '2'
               CALL q940_aah2(tmp.aag01,l1_last_y,l1_last_m) RETURNING l1_amt
             WHEN '3'
               CALL q940_aah2(tmp.aag01,tm.y2,tm.m2) RETURNING l1_amt
             WHEN '4'
             #FUN-970068---Begin
             # SELECT SUM(git05) INTO l1_amt FROM git_file,gir_file
             #  WHERE git01 = gir.gir01 AND git02 = tmp.aag01
#NO.MOD-5B0309 START---
             #    #AND git06 = tm.y1 AND git07 = tm.m2
             #    AND git06 = tm.y1 AND git07 BETWEEN tm.m1 AND tm.m2
#NO.MOD-5B0309 END----
             #    AND git01 = gir01 AND gir04 = 'N'
               SELECT SUM(gio05) INTO l1_amt FROM gio_file,gir_file
                WHERE gio01 = gir.gir01 AND gio02 = tmp.aag01
                  AND gio06 = tm.y1 AND gio07 BETWEEN tm.m1 AND tm.m2
                  AND gio01 = gir01 AND gir04 = 'N'
                  AND gio00 = tm.b                                            #TQC-C70083  add
             #FUN-970068---End
               IF cl_null(l1_amt) THEN LET l1_amt = 0 END IF
             WHEN '5'  #借方異動
               SELECT SUM(aah04) INTO l1_amt FROM aah_file
                WHERE aah00=tm.b AND aah01=tmp.aag01
                    AND aah02=tm.y1 AND aah03 BETWEEN tm.m1 AND tm.m2
               IF cl_null(l1_amt) THEN LET l1_amt = 0 END IF
             WHEN '6'  #貸方異動
               SELECT SUM(aah05) INTO l1_amt FROM aah_file
                WHERE aah00=tm.b AND aah01=tmp.aag01
                    AND aah02=tm.y1 AND aah03 BETWEEN tm.m1 AND tm.m2
               IF cl_null(l1_amt) THEN LET l1_amt = 0 END IF
 
           END CASE
           #若為減項
         # IF tmp.gis03 = '-' THEN LET l1_amt  = l1_amt * -1 END IF   #FUN-970068
           IF tmp.gin03 = '-' THEN LET l1_amt  = l1_amt * -1 END IF   #FUN-970068
           LET l1_amt_s = l1_amt_s + l1_amt
         END FOREACH
 
         IF l1_amt_s = 0 AND tm.c = 'N' THEN
            CONTINUE FOREACH
         END IF
         #計算投資活動產生之淨現金
         LET l1_sub_amt = l1_sub_amt + l1_amt_s
         SELECT gir05 INTO l_gir05 FROM gir_file WHERE gir01 = gir.gir01
         IF NOT cl_null(l_gir05) THEN
            LET l_sharp = FGL_WIDTH(l_gir05)
         END IF
         PRINT '\"',g_x[41] CLIPPED,'\"',   #報表編號     #No.TQC-6A0080
#        PRINT '\"',g_x[41] ,'\"',     #報表編號    #No.TQC-6A0080 
              '\t',
              '\"',g_company CLIPPED,'\"',  #編制單位
              '\t',
              '\"',g_ym CLIPPED,'\"',       #報告期
              '\t',
              '\"',l1_unit CLIPPED,'\"',     #貨幣單位
              '\t',
              '\"',gir.gir02 CLIPPED,'\"',    #項目
              '\t';
        IF cl_null(l_gir05) THEN
           PRINT '\"','\"',                    #行次
                 '\t';
        ELSE
           CASE l_sharp
              WHEN "1"
                 PRINT '\"',l_gir05 USING '#','\"',  #行次
                       '\t';
              WHEN "2"
                 PRINT '\"',l_gir05 USING '##','\"',  #行次
                       '\t';
              WHEN "3"
                 PRINT '\"',l_gir05 USING '###','\"',  #行次
                       '\t';
              WHEN "4"
                 PRINT '\"',l_gir05 USING '####','\"',  #行次
                       '\t';
              WHEN "5"
                 PRINT '\"',l_gir05 USING '#####','\"',  #行次
                       '\t';
              OTHERWISE 
                 PRINT ;
           END CASE
        END IF
         LET l1_amt_s = l1_amt_s*tm.q/g_unit       #依匯率及單位換算
#        IF l1_amt_s >= 0 THEN
#           LET l1_amt_s = l1_amt_s * -1
#        END IF
         PRINT q940_numfor(l1_amt_s,tm.e)
      END FOREACH
      LET l1_tot_amt = l1_tot_amt + l1_sub_amt  #計算本期現金淨增數
#     PRINT '\"',g_x[41],'\"',           #報表編號
#          '\t',
#          '\"',g_company CLIPPED,'\"',  #編制單位
#          '\t',
#          '\"',g_ym CLIPPED,'\"',       #報告期
#          '\t',
#          '\"',l1_unit CLIPPED,'\"',     #貨幣單位
#          '\t',
#          '\"',g_x[22] CLIPPED,'\"',    #項目
#          '\t',
#          '\"','\"',                    #行次
#          '\t';
#     LET l1_sub_amt = l1_sub_amt*tm.q/g_unit  #依匯率及單位換算
#     IF l1_sub_amt < 0 THEN
#        LET l1_sub_amt = l1_sub_amt * -1
#     END IF
#     PRINT COLUMN 59,q940_numfor(l1_sub_amt,tm.e)
      LET l1_sub_amt = 0
      LET l1_amt_s = 0
 
      #-------------------理財活動之現金流量------------------------------
      #理財活動之現金流量
#     SKIP 1 LINE
      PRINT '\"',g_x[41] CLIPPED,'\"',   #報表編號   #No.TQC-6A0080
#     PRINT '\"',g_x[41] ,'\"',     #報表編號    #No.TQC-6A0080 
           '\t',
           '\"',g_company CLIPPED,'\"',  #編制單位
           '\t',
           '\"',g_ym CLIPPED,'\"',       #報告期
           '\t',
           '\"',l1_unit CLIPPED,'\"',     #貨幣單位
           '\t',
           '\"',g_x[23] CLIPPED,'\"',    #項目
           '\t','\t'
      LET l1_amt = 0
      LET l1_sql="SELECT gir01,gir02 FROM gir_file ",
                " WHERE gir03 = '3' AND gir04='N'"
      PREPARE q940_gir_p31 FROM l1_sql
      DECLARE q940_gir_cs31 CURSOR FOR q940_gir_p31
 
     #FUN-970068---Begin
     #LET l1_sql="SELECT aag01,aag02,gis03,gis04 ",
     #          " FROM aag_file,gis_file,gir_file",
     #          " WHERE aag01=gis02 AND gis01=gir01 ",
     #          "   AND aag00=gis00 AND aag00='",tm.b,"' ",   #No.FUN-740020
     #          "   AND gir04='N' AND gis01 = ? "
      LET l1_sql="SELECT aag01,aag02,gin03,gin04 ",
                " FROM aag_file,gin_file,gir_file",
                " WHERE aag01=gin02 AND gin01=gir01 ",
                "   AND aag00=gin00 AND aag00='",tm.b,"' ",   
                "   AND gir04='N' AND gin01 = ? "
     #FUN-970068---Begin
      PREPARE q940_p51 FROM l1_sql
      DECLARE q940_cu51 CURSOR FOR q940_p51
      FOREACH q940_gir_cs31 INTO gir.*
         LET l1_amt_s = 0
         FOREACH q940_cu51 USING gir.gir01 INTO tmp.*
         # CASE tmp.gis04  #FUN-970068
           CASE tmp.gin04  #FUN-970068
             WHEN '1'
               CALL q940_aah(tmp.aag01,tm.y2,tm.m2,l1_amt)
                           RETURNING l1_amt
               IF cl_null(l1_amt) THEN LET l1_amt = 0 END IF
             WHEN '2'
               CALL q940_aah2(tmp.aag01,l1_last_y,l1_last_m) RETURNING l1_amt
             WHEN '3'
               CALL q940_aah2(tmp.aag01,tm.y2,tm.m2) RETURNING l1_amt
             WHEN '4'
             #FUN-970068---Begin
             # SELECT SUM(git05) INTO l1_amt FROM git_file,gir_file
             #  WHERE git01 = gir.gir01 AND git02 = tmp.aag01
#NO.MOD-5B0309 START---
             #    #AND git06 = tm.y1 AND git07 = tm.m2
             #    AND git06 = tm.y1 AND git07 BETWEEN tm.m1 AND tm.m2
#NO.MOD-5B0309 END----
             #    AND git01 = gir01 AND gir04 = 'N'
               SELECT SUM(gio05) INTO l1_amt FROM gio_file,gir_file
                WHERE gio01 = gir.gir01 AND gio02 = tmp.aag01
                  AND gio06 = tm.y1 AND gio07 BETWEEN tm.m1 AND tm.m2
                  AND gio01 = gir01 AND gir04 = 'N'
                  AND gio00 = tm.b                                            #TQC-C70083  add
             #FUN-970068---End
               IF cl_null(l1_amt) THEN LET l1_amt = 0 END IF
             WHEN '5'  #借方異動
               SELECT SUM(aah04) INTO l1_amt FROM aah_file
                WHERE aah00=tm.b AND aah01=tmp.aag01
                    AND aah02=tm.y1 AND aah03 BETWEEN tm.m1 AND tm.m2
               IF cl_null(l1_amt) THEN LET l1_amt = 0 END IF
             WHEN '6'  #貸方異動
               SELECT SUM(aah05) INTO l1_amt FROM aah_file
                WHERE aah00=tm.b AND aah01=tmp.aag01
                    AND aah02=tm.y1 AND aah03 BETWEEN tm.m1 AND tm.m2
               IF cl_null(l1_amt) THEN LET l1_amt = 0 END IF
           END CASE
           #若為減項
         # IF tmp.gis03 = '-' THEN LET l1_amt  = l1_amt * -1 END IF  #FUN-970068
           IF tmp.gin03 = '-' THEN LET l1_amt  = l1_amt * -1 END IF  #FUN-970068
           LET l1_amt_s = l1_amt_s + l1_amt
         END FOREACH
         IF l1_amt_s = 0 AND tm.c = 'N' THEN
            CONTINUE FOREACH
         END IF
         #計算理財活動產生之淨現金
         LET l1_sub_amt = l1_sub_amt + l1_amt_s
         SELECT gir05 INTO l_gir05 FROM gir_file WHERE gir01 = gir.gir01
         IF NOT cl_null(l_gir05) THEN
            LET l_sharp = FGL_WIDTH(l_gir05)
         END IF
         PRINT '\"',g_x[41] CLIPPED,'\"',    #報表編號    #No.TQC-6A0080
#        PRINT '\"',g_x[41] ,'\"',     #報表編號    #No.TQC-6A0080 
              '\t',
              '\"',g_company CLIPPED,'\"',  #編制單位
              '\t',
              '\"',g_ym CLIPPED,'\"',       #報告期
              '\t',
              '\"',l1_unit CLIPPED,'\"',     #貨幣單位
              '\t',
              '\"',gir.gir02 CLIPPED,'\"',    #項目
              '\t';
         IF cl_null(l_gir05) THEN
            PRINT '\"','\"',                    #行次
                  '\t';
         ELSE
           CASE l_sharp
              WHEN "1"
                 PRINT '\"',l_gir05 USING '#','\"',  #行次
                       '\t';
              WHEN "2"
                 PRINT '\"',l_gir05 USING '##','\"',  #行次
                       '\t';
              WHEN "3"
                 PRINT '\"',l_gir05 USING '###','\"',  #行次
                       '\t';
              WHEN "4"
                 PRINT '\"',l_gir05 USING '####','\"',  #行次
                       '\t';
              WHEN "5"
                 PRINT '\"',l_gir05 USING '#####','\"',  #行次
                       '\t';
              OTHERWISE 
                 PRINT ;
           END CASE
         END IF
         LET l1_amt_s= l1_amt_s*tm.q/g_unit       #依匯率及單位換算
#        IF l1_amt_s < 0 THEN
#           LET l1_amt_s = l1_amt_s * -1
#        END IF
         PRINT q940_numfor(l1_amt_s,tm.e)
      END FOREACH
      LET l1_tot_amt = l1_tot_amt + l1_sub_amt  #計算本期現金淨增數
#     PRINT '\"',g_x[41],'\"',           #報表編號
#          '\t',
#          '\"',g_company CLIPPED,'\"',  #編制單位
#          '\t',
#          '\"',g_ym CLIPPED,'\"',       #報告期
#          '\t',
#          '\"',l1_unit CLIPPED,'\"',     #貨幣單位
#          '\t',
#          '\"',g_x[24] CLIPPED,'\"',    #項目
#          '\t',
#          '\"','\"',                    #行次
#          '\t';
#     LET l1_sub_amt = l1_sub_amt*tm.q/g_unit  #依匯率及單位換算
#     IF l1_sub_amt < 0 THEN
#        LET l1_sub_amt = l1_sub_amt * -1
#     END IF
#     PRINT q940_numfor(l1_sub_amt,tm.e)
#     PRINT COLUMN 59,'----------------------'
 
##########################################################################
#     PRINT '\"',g_x[41],'\"',           #報表編號
#          '\t',
#          '\"',g_company CLIPPED,'\"',  #編制單位
#          '\t',
#          '\"',g_ym CLIPPED,'\"',       #報告期
#          '\t',
#          '\"',l1_unit CLIPPED,'\"',     #貨幣單位
#          '\t',
#          '\"',g_x[25] CLIPPED,'\"',    #項目
#          '\t',
#          '\"','\"',                    #行次
#          '\t';
#     LET l1_amt = l1_tot_amt                  #本期現金淨增數
#     LET l1_amt = l1_amt*tm.q/g_unit          #依匯率及單位換算
#     IF l1_amt < 0 THEN
#        LET l1_amt = l1_amt * -1
#     END IF
#     PRINT q940_numfor(l1_amt,tm.e)
#     PRINT COLUMN 59,'======================'
#     SKIP 1 LINE
 
      #-------------------期初現金及約當現金餘額 -------------------------
#     SKIP 1 LINE
#     LET l1_amt = 0
#     LET l1_sql="SELECT gir01,gir02 FROM gir_file ",
#               " WHERE gir03 = '4' AND gir04='N'"
#     PREPARE q940_gir_p41 FROM l1_sql
#     DECLARE q940_gir_cs41 CURSOR FOR q940_gir_p41
 
#     LET l1_sql="SELECT aag01,aag02,gis03,gis04 ",
#               " FROM aag_file,gis_file,gir_file",
#               " WHERE aag01=gis02 AND gir01=gis01 ",
#               "  AND gir04='N' AND gis01 = ? "
#     PREPARE q940_p61 FROM l1_sql
#     DECLARE q940_cu61 CURSOR FOR q940_p61
#     FOREACH q940_gir_cs41 INTO gir.*
#        LET l1_amt_s = 0
#        FOREACH q940_cu61 USING gir.gir01 INTO tmp.*
#          CASE tmp.gis04
#            WHEN '1'
#              CALL q940_aah(tmp.aag01,tm.y2,tm.m2,l1_amt)
#                          RETURNING l1_amt
#              IF cl_null(l1_amt) THEN LET l1_amt = 0 END IF
#            WHEN '2'
#              CALL q940_aah2(tmp.aag01,l1_last_y,l1_last_m) RETURNING l1_amt
#              IF cl_null(l1_amt) THEN LET l1_amt = 0 END IF
#            WHEN '3'
#              CALL q940_aah2(tmp.aag01,tm.y2,tm.m2) RETURNING l1_amt
#              IF cl_null(l1_amt) THEN LET l1_amt = 0 END IF
#            WHEN '4'
#              SELECT SUM(git05) INTO l1_amt FROM git_file,gir_file
#               WHERE git01 = gir.gir01 AND git02 = tmp.aag01
#NO.MOD-5B0309 START---
#                 #AND git06 = tm.y1 AND git07 = tm.m2
#                 AND git06 = tm.y1 AND git07 BETWEEN tm.m1 AND tm.m2
#NO.MOD-5B0309 END----
#                 AND git01 = gir01 AND gir04 = 'N'
#              IF cl_null(l1_amt) THEN LET l1_amt = 0 END IF
#            WHEN '5'  #借方異動
#              SELECT SUM(aah04) INTO l1_amt FROM aah_file
#               WHERE aah00=tm.b AND aah01=tmp.aag01
#                   AND aah02=tm.y1 AND aah03 BETWEEN tm.m1 AND tm.m2
#              IF cl_null(l1_amt) THEN LET l1_amt = 0 END IF
#            WHEN '6'  #貸方異動
#              SELECT SUM(aah05) INTO l1_amt FROM aah_file
#               WHERE aah00=tm.b AND aah01=tmp.aag01
#                   AND aah02=tm.y1 AND aah03 BETWEEN tm.m1 AND tm.m2
#              IF cl_null(l1_amt) THEN LET l1_amt = 0 END IF
#          END CASE
#          #若為減項
#          IF tmp.gis03 = '-' THEN LET l1_amt  = l1_amt * -1 END IF
#          LET l1_amt_s = l1_amt_s + l1_amt
#        END FOREACH
#        IF l1_amt_s = 0 AND tm.c = 'N' THEN
#           CONTINUE FOREACH
#        END IF
#        SELECT gir05 INTO l_gir05 FROM gir_file WHERE gir01 = gir.gir01
#        IF NOT cl_null(l_gir05) THEN
#           LET l_sharp = NULL
#           FOR i =1 TO FGL_WIDTH(l_gir05)
#              LET l_sharp = l_sharp CLIPPED,'#'
#           END FOR
#        END IF
#        PRINT '\"',g_x[41],'\"',           #報表編號
#             '\t',
#             '\"',g_company CLIPPED,'\"',  #編制單位
#             '\t',
#             '\"',g_ym CLIPPED,'\"',       #報告期
#             '\t',
#             '\"',l1_unit CLIPPED,'\"',     #貨幣單位
#             '\t',
#             '\"',gir.gir02 CLIPPED,'\"',    #項目
#             '\t';
#        IF cl_null(l_gir05) THEN
#           PRINT '\"','\"',                    #行次
#                 '\t';
#        ELSE
#           PRINT '\"',l_gir05 USING l_sharp,'\"',  #行次
#                 '\t';
#        END IF
#        LET l1_amt_s= l1_amt_s*tm.q/g_unit       #依匯率及單位換算
#        LET l1_this  = l1_amt_s
#        IF l1_amt_s < 0 THEN
#           LET l1_amt_s = l1_amt_s * -1
#        END IF
#        PRINT q940_numfor(l1_amt_s,tm.e)
#     END FOREACH
#     #--------------------期未現金及約當現金餘額---------------------
#     INITIALIZE gir.* TO NULL
#     SKIP 1 LINE
#     LET l1_amt = 0
#     LET l1_sql="SELECT gir01,gir02 FROM gir_file ",
#               " WHERE gir03 = '5' AND gir04='N'"
#     PREPARE q940_gir_p51 FROM l1_sql
#     DECLARE q940_gir_cs51 CURSOR FOR q940_gir_p51
 
#     LET l1_sql="SELECT aag01,aag02,gis03,gis04 ",
#               " FROM aag_file,gis_file,gir_file",
#               " WHERE aag01=gis02 AND gir01=gis01 ",
#               "   AND gir04='N' AND gis01 = ? "
#     PREPARE q940_p71 FROM l1_sql
#     DECLARE q940_cu71 CURSOR FOR q940_p71
#     FOREACH q940_gir_cs51 INTO gir.*
#        LET l1_amt_s = 0
#        FOREACH q940_cu71 USING gir.gir01 INTO tmp.*
#          CASE tmp.gis04
#            WHEN '1'
#              CALL q940_aah(tmp.aag01,tm.y2,tm.m2,l1_amt)
#                          RETURNING l1_amt
#              IF cl_null(l1_amt) THEN LET l1_amt = 0 END IF
#            WHEN '2'
#              CALL q940_aah2(tmp.aag01,l1_last_y,l1_last_m) RETURNING l1_amt
#              IF cl_null(l1_amt) THEN LET l1_amt = 0 END IF
#            WHEN '3'
#              CALL q940_aah2(tmp.aag01,tm.y2,tm.m2) RETURNING l1_amt
#              IF cl_null(l1_amt) THEN LET l1_amt = 0 END IF
#            WHEN '4'
#              SELECT SUM(git05) INTO l1_amt FROM git_file,gir_file
#               WHERE git01 = gir.gir01 AND git02 = tmp.aag01
#NO.MOD-5B0309 START---
#                 #AND git06 = tm.y1 AND git07 = tm.m2
#                 AND git06 = tm.y1 AND git07 BETWEEN tm.m1 AND tm.m2
#NO.MOD-5B0309 END----
#                 AND git01 = gir01 AND gir04 = 'N'
#              IF cl_null(l1_amt) THEN LET l1_amt = 0 END IF
#            WHEN '5'  #借方異動
#              SELECT SUM(aah04) INTO l1_amt FROM aah_file
#               WHERE aah00=tm.b AND aah01=tmp.aag01
#                   AND aah02=tm.y1 AND aah03 BETWEEN tm.m1 AND tm.m2
#              IF cl_null(l1_amt) THEN LET l1_amt = 0 END IF
#            WHEN '6'  #貸方異動
#              SELECT SUM(aah05) INTO l1_amt FROM aah_file
#               WHERE aah00=tm.b AND aah01=tmp.aag01
#                   AND aah02=tm.y1 AND aah03 BETWEEN tm.m1 AND tm.m2
#              IF cl_null(l1_amt) THEN LET l1_amt = 0 END IF
#          END CASE
#          #若為減項
#          IF tmp.gis03 = '-' THEN LET l1_amt  = l1_amt * -1 END IF
#          LET l1_amt_s = l1_amt_s + l1_amt
#        END FOREACH
#        IF l1_amt_s = 0 AND tm.c = 'N' THEN
#           CONTINUE FOREACH
#        END IF
#        SELECT gir05 INTO l_gir05 FROM gir_file WHERE gir01 = gir.gir01
#        IF NOT cl_null(l_gir05) THEN
#           LET l_sharp = NULL
#           FOR i =1 TO FGL_WIDTH(l_gir05)
#              LET l_sharp = l_sharp CLIPPED,'#'
#           END FOR
#        END IF
#        PRINT '\"',g_x[41],'\"',           #報表編號
#             '\t',
#             '\"',g_company CLIPPED,'\"',  #編制單位
#             '\t',
#             '\"',g_ym CLIPPED,'\"',       #報告期
#             '\t',
#             '\"',l1_unit CLIPPED,'\"',     #貨幣單位
#             '\t',
#             '\"',gir.gir02 CLIPPED,'\"',    #項目
#             '\t';
#        IF cl_null(l_gir05) THEN
#           PRINT '\"','\"';                    #行次
#        ELSE
#           PRINT '\"',l_gir05 USING l_sharp,'\"';  #行次
#        END IF
#        LET l1_amt_s= l1_amt_s*tm.q/g_unit       #依匯率及單位換算
#        LET l1_last = l1_amt_s
#        IF l1_amt_s >= 0 THEN
#           LET l1_amt_s = l1_amt_s * -1
#        END IF
#        PRINT q940_numfor(l1_amt_s,tm.e)
#     END FOREACH
#     LET l1_amt = l1_tot_amt                  #本期現金淨增數
#     LET l1_amt = l1_amt*tm.q/g_unit          #依匯率及單位換算
 
#     #若期未餘額 !=期初餘額+本期現金淨增數 show 緊告訊息 ....
#     IF l1_last != l1_this  + l1_amt THEN
#        LET l1_diff = l1_last - (l1_this  + l1_amt)
#        PRINT
#        PRINT '\"',g_x[41],'\"',           #報表編號
#             '\t',
#             '\"',g_company CLIPPED,'\"',  #編制單位
#             '\t',
#             '\"',g_ym CLIPPED,'\"',       #報告期
#             '\t',
#             '\"',l1_unit CLIPPED,'\"',     #貨幣單位
#             '\t',
#             '\"',g_x[35] CLIPPED,g_x[36] CLIPPED,'\"',    #項目
#             '\t',
#             '\"','\"',                    #行次
#             '\t';
#        PRINT q940_numfor(l1_diff,tm.e)
#     END IF
#     IF tm.s = 'Y' THEN
#        SKIP 4 LINE
#        PRINT '\"',g_x[41],'\"',           #報表編號
#             '\t',
#             '\"',g_company CLIPPED,'\"',  #編制單位
#             '\t',
#             '\"',g_ym CLIPPED,'\"',       #報告期
#             '\t',
#             '\"',l1_unit CLIPPED,'\"',     #貨幣單位
#             '\t',
#             '\"',g_x[34] CLIPPED,'\"',    #項目
#             '\t','\t'
#        SKIP 1 LINE
#        LET g_cnt = 1
#        DECLARE q940_gim1 CURSOR FOR
#         SELECT gim02,gim03 FROM gim_file  WHERE gim00='N'
#        FOREACH q940_gim1 INTO g_gim[g_cnt].*
#          IF SQLCA.sqlcode THEN
#              CALL cl_err('foreach:',SQLCA.sqlcode,1)
#              EXIT FOREACH
#          END IF
#          LET g_cnt = g_cnt + 1
#          IF g_cnt > g_max_rec THEN
#             CALL cl_err('','9035',0)
#             EXIT FOREACH
#          END IF
#        END FOREACH
#        LET g_cnt = g_cnt - 1
#        FOR i = 1 TO g_cnt
#           PRINT '\"',g_x[41],'\"',           #報表編號
#                '\t',
#                '\"',g_company CLIPPED,'\"',  #編制單位
#                '\t',
#                '\"',g_ym CLIPPED,'\"',       #報告期
#                '\t',
#                '\"',l1_unit CLIPPED,'\"',     #貨幣單位
#                '\t',
#                '\"',g_gim[i].gim02 CLIPPED,'\"',    #項目
#                '\t',
#                '\"','\"',                    #行次
#                '\t',
#                q940_numfor(g_gim[i].gim03,tm.e)
#        END FOR
#     END IF
 
END REPORT
 
FUNCTION q940_numfor(p_value,p_n)
   DEFINE p_value	LIKE type_file.num26_10,    #No.FUN-680098 dec(26,10) 
          p_len,p_n     LIKE type_file.num20_6,     #No.FUN-680098 smallint  
          l_len 	LIKE type_file.num5,        #No.FUN-680098 smallint
          l_str		LIKE type_file.chr1000,     #No.FUN-680098 VARCHAR(37)
          l_str1        LIKE type_file.chr1,        #No.FUN-680098 VARCHAR(1)
          l_length      LIKE type_file.num5,        #No.FUN-680098 smallint    
          i,j,k         LIKE type_file.num5         #No.FUN-680098 smallint
     
   LET p_value = cl_digcut(p_value,p_n)
   CASE WHEN p_n = 0  LET l_str = p_value USING '------------------------------------&'
        WHEN p_n = 10 LET l_str = p_value USING '-------------------------&.&&&&&&&&&&'
        WHEN p_n = 9  LET l_str = p_value USING '--------------------------&.&&&&&&&&&'
        WHEN p_n = 8  LET l_str = p_value USING '---------------------------&.&&&&&&&&'
        WHEN p_n = 7  LET l_str = p_value USING '----------------------------&.&&&&&&&'
        WHEN p_n = 6  LET l_str = p_value USING '-----------------------------&.&&&&&&'
        WHEN p_n = 5  LET l_str = p_value USING '------------------------------&.&&&&&'
        WHEN p_n = 4  LET l_str = p_value USING '-------------------------------&.&&&&'
        WHEN p_n = 3  LET l_str = p_value USING '--------------------------------&.&&&'
        WHEN p_n = 2  LET l_str = p_value USING '---------------------------------&.&&'
        WHEN p_n = 1  LET l_str = p_value USING '----------------------------------&.&'
   END CASE
   LET j=37                    #TQC-640038 
#  LET p_len = FGL_WIDTH(p_value)+p_n+1
   LET p_len = FGL_WIDTH(p_value)
   LET i = j - p_len + 9
   IF i < 0 THEN               #FUN-560048
        IF not cl_null(g_xml_rep) THEN
          LET i = 0
        ELSE
          LET i = 1
        END IF
   END IF
 
   LET l_length = 0
   #當傳進的金額位數實際上大於所要求回傳的位數時，該欄位應show"*****" NO:0508
   FOR k = 37 TO 1 STEP -1                        #MOD-590093 #TQC-640038
       LET l_str1 = l_str[k,k]
       IF cl_null(l_str1) THEN EXIT FOR END IF
       LET l_length = l_length + 1
   END FOR
   IF l_length > p_len THEN
      LET i = j - l_length
      IF i < 0 THEN
            RETURN l_str
      END IF
   END IF
   IF not cl_null(g_xml_rep) THEN
      RETURN l_str[i+1,j]
   ELSE 
      RETURN l_str[i,j]
   END IF
END FUNCTION
#No.FUN-640004 --end--
#Patch....NO.TQC-610035 <001,002> #
 
FUNCTION q940_bp(p_ud)
DEFINE
    p_ud   LIKE type_file.chr1    #No.FUN-680061 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   DISPLAY tm.p TO FORMONLY.azi01
   DISPLAY tm.y1 TO FORMONLY.yy
   DISPLAY tm.m1 TO FORMONLY.mm1
   DISPLAY tm.m2 TO FORMONLY.mm2
   DISPLAY tm.d  TO FORMONLY.unit
   
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_gir TO s_gir.* ATTRIBUTE(COUNT=g_rec_b)
      #BEFORE DISPLAY
      #   CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
      #  LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION output
         LET g_action_choice="output"
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
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION close
      LET g_action_choice="exit"
      EXIT DISPLAY
 
      ON ACTION exporttoexcel   #No.FUN-4B0021
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION q940_out()
  DEFINE l_i     LIKE type_file.num10
  DEFINE l_d1          LIKE type_file.num5,  
         l_d2          LIKE type_file.num5,  
         l_flag        LIKE type_file.chr1,  
         l_bdate,l_edate   LIKE type_file.dat
 
  LET g_prog = 'aglq940'
 
   LET g_sql = " line.type_file.num10,",
               " gir02.gir_file.gir02,",
               " gir05.gir_file.gir05,",
               " sum1.type_file.chr50,",
               " sum2.type_file.chr50 "
 
   LET l_table = cl_prt_temptable('aglq940',g_sql) CLIPPED
 
  LET l_table = cl_prt_temptable('aglq940',g_sql) CLIPPED
  IF l_table = -1 THEN 
     CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
     EXIT PROGRAM END IF
  LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
              " VALUES(?, ?, ?, ?, ? )    "
  PREPARE insert_prep FROM g_sql
  IF STATUS THEN
     CALL cl_err('insert_prep:',status,1) 
     CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
  END IF
 
  CALL cl_del_data(l_table) 
  FOR l_i=1 TO g_rec_b
      EXECUTE insert_prep USING g_pr_ar[l_i].*
  END FOR
 
      #CALL s_azm(tm.y1,tm.m1) RETURNING l_flag,l_bdate,l_edate #CHI-A70007 mark
      #CHI-A70007 add --start--
      IF g_aza.aza63 = 'Y' THEN
         CALL s_azmm(tm.y1,tm.m1,g_plant,tm.b) RETURNING l_flag,l_bdate,l_edate
      ELSE
         CALL s_azm(tm.y1,tm.m1) RETURNING l_flag,l_bdate,l_edate
      END IF
      #CHI-A70007 add --end--
      LET l_d1 = DAY(l_bdate)
      #CALL s_azm(tm.y2,tm.m2) RETURNING l_flag,l_bdate,l_edate #CHI-A70007 mark
      #CHI-A70007 add --start--
      IF g_aza.aza63 = 'Y' THEN
         CALL s_azmm(tm.y2,tm.m2,g_plant,tm.b) RETURNING l_flag,l_bdate,l_edate
      ELSE
         CALL s_azm(tm.y2,tm.m2) RETURNING l_flag,l_bdate,l_edate
      END IF
      #CHI-A70007 add --end--
      LET l_d2 = DAY(l_edate)
 
 
  LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
  LET g_str = ''  
  LET g_str = g_str,";",tm.title,";",tm.p,";",tm.d,";",tm.y1,";",tm.m1,";",
              l_d1,";",tm.y2,";",tm.m2,";",l_d2
  CALL cl_prt_cs3('aglq940','aglq940',g_sql,g_str)
END FUNCTION
