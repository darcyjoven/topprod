# Prog. Version..: '5.30.06-13.04.09(00010)'     #
#
# Pattern name...: axmp620.4gl
# Descriptions...: 出貨通知單轉出貨
# Date & Author..: 95/02/03 By Roger
# Modify..2.00.03: 96/01/23 BY Danny  (將判斷包裝單確認否拿掉)
# Modify.........: No.MOD-490405 04/10/01 By Wiky 若出通單產生過出貨單,不應該再產生
# Modify.........: No.FUN-540049 05/05/19 By Carrier 雙單位內容修改
# Modify.........: No.FUN-550070 05/05/26 By Will 單據編號放大
# Modify.........: No.MOD-560153 05/06/21 By Echo 產生出貨單後狀況碼錯誤,應為開立
# Modify.........: No.MOD-590204 05/09/15 By Rosayu 轉出失敗的話，失敗的出貨單單頭未刪除掉，造成只有單頭沒有單身。
# Modify.........: NO.MOD-590103 05/10/25 By Nicola 所以動作用同一個transaction包起來
# Modify.........: No.FUN-570155 06/03/15 By yiting 批次背景執行
# Modify.........: No.FUN-660167 06/06/23 By Ray cl_err --> cl_err3
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.MOD-660120 06/07/05 By Pengu 出貨單扣帳碼ogapost應default 'N'
# Modify.........: No.FUN-680137 06/09/15 By bnlent 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0094 06/11/01 By yjkhero l_time轉g_time
# Modify.........: No.FUN-710046 07/01/22 By cheunl 錯誤訊息匯整
# Modify.........: No.CHI-6C0044 07/02/12 By 於出貨確認時再update回出通單的出貨單號
# Modify.........: No.TQC-740124 07/04/18 By chenl 增加自動編號。
# Modify.........: No.TQC-740152 07/04/20 By rainy 過單用
# Modify.........: No.MOD-7B0164 07/11/30 By claire 避免出通單跳號應以訂單為條件
# Modify.........: No.MOD-820124 08/02/22 By claire 避免單身有不同訂單但相同料號的情況
# Modify.........: No.TQC-960033 09/06/22 By lilingyu 彈出對話框,維護"出貨數量"的欄位,沒有對輸入負數控管,同時輸入負數拋轉不成功,之后顯示運行成功
# Modify.........: No.TQC-970361 09/08/10 By lilingyu 控管已經拋轉過出貨單，就不可再拋
# Modify.........: No.FUN-870007 09/08/13 By Zhangyajun 流通零售功能修改
# Modify.........: No.FUN-980010 09/08/20 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A40041 10/04/20 By wujie     g_sys->AXM
# Modify.........: No.CHI-A70049 10/08/25 By pengu  ±N¦h¾lªºDISPLAYµ{¦¡mark
# Modify.........: No.FUN-AC0055 10/12/22 By wangxin oga57,ogb50欄位預設值修正
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:FUN-C30086 12/11/20 By Sakura 出貨通知單開窗需可篩選出多角貿易出貨通知單單號
# Modify.........: No:MOD-D40023 13/04/203By Vampire 出貨日期不可以大於目前使用會計年度!!!
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_oga		 RECORD LIKE oga_file.*
DEFINE b_ogb		 RECORD LIKE ogb_file.*
DEFINE g_no1,g_no2	 LIKE oga_file.oga01 #No.FUN-680137 VARCHAR(16) #No.FUN-550070
DEFINE g_t1       	 LIKE oay_file.oayslip                 #No.FUN-550070  #No.FUN-680137 VARCHAR(5)
DEFINE g_ogd13    	 LIKE ogd_file.ogd13     # 包裝單數量
DEFINE g_date2    	 LIKE type_file.dat     #No.FUN-680137 DATE
DEFINE g_buf             LIKE type_file.chr2     #No.FUN-680137 VARCHAR(2)
DEFINE g_oga011_t        LIKE oga_file.oga011 #出貨通知單上的出貨單號舊值
 
DEFINE   g_cnt           LIKE type_file.num10      #No.FUN-680137 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-680137 SMALLINT
DEFINE g_flag          LIKE type_file.chr1,                  #No.FUN-570155  #No.FUN-680137 VARCHAR(1)
       g_change_lang   LIKE type_file.chr1    #No.FUN-680137 VARCHAR(01) #是否有做語言切換 No.FUN-570155
 
