# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: anmp110.4gl
# Descriptions...: 定存/外匯傳票拋轉還原
# Date & Author..: 98/06/24 By Danny
# Modify.........: 99/06/29 By Kammy (add定存部份)
# Modify.........: No.MOD-510037 05/01/19 By kitty 傳票拋轉還原作錯支程式,但傳票還是會被作廢或刪除
# Modify.........: NO.FUN-550057 05/05/23 By jackie 單據編號加大
# Modify.........: No.MOD-560219 05/08/03 By Smapmin 新增判斷npp00=11,npp00=12的處理
# Modify.........: MOD-590081 05/09/20 By Smapmin 取消call s_abhmod()
# Modify.........: NO.FUN-570127 2006/03/08 By yiting 批次背景作業
# Modify.........: No.MOD-630059 06/03/17 By Smapmin 加入不能執行還原作業的條件判斷
# Modify.........: No.MOD-640499 06/04/18 By Smapmin 增加類別24的處理
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-670039 06/07/12 By Carrier 帳別擴充為5碼
# Modify.........: No.MOD-680013 06/08/04 By Smapmin 因應MOD-470276,故將npp00='4','5'的update gxf_file段落mark
# Modify.........: No.FUN-680088 06/08/28 By Elva 新增多帳套功能
# Modify.........: No.FUN-680107 06/09/06 By Hellen 欄位類型修改
# Modify.........: No.FUN-690117 06/10/16 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.CHI-780008 07/08/13 By Smapmin 還原MOD-590081
# Modify.........: No.FUN-980005 09/08/12 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.MOD-980096 09/08/13 By mike 傳票編號 應檢查  anmp110 畫面上的營運中心的 傳票編號                              
# Modify.........: No.FUN-980020 09/08/30 By douzh GP5.2架構重整，修改sub相關傳參
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-990031 09/10/13 By lutingtingGP5.2財務營運中心欄位調整,營運中心要控制在同一法人下 
# Modify.........: No:CHI-A20014 10/02/25 By sabrina 送簽中或已核准不可還原
# Modify.........: No.FUN-A50102 10/07/09 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:MOD-AB0110 10/11/11 By Dido npp00若為 1,2,3,6,7,16,17,18,19,20,則必須至anmp409執行還原作業  
# Modify.........: No:FUN-B40056 11/06/03 By guoch 刪除資料時一併刪除tic_file的資料
# Modify.........: No:CHI-C20017 12/05/29 By wangrr 若g_bgjob='Y'時使用彙總訊息方式呈現
# Modify.........: No.FUN-CB0096 13/01/10 by zhangweib 增加log檔記錄程序運行過程
# Modify.........: No:MOD-CC0035 13/02/19 By Polly npp00為8、10、11、12類需回寫nme10、nme16欄位
# Modify.........: No.FUN-D60110 13/08/26 by yangtt 憑證編號開窗可多選
# Modify.........: No:MOD-G30031 16/03/09 By doris 1.輸入時,傳票編號不允許打*號
#                                                  2.拋轉還原時多控卡不允許刪除不同來源碼的傳票
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_wc,g_sql       LIKE type_file.chr1000 #No.FUN-580092 HCN #No.FUN-680107 STRING
DEFINE g_dbs_gl 	LIKE type_file.chr21   #NO.FUN-680107 VARCHAR(21)
DEFINE p_plant          LIKE azp_file.azp01    #NO.FUN-680107 VARCHAR(12)
DEFINE p_acc            LIKE aaa_file.aaa01    #No.FUN-670039
DEFINE p_acc1           LIKE aaa_file.aaa01    #No.FUN-680088
DEFINE gl_date		LIKE type_file.dat     #NO.FUN-680107 DATE
DEFINE gl_yy,gl_mm	LIKE type_file.num5    #NO.FUN-680107 SMALLINT
#DEFINE g_existno	LIKE apk_file.apk28    #NO.FUN-680107 VARCHAR(12)	
DEFINE g_existno	LIKE npp_file.nppglno  #NO.FUN-550057
DEFINE g_existno1       LIKE npp_file.nppglno  #NO.FUN-680088
DEFINE g_str 		LIKE type_file.chr3    #NO.FUN-680107 VARCHAR(3)
DEFINE g_mxno		LIKE type_file.chr8    #NO.FUN-680107 VARCHAR(8)
DEFINE p_row,p_col      LIKE type_file.num5    #No.FUN-680107 SMALLINT
DEFINE g_aaz84          LIKE aaz_file.aaz84    #還原方式 1.刪除 2.作廢 no.4868
DEFINE g_msg            LIKE ze_file.ze03      #No.FUN-680107 VARCHAR(72)
DEFINE g_flag           LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
DEFINE g_change_lang    LIKE type_file.chr1    # Prog. Version..: '5.30.06-13.03.12(01) #FUN-570127
#No.FUN-CB0096 ---start--- Add
DEFINE g_id     LIKE azu_file.azu00
DEFINE l_id     STRING
DEFINE l_time   LIKE type_file.chr8
#No.FUN-CB0096 ---end  --- Add
#No.FUN-D60110 ---Add--- Start
DEFINE g_existno_str     STRING
DEFINE bst base.StringTokenizer
DEFINE temptext STRING
DEFINE l_errno LIKE type_file.num10
DEFINE g_existno1_str STRING
DEFINE tm   RECORD
            wc1         STRING
            END RECORD
#No.FUN-D60110 ---Add--- End

MAIN
#     DEFINEl_time LIKE type_file.chr8               #No.FUN-6A0082
DEFINE l_aba19          LIKE aba_file.aba19    #FUN-680088
DEFINE l_abapost        LIKE aba_file.abapost  #FUN-680088
DEFINE l_abaacti        LIKE aba_file.abaacti  #FUN-680088
DEFINE l_aba20          LIKE aba_file.aba20    #CHI-A20014 add
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
#NO.FUN-570127--start--
   INITIALIZE g_bgjob_msgfile TO NULL
   LET p_plant   = ARG_VAL(1)
   LET p_acc     = ARG_VAL(2)
   LET g_existno = ARG_VAL(3)
   LET g_bgjob   = ARG_VAL(4)
#  LET p_acc1    = ARG_VAL(5)  #FUN-680088
#  LET g_existno1= ARG_VAL(6)  #FUN-680088
         
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
#NO.FUN-570127---end---
 
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690117
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
 
#NO.FUN-570127 mark--
#   OPEN WINDOW p110 AT p_row,p_col WITH FORM "anm/42f/anmp110" 
#    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
#   CALL cl_ui_init()
 
#   CALL cl_opmsg('z')
#    CALL p110()
#    CLOSE WINDOW p110
#NO.FUN-570127 mark--
   LET g_success = 'Y'  #CHI-C20017 add
