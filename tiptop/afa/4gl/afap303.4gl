# Prog. Version..: '5.30.08-13.07.05(00000)'     #
#
# Pattern name...: afap303.4gl
# Descriptions...: FA系統傳票拋轉還原
# Date & Author..: 97/05/19 By Danny
# Modify.........: No:A099 04/06/29 By Danny 大陸折舊方式/減值準備/資產停用
# Modify.........: No.MOD-590096 05/09/07 By wujie 傳票號碼加大到16碼  
# Modify.........: MOD-590081 05/09/20 By Smapmin 取消call s_abhmod()
# Modify.........: No.FUN-570144 06/03/03 By yiting 批次作業背景執行功能
# Modify.........: No.FUN-660136 06/06/20 By Ice cl_err --> cl_err3
# Modify.........: No.FUN-670039 06/07/11 By Carrier 帳別擴充為5碼
# Modify.........: No.FUN-680028 06/08/22 By day 多帳套修改
# Modify.........: No.FUN-680070 06/09/07 By johnray 欄位形態定義改為LIKE形式,并入FUN-680028過單
# Modify.........: No.FUN-690113 06/10/13 By yjkhero cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.MOD-6B0075    06/11/14 By xufeng  將成會關帳日改成總帳關帳日 
# Modify.........: No.CHI-780008 07/08/13 By Smapmin 還原MOD-590081
# Modify.........: No.CHI-7C0035 08/03/05 By Smapmin 必要輸入欄位改由畫面檔控制
# Modify.........: No.FUN-980003 09/08/13 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980020 09/08/30 By douzh GP5.2架構重整，修改sub相關傳參
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-990031 09/10/12 By lutingtingGP5.2財務營運中心欄位調整,營運中心要控制在同一法人下
# Modify.........: No:CHI-A20014 10/02/25 By sabrina 送簽中或已核准不可還原
# Modify.........: No.FUN-A50102 10/06/02 By lutingting 跨庫寫法統一改為用cl_get_target_table()來實現 
# Modify.........: No.FUN-AB0088 11/04/06 By lixiang 固定资料財簽二功能
# Modify.........: No:MOD-B40034 11/04/07 By Dido 折舊檢核調整 
# Modify.........: No:FUN-B40056 11/06/03 By guoch 刪除資料時一併刪除tic_file的資料
# Modify.........: No:FUN-B60140 11/09/06 By minpp "財簽二二次改善"追單
# Modify.........: No:FUN-BC0035 12/01/16 By Sakura 增加g_type=14判斷
# Modify.........: No:FUN-C50113 12/05/28 By minpp afai104拋轉總帳還原調用
# Modify.........: No:CHI-C20017 12/05/30 By wangrr 若g_bgjob='Y'時使用彙總訊息方式呈現
# Modify.........: No.FUN-CB0096 13/01/10 by zhangweib 增加log檔記錄程序運行過程
# Modify.........: No.FUN-D40105 13/06/26 by lujh 憑證編號開窗可多選
# Modify.........: No.TQC-D60072 13/04/28 by lujh 報錯訊息要有憑證編號
# Modify.........: No:MOD-G30031 16/03/09 By doris 1.輸入時,傳票編號不允許打*號 
#                                                  2.拋轉還原時多控卡不允許刪除不同來源碼的傳票 

DATABASE ds
 
GLOBALS "../../config/top.global"
 
 DEFINE g_wc,g_sql       string  #No.FUN-580092 HCN
DEFINE g_dbs_gl 	LIKE type_file.chr21        #No.FUN-680070 VARCHAR(21)
DEFINE p_plant          LIKE type_file.chr20           #No.FUN-680070 VARCHAR(12)
DEFINE p_acc            LIKE aaa_file.aaa01    #No.FUN-670039
DEFINE p_acc1           LIKE aaa_file.aaa01    #No.FUN-680028
DEFINE gl_date		LIKE type_file.dat          #No.FUN-680070 DATE
DEFINE gl_yy,gl_mm	LIKE type_file.num5         #No.FUN-680070 SMALLINT
DEFINE g_existno	LIKE type_file.chr20 	#No.MOD-590096       #No.FUN-680070 VARCHAR(16)
DEFINE g_existno1	LIKE type_file.chr20 	#No.FUN-680028       #No.FUN-680070 VARCHAR(16)
DEFINE g_type           LIKE type_file.num5         #No.FUN-680070 SMALLINT
DEFINE g_str 		LIKE type_file.chr3         #No.FUN-680070 VARCHAR(3)
DEFINE g_mxno		LIKE type_file.chr8         #No.FUN-680070 VARCHAR(8)
DEFINE p_row,p_col      LIKE type_file.num5         #No.FUN-680070 SMALLINT
DEFINE g_aaz84          LIKE aaz_file.aaz84, #還原方式 1.刪除 2.作廢 no.4868
       g_change_lang    LIKE type_file.chr1                  #是否有做語言切換 No.FUN-570144       #No.FUN-680070 VARCHAR(01)
 