MAIN
   DEFINE   ls_date  STRING        #No.FUN-570155
   DEFINE li_result     LIKE type_file.num5    #No.FUN-550070  #No.FUN-680137 SMALLINT
 
   OPTIONS                                #改變一些系統預設值
      INPUT NO WRAP,
      FIELD ORDER FORM
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
  #->No.FUN-570155 --start--
  INITIALIZE g_bgjob_msgfile TO NULL
  LET g_no1   = ARG_VAL(1)    
  LET ls_date = ARG_VAL(2)
  LET g_date2 = cl_batch_bg_date_convert(ls_date)
  LET g_no2   = ARG_VAL(3)    
  LET g_bgjob = ARG_VAL(4)    #背景作業
  IF cl_null(g_bgjob) THEN
     LET g_bgjob = "N"
  END IF
  #->No.FUN-570155 ---end---
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
   SELECT * INTO g_sma.* FROM sma_file WHERE sma00='0'
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818 #NO.FUN-6A0094
 
#NO.FUN-570155 mark--
#   OPEN WINDOW p620_w 
#     WITH FORM "axm/42f/axmp620" ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   
#   CALL cl_ui_init()
#
#   CALL cl_opmsg('z')
 
#   CALL p620_p1()
 
#   CLOSE WINDOW p620_w
#NO.FUN-570155 mark--
 
#NO.FUN-570155 start-
  LET g_success = 'Y'
  WHILE TRUE
    IF g_bgjob = "N" THEN
       CALL p620_p1()
       IF cl_sure(18,20) THEN
          BEGIN WORK
          CALL p620_p2()
          CALL s_showmsg()                  #No.FUN-710046
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
           CLOSE WINDOW p620_w
           EXIT WHILE 
        END IF
       ELSE
          CONTINUE WHILE
       END IF
    ELSE
       BEGIN WORK
       LET g_success = 'Y'
       CALL p620_p2()
       CALL s_showmsg()                  #No.FUN-710046
       IF g_success = "Y" THEN
          COMMIT WORK
       ELSE
          ROLLBACK WORK
       END IF
       CALL cl_batch_bg_javamail(g_success)
       EXIT WHILE
   END IF
 END WHILE
#->No.FUN-570155 ---end---
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818 #NO.FUN-6A0094
 
END MAIN
 
FUNCTION p620_p1()
   DEFINE l_flag        LIKE type_file.num5    #No.FUN-680137 SMALLINT
   DEFINE li_result     LIKE type_file.num5    #No.FUN-550070  #No.FUN-680137 SMALLINT
   DEFINE lc_cmd        LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(500)   #No.FUN-570155
   DEFINE l_pass        LIKE type_file.num5
   DEFINE l_yy   LIKE type_file.num5 #MOD-D40023 add
   DEFINE l_mm   LIKE type_file.num5 #MOD-D40023 add
 
#->No.FUN-570155 --start--
  OPEN WINDOW p620_w WITH FORM "axm/42f/axmp620"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
  CALL cl_ui_init()
  CALL cl_opmsg('z')
#->No.FUN-570155 ---end---
 
   LET g_date2 = TODAY
 
   WHILE TRUE
      CLEAR FORM
      LET g_action_choice = ''
      LET g_no1=NULL
      LET g_no2=NULL
      LET g_bgjob = 'N' #NO.FUN-570155    
      #INPUT BY NAME g_no1,g_date2,g_no2 WITHOUT DEFAULTS 
      INPUT BY NAME g_no1,g_date2,g_no2,g_bgjob  WITHOUT DEFAULTS  #NO.FUN-570155 
      
         AFTER FIELD g_no1    
            IF NOT cl_null(g_no1) THEN 
               SELECT * INTO g_oga.* FROM oga_file
               #WHERE oga01=g_no1 AND oga09='1'          #FUN-C30086 mark
                WHERE oga01=g_no1 AND oga09 IN ('1','5') #FUN-C30086 add 5.多角貿易出通單
               IF STATUS THEN 