#NO.FUN-570127 start--
   WHILE TRUE
      CALL s_showmsg_init()  #CHI-C20017 add
      IF g_bgjob = 'N' THEN
         CALL p110_ask()
         #FUN-D60110 ---Add--- Start
         IF tm.wc1 = " 1=1" THEN
            CALL cl_err('','9033',0)
            CONTINUE WHILE
         END IF
         #FUN-D60110 ---Add--- End
         IF cl_sure(18,20) THEN
            LET g_success = 'Y'
            BEGIN WORK
            #FUN-D60110 ---Add--- Start
            CALL p110_existno_chk()
            IF g_success = 'N' THEN
                CALL s_showmsg()
                CONTINUE WHILE
            END IF
            #FUN-D60110 ---Add--- End
            CALL p110()
            CALL s_showmsg()  #CHI-C20017 add
            IF g_success = 'Y' THEN
               COMMIT WORK
               CALL cl_end2(1) RETURNING g_flag
            ELSE
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING g_flag
            END IF
            IF g_flag THEN
                 CONTINUE WHILE
            ELSE
                 CLOSE WINDOW p110_w
                 EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         LET tm.wc1 = "g_existno IN ('",g_existno,"')"  #No.FUN-D60110 Add
         CALL p110_existno_chk()                        #No.FUN-D60110 Add
        #No.FUN-D60110 ---Mark--- Start
        ##FUN-680088  --begin
        #LET g_plant_new=p_plant
        #CALL s_getdbs()
        #LET g_dbs_gl=g_dbs_new
        #LET g_sql="SELECT aba19,abapost,abaacti,aba20 ",   #CHI-A20014 add aba20
        #          #" FROM ",g_dbs_gl CLIPPED,"aba_file",
        #          " FROM ",cl_get_target_table(g_plant_new,'aba_file'), #FUN-A50102
        #          " WHERE aba01 = ? AND aba00 = ? AND aba06='NM'"
 	#    CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
        #CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
        #PREPARE p110_t_p11 FROM g_sql
        #DECLARE p110_t_c11 CURSOR FOR p110_t_p11
        #IF STATUS THEN
        #   #CALL cl_err('decl aba_cursor:',STATUS,1) #CHI-C20017 mark
        #   CALL s_errmsg('','','decl aba_cursor:',STATUS,1)  #CHI-C20017 add
        #   LET g_success = 'N'
        #   #RETURN  #CHI-C20017 mark
        #END IF
        #OPEN p110_t_c11 USING g_existno,g_nmz.nmz02b
        #FETCH p110_t_c11 INTO l_aba19,l_abapost,l_abaacti,l_aba20    #CHI-A20014 add l_aba20 
        #IF STATUS THEN
        #   #CALL cl_err('sel aba:',STATUS,1)  #CHI-C20017 mark
        #   CALL s_errmsg('','','sel aba:',STATUS,1)  #CHI-C20017 add
        #   LET g_success = 'N'
        #   #RETURN  #CHI-C20017 mark
        #END IF
        ##no.7378
        #IF l_abaacti = 'N' THEN
        #   #CALL cl_err('','mfg8001',1)  #CHI-C20017 mark
        #   CALL s_errmsg('','','','mfg8001',1)  #CHI-C20017 add
        #   LET g_success = 'N'
        #   #RETURN  #CHI-C20017 mark
        #END IF
        #CHI-A20014---add---start---
        #IF l_aba20 MATCHES '[Ss1]' THEN
        #   #CALL cl_err('','mfg3557',0)  #CHI-C20017 mark
        #   CALL s_errmsg('','','','mfg3557',1)   #CHI-C20017 add
        #   LET g_success = 'N'
        #   #RETURN  #CHI-C20017 mark
        #END IF
        #CHI-A20014---add---end---
        ##no.7378(end)
        #IF l_abapost = 'Y' THEN
        #   #CALL cl_err(g_existno,'aap-130',1) #CHI-C20017 mark
        #   CALL s_errmsg('','',g_existno,'aap-130',1)  #CHI-C20017 add
        #   LET g_success = 'N'
        #   #RETURN  #CHI-C20017 mark
        #END IF
        #IF l_aba19 = 'Y' THEN
        #   #CALL cl_err(g_existno,'anm-114',1) #CHI-C20017 mark
        #   CALL s_errmsg('','',g_existno,'anm-114',1)  #CHI-C20017 add
        #   LET g_success = 'N'
        #   #RETURN  #CHI-C20017 mark
        #END IF
        #IF g_aza.aza63 = 'Y' THEN
        #   SELECT UNIQUE npp07,nppglno INTO p_acc1,g_existno1
        #     FROM npp_file WHERE npp01 IN (SELECT npp01 FROM npp_file
        #                                    WHERE npp07=p_acc
        #                                      AND nppglno=g_existno
        #                                      AND npptype='0')
        #      AND npptype = '1'
        #      AND npp00 IN (SELECT npp00 FROM npp_file
        #                     WHERE npp07=p_acc
        #                       AND nppglno=g_existno
        #                       AND npptype='0')
        #   IF STATUS = 100 THEN
        #      #CALL cl_err3("sel","npp_file",g_existno,"","aap-986","","",1) #No.FUN-680088 #CHI-C20017 mark
        #      CALL s_errmsg('','','','aap-986',1)  #CHI-C20017 add
        #      LET g_success = 'N'
        #      #RETURN  #CHI-C20017 mark
        #   END IF
        #   OPEN p110_t_c11 USING g_existno1,g_nmz.nmz02c
        #   FETCH p110_t_c11 INTO l_aba19,l_abapost,l_abaacti,l_aba20 #no.7378     #CHI-A20014 add l_aba20
        #   IF STATUS THEN
        #      #CALL cl_err('sel aba:',STATUS,1) #CHI-C20017 mark
        #      CALL s_errmsg('','','sel aba:',STATUS,1)  #CHI-C20017 add
        #      LET g_success = 'N'
        #      #RETURN  #CHI-C20017 mark
        #   END IF
        #   IF l_abaacti = 'N' THEN
        #      #CALL cl_err('','mfg8003',1) #CHI-C20017 mark
        #      CALL s_errmsg('','','','mfg8003',1)  #CHI-C20017 add
        #      LET g_success = 'N'
        #      #RETURN  #CHI-C20017 mark
        #   END IF
        #  #CHI-A20014---add---start---
        #   IF l_aba20 MATCHES '[Ss1]' THEN
        #      #CALL cl_err('','mfg3557',0) #CHI-C20017 mark 
        #      CALL s_errmsg('','','','mfg3557',1)  #CHI-C20017 add
        #      LET g_success = 'N'
        #      #RETURN  #CHI-C20017 mark
        #   END IF
        #  #CHI-A20014---add---end---
        #   #no.7378(end)
        #   IF l_abapost = 'Y' THEN
        #      #CALL cl_err(g_existno1,'aap-132',1) #CHI-C20017 mark
        #      CALL s_errmsg('','',g_existno1,'aap-132',1)  #CHI-C20017 add
        #      LET g_success = 'N'
        #      #RETURN  #CHI-C20017 mark
        #   END IF
        #   IF l_aba19 = 'Y' THEN
        #      #CALL cl_err(g_existno1,'anm-116',1) #CHI-C20017 mark
        #      CALL s_errmsg('','',g_existno1,'anm-116',1)  #CHI-C20017 add
        #      LET g_success = 'N'
        #      #RETURN   #CHI-C20017 mark
        #   END IF
        #END IF
        ##FUN-680088  --end  
       #No.FUN-D60110 ---Mark--- Start
 
         #LET g_success = 'Y'  #CHI-C20017 mark
         BEGIN WORK
         CALL p110() 
         CALL s_showmsg()  #CHI-C20017 add
         IF g_success = 'Y' THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
#NO.FUN-570127---end---
     #No.FUN-CB0096 ---start--- add
     #LET l_time = TIME   #No.FUN-D60110 Mark
      LET l_time = l_time + 1 #No.FUN-D60110   Add
      LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
      CALL s_log_data('U','100',g_id,'1',l_time,'','')
     #No.FUN-CB0096 ---end  --- add
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
END MAIN
 
FUNCTION p110()
 
#NO.FUN-570127 mark---
#    WHILE TRUE 
#     # 得出總帳 database name 
#     # g_nmz.nmz02p -> g_plant_new -> s_getdbs() -> g_dbs_new --> g_dbs_gl
#       ERROR ""
#       LET g_flag = 'Y'
#       CALL p110_ask()			
#       IF g_flag = 'N' THEN 
#          CONTINUE WHILE
#       END IF 
#       IF INT_FLAG THEN 
#          LET INT_FLAG = 0
#          EXIT WHILE
#       END IF
#       IF cl_sure(20,20) THEN 
#          CALL cl_wait()
#NO.FUN-570127 mark---------
           IF g_bgjob = 'N' THEN
               OPEN WINDOW p110_t_w9 AT 19,4 WITH 3 ROWS, 70 COLUMNS 
           END IF
#          LET g_success = 'Y'   #NO.FUN-570127 mark
 
          LET g_plant_new=p_plant
          CALL s_getdbs()
          LET g_dbs_gl=g_dbs_new
       
          #no.4868 (還原方式為刪除/作廢)
          #LET g_sql = "SELECT aaz84 FROM ",g_dbs_gl CLIPPED,"aaz_file",
          LET g_sql = "SELECT aaz84 FROM ",cl_get_target_table(g_plant_new,'aaz_file'), #FUN-A50102
                      " WHERE aaz00 = '0' "
 	      CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
          CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
          PREPARE aaz84_pre FROM g_sql
          DECLARE aaz84_cs CURSOR FOR aaz84_pre
          OPEN aaz84_cs 
          FETCH aaz84_cs INTO g_aaz84
          IF STATUS THEN 
       #     CALL cl_err('sel aaz84',STATUS,1)
             #CALL cl_err('','aap-129',1)  #CHI-C20017 mark
             #CHI-C20017--add--str
             LET g_success = 'N'
            #IF g_bgjob = 'Y' THEN   #No.FUN-D60110  Mark
            #   CALL s_errmsg('','','','aap-129',1)
            #No.FUN-D60110 ---Mark--- Start
            #ELSE
            #   CALL cl_err('','aap-129',1)
            #END IF
            #No.FUN-D60110 ---Mark--- End
             #CHI-C20017--add--end
             IF g_bgjob = 'N' THEN
                CLOSE WINDOW p110_t_w9
             END IF
#NO.FUN-570127 mark-------
#             CLOSE WINDOW p110_t_w9
#             CLOSE WINDOW p110
#             CONTINUE WHILE
#NO.FUN-570127 mark--
          RETURN     #NO.FUN-570127 
          END IF
#          #no.4868(end)
          BEGIN WORK
          CALL p110_t()
          #FUN-680088  --begin
          IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
             CALL p110_t_1()
          END IF
          #FUN-680088  --end
          IF g_bgjob = 'N' THEN
             CLOSE WINDOW p110_t_w9
          END IF
 
#NO.FUN-570127 mark----
#          IF g_success = 'Y' THEN 
#             COMMIT WORK
#             CALL cl_end2(1) RETURNING g_flag        #批次作業正確結束
#          ELSE
#             ROLLBACK WORK
#             CALL cl_end2(2) RETURNING g_flag        #批次作業失敗
#          END IF
#          CLOSE WINDOW p110_t_w9
#          IF g_flag THEN
#             CONTINUE WHILE
#          ELSE
#             EXIT WHILE
#          END IF
#       END IF
#    END WHILE
#NO.FUN-570127 mark---
 
END FUNCTION
 
FUNCTION p110_ask()
   DEFINE   l_abapost	LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
   DEFINE   l_aba19     LIKE aba_file.aba19
   DEFINE   l_abaacti   LIKE aba_file.abaacti
   DEFINE   lc_cmd      LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(500)   #NO.FUN-570127 
   DEFINE   l_npp07     LIKE npp_file.npp07    #FUN-680088
   DEFINE   l_nppglno   LIKE npp_file.nppglno  #FUN-680088
   DEFINE   l_aba20     LIKE aba_file.aba20    #CHI-A20014 add 
   DEFINE   l_cnt       LIKE type_file.num5    #MOD-AB0110
 
#FUN-570127 --start--
   OPEN WINDOW p110_w AT p_row,p_col WITH FORM "anm/42f/anmp110"
        ATTRIBUTE (STYLE = g_win_style)
 
   CALL cl_ui_init()
   CALL cl_opmsg('z')
