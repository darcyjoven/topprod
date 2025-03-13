# Prog. Version..: '5.30.06-13.04.17(00010)'     #
#
# Pattern name...: aimp379.4gl
# Descriptions...: 庫存雜發收廢異動過帳還原
# Date & Author..: 95/03/20 By Roger
# Modify.........: NO.FUN-4A0042 04/10/11 by Carol 異動單號開窗查詢
# Modify.........: No.FUN-540025 05/04/22 By Carrier  #雙單位修改
# Modify.........: No.FUN-550011 05/05/23 By kim GP2.0功能 庫存單據不同期要check庫存是否為負
# Modify.........: No.FUN-550029 05/05/30 By vivien 單據編號格式放大
# Modify.........: NO.FUN-550047 05/06/13 by Echo 過帳還原時，狀況更改為「0:開立」
# Modify.........: No.FUN-570036 05/07/06 By Carrier 拆箱
# Modify.........: No.FUN-570122 06/02/16 By yiting 增加背景執行作業功能
# Modify.........: NO.TQC-620156 06/03/10 By kim GP3.0過帳錯誤統整顯示功能新增
# Modify.........: NO.FUN-640266 06/04/26 BY yiting 更改cl_err
# Modify.........: No.FUN-660079 06/06/20 By kim GP3.1 增加確認碼欄位與處理
# Modify.........: NO.FUN-660156 06/06/22 By Tracy cl_err -> cl_err3
# Modify.........: No.FUN-690026 06/09/07 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-690115 06/10/13 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-6C0083 07/01/08 By Nicola 錯誤訊息彙整
# Modify.........: NO.TQC-790053 07/09/10 By lumxa 點“語言”，跳出一對話框“是否運行本作業”
# Modify.........: No.TQC-7B0031 07/11/06 By Carrier 過帳還原時,日期要即時清掉
# Modify.........: No.FUN-810036 08/01/16 By Nicola 序號管理
# Modify.........: No.FUN-830056 08/03/17 By bnlent ICD庫存過帳修改  
# Modify.........: No.MOD-840124 08/04/16 By Pengu DELETE FROM tlf_file時須在加入tlf905=ina01條件 
# Modify.........: No.MOD-840189 08/04/20 By Nicola 不做批/序號不刪除tlfs_file
# Modify.........: No.MOD-870222 08/07/17 By lumx  過賬還原時候將inb13,inb14清空
# Modify.........: No.FUN-8C0084 08/12/22 By jan s_upimg相關改以 料倉儲批為參數傳入 ,不使用 ROWID
# Modify.........: No.TQC-930155 09/03/30 By Sunyanchun Lock img_file,imgg_file時，若報錯，不要rollback ，要放g_success ='N'
# Modify.........: No.MOD-940166 09/05/25 By Pengu 過帳還原時不可清空扣帳日期
# Modify.........: No.FUN-940083 09/06/15 By shiwuying g_bgjob='Y'時，沒有給g_ina.*賦值
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-9C0290 09/12/19 By jan 過帳還原控管倉庫是否有設定『限定倉管員』
# Modify.........: No.FUN-9C0072 10/01/14 By vealxu 精簡程式碼
# Modify.........: No.FUN-A20044 10/03/23 By vealxu ima26x 調整
# Modify.........: No:FUN-8C0131 10/04/07 by dxfwo  過帳還原時的呆滯日期異動
# Modify.........: No:MOD-AA0066 10/10/13 by sabrina (1)在call p379_s1()前增加LET g_totsuccess='Y'
#                                                    (2)FUNCTION p379_p2()的BEGIN WORK要mark，否則會造成Transaction異常
# Modify.........: No:TQC-AC0216 10/12/17 by jan 由其他程式呼叫本程式時不應該有呼叫外掛程式的感覺
# Modify.........: No:MOD-B10126 11/01/18 by sabrina 背景執行在CALL p379_p2前先用g_ina.ina01抓取g_ina.*及u_flag的值
# Modify.........: No:FUN-AB0089 11/02/25 By shenyang  修改本月平均單價
# Modify.........: No:FUN-AC0074 11/04/19 By jan 過帳還原時備置量更新
# Modify.........: No:FUN-B50138 11/05/24 By jan p2()FUNCTIO拆分成獨立的sub routine
# Modify.........: NO.FUN-BC0062 12/02/15 By lilingyu 當成本計算方式czz28選擇了'6.移動加權平均成本'時,批次類作業不可運行
# Modify.........: NO:TQC-D30066 12/03/26 By lixh1 其他作業串接時更改提示信息apm-936
# Modify.........: No:TQC-D80002 13/08/02 By lixh1 修正報錯信息按鈕語言別顯示問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_ina            RECORD LIKE ina_file.*
DEFINE b_inb            RECORD LIKE inb_file.*
DEFINE g_wc,g_wc2,g_sql string                  #No.FUN-580092 HCN
DEFINE u_flag           LIKE type_file.num5     #No.FUN-690026 SMALLINT
DEFINE g_argv1          LIKE ina_file.ina01     #No.FUN-550029  #No.FUN-690026 VARCHAR(16)
DEFINE g_forupd_sql     STRING                  #SELECT ... FOR UPDATE SQL
DEFINE g_cnt            LIKE type_file.num10    #No.FUN-550025  #No.FUN-690026 INTEGER
DEFINE g_change_lang    LIKE type_file.chr1     #是否有做語言切換 No.FUN-570122  #No.FUN-690026 VARCHAR(1)
 
