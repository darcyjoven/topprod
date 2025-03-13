# Prog. Version..: '5.30.06-13.04.17(00010)'     #
#
# Pattern name...: aimp920.4gl
# Descriptions...: 盤點過帳還原作業
# Date & Author..: 97/06/23 By Melody
# Modify ........: No:9477 By Melody 04/04/21 1.p920_wip(),此段沒有 g_success初值給多及begin work 但有commit work /rollback work
#                                             2.p920_wip()及p920_stk()的foreach 失敗皆無判斷!!
# Modify.........: No.MOD-530179 05/03/22 By Mandy 將DEFINE 用DEC()方式的改成用LIKE方式
# Modify.........: No.MOD-530155 05/03/25 By kim 無法跳離票據別的欄位
# Modify.........: No.FUN-570082 05/07/19 By Carrier 多單位現有庫存盤點過帳還原
# Modify.........: No.FUN-5B0016 05/11/15 By Sarah DELETE tlf_file前,先檢查單據日期(tlf06)是否小於等於成本關帳日(sma53),若有則show訊息,不可還原
# Modify.........: No.FUN-570122 06/02/20 By yiting 背景執行
# Modify.........: NO.FUN-640266 06/04/26 BY yiting 更改cl_err
# Modify.........: NO.FUN-660156 06/06/23 By Tracy cl_err -> cl_err3 
# Modify.........: No.FUN-690026 06/09/07 By Carrier 欄位型態用LIKE定義
# Modify.........: No.TQC-6C0153 06/12/26 By Ray 語言功能無效
# Modify.........: No.MOD-750127 07/05/28 By pengu p920_stk()及p920_multi_unit()的處理應該包再同一個transaction
# Modify.........: No.TQC-760195 07/07/04 By Carol mark在製過帳還原回寫工單已發數/超領數的處理
# Modify.........: No.FUN-870051 08/07/26 By sherry 增加被替代料為Key值
# Modify.........: No.FUN-8A0147 08/12/15 By douzh 批序號-盤點調整更新imgs_file和tlfs_file從pias_file的資料中
# Modify.........: No.FUN-8C0084 08/12/22 By jan s_upimg相關改以 料倉儲批為參數傳入 ,不使用 ROWID 
# Modify.........: No.MOD-910204 09/01/17 By claire sfb93='Y' 不寫 tlf_file及sfa064
# Modify.........: No.TQC-930155 09/03/30 By Sunyanchun Lock img_file,imgg_file時，若報錯，不要rollback ，要放g_success ='N'
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowid定義規範化
# Modify.........: No.MOD-940075 09/05/25 By Pengu 無批序號管理但在過帳還原時會出現update pias失敗錯誤訊息
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-A10018 10/01/13 By Pengu 執行程式時會當掉
# Modify.........: No:FUN-8C0131 10/04/07 by dxfwo  過帳還原時的呆滯日期異動
# Modify.........: No.FUN-A60095 10/07/19 By kim GP5.25 平行工藝
# Modify.........: No.FUN-B30211 11/04/01By yangtingting   1、離開MAIN時沒有cl_used(1)和cl_used(2)
#                                                           2、未加離開前得cl_used(2)
# Modify.........: No.FUN-B40082 11/05/23 By jason 還原資料已關帳,不可還原、相關單據過帳還原、取消確認、刪除
# Modify.........: No.FUN-B70074 11/07/21 By fengrui 添加行業別表的新增於刪除(sfsi_file by lixh1)
# Modify.........: No:FUN-B70032 11/08/16 By jason 新增ICD刻號/BIN盤點過帳
# Modify.........: No.FUN-B80119 11/09/14 By fengrui  增加調用s_icdpost的p_plant參數
# Modify.........: No.FUN-BC0104 12/01/17 By xianghui 數量異動回寫qco20
# Modify.........: No:MOD-C20118 12/03/06 By ck2yuan 應該要只抓同樣的製造批序號.否則會多刪除
# Modify.........: No:MOD-C60026 12/06/07 By ck2yuan 當若沒資料則show mfg3442訊息
# Modify.........: No:FUN-C70014 12/07/09 By wangwei 新增RUN CARD發料作業
# Modify.........: No.MOD-C70062 12/07/09 By Sakura 還原時，需將發料數量也還原
# Modify.........: No.MOD-C80048 12/09/21 By Elise 排除未過帳標籤
# Modify.........: No.MOD-CC0209 12/12/26 By Elise mark CLOSE WINDOW p880_w
# Modify.........: No.FUN-BC0062 13/02/17 By fengrui 當成本計算方式czz28選擇了'6.移動加權平均成本'時,批次類作業不可運行

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD			 # Print condition RECORD
            wc   LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(400)
            a    LIKE type_file.chr1     #No.FUN-690026 VARCHAR(1)
           END RECORD, 
       l_buf     LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(400)
       l_i,l_j   LIKE type_file.num5     #No.FUN-690026 SMALLINT
DEFINE g_change_lang   LIKE type_file.chr1     #是否有做語言切換 No.FUN-570122  #No.FUN-690026 VARCHAR(1)
DEFINE g_cnt           LIKE type_file.num5     #FUN-5B0016 #No.FUN-690026 SMALLINT
DEFINE g_nofind_flag   LIKE type_file.chr1     #MOD-C60026 add
DEFINE g_forupd_sql    STRING
         
MAIN
DEFINE l_flag LIKE type_file.chr1    #FUN-570122  #No.FUN-690026 VARCHAR(1)

   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT			     # Supress DEL key function
 
   INITIALIZE g_bgjob_msgfile TO NULL
   LET tm.wc = ARG_VAL(1)
   LET tm.a = ARG_VAL(2)
   LET g_bgjob = ARG_VAL(3)
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
   #FUN-570122 ----End----
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
 
   IF s_shut(0) THEN EXIT PROGRAM END IF

   #FUN-BC0062 --begin--
   SELECT * INTO g_ccz.* FROM ccz_file WHERE ccz00='0'
   IF g_ccz.ccz28  = '6' THEN
      CALL cl_err('','apm-937',1)
      EXIT PROGRAM
   END IF
   #FUN-BC0062 --end-- 

   CALL cl_used(g_prog,g_time,1) RETURNING g_time      #FUN-B30211
  #FUN-570122 ----Start----
   WHILE TRUE
 
      LET g_success = 'Y'
      IF g_bgjob = 'N' THEN
         CALL p920_tm(0,0)                   # Input print condition
         IF cl_sure(0,0) THEN
            IF tm.a = '1' THEN
               CALL p920_stk()
              #---------------No.MOD-750127 mark
              #IF g_sma.sma115='Y' THEN
              #   CALL p920_multi_unit()
              #END IF
              #---------------No.MOD-750127 end
            ELSE
               LET l_buf=tm.wc
               LET l_j=length(l_buf) - 2   #No:MOD-A10018 modify
               FOR l_i=1 TO l_j
                  IF l_buf[l_i,l_i+2]='pia' THEN
                     LET l_buf[l_i,l_i+2]='pid'
                  END IF
               END FOR
               LET tm.wc = l_buf
               CALL p920_wip()
            END IF
            IF g_success='Y' THEN
               COMMIT WORK
               IF g_nofind_flag = 'Y' THEN             #MOD-C60026 add
                  CALL cl_end2(1) RETURNING l_flag     #批次作業正確結束
               ELSE                                    #MOD-C60026 add
                  LET l_flag = 'Y'                     #MOD-C60026 add
               END IF                                  #MOD-C60026 add
            ELSE
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
            END IF
 
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
              #CLOSE WINDOW p880_w   #MOD-CC0209 mark
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         IF tm.a = '1' THEN
            CALL p920_stk()
           #---------------No.MOD-750127 mark
           #IF g_sma.sma115='Y' THEN
           #   CALL p920_multi_unit()
           #END IF
           #---------------No.MOD-750127 end
         ELSE
            LET l_buf=tm.wc
            LET l_j=length(l_buf) - 2   #No:MOD-A10018 modify
            FOR l_i=1 TO l_j
               IF l_buf[l_i,l_i+2]='pia' THEN
                  LET l_buf[l_i,l_i+2]='pid'
               END IF
            END FOR
            LET tm.wc = l_buf
            CALL p920_wip()
         END IF
         IF g_success = "Y" THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
