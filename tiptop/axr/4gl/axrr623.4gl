# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axrr623.4gl
# Descriptions...: 應收帳款月底重評價表
# Date & Author..: 96/05/04 by Roger
# Modify.........: No.FUN-4C0100 04/12/31 By Smapmin 報表轉XML格式
# Modify.........: No.FUN-550119 05/06/01 By Smapmin 新增INPUT "匯率選項"
# Modify.........: No.MOD-560008 05/06/02 By Smapmin DEFINE單價,金額,匯率
# Modify.........: No.MOD-580180 05/08/19 By Smapmin 對occ40重新定義,勾選時表示要月底重評價
# Modify.........: No.FUN-660116 06/06/16 By ice cl_err --> cl_err3
# Modify.........: No.TQC-610059 06/06/05 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-680123 06/08/29 By hongmei 欄位類型轉換
# Modify.........: No.FUN-690127 06/10/16 By baogui cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0095 06/10/27 By Xumin l_time轉g_time
# Modify.........: No.MOD-690083 06/12/05 By Smapmin 串到oca_file的方式改為OUTER
# Modify.........: No.TQC-6B0051 06/12/13 By xufeng  修改報表格式                
# Modify.........: No.TQC-790085 07/09/13 By lumxa  表名和制表日期位置顛倒。
# Modify.........: No.FUN-7B0026 07/11/15 By baofei  報表輸出至Crystal Reports功能    
# Modify.........: No.MOD-830160 08/03/24 By Smapmin 待抵類的也要納入/報表增加單據類別的呈現
# Modify.........: No.MOD-830179 08/03/24 By Smapmin 修改幣別取位
# Modify.........: No.CHI-830003 08/11/03 By xiaofeizhu 依程式畫面上的〔截止基准日〕回抓當月重評價匯率, 
# Modify.........:                                      若當月未產生重評價則往回抓前一月資料，若又抓不到再往上一個月找，找到有值為止
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-B10083 11/01/19 By yinhy l_oma24應給予預設值'',抓不到值不應為'1'
# Modify.........: No.FUN-B20033 11/02/17 By lilingyu SQL增加ooa37='1'的條件
# Modify.........: No.FUN-C40001 12/04/13 By SunLM 增加開窗功能
# Modify.........: No.FUN-C40021 12/05/31 By jinjj QBE增加會計科目oma18
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE yymm   	LIKE azj_file.azj02             #No.FUN-680123 VARCHAR(6) 
   DEFINE tm  RECORD                                    # Print condition RECORD
		wc      LIKE type_file.chr1000,         #No.FUN-680123 VARCHAR(1000) # Where condition
		detail	LIKE type_file.chr1,            #No.FUN-680123 VARCHAR(01)
		edate   LIKE type_file.dat,             #No.FUN-680123 DATE
                rate_op LIKE type_file.chr1,            # Prog. Version..: '5.30.06-13.03.12(01) #FUN-550119
		more    LIKE type_file.chr1             # Prog. Version..: '5.30.06-13.03.12(01) # Input more condition(Y/N)
              END RECORD
 
DEFINE   g_i            LIKE type_file.num5             #count/index for any purpose #No.FUN-680123 SMALLINT
#No.FUN-7B0026---Begin                                                                                                              
DEFINE l_table        STRING,                                                                                                       
       g_str          STRING,                                                                                                       
       g_sql          STRING                                                                                                        
