# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: axrp501.4gl
# Descriptions...: 客戶應收年底結轉作業                    
# Date & Author..: 95/02/12 By Roger
# Modify.........: 97/08/28 By Sophia 新增工廠別(ooo10),帳別(ooo11)
# Modify ........: No.FUN-4C0013 04/12/01 By ching 單價,金額改成 DEC(20,6)
# Modify.........: No.FUN-570156 06/03/09 By saki 批次背景執行
# Modify.........: No.FUN-680123 06/08/29 By hongmei 欄位類型轉換 
# Modify.........: No.FUN-6A0095 06/10/25 By xumin l_time轉g_time
# Modify.........: No.FUN-710050 07/01/22 By bnlent  錯誤訊息匯整 
# Modify.........: No.MOD-740358 07/04/24 By Carrier 加入"科目變更"內容
# Modify.........: NO.TQC-790100 07/09/17 BY Joe 修正Primary Key後, 程式判斷錯誤訊息時必須改變做法
# Modify.........: No.FUN-980011 09/08/18 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:FUN-CA0111 12/10/19 By Belle   寫入ooo_file時增加資料來源(ooo12='1')
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_wc,g_sql	string                       #No.FUN-580092 HCN 
DEFINE g_yy,g_mm        LIKE type_file.num5          #No.FUN-680123 SMALLINT
DEFINE g_a              LIKE type_file.chr1          #No.MOD-740358 
DEFINE b_date,e_date	LIKE type_file.dat           #No.FUN-680123 DATE
DEFINE g_dc             LIKE type_file.chr1          #No.FUN-680123 VARCHAR(1)
DEFINE #g_amt1,g_amt2	DEC(20,6)                    #FUN-4C0013
       g_amt1,g_amt2    LIKE type_file.num20_6       #No.FUN-680123 DEC(20,6)
DEFINE g_ooo		RECORD LIKE ooo_file.*
DEFINE p_row,p_col      LIKE type_file.num5          #No.FUN-680123 SMALLINT
DEFINE g_cnt            LIKE type_file.num10         #No.FUN-680123 INTEGER
DEFINE # Prog. Version..: '5.30.06-13.03.12(01)                     #是否有做語言切換 No.FUN-570156
       g_change_lang    LIKE type_file.chr1          #No.FUN-680123 VARCHAR(01)
 
MAIN
#   DEFINE l_time  	LIKE type_file.chr8          #No.FUN-680123 VARCHAR(8)   #No.FUN-6A0095
   DEFINE l_flag        LIKE type_file.chr1          #->No.FUN-570156   #No.FUN-680123 VARCHAR(1)
 
   OPTIONS
        MESSAGE   LINE  LAST-1,
        INPUT NO WRAP
   DEFER INTERRUPT
 
   #No.FUN-570156 --start--
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_yy     = ARG_VAL(1)             #結轉年度
   #No.MOD-740358  --Begin
   LET g_a      = ARG_VAL(2)
   LET g_bgjob  = ARG_VAL(3)     #背景作業
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
   IF cl_null(g_a) THEN
      LET g_a = "N"
   END IF
   #No.MOD-740358  --End  
   #No.FUN-570156 ---end---
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXR")) THEN
      EXIT PROGRAM
   END IF
 
   #No.FUN-570156 --start--
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0095
#  OPEN WINDOW p501_w AT p_row,p_col WITH FORM "axr/42f/axrp501"
#      ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
#   
#   CALL cl_ui_init()
 
#  CALL p501()
#  CLOSE WINDOW p501_w
   WHILE TRUE
      IF g_bgjob = "N" THEN
         CALL p501()
         IF cl_sure(18,20) THEN 
            LET g_success = 'Y'
            BEGIN WORK
            CALL cl_wait()
            CALL p501_1()
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
               CLOSE WINDOW p501_w
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         LET g_success = 'Y'
         BEGIN WORK 
         CALL p501_1()
         CALL s_showmsg()     #No.FUN-710050
         IF g_success = "Y" THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
   #No.FUN-570156 ---end---
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0095
END MAIN
 