#NO.FUN-570122 END-------
  CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
END MAIN
 
FUNCTION p920_tm(p_row,p_col)
   DEFINE p_row,p_col	LIKE type_file.num5     #No.FUN-690026 SMALLINT
   DEFINE lc_cmd        LIKE type_file.chr1000  #No.FUN-570122 #No.FUN-690026 VARCHAR(500)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 16 END IF
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 4 LET p_col = 36
   ELSE
       LET p_row = 4 LET p_col = 16
   END IF
 
   OPEN WINDOW p920_w AT p_row,p_col
        WITH FORM "aim/42f/aimp920" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_opmsg('p')
 
   CALL cl_ui_init()  #MOD-530155  從while迴圈移出
 
 WHILE TRUE
   INITIALIZE tm.* TO NULL		          # Default condition
   LET tm.a = '1'
   LET g_bgjob = 'N'   #FUN-570122
   CONSTRUCT BY NAME tm.wc ON pia01 
 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
     ON ACTION locale
          #->No.FUN-570122--end---
       #  LET g_action_choice='locale'
       #  CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
          CALL cl_dynamic_locale()     #No.TQC-6C0153
          CALL cl_show_fld_cont()     #No.TQC-6C0153
          LET g_change_lang = TRUE
          #->No.FUN-570122--end---
         CONTINUE CONSTRUCT     #No.TQC-6C0153
#        CONTINUE WHILE
#        EXIT CONSTRUCT      #No.TQC-6C0153
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 #MOD-530155...........begin 
      ON ACTION exit
         LET INT_FLAG = 1
      EXIT CONSTRUCT
 #MOD-530155...........end
  
      #No.FUN-580031 --start--
      ON ACTION qbe_select
         CALL cl_qbe_select()
      #No.FUN-580031 ---end---
 
   END CONSTRUCT
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
   IF INT_FLAG THEN 
       LET INT_FLAG = 0 CLOSE WINDOW p920_w 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
       EXIT PROGRAM 
   END IF
 # END WHILE  #MOD-530155
 #MOD-530155..................begin
   IF tm.wc = " 1=1" THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
 #MOD-530155..................end
 
  #No.FUN-570122 ----Start----
  #INPUT BY NAME tm.a WITHOUT DEFAULTS
   INPUT BY NAME tm.a,g_bgjob WITHOUT DEFAULTS
  #No.FUN-570122 ----End----
 
      AFTER FIELD a
         IF tm.a NOT MATCHES "[12]" OR tm.a IS NULL THEN 
            NEXT FIELD a
         END IF
 
      #No.FUN-570122 ----Start----
      AFTER FIELD g_bgjob
          IF g_bgjob NOT MATCHES "[YN]"  OR cl_null(g_bgjob) THEN
              NEXT FIELD g_bgjob
          END IF
      #No.FUN-570122 ----End----
 
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
      ON ACTION CONTROLG CALL cl_cmdask()	# Command execution
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 #MOD-530155...........begin
      ON ACTION exit
         LET INT_FLAG = 1
      EXIT INPUT
 #MOD-530155...........end
   
      #No.FUN-580031 --start--
      ON ACTION qbe_save
         CALL cl_qbe_save()
      #No.FUN-580031 ---end---
 
   END INPUT
   IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW p920_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM END IF