#FUN-570127 ---end---
 
   #FUN-680088  --begin
   IF g_aza.aza63 = 'N' THEN
      CALL cl_set_comp_visible("p_acc1,g_existno1",FALSE) 
   END IF
   #FUN-680088  --end
 
   LET p_plant = g_nmz.nmz02p
   LET p_acc   = g_nmz.nmz02b
   LET g_existno = NULL
   LET p_acc1    = NULL  #FUN-680088
   LET g_existno1= NULL  #FUN-680088
   LET g_action_choice = ""                                       #FUN-570127
   LET g_bgjob = 'N'                                              #FUN-570127
   DISPLAY NULL TO FORMONLY.g_existno1  #No.FUN-D60110 Add
 
   WHILE TRUE    #NO.FUN-570127
   DIALOG ATTRIBUTES(UNBUFFERED)  #No.FUN-D60110 Add
   #INPUT BY NAME p_plant,p_acc,g_existno WITHOUT DEFAULTS 
  #INPUT BY NAME p_plant,p_acc,g_existno,p_acc1,g_existno1,g_bgjob  WITHOUT DEFAULTS   #NO.FUN-570127 #FUN-680088      #No.FUN-D60110 mark
   INPUT BY NAME p_plant,p_acc,p_acc1 ATTRIBUTE(WITHOUT DEFAULTS=TRUE)     #No.FUN-D60110 Add
 
      AFTER FIELD p_plant
         #FUN-990031--mod--str--    營運中心要控制在當前法人下
         #SELECT azp01 FROM azp_file WHERE azp01 = p_plant
         #IF STATUS <> 0 THEN 
         #   NEXT FIELD p_plant 
         SELECT * FROM azw_file WHERE azw01 = p_plant AND azw02 = g_legal                                                        
         IF STATUS THEN                                                                                                          
            CALL cl_err3("sel","azw_file",p_plant,"","agl-171","","",1)                                                          
            NEXT FIELD p_plant                                                                                                   
         #FUN-990031--mod--end 
        #MOD-980096   ---start                                                                                                      
         ELSE                                                                                                                       
            LET g_plant_new=p_plant                                                                                                 
            CALL s_getdbs()                                                                                                         
            LET g_dbs_gl=g_dbs_new                                                                                                  
        #MOD-980096   ---end      
         END IF
 
      AFTER FIELD p_acc
         IF p_acc IS NULL THEN
            NEXT FIELD p_acc
         END IF
         LET g_nmz.nmz02b = p_acc
 
     #No.FUN-D60110 ---Mark--- Start
     #AFTER FIELD g_existno
     #   IF cl_null(g_existno) THEN 
     #      NEXT FIELD g_existno 
     #   END IF
     #   LET g_sql="SELECT aba02,aba03,aba04,aba19,abapost,abaacti,aba20 ",   #CHI-A20014 add aba20
     #             #" FROM ",g_dbs_gl CLIPPED,"aba_file",
     #             " FROM ",cl_get_target_table(g_plant_new,'aba_file'), #FUN-A50102
     #             " WHERE aba01 = ? AND aba00 = ? AND aba06='NM'"
     #   CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     #   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
     #   PREPARE p110_t_p1 FROM g_sql
     #   DECLARE p110_t_c1 CURSOR FOR p110_t_p1
     #   IF STATUS THEN
     #      CALL cl_err('decl aba_cursor:',STATUS,0)
     #      NEXT FIELD g_existno
     #   END IF
     #   OPEN p110_t_c1 USING g_existno,g_nmz.nmz02b
     #   FETCH p110_t_c1 INTO gl_date,gl_yy,gl_mm,l_aba19,l_abapost,
     #                        l_abaacti,l_aba20  #no.7378     #CHI-A20014 add l_aba20
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
     #   IF l_abapost = 'Y' THEN
     #      CALL cl_err(g_existno,'aap-130',0)
     #      NEXT FIELD g_existno
     #   END IF
     #   IF l_aba19 = 'Y' THEN
     #      CALL cl_err(g_existno,'anm-114',0)
     #      NEXT FIELD g_existno
     #   END IF
     #  #-MOD-AB0110-add-
     #   LET l_cnt = 0
     #   SELECT COUNT(*) INTO l_cnt FROM npp_file
     #     WHERE nppglno = g_existno AND
     #           npp00 IN ('1','2','3','6','7','16','17','18','19','20')   
     #   IF l_cnt > 0 THEN
     #      CALL cl_err('','anm-708',0)
     #      NEXT FIELD g_existno
     #   END IF
     #  #-MOD-AB0110-end-
     #   #FUN-680088  --begin
     #   IF g_aza.aza63 = 'Y' THEN
     #      SELECT UNIQUE npp07,nppglno INTO l_npp07,l_nppglno
     #        FROM npp_file WHERE npp01 IN (SELECT npp01 FROM npp_file
     #                                       WHERE npp07=p_acc
     #                                         AND nppglno=g_existno
     #                                         AND npptype='0')
     #         AND npptype = '1'
     #         AND npp00 IN (SELECT npp00 FROM npp_file
     #                        WHERE npp07=p_acc
     #                          AND nppglno=g_existno
     #                          AND npptype='0')
     #      IF STATUS = 100 THEN
     #         CALL cl_err3("sel","npp_file",g_existno,"","aap-986","","",1) #No.FUN-680088
     #         NEXT FIELD g_existno
     #      END IF
     #      OPEN p110_t_c1 USING l_nppglno,g_nmz.nmz02c
     #      FETCH p110_t_c1 INTO gl_date,gl_yy,gl_mm,l_aba19,l_abapost,
     #                           l_abaacti,l_aba20 #no.7378    #CHI-A20014 add l_aba20
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
     #      #no.7378(end)
     #      IF l_abapost = 'Y' THEN
     #         CALL cl_err(g_existno1,'aap-132',0)
     #         NEXT FIELD g_existno
     #      END IF
     #      IF l_aba19 = 'Y' THEN
     #         CALL cl_err(g_existno1,'anm-116',0)
     #         NEXT FIELD g_existno
     #      END IF
     #      LET p_acc1 = l_npp07
     #      LET g_existno1 = l_nppglno
     #      DISPLAY l_npp07 TO FORMONLY.p_acc1
     #      DISPLAY l_nppglno TO FORMONLY.g_existno1
     #   END IF
     #   #FUN-680088  --end  
     #No.FUN-D60110 ---Mark--- End
 
      AFTER INPUT
         IF INT_FLAG THEN
           #EXIT INPUT      #No.FUN-D60110   Mark
            EXIT DIALOG     #No.FUN-D60110 Add
         END IF
     #No.FUN-D60110 ---Mark--- Start
     #ON ACTION CONTROLR
     #   CALL cl_show_req_fields()
 
     #ON ACTION CONTROLG
     #   CALL cl_cmdask()
 
     #ON ACTION locale                    #genero
     #   #LET g_action_choice = "locale"
     #   #CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
     #   LET g_change_lang = TRUE        #FUN-570127   
     #   EXIT INPUT
 
     #ON IDLE g_idle_seconds
     #   CALL cl_on_idle()
     #   CONTINUE INPUT
 
     #ON ACTION about         #MOD-4C0121
     #   CALL cl_about()      #MOD-4C0121
 
     #ON ACTION help          #MOD-4C0121
     #   CALL cl_show_help()  #MOD-4C0121
 
 
     #ON ACTION exit  #加離開功能genero
     #   LET INT_FLAG = 1
     #   EXIT INPUT
     #No.FUN-D60110 ---Mark--- End
   
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
      ON ACTION CONTROLP           #No.FUN-D60110 Add
 
     #FUN-D60110 ---Mark--- Start
     #   #No.FUN-580031 --start--
     #   ON ACTION qbe_select
     #      CALL cl_qbe_select()
     #   #No.FUN-580031 ---end---
 
     #   #No.FUN-580031 --start--
     #   ON ACTION qbe_save
     #      CALL cl_qbe_save()
     #   #No.FUN-580031 ---end---
     #No.FUN-D60110 ---Mark--- End

 
   END INPUT

   #FUN-D60110 ---Add--- Start
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
      CALL  p110_existno_chk()
      IF g_success = 'N' THEN
         CALL s_showmsg()
         NEXT FIELD g_existno
      END IF

      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(g_existno)
              LET g_existno_str = ''
              CALL q_aba01_1( TRUE, TRUE, p_plant,p_acc,' ','NM')
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
   #FUN-D60110 ---Add--- End
 
#NO.FUN-570127 start--
#   IF g_action_choice = "locale" THEN  #genero
#      LET g_action_choice = ""
#      CALL cl_dynamic_locale()
#      LET g_flag = 'N'
#      RETURN
#   END IF
 
