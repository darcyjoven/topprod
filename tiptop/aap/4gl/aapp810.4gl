# Prog. Version..: '5.30.08-13.07.05(00000)'     #
#
# Pattern name...: aapp810.4gl
# Descriptions...: 外購系統傳票拋轉總帳還原作業
# Date & Author..: 98/06/19 By Danny
# modify ........: No.FUN-560190 05/06/21 By Danny  單據編號加大
# Modify.........: MOD-590081 05/09/20 By Smapmin 取消call s_abhmod()
# Modify.........: No.FUN-570112 06/02/23 By yiting 批次背景執行
# Modify.........: No.MOD-640018 06/04/13 By Smapmin 加入alc02<>0的條件
# Modify.........: No.FUN-660122 06/06/16 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-660117 06/06/21 By Rainy Char改為 Like
# Modify.........: No.FUN-660141 06/07/07 By wujie 帳別權限修改
# Modify.........: No.FUN-680029 06/08/22 By Rayven 新增多帳套功能
# Modify.........: No.FUN-690028 06/09/12 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0055 06/10/25 By douzh l_time轉g_time
# Modify.........: No.CHI-780008 07/08/13 By Smapmin 還原MOD-590081
# Modify.........: No.FUN-980001 09/08/04 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980020 09/08/30 By douzh GP5.2架構重整，修改sub相關傳參
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-990031 09/10/23 By lutingtingGP5.2財務營運中心欄位調整,營運中心要控制在同一法人下 
# Modify.........: No:CHI-A20014 10/02/25 By sabrina 送簽中或已核准不可還原
# Modify.........: No.FUN-A50102 10/06/01 By lutingting 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:CHI-AA0015 10/11/05 By Summer alc02原為vachar(1)改為Number(5) 
# Modify.........: No:FUN-B30211 11/03/30 By yangtingting 未加離開前的 cl_used(2)
# Modify.........: No:FUN-B40056 11/06/03 By guoch 刪除資料時一併刪除tic_file的資料
# Modify.........: No:MOD-C20146 12/02/20 By Polly 傳票還原刪除tic_file，時，先判斷是否有tic_file資料
# Modify.........: No.FUN-CB0096 13/01/10 by zhangweib 增加log檔記錄程序運行過程
# Modify.........: No.FUN-D40105 13/08/22 by yangtt 憑證編號開窗可多選
# Modify.........: No.TQC-D60072 13/08/22 by yangtt 報錯訊息要有憑證編號
# Modify.........: No:MOD-G30031 16/03/09 By doris 1.輸入時,傳票編號不允許打*號
#                                                  2.拋轉還原時多控卡不允許刪除不同來源碼的傳票
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
 DEFINE g_wc,g_sql       string  #No.FUN-580092 HCN
#DEFINE g_dbs_gl          LIKE type_file.chr21       # No.FUN-690028 VARCHAR(21)   #FUN-A50102
#DEFINE p_plant          VARCHAR(12)            #FUN-660117 remark
DEFINE p_plant          LIKE azp_file.azp01  #FUN-660117
#DEFINE p_acc            VARCHAR(02)            #FUN-660117 remark
DEFINE p_acc            LIKE apz_file.apz02b #FUN-660117
DEFINE p_acc1           LIKE apz_file.apz02c #No.FUN-680029
DEFINE gl_date		LIKE type_file.dat     #No.FUN-690028 DATE
DEFINE gl_yy,gl_mm	LIKE type_file.num5    #No.FUN-690028 SMALLINT
#DEFINE g_existno VARCHAR(16)	#No.FUN-560190  #FUN-660117 remark
DEFINE g_existno	LIKE aba_file.aba01             #FUN-660117
DEFINE g_existno1 LIKE npp_file.nppglno     #No.FUN-680029 
DEFINE g_str 		LIKE type_file.chr3        # No.FUN-690028 VARCHAR(3)
DEFINE g_mxno	        LIKE type_file.chr8        # No.FUN-690028 VARCHAR(8)
DEFINE l_flag           LIKE type_file.chr1        #No.FUN-690028 VARCHAR(1)
DEFINE i		LIKE type_file.num10       # No.FUN-690028 INTEGER
DEFINE g_aaz84          LIKE aaz_file.aaz84 #還原方式 1.刪除 2.作廢 no.4868
DEFINE p_row,p_col      LIKE type_file.num5    #No.FUN-690028 SMALLINT
DEFINE g_change_lang    LIKE type_file.chr1                  #是否有做語言切換 No.FUN-570112  #No.FUN-690028 VARCHAR(1)
 
DEFINE   g_msg           LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(72)
#No.FUN-CB0096 ---start--- Add
DEFINE g_id     LIKE azu_file.azu00
DEFINE l_id     STRING
DEFINE l_time   LIKE type_file.chr8
#No.FUN-CB0096 ---end  --- Add
#FUN-D40105--add--str--
DEFINE l_time_t LIKE type_file.chr8  
DEFINE g_existno_str     STRING  
DEFINE bst base.StringTokenizer
DEFINE temptext STRING
DEFINE l_errno LIKE type_file.num10
DEFINE g_existno1_str STRING 
DEFINE tm   RECORD
            wc1         STRING
            END RECORD 
#FUN-D40105--add--end--

MAIN
#     DEFINEl_time LIKE type_file.chr8              #No.FUN-6A0055
#No.FUN-680029 --star--
DEFINE   l_abapost   LIKE aba_file.abapost 
DEFINE   l_aba00     LIKE aba_file.aba00
DEFINE   l_abaacti   LIKE aba_file.abaacti
DEFINE   l_aaa07     LIKE aaa_file.aaa07
DEFINE   l_npp07     LIKE npp_file.npp07  
DEFINE   l_npp011    LIKE npp_file.npp011
DEFINE   l_npp00     LIKE npp_file.npp00  
DEFINE   l_nppglno   LIKE npp_file.nppglno
#No.FUN-680029 --end--
DEFINE   l_aba20     LIKE aba_file.aba20    #CHI-A20014 add
 
     OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