#                 CALL cl_err('sel oga:',STATUS,0)   #No.FUN-660167
                  CALL cl_err3("sel","oga_file",g_no1,"",STATUS,"","sel oga",0)   #No.FUN-660167
                  NEXT FIELD g_no1 
               END IF
 
               IF g_oga.ogaconf != 'Y' THEN  #01/08/20 mandy
                  CALL cl_err('ogaconf=N:','axm-184',0)
                  NEXT FIELD g_no1
               END IF
            END IF
          #BugNo:5235
          # IF NOT cl_null(g_oga.oga011) THEN 
          #    CALL cl_err('oga011!='':','axm-228',0) NEXT FIELD g_no1
          # END IF
         
         AFTER FIELD g_date2
            IF cl_null(g_date2) THEN
               NEXT FIELD g_date2 
            END IF
 
            IF g_date2 <= g_oaz.oaz09 THEN
               CALL cl_err('','axm-164',0) 
               NEXT FIELD g_date2
            END IF
 
            IF g_oaz.oaz03 = 'Y' AND NOT cl_null(g_sma.sma53)
               AND g_date2 <= g_sma.sma53 THEN
               CALL cl_err('','mfg9999',0)
               NEXT FIELD g_date2
            END IF
 
         AFTER FIELD g_no2
            IF cl_null(g_no2) THEN
               NEXT FIELD g_no2
            END IF
#No.FFUN-550070  --start  
#           LET g_t1=g_no2[1,3]
#           CALL s_axmslip(g_t1,g_buf,g_sys)	    #檢查單別
#           IF NOT cl_null(g_errno) THEN 
#              CALL cl_err(g_t1,g_errno,0)
#              NEXT FIELD g_no2 
#           END IF
#           #No:5445
#           IF cl_null(g_no2[5,10]) AND g_oay.oayauno = 'N' THEN
#              CALL cl_err(g_no2[1,3],'aap-011',0)
#              NEXT FIELD g_no2
#           END IF
#           IF NOT cl_chk_data_continue(g_no2[5,10]) THEN
#              CALL cl_err(g_no2,'9056',0)
#              NEXT FIELD g_no2
#           END IF
#           SELECT count(*) INTO g_cnt FROM oga_file
#            WHERE oga01 = g_no2
#           IF g_cnt > 0 THEN   #資料重複
#              CALL cl_err(g_no2,-239,0)
#              NEXT FIELD g_no2
#           END IF
         
#           IF cl_null(g_no2[5,10]) AND g_oay.oayauno='Y' THEN
#              CALL s_axmauno(g_no2,g_date2) RETURNING g_i,g_no2
#              IF g_i THEN NEXT FIELD g_no2 END IF
#                 DISPLAY BY NAME g_no2
#              END IF
            #No.FUN-550070  --end  
         #No.TQC-740124--begin--
            CALL p620_check_no2() RETURNING l_pass
            IF l_pass=0 THEN
               NEXT FIELD g_no2
            END IF 
         #No.TQC-740124--end--

        #MOD-D40023 add start -----
         AFTER INPUT
            CALL s_yp(g_date2) RETURNING l_yy,l_mm
            IF ((l_yy*12+l_mm) > (g_sma.sma51*12+g_sma.sma52)) THEN
               CALL cl_err('','mfg6090',0)
               NEXT FIELD g_date2 
            END IF
        #MOD-D40023 add end   -----
 
         ON ACTION locale
#NO.FUN-570155 start-
#            LET g_action_choice='locale'
#            CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
             LET g_change_lang = TRUE
#NO.FUN-570155 end--
 
            EXIT INPUT
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG 
            CALL cl_cmdask()
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
      
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
      
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
      
         ON ACTION CONTROLP                  
            CASE
               WHEN INFIELD(g_no1)
                     #CALL q_oga1(0,0,g_no1) RETURNING g_no1
                     #CALL FGL_DIALOG_SETBUFFER( g_no1 )
                      CALL cl_init_qry_var()
                      LET g_qryparam.form ="q_oga1"
                      LET g_qryparam.default1 = g_no1
                      CALL cl_create_qry() RETURNING g_no1