#No.FUN-7B0026---End  
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXR")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690127
#No.FUN-7B0026---Begin                                                                                                              
   LET g_sql = "oma00.oma_file.oma00,",    #MOD-830160
               "oma01.oma_file.oma01,",                                                                                             
               "oma02.oma_file.oma02,",                                                                                             
               "oma03.oma_file.oma03,",                                                                                             
               "oma032.oma_file.oma032,",                                                                                           
               "oma10.oma_file.oma10,", 
               "oma23.oma_file.oma23,",                                                                                            
               "amt1.type_file.num20_6,",                                                                                             
               "amt2.type_file.num20_6,",     
               "new_ex.oma_file.oma24,",                                                                                        
               "old_ex.oma_file.oma24,",                                                                                             
               "new_amt.type_file.num20_6,",                                                                                             
               "ex_prof.type_file.num20_6,",                                                                                             
               "ex_loss.type_file.num20_6,",
               "t_azi03.azi_file.azi03,",
               "t_azi04.azi_file.azi04,",
               "t_azi05.azi_file.azi05,",
               "t_azi07.azi_file.azi07"                                                                                             
      LET l_table = cl_prt_temptable('axrr623',g_sql) CLIPPED                                                                          
   IF l_table = -1 THEN EXIT PROGRAM END IF                                                                                         
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                  
               #" VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) "  #MOD-830160                                                                    
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) "  #MOD-830160                                                                    
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                             
   END IF                                                                                                                           
#No.FUN-7B0026---End       
 
 
   #-----TQC-610059---------
   LET g_pdate=ARG_VAL(1)
   LET g_towhom=ARG_VAL(2)
   LET g_rlang=ARG_VAL(3)
   LET g_bgjob=ARG_VAL(4)
   LET g_prtway=ARG_VAL(5)
   LET g_copies=ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.edate = ARG_VAL(8) 
   LET tm.rate_op = ARG_VAL(9)
   LET tm.detail = ARG_VAL(10)
   #-----END TQC-610059-----
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   LET g_rpt_name = ARG_VAL(14)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   #No.B621 010626 by linda add   #No.FUN-680123
#No.FUN-7B0026---Begin
{ 
   DROP TABLE r623_file
   CREATE TEMP TABLE r623_file
     (oma23 LIKE oma_file.oma23,
      amt1 LIKE type_file.num20_6,
      amt2 LIKE type_file.num20_6,
      new_amt LIKE type_file.num20_6,
      ex_prof LIKE type_file.num20_6,
      ex_loss LIKE type_file.num20_6)
           #No.A057#--END MOD-560008 #No.FUN-680123 end
   DELETE FROM r623_file  WHERE 1=1
}
#No.FUN-7B0026---End 
   #No.B621 end-----
   IF cl_null(tm.wc)
      THEN CALL axrr623_tm(0,0)             # Input print condition
   ELSE 
      CALL axrr623()                   # Read data and create out-file
   END IF
#   DROP TABLE r623_file   #No.B621        #No.FUN-7B0026 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
END MAIN
 