#->No.FUN-570112 --start--
   INITIALIZE g_bgjob_msgfile TO NULL
   LET p_plant   = ARG_VAL(1)                  #
   LET p_acc     = ARG_VAL(2)                  #
   LET g_existno = ARG_VAL(3)                  #
   LET g_bgjob = ARG_VAL(4)    #背景作業
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
#->No.FUN-570112 ---end---
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time   #No.FUN-6A0055 
   #No.FUN-CB0096 ---start--- Add
    LET l_time = TIME
    LET l_time_t = l_time   #FUN-D40105  add
    LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
    LET l_id = g_plant CLIPPED , g_prog CLIPPED , '100' , g_user CLIPPED , g_today USING 'YYYYMMDD' , l_time
    LET g_sql = "SELECT azu00 + 1 FROM azu_file ",
                " WHERE azu00 LIKE '",l_id,"%' "
    PREPARE aglt110_sel_azu FROM g_sql
    EXECUTE aglt110_sel_azu INTO g_id
    IF cl_null(g_id) THEN
       LET g_id = l_id,'000000'
    ELSE
       LET g_id = g_id + 1
    END IF
    CALL s_log_data('I','100',g_id,'1',l_time,'','')
   #No.FUN-CB0096 ---end  --- Add

   WHILE TRUE
      IF g_bgjob = "N" THEN
         CALL p810_ask()
         #FUN-D40105--add--str--
         IF tm.wc1 = " 1=1" THEN
            CALL cl_err('','9033',0)
            CONTINUE WHILE  
         END IF
         #FUN-D40105--add--end--
         IF cl_sure(18,20) THEN
            LET g_success = 'Y'
            BEGIN WORK
            #FUN-D40105--add--str--
            CALL p810_existno_chk()
            IF g_success = 'N' THEN 
                CALL s_showmsg()
                CONTINUE WHILE 
            END IF 
            #FUN-D40105--add--end--
            CALL p810()      
            CALL s_showmsg()   #FUN-D40105  add
            IF g_success = 'Y' THEN
               COMMIT WORK
               CALL cl_end2(1) RETURNING l_flag
            ELSE
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING l_flag
            END IF
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p810
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
         CLOSE WINDOW p810
      ELSE
         #No.FUN-680029 --start--
        #FUN-A50102--mark--str--跨庫用cl_get_target_table()實現
        #LET g_plant_new=p_plant
        #CALL s_getdbs()
        #LET g_dbs_gl=g_dbs_new
        #FUN-A50102--mark--end

        LET tm.wc1 = "g_existno IN ('",g_existno,"')"  #FUN-D40105  add
        CALL p810_existno_chk()  #FUN-D40105  add

         #FUN-D40105--mark--end--
         #LET g_sql="SELECT aba00,aba02,aba03,aba04,abapost,abaacti,aba20 FROM ",   #CHI-A20014 add aba20
         #         #g_dbs_gl CLIPPED,"aba_file",   #FUN-A50102
         #           cl_get_target_table(p_plant,'aba_file'),    #FUN-A50102
         #          " WHERE aba01 = ? AND aba00 = ? AND aba06='LC'"
         #CALL cl_replace_sqldb(g_sql) RETURNING g_sql   #FUN-A50102
         #CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql    #FUN-A50102
         #PREPARE p810_t_p4 FROM g_sql
         #DECLARE p810_t_c4 CURSOR FOR p810_t_p4
         #IF STATUS THEN
         #   CALL cl_err('decl aba_cursor:',STATUS,0)
         #   LET g_success = 'N'
         #   RETURN
         #END IF
         #OPEN p810_t_c4 USING g_existno,g_apz.apz02b
         #FETCH p810_t_c4 INTO l_aba00,gl_date,gl_yy,gl_mm,l_abapost,
         #                     l_abaacti,l_aba20     #CHI-A20014 add l_aba20
         #IF STATUS THEN
         #   CALL cl_err('sel aba:',STATUS,0)
         #   LET g_success = 'N'
         #   RETURN
         #END IF
         #IF l_abaacti = 'N' THEN
         #   CALL cl_err('','mfg8001',1)
         #   LET g_success = 'N'
         #   RETURN
         #END IF
         ##CHI-A20014---add---start---
         #IF l_aba20 MATCHES '[Ss1]' THEN
         #   CALL cl_err('','mfg3557',0)
         #   LET g_success ='N'
         #   RETURN
         #END IF
         ##CHI-A20014---add---end---
         ##LET g_sql="SELECT aaa07 FROM ",g_dbs_gl CLIPPED,"aaa_file",    #FUN-A50102
         #LET g_sql="SELECT aaa07 FROM ",cl_get_target_table(p_plant,'aaa_file'),    #FUN-A50102
         #          " WHERE aaa01 = '",l_aba00,"'"
 	     #CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
         #CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql    #FUN-A50102
         #PREPARE p810_t_p5 FROM g_sql
         #DECLARE p810_t_c5 CURSOR FOR p810_t_p5
         #IF STATUS THEN
         #   CALL cl_err('decl aba_cursor2:',STATUS,0)
         #   LET g_success = 'N'
         #   RETURN
         #END IF
         #OPEN p810_t_c5
         #FETCH p810_t_c5 INTO l_aaa07
         #IF gl_date <= l_aaa07 THEN
         #   CALL cl_err(gl_date,'agl-200',0)
         #   LET g_success = 'N'
         #   RETURN
         #END IF
         #IF l_abapost = 'Y' THEN
         #   CALL cl_err(g_existno,'aap-130',0)
         #   LET g_success = 'N'
         #   RETURN
         #END IF
         #IF g_aza.aza63 = 'Y' THEN
         #   SELECT npp00,npp011 INTO l_npp00,l_npp011
         #     FROM npp_file
         #    WHERE npp07 = p_acc
         #      AND nppglno = g_existno
         #      AND npptype = '0'
         #   SELECT UNIQUE npp07,nppglno INTO l_npp07,l_nppglno
         #     FROM npp_file
         #    WHERE npp01 IN (SELECT npp01 FROM npp_file WHERE npp07 = p_acc AND nppglno = g_existno AND npptype = '0' AND npp00 = l_npp00)
         #      AND npptype = '1'
         #      AND npp00 = l_npp00
         #      AND npp011= l_npp011
         #   IF cl_null(l_npp07) OR cl_null(l_nppglno) THEN
         #      CALL cl_err('','aap-986',1)
         #      LET g_success = 'N'
         #      RETURN
         #   END IF
         #   OPEN p810_t_c4 USING l_nppglno,g_apz.apz02c
         #   FETCH p810_t_c4 INTO l_aba00,gl_date,gl_yy,gl_mm,l_abapost,
         #                        l_abaacti,l_aba20     #CHI-A20014 add l_aba20
         #   IF STATUS THEN
         #      CALL cl_err('sel aba:',STATUS,0)
         #      LET g_success = 'N'
         #      RETURN
         #   END IF
         #   IF l_abaacti = 'N' THEN
         #      CALL cl_err('','mfg8003',1)
         #      LET g_success = 'N'
         #      RETURN
         #   END IF
         #  #CHI-A20014---add---start---
         #   IF l_aba20 MATCHES '[Ss1]' THEN
         #      CALL cl_err('','mfg3557',0)
         #      LET g_success ='N'
         #      RETURN
         #   END IF
         #  #CHI-A20014---add---end---
         #  #LET g_sql="SELECT aaa07 FROM ",g_dbs_gl CLIPPED,"aaa_file",   #FUN-A50102
         #   LET g_sql="SELECT aaa07 FROM ",cl_get_target_table(p_plant,'aaa_file'),   #FUN-A50102
         #             " WHERE aaa01 = '",l_aba00,"'"
 	     #   CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
         #   CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql    #FUN-A50102
         #   PREPARE p810_t_p6 FROM g_sql
         #   DECLARE p810_t_c6 CURSOR FOR p810_t_p6
         #   IF STATUS THEN
         #      CALL cl_err('decl aba_cursor2:',STATUS,0)
         #      LET g_success = 'N'
         #      RETURN
         #   END IF
         #   OPEN p810_t_c6
         #   FETCH p810_t_c6 INTO l_aaa07
         #   IF gl_date <= l_aaa07 THEN
         #      CALL cl_err(gl_date,'agl-200',0)
         #      LET g_success = 'N'
         #      RETURN
         #   END IF
         #   IF l_abapost = 'Y' THEN
         #      CALL cl_err(l_nppglno,'aap-132',0)
         #      LET g_success = 'N'
         #      RETURN
         #   END IF
         #   LET p_acc1 = l_npp07
         #   LET g_existno1 = l_nppglno
         #END IF
         #FUN-D40105--mark--end-- 
         
         #No.FUN-680029 --end--
         LET g_apz.apz02b = p_acc
         LET g_success = 'Y'
         BEGIN WORK
         CALL p810()
         IF g_success = "Y" THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
 
     #No.FUN-CB0096 ---start--- add
      LET l_time = TIME
      #FUN-D40105--add--str--
      IF  l_time = l_time_t   THEN 
         LET l_time = l_time + 1
      END IF 
      LET l_time_t = l_time
      #FUN-D40105--add--end--
      LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
      CALL s_log_data('U','100',g_id,'1',l_time,'','')
     #No.FUN-CB0096 ---end  --- add
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION p810()
# 得出總帳 database name 
# g_apz.apz02p -> g_plant_new -> s_getdbs() -> g_dbs_new --> g_dbs_gl
 
#NO.FUN-570112 MARK---
#WHILE TRUE
#   LET g_action_choice = ""
 
#   CALL p810_ask()			
#   IF g_action_choice = 'locale' THEN
#      CALL cl_dynamic_locale()
#      CONTINUE WHILE
#   END IF
#   IF INT_FLAG THEN RETURN END IF
#   IF cl_sure(20,20) THEN 
#      CALL cl_wait()
#      LET g_success = 'Y'
     #FUN-A50102--mark--str--
     #LET g_plant_new=p_plant
     #CALL s_getdbs()
     #LET g_dbs_gl=g_dbs_new 
     #FUN-A50102--mark--end
 
      #no.4868 (還原方式為刪除/作廢)
     #LET g_sql = "SELECT aaz84 FROM ",g_dbs_gl CLIPPED,"aaz_file",   #FUN-A50102
      LET g_sql = "SELECT aaz84 FROM ",cl_get_target_table(p_plant,'aaz_file'),   #FUN-A50102
                  " WHERE aaz00 = '0' "
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql    #FUN-A50102
      PREPARE aaz84_pre FROM g_sql
      DECLARE aaz84_cs CURSOR FOR aaz84_pre
      OPEN aaz84_cs 
      FETCH aaz84_cs INTO g_aaz84
      IF STATUS THEN 
         #CALL cl_err('sel aaz84',STATUS,1)           #FUN-D40105 mark
         CALL s_errmsg('sel aaz84','','',STATUS,1)    #FUN-D40105 add
         LET g_success = 'N'                          #FUN-D40105 add 
         CLOSE WINDOW p810
     #No.FUN-CB0096 ---start--- add
      LET l_time = TIME
      LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
      CALL s_log_data('U','100',g_id,'1',l_time,'','')
     #No.FUN-CB0096 ---end  --- add
         CALL  cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B30211
         EXIT PROGRAM
      END IF
      #no.4868(end)
#NO.FUN-570112 MARK-- 
#      BEGIN WORK
#      CALL p810_t()
#      IF g_success = 'Y' THEN
#         COMMIT WORK
#         CALL cl_end2(1) RETURNING l_flag
#      ELSE
#         ROLLBACK WORK
#         CALL cl_end2(2) RETURNING l_flag
#      END IF
#      IF l_flag THEN CONTINUE WHILE ELSE EXIT WHILE END IF
#      ERROR ""
#   END IF
#END WHILE
#NO.FUN-570112 MARK
    CALL p810_t()
    #No.FUN-680029 --start--
    IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
       CALL p810_t_1()
    END IF
    #No.FUN-680029 --end--
 
END FUNCTION
 