#                      CALL FGL_DIALOG_SETBUFFER( g_no1 )
                      DISPLAY BY NAME g_no1
               WHEN INFIELD(g_no2) #查詢單据
                  LET g_t1=g_no2[1,g_doc_len]    #No.FUN-550070
                  LET g_buf='50'
                  IF g_oga.oga00 = '3' THEN
                     LET g_buf[2,2] = '3' 
                  END IF
                  IF g_oga.oga00 = '4' THEN
                     LET g_buf[2,2] = '4' 
                  END IF
                  IF g_oga.oga00 = '5' THEN
                     LET g_buf[2,2] = '6' 
                  END IF
                  #CALL q_oay(FALSE,FALSE,g_t1,g_buf,g_sys) RETURNING g_t1  #TQC-670008
                  CALL q_oay(FALSE,FALSE,g_t1,g_buf,'AXM') RETURNING g_t1   #TQC-670008
#                  CALL FGL_DIALOG_SETBUFFER( g_t1 )
                  LET g_no2=g_t1                 #No.FUN-550070 
                  DISPLAY BY NAME g_no2 
                  NEXT FIELD g_no2
           END CASE
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
      END INPUT
#NO.FUN-570155 mark-
#      IF g_action_choice = 'locale' THEN
#         CALL cl_dynamic_locale()
#         CONTINUE WHILE
#      END IF
      
#      IF INT_FLAG THEN
#         LET INT_FLAG = 0
#       # ROLLBACK WORK     #No.MOD-590103 Mark
#         RETURN
#     END IF
      
#      IF cl_sure(0,0) THEN 
#         CALL cl_wait()
#         LET g_success = 'Y'
#         BEGIN WORK
 
#         CALL p620_p2()
 
#         IF g_success = 'Y' THEN
#            COMMIT WORK
#            CALL cl_end2(1) RETURNING l_flag
#         ELSE
#            ROLLBACK WORK
#            CALL cl_end2(2) RETURNING l_flag
#         END IF
#
#         IF l_flag THEN
#            CONTINUE WHILE 
#         ELSE
#            EXIT WHILE
#         END IF
#      END IF
#   END WHILE
#NO.FUN-570155 mark--
 
#NO.FUN-570155 start--
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p620_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
 
   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO lc_cmd FROM zz_file WHERE zz01 = 'axmp620'
      IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
          CALL cl_err('axmp620','9031',1)   
   ELSE
      LET lc_cmd = lc_cmd CLIPPED,
                   " '",g_no1 CLIPPED,"'",
                   " '",g_date2 CLIPPED,"'",
                   " '",g_no2 CLIPPED,"'",
                   " '",g_bgjob CLIPPED,"'"
      CALL cl_cmdat('axmp620',g_time,lc_cmd CLIPPED)
   END IF
   CLOSE WINDOW p620_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
   EXIT PROGRAM
 END IF
 EXIT WHILE
END WHILE
#FUN-570155 ---end---
 
END FUNCTION
 
FUNCTION p620_check_no2()
   DEFINE li_result     LIKE type_file.num5  
   LET g_buf='50'
   IF g_oga.oga00 = '3' THEN
      LET g_buf[2,2] = '3' 
   END IF
   IF g_oga.oga00 = '4' THEN
      LET g_buf[2,2] = '4' 
   END IF
   IF g_oga.oga00 = '5' THEN
      LET g_buf[2,2] = '6' 
   END IF
  
#  CALL s_check_no(g_sys,g_no2,"",g_buf,"oga_file","oga01","")
   CALL s_check_no("axm",g_no2,"",g_buf,"oga_file","oga01","")  #No.FUN-A40041
     RETURNING li_result,g_no2
   IF g_bgjob = 'N' THEN  #NO.FUN-570155 
       DISPLAY BY NAME g_no2
   END IF
   IF (NOT li_result) THEN
      RETURN FALSE
   END IF
  
#  CALL s_auto_assign_no(g_sys,g_no2,g_date2,g_buf,"oga_file","oga01","","","")
   CALL s_auto_assign_no("axm",g_no2,g_date2,g_buf,"oga_file","oga01","","","")   #No.FUN-A40041
     RETURNING li_result,g_no2                                         
   IF (NOT li_result) THEN                                                   
      RETURN FALSE
   END IF                                                                    
   IF g_bgjob = 'N' THEN  #NO.FUN-570155 
       DISPLAY BY NAME g_no2       
   END IF
   RETURN TRUE