MAIN
   DEFINE l_flag        LIKE type_file.chr1    #No.FUN-570122  #No.FUN-690026 VARCHAR(1)
 
   OPTIONS                                 #改變一些系統預設值
        INPUT NO WRAP
   DEFER INTERRUPT                         #擷取中斷鍵, 由程式處理
 
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_argv1=ARG_VAL(1)
   LET g_bgjob = ARG_VAL(2)
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = 'N'
   END IF
   LET g_ina.ina01=g_argv1

  #TQC-AC0216--begin--調整以下程式段位置
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
  #TQC-AC0216--end----------------

#TQC-D80002 -------Begin-------
##TQC-D30066 ------Begin--------
#   SELECT * INTO g_ccz.* FROM ccz_file WHERE ccz00='0'
#   IF g_ccz.ccz28  = '6' AND NOT cl_null(g_ina.ina01) AND g_bgjob = 'Y' THEN
#      CALL cl_err('','apm-936',1)
#      EXIT PROGRAM
#   END IF
##TQC-D30066 ------End----------
##FUN-BC0062 --begin--
##  SELECT * INTO g_ccz.* FROM ccz_file WHERE ccz00='0'   #TQC-D30066 mark
#   IF g_ccz.ccz28  = '6' THEN
#      CALL cl_err('','apm-937',1)
#      EXIT PROGRAM
#   END IF
##FUN-BC0062 --end--
#TQC-D80002 -------End----------


   SELECT * INTO g_sma.* FROM sma_file WHERE sma00='0'
   IF NOT cl_null(g_ina.ina01) AND g_bgjob = 'Y' THEN
      SELECT * INTO g_ina.* FROM ina_file WHERE ina01=g_ina.ina01
      IF g_ina.ina00 MATCHES "[1256]" THEN
         LET u_flag=+1
      ELSE
         LET u_flag=-1
      END IF
   END IF
 
  #TQC-AC0216--begin--mark--
  #IF (NOT cl_user()) THEN
  #   EXIT PROGRAM
  #END IF
 
  #WHENEVER ERROR CALL cl_err_msg_log
 
  #IF (NOT cl_setup("AIM")) THEN
  #   EXIT PROGRAM
  #END IF
  #TQC-AC0216--end--mark-----

   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690115 BY dxfwo
 