FUNCTION p810_ask()
   #DEFINE   l_abapost   VARCHAR(1)                #FUN-660117 remark
   DEFINE   l_abapost   LIKE aba_file.abapost   #FUN-660117
   DEFINE   l_aba00     LIKE aba_file.aba00
   DEFINE   l_abaacti   LIKE aba_file.abaacti
   DEFINE   l_aaa07     LIKE aaa_file.aaa07
   DEFINE   l_npp07     LIKE npp_file.npp07     #No.FUN-680029
   DEFINE   l_npp011    LIKE npp_file.npp011    #No.FUN-680029
   DEFINE   l_npp00     LIKE npp_file.npp00     #No.FUN-680029
   DEFINE   l_nppglno   LIKE npp_file.nppglno   #No.FUN-680029
   DEFINE   lc_cmd      LIKE type_file.chr1000  # No.FUN-690028 VARCHAR(500)     #No.FUN-570112
   DEFINE   l_chk_bookno  LIKE type_file.num5        # No.FUN-690028 SMALLINT     #No.FUN-660141  
   DEFINE   l_chk_bookno1 LIKE type_file.num5        # No.FUN-690028 SMALLINT     #No.FUN-680029
   DEFINE   g_cnt         LIKE type_file.num5        # No.FUN-690028 SMALLINT      #No.FUN-660141
   DEFINE   l_sql          STRING        #FUN-660141  
   DEFINE   l_aba20     LIKE aba_file.aba20     #CHI-A20014 add
 
#->No.FUN-570112 --start--
   OPEN WINDOW p810 AT p_row,p_col WITH FORM "aap/42f/aapp810"
        ATTRIBUTE (STYLE = g_win_style)
 
   CALL cl_ui_init()
   CALL cl_opmsg('z')
   
   #No.FUN-680029 --start--
   IF g_aza.aza63 = 'N' THEN
      CALL cl_set_comp_visible("p_acc1,g_existno1",FALSE)
   END IF
   #No.FUN-680029 --end--
 
   LET g_bgjob = "N"
#->No.FUN-570112 ---end---
 
 
   LET p_plant = g_apz.apz02p
   LET p_acc   = g_apz.apz02b
   LET g_existno = NULL
   LET g_existno1= NULL  #No.FUN-680029
   DISPLAY NULL TO FORMONLY.g_existno1  #FUN-D40105 add
WHILE TRUE                                                 #->No.FUN-570112
   LET g_action_choice = ""                                #->No.FUN-570112
  #INPUT BY NAME p_plant,p_acc,g_existno WITHOUT DEFAULTS  #->No.FUN-570112
   DIALOG ATTRIBUTES(UNBUFFERED)  #FUN-D40105  add
   #INPUT BY NAME p_plant,p_acc,g_existno,p_acc1,g_existno1,g_bgjob WITHOUT DEFAULTS  #No.FUN-680029 p_acc1,g_existno1  #FUN-D40105 mark
   INPUT BY NAME p_plant,p_acc,p_acc1 ATTRIBUTE(WITHOUT DEFAULTS=TRUE)         #FUN-D40105 add
 
      AFTER FIELD p_plant
         #FUN-990031--add--str--營運中心要控制在同意法人下
         #SELECT azp01 FROM azp_file WHERE azp01 = p_plant
         SELECT * FROM azw_file WHERE azw01 = p_plant
            AND azw02 = g_legal
         #FUN-990031--end
         IF STATUS <> 0 THEN 
            CALL cl_err('sel_azw','agl-171',0)   #FUN-990031
            NEXT FIELD p_plant
         END IF
         ##00/05/18 modify
        #FUN-A50102--mark--str--
        #LET g_plant_new=p_plant
        #CALL s_getdbs()
        #LET g_dbs_gl=g_dbs_new
        #FUN-A50102--mark--end
 
      AFTER FIELD p_acc
         IF p_acc IS NULL THEN
            NEXT FIELD p_acc 
         END IF
#No.FUN-660141--begin
         CALL s_check_bookno(p_acc,g_user,p_plant)
               RETURNING l_chk_bookno
         IF (NOT l_chk_bookno) THEN
            LET p_acc =NULL
            NEXT FIELD p_acc
         END IF
         IF p_acc IS NOT NULL THEN
                 LET g_plant_new= p_plant  # 工廠編號
                 CALL s_getdbs()
                 LET l_sql = "SELECT COUNT(*) ",
                            #"  FROM ",g_dbs_new CLIPPED,"aaa_file ",   #FUN-A50102
                             "  FROM ",cl_get_target_table(p_plant,'aaa_file'),   #FUN-A50102
                             " WHERE aaa01 = '",p_acc,"' "
                 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                 CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql    #FUN-A50102
                 PREPARE a810_pre2 FROM l_sql
                 DECLARE a810_cur2 CURSOR FOR a810_pre2
                 OPEN a810_cur2
                 FETCH a810_cur2 INTO g_cnt                                                                                         
#           SELECT COUNT(*) INTO g_cnt FROM aaa_file WHERE aaa01=p_acc                                                     
            IF g_cnt=0 THEN                                                                                                      
               #CALL cl_err(p_acc,'agl-095',0)          #FUN-D40105 mark
               CALL s_errmsg('',p_acc,'','agl-095',1)   #FUN-D40105 add
               NEXT FIELD p_acc                                                             
            END IF 
         END IF 
