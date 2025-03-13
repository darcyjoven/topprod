# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aimp001.4gl
# Descriptions...: 標準成本計算作業
# Date & Author..: 06/11/30 By kim (TQC-6B0191)
# Modify.........: No.FUN-710025 07/01/15 By bnlent 錯誤訊息匯整
# Modify.........: No.MOD-710106 07/01/16 By Carol 修改p001_sum()的SQL
# Modify.........: No.CHI-710055 07/01/24 By kim 未考慮QPA
# Modify.........: No.FUN-890103 08/09/25 By sherry 需考慮 發料」對「料件成本單位」換算率
# Modify.........: No.FUN-960056 09/06/23 By jan 1.加背景作業處理
# ...............................................2.材料/加工成本取得來源加 采購核價檔
# ...............................................3.將標准成本紀錄產生到標准成本月檔(stx_file)
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-990027 09/11/11 By sabrina BOM未發放也會算
# Modify.........: No:MOD-990079 09/11/11 By sabrina 若imb_file資料以存在時應只對標準成本欄位給default值即可
# Modify.........: No:MOD-990087 09/11/11 By sabrina BOM未發放，標準成本不應該算到該顆料
# Modify.........: No:MOD-990112 09/11/11 By sabrina 抓取人工製費英用料件主檔的預設製程料號及預設製程編號抓取ecb_file
# Modify.........: No.TQC-970118 09/11/13 By jan 拿掉stx04
# Modify.........: No.CHI-980070 09/11/13 By jan 不要delete imb_file 的資料,后續insert時若-239則update 
# Modify.........: No:MOD-990068 09/11/25 By sabrina 當發料單位與採購單位及庫存單位不一樣時，標準成本會異常
# Modify.........: No.FUN-9C0072 10/01/14 By vealxu 精簡程式碼
# Modify.........: No.FUN-AA0059 10/10/29 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()
# Modify.........: No.TQC-AB0032 10/11/05 By wangxin 修改鎖imb_file的SQL
# Modify.........: No.FUN-AB0025 10/11/11 By vealxu p001_tm() 中 tm.wc 加上 企業料號的條件
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No.CHI-C30115 12/05/29 By yuhuabao -239的錯誤判斷,應全部改成IF cl_sql_dup_value(SQLCA.sqlcode)
# Modify.........: No.CHI-C70033 12/10/30 By bart ecb49改抓ecb25

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm RECORD
            wc    STRING,
            yy    LIKE type_file.num5,    #FUN-960056
            mm    LIKE type_file.num5,    #FUN-960056
            type  LIKE type_file.chr1
          END RECORD,
       g_change_lang   LIKE type_file.chr1     #是否有做語言切換
DEFINE g_imb RECORD LIKE imb_file.*
DEFINE g_stx RECORD LIKE stx_file.*   #FUN-960056
DEFINE g_max_level  LIKE type_file.num5 #BOM最高階數
DEFINE g_sql STRING
DEFINE g_cnt        LIKE type_file.num5 #TQC-970118 
   