FUNCTION p501()
DEFINE l_flag        LIKE type_file.chr1          #No.FUN-680123 VARCHAR(1)
DEFINE #lc_cmd       VARCHAR(500)                    #No.FUN-570156
        lc_cmd       LIKE zz_file.zz08            #No.FUN-680123 VARCHAR(500)
 
   #No.FUN-570156 --start--
   OPEN WINDOW p501_w AT p_row,p_col WITH FORM "axr/42f/axrp501"
        ATTRIBUTE (STYLE = g_win_style)
   CALL cl_ui_init()
   #No.FUN-570156 ---end---
 
   CLEAR FORM
   SELECT azn02,azn04 INTO g_yy,g_mm FROM azn_file WHERE azn01 = g_ooz.ooz09
   LET g_bgjob = "N"         #No.FUN-570156
   WHILE TRUE
      CALL cl_opmsg('z')
 
      INPUT BY NAME g_yy,g_a,g_bgjob WITHOUT DEFAULTS       #No.FUN-570156  #No.MOD-740358
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         AFTER FIELD g_yy
            IF g_yy IS NULL OR g_yy=0 THEN
               NEXT FIELD g_yy
            END IF
 
         #No.MOD-740358  --Begin
         AFTER FIELD g_a
            IF cl_null(g_a) OR g_a NOT MATCHES '[YN]' THEN
               NEXT FIELD g_a
            END IF
         #No.MOD-740358  --End  
 
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
         ON ACTION CONTROLG 
            call cl_cmdask()
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
         ON ACTION exit               #加離開功能genero
            LET INT_FLAG = 1
            EXIT INPUT
         ON ACTION locale #genero
            #No.FUN-570156 --start--
#           LET g_action_choice = "locale"
#         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            LET g_change_lang = TRUE
            #No.FUN-570156 ---end---
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
      #No.FUN-570156 --start--
#     IF g_action_choice = "locale" THEN  #genero
      IF g_change_lang THEN
#        LET g_action_choice = ""
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         CONTINUE WHILE
      END IF
      #No.FUN-570156 ---end---
 
      IF INT_FLAG THEN
         #No.FUN-570156 --start--
         LET INT_FLAG = 0 
         CLOSE WINDOW p501_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