WHILE TRUE
     LET g_success = 'Y'
     IF g_bgjob = 'N' THEN   
        CALL p379_p1()
        IF cl_sure(0,0) THEN
           BEGIN WORK
           CALL p379sub_p2(g_ina.ina01,u_flag)  #FUN-B50138
           CALL cl_end(0,0)
           IF g_success='Y' THEN
              COMMIT WORK
              CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
           ELSE
              ROLLBACK WORK
              CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
           END IF
           IF l_flag THEN
              CONTINUE WHILE
           ELSE
              CLOSE WINDOW p379_w
              EXIT WHILE
           END IF
        ELSE
           CONTINUE WHILE
        END IF
     ELSE
        BEGIN WORK
       #MOD-B10126---add---start---
       #SELECT * INTO g_ina.* FROM ina_file WHERE ina01=g_ina.ina01 #FUN-B50138
        IF g_ina.ina00 MATCHES "[1256]" THEN
           LET u_flag=+1
        ELSE
           LET u_flag=-1
        END IF
       #MOD-B10126---add---end---
        CALL p379sub_p2(g_ina.ina01,u_flag) #FUN-B50138
        IF g_success = "Y" THEN
           COMMIT WORK
        ELSE
           ROLLBACK WORK
        END IF
        CALL cl_batch_bg_javamail(g_success)
        EXIT WHILE
     END IF
 
END WHILE
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo
END MAIN
 
FUNCTION p379_p1()
DEFINE lc_cmd        LIKE type_file.chr1000 #No.FUN-570122  #No.FUN-690026 VARCHAR(500)
DEFINE p_row,p_col   LIKE type_file.num5    #No.FUN-570122  #No.FUN-690026 SMALLINT
 
 
   OPEN WINDOW p379_w AT p_row,p_col
       WITH FORM "aim/42f/aimp379" ATTRIBUTE (STYLE = g_win_style)
 
   CALL cl_ui_init()