MAIN
DEFINE l_flag LIKE type_file.num5
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   INITIALIZE g_bgjob_msgfile TO NULL
   LET tm.wc = ARG_VAL(1)
   LET tm.type = ARG_VAL(2)
   LET g_bgjob = ARG_VAL(3)
   LET tm.yy=ARG_VAL(4)  #FUN-960056
   LET tm.mm=ARG_VAL(5)  #FUN-960056
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
 
   LET g_max_level=20
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
   ERROR ""
   LET g_success = 'Y'
   WHILE TRUE
      IF g_bgjob = "N" THEN
         CALL p001_tm()
         IF cl_sure(18,20) THEN
            BEGIN WORK
            LET g_success = 'Y'
            CALL aimp001()
            CALL s_showmsg()        #No.FUN-710025
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
               CLOSE WINDOW p001_w
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
         CLOSE WINDOW p001_w
      ELSE
         BEGIN WORK
         LET g_success = 'Y'
         CALL aimp001()
         CALL s_showmsg()        #No.FUN-710025
         IF g_success = "Y" THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
     CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION p001_tm()
   DEFINE p_row,p_col	LIKE type_file.num5
   DEFINE lc_cmd      LIKE type_file.chr1000
 
   IF s_shut(0) THEN RETURN END IF
 
   LET p_row = 3 LET p_col = 15
 
   OPEN WINDOW p001_w AT p_row,p_col WITH FORM "aim/42f/aimp001" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
   CALL cl_ui_init()
 
   CALL cl_opmsg('z')
 
   WHILE TRUE
      CLEAR FORM 
      INITIALIZE tm.* TO NULL			# Default condition
      IF cl_null(tm.type) THEN
         LET tm.type = '1'
      END IF
      CONSTRUCT BY NAME tm.wc ON ima01,ima12
 
      BEFORE CONSTRUCT
          CALL cl_qbe_init()
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(ima01) #料件編號
#FUN-AA0059 --Begin--
              # CALL cl_init_qry_var()
              # LET g_qryparam.form     = "q_ima"
              # LET g_qryparam.state    = "c"
              # CALL cl_create_qry() RETURNING g_qryparam.multiret
               CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--  
               DISPLAY g_qryparam.multiret TO ima01
               NEXT FIELD ima01
            
            WHEN INFIELD(ima12) #其他分群碼四
               CALL cl_init_qry_var()
               LET g_qryparam.form     = "q_azf"
               LET g_qryparam.state    = "c"
               LET g_qryparam.arg1     = "G"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima12
               NEXT FIELD ima12
         END CASE
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
       
      ON ACTION locale                    #genero
         LET g_change_lang = TRUE
         EXIT CONSTRUCT
      
      ON ACTION exit              #加離開功能genero
         LET INT_FLAG = 1
         EXIT CONSTRUCT
 
      ON ACTION qbe_select
         CALL cl_qbe_select()
 
      END CONSTRUCT
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup') #FUN-980030
      LET tm.wc = tm.wc CLIPPED, " AND (ima120 = '1' OR ima120 = ' ' OR ima120 IS NULL ) "   #FUN-AB0025 
 
 
     IF g_change_lang THEN
        LET g_change_lang = FALSE
        CALL cl_dynamic_locale()
        CALL cl_show_fld_cont()   #FUN-550037(smin)
        CONTINUE WHILE
     END IF
     IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLOSE WINDOW p001_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
        EXIT PROGRAM
     END IF
     LET g_bgjob = 'N'
     LET tm.yy= YEAR(g_today) #FUN-960056
     LET tm.mm=Month(g_today) #FUN-960056
     INPUT BY NAME tm.yy,tm.mm,tm.type,g_bgjob WITHOUT DEFAULTS #FUN-960056 add g_bgjob,tm.yy,tm.mm
 
        AFTER FIELD g_bgjob 
          IF g_bgjob NOT MATCHES "[YN]"  OR cl_null(g_bgjob) THEN
              NEXT FIELD g_bgjob 
          END IF
 
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
 
 
        ON ACTION exit  #加離開功能genero
           LET INT_FLAG = 1
           EXIT INPUT
        
        ON ACTION qbe_save
           CALL cl_qbe_save()
        
        ON ACTION locale
            LET g_change_lang = TRUE
            EXIT INPUT
 
      END INPUT
 
     IF g_bgjob = "Y" THEN
        SELECT zz08 INTO lc_cmd FROM zz_file
         WHERE zz01 = "aimp001"
        IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
           CALL cl_err('aimp001','9031',1)
        ELSE
           LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
           LET lc_cmd = lc_cmd CLIPPED,
                        " '",tm.wc CLIPPED ,"'",
                        " '",tm.type CLIPPED ,"'", #FUN-960056
                        " '",g_bgjob CLIPPED,"'",
                        " '",tm.yy CLIPPED ,"'",   #FUN-960056
                        " '",tm.yy CLIPPED ,"'"    #FUN-960056
           CALL cl_cmdat('aimp001',g_time,lc_cmd CLIPPED)
        END IF
        CLOSE WINDOW p001_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
        EXIT PROGRAM
     END IF
    EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION aimp001()
   DEFINE l_sql   STRING
   DEFINE l_cnt   LIKE type_file.num10
   DEFINE lf_price STRING
   DEFINE l_ima01 LIKE ima_file.ima01
   DEFINE l_ima02 LIKE ima_file.ima02
   DEFINE l_ima08 LIKE ima_file.ima08
   DEFINE l_ima16 LIKE ima_file.ima16
   DEFINE l_ima910 LIKE ima_file.ima910
   DEFINE l_ima44 LIKE ima_file.ima44  #TQC-970118
   DEFINE l_ima25 LIKE ima_file.ima25  #TQC-970118    #No.MOD-990068 modify
   DEFINE l_ima54 LIKE ima_file.ima54  #TQC-970118
   DEFINE l_price LIKE ima_file.ima53
   DEFINE l_date  LIKE type_file.dat    #FUN-960056
   DEFINE l_ecb01 LIKE ecb_file.ecb01   #TQC-970118
   DEFINE l_ecb02 LIKE ecb_file.ecb02   #TQC-970118
   DEFINE l_ecb03 LIKE ecb_file.ecb03   #TQC-970118
   DEFINE l_ecb04 LIKE ecb_file.ecb04   #TQC-970118
   DEFINE l_ecb06 LIKE ecb_file.ecb06   #TQC-970118
   DEFINE l_ecb44 LIKE ecb_file.ecb44   #TQC-970118
   DEFINE l_ecb45 LIKE ecb_file.ecb45   #TQC-970118
   DEFINE l_ecb46 LIKE ecb_file.ecb46   #TQC-970118
   #DEFINE l_ecb49 LIKE ecb_file.ecb49   #TQC-970118  #CHI-C70033
   DEFINE l_ecb25 LIKE ecb_file.ecb25   #TQC-970118   #CHI-C70033
   DEFINE l_ecb39 LIKE ecb_file.ecb39   #TQC-970118
   DEFINE l_factor LIKE type_file.num26_10 #TQC-970118
 
   #更新imb_file前先檢查有無被lock table........begin
   #TQC-AB0032  ----------bengin------------
   #LET l_sql = "SELECT imb01 FROM imb_file",
   #            "  WHERE imb01 IN (SELECT ima01 FROM ima_file",
   #            "  AND ",tm.wc CLIPPED,")",
   #            " FOR UPDATE "
   LET l_sql = "SELECT imb01 FROM imb_file,ima_file ",
               " WHERE imb01 = ima01 ",
               "   AND ",tm.wc CLIPPED,
               " FOR UPDATE " 
   #TQC-AB0032  -----------end--------------
   LET l_sql=cl_forupd_sql(l_sql)
   PREPARE p001_c1_p FROM l_sql
   IF SQLCA.sqlcode THEN 
      CALL cl_err('prepare p001_c1_p',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF  
 
   DECLARE p001_c1 CURSOR FOR p001_c1_p
   OPEN p001_c1
   IF SQLCA.sqlcode THEN 
      CALL cl_err3("sel","ima_file","","",SQLCA.sqlcode,"","",1)
      LET g_success='N'
      RETURN
   END IF
   CLOSE p001_c1_p
   #更新imb_file前先檢查有無被lock table........end
   
   #單價=>1. 料件主檔之最近採購單價 ima53  ; 2. 料件主檔之平均單價  ima91
   CASE tm.type
      WHEN "1"
         LET lf_price='ima53'
      WHEN "2"
         LET lf_price='ima91'
      WHEN "3"             #FUN-960056
         LET lf_price='0'  #FUN-960056
      OTHERWISE
         LET g_success='N'
         RETURN      
   END CASE
   
   LET l_sql="DELETE FROM stx_file WHERE stx01 IN ",
             "(SELECT ima01 FROM ima_file WHERE ",tm.wc CLIPPED,") ",
             " AND stx02 = ",tm.yy,
             " AND stx03 = ",tm.mm
   PREPARE p001_delstx_p FROM l_sql
   IF SQLCA.sqlcode THEN 
      CALL cl_err('prepare p001_c2_p',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
   EXECUTE p001_delstx_p
   IF SQLCA.sqlcode THEN 
      CALL cl_err3("del","stxb_file","","",SQLCA.sqlcode,"","",1)
      LET g_success='N'
      RETURN
   END IF
 
   #UPDATE->從最低階開始算起
   LET l_sql="SELECT ima01,ima02,ima08,ima16,ima910,",lf_price,
             " AS price,ima44,ima25,ima54 FROM ima_file", #TQC-970118  #No.MOD-990068 modify
             " WHERE ",tm.wc CLIPPED,
             " ORDER BY ima16 DESC"
   PREPARE p001_c3_p FROM l_sql
   IF SQLCA.sqlcode THEN 
      CALL cl_err('prepare p001_c3_p',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
   DECLARE p001_c3 CURSOR FOR p001_c3_p
   CALL s_showmsg_init()     #No.FUN-710025
   FOREACH p001_c3 INTO l_ima01,l_ima02,l_ima08,l_ima16,l_ima910,l_price,
                         l_ima44,l_ima25,l_ima54   #TQC-970118   #No.MOD-990068 modify
      IF g_success='N' THEN                                                                                                          
         LET g_totsuccess='N'                                                                                                       
         LET g_success="Y"                                                                                                          
      END IF                  
 
      IF SQLCA.sqlcode THEN 
         CALL s_errmsg('','','prepare FOREACH',SQLCA.sqlcode,1) 
         LET g_success = 'N'
         RETURN
      END IF
      CALL p001_init_imb(l_ima01)    #No.MOD-990079 modify
      #取加工廠商核價單單價
      IF tm.type = '3' AND l_ima08<>'S' THEN
         LET l_price = p001_defprice(l_ima01,l_ima54,'','N') 
      END IF
      #S件直接去核價單價
      IF l_ima08='S' THEN    
         LET l_price = p001_defprice(l_ima01,l_ima54,'','Y')  
      END IF
      IF l_price IS NULL THEN
         LET l_price=0
      END IF
      IF l_price <> 0 THEN
         CALL s_umfchk(l_ima01,l_ima25,l_ima44)   #No.MOD-990068 modify
              RETURNING g_cnt,l_factor
         IF g_cnt = 1 THEN
            CALL cl_err(l_ima01,'mfg3075',0)
            LET l_factor = 1
         END IF
         LET l_price = l_price*l_factor
      END IF
      LET g_imb.imb01=l_ima01
      CASE
         WHEN l_ima08 MATCHES '[PVZ]'
            LET g_imb.imb111=l_price
            LET g_imb.imb118=l_price
         WHEN l_ima08 MATCHES '[S]'   #TQC-970118
            LET g_imb.imb1171=l_price  #TQC-970118
      
         OTHERWISE
             LET l_cnt = 0 
             SELECT COUNT(*) INTO l_cnt FROM bma_file
                      WHERE bma01 = l_ima01
                        AND bma06 = l_ima910
                        AND bma05 IS NOT NULL
                        AND bma05 <= g_today
             
              IF cl_null(l_cnt) THEN LET l_cnt=0 END IF
              IF l_cnt = 0 THEN EXIT CASE END IF    
            #先用核價單單價更新標准加工單價
            DECLARE p001_upd_ecb_cs1 CURSOR FOR
               #SELECT ecb01,ecb02,ecb03,ecb04,ecb06,ecb44,ecb45,ecb46,ecb49,ecb39  #CHI-C70033
               SELECT ecb01,ecb02,ecb03,ecb04,ecb06,ecb44,ecb45,ecb46,ecb25,ecb39  #CHI-C70033
                 FROM ecb_file,ima_file,ecu_file,eca_file
                WHERE eca01 = ecb08      #AND ecb01 = l_ima01   #No.MOD-990112 modify
                  AND ecb01 = ecu01 AND ecb02 = ecu02 
                  AND ecu01 = ima571 AND ecu02= ima94
                  AND ima01 = l_ima01
            FOREACH p001_upd_ecb_cs1 INTO l_ecb01,l_ecb02,l_ecb03,
                                          l_ecb04,l_ecb06,l_ecb44,
                                          #l_ecb45,l_ecb46,l_ecb49, #CHI-C70033
                                          l_ecb45,l_ecb46,l_ecb25, #CHI-C70033
                                          l_ecb39
               LET l_price = 0
               #LET l_price = p001_defprice(l_ima01,l_ecb49,l_ecb06,l_ecb39)   #CHI-C70033
               LET l_price = p001_defprice(l_ima01,l_ecb25,l_ecb06,l_ecb39) #CHI-C70033
               IF cl_null(l_price) THEN LET l_price = 0 END IF
                  IF cl_null(l_ecb46) THEN LET l_ecb46 = 1 END IF
                  LET l_price = l_price / l_ecb46
            
               UPDATE ecb_file SET ecb48 = l_price
                WHERE ecb01 = l_ecb01 AND ecb02 = l_ecb02 AND ecb03 = l_ecb03
            END FOREACH
            #加工費用改為產品制程檔的標准加工單價(ecb49)
             SELECT SUM(ecb48) INTO g_imb.imb1171
              FROM eca_file,ecb_file,ecu_file,ima_file
             WHERE eca01=ecb08
               AND ecb01=ecu01
               AND ecb02=ecu02 
               AND ecu01=ima571
               AND ecu02=ima94
               AND ima01=l_ima01
            IF cl_null(g_imb.imb1171) THEN LET g_imb.imb1171=0 END IF
            #直接人工成本
            LET l_price=p001_cacl_emp(l_ima01)
            IF l_price IS NULL THEN
               LET l_price=0
            END IF
            LET g_imb.imb1131=l_price
            
            #固定製費
            LET l_price=p001_cacl_mat(l_ima01)
            IF l_price IS NULL THEN
               LET l_price=0
            END IF
            LET g_imb.imb114=l_price
      END CASE
      CALL p001_cacl_level(l_ima01,l_ima910,1) #TQC-970118
      LET g_imb.imboriu = g_user      #No.FUN-980030 10/01/04
      LET g_imb.imborig = g_grup      #No.FUN-980030 10/01/04
      INSERT INTO imb_file VALUES (g_imb.*)
      IF SQLCA.sqlcode THEN 
         IF cl_sql_dup_value(SQLCA.SQLCODE) THEN
            UPDATE imb_file SET imb_file.* = g_imb.*
             WHERE imb01 = g_imb.imb01
            IF SQLCA.SQLERRD[3]=0 THEN
               CALL s_errmsg('','','',SQLCA.sqlcode,1)
               LET g_success='N'
               CONTINUE FOREACH
            END IF
         ELSE
         CALL s_errmsg('','','',SQLCA.sqlcode,1) 
         LET g_success='N'
         CONTINUE FOREACH
         END IF #CHI-980070
      END IF
     CALL p001_init_stx()
     INSERT INTO stx_file VALUES (g_stx.*)
     IF SQLCA.sqlcode THEN 
#       IF SQLCA.sqlcode = -239 OR SQLCA.sqlcode = -263 THEN #CHI-C30115 mark
        IF cl_sql_dup_value(SQLCA.sqlcode)  OR SQLCA.sqlcode = -263 THEN #CHI-C30115 add
           UPDATE stx_file SET stx05 = g_stx.stx05,
                               stx06 = g_stx.stx06,
                               stx07 = g_stx.stx07,
                               stx08 = g_stx.stx08,
                               stx09 = g_stx.stx09,
                               stx10 = g_stx.stx10,
                               stx11 = g_stx.stx11,
                               stx12 = g_stx.stx12,
                               stx13 = g_stx.stx13
             WHERE stx01 = g_stx.stx01
               AND stx02 = g_stx.stx02
               AND stx03 = g_stx.stx03             
           IF SQLCA.SQLERRD[3]=0 THEN
              CALL s_errmsg('','','',SQLCA.sqlcode,1)
              LET g_success='N'
              CONTINUE FOREACH
           END IF
        ELSE                     
          CALL s_errmsg('','','',SQLCA.sqlcode,1) 
          LET g_success='N'
          CONTINUE FOREACH
        END IF
     END IF
   END FOREACH
      IF g_totsuccess="N" THEN
         LET g_success="N"
      END IF
 
END FUNCTION
 
FUNCTION p001_init_imb(p_ima01)        #MOD-990079 add p_ima01
   DEFINE  p_ima01        LIKE ima_file.ima01    #No:MOD-990079 add

   INITIALIZE g_imb.* TO NULL
   SELECT * INTO g_imb.* FROM imb_file WHERE imb01 = p_ima01
   IF STATUS THEN
      LET g_imb.imb02   ='1'    #標準成本資料取得方式            
      LET g_imb.imb111  = 0     #標準本階材料成本                
      LET g_imb.imb112  = 0     #標準本階材料製造費用            
      LET g_imb.imb1131 = 0     #標準本階人工成本                
      LET g_imb.imb1132 = 0     #標準本階人工製造費用            
      LET g_imb.imb114  = 0     #標準本階固定製造費用成本        
      LET g_imb.imb115  = 0     #標準本階變動製造費用成本        
      LET g_imb.imb1151 = 0     #標準本階廠外加工材料成本        
      LET g_imb.imb116  = 0     #標準本階廠外加工成本            
      LET g_imb.imb1171 = 0     #標準本階廠外加工固定製造費用成本
      LET g_imb.imb1172 = 0     #標準本階廠外加工變動製造費用成本
      LET g_imb.imb119  = 0     #標準本階機器成本                
      LET g_imb.imb118  = 0     #標準採購成本                    
      LET g_imb.imb120  = 0     #標準本階附加成本                
      LET g_imb.imb121  = 0     #標準下階材料成本                
      LET g_imb.imb122  = 0     #標準下階材料製造費用成本        
      LET g_imb.imb1231 = 0     #標準下階人工成本                
      LET g_imb.imb1232 = 0     #標準下階人工製造費用成本        
      LET g_imb.imb124  = 0     #標準下階固定製造成本            
      LET g_imb.imb125  = 0     #標準下階變動製造成本            
      LET g_imb.imb1251 = 0     #標準本階廠外加工材料成本        
      LET g_imb.imb126  = 0     #標準下階廠外加工成本            
      LET g_imb.imb1271 = 0     #標準下階廠外加工固定製造費用成本
      LET g_imb.imb1272 = 0     #標準下階廠外加工變動製造費用成本
      LET g_imb.imb129  = 0     #標準下階機器成本                
      LET g_imb.imb130  = 0     #標準下階附加成本                
      LET g_imb.imb211  = 0     #現時本階材料成本                
      LET g_imb.imb212  = 0     #現時本階材料製造費用            
      LET g_imb.imb2131 = 0     #現時本階人工成本                
      LET g_imb.imb2132 = 0     #現時本階人工製造費用            
      LET g_imb.imb214  = 0     #現時本階固定製造費用成本        
      LET g_imb.imb215  = 0     #現時本階變動製造費用成本        
      LET g_imb.imb2151 = 0     #現時本階廠外加工材料成本        
      LET g_imb.imb216  = 0     #現時本階廠外人工成本            
      LET g_imb.imb2171 = 0     #現時本階廠外加工固定製造費用成本
      LET g_imb.imb2172 = 0     #現時本階廠外加工變動製造費用成本
      LET g_imb.imb219  = 0     #現時本階機器成本                
      LET g_imb.imb218  = 0     #現時採購成本                    
      LET g_imb.imb220  = 0     #現時本階附加成本                
      LET g_imb.imb221  = 0     #現時下階材料成本                
      LET g_imb.imb222  = 0     #現時下階材料製造費用成本        
      LET g_imb.imb2231 = 0     #現時下階人工成本                
      LET g_imb.imb2232 = 0     #現時下階人工製造費用成本        
      LET g_imb.imb224  = 0     #現時下階固定製造成本            
      LET g_imb.imb225  = 0     #現時下階變動製造成本            
      LET g_imb.imb2251 = 0     #現時下階廠外加工材料成本        
      LET g_imb.imb226  = 0     #現時下階廠外加工成本            
      LET g_imb.imb2271 = 0     #現時下階廠外加工固定製造費用成本
      LET g_imb.imb2272 = 0     #現時下階廠外加工變動製造費用成本
      LET g_imb.imb229  = 0     #現時下階機器成本                
      LET g_imb.imb230  = 0     #現時下階附加成本                
      LET g_imb.imb311  = 0     #預設本階材料成本                
      LET g_imb.imb312  = 0     #預設本階材料製造費用            
      LET g_imb.imb3131 = 0     #預設本階人工成本                
      LET g_imb.imb3132 = 0     #預設本階人工製造費用            
      LET g_imb.imb314  = 0     #預設本階固定製造費用成本        
      LET g_imb.imb315  = 0     #預設本階變動製造費用成本        
      LET g_imb.imb3151 = 0     #預設本階廠外加工材料成本        
      LET g_imb.imb316  = 0     #預設本階廠外加工成本            
      LET g_imb.imb3171 = 0     #預設本階廠外加工固定製造費用成本
      LET g_imb.imb3172 = 0     #預設本階廠外加工變動製造費用成本
      LET g_imb.imb319  = 0     #預設本階機器成本                
      LET g_imb.imb318  = 0     #預設採購成本                    
      LET g_imb.imb320  = 0     #預設本階附加成本                
      LET g_imb.imb321  = 0     #預設下階材料成本                
      LET g_imb.imb322  = 0     #預設下階材料製造費用成本        
      LET g_imb.imb3231 = 0     #預設下階人工成本                
      LET g_imb.imb3232 = 0     #預設下階人工製造費用成本        
      LET g_imb.imb324  = 0     #預設下階固定製造成本            
      LET g_imb.imb325  = 0     #預設下階變動製造成本            
      LET g_imb.imb3251 = 0     #預設下階廠外加工材料成本        
      LET g_imb.imb326  = 0     #預設下階廠外加工成本            
      LET g_imb.imb3271 = 0     #預設下階廠外加工固定製造費用成本
      LET g_imb.imb3272 = 0     #預設下階廠外加工變動製造費用成本
      LET g_imb.imb329  = 0     #預設下階機器成本                
      LET g_imb.imb330  = 0     #預設下階附加成本    
      LET g_imb.imbacti ='Y'    #資料有效碼
      LET g_imb.imbuser =g_user #資料所有者
      LET g_imb.imbgrup =g_grup #資料所有群
   ELSE
      LET g_imb.imb02   ='1'    #標準成本資料取得方式            
      LET g_imb.imb111  = 0     #標準本階材料成本                
      LET g_imb.imb112  = 0     #標準本階材料製造費用            
      LET g_imb.imb1131 = 0     #標準本階人工成本                
      LET g_imb.imb1132 = 0     #標準本階人工製造費用            
      LET g_imb.imb114  = 0     #標準本階固定製造費用成本        
      LET g_imb.imb115  = 0     #標準本階變動製造費用成本        
      LET g_imb.imb1151 = 0     #標準本階廠外加工材料成本        
      LET g_imb.imb116  = 0     #標準本階廠外加工成本            
      LET g_imb.imb1171 = 0     #標準本階廠外加工固定製造費用成本
      LET g_imb.imb1172 = 0     #標準本階廠外加工變動製造費用成本
      LET g_imb.imb119  = 0     #標準本階機器成本                
      LET g_imb.imb118  = 0     #標準採購成本                    
      LET g_imb.imb120  = 0     #標準本階附加成本                
      LET g_imb.imb121  = 0     #標準下階材料成本                
      LET g_imb.imb122  = 0     #標準下階材料製造費用成本        
      LET g_imb.imb1231 = 0     #標準下階人工成本                
      LET g_imb.imb1232 = 0     #標準下階人工製造費用成本        
      LET g_imb.imb124  = 0     #標準下階固定製造成本            
      LET g_imb.imb125  = 0     #標準下階變動製造成本            
      LET g_imb.imb1251 = 0     #標準本階廠外加工材料成本        
      LET g_imb.imb126  = 0     #標準下階廠外加工成本            
      LET g_imb.imb1271 = 0     #標準下階廠外加工固定製造費用成本
      LET g_imb.imb1272 = 0     #標準下階廠外加工變動製造費用成本
      LET g_imb.imb129  = 0     #標準下階機器成本                
      LET g_imb.imb130  = 0     #標準下階附加成本                
   END IF
   LET g_imb.imbmodu =NULL   #資料更改者            
   LET g_imb.imbdate =g_today #最近修改日
END FUNCTION
 
FUNCTION p001_init_stx()
 
  INITIALIZE g_stx.* TO NULL
  LET g_stx.stx01 = g_imb.imb01
  LET g_stx.stx02 = tm.yy
  LET g_stx.stx03 = tm.mm
  LET g_stx.stx05 = g_imb.imb111
  LET g_stx.stx06 = g_imb.imb1131 + g_imb.imb1132
  LET g_stx.stx07 = g_imb.imb114 + g_imb.imb115
  LET g_stx.stx08 = g_imb.imb1151 + g_imb.imb116 + g_imb.imb1171 + g_imb.imb1172
  LET g_stx.stx09 = g_imb.imb121
  LET g_stx.stx10 = g_imb.imb1231 + g_imb.imb1232
  LET g_stx.stx11 = g_imb.imb124 + g_imb.imb125  #TQC-970118
  LET g_stx.stx12 = g_imb.imb1251 + g_imb.imb126 + g_imb.imb1271 + g_imb.imb1272  #TQC-970118
  LET g_stx.stx13 = g_stx.stx05+g_stx.stx06+g_stx.stx07+g_stx.stx08+g_stx.stx09+g_stx.stx10+g_stx.stx11+g_stx.stx12 
  LET g_stx.stx04 = ' '
END FUNCTION
#人工費用 =>1. 走製程  ~ 產品製程檔之人工工時[ecb19] * 所屬工作站之人工工資分攤率[eca18]
#           2.不走製程 ~ sra_file  [人工工時]  *  [工資分攤率]
FUNCTION p001_cacl_emp(l_ima01)
   DEFINE l_ima01 LIKE ima_file.ima01
   DEFINE l_cnt   LIKE type_file.num10
   DEFINE l_res   LIKE imb_file.imb1131
   
   LET l_cnt=0
   LET l_res=0
   SELECT COUNT(*) INTO l_cnt FROM ecb_file,ima_file
                             WHERE ima01=l_ima01
                               AND ecb01=ima571
                               AND ecb02=ima94
   IF l_cnt>0 THEN #走製程
      SELECT SUM(ecb19*eca18) INTO l_res
                         FROM eca_file,ecb_file,ima_file
                        WHERE eca01=ecb08
                          AND ima01=l_ima01
                          AND ecb01=ima571
                          AND ecb02=ima94
   ELSE #不走製程,只取第一筆
      LET g_sql="SELECT sra05*sra07 FROM sra_file",
                "                  WHERE sra02='",l_ima01,"'",
                "                  ORDER BY sra01"
      PREPARE cacl_emp_c_p FROM g_sql
      DECLARE cacl_emp_c CURSOR FOR cacl_emp_c_p
      FOREACH cacl_emp_c INTO l_res
         IF cl_null(l_res) THEN
            CONTINUE FOREACH
         END IF
      END FOREACH
      CLOSE cacl_emp_c
      FREE cacl_emp_c_p
   END IF
   IF cl_null(l_res) THEN
      LET l_res=0
   END IF
   RETURN l_res
END FUNCTION
 
#製造費用 =>1.走製程  ~ 產品製程檔之標準機器工時[ecb21]*所屬工作站之製費分攤率[eca22+eca24]
#           2.不走製程~ sra_file  [機器工時] *  [製費分攤率]
FUNCTION p001_cacl_mat(l_ima01)
   DEFINE l_ima01 LIKE ima_file.ima01
   DEFINE l_cnt   LIKE type_file.num10
   DEFINE l_res   LIKE imb_file.imb114
   
   LET l_cnt=0
   LET l_res=0
   SELECT COUNT(*) INTO l_cnt FROM ecb_file,ima_file
                             WHERE ima01=l_ima01
                               AND ecb01=ima571
                               AND ecb02=ima94
   IF l_cnt>0 THEN #走製程
      SELECT SUM(ecb21*(eca22+eca24)) INTO l_res
                         FROM eca_file,ecb_file,ima_file
                        WHERE eca01=ecb08
                          AND ima01=l_ima01
                          AND ecb01=ima571
                          AND ecb02=ima94
   ELSE #不走製程,只取第一筆
      LET g_sql="SELECT sra06*sra08 FROM sra_file",
                "                  WHERE sra02='",l_ima01,"'",
                "                  ORDER BY sra01"
      PREPARE cacl_mat_c_p FROM g_sql
      DECLARE cacl_mat_c CURSOR FOR cacl_mat_c_p
      FOREACH cacl_mat_c INTO l_res
         IF cl_null(l_res) THEN
            CONTINUE FOREACH
         END IF
      END FOREACH
      CLOSE cacl_mat_c
      FREE cacl_mat_c_p
   END IF
   IF cl_null(l_res) THEN
      LET l_res=0
   END IF
   RETURN l_res
END FUNCTION
 
FUNCTION p001_cacl_level(l_ima01,l_ima910,l_level)
   DEFINE l_ima01  LIKE ima_file.ima01
   DEFINE l_ima910 LIKE ima_file.ima910
   DEFINE l_level  LIKE type_file.num5
   DEFINE l_i,l_ac,l_tot  LIKE type_file.num10
   DEFINE l_sql    STRING
   DEFINE sr DYNAMIC ARRAY OF RECORD
                bmb03 LIKE bmb_file.bmb03,                
                level LIKE type_file.num5,
                bmb06 LIKE bmb_file.bmb06, #CHI-710055
                bmb07 LIKE bmb_file.bmb07, #CHI-710055
                bmb08 LIKE bmb_file.bmb08, #CHI-710055
                bmb10_fac LIKE bmb_file.bmb10_fac  #FUN-890103
             END RECORD
   IF l_level>g_max_level THEN
      LET g_success='N'
      CALL cl_err(l_ima01,'aim-001',1)
      RETURN
   END IF
   LET l_sql="SELECT bmb03,",l_level,
             ",bmb06,bmb07,bmb08,bmb10_fac FROM bmb_file,bma_file WHERE bmb01='", #FUN-890103  #CHI-710055 #No:MOD-990027 add bma_file
             l_ima01,"' AND bmb29='",l_ima910,"'",
             "    AND bmb01 = bma01 ",           
             "    AND bma06 = bmb29 ",
             "    AND bma05 IS NOT NULL ",
             "    AND bma05 <= '",g_today,"'",
             "    AND (bmb04 <='",g_today,
             "'    OR bmb04 IS NULL) AND (bmb05 >'",g_today,
             "'    OR bmb05 IS NULL)"
   PREPARE p001_cacl_c1_p FROM l_sql
   DECLARE p001_cacl_c1 CURSOR FOR p001_cacl_c1_p
   LET l_ac=1
   FOREACH p001_cacl_c1 INTO sr[l_ac].*
      IF SQLCA.sqlcode THEN
         LET g_success='N'
         CALL cl_err('p001_cacl_c1',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET l_ac=l_ac+1
   END FOREACH
   LET l_tot=l_ac-1
   FOR l_i = 1 TO l_tot
      IF sr[l_i].bmb03 IS NULL THEN
         CONTINUE FOR
      END IF
      CALL p001_sum(sr[l_i].bmb03,sr[l_i].bmb06,sr[l_i].bmb07,sr[l_i].bmb08,sr[l_i].bmb10_fac) #FUN-890103 #CHI-710055
      IF l_level>g_max_level THEN
         LET g_success='N'
         CALL cl_err(sr[l_i].bmb03,'aim-001',1)
         RETURN
      END IF     
      IF l_level+1>g_max_level THEN
         LET g_success='N'
         CALL cl_err(l_ima01,'aim-001',1)
         RETURN
      END IF
                                                         #kim:加此行會累計所有下階料號的成本,展到底,不加此行只展下一階
   END FOR
END FUNCTION
 
FUNCTION p001_sum(l_bmb03,l_bmb06,l_bmb07,l_bmb08,l_bmb10_fac) #CHI-710055 #FUN-890103 add l_bma10_fac
   DEFINE l_sql STRING
   DEFINE l_bmb03 LIKE bmb_file.bmb03
   DEFINE l_bmb06 LIKE bmb_file.bmb06 #CHI-710055
   DEFINE l_bmb07 LIKE bmb_file.bmb07 #CHI-710055
   DEFINE l_bmb08 LIKE bmb_file.bmb08 #CHI-710055
   DEFINE l_bmb10_fac LIKE bmb_file.bmb10_fac #FUN-890103
   DEFINE l_imb RECORD LIKE imb_file.*
   
   LET l_sql="SELECT (imb111+imb121  )*",l_bmb06,"/",l_bmb07,"*(1+",l_bmb08,"/100)*",l_bmb10_fac,",", 
             "       (imb112+imb122  )*",l_bmb06,"/",l_bmb07,"*(1+",l_bmb08,"/100)*",l_bmb10_fac,",",
             "       (imb1131+imb1231)*",l_bmb06,"/",l_bmb07,"*(1+",l_bmb08,"/100)*",l_bmb10_fac,",",
             "       (imb1132+imb1232)*",l_bmb06,"/",l_bmb07,"*(1+",l_bmb08,"/100)*",l_bmb10_fac,",",  #MOD-710106 moidfy imb1131-> imb1132 
             "       (imb119+imb129  )*",l_bmb06,"/",l_bmb07,"*(1+",l_bmb08,"/100)*",l_bmb10_fac,",",
             "       (imb114+imb124  )*",l_bmb06,"/",l_bmb07,"*(1+",l_bmb08,"/100)*",l_bmb10_fac,",",
             "       (imb115+imb125  )*",l_bmb06,"/",l_bmb07,"*(1+",l_bmb08,"/100)*",l_bmb10_fac,",",
             "       (imb1151+imb1251)*",l_bmb06,"/",l_bmb07,"*(1+",l_bmb08,"/100)*",l_bmb10_fac,",",
             "       (imb116+imb126  )*",l_bmb06,"/",l_bmb07,"*(1+",l_bmb08,"/100)*",l_bmb10_fac,",",
             "       (imb1171+imb1271)*",l_bmb06,"/",l_bmb07,"*(1+",l_bmb08,"/100)*",l_bmb10_fac,",",
             "       (imb1172+imb1272)*",l_bmb06,"/",l_bmb07,"*(1+",l_bmb08,"/100)*",l_bmb10_fac,",",
             "       (imb120+imb130  )*",l_bmb06,"/",l_bmb07,"*(1+",l_bmb08,"/100)*",l_bmb10_fac," ",  
             "  FROM imb_file WHERE imb01='",l_bmb03,"'"
   PREPARE p001_sum_c1_p FROM l_sql
   DECLARE p001_sum_c1 CURSOR FOR p001_sum_c1_p
   OPEN p001_sum_c1
   FETCH p001_sum_c1 INTO l_imb.imb121 ,
                          l_imb.imb122 ,
                          l_imb.imb1231,
                          l_imb.imb1232,
                          l_imb.imb129 ,
                          l_imb.imb124 ,
                          l_imb.imb125 ,
                          l_imb.imb1251,
                          l_imb.imb126 ,
                          l_imb.imb1271,
                          l_imb.imb1272,
                          l_imb.imb130
   CLOSE p001_sum_c1
   IF cl_null(l_imb.imb121 ) THEN LET l_imb.imb121 =0 END IF
   IF cl_null(l_imb.imb122 ) THEN LET l_imb.imb122 =0 END IF
   IF cl_null(l_imb.imb1231) THEN LET l_imb.imb1231=0 END IF
   IF cl_null(l_imb.imb1232) THEN LET l_imb.imb1232=0 END IF
   IF cl_null(l_imb.imb129 ) THEN LET l_imb.imb129 =0 END IF
   IF cl_null(l_imb.imb124 ) THEN LET l_imb.imb124 =0 END IF
   IF cl_null(l_imb.imb125 ) THEN LET l_imb.imb125 =0 END IF
   IF cl_null(l_imb.imb1251) THEN LET l_imb.imb1251=0 END IF
   IF cl_null(l_imb.imb126 ) THEN LET l_imb.imb126 =0 END IF
   IF cl_null(l_imb.imb1271) THEN LET l_imb.imb1271=0 END IF
   IF cl_null(l_imb.imb1272) THEN LET l_imb.imb1272=0 END IF
   IF cl_null(l_imb.imb130 ) THEN LET l_imb.imb130 =0 END IF
   
   LET g_imb.imb121  = g_imb.imb121  + l_imb.imb121 
   LET g_imb.imb122  = g_imb.imb122  + l_imb.imb122 
   LET g_imb.imb1231 = g_imb.imb1231 + l_imb.imb1231
   LET g_imb.imb1232 = g_imb.imb1232 + l_imb.imb1232
   LET g_imb.imb129  = g_imb.imb129  + l_imb.imb129 
   LET g_imb.imb124  = g_imb.imb124  + l_imb.imb124 
   LET g_imb.imb125  = g_imb.imb125  + l_imb.imb125 
   LET g_imb.imb1251 = g_imb.imb1251 + l_imb.imb1251
   LET g_imb.imb126  = g_imb.imb126  + l_imb.imb126 
   LET g_imb.imb1271 = g_imb.imb1271 + l_imb.imb1271
   LET g_imb.imb1272 = g_imb.imb1272 + l_imb.imb1272
   LET g_imb.imb130  = g_imb.imb130  + l_imb.imb130 
END FUNCTION

FUNCTION p001_defprice(p_part,p_vender,p_task,p_outsoucing)
   DEFINE p_part     LIKE pmh_file.pmh01,
          p_vender   LIKE pmh_file.pmh02,
          p_task     LIKE pmj_file.pmj10
   DEFINE l_j07r05   LIKE pmj_file.pmj07,  # 若分量計價pmi05='Y',l_j07r05=pmr05
          l_pmi01    LIKE pmi_file.pmi01,
          l_pmi05    LIKE pmi_file.pmi05, 
          l_pmj02    LIKE pmj_file.pmj02,
          l_pmj05    LIKE pmj_file.pmj05,
          l_pmj09    LIKE pmj_file.pmj09,
          l_rate     LIKE oea_file.oea24,
          l_sql      STRING
   DEFINE p_outsoucing LIKE type_file.chr1
   DEFINE l_pmj12    LIKE pmj_file.pmj12
   DEFINE l_bdate    LIKE type_file.dat
   DEFINE l_edate    LIKE type_file.dat
   
   IF p_outsoucing = 'Y' THEN
      LET l_pmj12 = '2'   #委外
   ELSE
      LET l_pmj12 = '1'   #採購
   END IF
   #抓取離畫面最近的核價單日期
   CALL s_ymtodate(tm.yy,tm.mm,tm.yy,tm.mm) RETURNING l_bdate,l_edate 
   LET l_sql = " SELECT pmi01,pmi05,pmj02,pmj05,pmj07,pmj09  ",    
               "   FROM pmj_file,pmi_file ",
               "  WHERE pmi01 = pmj01",        #核價單號
               "    AND pmj03 = '",p_part,"'",
               "    AND pmj09<= '",l_edate,"'",
               "    AND pmiconf ='Y' ",
               "    AND pmiacti ='Y' ",
               "    AND pmi03 = '",p_vender,"'",
               "    AND pmj12 = '",l_pmj12,"'"

   IF NOT cl_null(p_task) THEN
      LET l_sql = l_sql CLIPPED,
                  " AND pmj10 = '",p_task,"'", #作業編號
                  " AND pmj09 = ",
                  " (SELECT MAX(pmj09) FROM pmj_file,pmi_file ",
                  "   WHERE pmi01 = pmj01 ",
                  "     AND pmi03 = '",p_vender,"'",
                  "     AND pmj03 = '",p_part,"'",
                  "     AND pmj10 = '",p_task,"'",
                  "     AND pmiconf = 'Y' ",
                  "     AND pmiacti = 'Y' ",
                  "     AND pmj12 = '",l_pmj12,"'",
                  "     AND pmj09 <= '",l_edate,"')",
                  " ORDER BY pmj09 DESC "
   ELSE
      LET l_sql = l_sql CLIPPED,
                  " AND (pmj10 =' ' OR pmj10 = '' OR pmj10 IS NULL) ",
                  " AND pmj09 = ",
                  " (SELECT MAX(pmj09) FROM pmj_file,pmi_file ",
                  "   WHERE pmi01=pmj01 ",
                  "     AND pmi03 = '",p_vender,"'",
                  "     AND pmj03 = '",p_part,"'",
                  "     AND (pmj10 =' ' OR pmj10 = '' OR pmj10 IS NULL) ",
                  "     AND pmiconf = 'Y' ",
                  "     AND pmiacti = 'Y' ",
                  "     AND pmj12 = '",l_pmj12,"'",
                  "     AND pmj09 <= '",l_edate,"')",
                  " ORDER BY pmj09 DESC "
   END IF
   PREPARE pmj_pre FROM l_sql
   DECLARE pmj_cur CURSOR FOR pmj_pre
   OPEN pmj_cur
   FETCH pmj_cur INTO l_pmi01,l_pmi05,l_pmj02,l_pmj05,l_j07r05,l_pmj09   
   CLOSE pmj_cur

   IF l_pmi05 = 'Y' THEN          #分量計算
      DECLARE pmr05_cur CURSOR FOR
       SELECT pmr05               #分量計算的單價
         FROM pmr_file
        WHERE pmr01 = l_pmi01 AND pmr02 = l_pmj02
        ORDER BY pmr05
      FOREACH pmr05_cur INTO l_j07r05
         IF NOT cl_null(l_j07r05) THEN
            EXIT FOREACH
         END IF
      END FOREACH
   END IF

   IF cl_null(l_j07r05) OR l_j07r05 <=0 THEN 
      LET l_j07r05 = 0 
   END IF

   IF g_aza.aza17 <> l_pmj05 THEN
      #取中價匯率
      LET l_rate = s_curr3(l_pmj05,g_today,'M')
   ELSE
      LET l_rate=1
   END IF
   LET l_j07r05 = l_j07r05 * l_rate
   RETURN l_j07r05          
END FUNCTION
#No.FUN-9C0072 精簡程式碼