#No.FUN-660141--end   
         LET g_apz.apz02b = p_acc

      #FUN-D40105--mark--str--  
      #AFTER FIELD g_existno
      #   IF cl_null(g_existno) THEN 
      #      NEXT FIELD g_existno 
      #   END IF
      #   LET g_sql="SELECT aba00,aba02,aba03,aba04,abapost,abaacti,aba20 FROM ",   #CHI-A20014 add aba20
      #            #g_dbs_gl CLIPPED,"aba_file",   #FUN-A50102
      #              cl_get_target_table(p_plant,'aba_file'),    #FUN-A50102
      #             " WHERE aba01 = ? AND aba00 = ? AND aba06='LC'"
      #   CALL cl_replace_sqldb(g_sql) RETURNING g_sql    #FUN-A50102
      #   CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql    #FUN-A50102 
      #   PREPARE p810_t_p1 FROM g_sql
      #   DECLARE p810_t_c1 CURSOR FOR p810_t_p1
      #   IF STATUS THEN
      #      CALL cl_err('decl aba_cursor:',STATUS,0)
      #      NEXT FIELD g_existno
      #   END IF
      #   OPEN p810_t_c1 USING g_existno,g_apz.apz02b
      #   FETCH p810_t_c1 INTO l_aba00,gl_date,gl_yy,gl_mm,l_abapost,
      #                        l_abaacti,l_aba20 #no.7378     #CHI-A20014 add l_aba20
      #   IF STATUS THEN
      #      CALL cl_err('sel aba:',STATUS,0)
      #      NEXT FIELD g_existno
      #   END IF
      #   #no.7378
      #   IF l_abaacti = 'N' THEN
      #      CALL cl_err('','mfg8001',1)
      #      NEXT FIELD g_existno
      #   END IF  
      #  #CHI-A20014---add---start---
      #   IF l_aba20 MATCHES '[Ss1]' THEN
      #      CALL cl_err('','mfg3557',0)
      #      NEXT FIELD g_existno
      #   END IF
      #  #CHI-A20014---add---end---
      #   #no.7378(end)
      #  #LET g_sql="SELECT aaa07 FROM ",g_dbs_gl CLIPPED,"aaa_file",   #FUN-A50102
      #   LET g_sql="SELECT aaa07 FROM ",cl_get_target_table(p_plant,'aaa_file'),    #FUN-A50102 
      #             " WHERE aaa01 = '",l_aba00,"'"
 	  #   CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      #   CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql    #FUN-A50102
      #   PREPARE p810_t_p2 FROM g_sql
      #   DECLARE p810_t_c2 CURSOR FOR p810_t_p2
      #   IF STATUS THEN
      #      CALL cl_err('decl aba_cursor2:',STATUS,0)
      #      NEXT FIELD g_existno
      #   END IF
      #   OPEN p810_t_c2
      #   FETCH p810_t_c2 INTO l_aaa07
      #   IF gl_date <= l_aaa07 THEN
      #      CALL cl_err(gl_date,'agl-200',0)
      #      NEXT FIELD g_existno
      #   END IF
      #   IF l_abapost = 'Y' THEN
      #      CALL cl_err(g_existno,'aap-130',0)
      #      NEXT FIELD g_existno
      #   END IF
      #   #No.FUN-680029 --start--
      #   IF g_aza.aza63 = 'Y' THEN
      #      SELECT npp00,npp011 INTO l_npp00,l_npp011
      #        FROM npp_file
      #       WHERE npp07 = p_acc
      #         AND nppglno = g_existno
      #         AND npptype = '0'
      #      SELECT UNIQUE npp07,nppglno INTO l_npp07,l_nppglno
      #        FROM npp_file
      #       WHERE npp01 IN (SELECT npp01 FROM npp_file WHERE npp07 = p_acc AND nppglno = g_existno AND npptype = '0' AND npp00 = l_npp00)
      #         AND npptype = '1'
      #         AND npp00 = l_npp00
      #         AND npp011= l_npp011
      #      IF cl_null(l_npp07) OR cl_null(l_nppglno) THEN
      #         CALL cl_err('','aap-986',1)
      #         NEXT FIELD g_existno
      #      END IF
      #      OPEN p810_t_c1 USING l_nppglno,g_apz.apz02c
      #      FETCH p810_t_c1 INTO l_aba00,gl_date,gl_yy,gl_mm,l_abapost,
      #                           l_abaacti,l_aba20       #CHI-A20014 add l_aba20
      #      IF STATUS THEN
      #         CALL cl_err('sel aba:',STATUS,0)
      #         NEXT FIELD g_existno
      #      END IF
      #      IF l_abaacti = 'N' THEN
      #         CALL cl_err('','mfg8003',1)
      #         NEXT FIELD g_existno
      #      END IF
      #     #CHI-A20014---add---start---
      #      IF l_aba20 MATCHES '[Ss1]' THEN
      #         CALL cl_err('','mfg3557',0)
      #         NEXT FIELD g_existno
      #      END IF
      #     #CHI-A20014---add---end---
      #     #LET g_sql="SELECT aaa07 FROM ",g_dbs_gl CLIPPED,"aaa_file",   #FUN-A50102
      #      LET g_sql="SELECT aaa07 FROM ",cl_get_target_table(p_plant,'aaa_file'),   #FUN-A50102 
      #                " WHERE aaa01 = '",l_aba00,"'"
 	  #      CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      #      CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql    #FUN-A50102
      #      PREPARE p810_t_p3 FROM g_sql
      #      DECLARE p810_t_c3 CURSOR FOR p810_t_p3
      #      IF STATUS THEN
      #         CALL cl_err('decl aba_cursor2:',STATUS,0)
      #         NEXT FIELD g_existno
      #      END IF
      #      OPEN p810_t_c3
      #      FETCH p810_t_c3 INTO l_aaa07
      #      IF gl_date <= l_aaa07 THEN
      #         CALL cl_err(gl_date,'agl-200',0)
      #         NEXT FIELD g_existno
      #      END IF
      #      IF l_abapost = 'Y' THEN
      #         CALL cl_err(l_nppglno,'aap-132',0)
      #         NEXT FIELD g_existno
      #      END IF
      #      LET p_acc1 = l_npp07
      #      LET g_existno1 = l_nppglno
      #      DISPLAY l_npp07 TO FORMONLY.p_acc1
      #      DISPLAY l_nppglno TO FORMONLY.g_existno1
      #   END IF
         #No.FUN-680029 --end--
      #FUN-D40105--mark--end--
 
       #No.B003 010413 by plum
      AFTER INPUT
         IF INT_FLAG THEN
            #EXIT INPUT     #FUN-D40105 mark
            EXIT DIALOG     #FUN-D40105 add
         END IF
         LET l_flag='N'
         IF cl_null(p_plant)   THEN
            LET l_flag='Y' 
         END IF
         IF cl_null(p_acc)     THEN 
            LET l_flag='Y'
         END IF
         #FUN-D40105--mark--str--
         #IF cl_null(g_existno) THEN 
         #   LET l_flag='Y'
         #END IF
         #FUN-D40105--mark--end--
         IF l_flag='Y' THEN
            CALL cl_err('','9033',0)
            NEXT FIELD p_plant
         END IF
       #FUN-A50102--mark--str--
       ## 得出總帳 database name
       ## g_apz.apz02p -> g_plant_new -> s_getdbs() -> g_dbs_new --> g_dbs_gl
       # LET g_plant_new= p_plant  # 工廠編號
       # CALL s_getdbs()
       # LET g_dbs_gl=g_dbs_new 
       #FUN-A50102--mark--end
       #No.B003...end

      #FUN-D40105--mark--str--
      #ON ACTION CONTROLR
      #   CALL cl_show_req_fields()
      #ON ACTION CONTROLG
      #   CALL cl_cmdask()
      #ON ACTION locale
      #  #->No.FUN-570112 --start--
      #  #LET g_action_choice='locale'
      #  #CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
      #   LET g_change_lang = TRUE
      #  #->No.FUN-570112 ---end---
      #   EXIT INPUT
      #ON ACTION exit
      #   LET INT_FLAG = 1
      #   EXIT INPUT
      #ON IDLE g_idle_seconds
      #   CALL cl_on_idle()
      #   CONTINUE INPUT
 
      #ON ACTION about         #MOD-4C0121
      #   CALL cl_about()      #MOD-4C0121
 
      #ON ACTION help          #MOD-4C0121
      #   CALL cl_show_help()  #MOD-4C0121
      #FUN-D40105--add--end--  

      ON ACTION CONTROLP           #FUN-D40105  add
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---

         #FUN-D40105--add--str-- 
         ##No.FUN-580031 --start--
         #ON ACTION qbe_select
         #   CALL cl_qbe_select()
         ##No.FUN-580031 ---end---
 
         ##No.FUN-580031 --start--
         #ON ACTION qbe_save
         #   CALL cl_qbe_save()
         ##No.FUN-580031 ---end---
         #FUN-D40105--add--end-- 
 
   END INPUT

   #FUN-D40105--add--str--
   CONSTRUCT BY NAME  tm.wc1 ON g_existno
      BEFORE CONSTRUCT
        CALL cl_qbe_init()

   AFTER FIELD g_existno
      IF tm.wc1 = " 1=1" THEN 
         CALL cl_err('','9033',0)
         NEXT FIELD g_existno 
      END IF  
     #MOD-G30031---add---str--
      IF GET_FLDBUF(g_existno) = "*" THEN
         CALL cl_err('','9089',1)
         NEXT FIELD g_existno
      END IF
     #MOD-G30031---add---end-- 
      CALL  p810_existno_chk() 
      IF g_success = 'N' THEN 
         CALL s_showmsg()
         NEXT FIELD g_existno
      END IF 

      ON ACTION CONTROLP
         CASE 
            WHEN INFIELD(g_existno)
              LET g_existno_str = ''
              CALL q_aba01_1( TRUE, TRUE, p_plant,p_acc,' ','LC')
              RETURNING g_existno_str   
              DISPLAY g_existno_str TO g_existno
              NEXT FIELD g_existno
         END CASE

   END CONSTRUCT

   INPUT BY NAME g_bgjob ATTRIBUTE(WITHOUT DEFAULTS=TRUE)

   END INPUT 
   
   ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG
         CALL cl_cmdask()
      ON ACTION locale
         LET g_change_lang = TRUE
      ON ACTION exit 
         LET INT_FLAG = 1
         EXIT DIALOG    
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG  
 
      ON ACTION about         
         CALL cl_about()     
 
      ON ACTION help         
         CALL cl_show_help() 
  
      ON ACTION ACCEPT
        #MOD-G30031---add---str--
         IF GET_FLDBUF(g_existno) = "*" THEN
            CALL cl_err('','9089',1)
            NEXT FIELD g_existno
         END IF
        #MOD-G30031---add---end--
         EXIT DIALOG        
       
      ON ACTION CANCEL
         LET INT_FLAG=1
         EXIT DIALOG 
 
      ON ACTION qbe_select
         CALL cl_qbe_select()
 
      ON ACTION qbe_save
         CALL cl_qbe_save()
   END DIALOG 
   #FUN-D40105--add--end--
  #->No.FUN-570112 --start--
  #IF g_action_choice = 'locale' THEN
  #   RETURN
   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
      CONTINUE WHILE
  #->No.FUN-570112 ---end---
   END IF
 #->No.FUN-570112
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p810_w
     #No.FUN-CB0096 ---start--- add
      LET l_time = TIME
      #FUN-D40105--add--str--
      IF  l_time = l_time_t   THEN 
         LET l_time = l_time + 1
      END IF 
      LET l_time_t = l_time
      #FUN-D40105--add--end--
      LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
      CALL s_log_data('U','100',g_id,'1',l_time,'','')
     #No.FUN-CB0096 ---end  --- add
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B30211
      EXIT PROGRAM
   END IF
   IF g_bgjob = "Y" THEN
      SELECT zz08 INTO lc_cmd FROM zz_file
       WHERE zz01 = "aapp810"
      IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
         CALL cl_err('aapp810','9031',1)   
      ELSE
         LET lc_cmd = lc_cmd CLIPPED,
                      " '",p_plant CLIPPED,"'",
                      " '",p_acc CLIPPED,"'",
                      " '",g_existno CLIPPED,"'",
                      " '",g_bgjob CLIPPED,"'"
         CALL cl_cmdat('aapp810',g_time,lc_cmd CLIPPED)
      END IF
      CLOSE WINDOW p810
     #No.FUN-CB0096 ---start--- add
      LET l_time = TIME
      #FUN-D40105--add--str--
      IF  l_time = l_time_t   THEN 
         LET l_time = l_time + 1
      END IF 
      LET l_time_t = l_time
      #FUN-D40105--add--end--
      LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
      CALL s_log_data('U','100',g_id,'1',l_time,'','')
     #No.FUN-CB0096 ---end  --- add
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B30211
      EXIT PROGRAM
   END IF
   EXIT WHILE   
END WHILE      
 #->No.FUN-570112
END FUNCTION
 
FUNCTION p810_t()
   DEFINE n1,n2,n3,n4,n5,n6,n7 LIKE type_file.num10       # No.FUN-690028 INTEGER
   DEFINE l_npp		RECORD LIKE npp_file.*
   DEFINE l_cnt         LIKE type_file.num5           #MOD-C20146 add 