#TQC-D80002 ------Begin--------
   SELECT * INTO g_ccz.* FROM ccz_file WHERE ccz00='0'
   IF g_ccz.ccz28  = '6' AND NOT cl_null(g_ina.ina01) AND g_bgjob = 'Y' THEN
      CLOSE WINDOW  p379_w
      CALL cl_err('','apm-936',1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   IF g_ccz.ccz28  = '6' THEN
      CLOSE WINDOW  p379_w
      CALL cl_err('','apm-937',1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
#TQC-D80002 ------End-----------
   LET g_bgjob = 'N'
 
 WHILE TRUE
   CALL cl_opmsg('z')
   INPUT BY NAME g_ina.ina01,g_bgjob WITHOUT DEFAULTS    #No.FUN-570122
 
     AFTER FIELD ina01
        SELECT * INTO g_ina.* FROM ina_file WHERE ina01=g_ina.ina01
        IF STATUS THEN
           CALL cl_err3("sel","ina_file",g_ina.ina01,"",SQLCA.sqlcode,"","sel ina",0)  #No.FUN-660156
           NEXT FIELD ina01
        END IF
        IF g_ina.inaconf='X' THEN #FUN-660079
           CALL cl_err('inaconf=X:','9024',0) NEXT FIELD ina01 #FUN-660079
        END IF
        IF g_ina.inapost='N' THEN
           CALL cl_err('inapost=N:','aim-206',0) NEXT FIELD ina01
        END IF
	IF g_sma.sma53 IS NOT NULL AND g_ina.ina02 <= g_sma.sma53 THEN
           CALL cl_err('','mfg9999',0) NEXT FIELD ina01
	END IF
        IF g_ina.ina00 MATCHES "[1256]" THEN
           LET u_flag=+1
        ELSE
           LET u_flag=-1
        END IF
 
 
     AFTER FIELD g_bgjob
          IF g_bgjob NOT MATCHES "[YN]"  OR cl_null(g_bgjob) THEN
             NEXT FIELD g_bgjob
          END IF
 
      ON ACTION CONTROLP
         CALL cl_init_qry_var()
         LET g_qryparam.form ="q_ina"
         CALL cl_create_qry() RETURNING g_ina.ina01
         DISPLAY BY NAME g_ina.ina01
         NEXT FIELD ina01
 
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
 
 
      ON ACTION locale
           LET g_change_lang = TRUE
           CALL cl_show_fld_cont()
           CALL cl_dynamic_locale()
           LET g_action_choice = "locale"
         EXIT INPUT
 
         BEFORE INPUT
             CALL cl_qbe_init()
 
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
   END INPUT
 
   IF g_action_choice = "locale" THEN
      LET g_action_choice = ""
      CONTINUE WHILE
   END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p378_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo
      EXIT PROGRAM
   END IF
 
   IF g_bgjob = "Y" THEN
      SELECT zz08 INTO lc_cmd FROM zz_file
         WHERE zz01 = "aimp379"
       IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
          CALL cl_err('aimp379','9031',1)
       ELSE
          LET lc_cmd = lc_cmd CLIPPED,
                       " '",g_ina.ina01 CLIPPED,"'",
                       " '",g_bgjob CLIPPED,"'"
          CALL cl_cmdat('aimp379',g_time,lc_cmd CLIPPED)
       END IF
       CLOSE WINDOW p379_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo
       EXIT PROGRAM
    END IF
    EXIT WHILE
 
 END WHILE
END FUNCTION
 
#No.FUN-A20044 ---mark---start
#FUNCTION p379_u_ima() #------------------------------------ Update ima_file
#    DEFINE l_ima26,l_ima261,l_ima262	LIKE ima_file.ima26
# 
#   IF g_bgjob = 'N' THEN
#      MESSAGE "u_ima!"
#   END IF
#    CALL ui.Interface.refresh()
#    LET l_ima26=0 LET l_ima261=0 LET l_ima262=0
#    SELECT SUM(img10*img21) INTO l_ima26  FROM img_file
#     WHERE img01=b_inb.inb04 AND img23='Y' AND img24='Y'
#    IF STATUS THEN
#       IF g_bgerr THEN
#          CALL s_errmsg('img01',b_inb.inb04,'sel sum1:',STATUS,1)
#       ELSE
#          CALL cl_err3("sel","img_file",b_inb.inb04,"",STATUS,"","sel sum1",1)   #NO.FUN-640266  #No.FUN-660156
#       END IF
#       LET g_success='N'
#    END IF
#    IF l_ima26 IS NULL THEN LET l_ima26=0 END IF
#    SELECT SUM(img10*img21) INTO l_ima261 FROM img_file
#     WHERE img01=b_inb.inb04 AND img23='N'
#    IF STATUS THEN #CALL cl_err('sel sum2:',STATUS,1) LET g_success='N' END IF
#       IF g_bgerr THEN
#          CALL s_errmsg('img01',b_inb.inb04,'sel sum2:',STATUS,1)
#       ELSE
#          CALL cl_err3("sel","img_file",b_inb.inb04,"",STATUS,"","sel sum2",1)   #NO.FUN-640266  #No.FUN-660156
#       END IF
#       LET g_success='N'
#    END IF
#    IF l_ima261 IS NULL THEN LET l_ima261=0 END IF
#    SELECT SUM(img10*img21) INTO l_ima262 FROM img_file
#     WHERE img01=b_inb.inb04 AND img23='Y'
#    IF STATUS THEN #CALL cl_err('sel sum3:',STATUS,1) LET g_success='N' END IF
#       IF g_bgerr THEN
#          CALL s_errmsg('img01',b_inb.inb04,'sel sum3:',STATUS,1)
#       ELSE
#          CALL cl_err3("sel","img_file",b_inb.inb04,"",STATUS,"","sel sum3",1)   #NO.FUN-640266 #No.FUN-660156
#       END IF
#       LET g_success='N'
#    END IF
#    IF l_ima262 IS NULL THEN LET l_ima262=0 END IF
#    UPDATE ima_file SET ima26=l_ima26,ima261=l_ima261,ima262=l_ima262
#     WHERE ima01= b_inb.inb04
#    IF STATUS THEN
#       IF g_bgerr THEN
#          CALL s_errmsg('img01',b_inb.inb04,'upd ima26*:',STATUS,1)
#       ELSE
#          CALL cl_err3("upd","ima_file",b_inb.inb04,"",STATUS,"","upd imia26*",1)   #NO.FUN-640266 #No.FUN-660156
#       END IF
#       LET g_success='N' RETURN
#    END IF
#    IF SQLCA.SQLERRD[3]=0 THEN
#       IF g_bgerr THEN
#          CALL s_errmsg('img01',b_inb.inb04,'upd ima26*:','mfg0177',1)
#       ELSE
#          CALL cl_err3("upd","ima_file",b_inb.inb04,"","mfg0177","","upd ima26*",1)   #NO.FUN-640266 #No.FUN-660156
#       END IF
#       LET g_success='N' RETURN
#    END IF
#END FUNCTION
#No.FUN-A20044---mark---end 
#No.FUN-9C0072 精簡程式碼
 