#   IF INT_FLAG THEN
#      RETURN
#   END IF
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         CONTINUE WHILE
      END IF
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p110_w
     #No.FUN-CB0096 ---start--- add
     #LET l_time = TIME   #No.FUN-D60110 Mark
      LET l_time = l_time + 1 #No.FUN-D60110   Add
      LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
      CALL s_log_data('U','100',g_id,'1',l_time,'','')
     #No.FUN-CB0096 ---end  --- add
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
         EXIT PROGRAM
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO lc_cmd FROM zz_file
          WHERE zz01 = "anmp110"
         IF SQLCA.sqlcode or lc_cmd IS NULL THEN
             CALL cl_err('anmp110','9031','1')
         ELSE
            LET lc_cmd = lc_cmd CLIPPED,
                         " '",p_plant CLIPPED,"'",
                         " '",p_acc CLIPPED,"'",
                         " '",g_existno CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'"
            CALL cl_cmdat('anmp110',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW p110_w
     #No.FUN-CB0096 ---start--- add
     #LET l_time = TIME   #No.FUN-D60110 Mark
      LET l_time = l_time + 1 #No.FUN-D60110   Add
      LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
      CALL s_log_data('U','100',g_id,'1',l_time,'','')
     #No.FUN-CB0096 ---end  --- add
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
         EXIT PROGRAM
      END IF
      EXIT WHILE
   END WHILE
#NO.FUN.570127 ---end---
END FUNCTION
 
FUNCTION p110_t()
   DEFINE n1,n2,n3      LIKE type_file.num10  #No.FUN-680107 INTEGER
   DEFINE l_nppsys      LIKE npp_file.nppsys
   DEFINE l_npp00       LIKE npp_file.npp00
   DEFINE max_gxg02     LIKE gxg_file.gxg02
   DEFINE l_gxg01       LIKE gxg_file.gxg01
   DEFINE l_gxg02       LIKE gxg_file.gxg02
   DEFINE l_gxf15       LIKE gxf_file.gxf15   #MOD-560219
   DEFINE l_gxf17       LIKE gxf_file.gxf17   #MOD-560219
   DEFINE l_nme16       LIKE nme_file.nme16   #MOD-CC0035 add 
   DEFINE l_nppglno     LIKE npp_file.nppglno #No.FUN-D60110   Add
 
   #----------------------------------------------------------------------
  #No.FUN-D60110 ---Mod--- Start
  #SELECT UNIQUE npp00 INTO l_npp00 FROM npp_file
  # WHERE nppglno=g_existno AND nppsys = 'NM'
   LET tm.wc1 = cl_replace_str(tm.wc1,"aba01","nppglno")
   LET g_sql = "SELECT UNIQUE npp00,nppglno FROM npp_file",
               " WHERE nppsys = 'NM'",
               "   AND ",tm.wc1
   PREPARE p110_sel_npp001 FROM g_sql
   DECLARE p110_sel_npp00 CURSOR FOR p110_sel_npp001
   FOREACH p110_sel_npp00 INTO l_npp00,l_nppglno
  #No.FUN-D60110 ---Mod--- End
   CASE 
     WHEN l_npp00=4 
          SELECT gxg01,gxg02 INTO l_gxg01,l_gxg02 FROM gxg_file
           WHERE gxg07= l_nppglno  #No.FUN-D60110  Mod  g_existno --> l_nppglno
          SELECT MAX(gxg02) INTO max_gxg02 FROM gxg_file
           WHERE gxg01=l_gxg01  AND gxg09 IS NULL
          IF max_gxg02 != l_gxg02 THEN
             #CALL cl_err(l_gxg02,'anm-631',0)   #CHI-C20017 add
             LET g_success='N' 
             #RETURN  #CHI-C20017 add
             #CHI-C20017--add--str
            #IF g_bgjob = 'Y' THEN   #No.FUN-D60110 mark
                CALL s_errmsg('','',l_gxg02,'anm-631',1)
            #No.FUN-D60110 ---Mark--- Start
            #ELSE
            #   CALL cl_err(l_gxg02,'anm-631',0)
            #   RETURN
            #END IF
            #No.FUN-D60110 ---Mark--- End
             #CHI-C20017--add--end
          END IF
     WHEN l_npp00=5
          SELECT gxg01,gxg02 INTO l_gxg01,l_gxg02 FROM gxg_file
           WHERE gxg07= l_nppglno  #No.FUN-D60110  Mod  g_existno --> l_nppglno
          SELECT MAX(gxg02) INTO max_gxg02 FROM gxg_file
           WHERE gxg07=l_gxg01  AND gxg09 IS NOT NULL
          IF max_gxg02 != l_gxg02 THEN
             #CALL cl_err(l_gxg01,'anm-631',0)   #CHI-C20017 add
             LET g_success='N' 
             #RETURN  #CHI-C20017 add
             #CHI-C20017--add--str
            #IF g_bgjob = 'Y' THEN #No.FUN-D60110 mark
                CALL s_errmsg('','',l_gxg01,'anm-631',1)
            #No.FUN-D60110 ---Mark--- Start
            #ELSE
            #   CALL cl_err(l_gxg01,'anm-631',0)
            #   RETURN
            #END IF
            #No.FUN-D60110 ---Mark--- End
             #CHI-C20017--add--end
          END IF
 #MOD-560219
     WHEN l_npp00=12
          SELECT gxkglno INTO l_gxf15 FROM gxk_file,gxl_file,gxf_file
           WHERE gxk01=gxl01 AND gxl03=gxf011 AND gxk20='2' AND
                 gxf13= l_nppglno  #No.FUN-D60110  Mod  g_existno --> l_nppglno
          IF NOT cl_null(l_gxf15) THEN
             #CALL cl_err('','anm-004',1)   #CHI-C20017 add
             LET g_success='N' 
             #RETURN   #CHI-C20017 add
             #CHI-C20017--add--str
            #IF g_bgjob = 'Y' THEN    #No.FUN-D60110 mark
                CALL s_errmsg('','','','anm-004',1)
            #No.FUN-D60110 ---Mark--- Start
            #ELSE
            #   CALL cl_err('','anm-004',1)
            #   RETURN
            #END IF
            #No.FUN-D60110 ---Mark--- End  
             #CHI-C20017--add--end
          END IF
          SELECT gxg07 INTO l_gxf17 FROM gxg_file,gxf_file
           WHERE gxg011=gxf011 AND gxg021='1' AND gxg03=gxf21 AND
                 gxf13= l_nppglno  #No.FUN-D60110  Mod  g_existno --> l_nppglno
          IF NOT cl_null(l_gxf17) THEN
             #CALL cl_err('','anm-004',1)   #CHI-C20017 add
             LET g_success='N' 
             #RETURN   #CHI-C20017 add
             #CHI-C20017--add--str
            #IF g_bgjob = 'Y' THEN #CHI-C20017 mark
                CALL s_errmsg('','','','anm-004',1)
            #No.FUN-D60110 ---Mark--- Start
            #ELSE
            #   CALL cl_err('','anm-004',1)
            #   RETURN
            #END IF
            #No.FUN-D60110 ---Mark--- End  
             #CHI-C20017--add--end
          END IF
 #END MOD-560219
      #-----MOD-630059---------
      #OTHERWISE 
      #    IF l_npp00<>'11' THEN 
      #        LET g_success='N'                #No.MOD-510037
      #        EXIT CASE
      #    END IF
      #-----END MOD-630059-----
   END CASE
   END FOREACH  #FUN-D60110
   #--------------------------------------------------------------------
   IF g_aaz84 = '2' THEN   #還原方式為作廢 #no.4868
      #FUN-D60110 ---Add--- Start
       LET tm.wc1 = cl_replace_str(tm.wc1,"nppglno","aba01")
      #FUN-D60110 ---Add--- End
      #LET g_sql="UPDATE ",g_dbs_gl CLIPPED," aba_file  SET abaacti = 'N' ",
      LET g_sql="UPDATE ",cl_get_target_table(g_plant_new,'aba_file'), #FUN-A50102
                "   SET abaacti = 'N' ",
               #" WHERE aba01 = ? AND aba00 = ? "     #No.FUN-D60110   Mark
                " WHERE  aba00 = ? ",                  #No.FUN-D60110 Add
                "   AND ",tm.wc1                       #No.FUN-D60110 Add
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
      PREPARE p110_updaba_p FROM g_sql
     #EXECUTE p110_updaba_p USING g_existno,g_nmz.nmz02b   #No.FUN-D60110   Mark
      EXECUTE p110_updaba_p USING g_nmz.nmz02b              #No.FUN-D60110 Add
      IF SQLCA.sqlcode THEN
         #CALL cl_err('(upd abaacti)',SQLCA.sqlcode,1)   #CHI-C20017 add
         LET g_success = 'N' 
         #RETURN   #CHI-C20017 add
         #CHI-C20017--add--str
        #IF g_bgjob = 'Y' THEN   #No.FUN-D60110  Mark
            CALL s_errmsg('','','(upd abaacti)',SQLCA.sqlcode,1)
        #No.FUN-D60110 ---Mark--- Start
        #ELSE
        #   CALL cl_err('(upd abaacti)',SQLCA.sqlcode,1)
        #   RETURN
        #END IF
        #No.FUN-D60110 ---Mark--- End  
         #CHI-C20017--add--end
      END IF
   ELSE
      IF g_bgjob = 'N' THEN   #NO.FUN-570127
          DISPLAY "Delete GL's Voucher body!" AT 1,1 #-------------------------
      END IF

      #FUN-D60110 ---Add--- Start
      IF g_aaz.aaz84 = '1' THEN
         LET tm.wc1 = cl_replace_str(tm.wc1,"nppglno","abb01")
      ELSE
         LET tm.wc1 = cl_replace_str(tm.wc1,"aba01","abb01")
      END IF
      #FUN-D60110 ---Add--- End 

      #LET g_sql="DELETE FROM ",g_dbs_gl CLIPPED,"abb_file WHERE abb01=? AND abb00=?"
      LET g_sql="DELETE FROM ",cl_get_target_table(g_plant_new,'abb_file'), #FUN-A50102
               #" WHERE abb01=? AND abb00=?"     #No.FUN-D60110   Mark
                " WHERE  abb00 = ? ",            #No.FUN-D60110 Add
                "   AND ",tm.wc1                 #No.FUN-D60110 Add
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
      PREPARE p110_2_p3 FROM g_sql
     #EXECUTE p110_2_p3 USING g_existno,g_nmz.nmz02b     #No.FUN-D60110   Mark
      EXECUTE p110_2_p3 USING g_nmz.nmz02b               #No.FUN-D60110 Add
      IF SQLCA.sqlcode THEN
         #CALL cl_err('(del abb)',SQLCA.sqlcode,1)   #CHI-C20017 add
         LET g_success = 'N' 
         #RETURN   #CHI-C20017 add
         #CHI-C20017--add--str
        #IF g_bgjob = 'Y' THEN   #No.FUN-D60110   Mark
            CALL s_errmsg('','','(del abb)',SQLCA.sqlcode,1)
        #No.FUN-D60110 ---Mark--- Start
        #ELSE
        #   CALL cl_err('(del abb)',SQLCA.sqlcode,1)
        #   RETURN
        #END IF
        #No.FUN-D60110 ---Mark--- End  
         #CHI-C20017--add--end
      END IF
      IF g_bgjob = 'N' THEN   #NO.FUN-570127
          DISPLAY "Delete GL's Voucher head!" AT 1,1 #-------------------------
      END IF
      #LET g_sql="DELETE FROM ",g_dbs_gl CLIPPED,"aba_file WHERE aba01=? AND aba00=?"
      LET tm.wc1 = cl_replace_str(tm.wc1,"abb01","aba01")     #No.FUN-D60110 Add
      LET g_sql="DELETE FROM ",cl_get_target_table(g_plant_new,'aba_file'), #FUN-A50102
               #" WHERE aba01=? AND aba00=?"    #No.FUN-D60110   Mark
                " WHERE  aba00 = ? ",            #No.FUN-D60110 Add
                "   AND ",tm.wc1                 #No.FUN-D60110 Add
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
      PREPARE p110_2_p4 FROM g_sql
     #EXECUTE p110_2_p4 USING g_existno,g_nmz.nmz02b    #No.FUN-D60110   Mark
      EXECUTE p110_2_p4 USING g_nmz.nmz02b               #No.FUN-D60110 Add
      IF SQLCA.sqlcode THEN
         #CALL cl_err('(del aba)',SQLCA.sqlcode,1)   #CHI-C20017 add
         LET g_success = 'N' 
         #RETURN   #CHI-C20017 add
         #CHI-C20017--add--str
        #IF g_bgjob = 'Y' THEN #No.FUN-D60110   Mark
            CALL s_errmsg('','','(del aba)',SQLCA.sqlcode,1)
        #No.FUN-D60110 ---Mark--- Start
        #ELSE
        #   CALL cl_err('(del aba)',SQLCA.sqlcode,1)
        #   RETURN
        #END IF
        #No.FUN-D60110 ---Mark--- End  
         #CHI-C20017--add--end
      END IF
      IF SQLCA.sqlerrd[3] = 0 THEN
         #CALL cl_err('(del aba)','aap-161',1)   #CHI-C20017 add
         LET g_success = 'N' 
         #RETURN   #CHI-C20017 add
         #CHI-C20017--add--str
        #IF g_bgjob = 'Y' THEN   #No.FUN-D60110   Mark
            CALL s_errmsg('','','(del aba)','aap-161',1)
        #No.FUN-D60110 ---Mark--- Start
        #ELSE
        #   CALL cl_err('(del aba)','aap-161',1)
        #   RETURN
        #END IF
        #No.FUN-D60110 ---Mark--- End
         #CHI-C20017--add--end
      END IF
      IF g_bgjob = 'N' THEN   #NO.FUN-570127
          DISPLAY "Delete GL's Voucher desp!" AT 1,1 #-------------------------
      END IF
      #LET g_sql="DELETE FROM ",g_dbs_gl CLIPPED,"abc_file WHERE abc01=? AND abc00=?"
      LET tm.wc1 = cl_replace_str(tm.wc1,"aba01","abc01")     #No.FUN-D60110 Add
      LET g_sql="DELETE FROM ",cl_get_target_table(g_plant_new,'abc_file'), #FUN-A50102
               #" WHERE abc01=? AND abc00=?"    #FUN-A50102  #No.FUN-D60110   Mark
                " WHERE  abc00=?",               #No.FUN-D60110 Add
                "   AND ",tm.wc1                 #No.FUN-D60110 Add
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
      PREPARE p110_2_p5 FROM g_sql
     #EXECUTE p110_2_p5 USING g_existno,g_nmz.nmz02b   #No.FUN-D60110   Mark
      EXECUTE p110_2_p5 USING g_nmz.nmz02b              #No.FUN-D60110 Add
      IF SQLCA.sqlcode THEN
         #CALL cl_err('(del abc)',SQLCA.sqlcode,1)   #CHI-C20017 add
         LET g_success = 'N' 
         #RETURN   #CHI-C20017 add
         #CHI-C20017--add--str
        #IF g_bgjob = 'Y' THEN   #No.FUN-D60110   Mark
            CALL s_errmsg('','','(del abc)',SQLCA.sqlcode,1)
        #No.FUN-D60110 ---Mark--- Start
        #ELSE
        #   CALL cl_err('(del abc)',SQLCA.sqlcode,1)
        #   RETURN
        #END IF
        #No.FUN-D60110 ---Mark--- End  
         #CHI-C20017--add--end
      END IF
#FUN-B40056 -begin
      LET tm.wc1 = cl_replace_str(tm.wc1,"abc01","tic04")     #No.FUN-D60110 Add
      LET g_sql="DELETE FROM ",cl_get_target_table(g_plant_new,'tic_file'), #FUN-A50102
               #" WHERE tic04=? AND tic00=?"  #No.FUN-D60110   Mark
                " WHERE  tic00 =?",              #No.FUN-D60110 Add
                "   AND ",tm.wc1                 #No.FUN-D60110 Add
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
      PREPARE p110_2_p8 FROM g_sql
     #EXECUTE p110_2_p8 USING g_existno,g_nmz.nmz02b   #No.FUN-D60110   Mark
      EXECUTE p110_2_p8 USING g_nmz.nmz02b              #No.FUN-D60110 Add
      IF SQLCA.sqlcode THEN
         #CALL cl_err('(del tic)',SQLCA.sqlcode,1)   #CHI-C20017 add
         LET g_success = 'N' 
         #RETURN   #CHI-C20017 add
         #CHI-C20017--add--str
        #IF g_bgjob = 'Y' THEN    #No.FUN-D60110   Mark
            CALL s_errmsg('','','(del tic)',SQLCA.sqlcode,1)
        #No.FUN-D60110 ---Mark--- Start
        #ELSE
        #   CALL cl_err('(del tic)',SQLCA.sqlcode,1)
        #   RETURN
        #END IF
        #No.FUN-D60110 ---Mark--- End
         #CHI-C20017--add--end
      END IF
#FUN-B40056 -end
   END IF
#  CALL s_abhmod(g_dbs_gl,g_nmz.nmz02b,g_existno)   #MOD-590081   #CHI-780008 #FUN-980020 mark
   CALL s_abhmod(p_plant,g_nmz.nmz02b,g_existno)    #FUN-980020
   IF g_success = 'N' THEN RETURN END IF
   LET g_msg = TIME
   INSERT INTO azo_file (azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)          #FUN-980005 add plant & legal 
                  VALUES('anmp110',g_user,g_today,g_msg,g_existno,'delete',g_plant,g_legal)
   FOREACH p110_sel_npp00 INTO l_npp00,l_nppglno   #No.FUN-D60110   Add
   CASE
     WHEN l_npp00=4                      #質押
          UPDATE gxg_file set gxg07=NULL,gxg08=NULL WHERE gxg07=l_nppglno  #No.FUN-D60110  Mod g_existno  --> l_nppglno
          IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
#            CALL cl_err('upd gxg07,gxg03',STATUS,1)    #No.FUN-660148
             #CALL cl_err3("upd","gxg_file",g_existno,"",STATUS,"","upd gxg07,gxg03",1) #No.FUN-660148 #CHI-C20017 add
             LET g_success='N' 
             #RETURN   #CHI-C20017 add
             #CHI-C20017--add--str
            #IF g_bgjob = 'Y' THEN  #FUN-D60110
                CALL s_errmsg('','','(upd gxg07,gxg03)',STATUS,1)
            #No.FUN-D60110 ---Mark--- Start
            #ELSE
            #   CALL cl_err3("upd","gxg_file",g_existno,"",STATUS,"","upd gxg07,gxg03",1)
            #   RETURN
            #END IF
            #No.FUN-D60110 ---Mark--- End
             #CHI-C20017--add--end
          END IF
          #-----MOD-680013---------
          UPDATE gxf_file SET gxf17=NULL,gxf18=NULL WHERE gxf17=g_existno
          #IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
#         #   CALL cl_err('upd gxf17,gxf18',STATUS,1)    #No.FUN-660148
          #   CALL cl_err3("upd","gxf_file",g_existno,"",STATUS,"","upd gxf17,gxf18",1) #No.FUN-660148
          #   LET g_success='N' RETURN
          #END IF
          #-----END MOD-680013-----
     WHEN l_npp00=5                        #解除質押
          UPDATE gxg_file set gxg10=NULL,gxg11=NULL WHERE gxg10= l_nppglno  #No.FUN-D60110  Mod g_existno  --> l_nppglno
          IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
#            CALL cl_err('upd gxg10,gxg11',STATUS,1)    #No.FUN-660148
             #CALL cl_err3("upd","gxg_file",g_existno,"",STATUS,"","upd gxg10,gxg11",1) #No.FUN-660148 #CHI-C20017 add
             LET g_success='N' 
             #RETURN  #CHI-C20017 add
             #CHI-C20017--add--str
            #IF g_bgjob = 'Y' THEN     #No.FUN-D60110 mark
                CALL s_errmsg('','','(upd gxg10,gxg11)',STATUS,1)
            #No.FUN-D60110 ---Mark--- Start
            #ELSE
            #   CALL cl_err3("upd","gxg_file",g_existno,"",STATUS,"","upd gxg10,gxg11",1)
            #   RETURN
            #END IF
            #No.FUN-D60110 ---Mark--- End
             #CHI-C20017--add--end
          END IF
          #-----MOD-680013---------
          UPDATE gxf_file SET gxf19=NULL,gxf20=NULL WHERE gxf19= l_nppglno  #No.FUN-D60110  Mod g_existno  --> l_nppglno
          #IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
#         #   CALL cl_err('upd gxf19,gxf20',STATUS,1)   #No.FUN-660148
          #   CALL cl_err3("upd","gxf_file",g_existno,"",STATUS,"","upd gxf19",1) #No.FUN-660148
          #   LET g_success='N' RETURN 
          #END IF
          #-----END MOD-680013-----
     WHEN l_npp00=8                         #交割 
         #--------------------------MOD-CC0035-------------------(S)
          SELECT gxe04 INTO l_nme16 FROM gxe_file
           WHERE gxe14 = g_existno
          IF cl_null(l_nme16) THEN LET l_nme16 = ' ' END IF
         #--------------------------MOD-CC0035-------------------(E)
          UPDATE gxe_file SET gxe14 = NULL,gxe141=NULL WHERE gxe14= l_nppglno  #No.FUN-D60110  Mod g_existno  --> l_nppglno
          IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
#            CALL cl_err('(upd gxe14)',STATUS,1)    #No.FUN-660148
             #CALL cl_err3("upd","gxe_file",g_existno,"",STATUS,"","upd gxe14",1) #No.FUN-660148 #CHI-C20017 add
             LET g_success='N' 
             #RETURN   #CHI-C20017 add
             #CHI-C20017--add--str
            #IF g_bgjob = 'Y' THEN   #No.FUN-D60110 mark
                CALL s_errmsg('','','(upd gxe14)',STATUS,1)
            #No.FUN-D60110 ---Mark--- Start
            #ELSE
            #   CALL cl_err3("upd","gxe_file",g_existno,"",STATUS,"","upd gxe14",1)
            #   RETURN
            #END IF
            #No.FUN-D60110 ---Mark--- End
             #CHI-C20017--add--end
         #--------------------------MOD-CC0035-------------------(S)
          ELSE
             UPDATE nme_file SET nme10 = NULL ,nme16 = l_nme16
              WHERE nme10 =  l_nppglno  #No.FUN-D60110  Mod g_existno  --> l_nppglno
              IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
                 LET g_success='N'
                #IF g_bgjob = 'Y' THEN   #No.FUN-D60110 mark
                    CALL s_errmsg('','','(upd nme10)',STATUS,1)
                #No.FUN-D60110 ---Mark--- Start
                #ELSE
                #   CALL cl_err3("upd","nme_file",g_existno,"",STATUS,"","upd nme10",1)
                #   RETURN
                #END IF
                #No.FUN-D60110 ---Mark--- End  
              END IF
         #--------------------------MOD-CC0035-------------------(E)
          END IF
     WHEN l_npp00=9                          #交易
          UPDATE gxc_file SET gxc14 = NULL,gxc141=NULL WHERE gxc14= l_nppglno  #No.FUN-D60110  Mod g_existno  --> l_nppglno
          IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
#            CALL cl_err('(upd gxc14)',STATUS,1)   #No.FUN-660148
             #CALL cl_err3("upd","gxc_file",g_existno,"",STATUS,"","upd gxc14",1) #No.FUN-660148 #CHI-C20017 add
             LET g_success='N' 
             #RETURN   #CHI-C20017 add
             #CHI-C20017--add--str
            #IF g_bgjob = 'Y' THEN   #No.FUN-D60110 mark
                CALL s_errmsg('','','(upd gxc14)',STATUS,1)
            #No.FUN-D60110 ---Mark--- Start
            #ELSE
            #   CALL cl_err3("upd","gxc_file",g_existno,"",STATUS,"","upd gxc14",1)
            #   RETURN
            #END IF
            #No.FUN-D60110 ---Mark--- End
             #CHI-C20017--add--end
          END IF
     #### polly.s
     WHEN l_npp00=10                          #收款
         #--------------------------MOD-CC0035-------------------(S)
          SELECT gxi02 INTO l_nme16 FROM gxi_file
           WHERE gxiglno =  l_nppglno  #No.FUN-D60110  Mod g_existno  --> l_nppglno
          IF cl_null(l_nme16) THEN LET l_nme16 = ' ' END IF
         #--------------------------MOD-CC0035-------------------(E)
          UPDATE gxi_file SET gxiglno = NULL,gxi25=NULL WHERE gxiglno=g_existno
          IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
#            CALL cl_err('(upd gxiglno)',STATUS,1)   #No.FUN-660148
             #CALL cl_err3("upd","gxi_file",g_existno,"",STATUS,"","upd gxiglno",1) #No.FUN-660148 #CHI-C20017 add
             LET g_success='N' 
             #RETURN   #CHI-C20017 add
             #CHI-C20017--add--str
            #IF g_bgjob = 'Y' THEN   #No.FUN-D60110 mark
                CALL s_errmsg('','','(upd gxiglno)',STATUS,1)
            #No.FUN-D60110 ---Mark--- Start
            #ELSE
            #   CALL cl_err3("upd","gxi_file",g_existno,"",STATUS,"","upd gxiglno",1)
            #   RETURN
            #END IF
            #No.FUN-D60110 ---Mark--- End
             #CHI-C20017--add--end
         #--------------------------MOD-CC0035-------------------(S)
          ELSE
             UPDATE nme_file SET nme10 = NULL ,nme16 = l_nme16
              WHERE nme10 =  l_nppglno  #No.FUN-D60110  Mod g_existno  --> l_nppglno
              IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
                 LET g_success='N'
                #IF g_bgjob = 'Y' THEN   #No.FUN-D60110 mark
                    CALL s_errmsg('','','(upd nme10)',STATUS,1)
                #No.FUN-D60110 ---Mark--- Start
                #ELSE
                #   CALL cl_err3("upd","nme_file",g_existno,"",STATUS,"","upd nme10",1)
                #   RETURN
                #END IF
                #No.FUN-D60110 ---Mark--- End
              END IF
         #--------------------------MOD-CC0035-------------------(E)
          END IF
     WHEN l_npp00=11                          #收款
         #--------------------------MOD-CC0035-------------------(S)
          SELECT gxk02 INTO l_nme16 FROM gxk_file
           WHERE gxkglno =  l_nppglno  #No.FUN-D60110  Mod g_existno  --> l_nppglno
          IF cl_null(l_nme16) THEN LET l_nme16 = ' ' END IF
         #--------------------------MOD-CC0035-------------------(E)
          UPDATE gxk_file SET gxkglno = NULL,gxk30=NULL WHERE gxkglno= l_nppglno  #No.FUN-D60110  Mod g_existno  --> l_nppglno
          IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
#            CALL cl_err('(upd gxkglno)',STATUS,1)   #No.FUN-660148
             #CALL cl_err3("upd","gxk_file",g_existno,"",STATUS,"","upd gxklno",1) #No.FUN-660148 #CHI-C20017 add
             LET g_success='N' 
             #RETURN   #CHI-C20017 add
             #CHI-C20017--add--str
            #IF g_bgjob = 'Y' THEN  #No.FUN-D60110 mark
                CALL s_errmsg('','','(upd gxklno)',STATUS,1)
            #No.FUN-D60110 ---Mark--- Start
            #ELSE
            #   CALL cl_err3("upd","gxk_file",g_existno,"",STATUS,"","upd gxklno",1)
            #   RETURN
            #END IF
            #No.FUN-D60110 ---Mark--- End
             #CHI-C20017--add--end
         #--------------------------MOD-CC0035-------------------(S)
          ELSE
             UPDATE nme_file SET nme10 = NULL ,nme16 = l_nme16
              WHERE nme10 = l_nppglno  #No.FUN-D60110  Mod g_existno  --> l_nppglno
              IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
                 LET g_success='N'
                #IF g_bgjob = 'Y' THEN    #No.FUN-D60110 mark
                    CALL s_errmsg('','','(upd nme10)',STATUS,1)
                #No.FUN-D60110 ---Mark--- Start
                #ELSE
                #   CALL cl_err3("upd","nme_file",g_existno,"",STATUS,"","upd nme10",1)
                #   RETURN
                #END IF
                #No.FUN-D60110 ---Mark--- End
              END IF
         #--------------------------MOD-CC0035-------------------(E)
          END IF
          UPDATE gxf_file SET gxf29 = NULL,gxf30=NULL WHERE gxf29= l_nppglno  #No.FUN-D60110  Mod g_existno  --> l_nppglno
          IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
#            CALL cl_err('(upd gxf29)',STATUS,1)   #No.FUN-660148
             #CALL cl_err3("upd","gxf_file",g_existno,"",STATUS,"","upd gxf29",1) #No.FUN-660148 #CHI-C20017 add
             LET g_success='N' 
             #RETURN   #CHI-C20017 add
             #CHI-C20017--add--str
            #IF g_bgjob = 'Y' THEN  #No.FUN-D60110 mark
                CALL s_errmsg('','','(upd gxf29)',STATUS,1)
            #No.FUN-D60110 ---Mark--- Start
            #ELSE
            #   CALL cl_err3("upd","gxf_file",g_existno,"",STATUS,"","upd gxf29",1)
            #   RETURN
            #END IF
            #No.FUN-D60110 ---Mark--- End
             #CHI-C20017--add--end
          END IF
     WHEN l_npp00=12                          #收款
         #--------------------------MOD-CC0035-------------------(S)
          SELECT gxf03 INTO l_nme16 FROM gxf_file
           WHERE gxf29 =  l_nppglno  #No.FUN-D60110  Mod g_existno  --> l_nppglno
          IF cl_null(l_nme16) THEN LET l_nme16 = ' ' END IF
         #--------------------------MOD-CC0035-------------------(E)
          UPDATE gxf_file SET gxf13 = NULL,gxf14=NULL WHERE gxf13=g_existno
          IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
#            CALL cl_err('(upd gxf13)',STATUS,1)    #No.FUN-660148
             #CALL cl_err3("upd","gxf_file",g_existno,"",STATUS,"","upd gxf13",1) #No.FUN-660148 #CHI-C20017 add
             LET g_success='N'
             #RETURN  #CHI-C20017 add
             #CHI-C20017--add--str
            #IF g_bgjob = 'Y' THEN  #No.FUN-D60110 mark
                CALL s_errmsg('','','(upd gxf13)',STATUS,1)
            #No.FUN-D60110 ---Mark--- Start
            #ELSE
            #   CALL cl_err3("upd","gxf_file",g_existno,"",STATUS,"","upd gxf13",1)
            #   RETURN
            #END IF
            #No.FUN-D60110 ---Mark--- End
             #CHI-C20017--add--end
         #--------------------------MOD-CC0035-------------------(S)
          ELSE
             UPDATE nme_file SET nme10 = NULL ,nme16 = l_nme16
              WHERE nme10 =  l_nppglno  #No.FUN-D60110  Mod g_existno  --> l_nppglno
              IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
                 LET g_success='N'
                #IF g_bgjob = 'Y' THEN  #No.FUN-D60110 mark
                    CALL s_errmsg('','','(upd nme10)',STATUS,1)
                #No.FUN-D60110 ---Mark--- Start
                #ELSE
                #   CALL cl_err3("upd","nme_file",g_existno,"",STATUS,"","upd nme10",1)
                #   RETURN
                #END IF
                #No.FUN-D60110 ---Mark--- Start
              END IF
         #--------------------------MOD-CC0035-------------------(E)
          END IF
     #### polly.end
 
    #-----MOD-640499---------
    WHEN l_npp00=24
         UPDATE gxh_file SET gxhglno = NULL
              WHERE gxhglno =  l_nppglno  #No.FUN-D60110  Mod g_existno  --> l_nppglno
         IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
#           CALL cl_err('(upd gxf13)',STATUS,1)    #No.FUN-660148
            #CALL cl_err3("upd","gxh_file",g_existno,"",STATUS,"","upd gxf13",1) #No.FUN-660148 #CHI-C20017 add
            LET g_success='N' 
            #RETURN   #CHI-C20017 add
            #CHI-C20017--add--str
           #IF g_bgjob = 'Y' THEN   #No.FUN-D60110 mark
               CALL s_errmsg('','','(upd gxf13)',STATUS,1)
           #No.FUN-D60110 ---Mark--- Start
           #ELSE
           #   CALL cl_err3("upd","gxh_file",g_existno,"",STATUS,"","upd gxf13",1)
           #   RETURN
           #END IF
           #No.FUN-D60110 ---Mark--- End
            #CHI-C20017--add--end
         END IF
    #-----END MOD-640499-----
 
      OTHERWISE LET g_success='N'                #No.MOD-510037
               EXIT CASE
   END CASE
   #----------------------------------------------------------------------
   UPDATE npp_file SET npp03 = NULL ,nppglno = NULL ,npp06 = NULL ,npp07 = NULL
    WHERE nppglno=l_nppglno  #No.FUN-D60110  Mod g_existno  --> l_nppglno
      AND nppsys = 'NM'
      AND npptype = '0' AND npp07=g_nmz.nmz02b  #FUN-680088
   IF STATUS THEN
#     CALL cl_err('(upd npp)',STATUS,1)   #No.FUN-660148
      #CALL cl_err3("upd","npp_file",g_existno,"",STATUS,"","upd npp",1) #No.FUN-660148  #CHI-C20017 add
      LET g_success='N' 
      #RETURN   #CHI-C20017 add
      #CHI-C20017--add--str
     #IF g_bgjob = 'Y' THEN  #No.FUN-D60110 mark
                CALL s_errmsg('','','(upd npp)',STATUS,1)
     #No.FUN-D60110 ---Mark--- Start
     #ELSE
     #   CALL cl_err3("upd","npp_file",g_existno,"",STATUS,"","upd npp",1)
     #   RETURN
     #END IF
     #No.FUN-D60110 ---Mark--- End
      #CHI-C20017--add--end
   END IF
  #No.FUN-CB0096 ---start--- Add
  #LET l_time = TIME    #No.FUN-D60110 Mark
   LET l_time = l_time + 1 #No.FUN-D60110   Add
   LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
   CALL s_log_data('I','114',g_id,'2',l_time,g_existno,'')
  #No.FUN-CB0096 ---end  --- Add
   END FOREACH   #No.FUN-D60110   Add
END FUNCTION
 
#FUN-680088  --begin
FUNCTION p110_t_1()
   DEFINE n1,n2,n3      LIKE type_file.num10  #No.FUN-680107 INTEGER
   DEFINE l_nppsys      LIKE npp_file.nppsys
   DEFINE l_npp00       LIKE npp_file.npp00
   DEFINE max_gxg02     LIKE gxg_file.gxg02
   DEFINE l_gxg01       LIKE gxg_file.gxg01
   DEFINE l_gxg02       LIKE gxg_file.gxg02
   DEFINE l_gxf15       LIKE gxf_file.gxf15   #MOD-560219
   DEFINE l_gxf17       LIKE gxf_file.gxf17   #MOD-560219
 
   LET tm.wc1 = "aba01 IN (",g_existno1_str,")"    #No.FUN-D60110   Add 

   #----------------------------------------------------------------------
   IF g_aaz84 = '2' THEN   #還原方式為作廢 #no.4868
      #LET g_sql="UPDATE ",g_dbs_gl CLIPPED," aba_file  SET abaacti = 'N' ",
      LET g_sql="UPDATE ",cl_get_target_table(g_plant_new,'aba_file'), #FUN-A50102
                "   SET abaacti = 'N' ",
               #" WHERE aba01 = ? AND aba00 = ? "        #No.FUN-D60110   Mark
                 " WHERE  aba00 = ? ",                     #No.FUN-D60110   Add
                 "   AND ",tm.wc1                          #No.FUN-D60110   Add
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
      PREPARE p110_updaba_p1 FROM g_sql
     #EXECUTE p110_updaba_p1 USING g_existno1,g_nmz.nmz02c #FUN-680088     #No.FUN-D60110   Mark
      EXECUTE p110_updaba_p1 USING g_nmz.nmz02c    #No.FUN-D60110 Add
      IF SQLCA.sqlcode THEN
         #CALL cl_err('(upd abaacti)',SQLCA.sqlcode,1)   #CHI-C20017 add
         LET g_success = 'N' 
         #RETURN  #CHI-C20017 add
         #CHI-C20017--add--str
        #IF g_bgjob = 'Y' THEN  #No.FUN-D60110   Mark
            CALL s_errmsg('','','(upd abaacti)',SQLCA.sqlcode,1) 
        #No.FUN-D60110 ---Mark--- Start
        #ELSE
        #   CALL cl_err('(upd abaacti)',SQLCA.sqlcode,1)
        #   RETURN
        #END IF
        #No.FUN-D60110 ---Mark--- Start
         #CHI-C20017--add--end
      END IF
   ELSE
      IF g_bgjob = 'N' THEN   #NO.FUN-570127
          DISPLAY "Delete GL's Voucher body!" AT 1,1 #-------------------------
      END IF

      LET tm.wc1 = cl_replace_str(tm.wc1,"aba01","abb01")          #No.FUN-D60110   Add 

      #LET g_sql="DELETE FROM ",g_dbs_gl CLIPPED,"abb_file WHERE abb01=? AND abb00=?"
      LET g_sql="DELETE FROM ",cl_get_target_table(g_plant_new,'abb_file'), #FUN-A50102
               #" WHERE abb01=? AND abb00=?"     #No.FUN-D60110   Mark
                " WHERE  abb00=?",                #No.FUN-D60110   Add
                "   AND ",tm.wc1                  #No.FUN-D60110   Add
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
      PREPARE p110_2_p31 FROM g_sql
     #EXECUTE p110_2_p31 USING g_existno1,g_nmz.nmz02c #FUN-680088   #No.FUN-D60110   Mark
      EXECUTE p110_2_p31 USING g_nmz.nmz02c    #No.FUN-D60110   Add
      IF SQLCA.sqlcode THEN
         #CALL cl_err('(del abb)',SQLCA.sqlcode,1)   #CHI-C20017 add
         LET g_success = 'N' 
         #RETURN   #CHI-C20017 add
         #CHI-C20017--add--str
        #IF g_bgjob = 'Y' THEN     #No.FUN-D60110   Mark
            CALL s_errmsg('','','(del abb)',SQLCA.sqlcode,1)
        #No.FUN-D60110 ---Mark--- Start
        #ELSE
        #   CALL cl_err('(del abb)',SQLCA.sqlcode,1)
        #   RETURN
        #END IF
        #No.FUN-D60110 ---Mark--- End
         #CHI-C20017--add--end
      END IF
      IF g_bgjob = 'N' THEN   #NO.FUN-570127
          DISPLAY "Delete GL's Voucher head!" AT 1,1 #-------------------------
      END IF

      LET tm.wc1 = cl_replace_str(tm.wc1,"abb01","aba01")          #No.FUN-D60110   Add

      #LET g_sql="DELETE FROM ",g_dbs_gl CLIPPED,"aba_file WHERE aba01=? AND aba00=?"
      LET g_sql="DELETE FROM ",cl_get_target_table(g_plant_new,'aba_file'), #FUN-A50102
               #" WHERE aba01=? AND aba00=?"       #No.FUN-D60110 Mark
                " WHERE aba00=?",               #No.FUN-D60110   Mark
                "   AND ",tm.wc1                 #No.FUN-D60110   Add
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
      PREPARE p110_2_p41 FROM g_sql
     #EXECUTE p110_2_p41 USING g_existno1,g_nmz.nmz02c #FUN-680088    #No.FUN-D60110   Mark
      EXECUTE p110_2_p41 USING g_nmz.nmz02c           #No.FUN-D60110   Add
      IF SQLCA.sqlcode THEN
         #CALL cl_err('(del aba)',SQLCA.sqlcode,1)   #CHI-C20017 add
         LET g_success = 'N' 
         #RETURN   #CHI-C20017 add
         #CHI-C20017--add--str
        #IF g_bgjob = 'Y' THEN  #No.FUN-D60110   Mark
            CALL s_errmsg('','','(del aba)',SQLCA.sqlcode,1)
        #No.FUN-D60110 ---Mark--- Start
        #ELSE
        #   CALL cl_err('(del aba)',SQLCA.sqlcode,1)
        #   RETURN
        #END IF
        #No.FUN-D60110 ---Mark--- End
         #CHI-C20017--add--end
      END IF
      IF SQLCA.sqlerrd[3] = 0 THEN
         #CALL cl_err('(del aba)','aap-161',1)   #CHI-C20017 add
         LET g_success = 'N' 
         #RETURN   #CHI-C20017 add
         #CHI-C20017--add--str
        #IF g_bgjob = 'Y' THEN   #No.FUN-D60110   Mark
            CALL s_errmsg('','','(del aba)','aap-161',1)
        #No.FUN-D60110 ---Mark--- Start
        #ELSE
        #   CALL cl_err('(del aba)','aap-161',1)
        #   RETURN
        #END IF
        #No.FUN-D60110 ---Mark--- End
         #CHI-C20017--add--end
      END IF
      IF g_bgjob = 'N' THEN   #NO.FUN-570127
          DISPLAY "Delete GL's Voucher desp!" AT 1,1 #-------------------------
      END IF

      LET tm.wc1 = cl_replace_str(tm.wc1,"aba01","abc01")   #No.FUN-D60110   Add

      #LET g_sql="DELETE FROM ",g_dbs_gl CLIPPED,"abc_file WHERE abc01=? AND abc00=?"
      LET g_sql="DELETE FROM ",cl_get_target_table(g_plant_new,'abc_file'), #FUN-A50102
               #" WHERE abc01=? AND abc00=?"    #No.FUN-D60110   Mark
                " WHERE  abc00=?",              #No.FUN-D60110   Add
                "   AND ",tm.wc1                #No.FUN-D60110   Add
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
      PREPARE p110_2_p51 FROM g_sql
     #EXECUTE p110_2_p51 USING g_existno1,g_nmz.nmz02c #FUN-680088    #No.FUN-D60110   Mark
      EXECUTE p110_2_p51 USING g_nmz.nmz02c          #No.FUN_D60110   Add
      IF SQLCA.sqlcode THEN
         #CALL cl_err('(del abc)',SQLCA.sqlcode,1)   #CHI-C20017 add
         LET g_success = 'N' 
         #RETURN   #CHI-C20017 add
         #CHI-C20017--add--str
        #IF g_bgjob = 'Y' THEN
            CALL s_errmsg('','','(del abc)',SQLCA.sqlcode,1)
        #No.FUN-D60110 ---Mark--- Start
        #ELSE
        #   CALL cl_err('(del abc)',SQLCA.sqlcode,1)
        #   RETURN
        #END IF
        #No.FUN-D60110 ---Mark--- End
         #CHI-C20017--add--end
      END IF
#FUN-B40056  -begin

      LET tm.wc1 = cl_replace_str(tm.wc1,"abc01","tic04")          #No.FUN-D60110   Add

      LET g_sql="DELETE FROM ",cl_get_target_table(g_plant_new,'tic_file'), #FUN-A50102
               #" WHERE tic04=? AND tic00=?"   #No.FUN-D60110   Mark
                " WHERE tic00 =?",              #No.FUN-D60110   Add
                "   AND ",tm.wc1                #No.FUN-D60110   Add
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
      PREPARE p110_2_p81 FROM g_sql
     #EXECUTE p110_2_p81 USING g_existno1,g_nmz.nmz02c #FUN-680088   #No.FUN-D60110   Mark
      EXECUTE p110_2_p81 USING g_nmz.nmz02c  #No.FUN-D60110   Add
      IF SQLCA.sqlcode THEN
         #CALL cl_err('(del tic)',SQLCA.sqlcode,1)   #CHI-C20017 add
         LET g_success = 'N' 
         #RETURN   #CHI-C20017 add
         #CHI-C20017--add--str
        #IF g_bgjob = 'Y' THEN
            CALL s_errmsg('','','(del tic)',SQLCA.sqlcode,1)
        #No.FUN-D60110 ---Mark--- Start
        #ELSE
        #   CALL cl_err('(del tic)',SQLCA.sqlcode,1)
        #   RETURN
        #END IF
        #No.FUN-D60110 ---Mark--- End
         #CHI-C20017--add--end
      END IF
#FUN-B40056  -end
   END IF
#  CALL s_abhmod(g_dbs_gl,g_nmz.nmz02c,g_existno1)    #MOD-590081   #CHI-780008 #FUN-980020 mark
   CALL s_abhmod(p_plant,g_nmz.nmz02c,g_existno1)     #FUN-980020
   IF g_success = 'N' THEN RETURN END IF
   LET g_msg = TIME
   INSERT INTO azo_file (azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)          #FUN-980005 add plant & legal 
                  VALUES('anmp110',g_user,g_today,g_msg,g_existno1,'delete',g_plant,g_legal)
   #----------------------------------------------------------------------
  #No.FUN-D60110 ---Mark--- Start
  #UPDATE npp_file SET (npp03,nppglno,npp06,npp07)=(NULL,NULL,NULL,NULL) 
  # WHERE nppglno=g_existno1  AND nppsys = 'NM'
  #   AND npptype = '1' AND npp07=g_nmz.nmz02c  #FUN-680088
  #No.FUN-D60110 ---Mark--- End

  #No.FUN-D60110 ---Add--- Start
   IF g_aaz84 = '2' THEN
      LET tm.wc1 = cl_replace_str(tm.wc1,"aba01","nppglno")
   ELSE
      LET tm.wc1 = cl_replace_str(tm.wc1,"tic04","nppglno")
   END IF
   LET g_sql = "UPDATE npp_file SET npp03= NULL,nppglno = NULL,npp06 = NULL,npp07 = NULL",
               " WHERE ",tm.wc1,
               "   AND npptype = '1' ",
               "   AND npp07 ='",g_nmz.nmz02c,"'"
   PREPARE p110_2_p9 FROM g_sql
   EXECUTE p110_2_p9
  #No.FUN-D60110 ---Add--- End

   IF STATUS THEN
#     CALL cl_err('(upd npp)',STATUS,1)   #No.FUN-660148
      #CALL cl_err3("upd","npp_file",g_existno1,"",STATUS,"","upd npp",1) #No.FUN-660148 #CHI-C20017 add
      LET g_success='N' 
      #RETURN   #CHI-C20017 add
      #CHI-C20017--add--str
     #IF g_bgjob = 'Y' THEN
         CALL s_errmsg('','','(upd npp)',STATUS,1)
     #No.FUN-D60110 ---Mark--- Start
     #ELSE
     #   CALL cl_err3("upd","npp_file",g_existno1,"",STATUS,"","upd npp",1)
     #   RETURN
     #END IF
     #No.FUN-D60110 ---Mark--- End
      #CHI-C20017--add--end
   END IF
  #No.FUN-CB0096 ---start--- Add
  #LET l_time = TIME   #No.FUN-D60110 Mark
   LET l_time = l_time + 1 #No.FUN-D60110   Add
   LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
   CALL s_log_data('I','114',g_id,'2',l_time,g_existno,'')
  #No.FUN-CB0096 ---end  --- Add
END FUNCTION
#FUN-680088  --end  

#FUN-D60110 ---Add--- Start
FUNCTION p110_existno_chk()
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

   CALL s_showmsg_init()
   LET g_existno1 = NULL
   LET g_success = 'Y'
   LET tm.wc1 = cl_replace_str(tm.wc1,"g_existno","aba01")
   LET g_sql="SELECT aba02,aba03,aba04,aba19,abapost,abaacti,aba20,aba01,aba06 ",   #MOD-G30031 add aba06 
             " FROM ",cl_get_target_table(g_plant_new,'aba_file'),
            #" WHERE aba00 = ? AND aba06='NM'" CLIPPED,   #MOD-G30031 mark
             " WHERE aba00 = ? " CLIPPED,                 #MOD-G30031 add
             "   AND ",tm.wc1
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
   PREPARE p110_t_p1 FROM g_sql
   DECLARE p110_t_c1 CURSOR FOR p110_t_p1
   IF STATUS THEN
      CALL cl_err('decl aba_cursor:',STATUS,0)
      LET g_success = 'N'
   END IF
   FOREACH p110_t_c1 USING g_nmz.nmz02b INTO gl_date,  gl_yy,    gl_mm,  l_aba19,
                                             l_abapost,l_abaacti,l_aba20,l_aba01   #No.TQC-D60072   Add l_aba01
                                            ,l_aba06   #MOD-G30031 add 
      IF STATUS THEN
         CALL s_errmsg('sel aba:',l_aba01,'',STATUS,1)
         LET g_success = 'N'
      END IF
      IF l_abaacti = 'N' THEN
         CALL s_errmsg('',l_aba01,'','mfg8001',1)
         LET g_success = 'N'
      END IF
      IF l_aba20 MATCHES '[Ss1]' THEN
         CALL s_errmsg('',l_aba01,'','mfg3557',1)
         LET g_success = 'N'
      END IF
     #MOD-G30031---add---str--
      IF l_aba06 <> 'NM' THEN
         CALL s_errmsg('sel aba:',l_aba01,'','agl040',1)
         LET g_success = 'N'
      END IF
     #MOD-G30031---add---end--
      IF l_abapost = 'Y' THEN
         CALL s_errmsg('',l_aba01,'','aap-130',1)
         LET g_success = 'N'
      END IF
      IF l_aba19 = 'Y' THEN
         CALL s_errmsg('',l_aba01,'','anm-114',1)
         LET g_success = 'N'
      END IF
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM npp_file
       WHERE nppglno = l_aba01
         AND npp00 IN ('1','2','3','6','7','16','17','18','19','20')
      IF l_cnt > 0 THEN
         CALL s_errmsg('',l_aba01,'','anm-708',1)
         LET g_success = 'N'
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
      PREPARE p110_pre_chk1 FROM g_sql
      DECLARE p110_c_chk1 CURSOR FOR p110_pre_chk1
      FOREACH p110_c_chk1 INTO l_npp07,l_nppglno
         IF cl_null(l_npp07) OR cl_null(l_nppglno) THEN
            CALL s_errmsg('',l_nppglno,'','aap-986',1)   #No.TQC-D60072   Mod l_aba01 --> l_nppglno
            LET g_success = 'N'
         END IF
         LET g_sql="SELECT aba01,aba00,aba02,aba03,aba04,abapost,aba19,abaacti,aba20 FROM ",
                   cl_get_target_table(p_plant,'aba_file'),
                   " WHERE aba01 = ? AND aba00 = ? AND aba06='AP'" CLIPPED
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql
         CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql
         PREPARE p110_t_p1_2 FROM g_sql
         DECLARE p110_t_c1_2 CURSOR FOR p110_t_p1_2
         FOREACH p110_t_c1_2 USING l_nppglno,l_npp07 INTO gl_date,gl_yy,gl_mm,l_aba19,l_abapost,
                                                          l_abaacti,l_aba20
            IF STATUS THEN
               CALL s_errmsg('sel aba:',l_nppglno,'',STATUS,1)
               LET g_success = 'N'
            END IF
            IF l_abaacti = 'N' THEN
               CALL s_errmsg('',l_nppglno,'','mfg8003',1)
               LET g_success = 'N'
            END IF
            IF l_aba20 MATCHES '[Ss1]' THEN
               CALL s_errmsg('',l_nppglno,'','mfg3557',1)
               LET g_success = 'N'
            END IF
            IF l_abapost = 'Y' THEN
               CALL s_errmsg('',l_nppglno,'','aap-132',1)
               LET g_success = 'N'
            END IF
            IF l_aba19 = 'Y' THEN
               CALL s_errmsg('',l_nppglno,'','anm-116',1)
               LET g_success = 'N'
            END IF
            LET p_acc1 = l_npp07
            LET g_existno1 = l_nppglno
            DISPLAY l_npp07 TO FORMONLY.p_acc1
            DISPLAY l_nppglno TO FORMONLY.g_existno1
         END FOREACH
         IF cl_null(g_existno1) THEN
            LET g_existno1 = "'",l_nppglno,"'"
            LET g_existno1_str = g_existno1
         ELSE
            LET g_existno1_str = g_existno1_str,",","'",l_nppglno,"'"
         END IF
      END FOREACH
   END IF
   LET g_existno1 = ""
END FUNCTION
#FUN-D60110 ---Add--- End