IF g_aaz84 = '2' THEN   #還原方式為作廢 #no.4868
  #FUN-A50102--mod--str--
  #LET g_sql="UPDATE ",g_dbs_gl CLIPPED," aba_file  SET abaacti = 'N' ",

  #FUN-D40105--add--str--
  IF g_aza.aza63 = 'Y' THEN
     LET tm.wc1 = cl_replace_str(tm.wc1,"nppglno","aba01")
  END IF 
  #FUN-D40105--add--end--
  
   LET g_sql="UPDATE ",cl_get_target_table(p_plant,'aba_file'),
             "   SET abaacti = 'N' ",
  #FUN-A50102--mod--end
             #" WHERE aba01 = ? AND aba00 = ? "     #FUN-D40105  mark
             " WHERE  aba00 = ? ",                  #FUN-D40105 add
             "   AND ",tm.wc1                       #FUN-D40105 add
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
   CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql    #FUN-A50102
   PREPARE p810_updaba_p FROM g_sql
   #EXECUTE p810_updaba_p USING g_existno,g_apz.apz02b   #FUN-D40105  mark
   EXECUTE p810_updaba_p USING g_apz.apz02b              #FUN-D40105 add
   IF SQLCA.sqlcode THEN
      #CALL cl_err('(upd abaacti)',SQLCA.sqlcode,1)    #FUN-D40105  mark
      CALL s_errmsg('','','(upd abaacti)',SQLCA.sqlcode,1)  #FUN-D40105 add
      LET g_success = 'N' 
      RETURN
   END IF
ELSE
   IF g_bgjob = 'N' THEN    #FUN-570112
       DISPLAY "Delete GL's Voucher body!" AT 1,1 #-------------------------
   END IF
  #FUN-A50102--mod--str--
  #LET g_sql="DELETE FROM ",g_dbs_gl CLIPPED,"abb_file WHERE abb01=? AND abb00=?"

   #FUN-D40105--add--str--
   IF g_aza.aza63 = 'Y' THEN
      LET tm.wc1 = cl_replace_str(tm.wc1,"nppglno","abb01")
   ELSE
      LET tm.wc1 = cl_replace_str(tm.wc1,"aba01","abb01")
   END IF 
   #FUN-D40105--add--end--
  
   LET g_sql="DELETE FROM ",cl_get_target_table(p_plant,'abb_file'),
             #" WHERE abb01=? AND abb00=?"    #FUN-D40105  mark
             " WHERE  abb00 = ? ",            #FUN-D40105 add
             "   AND ",tm.wc1                 #FUN-D40105 add
  #FUN-A50102--mod--end
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
   CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql    #FUN-A50102
   PREPARE p810_2_p3 FROM g_sql
   #EXECUTE p810_2_p3 USING g_existno,g_apz.apz02b    #FUN-D40105  mark
   EXECUTE p810_2_p3 USING g_apz.apz02b               #FUN-D40105 add
   IF SQLCA.sqlcode THEN
      #CALL cl_err('(del abb)',SQLCA.sqlcode,1)        #FUN-D40105  mark
      CALL s_errmsg('','','(del abb)',SQLCA.sqlcode,1) #FUN-D40105 add
      LET g_success = 'N' 
      RETURN
   END IF
   IF g_bgjob = 'N' THEN    #FUN-570112
       DISPLAY "Delete GL's Voucher head!" AT 1,1 #-------------------------
   END IF
  #FUN-A50102--mod--str--
  #LET g_sql="DELETE FROM ",g_dbs_gl CLIPPED,"aba_file WHERE aba01=? AND aba00=?"
   LET tm.wc1 = cl_replace_str(tm.wc1,"abb01","aba01")     #FUN-D40105 add
   LET g_sql="DELETE FROM ",cl_get_target_table(p_plant,'aba_file'),
             #" WHERE aba01=? AND aba00=?"    #FUN-D40105 mark
             " WHERE  aba00 = ? ",            #FUN-D40105 add
             "   AND ",tm.wc1                 #FUN-D40105 add
  #FUN-A50102--mod--end
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
   CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql    #FUN-A50102
   PREPARE p810_2_p4 FROM g_sql
   #EXECUTE p810_2_p4 USING g_existno,g_apz.apz02b  #FUN-D40105 mark
   EXECUTE p810_2_p4 USING g_apz.apz02b             #FUN-D40105 add
   IF SQLCA.sqlcode THEN
      #CALL cl_err('(del aba)',SQLCA.sqlcode,1)        #FUN-D40105 mark
      CALL s_errmsg('','','(del aba)',SQLCA.sqlcode,1) #FUN-D40105 add
      LET g_success = 'N' 
      RETURN
   END IF
   IF SQLCA.sqlerrd[3] = 0 THEN
      #CALL cl_err('(del aba)','aap-161',1)            #FUN-D40105 mark
      CALL s_errmsg('','','(del aba)',SQLCA.sqlcode,1) #FUN-D40105 add
      LET g_success = 'N' 
      RETURN
   END IF
   IF g_bgjob = 'N' THEN    #FUN-570112
       DISPLAY "Delete GL's Voucher desp!" AT 1,1 #-------------------------
   END IF
  #FUN-A50102--mod--str--
  #LET g_sql="DELETE FROM ",g_dbs_gl CLIPPED,"abc_file WHERE abc01=? AND abc00=?"
   LET tm.wc1 = cl_replace_str(tm.wc1,"aba01","abc01")     #FUN-D40105 add
   LET g_sql="DELETE FROM ",cl_get_target_table(p_plant,'abc_file'),
             #" WHERE abc01=? AND abc00=?"    #FUN-D40105 mark
             " WHERE  abc00=?",               #FUN-D40105 add
             "   AND ",tm.wc1                 #FUN-D40105 add
  #FUN-A50102--mod--end
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
   CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql    #FUN-A50102
   PREPARE p810_2_p5 FROM g_sql
   #EXECUTE p810_2_p5 USING g_existno,g_apz.apz02b  #FUN-D40105 mark
   EXECUTE p810_2_p5 USING g_apz.apz02b             #FUN-D40105 add
   IF SQLCA.sqlcode THEN
      #CALL cl_err('(del abc)',SQLCA.sqlcode,1)        #FUN-D40105 mark
      CALL s_errmsg('','','(del abc)',SQLCA.sqlcode,1) #FUN-D40105 add
      LET g_success = 'N' 
      RETURN
   END IF
  #---------------------------MOD-C20146------------------------------------------start
   LET l_cnt = 0
   LET tm.wc1 = cl_replace_str(tm.wc1,"abc01","tic04")     #FUN-D40105 add
   LET g_sql="SELECT COUNT(*) FROM ",cl_get_target_table(p_plant,'tic_file'),
             #" WHERE tic04=? AND tic00=?"    #FUN-D40105 mark 
             " WHERE  tic00 =?",              #FUN-D40105 add
             "   AND ",tm.wc1                 #FUN-D40105 add
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql
   PREPARE p810_2_p11 FROM g_sql
   #EXECUTE p810_2_p11 USING g_existno,g_apz.apz02b INTO l_cnt  #FUN-D40105 mark 
   EXECUTE p810_2_p11 USING g_apz.apz02b INTO l_cnt             #FUN-D40105 add 
   IF l_cnt > 0 THEN
  #---------------------------MOD-C20146--------------------------------------------end
     #FUN-B40056 -begin
      LET g_sql="DELETE FROM ",cl_get_target_table(p_plant,'tic_file'),
                #" WHERE tic04=? AND tic00=?"    #FUN-D40105 mark 
                " WHERE  tic00 =?",              #FUN-D40105 add
                "   AND ",tm.wc1                 #FUN-D40105 add
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql       
      CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql
      PREPARE p810_2_p9 FROM g_sql
      #EXECUTE p810_2_p9 USING g_existno,g_apz.apz02b
      EXECUTE p810_2_p9 USING g_apz.apz02b
      IF SQLCA.sqlcode THEN
         #CALL cl_err('(del tic)',SQLCA.sqlcode,1)         #FUN-D40105 mark 
         CALL s_errmsg('','','(del tic)',SQLCA.sqlcode,1)  #FUN-D40105 add
         LET g_success = 'N' 
         RETURN
      END IF
     #FUN-B40056 -end
   END IF                      #MOD-C20146 add
END IF
#  CALL s_abhmod(g_dbs_gl,g_apz.apz02b,g_existno)   #MOD-590081 #CHI-780008  #FUN-980020 mark
   CALL s_abhmod(p_plant,g_apz.apz02b,g_existno)    #FUN-980020 
   IF g_success = 'N' THEN RETURN END IF
   LET g_msg = TIME
   #INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06) #FUN-980001 mark
   #              VALUES('aapp810',g_user,g_today,g_msg,g_existno,'delete') #FUN-980001 mark
   INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #FUN-980001 add
                 VALUES('aapp810',g_user,g_today,g_msg,g_existno,'delete',g_plant,g_legal) #FUN-980001 add
   #----------------------------------------------------------------------
   LET n1 = 0
   
   #UPDATE ala_file SET ala72 = NULL WHERE ala72 = g_existno   #預購申請 #FUN-D40105 mark
   #FUN-D40105--add--str--
   IF g_aaz84 = '2' THEN
      LET tm.wc1 = cl_replace_str(tm.wc1,"aba01","ala72")
   ELSE
      LET tm.wc1 = cl_replace_str(tm.wc1,"tic04","ala72")
   END IF    
   LET g_sql = "UPDATE ala_file SET ala72 = NULL ",
               " WHERE ",tm.wc1                
   PREPARE p810_pre_1 FROM g_sql
   EXECUTE p810_pre_1
   #FUN-D40105--add--end--
   IF STATUS THEN 