DEFINE   g_msg           LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(72#No.FUN-CB0096 ---start--- Add
DEFINE g_id     LIKE azu_file.azu00
DEFINE l_id     STRING
DEFINE l_time   LIKE type_file.chr8
DEFINE gl_no    LIKE type_file.chr20
#No.FUN-CB0096 ---end  --- Add)
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
DEFINE l_aba19           LIKE aba_file.aba19   #No.FUN-680028
DEFINE l_abapost         LIKE aba_file.abapost #No.FUN-680028
DEFINE l_abaacti         LIKE aba_file.abaacti #No.FUN-680028
#     DEFINE     l_time LIKE type_file.chr8              #No.FUN-6A0069
     DEFINE l_flag      LIKE type_file.chr1    #No.FUN-570144       #No.FUN-680070 VARCHAR(1)
DEFINE l_aaa07          LIKE aaa_file.aaa07    #MOD-6B0075
DEFINE l_aba20          LIKE aba_file.aba20    #CHI-A20014 add
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
#->No.FUN-570144 --start--
   INITIALIZE g_bgjob_msgfile TO NULL
   LET p_plant   = ARG_VAL(1)           #
   LET p_acc     = ARG_VAL(2)           #
   LET g_existno = ARG_VAL(3)           #
   LET g_type    = ARG_VAL(4)           #
   LET g_bgjob   = ARG_VAL(5)           #背景作業
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
  
#->No.FUN-570144 ---end---
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690113
   #No.FUN-CB0096 ---start--- Add
    LET l_time = TIME        
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
 
#NO.FUN-570144 MARK--
#    OPEN WINDOW p303 AT p_row,p_col WITH FORM "afa/42f/afap303" 
#       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
#    CALL cl_ui_init()
#NO.FUN-570144 MARK--
 
    CALL cl_opmsg('z')
#->No.FUN-570144 --start--
   LET g_success = 'Y'
   WHILE TRUE
      CALL s_showmsg_init()  #CHI-C20017 add
      IF g_bgjob = "N" THEN
         CALL p303_ask()
         #FUN-D40105--add--str--
         IF tm.wc1 = " 1=1" THEN
            CALL cl_err('','9033',0)
            CONTINUE WHILE  
         END IF
         IF cl_null(g_type) THEN 
            CALL cl_err('','9033',0)
            CONTINUE WHILE
         END IF 
         #FUN-D40105--add--end--
         IF cl_sure(18,20) THEN
            LET g_success = 'Y'
            BEGIN WORK
            #FUN-D40105--add--str--
            CALL p303_existno_chk()
            IF g_success = 'N' THEN 
                CALL s_showmsg()
                CONTINUE WHILE 
            END IF 
            #FUN-D40105--add--end--
            CALL p303()
            #CALL s_showmsg_init()  #CHI-C20017 add  #FUN-D40105 mark
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
               CLOSE WINDOW p303
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         #No.FUN-680028--begin
         LET g_plant_new=p_plant                                                
         CALL s_getdbs()                                                        
         LET g_dbs_gl=g_dbs_new  

         LET tm.wc1 = "g_existno IN ('",g_existno,"')"  #FUN-D40105  add
         CALL p303_existno_chk()  #FUN-D40105  add

         #FUN-D40105--mark--end--
         #LET g_sql="SELECT aba02,abapost,aba19,abaacti,aba20 ",   #CHI-A20014 add aba20
         #         #"  FROM ",g_dbs_gl,"aba_file",  #FUN-A50102
         #          "  FROM ",cl_get_target_table(g_plant_new,'aba_file'),   #FUN-A50102
         #          " WHERE aba01 = ? AND aba00 = ? AND aba06='FA'"
 	     #CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
         #CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
         #PREPARE p303_t_p11 FROM g_sql
         #DECLARE p303_t_c11 CURSOR FOR p303_t_p11
         #IF STATUS THEN
         #   #CALL cl_err('decl aba_cursor:',STATUS,0) #CHI-C20017 mark
         #   CALL s_errmsg('','','decl aba_cursor:',STATUS,1)  #CHI-C20017 add
         #   LET g_success = 'N'                                                 
         #   #RETURN   #CHI-C20017 mark
         #END IF
         #OPEN p303_t_c11 USING g_existno,g_faa.faa02b
         #FETCH p303_t_c11 INTO gl_date,l_abapost,l_aba19 ,
         #                     l_abaacti,l_aba20           #CHI-A20014 add l_aba20
         #IF STATUS THEN
         #   #CALL cl_err('sel aba:',STATUS,0) #CHI-C20017 mark
         #   CALL s_errmsg('','','sel aba:',STATUS,1)  #CHI-C20017 add
         #   LET g_success = 'N'                                                 
         #   #RETURN   #CHI-C20017 mark
         #END IF
         #IF l_abaacti = 'N' THEN
         #   #CALL cl_err('','mfg8001',1) #CHI-C20017 mark
         #   CALL s_errmsg('','','','mfg8001',1)  #CHI-C20017 add
         #   LET g_success = 'N'                                                 
         #   #RETURN   #CHI-C20017 mark
         #END IF
         ##CHI-A20014---add---start---
         #IF l_aba20 MATCHES '[Ss1]' THEN
         #   #CALL cl_err('','mfg3557',0) #CHI-C20017 mark
         #   CALL s_errmsg('','','','mfg3557',1)  #CHI-C20017 add
         #   LET g_success = 'N'                                                 
         #   #RETURN   #CHI-C20017 mark
         #END IF
         ##CHI-A20014---add---end---
         #IF l_abapost = 'Y' THEN
         #   #CALL cl_err(g_existno,'aap-130',0) #CHI-C20017 mark
         #   CALL s_errmsg('','',g_existno,'aap-130',1) #CHI-C20017 add
         #   LET g_success = 'N'                                                 
         #   #RETURN   #CHI-C20017 mark
         #END IF
#MOD-6B0075    --begin
#        #IF gl_date < g_sma.sma53 THEN    
         #SELECT aaa07 INTO l_aaa07        
         #   FROM aaa_file                 
         # WHERE aaa01= p_acc              
         #IF gl_date < l_aaa07  THEN       
         #   #CALL cl_err(gl_date,'aap-027',0) #CHI-C20017 mark
         #   CALL s_errmsg('','',gl_date,'aap-027',1)  #CHI-C20017 add
         #   LET g_success = 'N'                                                 
         #   #RETURN   #CHI-C20017 mark
         #END IF
#MOD-6B0075    --end
         #IF l_aba19 ='Y' THEN 
         #   #CALL cl_err(gl_date,'aap-026',0) #CHI-C20017 mark
         #   CALL s_errmsg('','',gl_date,'aap-026',1) #CHI-C20017 add
         #   LET g_success = 'N'                                                 
         #   #RETURN   #CHI-C20017 mark
         #END IF
         #FUN-D40105--mark--end-- 
         
      #  IF g_aza.aza63='Y' THEN 
        ##-----No:FUN-B60140 Mark-----
        #IF g_faa.faa31 = 'Y' THEN   #NO.FUN-AB0088
        #   SELECT unique npp07,nppglno INTO p_acc1,g_existno1
        #     FROM npp_file 
        #    WHERE npp01 IN (SELECT npp01 FROM npp_file 
        #                    WHERE npp07   = p_acc 
        #                      AND nppglno = g_existno 
        #                      AND npptype = '0' 
        #                      AND nppsys  = 'FA' 
        #                      AND npp00   = g_type)
        #      AND npptype = '1' AND nppsys = 'FA' AND npp00=g_type
        #   IF SQLCA.sqlcode THEN
        #      CALL cl_err('','aap-986',0) 
        #      LET g_success = 'N'                                                 
        #      RETURN
        #   ELSE
        #      OPEN p303_t_c11 USING g_existno1,g_faa.faa02c
        #      FETCH p303_t_c11 INTO gl_date,l_abapost,l_aba19,l_abaacti,l_aba20    #CHI-A20014 add l_aba20
        #      IF STATUS THEN
        #         CALL cl_err('decl aba_cursor:',STATUS,0) 
        #         LET g_success = 'N'                                                 
        #         RETURN
        #      END IF
        #      IF l_abaacti = 'N' THEN
        #         CALL cl_err('','mfg8001',1) 
        #         LET g_success = 'N'                                                 
        #         RETURN
        #      END IF
        #     #CHI-A20014---add---start---
        #      IF l_aba20 MATCHES '[Ss1]' THEN
        #         CALL cl_err('','mfg3557',0) 
        #         LET g_success = 'N'                                                 
        #         RETURN   
        #      END IF
        #     #CHI-A20014---add---end---
        #      IF l_abapost = 'Y' THEN
        #         CALL cl_err(g_existno1,'aap-130',0)
        #         LET g_success = 'N'                                                 
        #         RETURN
        #      END IF
#MOD-6B0075    --begin
#       #      IF gl_date < g_sma.sma53 THEN    
        #      SELECT aaa07 INTO l_aaa07        
        #         FROM aaa_file                 
        #       WHERE aaa01= p_acc              
        #      IF gl_date < l_aaa07  THEN       
        #         CALL cl_err(gl_date,'aap-027',0)
        #         LET g_success = 'N'                                                 
        #         RETURN   
        #      END IF
#MOD-6B0075    --end
        #      IF l_aba19 ='Y' THEN 
        #         CALL cl_err(gl_date,'aap-026',0)
        #         LET g_success = 'N'                                                 
        #         RETURN
        #      END IF
        #   END IF
        #END IF
        ##No.FUN-680028--end  
        ##-----No:FUN-B60140 Mark END-----
  
         BEGIN WORK
         CALL p303() 
         CALL s_showmsg()  #CHI-C20017 add
         IF g_success = "Y" THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
#NO.FUN-570144 END---
 
#NO.FUN-570144 MARK--
#    CALL p303()
#    IF INT_FLAG
#       THEN LET INT_FLAG = 0
#       ELSE CALL cl_end(18,20)
#    END IF
#    CLOSE WINDOW p303
#NO.FUN-570144 MARK--
     #No.FUN-CB0096 ---start--- add
      #LET l_time = TIME        #FUN-D40105 mark
      LET l_time = l_time + 1   #FUN-D40105 add
      LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
      CALL s_log_data('U','100',g_id,'1',l_time,'','')
     #No.FUN-CB0096 ---end  --- add
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
END MAIN
 
FUNCTION p303()
# 得出總帳 database name 
# g_faa.faa02p -> g_plant_new -> s_getdbs() -> g_dbs_new --> g_dbs_gl
#NO.FUN-570144 MARK--
#   CALL p303_ask()			
#   IF INT_FLAG THEN RETURN END IF
#   IF NOT cl_sure(20,20) THEN LET INT_FLAG = 1 RETURN END IF
#   CALL cl_wait()
#   OPEN WINDOW p303_t_w9 AT 19,4 WITH 3 ROWS, 70 COLUMNS 
#   LET g_success = 'Y'
#NO.FUN-570144 MARK--
 
   LET g_plant_new=p_plant
   CALL s_getdbs()
   LET g_dbs_gl=g_dbs_new 
 
   #no.4868 (還原方式為刪除/作廢)
  #LET g_sql = "SELECT aaz84 FROM ",g_dbs_gl CLIPPED,"aaz_file",   #FUN-A50102
   LET g_sql = "SELECT aaz84 FROM ",cl_get_target_table(g_plant_new,'aaz_file'),   #FUN-A50102
               " WHERE aaz00 = '0' "
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
   PREPARE aaz84_pre FROM g_sql
   DECLARE aaz84_cs CURSOR FOR aaz84_pre
   OPEN aaz84_cs 
   FETCH aaz84_cs INTO g_aaz84
   IF STATUS THEN 
      #CALL cl_err('sel aaz84',STATUS,1) #CHI-C20017 mark
      #CHI-C20017--add--str
      IF g_bgjob = 'Y' THEN
         CALL s_errmsg('','','sel aaz84',STATUS,1)
         CALL s_showmsg()
      ELSE
         CALL cl_err('sel aaz84',STATUS,1)
      END IF
      #CHI-C20017--add--end
      CALL cl_batch_bg_javamail("N")         #FUN-570144
      #CLOSE WINDOW p303_t_w9                #FUN-570144
      #CLOSE WINDOW p303                     #FUN-570144
     #No.FUN-CB0096 ---start--- add
      #LET l_time = TIME        #FUN-D40105 mark 
      LET l_time = l_time + 1   #FUN-D40105 add
      LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
      CALL s_log_data('U','100',g_id,'1',l_time,'','')
     #No.FUN-CB0096 ---end  --- add
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
      EXIT PROGRAM
   END IF
   #no.4868(end)
 
#   BEGIN WORK  #NO.FUN-570144 MARK
   #No.FUN-680028--begin
#  CALL p303_t()
   CALL p303_t()
#  IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
  ##-----No:FUN-B60140 Mark -----
  #IF g_faa.faa31 = 'Y' AND g_success = 'Y' THEN   #NO.FUN-AB0088
  #   CALL p303_t_1()
  #END IF
  ##-----No:FUN-B60140 Mark END-----
   #No.FUN-680028--end  
#NO.FUN-570144 MARK--
#   IF g_success = 'Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF
#   ERROR ""
#   CLOSE WINDOW p303_t_w9
#NO.FUN-570144 MARK--
 
END FUNCTION
 
FUNCTION p303_ask()
   DEFINE   l_abapost,l_flag   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
   DEFINE   l_aba19            LIKE aba_file.aba19 
   DEFINE   l_abaacti          LIKE aba_file.abaacti
   DEFINE   lc_cmd             LIKE type_file.chr1000    #No.FUN-570144       #No.FUN-680070 VARCHAR(500)
   DEFINE   l_aaa07            LIKE aaa_file.aaa07       #No.MOD-6B0075
   DEFINE   l_aba20            LIKE aba_file.aba20       #CHI-A20014 add 

#->No.FUN-570144 --start--
   OPEN WINDOW p303 AT p_row,p_col WITH FORM "afa/42f/afap303"
        ATTRIBUTE (STYLE = g_win_style)
 
   CALL cl_ui_init()
 
    #No:A099
    IF g_aza.aza26 = '2' THEN 
       CALL p303_set_comb()
    END IF
    #end No:A099
 
   #No.FUN-680028--begin
#  IF g_aza.aza63 != 'Y' THEN 

   #-----No:FUN-B60140-----
   #IF g_faa.faa31 = 'Y' THEN   #NO.FUN-AB0088
   #   CALL cl_set_comp_visible("p_acc1,g_existno1",FALSE)  
   #END IF
   CALL cl_set_comp_visible("p_acc1,g_existno1",FALSE)
   #-----No:FUN-B60140 END-----
   #No.FUN-680028--end
 
   CALL cl_opmsg('z')
   LET g_bgjob = "N"
#->No.FUN-570144 ---end---
   LET p_plant = g_faa.faa02p
   LET p_acc   = g_faa.faa02b
   IF NOT cl_null (g_existno) THEN             #FUN-C50113
      DISPLAY BY NAME g_existno                #FUN-C50113
      CALL cl_set_comp_entry("g_existno",FALSE)  #FUN-C50113
   ELSE                                        #FUN-C50113
      LET g_existno = NULL
      CALL cl_set_comp_entry("g_existno",TRUE)  #FUN-C50113
   END IF                                       #FUN-C50113

  IF NOT cl_null (g_type) THEN                  #FUN-C50113
     LET g_type    = 10                         #FUN-C50113
     CALL cl_set_comp_entry("g_type",FALSE)     #FUN-C50113
  ELSE                                          #FUN-C50113
     LET g_type = null
     CALL cl_set_comp_entry("g_type",TRUE)      #FUN-C50113
  END IF                                         #FUN-C50113
   LET g_existno1= NULL        #No.FUN-680028
   LET p_acc1  = g_faa.faa02c  #No.FUN-680028
   DISPLAY BY NAME p_acc1,g_existno1  #No.FUN-680028
 
  WHILE TRUE
   #INPUT BY NAME p_plant,p_acc,g_existno,g_type WITHOUT DEFAULTS
   DIALOG ATTRIBUTES(UNBUFFERED)  #FUN-D40105  add
   #INPUT BY NAME p_plant,p_acc,g_existno,g_type,g_bgjob WITHOUT DEFAULTS  #NO.FUN-570144 
   INPUT BY NAME p_plant,p_acc ATTRIBUTE(WITHOUT DEFAULTS=TRUE)  
       ON ACTION locale
#           CALL cl_dynamic_locale()
#          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
           #No:A099
           IF g_aza.aza26 = '2' THEN 
              CALL p303_set_comb()
           END IF
           #end No:A099
           #->No.FUN-570144 --start--
           LET g_change_lang = TRUE
           #EXIT INPUT  #FUN-D40105  mark
           EXIT DIALOG  #FUN-D40105  add
           #->No.FUN-570144 ---end---
 
 
      AFTER FIELD p_plant
       IF NOT cl_null(p_plant) THEN
         #FUN-990031--mod--str--  營運中心要控制在當前法人下  
         #SELECT azp01 FROM azp_file WHERE azp01 = p_plant
         SELECT * FROM azw_file WHERE azw01 = p_plant AND azw02 = g_legal  
         #FUN-990031--mod--end
         IF STATUS <> 0 THEN 
            CALL cl_err3("sel","azw_file",p_plant,"","agl-171","","",1)  #FUN-990031
            NEXT FIELD p_plant 
         END IF
         ##00/05/18 modify
         LET g_plant_new=p_plant
         CALL s_getdbs()
         LET g_dbs_gl=g_dbs_new 
       END IF
 
      AFTER FIELD p_acc
       IF NOT cl_null(p_acc) THEN
         LET g_faa.faa02b = p_acc
       END IF

      #FUN-D40105--mark--str-- 
      #AFTER FIELD g_existno
      #   IF NOT cl_null(g_existno) THEN 
      #      LET g_sql="SELECT aba02,aba03,aba04,abapost,aba19,abaacti,aba20 ",  #CHI-A20014 add aba20
      #               #"  FROM ",g_dbs_gl,"aba_file",   #FUN-A50102
      #                "  FROM ",cl_get_target_table(g_plant_new,'aba_file'),   #FUN-A50102
      #                " WHERE aba01 = ? AND aba00 = ? AND aba06='FA'"
 	  #      CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      #      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
      #      PREPARE p303_t_p1 FROM g_sql
      #      DECLARE p303_t_c1 CURSOR FOR p303_t_p1
      #      IF STATUS THEN
      #         CALL cl_err('decl aba_cursor:',STATUS,0) NEXT FIELD g_existno
      #      END IF
      #      OPEN p303_t_c1 USING g_existno,g_faa.faa02b
      #      FETCH p303_t_c1 INTO gl_date,gl_yy,gl_mm,l_abapost,l_aba19 ,
      #                           l_abaacti,l_aba20 #no.7378    #CHI-A20014 add l_aba20
      #      IF STATUS THEN
      #         CALL cl_err('sel aba:',STATUS,0) NEXT FIELD g_existno
      #      END IF
      #      #no.7378
      #      IF l_abaacti = 'N' THEN
      #         CALL cl_err('','mfg8001',1) NEXT FIELD g_existno
      #      END IF
      #     #CHI-A20014---add---start---
      #      IF l_aba20 MATCHES '[Ss1]' THEN
      #         CALL cl_err('','mfg3557',0) 
      #         NEXT FIELD g_existno
      #      END IF
      #     #CHI-A20014---add---end---
      #      #no.7378(end)
      #      IF l_abapost = 'Y' THEN
      #         CALL cl_err(g_existno,'aap-130',0)
      #         NEXT FIELD g_existno
      #      END IF
#MOD-6B0075    --begin
#     #      IF gl_date < g_sma.sma53 THEN    
      #      SELECT aaa07 INTO l_aaa07        
      #         FROM aaa_file                 
      #       WHERE aaa01= p_acc              
      #      IF gl_date < l_aaa07  THEN       
      #         CALL cl_err(gl_date,'aap-027',0)
      #         LET g_success = 'N'                                                 
      #         RETURN   
      #      END IF
#MOD-6B0075    --end
      #      IF l_aba19 ='Y' THEN 
      #         CALL cl_err(gl_date,'aap-026',0)
      #         NEXT FIELD g_existno
      #      END IF
      #   END IF
      #FUN-D40105--mark--end--
        
      #No.FUN-680028--begin
      #AFTER FIELD g_type      #FUN-D40105 mark
      #  IF NOT cl_null(g_type) THEN  #FUN-D40105 mark
      #    IF g_aza.aza63='Y' THEN 
          ##-----No:FUN-B60140-----
          #IF g_faa.faa31 = 'Y' THEN   #NO.FUN-AB0088
          #   SELECT unique npp07,nppglno INTO p_acc1,g_existno1
          #     FROM npp_file 
          #    WHERE npp01 IN (SELECT npp01 FROM npp_file 
          #                    WHERE npp07   = p_acc 
          #                      AND nppglno = g_existno 
          #                      AND npptype = '0' 
          #                      AND nppsys  = 'FA' 
          #                      AND npp00   = g_type)
          #      AND npptype = '1' AND nppsys = 'FA' AND npp00=g_type
          #   IF SQLCA.sqlcode THEN
          #      CALL cl_err('','aap-986',0) 
          #      RETURN
          #   ELSE
#         #      LET p_acc1 = l_npp07
#         #      LET g_existno1 = l_nppglno
          #      DISPLAY BY NAME p_acc1,g_existno1
          #      LET g_faa.faa02c = p_acc1
          #      LET g_sql="SELECT aba02,aba03,aba04,abapost,aba19,abaacti,aba20 ",   #CHI-A20014 add aba20
          #               #"  FROM ",g_dbs_gl,"aba_file",  #FUN-A50102
          #                "  FROM ",cl_get_target_table(g_plant_new,'aba_file'),   #FUN-A50102
          #                " WHERE aba01 = ? AND aba00 = ? AND aba06='FA'"
 	  #      CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
          #      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
          #      PREPARE p303_t_p1_1 FROM g_sql
          #      DECLARE p303_t_c1_1 CURSOR FOR p303_t_p1_1
          #      IF STATUS THEN
          #         CALL cl_err('decl aba_cursor:',STATUS,0) NEXT FIELD g_type
          #      END IF
          #      OPEN p303_t_c1_1 USING g_existno1,g_faa.faa02c
          #      FETCH p303_t_c1_1 INTO gl_date,gl_yy,gl_mm,l_abapost,l_aba19 ,
          #                           l_abaacti,l_aba20  #no.7378    #CHI-A20014 add l_aba20
          #      IF STATUS THEN
          #         CALL cl_err('sel aba:',STATUS,0) NEXT FIELD g_type
          #      END IF
          #      IF l_abaacti = 'N' THEN
          #         CALL cl_err('','mfg8001',1) NEXT FIELD g_type
          #      END IF
          #     #CHI-A20014---add---start---
          #      IF l_aba20 MATCHES '[Ss1]' THEN
          #         CALL cl_err('','mfg3557',0) 
          #         NEXT FIELD g_type
          #      END IF
          #     #CHI-A20014---add---end---
          #      IF l_abapost = 'Y' THEN
          #         CALL cl_err(g_existno1,'aap-130',0)
          #         NEXT FIELD g_type
          #      END IF
#MOD-6B0075    --begin
#         #      IF gl_date < g_sma.sma53 THEN    
          #      SELECT aaa07 INTO l_aaa07        
          #         FROM aaa_file                 
          #       WHERE aaa01= p_acc              
          #      IF gl_date < l_aaa07  THEN       
          #         CALL cl_err(gl_date,'aap-027',0)
          #         LET g_success = 'N'                                                 
          #         RETURN   
          #      END IF
#MOD-6B0075    --end
          #      IF l_aba19 ='Y' THEN 
          #         CALL cl_err(gl_date,'aap-026',0)
          #         NEXT FIELD g_type
          #      END IF
          #   END IF
          #END IF
          ##-----No:FUN-B60140 Mark END-----
        #END IF   #FUN-D40105  mark
      #No.FUN-680028--end  
 
       #No.B003 010413 by plum
      AFTER INPUT
         IF INT_FLAG THEN 
            #EXIT INPUT  #FUN-D40105  mark 
            EXIT DIALOG  #FUN-D40105  add
         END IF
         #-----CHI-7C0035---------
         #LET l_flag='N'
         #IF cl_null(p_plant)   THEN 
         #   LET l_flag='Y'
         #END IF
         #IF cl_null(p_acc)     THEN
         #   LET l_flag='Y'
         #END IF
         #IF cl_null(g_existno) THEN
         #   LET l_flag='Y'
         #END IF
         #IF cl_null(g_type)    THEN
         #   LET l_flag='Y'
         #END IF
         #IF l_flag='Y' THEN
         #   CALL cl_err('','9033',0)
         #   NEXT FIELD p_plant
         #END IF
         #-----END CHI-7C0035-----
        # 得出總帳 database name
        # g_apz.apz02p -> g_plant_new -> s_getdbs() -> g_dbs_new --> g_dbs_gl
         LET g_plant_new= p_plant  # 工廠編號
         CALL s_getdbs()
         LET g_dbs_gl=g_dbs_new    # 得資料庫名稱
        #No.B003...end

      #FUN-D40105--mark--str--
      #ON ACTION CONTROLR
      #   CALL cl_show_req_fields()
 
      #ON ACTION CONTROLG
      #   CALL cl_cmdask()
 
      #ON IDLE g_idle_seconds
      #   CALL cl_on_idle()
      #   CONTINUE INPUT
 
      #ON ACTION about         #MOD-4C0121
      #   CALL cl_about()      #MOD-4C0121
 
      #ON ACTION help          #MOD-4C0121
      #   CALL cl_show_help()  #MOD-4C0121
 
 
      #   ON ACTION exit                            #加離開功能
      #      LET INT_FLAG = 1
      #      EXIT INPUT
      #FUN-D40105--add--end--  

      ON ACTION CONTROLP           #FUN-D40105  add
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---

         #FUN-D40105--add--str-- 
         #No.FUN-580031 --start--
         #ON ACTION qbe_select
         #   CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         #ON ACTION qbe_save
         #   CALL cl_qbe_save()
         #No.FUN-580031 ---end---
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
      CALL  p303_existno_chk() 
      IF g_success = 'N' THEN 
         CALL s_showmsg()
         NEXT FIELD g_existno
      END IF 

      ON ACTION CONTROLP
         CASE 
            WHEN INFIELD(g_existno)
              LET g_existno_str = ''
              CALL q_aba01_1( TRUE, TRUE, p_plant,p_acc,' ','FA')
              RETURNING g_existno_str   
              DISPLAY g_existno_str TO g_existno
              NEXT FIELD g_existno
         END CASE

   END CONSTRUCT

   INPUT BY NAME g_type,g_bgjob ATTRIBUTE(WITHOUT DEFAULTS=TRUE)

   END INPUT 
   
   ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG
         CALL cl_cmdask()
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
 
#NO.FUN-570144 MARK---
   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
      CONTINUE WHILE
   END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p303
     #No.FUN-CB0096 ---start--- add
      #LET l_time = TIME        #FUN-D40105 mark 
      LET l_time = l_time + 1   #FUN-D40105 add
      LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
      CALL s_log_data('U','100',g_id,'1',l_time,'','')
     #No.FUN-CB0096 ---end  --- add
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
      EXIT PROGRAM
   END IF
 
   IF g_bgjob = "Y" THEN
      SELECT zz08 INTO lc_cmd FROM zz_file
       WHERE zz01 = "afap303"
      IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
         CALL cl_err('afap303','9031',1) 
      ELSE
         LET lc_cmd = lc_cmd CLIPPED,
                      " '",p_plant   CLIPPED,"'",
                      " '",p_acc     CLIPPED,"'",
                      " '",g_existno CLIPPED,"'",
                      " '",g_type    CLIPPED,"'",
                      " '",g_bgjob   CLIPPED,"'"
         CALL cl_cmdat('afap303',g_time,lc_cmd CLIPPED)
      END IF
      CLOSE WINDOW p303
     #No.FUN-CB0096 ---start--- add
      #LET l_time = TIME        #FUN-D40105 mark
      LET l_time = l_time + 1   #FUN-D40105 add
      LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
      CALL s_log_data('U','100',g_id,'1',l_time,'','')
     #No.FUN-CB0096 ---end  --- add
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
      EXIT PROGRAM
   END IF
 EXIT WHILE
END WHILE
#->No.FUN-570144 ---end---
 
 
END FUNCTION
 
FUNCTION p303_t()
   DEFINE n1,n2,n3,n4,n5,n6,n7,n8,n9,n11,n14 LIKE type_file.num10        #No.FUN-680070 INTEGER #FUN-BC0035 add n14
   DEFINE n12                            LIKE type_file.num10           #No:A099       #No.FUN-680070 INTEGER
   DEFINE l_npp	   	    RECORD LIKE npp_file.*
   DEFINE l_cnt        LIKE type_file.num5      #檢查重複用         #MOD-B40034
 
IF g_aaz84 = '2' THEN   #還原方式為作廢 #no.4868
  #LET g_sql="UPDATE ",g_dbs_gl," aba_file  SET abaacti = 'N' ",   #FUN-A50102
   LET g_sql="UPDATE ",cl_get_target_table(g_plant_new,'aba_file'),   #FUN-A50102
             "   SET abaacti = 'N' ",   #FUN-A50102
             #" WHERE aba01 = ? AND aba00 = ? "     #FUN-D40105 mark
             " WHERE  aba00 = ? ",                  #FUN-D40105 add
             "   AND ",tm.wc1                       #FUN-D40105 add
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
   PREPARE p303_updaba_p FROM g_sql
   #EXECUTE p303_updaba_p USING g_existno,g_faa.faa02b   #FUN-D40105 mark
   EXECUTE p303_updaba_p USING g_faa.faa02b              #FUN-D40105 add
   IF SQLCA.sqlcode THEN
      #CALL cl_err('(upd abaacti)',SQLCA.sqlcode,1)  #CHI-C20017 mark
      LET g_success = 'N' 
      #RETURN  #CHI-C20017 mark
   #CHI-C20017--add--str
      IF g_bgjob = 'Y' THEN
         CALL s_errmsg('','','(upd abaacti)',SQLCA.sqlcode,1)
      ELSE
         CALL cl_err('(upd abaacti)',SQLCA.sqlcode,1)
         RETURN
      END IF
   #CHI-C20017--add--end
   END IF
ELSE
   IF g_bgjob= 'N' THEN    #FUN-570144 BY 050919
      MESSAGE "Delete GL's Voucher body!"  #-------------------------
      CALL ui.Interface.refresh()
   END IF
  #LET g_sql="DELETE FROM ",g_dbs_gl,"abb_file WHERE abb01=? AND abb00=?"   #FUN-A50102
   LET tm.wc1 = cl_replace_str(tm.wc1,"aba01","abb01")   #FUN-D40105 add
   LET g_sql="DELETE FROM ",cl_get_target_table(g_plant_new,'abb_file'),    #FUN-A50102
             #" WHERE abb01=? AND abb00=? "   #FUN-A50102   #FUN-D40105  mark
             " WHERE  abb00 = ? ",            #FUN-D40105 add
             "   AND ",tm.wc1                 #FUN-D40105 add
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
   PREPARE p303_2_p3 FROM g_sql
   #EXECUTE p303_2_p3 USING g_existno,g_faa.faa02b   #FUN-D40105 mark
   EXECUTE p303_2_p3 USING g_faa.faa02b              #FUN-D40105 add
   IF SQLCA.sqlcode THEN
      #CALL cl_err('(del abb)',SQLCA.sqlcode,1)  #CHI-C20017 mark
      LET g_success = 'N' 
      #RETURN   #CHI-C20017 mark
   #CHI-C20017--add--str
      #IF g_bgjob = 'Y' THEN   #FUN-D40105 mark
         CALL s_errmsg('','','(del abb)',SQLCA.sqlcode,1)
      #FUN-D40105--mark--str--   
      #ELSE
      #   CALL cl_err('(del abb)',SQLCA.sqlcode,1)
      #   RETURN
      #END IF
      #FUN-D40105--mark--end-- 
   #CHI-C20017--add--end
   END IF
   IF g_bgjob= 'N' THEN    #FUN-570144
       MESSAGE "Delete GL's Voucher head!"  #-------------------------
       CALL ui.Interface.refresh()
   END IF
  #FUN-A50102--mod--str--
  #LET g_sql="DELETE FROM ",g_dbs_gl,"aba_file WHERE aba01=? AND aba00=?"
   LET tm.wc1 = cl_replace_str(tm.wc1,"abb01","aba01")     #FUN-D40105 add
   LET g_sql="DELETE FROM ",cl_get_target_table(g_plant_new,'aba_file'),
             #" WHERE aba01=? AND aba00=?"    #FUN-D40105 mark
             " WHERE  aba00 = ? ",            #FUN-D40105 add
             "   AND ",tm.wc1                 #FUN-D40105 add
  #FUN-A50102--mod--end
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
   PREPARE p303_2_p4 FROM g_sql
   #EXECUTE p303_2_p4 USING g_existno,g_faa.faa02b  #FUN-D40105 mark   
   EXECUTE p303_2_p4 USING g_faa.faa02b     #FUN-D40105 add
   IF SQLCA.sqlcode THEN
      #CALL cl_err('(del aba)',SQLCA.sqlcode,1)  #CHI-C20017 mark
      LET g_success = 'N' 
      #RETURN   #CHI-C20017 mark
   #CHI-C20017--add--str
      #IF g_bgjob = 'Y' THEN   #FUN-D40105 mark
         CALL s_errmsg('','','(del aba)',SQLCA.sqlcode,1)
      #FUN-D40105--mark--str--   
      #ELSE
      #   CALL cl_err('(del aba)',SQLCA.sqlcode,1)
      #   RETURN
      #END IF
      #FUN-D40105--mark--end-- 
   #CHI-C20017--add--end
   END IF
   IF SQLCA.sqlerrd[3] = 0 THEN
      #CALL cl_err('(del aba)','aap-161',1)  #CHI-C20017 mark
      LET g_success = 'N' 
      #RETURN   #CHI-C20017 mark
   #CHI-C20017--add--str
      #IF g_bgjob = 'Y' THEN     #FUN-D40105 mark
         CALL s_errmsg('','','(del aba)','aap-161',1)
      #FUN-D40105--mark--str--    
      #ELSE
      #   CALL cl_err('(del aba)','aap-161',1)
      #   RETURN
      #END IF
      #FUN-D40105--mark--end--
   #CHI-C20017--add--end
   END IF
   IF g_bgjob= 'N' THEN    #FUN-570144
       MESSAGE "Delete GL's Voucher desp!"  #-------------------------
       CALL ui.Interface.refresh()
   END IF
  #FUN-A50102--mod--str--
  #LET g_sql="DELETE FROM ",g_dbs_gl,"abc_file WHERE abc01=? AND abc00=?"
   LET tm.wc1 = cl_replace_str(tm.wc1,"aba01","abc01")     #FUN-D40105 add
   LET g_sql="DELETE FROM ",cl_get_target_table(g_plant_new,'abc_file'),
             #" WHERE abc01=? AND abc00=?"    #FUN-D40105 mark
             " WHERE  abc00=?",               #FUN-D40105 add
             "   AND ",tm.wc1                 #FUN-D40105 add
  #FUN-A50102--mod--end
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
   PREPARE p303_2_p5 FROM g_sql
   #EXECUTE p303_2_p5 USING g_existno,g_faa.faa02b  #FUN-D40105 mark
   EXECUTE p303_2_p5 USING g_faa.faa02b             #FUN-D40105 add
   IF SQLCA.sqlcode THEN
      #CALL cl_err('(del abc)',SQLCA.sqlcode,1)  #CHI-C20017 mark
      LET g_success = 'N' 
      #RETURN   #CHI-C20017 mark
   #CHI-C20017--add--str
      #IF g_bgjob = 'Y' THEN      #FUN-D40105 mark
         CALL s_errmsg('','','(del abc)',SQLCA.sqlcode,1)
      #FUN-D40105--mark--str--       
      #ELSE
      #   CALL cl_err('(del abc)',SQLCA.sqlcode,1)
      #   RETURN
      #END IF
      #FUN-D40105--mark--end--
   #CHI-C20017--add--end
   END IF
#FUN-B40056 -begin
   LET tm.wc1 = cl_replace_str(tm.wc1,"abc01","tic04")     #FUN-D40105 add
   LET g_sql="DELETE FROM ",cl_get_target_table(p_plant,'tic_file'),
             #" WHERE tic04=? AND tic00=?"    #FUN-D40105 mark 
             " WHERE  tic00 =?",              #FUN-D40105 add
             "   AND ",tm.wc1                 #FUN-D40105 add
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql       
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
   PREPARE p303_2_p9 FROM g_sql
   #EXECUTE p303_2_p9 USING g_existno,g_faa.faa02b   #FUN-D40105 mark 
   EXECUTE p303_2_p9 USING g_faa.faa02b              #FUN-D40105 add
   IF SQLCA.sqlcode THEN
      #CALL cl_err('(del tic)',SQLCA.sqlcode,1) #CHI-C20017 mark
      LET g_success = 'N' 
      #RETURN   #CHI-C20017 mark
   #CHI-C20017--add--str
      #IF g_bgjob = 'Y' THEN    #FUN-D40105 mark
         CALL s_errmsg('','','(del tic)',SQLCA.sqlcode,1)
      #FUN-D40105--mark--str--       
      #ELSE
      #   CALL cl_err('(del tic)',SQLCA.sqlcode,1)
      #   RETURN
      #END IF
      #FUN-D40105--mark--end--
   #CHI-C20017--add--end
   END IF
#FUN-B40056 -end   
END IF
   IF g_bgjob= 'N' THEN    #FUN-570144
       MESSAGE "Delete GL's Voucher detail!"  #-------------------------
       CALL ui.Interface.refresh()
   END IF
#  CALL s_abhmod(g_dbs_gl,g_faa.faa02b,g_existno)   #MOD-590081   #CHI-780008 #FUN-980020 mark
   CALL s_abhmod(p_plant,g_faa.faa02b,g_existno)    #FUN-980020
   IF g_success = 'N' THEN RETURN END IF
 
   LET g_msg = TIME
   INSERT INTO azo_file (azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)     #FUN-980003 add
          VALUES('afap303',g_user,g_today,g_msg,g_existno,'delete',g_plant,g_legal) #FUN-980003 add
   LET gl_no = NULL   #No.FUN-CB0096   Add
   #----------------------------------------------------------------------
   CASE 
    WHEN g_type = 1    #資本化
         SELECT faq01 INTO gl_no FROM faq_file WHERE faq06 = g_existno   #No.FUN-CB0096   Add
         
         #UPDATE faq_file SET faq06=NULL,faq07=NULL WHERE faq06=g_existno  #FUN-D40105 mark
         #FUN-D40105--add--str-- 
         IF g_aaz84 = '2' THEN
            LET tm.wc1 = cl_replace_str(tm.wc1,"aba01","faq06")
         ELSE
            LET tm.wc1 = cl_replace_str(tm.wc1,"tic04","faq06")
         END IF 
         LET g_sql = "UPDATE faq_file SET faq06=NULL,faq07=NULL ",
                     " WHERE ",tm.wc1
         PREPARE p303_pre_1 FROM g_sql
         EXECUTE p303_pre_1
         #FUN-D40105--add--end-- 
            IF STATUS THEN
#              CALL cl_err('(upd faq)',STATUS,1)   #No.FUN-660136
               #CALL cl_err3("upd","faq_file",g_existno,"",STATUS,"","(upd faq)",1)   #No.FUN-660136 #CHI-C20017 mark
               LET g_success='N' 
               #RETURN   #CHI-C20017 mark
            #CHI-C20017--add--str
               #IF g_bgjob = 'Y' THEN   #FUN-D40105 mark
                  CALL s_errmsg('','','(upd faq)',STATUS,1)
               #FUN-D40105--mark--str--    
               #ELSE
               #   CALL cl_err3("upd","faq_file",g_existno,"",STATUS,"","(upd faq)",1)
               #   RETURN
               #END IF
               #FUN-D40105--mark--end--
            #CHI-C20017--add--end
            END IF
            LET n1=SQLCA.SQLERRD[3]
    WHEN g_type = 2    #部門移轉
         SELECT fas01 INTO gl_no FROM fas_file WHERE fas07 = g_existno   #No.FUN-CB0096   Add
         #UPDATE fas_file SET fas07=NULL,fas08=NULL WHERE fas07=g_existno   #FUN-D40105 mark
         #FUN-D40105--add--str-- 
         IF g_aaz84 = '2' THEN
            LET tm.wc1 = cl_replace_str(tm.wc1,"aba01","fas07")
         ELSE
            LET tm.wc1 = cl_replace_str(tm.wc1,"tic04","fas07")
         END IF 
         LET g_sql = "UPDATE fas_file SET fas07=NULL,fas08=NULL ",
                     " WHERE ",tm.wc1
         PREPARE p303_pre_2 FROM g_sql
         EXECUTE p303_pre_2
         #FUN-D40105--add--end--
            IF STATUS THEN
#              CALL cl_err('(upd fas)',STATUS,1)  #No.FUN-660136
               #CALL cl_err3("upd","fas_file",g_existno,"",STATUS,"","(upd fas)",1)   #No.FUN-660136 #CHI-C20017 mark
               LET g_success='N' 
               #RETURN   #CHI-C20017 mark
            #CHI-C20017--add--str
               #IF g_bgjob = 'Y' THEN    #FUN-D40105 mark
                  CALL s_errmsg('','','(upd fas)',STATUS,1)
               #FUN-D40105--mark--str--   
               #ELSE
               #   CALL cl_err3("upd","fas_file",g_existno,"",STATUS,"","(upd fas)",1)
               #   RETURN
               #END IF
               #FUN-D40105--mark--end--
            #CHI-C20017--add--end
            END IF
            LET n11=SQLCA.SQLERRD[3]
    #FUN-BC0035---begin add
    WHEN g_type = 14   #類別異動
         SELECT fbx01 INTO gl_no FROM fbx_file WHERE fbx07 = g_existno   #No.FUN-CB0096   Add
         #UPDATE fbx_file SET fbx07=NULL,fbx08=NULL WHERE fbx07=g_existno   #FUN-D40105 mark
         #FUN-D40105--add--str-- 
         IF g_aaz84 = '2' THEN
            LET tm.wc1 = cl_replace_str(tm.wc1,"aba01","fbx07")
         ELSE
            LET tm.wc1 = cl_replace_str(tm.wc1,"tic04","fbx07")
         END IF 
         LET g_sql = "UPDATE fbx_file SET fbx07=NULL,fbx08=NULL ",
                     " WHERE ",tm.wc1
         PREPARE p303_pre_3 FROM g_sql
         EXECUTE p303_pre_3
         #FUN-D40105--add--end--
            IF STATUS THEN 
               #CALL cl_err3("upd","fbx_file",g_existno,"",STATUS,"","(upd fbx)",1) #CHI-C20017 mark
               LET g_success='N'
               #RETURN   #CHI-C20017 mark
            #CHI-C20017--add--str
               #IF g_bgjob = 'Y' THEN   #FUN-D40105 mark
                  CALL s_errmsg('','','(upd fbx)',STATUS,1)
               #FUN-D40105--mark--str--    
               #ELSE
               #   CALL cl_err3("upd","fbx_file",g_existno,"",STATUS,"","(upd fbx)",1)
               #   RETURN
               #END IF
               #FUN-D40105--mark--end--
            #CHI-C20017--add--end
            END IF
            LET n14=SQLCA.SQLERRD[3]    
    #FUN-BC0035---add add            
    WHEN g_type = 4   #出售
         SELECT fbx01 INTO gl_no FROM fbx_file WHERE fbx07 = g_existno   #No.FUN-CB0096   Add
         #UPDATE fbe_file SET fbe14=NULL,fbe15=NULL WHERE fbe14=g_existno   #FUN-D40105 mark
         #FUN-D40105--add--str-- 
         IF g_aaz84 = '2' THEN
            LET tm.wc1 = cl_replace_str(tm.wc1,"aba01","fbe14")
         ELSE
            LET tm.wc1 = cl_replace_str(tm.wc1,"tic04","fbe14")
         END IF 
         LET g_sql = "UPDATE fbe_file SET fbe14=NULL,fbe15=NULL ",
                     " WHERE ",tm.wc1
         PREPARE p303_pre_4 FROM g_sql
         EXECUTE p303_pre_4
         #FUN-D40105--add--end--
            IF STATUS THEN
#              CALL cl_err('(upd fbe)',STATUS,1) #No.FUN-660136
               #CALL cl_err3("upd","fbe_file",g_existno,"",STATUS,"","(upd fbe)",1)   #No.FUN-660136 #CHI-C20017 mark
               LET g_success='N' 
               #RETURN   #CHI-C20017 mark
            #CHI-C20017--add--str
               #IF g_bgjob = 'Y' THEN     #FUN-D40105 mark
                  CALL s_errmsg('','','(upd fbe)',STATUS,1)
               #FUN-D40105--mark--str--    
               #ELSE
               #   CALL cl_err3("upd","fbe_file",g_existno,"",STATUS,"","(upd fbe)",1)
               #   RETURN
               #END IF
               #FUN-D40105--mark--end--
            #CHI-C20017--add--end
            END IF
            LET n2=SQLCA.SQLERRD[3]
    WHEN g_type = 5  OR g_type = 6 #銷帳/報廢
         SELECT fbx01 INTO gl_no FROM fbx_file WHERE fbx07 = g_existno   #No.FUN-CB0096   Add
         #UPDATE fbg_file SET fbg08=NULL,fbg09=NULL WHERE fbg08=g_existno  #FUN-D40105 mark
         #FUN-D40105--add--str-- 
         IF g_aaz84 = '2' THEN
            LET tm.wc1 = cl_replace_str(tm.wc1,"aba01","fbg08")
         ELSE
            LET tm.wc1 = cl_replace_str(tm.wc1,"tic04","fbg08")
         END IF 
         LET g_sql = "UPDATE fbg_file SET fbg08=NULL,fbg09=NULL ",
                     " WHERE ",tm.wc1
         PREPARE p303_pre_5 FROM g_sql
         EXECUTE p303_pre_5
         #FUN-D40105--add--end--
            IF STATUS THEN
#              CALL cl_err('(upd fbg)',STATUS,1)  #No.FUN-660136
               #CALL cl_err3("upd","fbg_file",g_existno,"",STATUS,"","(upd fbg)",1)   #No.FUN-660136 #CHI-C20017 mark
               LET g_success='N' 
               #RETURN   #CHI-C20017 mark
            #CHI-C20017--add--str
               #IF g_bgjob = 'Y' THEN   #FUN-D40105 mark
                  CALL s_errmsg('','','(upd fbg)',STATUS,1)
               #FUN-D40105--mark--str--      
               #ELSE
               #   CALL cl_err3("upd","fbg_file",g_existno,"",STATUS,"","(upd fbg)",1)
               #   RETURN
               #END IF
               #FUN-D40105--mark--end--
            #CHI-C20017--add--end
            END IF
            LET n3=SQLCA.SQLERRD[3]
    WHEN g_type = 7   #改良
         SELECT fbx01 INTO gl_no FROM fbx_file WHERE fbx07 = g_existno   #No.FUN-CB0096   Add
         #UPDATE fay_file SET fay06=NULL,fay07=NULL WHERE fay06=g_existno  #FUN-D40105 mark
         #FUN-D40105--add--str-- 
         IF g_aaz84 = '2' THEN
            LET tm.wc1 = cl_replace_str(tm.wc1,"aba01","fay06")
         ELSE
            LET tm.wc1 = cl_replace_str(tm.wc1,"tic04","fay06")
         END IF 
         LET g_sql = "UPDATE fay_file SET fay06=NULL,fay07=NULL ",
                     " WHERE ",tm.wc1
         PREPARE p303_pre_6 FROM g_sql
         EXECUTE p303_pre_6
         #FUN-D40105--add--end--
            IF STATUS THEN
#              CALL cl_err('(upd fay)',STATUS,1) #No.FUN-660136
               #CALL cl_err3("upd","fay_file",g_existno,"",STATUS,"","(upd fay)",1)   #No.FUN-660136 #CHI-C20017 mark
               LET g_success='N' 
               #RETURN   #CHI-C20017 mark
            #CHI-C20017--add--str
               #IF g_bgjob = 'Y' THEN   #FUN-D40105 mark
                  CALL s_errmsg('','','(upd fay)',STATUS,1)
               #FUN-D40105--mark--str--        
               #ELSE
               #   CALL cl_err3("upd","fay_file",g_existno,"",STATUS,"","(upd fay)",1)
               #   RETURN
               #END IF
               #FUN-D40105--mark--end--
            #CHI-C20017--add--end
            END IF
            LET n4=SQLCA.SQLERRD[3]
    WHEN g_type = 8   #重估
         SELECT fbx01 INTO gl_no FROM fbx_file WHERE fbx07 = g_existno   #No.FUN-CB0096   Add
         #UPDATE fba_file SET fba06=NULL,fba07=NULL WHERE fba06=g_existno   #FUN-D40105 mark
         #FUN-D40105--add--str-- 
         IF g_aaz84 = '2' THEN
            LET tm.wc1 = cl_replace_str(tm.wc1,"aba01","fba06")
         ELSE
            LET tm.wc1 = cl_replace_str(tm.wc1,"tic04","fba06")
         END IF 
         LET g_sql = "UPDATE fba_file SET fba06=NULL,fba07=NULL ",
                     " WHERE ",tm.wc1
         PREPARE p303_pre_7 FROM g_sql
         EXECUTE p303_pre_7
         #FUN-D40105--add--end--
            IF STATUS THEN
#              CALL cl_err('(upd fba)',STATUS,1) #No.FUN-660136
               #CALL cl_err3("upd","fba_file",g_existno,"",STATUS,"","(upd fba)",1)   #No.FUN-660136 #CHI-C20017 mark
               LET g_success='N' 
               #RETURN    #CHI-C20017 mark
            #CHI-C20017--add--str
               #IF g_bgjob = 'Y' THEN   #FUN-D40105 mark
                  CALL s_errmsg('','','(upd fba)',STATUS,1)
               #FUN-D40105--mark--str--         
               #ELSE
               #   CALL cl_err3("upd","fba_file",g_existno,"",STATUS,"","(upd fba)",1)
               #   RETURN
               #END IF
               #FUN-D40105--mark--end--
            #CHI-C20017--add--end
            END IF
            LET n5=SQLCA.SQLERRD[3]
    WHEN g_type = 9   #調整
         SELECT fbx01 INTO gl_no FROM fbx_file WHERE fbx07 = g_existno   #No.FUN-CB0096   Add
         #UPDATE fbc_file SET fbc06=NULL,fbc07=NULL WHERE fbc06=g_existno   #FUN-D40105 mark
         #FUN-D40105--add--str-- 
         IF g_aaz84 = '2' THEN
            LET tm.wc1 = cl_replace_str(tm.wc1,"aba01","fbc06")
         ELSE
            LET tm.wc1 = cl_replace_str(tm.wc1,"tic04","fbc06")
         END IF 
         LET g_sql = "UPDATE fbc_file SET fbc06=NULL,fbc07=NULL  ",
                     " WHERE ",tm.wc1
         PREPARE p303_pre_8 FROM g_sql
         EXECUTE p303_pre_8
         #FUN-D40105--add--end--
           IF STATUS THEN
#             CALL cl_err('(upd fbc)',STATUS,1) #No.FUN-660136
              #CALL cl_err3("upd","fbc_file",g_existno,"",STATUS,"","(upd fbc)",1)   #No.FUN-660136 #CHI-C20017 mark
              LET g_success='N' 
              #RETURN   #CHI-C20017 mark
           #CHI-C20017--add--str
              #IF g_bgjob = 'Y' THEN    #FUN-D40105 mark
                 CALL s_errmsg('','','(upd fbc)',STATUS,1)
              #FUN-D40105--mark--str--      
              #ELSE
              #   CALL cl_err3("upd","fbc_file",g_existno,"",STATUS,"","(upd fbc)",1)
              #   RETURN
              #END IF
              #FUN-D40105--mark--end--
           #CHI-C20017--add--end
           END IF
           LET n6=SQLCA.SQLERRD[3]
    WHEN g_type = 10   #折舊
         SELECT fbx01 INTO gl_no FROM fbx_file WHERE fbx07 = g_existno   #No.FUN-CB0096   Add
       #LET n7=1       #MOD-B40034 mark 
       #-MOD-B40034-add-
        #FUN-D40105--mark--str--  
        #LET l_cnt = 0
        #SELECT COUNT(*) INTO l_cnt
        #  FROM npp_file 
        # WHERE nppglno = g_existno
        #   AND npp00 = 10
        #   AND npptype = '0' AND npp07 = g_faa.faa02b 
        #FUN-D40105--mark--end--

        #FUN-D40105--add--str-- 
         IF g_aaz84 = '2' THEN
            LET tm.wc1 = cl_replace_str(tm.wc1,"aba01","nppglno")
         ELSE
            LET tm.wc1 = cl_replace_str(tm.wc1,"tic04","nppglno")
         END IF 
         LET g_sql = "SELECT COUNT(*) FROM npp_file ",
                     " WHERE npp00 = 10",
                     "   AND npptype = '0'",
                     "   AND npp07 = '",g_faa.faa02b,"'",
                     "   AND ",tm.wc1
         PREPARE p303_pre_9 FROM g_sql
         EXECUTE p303_pre_9 INTO l_cnt
         #FUN-D40105--add--end--   
           
        IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
        LET n7 = l_cnt  
       #-MOD-B40034-end-
    WHEN g_type = 11   #利息資本化
         SELECT fbx01 INTO gl_no FROM fbx_file WHERE fbx07 = g_existno   #No.FUN-CB0096   Add
         #UPDATE fcx_file SET fcx11=NULL,fcx12=NULL WHERE fcx11=g_existno  #FUN-D40105 mark
         #FUN-D40105--add--str-- 
         IF g_aaz84 = '2' THEN
            LET tm.wc1 = cl_replace_str(tm.wc1,"aba01","fcx11")
         ELSE
            LET tm.wc1 = cl_replace_str(tm.wc1,"tic04","fcx11")
         END IF 
         LET g_sql = "UPDATE fcx_file SET fcx11=NULL,fcx12=NULL  ",
                     " WHERE ",tm.wc1
         PREPARE p303_pre_10 FROM g_sql
         EXECUTE p303_pre_10
         #FUN-D40105--add--end--
           IF STATUS THEN
#             CALL cl_err('(upd fcx)',STATUS,1) #No.FUN-660136
              #CALL cl_err3("upd","fcx_file",g_existno,"",STATUS,"","(upd fcx)",1)   #No.FUN-660136 #CHI-C20017 mark
              LET g_success='N' 
              #RETURN   #CHI-C20017 mark
           #CHI-C20017--add--str
              #IF g_bgjob = 'Y' THEN    #FUN-D40105 mark
                 CALL s_errmsg('','','(upd fcx)',STATUS,1)
              #FUN-D40105--mark--str--     
              #ELSE
              #   CALL cl_err3("upd","fcx_file",g_existno,"",STATUS,"","(upd fcx)",1)
              #   RETURN
              #sEND IF
              #FUN-D40105--mark--end--  
           #CHI-C20017--add--end
           END IF
           LET n8=SQLCA.SQLERRD[3]
#------ added by frank871  NO:0069
    WHEN g_type = 12   #保險       
         SELECT fbx01 INTO gl_no FROM fbx_file WHERE fbx07 = g_existno   #No.FUN-CB0096   Add
         #UPDATE fdd_file SET fdd06=NULL,fdd07=NULL WHERE fdd06=g_existno   #FUN-D40105 mark
         #FUN-D40105--add--str-- 
         IF g_aaz84 = '2' THEN
            LET tm.wc1 = cl_replace_str(tm.wc1,"aba01","fdd06")
         ELSE
            LET tm.wc1 = cl_replace_str(tm.wc1,"tic04","fdd06")
         END IF 
         LET g_sql = "UPDATE fdd_file SET fdd06=NULL,fdd07=NULL  ",
                     " WHERE ",tm.wc1
         PREPARE p303_pre_11 FROM g_sql
         EXECUTE p303_pre_11
         #FUN-D40105--add--end--
           IF STATUS THEN
#             CALL cl_err('(upd fdd)',STATUS,1) #No.FUN-660136
              #CALL cl_err3("upd","fdd_file",g_existno,"",STATUS,"","(upd fdd)",1)   #No.FUN-660136 #CHI-C20017 mark
              LET g_success='N' 
              #RETURN   #CHI-C20017 mark
           #CHI-C20017--add--str
              #IF g_bgjob = 'Y' THEN   #FUN-D40105 mark
                 CALL s_errmsg('','','(upd fdd)',STATUS,1)
              #FUN-D40105--mark--str--     
              #ELSE
              #   CALL cl_err3("upd","fdd_file",g_existno,"",STATUS,"","(upd fdd)",1)
              #   RETURN
              #END IF
              #FUN-D40105--mark--end--  
           #CHI-C20017--add--end
           END IF
           LET n9=SQLCA.SQLERRD[3]
#-----------------------
    #No:A099
    WHEN g_type = 13  #減值準備                                                 
         SELECT fbx01 INTO gl_no FROM fbx_file WHERE fbx07 = g_existno   #No.FUN-CB0096   Add
         #UPDATE fbs_file SET fbs04 = NULL, fbs05 = NULL WHERE fbs04=g_existno    #FUN-D40105 mark
         #FUN-D40105--add--str-- 
         IF g_aaz84 = '2' THEN
            LET tm.wc1 = cl_replace_str(tm.wc1,"aba01","fbs04")
         ELSE
            LET tm.wc1 = cl_replace_str(tm.wc1,"tic04","fbs04")
         END IF 
         LET g_sql = "UPDATE fbs_file SET fbs04 = NULL, fbs05 = NULL  ",
                     " WHERE ",tm.wc1
         PREPARE p303_pre_12 FROM g_sql
         EXECUTE p303_pre_12
         #FUN-D40105--add--end--  
           IF STATUS THEN                                                       
#             CALL cl_err('(upd fbs)',STATUS,1) #No.FUN-660136
              #CALL cl_err3("upd","fbs_file",g_existno,"",STATUS,"","(upd fbs)",1)   #No.FUN-660136 #CHI-C20017 mark
              LET g_success='N' 
              #RETURN   #CHI-C20017 mark
           #CHI-C20017--add--str
              #IF g_bgjob = 'Y' THEN   #FUN-D40105 mark
                 CALL s_errmsg('','','(upd fbs)',STATUS,1)
              #FUN-D40105--mark--str--        
              #ELSE
              #   CALL cl_err3("upd","fbs_file",g_existno,"",STATUS,"","(upd fbs)",1)
              #   RETURN
              #END IF
              #FUN-D40105--mark--end--  
           #CHI-C20017--add--end
           END IF                                                               
           LET n12=SQLCA.SQLERRD[3]                                             
    #end No:A099
    END CASE
      IF n1+n2+n3+n4+n5+n6+n7+n8+n9+n11+n12+n14 = 0 THEN    #No:A099 #FUN-BC0035 add n14
         #CALL cl_err('upd fa?:','aap-161',1) #CHI-C20017 mark
         LET g_success='N' 
         #RETURN    #CHI-C20017 mark
      #CHI-C20017--add--str
         #IF g_bgjob = 'Y' THEN   #FUN-D40105 mark
            CALL s_errmsg('','','upd fa?:','aap-161',1)
         #FUN-D40105--mark--str--     
         #ELSE
         #   CALL cl_err('upd fa?:','aap-161',1)
         #   RETURN
         #END IF
         #FUN-D40105--mark--end--
      #CHI-C20017--add--end
      END IF
   #----------------------------------------------------------------------

   #FUN-D40105--add--str--
   CASE 
     WHEN g_type = 1  
        LET tm.wc1 = cl_replace_str(tm.wc1,"faq06","nppglno")     
     WHEN g_type = 2
        LET tm.wc1 = cl_replace_str(tm.wc1,"fas07","nppglno")    
     WHEN g_type = 14
        LET tm.wc1 = cl_replace_str(tm.wc1,"fbx07","nppglno")  
     WHEN g_type = 4 
        LET tm.wc1 = cl_replace_str(tm.wc1,"fbe14","nppglno")  
     WHEN g_type = 5  OR g_type = 6 
        LET tm.wc1 = cl_replace_str(tm.wc1,"fbg08","nppglno") 
     WHEN g_type = 7
        LET tm.wc1 = cl_replace_str(tm.wc1,"fay06","nppglno")
     WHEN g_type = 8
        LET tm.wc1 = cl_replace_str(tm.wc1,"fba06","nppglno")   
     WHEN g_type = 9
        LET tm.wc1 = cl_replace_str(tm.wc1,"fbc06","nppglno")  
     WHEN g_type = 10
        LET tm.wc1 = cl_replace_str(tm.wc1,"nppglno","nppglno")
     WHEN g_type = 11
        LET tm.wc1 = cl_replace_str(tm.wc1,"fcx11","nppglno")
     WHEN g_type = 12
        LET tm.wc1 = cl_replace_str(tm.wc1,"fdd06","nppglno")
     WHEN g_type = 13 
        LET tm.wc1 = cl_replace_str(tm.wc1,"fbs04","nppglno")
   END CASE 
   #FUN-D40105--add--end--

   #FUN-D40105--mark--str-- 
   #UPDATE npp_file SET npp03 = NULL ,nppglno= NULL,
   #                    npp06 = NULL ,npp07  = NULL  #no.7277
   # WHERE nppglno=g_existno
   #   AND npptype='0' AND npp07 = g_faa.faa02b  #No.FUN-680028
   #FUN-D40105--mark--end--   

   #FUN-D40105--add--str--   
   LET g_sql = "UPDATE npp_file SET npp03 = NULL ,nppglno= NULL,",
               "                    npp06 = NULL ,npp07  = NULL ",
               " WHERE npptype='0' ",
               "   AND npp07 = '",g_faa.faa02b,"'",
               "   AND ",tm.wc1  
   PREPARE p203_pre_13 FROM g_sql
   EXECUTE p203_pre_13             
   #FUN-D40105--add--end--  
      IF STATUS THEN
#        CALL cl_err('(upd npp03)',STATUS,1) #No.FUN-660136
         #CALL cl_err3("upd","npp_file",g_existno,"",STATUS,"","(upd npp03)",1)   #No.FUN-660136 #CHI-C20017 mark
         LET g_success='N' 
         #RETURN    #CHI-C20017 mark
      #CHI-C20017--add--str
         #IF g_bgjob = 'Y' THEN    #FUN-D40105 mark
            CALL s_errmsg('','','(upd npp03)',STATUS,1)
         #FUN-D40105--mark--str--    
         #ELSE
         #   CALL cl_err3("upd","npp_file",g_existno,"",STATUS,"","(upd npp03)",1)
         #   RETURN
         #END IF
         #FUN-D40105--mark--end--
      #CHI-C20017--add--end
      END IF
  #No.FUN-CB0096 ---start--- Add
   #LET l_time = TIME        #FUN-D40105 mark
   LET l_time = l_time + 1   #FUN-D40105 add
   LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
   CALL s_log_data('I','114',g_id,'2',l_time,g_existno,gl_no)
  #No.FUN-CB0096 ---end  --- Add
END FUNCTION
 
#No:A099
FUNCTION p303_set_comb()                                                        
  DEFINE comb_value STRING                                                      
  DEFINE comb_item  STRING                                                      
                                                                                
    LET comb_value = '1,2,4,5,6,7,8,9,10,11,12,13,14' #FUN-BC0035 add 14
    CALL cl_getmsg('afa-377',g_lang) RETURNING comb_item
 
    CALL cl_set_combo_items('g_type',comb_value,comb_item)     
END FUNCTION
#end No:A099
 
#No.FUN-680028--begin
FUNCTION p303_t_1()
   DEFINE n1,n2,n3,n4,n5,n6,n7,n8,n9,n11,n14 LIKE type_file.num10        #No.FUN-680070 INTEGER #FUN-BC0035 add n14
   DEFINE n12                            LIKE type_file.num10           #No:A099       #No.FUN-680070 INTEGER
   DEFINE l_npp	   	    RECORD LIKE npp_file.*
 
IF g_aaz84 = '2' THEN   #還原方式為作廢 #no.4868
  #FUN-A50102--mod--str-- 
  #LET g_sql="UPDATE ",g_dbs_gl," aba_file  SET abaacti = 'N' ",
   LET g_sql="UPDATE ",cl_get_target_table(g_plant_new,'aba_file'),
             "   SET abaacti = 'N' ",
  #FUN-A50102--mod--end
             " WHERE aba01 = ? AND aba00 = ? "
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
   PREPARE p303_updaba_p_1 FROM g_sql
   EXECUTE p303_updaba_p_1 USING g_existno,g_faa.faa02c
   IF SQLCA.sqlcode THEN
      #CALL cl_err('(upd abaacti)',SQLCA.sqlcode,1)  #CHI-C20017 mark
      LET g_success = 'N' 
      #RETURN   #CHI-C20017 mark
   #CHI-C20017--add--str
      IF g_bgjob = 'Y' THEN
         CALL s_errmsg('','','(upd abaacti)',SQLCA.sqlcode,1)
      ELSE
         CALL cl_err('(upd abaacti)',SQLCA.sqlcode,1)
         RETURN
      END IF
   #CHI-C20017--add--end
   END IF
ELSE
   IF g_bgjob= 'N' THEN    #FUN-570144 BY 050919
      MESSAGE "Delete GL's Voucher body!"  #-------------------------
      CALL ui.Interface.refresh()
   END IF
  #FUN-A50102--mod--str--
  #LET g_sql="DELETE FROM ",g_dbs_gl,"abb_file WHERE abb01=? AND abb00=?"
   LET g_sql="DELETE FROM ",cl_get_target_table(g_plant_new,'abb_file'),
             " WHERE abb01=? AND abb00=?"
  #FUN-A50102--mod--end
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
   PREPARE p303_2_p3_1 FROM g_sql
   EXECUTE p303_2_p3_1 USING g_existno1,g_faa.faa02c
   IF SQLCA.sqlcode THEN
      #CALL cl_err('(del abb)',SQLCA.sqlcode,1)  #CHI-C20017 mark
      LET g_success = 'N' 
      #RETURN  #CHI-C20017 mark
   #CHI-C20017--add--str
      IF g_bgjob = 'Y' THEN
         CALL s_errmsg('','','(del abb)',SQLCA.sqlcode,1)
      ELSE
         CALL cl_err('(del abb)',SQLCA.sqlcode,1)
         RETURN
      END IF
   #CHI-C20017--add--end
   END IF
   IF g_bgjob= 'N' THEN    #FUN-570144
       MESSAGE "Delete GL's Voucher head!"  #-------------------------
       CALL ui.Interface.refresh()
   END IF
  #FUN-A50102--mod--str--
  #LET g_sql="DELETE FROM ",g_dbs_gl,"aba_file WHERE aba01=? AND aba00=?"
   LET g_sql="DELETE FROM ",cl_get_target_table(g_plant_new,'aba_file'),
             " WHERE aba01=? AND aba00=?"
  #FUN-A50102--mod--end
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
   PREPARE p303_2_p4_1 FROM g_sql
   EXECUTE p303_2_p4_1 USING g_existno1,g_faa.faa02c
   IF SQLCA.sqlcode THEN
      #CALL cl_err('(del aba)',SQLCA.sqlcode,1)  #CHI-C20017 mark
      LET g_success = 'N' 
      #RETURN   #CHI-C20017 mark
   #CHI-C20017--add--str
      IF g_bgjob = 'Y' THEN
         CALL s_errmsg('','','(del aba)',SQLCA.sqlcode,1)
      ELSE
         CALL cl_err('(del aba)',SQLCA.sqlcode,1)
         RETURN
      END IF
   #CHI-C20017--add--end
   END IF
   IF SQLCA.sqlerrd[3] = 0 THEN
      #CALL cl_err('(del aba)','aap-161',1)  #CHI-C20017 mark
      LET g_success = 'N' 
      #RETURN   #CHI-C20017 mark
   #CHI-C20017--add--str
      IF g_bgjob = 'Y' THEN
         CALL s_errmsg('','','(del aba)','aap-161',1)
      ELSE
         CALL cl_err('(del aba)','aap-161',1)
         RETURN
      END IF
   #CHI-C20017--add--end
   END IF
   IF g_bgjob= 'N' THEN    #FUN-570144
       MESSAGE "Delete GL's Voucher desp!"  #-------------------------
       CALL ui.Interface.refresh()
   END IF
  #FUN-A50102--mod--str--
  #LET g_sql="DELETE FROM ",g_dbs_gl,"abc_file WHERE abc01=? AND abc00=?"
   LET g_sql="DELETE FROM ",cl_get_target_table(g_plant_new,'abc_file'),
             " WHERE abc01=? AND abc00=?"
  #FUN-A50102--mod--end
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
   PREPARE p303_2_p5_1 FROM g_sql
   EXECUTE p303_2_p5_1 USING g_existno1,g_faa.faa02c
   IF SQLCA.sqlcode THEN
      #CALL cl_err('(del abc)',SQLCA.sqlcode,1)  #CHI-C20017 mark
      LET g_success = 'N' 
      #RETURN   #CHI-C20017 mark
   #CHI-C20017--add--str
      IF g_bgjob = 'Y' THEN
         CALL s_errmsg('','','(del abc)',SQLCA.sqlcode,1)
      ELSE
         CALL cl_err('(del abc)',SQLCA.sqlcode,1)
         RETURN
      END IF
   #CHI-C20017--add--end
   END IF
#FUN-B40056 -begin
   LET g_sql="DELETE FROM ",cl_get_target_table(p_plant,'tic_file'),
             " WHERE tic04=? AND tic00=?"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql       
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
   PREPARE p303_2_p10 FROM g_sql
   EXECUTE p303_2_p10 USING g_existno1,g_faa.faa02c
   IF SQLCA.sqlcode THEN
      #CALL cl_err('(del tic)',SQLCA.sqlcode,1)  #CHI-C20017 mark
      LET g_success = 'N' 
      #RETURN   #CHI-C20017 mark
   #CHI-C20017--add--str
      IF g_bgjob = 'Y' THEN
         CALL s_errmsg('','','(del tic)',SQLCA.sqlcode,1)
      ELSE
         CALL cl_err('(del tic)',SQLCA.sqlcode,1)
         RETURN
      END IF
   #CHI-C20017--add--end
   END IF
#FUN-B40056 -end 
END IF
   IF g_bgjob= 'N' THEN    #FUN-570144
       MESSAGE "Delete GL's Voucher detail!"  #-------------------------
       CALL ui.Interface.refresh()
   END IF
   IF g_success = 'N' THEN RETURN END IF
 
   LET g_msg = TIME
   INSERT INTO azo_file (azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)      #FUN-980003 add
          VALUES('afap303',g_user,g_today,g_msg,g_existno1,'delete',g_plant,g_legal) #FUN-980003 add
 
   UPDATE npp_file SET npp03 = NULL ,nppglno= NULL,
                       npp06 = NULL ,npp07  = NULL  #no.7277
    WHERE nppglno=g_existno1
      AND npptype='1' AND npp07 = g_faa.faa02c  #No.FUN-680028
      IF STATUS THEN
         #CALL cl_err3("upd","npp_file",g_existno1,"",STATUS,"","(upd npp03)",1)   #No.FUN-660136 #CHI-C20017 mark
         LET g_success='N' 
         #RETURN   #CHI-C20017 mark
      #CHI-C20017--add--str
         IF g_bgjob = 'Y' THEN
            CALL s_errmsg('','','(upd npp03)',STATUS,1)
         ELSE
            CALL cl_err3("upd","npp_file",g_existno1,"",STATUS,"","(upd npp03)",1)
            RETURN
         END IF
      #CHI-C20017--add--end
      END IF
  #No.FUN-CB0096 ---start--- Add
   #LET l_time = TIME        #FUN-D40105 mark
   LET l_time = l_time + 1   #FUN-D40105 add
   LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
   CALL s_log_data('I','114',g_id,'2',l_time,g_existno,gl_no)
  #No.FUN-CB0096 ---end  --- Add
END FUNCTION
#No.FUN-680028--end  

FUNCTION p303_existno_chk()
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

   LET g_sql="SELECT aba01,aba02,abapost,aba19,abaacti,aba20,aba06 ",   #MOD-G30031 add aba06    
             "  FROM ",cl_get_target_table(g_plant_new,'aba_file'),  
            #" WHERE aba00 = ? AND aba06='FA'",                         #MOD-G30031 mark
             " WHERE aba00 = ? ",                                       #MOD-G30031 add 
             "   AND ",tm.wc1
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql       
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   
   PREPARE p303_t_p11 FROM g_sql
   DECLARE p303_t_c11 CURSOR FOR p303_t_p11
   IF STATUS THEN
      CALL s_errmsg('','','decl aba_cursor:',STATUS,1)  
      LET g_success = 'N'                                                 
   END IF
   FOREACH p303_t_c11 USING g_faa.faa02b
                       INTO l_aba01,gl_date,l_abapost,l_aba19,
                            l_abaacti,l_aba20,l_aba06   #MOD-G30031 add l_aba06  
      IF STATUS THEN
         CALL s_errmsg('',l_aba01,'sel aba:',STATUS,1)  
         LET g_success = 'N'                                                 
      END IF
      IF l_abaacti = 'N' THEN
         #CALL s_errmsg('','','','mfg8001',1)      #TQC-D60072 mark
         CALL s_errmsg('',l_aba01,'','mfg8001',1)  #TQC-D60072 add
         LET g_success = 'N'                                                 
      END IF
      IF l_aba20 MATCHES '[Ss1]' THEN
        #CALL s_errmsg('','','','mfg3557',1)       #TQC-D60072 mark   #MOD-G30031 mark
         CALL s_errmsg('',l_aba01,'','mfg3557',1)  #TQC-D60072 add
         LET g_success = 'N'                                                 
      END IF
     #MOD-G30031---add---str--
      IF l_aba06 <> 'FA' THEN
         CALL s_errmsg('sel aba:',l_aba01,'','agl040',1)
         LET g_success = 'N'
      END IF
     #MOD-G30031---add---end--
      IF l_abapost = 'Y' THEN
         #CALL s_errmsg('','',g_existno,'aap-130',1)   #TQC-D60072 mark
         CALL s_errmsg('','',l_aba01,'aap-130',1)      #TQC-D60072 add 
         LET g_success = 'N'                                                 
      END IF
      SELECT aaa07 INTO l_aaa07        
        FROM aaa_file                 
       WHERE aaa01= p_acc              
      IF gl_date < l_aaa07  THEN       
        #CALL s_errmsg('','',gl_date,'aap-027',1)        #TQC-D60072 mark   #MOD-G30031 mark
         CALL s_errmsg('',l_aba01,gl_date,'aap-027',1)   #TQC-D60072 add 
         LET g_success = 'N'                                                 
      END IF
      IF l_aba19 ='Y' THEN 
         #CALL s_errmsg('','',gl_date,'aap-026',1)       #TQC-D60072 mark
         CALL s_errmsg('',l_aba01,gl_date,'aap-026',1)   #TQC-D60072 add 
         LET g_success = 'N'                                                 
      END IF   
   END FOREACH 
END FUNCTION 