END FUNCTION
 
FUNCTION p620_p2()
   DEFINE l_ogc       RECORD LIKE ogc_file.*   
   DEFINE l_ogb04     LIKE ogb_file.ogb04    #MOD-490405   
   DEFINE l_ogb12     LIKE ogb_file.ogb12     
   DEFINE l_sum_ogb12 LIKE ogb_file.ogb12 
   DEFINE l_sql       STRING                  
   DEFINE l_ogb03     LIKE ogb_file.ogb03    #MOD-7B0164
   DEFINE l_chr       LIKE type_file.chr1                 #是否產生單頭MOD-490405(end)    #No.FUN-680137 VARCHAR(1)  
   DEFINE l_ogb31     LIKE ogb_file.ogb31    #MOD-820124       
   DEFINE l_ogb32     LIKE ogb_file.ogb32    #MOD-820124       
   DEFINE l_cnt       LIKE type_file.num5    #TQC-970361     
   DEFINE l_oga09     LIKE oga_file.oga09    #FUN-C30086 add
   DEFINE l_poz00     LIKE poz_file.poz00    #FUN-C30086 add
 
#TQC-970361 --BEGIN--                                                                                                               
     SELECT COUNT(oga01) INTO l_cnt FROM oga_file,ogb_file                                                                          
      WHERE oga01 = ogb01                                                                                                           
       #AND oga09 = '2'            #FUN-C30086 mark
        AND oga09 IN ('2','4','6') #FUN-C30086 add 4.多角貿易出貨單6.多角代採出貨單
        AND ogaconf != 'X'                                                                                                          
        AND ogb03 IS NOT NULL                                                                                                       
        AND oga011 = g_no1                                                                                                          
     IF l_cnt > 0 THEN                                                                                                              
        CALL cl_err('','axm-652',0)                                                                                                 
        LET g_success = 'N'                                                                                                         
        RETURN                                                                                                                      
     END IF                                                                                                                         
#TQC-970361 --END--   
 
  #MOD-490405先找出通單單身#
  
   LET l_sql = " SELECT ogb04,ogb12,ogb31,ogb32 FROM ogb_file,oga_file ",  #MOD-820124
               "  WHERE ogb01='",g_no1,"' ",
               "    AND ogb01=oga01 ",
              #"    AND oga09='1'   ",        #FUN-C30086 mark
               "    AND oga09 IN ('1','5') ", #FUN-C30086 add 5.多角貿易出通單
               "    AND ogaconf <> 'X'   "
   
   DECLARE p620_foreach CURSOR FROM l_sql
  #DISPLAY l_sql                                    #CHI-A70049 mark
   
   LET l_chr='Y'
   FOREACH p620_foreach INTO l_ogb04,l_ogb12,l_ogb31,l_ogb32  #MOD-820124 modify
      IF SQLCA.SQLCODE THEN
         CALL cl_err('l_ogb04',SQLCA.SQLCODE,1) 
         LET l_chr='N'  
         EXIT FOREACH   
      ELSE
         SELECT sum(ogb12) INTO l_sum_ogb12 FROM oga_file,ogb_file 
          WHERE oga011= g_no1 
            AND oga01 = ogb01  
            AND ogb04 = l_ogb04   
            AND ogaconf <> 'X'
            AND ogb31 = l_ogb31   #MOD-820124 add
            AND ogb32 = l_ogb32   #MOD-820124 add
         IF cl_null(l_sum_ogb12) THEN
            LET l_sum_ogb12 = 0
         END IF
  
         IF l_sum_ogb12 < l_ogb12 THEN  #出貨單比出單數量少
            LET l_chr='Y'
            EXIT FOREACH                #可再產單頭
         ELSE
            LET l_chr='N'
            CONTINUE FOREACH
         END IF
      END IF
   END FOREACH 
   IF l_chr='N' THEN  
      LET g_success='N' 
      CALL cl_err('','axm-123',1)                  
      RETURN 
   END IF
  #MOD-490405(end)
   
   SELECT oga011 INTO g_oga011_t  #NO:mandy
     FROM oga_file
    WHERE oga01 = g_no1
 
 #CHI-6C0044 remark begin
   #UPDATE oga_file SET oga011 = g_no2
   # WHERE oga01 = g_no1
   #IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN 