FUNCTION axrr623_tm(p_row,p_col)
DEFINE lc_qbe_sn         LIKE gbm_file.gbm01          #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,         #No.FUN-680123 SMALLINT
          l_cmd          LIKE type_file.chr1000       #No.FUN-680123 VARCHAR(1000)
 
   IF p_row = 0 THEN LET p_row = 2 LET p_col = 15 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
        LET p_row = 6 LET p_col = 17
   ELSE LET p_row = 4 LET p_col = 10
   END IF
 
   OPEN WINDOW axrr623_w AT p_row,p_col
        WITH FORM "axr/42f/axrr623"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.detail='Y'
   LET tm.edate=g_today
   LET tm.rate_op = 'B'   #FUN-550119
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON oma23,oma15,oca01,oma03,oma18    #FUN-C40021 add 'oma18'
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
       ON ACTION locale
           #CALL cl_dynamic_locale()
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
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
      #No.FUN-C40001  --Begin
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(oma23)#幣別
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_azi"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oma23
                 NEXT FIELD oma23
            WHEN INFIELD(oma15)#部門
                 CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gem1"   #No.MOD-530272
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oma15
                 NEXT FIELD oma15
            WHEN INFIELD(oca01)#客戶分類
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_oca"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oca01
                 NEXT FIELD oca01
            WHEN INFIELD(oma03)#賬款客戶編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_occ"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oma03
                 NEXT FIELD oma03
          #No.FUN-C40021 --start--
            WHEN INFIELD(oma18) #科目編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oma18
                 NEXT FIELD oma18
          #No.FUN-C40021 ---end---
            END CASE
      #No.FUN-C40001  --End 
  END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
					
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axrr623_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
         
   END IF
   #INPUT BY NAME tm.edate,tm.detail,tm.more WITHOUT DEFAULTS    #FUN-550119
   INPUT BY NAME tm.edate,tm.rate_op,tm.detail,tm.more WITHOUT DEFAULTS    #FUN-550119
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD edate
         LET yymm=tm.edate USING 'yyyymmdd'
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
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
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axrr623_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axrr623'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axrr623','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'" ,
                         " '",tm.edate CLIPPED,"'" ,
                         " '",tm.rate_op CLIPPED,"'"  ,   #TQC-610059
                         " '",tm.detail CLIPPED,"'"  ,   #TQC-610059
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('axrr623',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axrr623_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axrr623()
   ERROR ""
END WHILE
   CLOSE WINDOW axrr623_w
END FUNCTION
 
FUNCTION axrr623()
   DEFINE l_name    LIKE type_file.chr20,          #No.FUN-680123 VARCHAR(20) # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0095
          l_sql     LIKE type_file.chr1000,        #No.FUN-680123 VARCHAR(1000)
           amt1,amt2 LIKE type_file.num20_6,       #No.FUN-680123 DEC(20,6) #MOD-560008
          l_za05    LIKE za_file.za05,             #No.FUN-680123 VARCHAR(40)
		  l_omavoid	LIKE oma_file.omavoid,
		  l_omaconf	LIKE oma_file.omaconf,
		  l_bucket	LIKE type_file.num5,    #No.FUN-680123 SMALLINT,
          l_order   ARRAY[5] OF LIKE cre_file.cre08,    #No.FUN-680123 ARRAY[5] OF VARCHAR(10)
          sr        RECORD
			occ03	  LIKE occ_file.occ03,  #No.FUN-680123 VARCHAR(4)
			occ40	  LIKE occ_file.occ40,  #No.FUN-680123 VARCHAR(4)
                        oma00     LIKE oma_file.oma00,  #MOD-830160
			oma01	  LIKE oma_file.oma01,
			oma02	  LIKE oma_file.oma02,
			oma10	  LIKE oma_file.oma10,	#
			oma03	  LIKE oma_file.oma03,	#客戶
			oma032    LIKE oma_file.oma032,	#簡稱
			oma23	  LIKE oma_file.oma23,	#
 			old_ex    LIKE oma_file.oma24, #No.FUN-680123 DEC(20,10) #--MOD-560008
		       #new_ex    DEC(20,10),
                        new_ex    LIKE oma_file.oma24,   #No.FUN-680123 DEC(20,10)
			amt1      LIKE type_file.num20_6,#No.FUN-680123 DEC(20,6)
			amt2      LIKE type_file.num20_6,#No.FUN-680123 DEC(20,6) #No.A057
			new_amt   LIKE type_file.num20_6,#No.FUN-680123 DEC(20,6) #No.A057
			ex_prof   LIKE type_file.num20_6,#No.FUN-680123 DEC(20,6) #No.A057
 			ex_loss   LIKE type_file.num20_6 #No.FUN-680123 DEC(20,6) #No.A057  #--END MOD-560008
                    END RECORD
   DEFINE l_oox01   STRING                 #CHI-830003 add
   DEFINE l_oox02   STRING                 #CHI-830003 add
   DEFINE l_sql_1   STRING                 #CHI-830003 add
   DEFINE l_sql_2   STRING                 #CHI-830003 add
   DEFINE l_omb03_1 LIKE omb_file.omb03    #CHI-830003 add
   DEFINE l_count   LIKE type_file.num5    #CHI-830003 add
   DEFINE l_oma24   LIKE oma_file.oma24    #CHI-830003 add
 
     CALL cl_del_data(l_table)            #No.FUN-7B0026                                                                            
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang                                                                   
     SELECT zz05 INTO g_zz05    FROM zz_file WHERE zz01 = g_prog   #No.FUN-7B0026 
     #====>資料權限的檢查
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN#只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND omauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND omagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND omagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('omauser', 'omagrup')
     #End:FUN-980030
 
#FUN-550119
{
  IF g_aza.aza19 = '1' THEN
     LET l_sql="SELECT occ03,occ40,oma01,oma02,oma10,oma03,oma032,oma23,",
             # "       oma24,azj06,oma54t-oma55,oma56t-oma57,0,0,0",           #No.A057
               "       oma24,oma60,oma54t-oma55,oma56t-oma57,oma61,0,0",           #No.A057
               " FROM oma_file, occ_file,oca_file, OUTER azj_file",
               " WHERE oma03=occ01 AND oca_file.oca01=occ_file.occ03 AND ",tm.wc CLIPPED,
               "   AND oma23=azj_file.azj01 AND azj02='",yymm,"'",
               "   AND oma00 MATCHES '1*' AND omaconf='Y' AND omavoid='N'",
               "   AND oma02 <= '",tm.edate,"'",
               "   AND (oma54t>oma55 OR",
               "        oma01 IN (SELECT oob06 FROM ooa_file,oob_file",
               "             WHERE ooa01=oob01 AND ooaconf !='X' ", #010804增
               "               AND ooa02 > '",tm.edate,"' ))"
  ELSE
}
#END FUN-550119
     #LET l_sql="SELECT occ03,occ40,oma01,oma02,oma10,oma03,oma032,oma23,",   #MOD-830160
     LET l_sql="SELECT occ03,occ40,oma00,oma01,oma02,oma10,oma03,oma032,oma23,",   #MOD-830160
             # "       oma24,0,oma54t-oma55,oma56t-oma57,0,0,0",               #no.A057
               "       oma24,oma60,oma54t-oma55,oma56t-oma57,oma61,0,0",               #no.A057
               #" FROM oma_file, occ_file,oca_file",   #MOD-690083
              " FROM oma_file, occ_file,OUTER oca_file",        #MOD-690083
               " WHERE oma03=occ01 AND oca_file.oca01=occ_file.occ03 AND ",tm.wc CLIPPED,
               #"   AND oma00 MATCHES '1*' AND omaconf='Y' AND omavoid='N'",   #MOD-830160
               "   AND (oma00 LIKE '1%' OR oma00 LIKE '2%') ",   #MOD-830160
               "   AND omaconf='Y' AND omavoid='N'",   #MOD-830160
               "   AND oma02 <= '",tm.edate,"'",
               "   AND (oma54t>oma55 OR",
               "        oma01 IN (SELECT oob06 FROM ooa_file,oob_file",
               "             WHERE ooa01=oob01 AND ooaconf !='X' ", #010804增
               "               AND ooa37 = '1'",            #FUN-B20033
               "               AND ooa02 > '",tm.edate,"' ))"
#  END IF  #FUN-550119
 
     LET l_sql= l_sql CLIPPED
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
        EXIT PROGRAM
     END IF
     PREPARE axrr623_prepare1 FROM l_sql
     DECLARE axrr623_curs1 CURSOR FOR axrr623_prepare1
#     CALL cl_outnam('axrr623') RETURNING l_name    #No.FUN-7B0026   
#     START REPORT axrr623_rep TO l_name           #No.FUN-7B0026
 
#     DELETE FROM r623_file WHERE 1=1                #No.FUN-7B0026 
#     LET g_pageno = 0                               #No.FUN-7B0026 
     FOREACH axrr623_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       IF sr.oma23=g_aza.aza17 THEN CONTINUE FOREACH END IF
 #       IF sr.occ40='Y' THEN CONTINUE FOREACH END IF   #MOD-580180
        IF sr.occ40='N' THEN CONTINUE FOREACH END IF   #MOD-580180
        
      #CHI-830003--Add--Begin--#    
      IF g_ooz.ooz07 = 'Y' THEN
         LET l_oox01 = YEAR(tm.edate)
         LET l_oox02 = MONTH(tm.edate)                      	 
         LET l_oma24 = ''  #TQC-B10083 add
         WHILE cl_null(l_oma24)
            IF g_ooz.ooz62 = 'N' THEN
               LET l_sql_2 = "SELECT COUNT(*) FROM oox_file",
                             " WHERE oox00 = 'AR' AND oox01 <= '",l_oox01,"'",
                             "   AND oox02 <= '",l_oox02,"'",
                             "   AND oox03 = '",sr.oma01,"'",
                             "   AND oox04 = '0'"
               PREPARE r623_prepare7 FROM l_sql_2
               DECLARE r623_oox7 CURSOR FOR r623_prepare7
               OPEN r623_oox7
               FETCH r623_oox7 INTO l_count
               CLOSE r623_oox7                       
               IF l_count = 0 THEN
                  #LET l_oma24 = '1'    #TQC-B10083 mark
                  EXIT WHILE            #TQC-B10083 add
               ELSE                  
                  LET l_sql_1 = "SELECT oox07 FROM oox_file",             
                                " WHERE oox00 = 'AR' AND oox01 = '",l_oox01,"'",
                                "   AND oox02 = '",l_oox02,"'",
                                "   AND oox03 = '",sr.oma01,"'",
                                "   AND oox04 = '0'"
               END IF                 
            ELSE
               LET l_sql_2 = "SELECT COUNT(*) FROM oox_file",
                             " WHERE oox00 = 'AR' AND oox01 <= '",l_oox01,"'",
                             "   AND oox02 <= '",l_oox02,"'",
                             "   AND oox03 = '",sr.oma01,"'",
                             "   AND oox04 <> '0'"
               PREPARE r623_prepare8 FROM l_sql_2
               DECLARE r623_oox8 CURSOR FOR r623_prepare8
               OPEN r623_oox8
               FETCH r623_oox8 INTO l_count
               CLOSE r623_oox8                       
               IF l_count = 0 THEN
                  #LET l_oma24 = '1'    #TQC-B10083 mark
                  EXIT WHILE            #TQC-B10083 add
               ELSE            
                  SELECT MIN(omb03) INTO l_omb03_1 FROM omb_file
                   WHERE omb01 = sr.oma01
                  IF cl_null(l_omb03_1) THEN
                     LET l_omb03_1 = 0
                  END IF       
                  LET l_sql_1 = "SELECT oox07 FROM oox_file",             
                                " WHERE oox00 = 'AR' AND oox01 = '",l_oox01,"'",
                                "   AND oox02 = '",l_oox02,"'",
                                "   AND oox03 = '",sr.oma01,"'",
                                "   AND oox04 = '",l_omb03_1,"'"                                      
               END IF
            END IF   
            IF l_oox02 = '01' THEN
               LET l_oox02 = '12'
               LET l_oox01 = l_oox01-1
            ELSE    
               LET l_oox02 = l_oox02-1
            END IF            
            
            IF l_count <> 0 THEN        
               PREPARE r623_prepare07 FROM l_sql_1
               DECLARE r623_oox07 CURSOR FOR r623_prepare07
               OPEN r623_oox07
               FETCH r623_oox07 INTO l_oma24
               CLOSE r623_oox07
            END IF              
         END WHILE                       
      END IF
      #CHI-830003--Add--End--#        
        
       LET amt1=0 LET amt2=0
       #CHI-830003--Begin--#
       #IF g_ooz.ooz07 = 'Y' AND l_count <> 0 THEN          #TQC-B10083 mark
       IF g_ooz.ooz07 = 'Y' AND NOT cl_null(l_oma24) THEN   #TQC-B10083 mod
          LET sr.amt2 = sr.amt1 * l_oma24
       END IF    
       #CHI-830003--End--#       
 
       IF sr.oma00 MATCHES '1*' THEN  #MOD-830160
          SELECT SUM(oob09),SUM(oob10) INTO amt1,amt2
               FROM oob_file, ooa_file
              WHERE oob06=sr.oma01 AND oob03='2' AND oob04='1' AND ooaconf='Y'
                AND ooa37 = '1'        #FUN-B20033 
                AND ooa01=oob01 AND ooa02 > tm.edate
          IF amt1 IS NULL THEN LET amt1=0 END IF
          IF amt2 IS NULL THEN LET amt2=0 END IF
          #CHI-830003--Begin--#
          #IF g_ooz.ooz07 = 'Y' AND l_count <> 0 THEN          #TQC-B10083 mark
          IF g_ooz.ooz07 = 'Y' AND NOT cl_null(l_oma24) THEN   #TQC-B10083 mod
             LET amt2 = amt1 * l_oma24
          END IF    
          #CHI-830003--End--#          
          
          LET sr.amt1=sr.amt1+amt1
          LET sr.amt2=sr.amt2+amt2
       #-----MOD-830160---------
       ELSE
          SELECT SUM(oob09),SUM(oob10) INTO amt1,amt2
               FROM oob_file, ooa_file
              WHERE oob06=sr.oma01 AND oob03='1' AND oob04='3' AND ooaconf='Y'
                AND ooa01=oob01 AND ooa02 > tm.edate
                AND ooa37 = '1'            #FUN-B20033
          IF amt1 IS NULL THEN LET amt1=0 END IF
          IF amt2 IS NULL THEN LET amt2=0 END IF
          #CHI-830003--Begin--#
          #IF g_ooz.ooz07 = 'Y' AND l_count <> 0 THEN            #TQC-B10083 mark  
          IF g_ooz.ooz07 = 'Y' AND NOT cl_null(l_oma24) THEN     #TQC-B10083 mod
             LET amt2 = amt1 * l_oma24
          END IF    
          #CHI-830003--End--#          
 
          LET sr.amt1=(sr.amt1+amt1) * -1
          LET sr.amt2=(sr.amt2+amt2) * -1
       END IF
       #-----END MOD-830160-----
{--modi by kitty bug no:A057
### 02/09/19 add by connie
       IF g_aza.aza19 = '2' THEN
          #CALL s_curr3(sr.oma23,tm.edate,'B') RETURNING sr.new_ex    #FUN-550119
 
       END IF
###
}
          CALL s_curr3(sr.oma23,tm.edate,tm.rate_op) RETURNING sr.new_ex   #FUN-550119
          LET sr.new_amt = sr.amt1 * sr.new_ex
          LET sr.new_amt = cl_digcut(sr.new_amt,g_azi04)   #MOD-830179
          LET amt1 = sr.amt2 - sr.new_amt
          IF amt1 = 0 THEN CONTINUE FOREACH END IF
          IF amt1 < 0
             THEN LET sr.ex_prof = amt1*-1 LET sr.ex_loss = 0
             ELSE LET sr.ex_prof = 0       LET sr.ex_loss = amt1
          END IF
#No.FUN-7B0026---Begin
      SELECT azi03,azi04,azi05,azi07 INTO t_azi03,t_azi04,t_azi05,t_azi07                                   
         FROM azi_file                                                                                                              
        WHERE azi01=sr.oma23     
         #EXECUTE insert_prep USING  sr.oma01,sr.oma02,sr.oma03,sr.oma032,   #MOD-830160
         EXECUTE insert_prep USING  sr.oma00,sr.oma01,sr.oma02,sr.oma03,sr.oma032,   #MOD-830160
                                    sr.oma10,sr.oma23,sr.amt1,sr.amt2,sr.new_ex,
                                    sr.old_ex,sr.new_amt,
                                    sr.ex_prof,sr.ex_loss,t_azi03,t_azi04,
                                    t_azi05,t_azi07
 
{
       OUTPUT TO REPORT axrr623_rep(sr.*)
       #No.B621 010626 by linda add
       INSERT INTO r623_file VALUES(sr.oma23,sr.amt1,sr.amt2,
                    sr.new_amt,sr.ex_prof,sr.ex_loss)
       IF SQLCA.SQLCODE <>0 THEN
#         CALL cl_err('ins r623_file:',SQLCA.SQLCODE,0)   #No.FUN-660116
          CALL cl_err3("ins","r623_file",sr.oma23,sr.amt1,SQLCA.sqlcode,"","ins r623_file:",0)   #No.FUN-660116
          EXIT FOREACH
       END IF
       #No.B621 end---
}
 
#No.FUN-7B0026---End
     END FOREACH
#No.FUN-7B0026---Begin
#     FINISH REPORT axrr623_rep
   IF g_zz05 = 'Y' THEN                                                                                                             
      CALL cl_wcchp(tm.wc,'oma23,oma15,oca01,oma03,oma18')          #FUN-C40021 add 'oma18'                                                                            
        RETURNING tm.wc                                                                                                             
                                                                                                           
   END IF                                                                                                                           
        LET g_str=tm.wc,";",g_azi04,";",g_azi05,";",tm.detail                                                                                                                            
   LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED                                                               
   CALL cl_prt_cs3('axrr623','axrr623',l_sql,g_str)  
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#No.FUN-7B0026---End
END FUNCTION
#No.FUN-7B0026---Begin
{
REPORT axrr623_rep(sr)
   DEFINE l_last_sw    LIKE type_file.chr1,            #No.FUN-680123 VARCHAR(1)
          l_oma23      LIKE oma_file.oma23,            #No.FUN-680123 VARCHAR(4)
          l_amt1       LIKE type_file.num20_6,         #No.FUN-680123 DEC(20,6) #--MOD-560008
          l_amt2       LIKE type_file.num20_6,         #No.FUN-680123 DEC(20,6) #No.A057
          l_new_amt    LIKE type_file.num20_6,         #No.FUN-680123 DEC(20,6) #No.A057
          l_ex_prof    LIKE type_file.num20_6,         #No.FUN-680123 DEC(20,6) #No.A057
          l_ex_loss    LIKE type_file.num20_6,         #No.FUN-680123 DEC(20,6) #--END MOD-560008 #No.A057
          g_head1      STRING,
          sr        RECORD
			occ03	  LIKE occ_file.occ03, #No.FUN-680123 VARCHAR(4)
			occ40	  LIKE occ_file.occ40, #No.FUN-680123 VARCHAR(1)
			oma01	  LIKE oma_file.oma01,
			oma02	  LIKE oma_file.oma02,	#
			oma10	  LIKE oma_file.oma10,	#
			oma03	  LIKE oma_file.oma03,	#客戶
			oma032    LIKE oma_file.oma032,	#簡稱
			oma23	  LIKE oma_file.oma23,
 		       #old_ex    DEC(20,10),            #--MOD-560008
		        old_ex    LIKE oma_file.oma23,   #No.FUN-680123 DEC(20,10)
                        new_ex    LIKE oma_file.oma24,   #No.FUN-680123 DEC(20,10) 
			amt1      LIKE type_file.num20_6,#No.FUN-680123 DEC(20,6)
			amt2      LIKE type_file.num20_6,#No.FUN-680123 DEC(20,6) #No.A057
			new_amt   LIKE type_file.num20_6,#No.FUN-680123 DEC(20,6) #No.A057
			ex_prof   LIKE type_file.num20_6,#No.FUN-680123 DEC(20,6) #No.A057
 			ex_loss   LIKE type_file.num20_6 #No.FUN-680123 DEC(20,6) #No.A057  #-- END MOD-560008
                    END RECORD
 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER BY sr.oma23,sr.oma03,sr.oma032,sr.oma02
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]     #No.TQC-6B0051
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]   #TQC-790085
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED, pageno_total
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]    #No.TQC-6B0051 #TQC-790085 mark
      LET g_head1 = g_x[11] CLIPPED,tm.edate
      PRINT g_head1
      PRINT g_dash[1,g_len]
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],
            g_x[38],g_x[39],g_x[40],g_x[41],g_x[42],g_x[43]
      PRINT g_dash1
      LET l_last_sw = 'n'
   BEFORE GROUP OF sr.oma23
      SELECT azi03,azi04,azi05,azi07 INTO t_azi03,t_azi04,t_azi05,t_azi07  #抓原幣取位
         FROM azi_file
        WHERE azi01=sr.oma23
      PRINT COLUMN g_c[31],sr.oma23,
            COLUMN g_c[32],cl_numfor(sr.new_ex,32,t_azi07);
   ON EVERY ROW
      IF tm.detail='Y' THEN
         #PRINT COLUMN g_c[33],sr.oma03[1,6],   #MOD-690083
         PRINT COLUMN g_c[33],sr.oma03,   #MOD-690083
               COLUMN g_c[34],sr.oma032,
               COLUMN g_c[35],sr.oma01,
               COLUMN g_c[36],sr.oma10,
               COLUMN g_c[37],sr.oma02,
	       COLUMN g_c[38],cl_numfor(sr.amt1,38,t_azi04),
	       COLUMN g_c[39],cl_numfor(sr.old_ex,39,t_azi07),
	       COLUMN g_c[40],cl_numfor(sr.amt2,40,g_azi04),
	       COLUMN g_c[41],cl_numfor(sr.new_amt,41,g_azi04),
	       COLUMN g_c[42],cl_numfor(sr.ex_prof,42,t_azi04),
	       COLUMN g_c[43],cl_numfor(sr.ex_loss,43,t_azi04)
      END IF
 
   AFTER GROUP OF sr.oma23
 
     SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05  #抓原幣取位
       FROM azi_file
      WHERE azi01=sr.oma23
      PRINT
      PRINT COLUMN g_c[34],g_x[12] CLIPPED,
	    COLUMN g_c[38],cl_numfor(GROUP SUM(sr.amt1),38,t_azi05),
	    COLUMN g_c[40],cl_numfor(GROUP SUM(sr.amt2),40,g_azi05),
	    COLUMN g_c[41],cl_numfor(GROUP SUM(sr.new_amt),41,g_azi05),
	    COLUMN g_c[42],cl_numfor(GROUP SUM(sr.ex_prof),42,t_azi05),
	    COLUMN g_c[43],cl_numfor(GROUP SUM(sr.ex_loss),43,t_azi05)
      PRINT
 
   ON LAST ROW
      PRINT COLUMN g_c[34],g_x[13] CLIPPED;
      #No.B621 010626 by linda add 依幣別加總
      DECLARE r623_t1 CURSOR FOR
        SELECT oma23,SUM(amt1),SUM(amt2),SUM(new_amt),SUM(ex_prof),SUM(ex_loss)
          FROM r623_file
         GROUP BY oma23
         ORDER BY oma23
      FOREACH r623_t1 INTO l_oma23,l_amt1,l_amt2,l_new_amt,
                           l_ex_prof,l_ex_loss
         SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05  #抓原幣取位
           FROM azi_file
          WHERE azi01=l_oma23
          PRINT COLUMN g_c[35],l_oma23,
		COLUMN g_c[38],cl_numfor(l_amt1,38,t_azi04),
		COLUMN g_c[40],cl_numfor(l_amt2,40,g_azi04),
		COLUMN g_c[41],cl_numfor(l_new_amt,41,g_azi04),
		COLUMN g_c[42],cl_numfor(l_ex_prof,42,t_azi04),
		COLUMN g_c[43],cl_numfor(l_ex_loss,43,t_azi04)
      END FOREACH
      #No.B621 end---
      LET l_last_sw ='y'   #No.TQC-6B0051 
 
   PAGE TRAILER
#      	 PRINT g_x[14]    #No.TQC-6B0051
         PRINT g_dash[1,g_len]
         #No.TQC-6B0051  --begin
         IF l_last_sw ='y' THEN
            PRINT g_x[14] CLIPPED, COLUMN g_len-9,g_x[9] CLIPPED
            PRINT
         ELSE
            PRINT g_x[14] CLIPPED, COLUMN g_len-9,g_x[8] CLIPPED
            PRINT
         END IF
         #No.TQC-6B0051   --end
 
         PRINT COLUMN g_c[31],g_x[4],
               COLUMN g_c[33],g_x[5],
               COLUMN g_c[35],g_x[6],
               COLUMN g_c[37],g_x[7]
END REPORT
}
#No.FUN-7B0026---End