#        RETURN
         #No.FUN-570156 ---end---
      END IF
 
      #No.FUN-570156 --start--
      IF g_bgjob = "Y" THEN
         SELECT zz08 INTO lc_cmd FROM zz_file
          WHERE zz01 = "axrp501"
         IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
            CALL cl_err('axrp501','9031',1)
         ELSE
            LET lc_cmd = lc_cmd CLIPPED,
                         " '",g_yy CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'"
            CALL cl_cmdat('axrp501',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW p501_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
 
#     IF cl_sure(21,21) THEN   
#        CALL cl_wait()
#        CALL p501_1()
#        IF g_success='Y' THEN
#           CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
#        ELSE
#           CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
#        END IF
#        IF l_flag THEN
#           CONTINUE WHILE
#        ELSE
#           EXIT WHILE
#        END IF
#     END IF
#     ERROR ''
      #No.FUN-570156 ---end---
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION p501_1()
  DEFINE  next_yy LIKE type_file.num5          #No.FUN-680123 SMALLINT
  DEFINE  l_ooo   RECORD LIKE ooo_file.*       #No.MOD-740358
  LET g_success ='Y'   #genero
  LET next_yy = g_yy + 1
  IF g_bgjob = "N" THEN             #No.FUN-570156
     MESSAGE   "del next year's ooo!"
     CALL ui.Interface.refresh() 
  END IF                            #No.FUN-570156
 #DELETE FROM ooo_file WHERE ooo06 = next_yy AND ooo07=0                    #FUN-CA0111 mark
  DELETE FROM ooo_file WHERE ooo06 = next_yy AND ooo07=0 AND ooo12 = '1'    #FUN-CA0111
  DECLARE p501_eoy_c CURSOR FOR
     SELECT ooo10,ooo11,ooo01,ooo02,ooo03,ooo04,ooo05, 
            SUM(ooo08d-ooo08c),SUM(ooo09d-ooo09c)
       FROM ooo_file
      WHERE ooo06 = g_yy
      GROUP BY ooo10,ooo11,ooo01,ooo02,ooo03,ooo04,ooo05
  LET g_cnt=1
  LET g_ooo.ooo06=next_yy
  LET g_ooo.ooo07=0
  LET g_ooo.ooolegal = g_legal #FUN-980011 add
 
  CALL s_showmsg_init()     #No.FUN-710050
  FOREACH p501_eoy_c INTO g_ooo.ooo10,g_ooo.ooo11,g_ooo.ooo01,
                          g_ooo.ooo02,g_ooo.ooo03,g_ooo.ooo04,
                          g_ooo.ooo05,g_ooo.ooo08d,g_ooo.ooo09d
     IF STATUS THEN 
     #No.FUN-710050--Begin--
     #  CALL cl_err('foreach:',STATUS,1) 
        CALL s_errmsg('','','foreach:',STATUS,1) 
     #No.FUN-710050--End--
        LET g_success='N'
        RETURN 
     END IF
     #No.FUN-710050--Begin--                                                                                                      
       IF g_success='N' THEN                                                                                                        
          LET g_totsuccess='N'                                                                                                      
          LET g_success="Y"                                                                                                         
       END IF                                                                                                                       
     #No.FUN-710050--End-
 
     IF g_ooo.ooo08d < 0
        THEN LET g_ooo.ooo08c = -g_ooo.ooo08d LET g_ooo.ooo08d=0
        ELSE LET g_ooo.ooo08c = 0
     END IF
     IF g_ooo.ooo09d < 0
        THEN LET g_ooo.ooo09c = -g_ooo.ooo09d LET g_ooo.ooo09d=0
        ELSE LET g_ooo.ooo09c = 0
     END IF
     LET g_cnt=g_cnt+1
     IF g_bgjob = "N" THEN           #No.FUN-570156
        MESSAGE   "(",g_cnt USING '<<<<<',") ins ooo:",g_ooo.ooo01
        CALL ui.Interface.refresh() 
     END IF                          #No.FUN-570156
     #No.MOD-740358  --Begin
     IF g_a = 'Y' THEN
        CALL s_tag(next_yy,g_ooo.ooo11,g_ooo.ooo03)
             RETURNING g_ooo.ooo11,g_ooo.ooo03
     END IF
     #No.MOD-740358  --End  
     LET g_ooo.ooo12 = '1'    #FUN-CA0111
     INSERT INTO ooo_file VALUES (g_ooo.*)
     #No.MOD-740358  --Begin
     #多個科目對應同一科目時,INSERT會有重復問題
#    IF SQLCA.SQLCODE THEN   #genero
     ##NO.TQC-790100 START--------------------------
     ##IF SQLCA.sqlcode=-239 THEN
     IF cl_sql_dup_value(SQLCA.SQLCODE) THEN
     ##NO.TQC-790100 END----------------------------
        SELECT * INTO l_ooo.* FROM ooo_file
         WHERE ooo10 = g_ooo.ooo10
           AND ooo11 = g_ooo.ooo11
           AND ooo01 = g_ooo.ooo01
           AND ooo02 = g_ooo.ooo02
           AND ooo03 = g_ooo.ooo03
           AND ooo04 = g_ooo.ooo04
           AND ooo05 = g_ooo.ooo05
           AND ooo06 = g_ooo.ooo06
           AND ooo07 = g_ooo.ooo07
        IF SQLCA.sqlcode THEN
           LET g_showmsg = g_ooo.ooo10,"/",g_ooo.ooo11,"/",g_ooo.ooo01,"/",
                           g_ooo.ooo02,"/",g_ooo.ooo03,"/",g_ooo.ooo04,"/",
                           g_ooo.ooo05,"/",g_ooo.ooo06,"/",g_ooo.ooo07
           CALL s_errmsg("ooo10,ooo11,ooo01,ooo02,ooo03,ooo04,ooo05,ooo06,ooo07",g_showmsg,"select ooo",SQLCA.sqlcode,1)
           LET g_success = 'N'
           CONTINUE FOREACH
        END IF
        IF cl_null(l_ooo.ooo08d) THEN LET l_ooo.ooo08d = 0 END IF
        IF cl_null(l_ooo.ooo08c) THEN LET l_ooo.ooo08c = 0 END IF
        IF cl_null(l_ooo.ooo09d) THEN LET l_ooo.ooo09d = 0 END IF
        IF cl_null(l_ooo.ooo09c) THEN LET l_ooo.ooo09c = 0 END IF
        IF cl_null(g_ooo.ooo08d) THEN LET g_ooo.ooo08d = 0 END IF
        IF cl_null(g_ooo.ooo08c) THEN LET g_ooo.ooo08c = 0 END IF
        IF cl_null(g_ooo.ooo09d) THEN LET g_ooo.ooo09d = 0 END IF
        IF cl_null(g_ooo.ooo09c) THEN LET g_ooo.ooo09c = 0 END IF
        LET l_ooo.ooo08d = l_ooo.ooo08d + g_ooo.ooo08d
        LET l_ooo.ooo08c = l_ooo.ooo08c + g_ooo.ooo08c
        LET l_ooo.ooo09d = l_ooo.ooo09d + g_ooo.ooo09d
        LET l_ooo.ooo09c = l_ooo.ooo09c + g_ooo.ooo09c
        IF l_ooo.ooo08d - l_ooo.ooo08c > 0 THEN 
           LET l_ooo.ooo08d = l_ooo.ooo08d -l_ooo.ooo08c LET g_ooo.ooo08c=0
        ELSE 
           LET l_ooo.ooo08c = l_ooo.ooo08c -l_ooo.ooo08d LET g_ooo.ooo08d=0
        END IF
        IF l_ooo.ooo09d - l_ooo.ooo09c > 0 THEN 
           LET l_ooo.ooo09d = l_ooo.ooo09d -l_ooo.ooo09c LET g_ooo.ooo09c=0
        ELSE 
           LET l_ooo.ooo09c = l_ooo.ooo09c -l_ooo.ooo09d LET g_ooo.ooo09d=0
        END IF
        UPDATE ooo_file SET ooo08d = l_ooo.ooo08d,
                            ooo08c = l_ooo.ooo08c,
                            ooo09d = l_ooo.ooo09d,
                            ooo09c = l_ooo.ooo09c
         WHERE ooo10 = g_ooo.ooo10
           AND ooo11 = g_ooo.ooo11
           AND ooo01 = g_ooo.ooo01
           AND ooo02 = g_ooo.ooo02
           AND ooo03 = g_ooo.ooo03
           AND ooo04 = g_ooo.ooo04
           AND ooo05 = g_ooo.ooo05
           AND ooo06 = g_ooo.ooo06
           AND ooo07 = g_ooo.ooo07
        IF SQLCA.sqlcode <> 0 THEN
           LET g_showmsg = g_ooo.ooo10,"/",g_ooo.ooo11,"/",g_ooo.ooo01,"/",
                           g_ooo.ooo02,"/",g_ooo.ooo03,"/",g_ooo.ooo04,"/",
                           g_ooo.ooo05,"/",g_ooo.ooo06,"/",g_ooo.ooo07
           CALL s_errmsg("ooo10,ooo11,ooo01,ooo02,ooo03,ooo04,ooo05,ooo06,ooo07",g_showmsg,"update ooo",SQLCA.sqlcode,1)
           LET g_success='N' 
           CONTINUE FOREACH
        END IF
     ELSE
        IF SQLCA.sqlcode <> 0 THEN
           #No.MOD-740358  --Begin
           LET g_showmsg = g_ooo.ooo10,"/",g_ooo.ooo11,"/",g_ooo.ooo01,"/",
                           g_ooo.ooo02,"/",g_ooo.ooo03,"/",g_ooo.ooo04,"/",
                           g_ooo.ooo05,"/",g_ooo.ooo06,"/",g_ooo.ooo07
           CALL s_errmsg("ooo10,ooo11,ooo01,ooo02,ooo03,ooo04,ooo05,ooo06,ooo07",g_showmsg,"insert ooo",SQLCA.sqlcode,1)
           #No.MOD-740358  --End  
           LET g_success='N' 
        #No.FUN-710050--Begin--
        #  EXIT FOREACH
           CONTINUE FOREACH
        #No.FUN-710050--End--
        END IF
     END IF
     #No.MOD-740358  --End  
  END FOREACH
  #No.FUN-710050--Begin--                                                                                                             
          IF g_totsuccess="N" THEN                                                                                                         
              LET g_success="N"                                                                                                             
          END IF                                                                                                                           
  #No.FUN-710050--End--
 
  #ERROR ''             #No.FUN-570156
  #CALL cl_end(0,0)
END FUNCTION