#  CALL cl_err('(upd ala72)',STATUS,1) #No.FUN-660122
   #CALL cl_err3("upd","ala_file",g_existno,"",STATUS,"","upd ala72",1)  #No.FUN-660122 #FUN-D40105 mark
      CALL s_errmsg('upd ala72','ala_file','',STATUS,1) #FUN-D40105 add
      LET g_success = 'N'                               #FUN-D40105 add 
   END IF
   LET n1=SQLCA.SQLERRD[3]
 
   #UPDATE alk_file SET alk72 = NULL WHERE alk72 = g_existno   #外購到貨  #FUN-D40105 mark
   #FUN-D40105--add--str--
   LET tm.wc1 = cl_replace_str(tm.wc1,"ala72","alk72") 
   LET g_sql = "UPDATE alk_file SET alk72 = NULL",
               " WHERE ",tm.wc1   
   PREPARE p810_pre_2 FROM g_sql
   EXECUTE p810_pre_2 
   #FUN-D40105--add--end--
   LET n1=n1+SQLCA.SQLERRD[3]
 
   #UPDATE apa_file SET apa44 = '-'  WHERE apa44 = g_existno   #外購到貨  #FUN-D40105 mark
   #FUN-D40105--add--str--
   LET tm.wc1 = cl_replace_str(tm.wc1,"alk72","apa44") 
   LET g_sql = "UPDATE apa_file SET apa44 = '-' ",
               " WHERE ",tm.wc1   
   PREPARE p810_pre_3 FROM g_sql
   EXECUTE p810_pre_3 
   #FUN-D40105--add--end--
   IF STATUS THEN 
#     CALL cl_err('(upd ala72)',STATUS,1) #No.FUN-660122
      #CALL cl_err3("upd","apa_file",g_existno,"",STATUS,"","upd ala72",1)  #No.FUN-660122  #FUN-D40105 mark
      CALL s_errmsg('upd ','apa_file','',STATUS,1) #FUN-D40105 add
      LET g_success = 'N'                          #FUN-D40105 add 
   END IF
   LET n2=SQLCA.SQLERRD[3]
 
   #UPDATE alh_file SET alh72 = NULL WHERE alh72 = g_existno   #外購到單  #FUN-D40105 mark
   #FUN-D40105--add--str--
   LET tm.wc1 = cl_replace_str(tm.wc1,"apa44","alh72") 
   LET g_sql = "UPDATE alh_file SET alh72 = NULL ",
               " WHERE ",tm.wc1   
   PREPARE p810_pre_4 FROM g_sql
   EXECUTE p810_pre_4 
   #FUN-D40105--add--end--
   IF STATUS THEN 
#     CALL cl_err('(upd ala72)',STATUS,1) #No.FUN-660122
      #CALL cl_err3("upd","alh_file",g_existno,"",STATUS,"","upd ala72",1)  #No.FUN-660122
      CALL s_errmsg('upd ','alh_file','',STATUS,1) #FUN-D40105 add
      LET g_success = 'N'                          #FUN-D40105 add 
   END IF
   LET n3=SQLCA.SQLERRD[3]
 
   #UPDATE ala_file SET ala74 = NULL WHERE ala74 = g_existno   #外購付款  #FUN-D40105 mark
   #FUN-D40105--add--str--
   LET tm.wc1 = cl_replace_str(tm.wc1,"alh72","ala74") 
   LET g_sql = "UPDATE ala_file SET ala74 = NULL ",
               " WHERE ",tm.wc1   
   PREPARE p810_pre_5 FROM g_sql
   EXECUTE p810_pre_5 
   #FUN-D40105--add--end--
   IF STATUS THEN 
#     CALL cl_err('(upd ala72)',STATUS,1) #No.FUN-660122
      #CALL cl_err3("upd","ala_file",g_existno,"",STATUS,"","upd ala72",1)  #No.FUN-660122  #FUN-D40105 mark
      CALL s_errmsg('upd ','ala_file','',STATUS,1) #FUN-D40105 add
      LET g_success = 'N'                          #FUN-D40105 add 
   END IF
   LET n4=SQLCA.SQLERRD[3]
 
   #UPDATE alc_file SET alc74 = NULL WHERE alc74 = g_existno AND    #FUN-D40105 mark
   #                                       alc02 <> 0  #MOD-640018  #修改付款 #CHI-AA0015 mod '0'->0  #FUN-D40105 mark
   #FUN-D40105--add--str--
   LET tm.wc1 = cl_replace_str(tm.wc1,"ala74","alc74") 
   LET g_sql = "UPDATE alc_file SET alc74 = NULL ",
               " WHERE alc02 <> 0 ",
               "   AND ",tm.wc1   
   PREPARE p810_pre_6 FROM g_sql
   EXECUTE p810_pre_6 
   #FUN-D40105--add--end--
   IF STATUS THEN 
#     CALL cl_err('(upd ala72)',STATUS,1) #No.FUN-660122
      #CALL cl_err3("upd","alc_file",g_existno,"",STATUS,"","upd ala72",1)  #No.FUN-660122  #FUN-D40105 mark
      CALL s_errmsg('upd ','alc_file','',STATUS,1) #FUN-D40105 add   
      LET g_success = 'N'                          #FUN-D40105 add 
   END IF
   LET n5=SQLCA.SQLERRD[3]
 
   #UPDATE alc_file SET alc72 = NULL WHERE alc72 = g_existno AND   #FUN-D40105 mark
   #                                       alc02 <> 0  #MOD-640018  #外購修改 #CHI-AA0015 mod '0'->0  #FUN-D40105 mark
   #FUN-D40105--add--str--
   LET tm.wc1 = cl_replace_str(tm.wc1,"alc74","alc72") 
   LET g_sql = "UPDATE alc_file SET alc72 = NULL ",
               " WHERE alc02 <> 0 ",
               "   AND ",tm.wc1   
   PREPARE p810_pre_7 FROM g_sql
   EXECUTE p810_pre_7 
   #FUN-D40105--add--end--                                       
   IF STATUS THEN 
#     CALL cl_err('(upd ala72)',STATUS,1) #No.FUN-660122
      #CALL cl_err3("upd","alc_file",g_existno,"",STATUS,"","upd ala72",1)  #No.FUN-660122  #FUN-D40105 mark
      CALL s_errmsg('upd ','alc_file','',STATUS,1) #FUN-D40105 add
      LET g_success = 'N'                          #FUN-D40105 add 
   END IF
   LET n6=SQLCA.SQLERRD[3]
 
   UPDATE ala_file SET ala75 = NULL WHERE ala75 = g_existno   #結案
   #FUN-D40105--add--str--
   LET tm.wc1 = cl_replace_str(tm.wc1,"alc72","ala75") 
   LET g_sql = "UPDATE ala_file SET ala75 = NULL ",
               " WHERE ",tm.wc1  
   PREPARE p810_pre_8 FROM g_sql
   EXECUTE p810_pre_8 
   #FUN-D40105--add--end-- 
   IF STATUS THEN 
#     CALL cl_err('(upd ala72)',STATUS,1) #No.FUN-660122
      #CALL cl_err3("upd","ala_file",g_existno,"",STATUS,"","upd ala72",1)  #No.FUN-660122  #FUN-D40105 mark
      CALL s_errmsg('upd ','ala_file','',STATUS,1) #FUN-D40105 add
      LET g_success = 'N'                          #FUN-D40105 add 
   END IF
   LET n7=SQLCA.SQLERRD[3]
 
   IF n1+n2+n3+n4+n5+n6+n7 = 0 THEN
      #CALL cl_err('upd ala/alk/alh/alc:','aap-161',1)        #FUN-D40105 mark
      CALL s_errmsg('upd ala/alk/alh/alc:','','','aap-161',1) #FUN-D40105 add
      LET g_success='N' 
      RETURN
   END IF
   #----------------------------------------------------------------------
   #FUN-D40105--mark--str--
   #UPDATE npp_file SET npp03   = NULL,
   #                    nppglno = NULL,
   #                    npp06   = NULL,
   #                    npp07   = NULL
   # WHERE nppglno=g_existno
   #   AND npptype = '0'          #No.FUN-680029
   #   AND npp07 = g_apz.apz02b   #No.FUN-680029
   #FUN-D40105--add--end--
   #FUN-D40105--add--str--
   LET tm.wc1 = cl_replace_str(tm.wc1,"ala75","nppglno")         
   LET g_sql = "UPDATE npp_file SET npp03= NULL,nppglno = NULL,npp06 = NULL,npp07 = NULL",
               " WHERE ",tm.wc1,
               " AND npptype = '0'",
               " AND npp07 ='", g_apz.apz02b,"'"
   PREPARE p810_pre_9 FROM g_sql
   EXECUTE p810_pre_9
   #FUN-D40105--add--end--
   IF STATUS THEN
#     CALL cl_err('(upd npp03)',STATUS,1)    #No.FUN-660122                 
      #CALL cl_err3("upd","npp_file",g_existno,"",STATUS,"","upd npp03",1)  #No.FUN-660122  #FUN-D40105 mark
      CALL s_errmsg('upd ','npp_file','',STATUS,1) #FUN-D40105 add
      LET g_success='N' RETURN
   END IF
  #No.FUN-CB0096 ---start--- Add
   LET l_time = TIME
   #FUN-D40105--add--str--
   IF l_time = l_time_t   THEN 
      LET l_time = l_time + 1
   END IF 
   LET l_time_t = l_time
   #FUN-D40105--add--end--
   LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
   CALL s_log_data('I','114',g_id,'2',l_time,g_existno,'')
  #No.FUN-CB0096 ---end  --- Add