#  #   CALL cl_err('upd oga011',SQLCA.SQLCODE,1)  #No.FUN-660167
   #   CALL cl_err3("upd","oga_file",g_no1,"",SQLCA.SQLCODE,"","upd oga011",1)   #No.FUN-660167 
   #   LET g_success='N'
   #   RETURN
   #END IF
 #CHI-6C0044 remark end
 
   LET g_oga.oga01 = g_no2
   LET g_oga.oga02 = g_date2
   LET g_oga.oga011 = g_no1
  #LET g_oga.oga09 = '2' #FUN-C30086 mark
#FUN-C30086---add---START
   SELECT oga09 INTO l_oga09 FROM oga_file WHERE oga01 = g_no1
   CASE
     WHEN l_oga09 = '1' #一單出貨通知單
       LET g_oga.oga09 = '2'
     WHEN l_oga09 = '5' #多角貿易出或通知單
       SELECT poz00 INTO l_poz00 FROM oga_file
         LEFT OUTER JOIN oea_file ON oga16 = oea01
         LEFT OUTER JOIN poz_file ON oea904 = poz01
       WHERE oga01 = g_no1
       IF l_poz00 = '1' THEN   #1.銷售
          LET g_oga.oga09 = '4'
       ELSE                    #2.代採
          LET g_oga.oga09 = '6'
       END IF
   END CASE
#FUN-C30086---add-----END
   LET g_oga.ogaconf = 'N' #
   LET g_oga.ogapost = 'N' #No.MOD-660120 add
#  LET g_oga.ogaconf = 'Y' # 為使oeb23待出貨數量正確, 故出貨單也須為確認狀態
   LET g_oga.ogaprsw = 0
   LET g_oga.oga55='0'               #MOD-560153
   LET g_oga.oga57  = '1'          #FUN-AC0055 add
   LET g_oga.ogamksg = g_oay.oayapr  #MOD-560153
   LET g_oga.oga85=' '  #No.FUN-870007
   LET g_oga.oga94='N'  #No.FUN-870007 
 
   #FUN-980010 add plant & legal 
   LET g_oga.ogaplant = g_plant 
   LET g_oga.ogalegal = g_legal 
   #FUN-980010 end plant & legal 
 
   LET g_oga.ogaoriu = g_user      #No.FUN-980030 10/01/04
   LET g_oga.ogaorig = g_grup      #No.FUN-980030 10/01/04
   INSERT INTO oga_file VALUES (g_oga.*)
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN 
#     CALL cl_err('ins oga',SQLCA.SQLCODE,1)   #No.FUN-660167
      CALL cl_err3("ins","oga_file",g_oga.oga01,"",SQLCA.SQLCODE,"","ins oga",1)   #No.FUN-660167  
      LET g_success='N' 
      RETURN
   END IF
   
  ##-----No.MOD-590103 Mark-----
  #IF g_success = 'Y'#No:5320
  #   THEN COMMIT WORK
  #   ELSE CALL cl_rbmsg(1) ROLLBACK WORK
  #END IF
   
  #BEGIN WORK LET g_success = 'Y'
  ##-----No.MOD-590103 Mark END-----
   
   #No.FUN-540049  --begin
   IF g_sma.sma115 = 'Y' THEN
      CALL s_g_ogb1(g_no1,g_no2)
   ELSE
      CALL s_g_ogb(g_no1,g_no2)
   END IF
   #No.FUN-540049  --end 
                      #NO:mandy
   CALL p620_delall() #若沒有單身資料,就將單頭資料也刪除 #MOD-590204 unmark
                      #並將出貨通知單上的出貨單號恢復成舊值
                      #加入p620_delall()這段程式會有出貨單號跳號的缺點
 
   #No.B219 010329 by plum
   IF g_success = 'N' THEN
      RETURN 
   END IF
   #No.B219..end
 