#NO.FUN-570122 MARK--------------
#   IF NOT cl_sure(0,0) THEN CLOSE WINDOW p920_w RETURN END IF
#   CALL cl_wait()
#   IF tm.a = '1' THEN
#      CALL p920_stk() 
#      #No.FUN-570082  --begin
#      IF g_sma.sma115='Y' THEN
#         CALL p920_multi_unit()
#       END IF    
#      #No.FUN-570082  --end
#   ELSE
#      LET l_buf=tm.wc
#      LET l_j=length(l_buf)   
#      FOR l_i=1 TO l_j 
#          IF l_buf[l_i,l_i+2]='pia' THEN LET l_buf[l_i,l_i+2]='pid' END IF
#      END FOR
#      LET tm.wc = l_buf
#      CALL p920_wip()
#   END IF
#   ERROR ""
#   CALL cl_end(19,20) 
#   END WHILE  #MOD-530155
#   CLOSE WINDOW p920_w
#NO.FUN-570122 MARK----------------------
 
   #FUN-570122 ----Start----
   IF g_bgjob = "Y" THEN
      SELECT zz08 INTO lc_cmd FROM zz_file
        WHERE zz01 = "aimp920"
      IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
         CALL cl_err('aimp920','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET lc_cmd = lc_cmd CLIPPED,
                      " '",tm.wc CLIPPED,"'",
                      " '",tm.a CLIPPED,"'",
                      " '",g_bgjob CLIPPED,"'"
         CALL cl_cmdat('aimp920',g_time,lc_cmd CLIPPED)
      END IF
      CLOSE WINDOW p920_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
   END IF
  EXIT WHILE
 END WHILE  
#FUN-570122 ----End----
END FUNCTION
 
#--------- 1. Delete tlf_file    2. Update 過帳碼='N' -----------
FUNCTION p920_stk()
    DEFINE l_sql        LIKE type_file.chr1000  #No.FUN-690026 VARCHAR(600)
    DEFINE l_pia        RECORD LIKE pia_file.*,
           l_img23      LIKE img_file.img23,
           l_img24      LIKE img_file.img24,
           l_qty        LIKE img_file.img10     #MOD-530179
    DEFINE l_img01      LIKE img_file.img01     #No.TQC-930155
    DEFINE l_img02      LIKE img_file.img02     #No.TQC-930155 
    DEFINE l_img03      LIKE img_file.img03     #No.TQC-930155 
    DEFINE l_img04      LIKE img_file.img04     #No.TQC-930155  
    DEFINE l_ima01      LIKE ima_file.ima01     #No.TQC-930155
    DEFINE la_tlf  DYNAMIC ARRAY OF RECORD LIKE tlf_file.*  #NO.FUN-8C0131 
    DEFINE l_i     LIKE type_file.num5                      #NO.FUN-8C0131 

## No:2916 modify 1998/12/11 ----------------------------
 #  LET l_sql=" SELECT pia_file.*,img23,img24,(tlf10*tlf12) ",
    ##--------NO:3033  modify in 1999/03/10 -------------------#
    LET l_sql=" SELECT pia_file.*,img23,img24,",
              "   (tlf10*tlf12*tlf907) ",          #<----------#
              "   FROM pia_file,img_file,tlf_file",
              "   WHERE ",tm.wc CLIPPED,
              "     AND tlf13='aimp880'", 
              "     AND tlf01=pia02",    #料
              "     AND tlf902=pia03",   #倉
              "     AND tlf903=pia04",   #儲
              "     AND tlf904=pia05",   #批
              "     AND tlf905=pia01",   #標籤編號
              "     AND img01=pia02",    #料
              "     AND img02=pia03",   #倉
              "     AND img03=pia04",   #儲
              "     AND img04=pia05"    #批
    PREPARE p920_prepare1 FROM l_sql
    DECLARE p920_cs1 CURSOR FOR p920_prepare1
 
    BEGIN WORK
    LET g_success='Y'
    LET g_nofind_flag = 'N'      #MOD-C60026 add
    CALL s_showmsg_init() #FUN-B70032
 
    FOREACH p920_cs1 INTO l_pia.*,l_img23,l_img24,l_qty
       #No:9477
        IF SQLCA.sqlcode THEN
           CALL cl_err('p920_cs1',SQLCA.sqlcode,0)
           EXIT FOREACH
        END IF
       #No:9477
        IF g_bgjob = 'N' THEN   #FUN-570122
           MESSAGE l_pia.pia01
        END IF                           #FUN-570122
        CALL ui.Interface.refresh()
 
        #FUN-B70032 --START--       
        IF s_industry('icd') THEN
           IF NOT p920_uppiad(l_pia.pia01) THEN
              LET g_success='N' 
              LET g_showmsg=l_pia.pia01,"/",l_pia.pia02,"/",l_pia.pia03,"/",
                           l_pia.pia04,"/",l_pia.pia05 
              CALL s_errmsg('pia01,pia02,pia03,pia04,pia05 ',g_showmsg,'','mfg1604',1)              
           END IF 
        END IF
        #FUN-B70032 --END-- 
 
        UPDATE pia_file SET pia19='N' WHERE pia01=l_pia.pia01
        IF SQLCA.SQLERRD[3]=0 OR STATUS 
           THEN
           LET g_success='N'
           CALL cl_err3("upd","pia_file",l_pia.pia01,"",STATUS,"","upd pia",1)   #NO.FUN-640266  #No.FUN-660156
           EXIT FOREACH
        END IF

        LET g_forupd_sql = "SELECT img01,img02,img03,img04 FROM img_file ",                                                                
                    "  WHERE img01 = ? AND img02 = ? ",                                                                             
                    "   AND img03 = ? AND img04 = ? FOR UPDATE"                                                                     
        LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
        DECLARE img_lock CURSOR FROM g_forupd_sql  

        OPEN img_lock USING l_pia.pia02,l_pia.pia03,l_pia.pia04,l_pia.pia05     
        IF STATUS THEN                           
           CALL cl_err("OPEN img_lock:",STATUS,1)
           LET g_success = 'N'                 
           CLOSE img_lock                       
           EXIT FOREACH                          
        END IF                                     
        FETCH img_lock INTO l_img01,l_img02,l_img03,l_img04                 
        IF STATUS THEN                                                       
           CALL cl_err3("sel","img_file",l_pia.pia02,l_pia.pia03,SQLCA.sqlcode,"","sel img",1)           
           LET g_success = 'N'        
           CLOSE img_lock              
           EXIT FOREACH                 
        END IF                           
        #No.TQC-930155------end--------------
        #---->更新庫存明細檔
                       #1         #2  #3      #4     #5
         #CALL s_upimg(' ',2,l_qty*-1 ,g_today,l_pia.pia02, #FUN-8C0084
          CALL s_upimg(l_pia.pia02,l_pia.pia03,l_pia.pia04,l_pia.pia05,2,l_qty*-1 ,g_today,l_pia.pia02,#FUN-8C0084
                       #6          #7          #8
                       l_pia.pia03,l_pia.pia04,l_pia.pia05,
                       #9          #10  #11         #12
                       l_pia.pia01,'',  l_pia.pia09,l_qty,
                       #13         #14  #15         #16
                       l_pia.pia09,1  , l_pia.pia10,1,
                       #17         #18  #19         #20
                       l_pia.pia07,' ', ' ',' ',
                       #21         #22
                       l_pia.pia06,' ')
          IF g_success ='N' 
             THEN 
             EXIT FOREACH
          END IF
 
          CALL p920_upimgs(l_pia.pia01,l_qty*-1,g_today)
          IF g_success ='N' 
             THEN 
             EXIT FOREACH
          END IF
 
        LET g_forupd_sql = "SELECT ima01 FROM ima_file WHERE ima01 = ? FOR UPDATE"     
        LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
        DECLARE ima_lock CURSOR FROM g_forupd_sql 

        OPEN ima_lock USING l_pia.pia02 
        IF STATUS THEN                   
           CALL cl_err("OPEN ima_lock:",STATUS,1)    
           LET g_success = 'N'
           CLOSE ima_lock 
           EXIT FOREACH  
        END IF            
        FETCH ima_lock INTO l_ima01  
        IF STATUS THEN    
           CALL cl_err3("sel","ima_file",l_pia.pia02,'',SQLCA.sqlcode,"","sel ima",1)
           LET g_success = 'N'   
           CLOSE ima_lock 
           EXIT FOREACH    
        END IF  
        #No.TQC-930155--------------end--------
 
        IF s_udima(l_pia.pia02,              #料件編號
                   l_img23,                  #是否可用倉儲
                   l_img24,                  #是否為MRP可用倉儲
                   l_qty,                    #數量(換算為庫存單位)
                   g_today,                  #最近一次盤點日期
                   +2)                       #表盤點
           THEN LET g_success ='N'
                EXIT FOREACH
           END IF
 
       #start FUN-5B0016
        SELECT count(*) INTO g_cnt FROM tlf_file
         WHERE tlf13 ='aimp880'
           AND tlf01 =l_pia.pia02   #料
           AND tlf902=l_pia.pia03   #倉
           AND tlf903=l_pia.pia04   #儲
           AND tlf904=l_pia.pia05   #批
           AND tlf905=l_pia.pia01   #標籤編號
           AND tlf06<=g_sma.sma53   #單據日期<=成本關帳日
        IF SQLCA.sqlcode OR cl_null(g_cnt) THEN LET g_cnt = 0 END IF
        IF g_cnt > 0 THEN
           CALL cl_err(l_pia.pia01,'aim-881',1)   #還原資料已關帳,不可還原!
           LET g_success='N'
           EXIT FOREACH
        END IF
       #end FUN-5B0016

  ##NO.FUN-8C0131   add--begin   
    LET l_sql =  " SELECT  * FROM tlf_file ", 
                 "  WHERE  tlf13='aimp880' AND tlf01 = '",l_pia.pia02,"'",
                 "    AND tlf902='",l_pia.pia03,"' AND tlf903='",l_pia.pia04,"' ",
                 "    AND tlf904='",l_pia.pia05,"' AND tlf905='",l_pia.pia01,"'"
    DECLARE p920_u_tlf_c CURSOR FROM l_sql
    LET l_i = 0 
    CALL la_tlf.clear()
    FOREACH p920_u_tlf_c INTO g_tlf.*
       LET l_i = l_i + 1
       LET la_tlf[l_i].* = g_tlf.*
    END FOREACH     

  ##NO.FUN-8C0131   add--end 
 
        DELETE FROM tlf_file WHERE tlf13='aimp880' 
                               AND tlf01=l_pia.pia02    #料
                               AND tlf902=l_pia.pia03   #倉
                               AND tlf903=l_pia.pia04   #儲
                               AND tlf904=l_pia.pia05   #批
                               AND tlf905=l_pia.pia01   #標籤編號
       #No.+035 010329 by plum modi
       #IF STATUS THEN
        IF SQLCA.sqlcode THEN
           LET g_success='N'
#           CALL cl_err('upd pia',SQLCA.SQLCODE,1)
           CALL cl_err3("del","tlf_file",l_pia.pia02,"",SQLCA.SQLCODE,"","upd pia",1)   #NO.FUN-640266  #No.FUN-660156
           EXIT FOREACH
        END IF
       #No.+035..end
  ##NO.FUN-8C0131   add--begin
    FOR l_i = 1 TO la_tlf.getlength()
       LET g_tlf.* = la_tlf[l_i].*
       IF NOT s_untlf1('') THEN 
          LET g_success='N' RETURN
       END IF 
    END FOR       
  ##NO.FUN-8C0131   add--end 
#No.FUN-8A0147--begin
        DELETE FROM tlfs_file WHERE tlfs01=l_pia.pia02   #料
                                AND tlfs02=l_pia.pia03   #倉
                                AND tlfs03=l_pia.pia04   #儲
                                AND tlfs04=l_pia.pia05   #批
                                AND tlfs10=l_pia.pia01   #標籤編號
        IF SQLCA.sqlcode THEN
           LET g_success='N'
           CALL cl_err3("del","tlfs_file",l_pia.pia02,"",SQLCA.SQLCODE,"","upd pia",1)  
           EXIT FOREACH
        END IF
#No.FUN-8A0147--end
        LET g_nofind_flag = 'Y'       #MOD-C60026 add
    END FOREACH 
 
   #---------------No.MOD-750127 add
   #還原多單位資料
    IF g_sma.sma115='Y' THEN
       CALL p920_multi_unit()
    END IF
   #---------------No.MOD-750127 end
 
    IF g_success = 'Y'
       THEN 
       COMMIT WORK
       IF g_nofind_flag='Y' THEN         #MOD-C60026 add
          CALL cl_cmmsg(4) 
       ElSE                              #MOD-C60026 add
          CALL cl_err('','mfg3442',1)    #MOD-C60026 add
       END IF                            #MOD-C60026 add
    ELSE 
       ROLLBACK WORK
       CALL cl_rbmsg(4) 
    END IF
 
END FUNCTION 
    
#No.FUN-8A0147--begin
FUNCTION p920_upimgs(p_pia01,p_qty,p_date)
DEFINE p_pia01  LIKE pia_file.pia01
DEFINE p_qty    LIKE imgs_file.imgs08    
DEFINE p_date   LIKE imgs_file.imgs09   
DEFINE l_pias   RECORD LIKE pias_file.*  
DEFINE l_imgs   RECORD LIKE imgs_file.*  
DEFINE l_sql    STRING
DEFINE l_imgs08 LIKE imgs_file.imgs08
DEFINE l_tlfs09 LIKE tlfs_file.tlfs09
DEFINE l_tlfs13 LIKE tlfs_file.tlfs13
 
 
   IF g_success = "N" THEN
      RETURN
   END IF
 
   LET l_imgs.imgs08 = NULL
   
      LET l_sql = "SELECT * FROM pias_file ",
                  " WHERE pias01 = '",p_pia01,"' " 
      
      PREPARE pias1_pre FROM l_sql
      DECLARE pias1_cs CURSOR FOR pias1_pre
      
      FOREACH pias1_cs INTO l_pias.*
         IF STATUS THEN 
            IF g_bgerr THEN 
               CALL s_errmsg('','','foreach:',STATUS,1)
            ELSE
               CALL cl_err('foreach:',STATUS,1)
            END IF
            EXIT FOREACH
         END IF
       #-------No.MOD-940075 add
        UPDATE pias_file SET pias19='N' WHERE pias01=l_pias.pias01
        IF SQLCA.SQLERRD[3]=0 OR STATUS
           THEN
           LET g_success='N'
           CALL cl_err3("upd","pias_file",l_pias.pias01,"",STATUS,"","upd pias",1)
           EXIT FOREACH
        END IF
       #-------No.MOD-940075 end
         
         LET l_sql = "SELECT tlfs09,tlfs13 FROM tlfs_file ",
                     " WHERE tlfs01 = '",l_pias.pias02,"' ",
                     " AND tlfs02 = '",l_pias.pias03,"' ",
                     " AND tlfs03 = '",l_pias.pias04,"' ",
                     " AND tlfs04 = '",l_pias.pias05,"' ",
                     " AND tlfs05 = '",l_pias.pias06,"' ",
                     " AND tlfs06 = '",l_pias.pias07,"' ",    #MOD-C20118  add
                     " AND tlfs10 = '",l_pias.pias01,"' " 
         
         PREPARE tlfs1_pre FROM l_sql
         DECLARE tlfs1_cs CURSOR FOR tlfs1_pre
         
         FOREACH tlfs1_cs INTO l_tlfs09,l_tlfs13
             IF STATUS THEN 
                IF g_bgerr THEN 
                   CALL s_errmsg('','','foreach:',STATUS,1)
                ELSE
                   CALL cl_err('foreach:',STATUS,1)
                END IF
                EXIT FOREACH
             END IF
 
             LET l_imgs.imgs01 = l_pias.pias02
             LET l_imgs.imgs02 = l_pias.pias03
             LET l_imgs.imgs03 = l_pias.pias04
             LET l_imgs.imgs04 = l_pias.pias05
             LET l_imgs.imgs05 = l_pias.pias06
             LET l_imgs.imgs06 = l_pias.pias07
             LET l_imgs.imgs07 = l_pias.pias10
             LET l_imgs.imgs09 = p_date
             LET l_imgs.imgs10 = ''
             LET l_imgs.imgs11 = ' '
    
             LET l_imgs.imgs08 = NULL
          
             SELECT imgs08 INTO l_imgs.imgs08
               FROM imgs_file
              WHERE imgs01 = l_imgs.imgs01
                AND imgs02 = l_imgs.imgs02
                AND imgs03 = l_imgs.imgs03
                AND imgs04 = l_imgs.imgs04
                AND imgs05 = l_imgs.imgs05
                AND imgs06 = l_imgs.imgs06
                AND imgs11 = l_imgs.imgs11
             
             IF STATUS != 100 THEN
                IF STATUS OR l_imgs.imgs08 IS NULL THEN
                   LET g_success='N'
                   IF g_bgerr THEN
                      CALL s_errmsg('ima01',l_imgs.imgs01,'imgs_file','asf-375',1)
                   ELSE
                      CALL cl_err('imgs_file','asf-375',1)
                   END IF
                   RETURN
                END IF 
             END IF
 
             IF l_tlfs09 ='1' THEN
                 LET l_imgs08 = l_imgs.imgs08 - l_tlfs13
             ELSE
                 LET l_imgs08 = l_imgs.imgs08 + l_tlfs13
             END IF
 
             UPDATE imgs_file
                SET imgs08=l_imgs08            #庫存數量
              WHERE imgs01 = l_imgs.imgs01
                AND imgs02 = l_imgs.imgs02
                AND imgs03 = l_imgs.imgs03
                AND imgs04 = l_imgs.imgs04
                AND imgs05 = l_imgs.imgs05
                AND imgs06 = l_imgs.imgs06
                AND imgs11 = l_imgs.imgs11
             
             IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
                LET g_success='N' 
                IF g_bgerr THEN
                   CALL s_errmsg('ima01',l_imgs.imgs01,'del imgs','asf-375',1)
                ELSE
                   CALL cl_err('del imgs','asf-375',1)
                END IF
                RETURN
             END IF
         END FOREACH
      END FOREACH
 
 
END FUNCTION 
#No.FUN-8A0147--end
 
FUNCTION p920_wip()
    DEFINE l_sql    LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(300)
    DEFINE l_pie    RECORD LIKE pie_file.*
    DEFINE l_pid    RECORD LIKE pid_file.*
    DEFINE l_sfb93  LIKE sfb_file.sfb93    #MOD-910204 add
    DEFINE la_tlf   DYNAMIC ARRAY OF RECORD LIKE tlf_file.*  #NO.FUN-8C0131 
    DEFINE l_i      LIKE type_file.num5                      #NO.FUN-8C0131
    DEFINE l_sfp01  LIKE sfp_file.sfp01, #FUN-B40082
           l_sfp06  LIKE sfp_file.sfp06  #FUN-B40082
    DEFINE l_sfb28  LIKE sfb_file.sfb28  #FUN-B40082    
    DEFINE l_ina01  LIKE ina_file.ina01  #FUN-B40082               
    DEFINE l_prog   LIKE type_file.chr20 #FUN-B40082  
    DEFINE l_flag   LIKE type_file.chr30 #FUN-B40082
    DEFINE l_flag2  LIKE type_file.chr30 #FUN-B40082
    DEFINE p_flag   LIKE type_file.num5  #FUN-B40082
     
   #LET l_sql=" SELECT pie_file.*,pid_file.* FROM pie_file,pid_file", #MOD-C70062 mark
    LET l_sql=" SELECT pid_file.* FROM pid_file",                     #MOD-C70062 add
              "    WHERE ",tm.wc CLIPPED                              #MOD-C70062 add
             #"    WHERE pid01=pie01 AND ",tm.wc CLIPPED              #MOD-C70062 mark
    PREPARE p920_prepare2 FROM l_sql
    DECLARE p920_cs2 CURSOR FOR p920_prepare2
 
    #No:9477
    BEGIN WORK
    LET g_success='Y'
    #No:9477
    LET g_nofind_flag = 'N'      #MOD-C60026 add 
   #FOREACH p920_cs2 INTO l_pie.*,l_pid.* #MOD-C70062 mark
    FOREACH p920_cs2 INTO l_pid.*         #MOD-C70062 add
       #No:9477
        IF SQLCA.sqlcode THEN
           CALL cl_err('p920_cs2',SQLCA.sqlcode,0)
           EXIT FOREACH
        END IF
       #No:9477
       
        #FUN-A60095(S)
       #IF l_pie.piedate <= g_sma.sma53 THEN
       #   CALL cl_err(l_pie.pie01,'aim-881',1)   #還原資料已關帳,不可還原!
       #   LET g_success='N'
       #   EXIT FOREACH        
       #END IF
        #FUN-A60095(E)
      
       #FUN-B40082 --START--
#程式搬移至單身FOREACH處理
#MOD-C70062---mark---START
#      IF l_pie.piedate <= g_sma.sma53 THEN
#         CALL cl_err(l_pie.pie01,'aim-881',1)   #還原資料已關帳,不可還原!
#         LET g_success='N'
#         EXIT FOREACH
#      END IF
#MOD-C70062---mark-----END

       SELECT sfb28 INTO l_sfb28 FROM sfb_file
          WHERE sfb01 = l_pid.pid02 
       IF SQLCA.sqlcode THEN
          CALL cl_err('p920_cs2',SQLCA.sqlcode,0)
          EXIT FOREACH
       END IF        
       IF NOT cl_null(l_sfb28) THEN
          CALL cl_err(l_pid.pid02,'aim-886',1)   #工單資料已結案,不可還原!
          LET g_success='N'
          EXIT FOREACH
       END IF                 
       #FUN-B40082 --END-- 
        
#程式搬移至單身FOREACH處理
#MOD-C70062---mark---START
#       UPDATE pie_file SET pie16='N' ,
#                           piedate = NULL   #FUN-A60095
#                     WHERE pie01=l_pie.pie01
#                       AND pie07=l_pie.pie07
#       IF sqlca.sqlcode OR sqlca.sqlerrd[3] = 0 THEN
#          LET g_success='N'
##         CALL cl_err('UPDATE pie_file:',SQLCA.SQLCODE,1)
#          CALL cl_err3("upd","pie_file",l_pie.pie01,l_pie.pie07,SQLCA.SQLCODE,"","UPDATE pie_file:",1)   #NO.FUN-640266 #No.FUN-660156
#          EXIT FOREACH
#       END IF
#MOD-C70062---mark-----END
 
       #FUN-A60095 mark(S)
       ##start FUN-5B0016
       # SELECT count(*) INTO g_cnt FROM tlf_file
       #  WHERE tlf13 = 'aimp880'
       #    AND tlf01 = l_pie.pie02
       #    AND ( (tlf02  = 60 AND tlf03  =  0 AND tlf026 = l_pid.pid02 AND
       #           tlf036 = l_pie.pie01 AND tlf037 = l_pie.pie07) OR
       #          (tlf02  = 0  AND tlf03  = 60 AND tlf036 = l_pid.pid02 AND
       #           tlf026 = l_pie.pie01 AND tlf027 = l_pie.pie07))
       #    AND tlf06<=g_sma.sma53   #單據日期<=成本關帳日
       # IF SQLCA.sqlcode OR cl_null(g_cnt) THEN LET g_cnt = 0 END IF
       # IF g_cnt > 0 THEN
       #    CALL cl_err(l_pie.pie01,'aim-881',1)   #還原資料已關帳,不可還原!
       #    LET g_success='N'
       #    EXIT FOREACH
       # END IF
       ##end FUN-5B0016
       #FUN-A60095 mark(E)

#MOD-C70062---add---START
       LET l_sql=" SELECT pie_file.* FROM pie_file,pid_file",
                 "  WHERE pid01=pie01 ",
                 "    AND pie16= 'Y' AND ",tm.wc CLIPPED  #MOD-C80048 add pie16
       PREPARE p920_prepare3 FROM l_sql
       DECLARE p920_cs3 CURSOR FOR p920_prepare3
       FOREACH p920_cs3 INTO l_pie.*
           IF l_pie.piedate <= g_sma.sma53 THEN
              CALL cl_err(l_pie.pie01,'aim-881',1)   #還原資料已關帳,不可還原!
              LET g_success='N'
              EXIT FOREACH
           END IF
           UPDATE pie_file SET pie16='N' ,
                               piedate = NULL   #FUN-A60095
                         WHERE pie01=l_pie.pie01
                           AND pie07=l_pie.pie07
           IF sqlca.sqlcode OR sqlca.sqlerrd[3] = 0 THEN
              LET g_success='N'
#              CALL cl_err('UPDATE pie_file:',SQLCA.SQLCODE,1)
              CALL cl_err3("upd","pie_file",l_pie.pie01,l_pie.pie07,SQLCA.SQLCODE,"","UPDATE pie_file:",1)   #NO.FUN-640266 #No.FUN-660156
              EXIT FOREACH
           END IF
           IF g_sma.sma542='Y' THEN  #FUN-B40082
#            UPDATE sfa_file SET sfa06 = l_pie.pie12, #已發量  #TQC-760195 mark
#                                sfa062= l_pie.pie13, #超領量  #TQC-760195 mark
             UPDATE sfa_file SET sfa064= 0            #虧損量  #TQC-760195 modify
             WHERE  sfa01  = l_pid.pid02  #工單號碼
               AND  sfa03  = l_pie.pie02  #料件編號
               AND  sfa08  = l_pie.pie03  #作業序號
               AND  sfa12  = l_pie.pie04  #發料單位
               AND  sfa012 = l_pie.pie012 #FUN-A60095
               AND  sfa013 = l_pie.pie013 #FUN-A60095
               AND  sfa27  = l_pie.pie900 #FUN-A60095
           #FUN-B40082(S)
           ELSE
             UPDATE sfa_file SET sfa064= 0           #虧損量  #TQC-760195 modify
             WHERE  sfa01  = l_pid.pid02  #工單號碼
               AND  sfa03  = l_pie.pie02  #料件編號
               AND  sfa08  = l_pie.pie03  #作業序號
               AND  sfa12  = l_pie.pie04  #發料單位
               AND  sfa27  = l_pie.pie900 #FUN-A60095
           END IF
           #FUN-B40082(E)
           IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
              LET g_success='N'
#              CALL cl_err('UPDATE sfa_file:',SQLCA.SQLCODE,1)
              CALL cl_err3("upd","sfa_file",l_pid.pid02,l_pie.pie02,SQLCA.SQLCODE,"",
                           "UPDATE sfa_file",1)   #NO.FUN-640266 #No.FUN-660156
              EXIT FOREACH
           END IF
       END FOREACH       
#MOD-C70062---add-----END

      #FUN-B40082 --START--      
      LET l_prog = g_prog
      FOR l_i = 0 TO 1         
         IF l_i = 0 THEN  #庫存會增加的類型先作
            LET l_flag = "'1','2','3','4','D'"      #FUN-C70014 add 'D'
            LET l_flag2 = "'1'"
            LET p_flag = 1
         ELSE 
            LET l_flag = "'6','7','8','9'"
            LET l_flag2 = "'3'"
            LET p_flag = -1
         END IF           
         #l.發料還原 2.退料還原
         LET l_sql=" SELECT UNIQUE sfp01,sfp06 FROM sfp_file",
                    " WHERE sfp14 = '", l_pie.pie01,"'",
                    " AND sfp06 IN (", l_flag, ")"
         PREPARE p920_pre_z1 FROM l_sql
         DECLARE p920_cs_z1 CURSOR FOR p920_pre_z1      
         FOREACH p920_cs_z1 INTO l_sfp01,l_sfp06
            IF l_sfp01 IS NULL THEN CONTINUE FOREACH END IF 
            IF NOT p920_sfp_z(l_sfp01,l_sfp06) THEN      
               EXIT FOREACH 
            END IF
         END FOREACH
         LET g_prog = l_prog
         IF g_success = 'N' THEN EXIT FOREACH END IF

         #1.雜發還原 2.雜收還原
         LET l_sql=" SELECT UNIQUE ina01 FROM ina_file",
                    " WHERE ina10 = '", l_pie.pie01,"'",
                    " AND ina00 IN (", l_flag2 ,")"
         PREPARE p920_pre_z2 FROM l_sql
         DECLARE p920_cs_z2 CURSOR FOR p920_pre_z2
         FOREACH p920_cs_z2 INTO l_ina01
            IF l_ina01 IS NULL THEN CONTINUE FOREACH END IF 
            IF NOT p920_ina_z(l_ina01,p_flag) THEN      
               EXIT FOREACH
            END IF
         END FOREACH
         IF g_success = 'N' THEN EXIT FOREACH END IF
      END FOR                
      #FUN-B40082 --END--
      
      #FUN-6A0095 mark(S)  
      ##MOD-910204-begin-add
      #SELECT sfb93 INTO l_sfb93 FROM sfb_file,sfa_file
      # WHERE sfa01 = l_pid.pid02 AND sfa03 = l_pie.pie02
      #   AND sfa08 = l_pie.pie03 AND sfa12 = l_pie.pie04
      #   AND sfa01 = sfb01
      #   AND sfa012 = l_pie.pie012  #FUN-A60095
      #   AND sfa013 = l_pie.pie013  #FUN-A60095
      #   AND sfa27  = l_pie.pie900  #FUN-A60095
      ##MOD-910204-end-add
      #FUN-6A0095 mark(E)  
      #IF l_sfb93 != 'Y'  THEN #MOD-910204 add #FUN-A60095 mark
        #------------ NO:0384 modify in 99/07/08 -------------------------#
#FUN-A60095 mark(S)
# ##NO.FUN-8C0131   add--begin   
#    LET l_sql =  " SELECT  * FROM tlf_file ", 
#                 "  WHERE tlf13 = 'aimp880' AND  tlf01 = '",l_pie.pie02,"'",
#                 "    AND ((tlf02  = 60 AND tlf03 = 0 AND tlf026='",l_pid.pid02,"'",
#                 "    AND tlf036='",l_pie.pie01,"' ANDtlf037 = '",l_pid.pid07,"') OR ",
#                 "        (tlf02  = 0 AND tlf03  = 60 AND tlf036='",l_pid.pid02,"' AND tlf026='",l_pie.pie01,"'",
#                 "         AND tlf027 = '",l_pie.pie07,"')) "   
#    DECLARE p920_u_tlf_c1 CURSOR FROM l_sql
#    LET l_i = 0 
#    CALL la_tlf.clear()
#    FOREACH p920_u_tlf_c1 INTO g_tlf.*
#       LET l_i = l_i + 1
#       LET la_tlf[l_i].* = g_tlf.*
#    END FOREACH     
#
#  ##NO.FUN-8C0131   add--end  
#        DELETE FROM tlf_file
#         WHERE tlf13 = 'aimp880' 
#           AND tlf01 = l_pie.pie02
#           AND ( (tlf02  = 60 AND tlf03  =  0 AND tlf026 = l_pid.pid02 AND 
#                  tlf036 = l_pie.pie01 AND tlf037 = l_pie.pie07) OR 
#                 (tlf02  = 0  AND tlf03  = 60 AND tlf036 = l_pid.pid02 AND
#                  tlf026 = l_pie.pie01 AND tlf027 = l_pie.pie07))
# 
#        IF sqlca.sqlcode OR sqlca.sqlerrd[3] = 0 THEN
#           LET g_success='N'
##           CALL cl_err('DELETE tlf_file:',SQLCA.SQLCODE,1)
#           CALL cl_err3("del","tlf_file",l_pie.pie02,"",STATUS,"","DELETE tlf_file",1)   #NO.FUN-640266  #No.FUN-660156
#           EXIT FOREACH
#        END IF
#
#  ##NO.FUN-8C0131   add--begin
#       FOR l_i = 1 TO la_tlf.getlength()
#          LET g_tlf.* = la_tlf[l_i].*
#          IF NOT s_untlf1('') THEN 
#             LET g_success='N' RETURN
#          END IF 
#       END FOR       
#  ##NO.FUN-8C0131   add--end
#FUN-A60095 mark(E)

#程式搬移至過帳還原之前
#MOD-C70062---mark---START
#      IF g_sma.sma542='Y' THEN  #FUN-B40082
##       UPDATE sfa_file SET sfa06 = l_pie.pie12, #已發量  #TQC-760195 mark
##                           sfa062= l_pie.pie13, #超領量  #TQC-760195 mark
#        UPDATE sfa_file SET sfa064= 0            #虧損量  #TQC-760195 modify
#        WHERE  sfa01  = l_pid.pid02  #工單號碼
#          AND  sfa03  = l_pie.pie02  #料件編號
#          AND  sfa08  = l_pie.pie03  #作業序號
#          AND  sfa12  = l_pie.pie04  #發料單位
#          AND  sfa012 = l_pie.pie012 #FUN-A60095
#          AND  sfa013 = l_pie.pie013 #FUN-A60095           
#          AND  sfa27  = l_pie.pie900 #FUN-A60095      
#      #FUN-B40082(S)
#      ELSE
#        UPDATE sfa_file SET sfa064= 0,           #虧損量  #TQC-760195 modify
#        WHERE  sfa01  = l_pid.pid02  #工單號碼
#          AND  sfa03  = l_pie.pie02  #料件編號
#          AND  sfa08  = l_pie.pie03  #作業序號
#          AND  sfa12  = l_pie.pie04  #發料單位
#          AND  sfa27  = l_pie.pie900 #FUN-A60095      
#      END IF
#      #FUN-B40082(E)
#       IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#          LET g_success='N'
##         CALL cl_err('UPDATE sfa_file:',SQLCA.SQLCODE,1)
#          CALL cl_err3("upd","sfa_file",l_pid.pid02,l_pie.pie02,SQLCA.SQLCODE,"",
#                       "UPDATE sfa_file",1)   #NO.FUN-640266 #No.FUN-660156
#          EXIT FOREACH
#       END IF
#       #---------------------------------------------------------------#
#     #END IF #MOD-910204 add #FUN-A60095 mark
#MOD-C70062---mark-----END
       LET g_nofind_flag = 'Y'       #MOD-C60026 add
    END FOREACH 
    IF g_success = 'Y'
       THEN 
       COMMIT WORK
       IF g_nofind_flag='Y' THEN         #MOD-C60026 add
          CALL cl_cmmsg(4) 
       ElSE                              #MOD-C60026 add
          CALL cl_err('','mfg3442',1)    #MOD-C60026 add
       END IF                            #MOD-C60026 add
    ELSE 
       ROLLBACK WORK
       CALL cl_rbmsg(4) 
    END IF
END FUNCTION 
 
#No.FUN-570082  --begin
FUNCTION p920_multi_unit()
    DEFINE l_sql          LIKE type_file.chr1000  #No.FUN-690026 VARCHAR(600)
    DEFINE l_piaa         RECORD LIKE piaa_file.*,
           l_qty          LIKE imgg_file.imgg10,
           l_img09        LIKE img_file.img09,
           l_ima906       LIKE ima_file.ima906,
           l_ima907       LIKE ima_file.ima907,
           l_sw           LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
           l_factor       LIKE img_file.img21,
           lsb_wc         base.StringBuffer,
           ls_wc          STRING,
           l_imgg01       LIKE imgg_file.imgg01,    #No.TQC-930155                                                                  
           l_imgg02       LIKE imgg_file.imgg02,    #No.TQC-930155                                                                  
           l_imgg03       LIKE imgg_file.imgg03,    #No.TQC-930155                                                                  
           l_imgg04       LIKE imgg_file.imgg04,    #No.TQC-930155                                                                  
           l_imgg09       LIKE imgg_file.imgg09     #No.TQC-930155
 
    IF g_success = 'N' THEN RETURN END IF    #No.MOD-750127 add
    LET ls_wc=tm.wc CLIPPED                                                     
    LET lsb_wc=base.StringBuffer.create()                                      
    CALL lsb_wc.append(ls_wc.trim())                                           
    CALL lsb_wc.replace("pia","piaa",0)                                        
    LET ls_wc=lsb_wc.toString()        
 
    LET l_sql=" SELECT piaa_file.*,(tlff10*tlff907)",
              "   FROM piaa_file,imgg_file,tlff_file",
              "  WHERE ",ls_wc.trim(),
              "     AND tlff13 ='aimp880'", 
              "     AND tlff01 =piaa02",   #料
              "     AND tlff902=piaa03",   #倉
              "     AND tlff903=piaa04",   #儲
              "     AND tlff904=piaa05",   #批
              "     AND tlff905=piaa01",   #標籤編號
              "     AND tlff11 =piaa09",   #單位
              "     AND imgg01 =piaa02",   #料
              "     AND imgg02 =piaa03",   #倉
              "     AND imgg03 =piaa04",   #儲
              "     AND imgg04 =piaa05",   #批
              "     AND imgg09 =piaa09"    #單位
    PREPARE p920_pre1 FROM l_sql
    DECLARE p920_mcs1 CURSOR FOR p920_pre1
 
   #BEGIN WORK          #No.MOD-750127 mark
   #LET g_success='Y'   #No.MOD-750127 mark
 
    FOREACH p920_mcs1 INTO l_piaa.*,l_qty
        IF SQLCA.sqlcode THEN
           CALL cl_err('p920_cs1',SQLCA.sqlcode,0)
           EXIT FOREACH
        END IF
        IF g_bgjob = 'N' THEN   #FUN-570122
           MESSAGE l_piaa.piaa01 || ' ' || l_piaa.piaa09
        END IF                           #FUN-570122
        CALL ui.Interface.refresh()
 
        UPDATE piaa_file SET piaa19='N' 
         WHERE piaa01=l_piaa.piaa01 AND piaa09=l_piaa.piaa09
        IF SQLCA.SQLERRD[3]=0 OR STATUS THEN
           LET g_success='N'
#           CALL cl_err('upd piaa',SQLCA.SQLCODE,1)
           CALL cl_err3("upd","piaa_file",l_piaa.piaa01,l_piaa.piaa09,STATUS,"","upd piaa",1)   #NO.FUN-640266
           EXIT FOREACH
        END IF
 
        SELECT ima906,ima907 INTO l_ima906,l_ima907 FROM ima_file
         WHERE ima01=l_piaa.piaa02
        SELECT img09 INTO l_img09 FROM img_file
         WHERE img01=l_piaa.piaa02 AND img02=l_piaa.piaa03
           AND img03=l_piaa.piaa04 AND img04=l_piaa.piaa05
        LET l_factor = 1
        IF l_img09 <> l_piaa.piaa09 THEN
           CALL s_umfchk(l_piaa.piaa02,l_piaa.piaa09,l_img09)
                RETURNING l_sw,l_factor
           IF l_sw = 1 AND NOT (l_ima906='3' AND l_ima907=l_piaa.piaa09) THEN
               LET g_success='N'
               CALL cl_err('imgg09/img09','mfg3075',1)
               EXIT FOREACH
           END IF
        END IF
 
        LET g_forupd_sql = "SELECT imgg01,imgg02,imgg03,imgg04,imgg09 FROM imgg_file ",                                                    
                           " WHERE imgg01= ? AND imgg02= ? AND imgg03= ? AND imgg04= ? ",                                           
                           "   AND imgg09= ? FOR UPDATE "                                                                           
        LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
        DECLARE imgg_lock CURSOR FROM g_forupd_sql

        OPEN imgg_lock USING l_piaa.piaa02,l_piaa.piaa03,l_piaa.piaa04,l_piaa.piaa05,l_piaa.piaa09                                  
        IF STATUS THEN                                                                                                              
           CALL cl_err("OPEN imgg_lock:", STATUS, 1)                                                                                
           LET g_success='N'                                                                                                        
           CLOSE imgg_lock                                                                                                          
           EXIT FOREACH                                                                                                             
        END IF                                                                                                                      
        FETCH imgg_lock INTO l_imgg01,l_imgg02,l_imgg03,l_imgg04,l_imgg09                                                           
        IF STATUS THEN                                                                                                              
           CALL cl_err('lock imgg fail',STATUS,1)                                                                                   
           LET g_success='N'                                                                                                        
           CLOSE imgg_lock                                                                                                          
           EXIT FOREACH                                                                                                             
        END IF                                                                                                                      
        #No.TQC-930155-------------end---------
 
        #---->更新庫存明細檔
       #CALL s_upimgg(' ',2,l_qty*-1,g_today,           #FUN-8C0084               
        CALL s_upimgg(l_piaa.piaa02,l_piaa.piaa03,l_piaa.piaa04,l_piaa.piaa05,l_piaa.piaa09,2,l_qty*-1,g_today, #FUN-8C0084                         
                      l_piaa.piaa02,l_piaa.piaa03,l_piaa.piaa04,l_piaa.piaa05,'','','','',l_piaa.piaa09,'',l_factor,'','','','','','','',l_piaa.piaa10)
                       #1         #2  #3      #4     #5
        IF g_success ='N' THEN 
           EXIT FOREACH
        END IF
 
        DELETE FROM tlff_file WHERE tlff13 ='aimp880' 
                                AND tlff01 =l_piaa.piaa02    #料
                                AND tlff902=l_piaa.piaa03   #倉
                                AND tlff903=l_piaa.piaa04   #儲
                                AND tlff904=l_piaa.piaa05   #批
                                AND tlff905=l_piaa.piaa01   #標籤編號
                                AND tlff11 =l_piaa.piaa09   #單位
        IF SQLCA.sqlcode THEN
           LET g_success='N'
#           CALL cl_err('upd piaa',SQLCA.SQLCODE,1)
           CALL cl_err3("del","tlff_file",l_piaa.piaa02,"",SQLCA.sqlcode,"","",1)   #NO.FUN-640266 #No.FUN-660156
           EXIT FOREACH
        END IF
    END FOREACH 
 
   #------------No.MOD-750127 mark
   #IF g_success = 'Y' THEN 
   #   COMMIT WORK
   #   CALL cl_cmmsg(4) 
   #ELSE 
   #   ROLLBACK WORK
   #   CALL cl_rbmsg(4) 
   #END IF
   #------------No.MOD-750127 end
 
END FUNCTION 

#FUN-B40082 add
FUNCTION p920_sfp_z(l_sfp01,l_sfp06) 
   DEFINE l_sfp01  LIKE sfp_file.sfp01,
          l_sfp06  LIKE sfp_file.sfp06
   DEFINE p_argv1  LIKE type_file.chr1 
   LET p_argv1 = '1'
   CASE l_sfp06      
      WHEN "2" LET g_prog='asfi512'      
      WHEN "4" LET g_prog='asfi514'
      WHEN "6" 
         LET g_prog='asfi526'
         LET p_argv1 = '2'
      WHEN "9" 
         LET g_prog='asfi529'
         LET p_argv1 = '2'
   END CASE
 
   #過帳還原
   CALL i501sub_z(p_argv1,l_sfp01,NULL,FALSE)
   IF g_success = 'N' THEN
      RETURN FALSE 
   END IF

   #確認還原   
   CALL i501sub_w(l_sfp01,g_action_choice,FALSE)
   IF g_success = 'N' THEN
      RETURN FALSE 
   END IF

   #刪除單身
    DELETE FROM sfs_file WHERE sfs01 = l_sfp01
    IF STATUS THEN       
       CALL cl_err3("del","sfs_file",l_sfp01,"",STATUS,"","del sfsf",1)        
       LET g_success='N'
       RETURN FALSE 
#FUN-B70074 -----------------Begin--------------------
    ELSE 
        IF NOT s_industry('std') THEN
           IF NOT s_del_sfsi(l_sfp01,'','') THEN
              LET g_success='N'
              RETURN FALSE
           END IF
        END IF             
#FUN-B70074 -----------------End----------------------
    END IF
   
   #刪除單頭
   DELETE FROM sfp_file WHERE sfp01 = l_sfp01
   IF STATUS THEN       
       CALL cl_err3("del","sfp_file",l_sfp01,"",STATUS,"","del sfpf",1)        
       LET g_success='N'
       RETURN FALSE 
    END IF
   
   RETURN TRUE 
END FUNCTION

#FUN-B40082 add
FUNCTION p920_ina_z(l_ina01,p_flag)
   DEFINE l_ina01  LIKE ina_file.ina01
   DEFINE p_flag   LIKE type_file.num5
   #FUN-BC0104-add-str--
   DEFINE l_inb01  LIKE inb_file.inb01
   DEFINE l_inb03  LIKE inb_file.inb03
   DEFINE l_inb46  LIKE inb_file.inb46
   DEFINE l_inb47  LIKE inb_file.inb47
   DEFINE l_inb48  LIKE inb_file.inb48
   DEFINE l_flagg  LIKE type_file.chr1
   DEFINE l_qcl05  LIKE qcl_file.qcl05
   DEFINE l_type1  LIKE type_file.chr1
   DEFINE l_cn     LIKE  type_file.num5
   DEFINE l_c      LIKE  type_file.num5
   DEFINE l_inb_a  DYNAMIC ARRAY OF RECORD
          inb01    LIKE  inb_file.inb01,
          inb03    LIKE  inb_file.inb03,
          inb46    LIKE  inb_file.inb46,
          inb48    LIKE  inb_file.inb48,
          inb47    LIKE  inb_file.inb47,
          flagg    LIKE  type_file.chr1
                   END RECORD
   #FUN-BC0104-add-end--

   #取消過帳
   CALL p379sub_p2(l_ina01,p_flag)
   IF g_success = 'N' THEN
      RETURN FALSE 
   END IF

   #取消確認
   CALL t370sub_z(l_ina01,'N',TRUE)
   IF g_success = 'N' THEN
      RETURN FALSE 
   END IF

   #FUN-BC0104-add-str--
   LET l_cn =1
   DECLARE upd_qco20 CURSOR FOR
    SELECT inb03 FROM inb_file WHERE inb01 = l_ina01
   FOREACH upd_qco20 INTO l_inb03
      CALL s_iqctype_inb(l_ina01,l_inb03) RETURNING l_inb01,l_inb03,l_inb46,l_inb48,l_inb47,l_flagg
      LET l_inb_a[l_cn].inb01 = l_inb01
      LET l_inb_a[l_cn].inb03 = l_inb03
      LET l_inb_a[l_cn].inb46 = l_inb46
      LET l_inb_a[l_cn].inb48 = l_inb48
      LET l_inb_a[l_cn].inb47 = l_inb47
      LET l_inb_a[l_cn].flagg = l_flagg
      LET l_cn = l_cn + 1
   END FOREACH
   #FUN-BC0104-add-end--
   #刪除單身
   DELETE FROM inb_file WHERE inb01 = l_ina01
   IF STATUS THEN       
       CALL cl_err3("del","inb_file",l_ina01,"",STATUS,"","del inbf",1)        
       LET g_success='N'
       RETURN FALSE 
#FUN-B70074-add-str--
   ELSE 
       #FUN-BC0104-add-str--
       FOR l_c=1 TO l_cn-1
          IF l_inb_a[l_c].flagg = 'Y' THEN
             CALL s_qcl05_sel(l_inb_a[l_c].inb46) RETURNING l_qcl05
             IF l_qcl05='1' THEN LET l_type1='6' ELSE LET l_type1='4' END IF
             IF NOT s_iqctype_upd_qco20(l_inb_a[l_c].inb01,l_inb_a[l_c].inb03,l_inb_a[l_c].inb48,l_inb_a[l_c].inb47,l_type1) THEN
                LET g_success ='N'
                RETURN FALSE
             END IF
          END IF
       END FOR
       #FUN-BC0104-add-end--
      IF NOT s_industry('std') THEN 
         IF NOT s_del_inbi(l_ina01,'','') THEN 
            LET g_success ='N'
            RETURN FALSE 
         END IF 
      END IF
#FUN-B70074-add-end--
    END IF
   
   #刪除單頭
   DELETE FROM ina_file WHERE ina01 = l_ina01
   IF STATUS THEN       
       CALL cl_err3("del","ina_file",l_ina01,"",STATUS,"","del inaf",1)        
       LET g_success='N'
       RETURN FALSE 
    END IF
   
   RETURN TRUE 
END FUNCTION  

#FUN-B70032 --START--
FUNCTION p920_uppiad(l_pia01) 
   DEFINE l_sql      STRING  
   DEFINE l_pia01    LIKE pia_file.pia01      
   DEFINE l_piad     RECORD LIKE piad_file.*
   DEFINE l_qty      LIKE type_file.num15_3
   DEFINE p_in_out   LIKE type_file.num5
   DEFINE l_cnt      LIKE type_file.num10
   
   #刻號/BIN盤點資料
   LET l_sql = "SELECT * FROM piad_file WHERE piad01 = '" ,l_pia01, "'"              
               
   PREPARE p880_piad_p1 FROM l_sql           
   DECLARE p880_paid_c1 CURSOR FOR p880_piad_p1
   
   LET l_cnt = 0
   
   FOREACH p880_paid_c1 INTO l_piad.*
      IF SQLCA.sqlcode THEN         
         RETURN FALSE 
      END IF 
      
      #給預設值
      IF cl_null(l_piad.piad09) THEN LET l_piad.piad09 = 0 END IF        
      IF cl_null(l_piad.piad30) THEN LET l_piad.piad30 = 0 END IF
      IF cl_null(l_piad.piad50) THEN LET l_piad.piad50 = 0 END IF      
      #若有複盤以複盤數量為主
      IF l_piad.piad50 > 0 THEN LET l_piad.piad30 = l_piad.piad50 END IF

      LET p_in_out = 0 
      #盤點量<>庫存量
      IF l_piad.piad30 <> l_piad.piad09 THEN
         #建立ICD料件出/入庫紀錄檔
         IF l_piad.piad30 - l_piad.piad09 > 0 THEN   #盤盈
            LET l_qty = l_piad.piad30 - l_piad.piad09
            LET p_in_out = 1            
         ELSE                                        #盤虧
            LET l_qty = l_piad.piad09 - l_piad.piad30
            LET p_in_out = -1            
         END IF  
   
         #過帳
         IF NOT s_icdpost(p_in_out,l_piad.piad02,l_piad.piad03,l_piad.piad04,l_piad.piad05,
                          l_piad.piad10,l_qty,l_pia01,0,l_piad.piad12,'N','','',' ',' ','') THEN  #FUN-B80119--傳入p_plant參數---
            RETURN FALSE              
         END IF                   
         IF p_in_out = 1  THEN CALL icd_ida_del(l_pia01,0,'') END IF  #刪入庫資料  #FUN-B80119--傳入p_plant參數---     
         IF p_in_out = -1 THEN CALL icd_idb_del(l_pia01,0,'') END IF  #刪出庫資料  #FUN-B80119--傳入p_plant參數---
         
      END IF
      LET l_cnt = l_cnt + 1      
   END FOREACH
   IF l_cnt > 0 THEN 
      #更新盤點過帳狀態
      UPDATE piad_file SET piad19='N' WHERE piad01 = l_pia01 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         RETURN FALSE
      END IF      
   END IF 
   RETURN TRUE 
END FUNCTION 
#FUN-B70032 --END--

#No.FUN-570082  --end #FUN-870051 pass only