END FUNCTION
 
#No.FUN-680029 --start--
FUNCTION p810_t_1()
   DEFINE l_npp		RECORD LIKE npp_file.*
   DEFINE l_cnt         LIKE type_file.num5           #MOD-C20146 add 

   LET tm.wc1 = "aba01 IN (",g_existno1_str,")"  #FUN-D40105  add
   
   IF g_aaz84 = '2' THEN   #還原方式為作廢 
     #FUN-A50102--mod--str--
     #LET g_sql="UPDATE ",g_dbs_gl CLIPPED," aba_file  SET abaacti = 'N' ",
      LET g_sql="UPDATE ",cl_get_target_table(p_plant,'aba_file'),
                "   SET abaacti = 'N' ",
     #FUN-A50102--mod--end
                #" WHERE aba01 = ? AND aba00 = ? "        #FUN-D40105 mark
                " WHERE  aba00 = ? ",                     #FUN-D40105 add
                "   AND ",tm.wc1                          #FUN-D40105 add    
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql    #FUN-A50102
      PREPARE p810_updaba_p1 FROM g_sql
      #EXECUTE p810_updaba_p1 USING g_existno1,g_apz.apz02c  #FUN-D40105 mark
      EXECUTE p810_updaba_p1 USING g_apz.apz02c              #FUN-D40105 add
      IF SQLCA.sqlcode THEN
         #CALL cl_err('(upd abaacti)',SQLCA.sqlcode,1)        #FUN-D40105 mark
         CALL s_errmsg('','(upd abaacti)','',SQLCA.sqlcode,1) #FUN-D40105 add
         LET g_success = 'N' 
         RETURN
      END IF
   ELSE
      IF g_bgjob = 'N' THEN
          DISPLAY "Delete GL's Voucher body!" AT 1,1
      END IF
     #FUN-A50102--mod--str--
     #LET g_sql="DELETE FROM ",g_dbs_gl CLIPPED,"abb_file WHERE abb01=? AND abb00=?"
      LET tm.wc1 = cl_replace_str(tm.wc1,"aba01","abb01")          #FUN-D40105 add
      LET g_sql="DELETE FROM ",cl_get_target_table(p_plant,'abb_file'),
                #" WHERE abb01=? AND abb00=?"     #FUN-D40105 mark
                " WHERE  abb00=?",                #FUN-D40105 add  
                "   AND ",tm.wc1                  #FUN-D40105 add   
     #FUN-A50102--mod--end
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql    #FUN-A50102
      PREPARE p810_2_p6 FROM g_sql
      #EXECUTE p810_2_p6 USING g_existno1,g_apz.apz02c  #FUN-D40105 mark
      EXECUTE p810_2_p6 USING g_apz.apz02c              #FUN-D40105 add  
      IF SQLCA.sqlcode THEN
         #CALL cl_err('(del abb)',SQLCA.sqlcode,1)        #FUN-D40105 mark 
         CALL s_errmsg('','(del abb)','',SQLCA.sqlcode,1) #FUN-D40105 add
         LET g_success = 'N' 
         RETURN
      END IF
      IF g_bgjob = 'N' THEN
          DISPLAY "Delete GL's Voucher head!" AT 1,1
      END IF
     #FUN-A50102--mod--str--
     #LET g_sql="DELETE FROM ",g_dbs_gl CLIPPED,"aba_file WHERE aba01=? AND aba00=?"
      LET tm.wc1 = cl_replace_str(tm.wc1,"abb01","aba01")          #FUN-D40105 add
      LET g_sql="DELETE FROM ",cl_get_target_table(p_plant,'aba_file'),
                #" WHERE aba01=? AND aba00=?"    #FUN-D40105 mark
                " WHERE  aba00=?",               #FUN-D40105 add
                "   AND ",tm.wc1                 #FUN-D40105 add  
     #FUN-A50102--mod--end
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql    #FUN-A50102
      PREPARE p810_2_p7 FROM g_sql
      #EXECUTE p810_2_p7 USING g_existno1,g_apz.apz02c
      EXECUTE p810_2_p7 USING g_apz.apz02c
      IF SQLCA.sqlcode THEN
         #CALL cl_err('(del aba)',SQLCA.sqlcode,1)         #FUN-D40105 mark
         CALL s_errmsg('','(del aba)','',SQLCA.sqlcode,1)  #FUN-D40105 add
         LET g_success = 'N' 
         RETURN
      END IF
      IF SQLCA.sqlerrd[3] = 0 THEN
         #CALL cl_err('(del aba)','aap-161',1)        #FUN-D40105 mark 
         CALL s_errmsg('','(del aba)','','aap-161',1) #FUN-D40105 add
         LET g_success = 'N' 
         RETURN
      END IF
      IF g_bgjob = 'N' THEN 
          DISPLAY "Delete GL's Voucher desp!" AT 1,1
      END IF
     #FUN-A50102--mod--str--
     #LET g_sql="DELETE FROM ",g_dbs_gl CLIPPED,"abc_file WHERE abc01=? AND abc00=?"
      LET tm.wc1 = cl_replace_str(tm.wc1,"aba01","abc01")          #FUN-D40105 add
      LET g_sql="DELETE FROM ",cl_get_target_table(p_plant,'abc_file'),
                #" WHERE abc01=? AND abc00=?"   #FUN-D40105 mark
                " WHERE  abc00=?",              #FUN-D40105 add
                "   AND ",tm.wc1                #FUN-D40105 add 
     #FUN-A50102--mod--end
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql    #FUN-A50102
      PREPARE p810_2_p8 FROM g_sql
      #EXECUTE p810_2_p8 USING g_existno1,g_apz.apz02c  #FUN-D40105 mark
      EXECUTE p810_2_p8 USING g_apz.apz02c              #FUN-D40105 add
      IF SQLCA.sqlcode THEN
         #CALL cl_err('(del abc)',SQLCA.sqlcode,1)        #FUN-D40105 mark
         CALL s_errmsg('','(del abc)','',SQLCA.sqlcode,1) #FUN-D40105 add
         LET g_success = 'N' 
         RETURN
      END IF
     #---------------------------MOD-C20146------------------------------------------start
      LET l_cnt = 0
      LET tm.wc1 = cl_replace_str(tm.wc1,"abc01","tic04")          #FUN-D40105 add
      LET g_sql="SELECT COUNT(*) FROM ",cl_get_target_table(p_plant,'tic_file'),
                #" WHERE tic04=? AND tic00=?"   #FUN-D40105 mark
                " WHERE  tic00 =?",             #FUN-D40105 add
                "   AND ",tm.wc1                #FUN-D40105 add
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql
      PREPARE p810_2_p12 FROM g_sql
      #EXECUTE p810_2_p12 USING g_existno1,g_apz.apz02c INTO l_cnt  #FUN-D40105 mark
      EXECUTE p810_2_p12 USING g_apz.apz02c INTO l_cnt  #FUN-D40105 add
      IF l_cnt > 0 THEN
     #---------------------------MOD-C20146--------------------------------------------end
        #FUN-B40056 -begin
         LET g_sql="DELETE FROM ",cl_get_target_table(p_plant,'tic_file'),
                   #" WHERE tic04=? AND tic00=?"   #FUN-D40105 mark
                   " WHERE  tic00 =?",             #FUN-D40105 add
                   "   AND ",tm.wc1                #FUN-D40105 add  
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql       
         CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql
         PREPARE p810_2_p10 FROM g_sql
         #EXECUTE p810_2_p10 USING g_existno1,g_apz.apz02c   #FUN-D40105 mark
         EXECUTE p810_2_p10 USING g_apz.apz02c               #FUN-D40105 add
         IF SQLCA.sqlcode THEN
            #CALL cl_err('(del tic)',SQLCA.sqlcode,1)        #FUN-D40105 mark
            CALL s_errmsg('','(del tic)','',SQLCA.sqlcode,1) #FUN-D40105 add
            LET g_success = 'N' 
            RETURN
         END IF
        #FUN-B40056 -end
      END IF                        #MOD-C20146 add
   END IF
 
   IF g_success = 'N' THEN RETURN END IF
   LET g_msg = TIME
   #INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06) #FUN-980001 mark
   #              VALUES('aapp810',g_user,g_today,g_msg,g_existno1,'delete') #FUN-980001 mark
   INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #FUN-980001 add
                 VALUES('aapp810',g_user,g_today,g_msg,g_existno1,'delete',g_plant,g_legal) #FUN-980001 add
 
   #FUN-D40105--mark--str--
   #UPDATE npp_file SET npp03   = NULL,
   #                    nppglno = NULL,
   #                    npp06   = NULL,
   #                    npp07   = NULL
   # WHERE nppglno= g_existno1
   #   AND npptype = '1' 
   #   AND npp07 = g_apz.apz02c 
   #FUN-D40105--mark--end--
   #FUN-D40105--add--str--
   IF g_aaz84 = '2' THEN  
      LET tm.wc1 = cl_replace_str(tm.wc1,"aba01","nppglno") 
   ELSE 
      LET tm.wc1 = cl_replace_str(tm.wc1,"tic04","nppglno")  
   END IF       
   LET g_sql = "UPDATE npp_file SET npp03= NULL,nppglno = NULL,npp06 = NULL,npp07 = NULL",
               " WHERE ",tm.wc1,
               "   AND npptype = '1' ",
               "   AND npp07 ='",g_apz.apz02c,"'"  
   PREPARE p810_pre_10 FROM g_sql
   EXECUTE p810_pre_10
   #FUN-D40105--add--end--
   IF STATUS THEN
      #CALL cl_err3("upd","npp_file",g_existno1,"",STATUS,"","upd npp03",1) #FUN-D40105 mark
      CALL s_errmsg('','npp_file','',SQLCA.sqlcode,1)  #FUN-D40105 add
      LET g_success='N' RETURN
   END IF
  #No.FUN-CB0096 ---start--- Add
   LET l_time = TIME
   #FUN-D40105--add--str--
   IF l_time = l_time_t   THEN 
      LET l_time = l_time + 1
   END IF 
   LET l_time_t = l_time
   #FUN-D40105--add--end--
   LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
   CALL s_log_data('I','114',g_id,'2',l_time,g_existno,'')
  #No.FUN-CB0096 ---end  --- Add