#  DROP TABLE x
#  SELECT * FROM ogb_file WHERE ogb01 = g_no1 INTO TEMP x
#  IF STATUS THEN CALL cl_err('into x',STATUS,1) LET g_success='N' END IF
#  UPDATE x SET ogb01=g_no2
#  IF STATUS THEN CALL cl_err('upd x',STATUS,1) LET g_success='N' END IF
#  INSERT INTO ogb_file SELECT * FROM x
#  IF STATUS THEN CALL cl_err('ins ogb',STATUS,1) LET g_success='N' END IF
   
#  若有包裝單抓包裝單數量 , 否則抓出貨通知單數 #
   DECLARE p620_ogb_curs CURSOR FOR SELECT * FROM ogb_file
                                     WHERE ogb01 = g_no2
   IF STATUS THEN
      CALL cl_err('declare',STATUS,1)
      LET g_success = 'N'
      RETURN 
   END IF
 
   FOREACH p620_ogb_curs INTO b_ogb.*
      IF STATUS THEN
         CALL cl_err('foreach',STATUS,1)       
         LET g_success = 'N'
         RETURN
      END IF
      #MOD-7B0164-begin-modify
       SELECT ogb03 INTO l_ogb03 
        FROM  ogb_file
        WHERE ogb01 = g_no1
          AND ogb31 = b_ogb.ogb31
          AND ogb32 = b_ogb.ogb32
      #MOD-7B0164-end-modify
      SELECT SUM(ogd13) INTO g_ogd13 FROM ogd_file 
       WHERE ogd01 = g_no1            # 通知單號 
         AND ogd03 = l_ogb03          # 項次      #MOD-7B0164 
        #AND ogd03 = b_ogb.ogb03      # 項次      #MOD-7B0164
      IF STATUS = 0 AND NOT cl_null(g_ogd13) THEN
         UPDATE ogb_file SET ogb16 = g_ogd13
          WHERE ogb01 = g_no2
            AND ogb03 = b_ogb.ogb03
#          IF STATUS THEN CALL cl_err('upd ogb_file',STATUS,1)
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN 
#           CALL cl_err('upd ogb_file',SQLCA.SQLCODE,1) #No.FUN-660167
            CALL cl_err3("upd","ogb_file",g_no2,b_ogb.ogb03,SQLCA.SQLCODE,"","upd ogb_file",1)   #No.FUN-660167    
            LET g_success='N'
            RETURN         
         END IF
      END IF
   END FOREACH
#  96-05-17 by WUPN ------------- #
   DROP TABLE x
   SELECT * FROM ogc_file WHERE ogc01 = g_no1 INTO TEMP x
   UPDATE x SET ogc01=g_no2
   INSERT INTO ogc_file SELECT * FROM x
   
   DROP TABLE x
   SELECT * FROM oao_file WHERE oao01 = g_no1 INTO TEMP x
   UPDATE x SET oao01=g_no2
   INSERT INTO oao_file SELECT * FROM x
   
   DROP TABLE x
   SELECT * FROM oap_file WHERE oap01 = g_no1 INTO TEMP x
   UPDATE x SET oap01=g_no2
   INSERT INTO oap_file SELECT * FROM x
 
END FUNCTION
 
FUNCTION p620_delall()
 
   SELECT COUNT(*) INTO g_cnt
     FROM ogb_file
    WHERE ogb01 = g_no2 #出貨單號
 
   #沒有單身資料,就將單頭資料也刪除
   IF g_cnt <=0 THEN
      DELETE FROM oga_file
       WHERE oga01 = g_no2
 
      #將出貨通知單上的出貨單號恢復成舊值
     #CHI-6C0044 remark begin
      #UPDATE oga_file 
      #   SET oga011 = g_oga011_t 
      # WHERE oga01=g_no1
     #CHI-6C0044 remark end
      LET g_no2 = NULL
 
      DISPLAY g_no2 TO FORMONLY.g_no2
 
      #轉出貨單不成功,因單身無轉出資料!
      CALL cl_err('','axm-620',1)     
      LET g_success = 'N'                  #TQC-960033                    
     #-----No.MOD-590103 Mark-----
     #COMMIT WORK
     #BEGIN WORK
     #-----No.MOD-590103 Mark END-----
   END IF
   
END FUNCTION
#TQC-740152