END FUNCTION
#No.FUN-680029 --end--

#FUN-D40105--add--str--
FUNCTION p810_existno_chk()
   DEFINE   l_chk_bookno       LIKE type_file.num5    
   DEFINE   l_chk_bookno1      LIKE type_file.num5    
   DEFINE   l_abapost,l_flag   LIKE type_file.chr1    
   DEFINE   l_aba19            LIKE aba_file.aba19 
   DEFINE   l_abaacti          LIKE aba_file.abaacti
   DEFINE   l_aba01            LIKE aba_file.aba01 
   DEFINE   l_aba00            LIKE aba_file.aba00
   DEFINE   l_aba06            LIKE aba_file.aba06   #MOD-G30031 add 
   DEFINE   l_aaa07            LIKE aaa_file.aaa07 
   DEFINE   l_npp00            LIKE npp_file.npp00 
   DEFINE   l_npp01            LIKE npp_file.npp01
   DEFINE   l_npp07            LIKE npp_file.npp07     
   DEFINE   l_nppglno          LIKE npp_file.nppglno   
   DEFINE   l_cnt              LIKE type_file.num5    
   DEFINE   lc_cmd             LIKE type_file.chr1000 
   DEFINE   l_sql              STRING        
   DEFINE   l_cnt1             LIKE type_file.num5     
   DEFINE   l_aba20            LIKE aba_file.aba20    
   DEFINE   l_npp011           LIKE npp_file.npp011

   CALL s_showmsg_init()
   LET g_existno1 = NULL
   LET g_success = 'Y' 
   LET tm.wc1 = cl_replace_str(tm.wc1,"g_existno","aba01")
   LET g_sql="SELECT aba01,aba00,aba02,aba03,aba04,abapost,abaacti,aba20,aba06 FROM ",   #MOD-G30031 add aba06 
             cl_get_target_table(p_plant,'aba_file'), 
            #" WHERE aba00 = ? AND aba06='LC'",   #MOD-G30031 mark
             " WHERE aba00 = ? ",                 #MOD-G30031 add
             "   AND ",tm.wc1
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql   
   CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql    
   PREPARE p810_t_p4 FROM g_sql
   DECLARE p810_t_c4 CURSOR FOR p810_t_p4
   IF STATUS THEN
      CALL s_errmsg('decl aba_cursor:','','',STATUS,1)
      LET g_success = 'N'
      RETURN
   END IF
   FOREACH p810_t_c4 USING g_apz.apz02b INTO l_aba01,l_aba00,gl_date,gl_yy,gl_mm,l_abapost,
                                                       l_abaacti,l_aba20,l_aba06   #MOD-G30031 add l_aba06 
      IF STATUS THEN
         CALL s_errmsg('sel aba:',l_aba01,'',STATUS,1)
         LET g_success = 'N'
         RETURN
      END IF
      IF l_abaacti = 'N' THEN
         CALL s_errmsg('',l_aba01,'','mfg8001',1)
         LET g_success = 'N'
         RETURN
      END IF
      IF l_aba20 MATCHES '[Ss1]' THEN
         CALL s_errmsg('',l_aba01,'','mfg3557',1)
         LET g_success ='N'
         RETURN
      END IF
     #MOD-G30031---add---str--
      IF l_aba06 <> 'LC' THEN
         CALL s_errmsg('sel aba:',l_aba01,'','agl040',1)
         LET g_success = 'N'
      END IF
     #MOD-G30031---add---end--
      LET g_sql="SELECT aaa07 FROM ",cl_get_target_table(p_plant,'aaa_file'),   
                " WHERE aaa01 = '",l_aba00,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
      CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql    
      PREPARE p810_t_p5 FROM g_sql
      DECLARE p810_t_c5 CURSOR FOR p810_t_p5
      IF STATUS THEN
         CALL s_errmsg('decl aba_cursor2:',l_aba00,'',STATUS,1)
         LET g_success = 'N'
         RETURN
      END IF
      OPEN p810_t_c5
      FETCH p810_t_c5 INTO l_aaa07
      IF gl_date <= l_aaa07 THEN
         CALL s_errmsg(gl_date,l_aba01,'','agl-200',1)
         LET g_success = 'N'
         RETURN
      END IF
      IF l_abapost = 'Y' THEN
         CALL s_errmsg('',l_aba01,'','aap-130',1)
         LET g_success = 'N'
         RETURN
      END IF
   END FOREACH 
   IF g_aza.aza63 = 'Y' THEN
      LET tm.wc1 = cl_replace_str(tm.wc1,"aba01","nppglno")
      LET g_sql = "SELECT UNIQUE npp07,nppglno  ",
                     "  FROM npp_file",
                     "  WHERE npp01 IN (SELECT npp01 FROM npp_file ",
                     "  WHERE npp07 = '",p_acc,"'",
                     "    AND npptype = '0' ",
                     "    AND ",tm.wc1,
                     " )", 
                     "    AND npptype = '1'"
      PREPARE p810_pre_chk1 FROM g_sql
      DECLARE p810_c_chk1 CURSOR FOR p810_pre_chk1
      FOREACH p810_c_chk1 INTO l_npp07,l_nppglno
         IF cl_null(l_npp07) OR cl_null(l_nppglno) THEN
            #CALL s_errmsg('','','','aap-986',1)         #TQC-D60072 mark
            CALL s_errmsg('',l_nppglno,'','aap-986',1)   #TQC-D60072 add
            LET g_success = 'N'
            RETURN
         END IF

         LET g_sql="SELECT aba01,aba00,aba02,aba03,aba04,abapost,abaacti,aba20 FROM ",   
                   cl_get_target_table(p_plant,'aba_file'), 
                   " WHERE aba01 = ? AND aba00 = ? AND aba06='LC'"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql   
         CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql    
         PREPARE p810_t_p4_1 FROM g_sql
         DECLARE p810_t_c4_1 CURSOR FOR p810_t_p4_1
         
         FOREACH p810_t_c4_1 USING l_nppglno,g_apz.apz02c
                              INTO l_aba01,l_aba00,gl_date,gl_yy,gl_mm,l_abapost,
                                   l_abaacti,l_aba20     
            IF STATUS THEN
               CALL s_errmsg('sel aba:','','',STATUS,1)
               LET g_success = 'N'
               RETURN
            END IF
            IF l_abaacti = 'N' THEN
               CALL s_errmsg('',l_aba01,'','mfg8003',1)
               LET g_success = 'N'
               RETURN
            END IF
            IF l_aba20 MATCHES '[Ss1]' THEN
               CALL s_errmsg('',l_aba01,'','mfg3557',1)
               LET g_success ='N'
               RETURN
            END IF
            LET g_sql="SELECT aaa07 FROM ",cl_get_target_table(p_plant,'aaa_file'),   
                      " WHERE aaa01 = '",l_aba00,"'"
 	        CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
            CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql    
            PREPARE p810_t_p6 FROM g_sql
            DECLARE p810_t_c6 CURSOR FOR p810_t_p6
            IF STATUS THEN
               CALL s_errmsg('decl aba_cursor2:','','',STATUS,1)
               LET g_success = 'N'
               RETURN
            END IF
            OPEN p810_t_c6
            FETCH p810_t_c6 INTO l_aaa07
            IF gl_date <= l_aaa07 THEN
               CALL s_errmsg(gl_date,l_aba01,'','agl-200',1)
               LET g_success = 'N'
               RETURN
            END IF
            IF l_abapost = 'Y' THEN
               CALL s_errmsg('',l_aba01,'','aap-132',1)
               LET g_success = 'N'
               RETURN
            END IF
         END FOREACH 
         IF cl_null(g_existno1) THEN 
            LET g_existno1 = "'",l_nppglno,"'"
            LET g_existno1_str = g_existno1
         ELSE
            LET g_existno1_str = g_existno1_str,",","'",l_nppglno,"'"
         END IF 
      END FOREACH 
   END IF
   LET p_acc1 = l_npp07
   DISPLAY l_npp07 TO FORMONLY.p_acc1
   DISPLAY g_existno1_str TO FORMONLY.g_existno1   
END FUNCTION 
#FUN-D40105--add--end--
