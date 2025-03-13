# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: asfp640.4gl
# Descriptions...: 工單清除作業
# Date & Author..: 93/02/12 By David
# Modify.........: NO.MOD-580222 05/08/23 by Rosayu cl_used只可以在main的進入點跟退出點呼叫兩次
# Modify.........: No.FUN-660128 06/06/19 By Xumin cl_err --> cl_err3
# Modify.........: No.FUN-680121 06/08/29 By huchenghao 類型轉換
# Modify.........: No.FUN-660047 06/10/26 By Sarah 選擇方式改用勾選輸入較方便
# Modify.........: No.FUN-6A0090 06/11/07 By douzh l_time轉g_time
# Modify.........: No.FUN-710026 07/01/15 By hongmei 錯誤訊息匯總顯示修改
# Modify.........: No.FUN-7B0018 08/02/20 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.CHI-7B0034 08/07/08 By sherry 增加被替代料為Key值
# Modify.........: No.FUN-8A0086 08/10/21 By baofei 完善FUN-710050的錯誤匯總的修改
# Modify.........: No.TQC-940121 09/05/08 By mike 畫面中不存在cn3欄位 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A60081 10/06/18 By vealxu 製造功能優化-平行制程（批量修改）
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm     RECORD                            # Print condition RECORD
         wc       LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(300)# Where condition
         a        LIKE type_file.chr1           #No.FUN-680121 VARCHAR(1)# 是否需逐一確認
              END RECORD,
       g_sfi  RECORD LIKE sfi_file.*,
       g_sfj  RECORD LIKE sfj_file.*
DEFINE g_rec_b    LIKE type_file.num5           #No.FUN-680121 SMALLINT   #FUN-660047 add
DEFINE g_cnt      LIKE type_file.num20          #No.FUN-680121 INTEGER
DEFINE g_i        LIKE type_file.num5           #count/index for any purpose   #No.FUN-680121 SMALLINT
DEFINE g_msg      LIKE type_file.chr1000        #No.FUN-680121 VARCHAR(72)
DEFINE l_flag     LIKE type_file.chr1           #Print tm.wc ?(Y/N)            #No.FUN-680121 VARCHAR(1)
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time  #MOD-580222 add  #No.FUN-6A0090
 
   LET g_success = 'Y'
   BEGIN WORK
   WHILE TRUE
      CALL asfp640_tm(0,0)            # Read data and create out-file
      IF tm.a MATCHES'[yY]' THEN
         OPEN WINDOW asfp6401_w AT 3,2
         WITH FORM "asf/42f/asfp6401"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
         CALL cl_ui_locale("asfp6401")
         CALL asfp640_2()            # Read data and create out-file
         CLOSE WINDOW asfp6401_w
         ERROR ''
      ELSE
         CALL asfp640_1()            # Read data and create out-file
      END IF
         CALL s_showmsg()            #NO.FUN-710026
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
            EXIT WHILE
         END IF
   END WHILE
 
   CLOSE WINDOW asfp640_w
 
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time  #MOD-580222 add  #No.FUN-6A0090
END MAIN
 
FUNCTION asfp640_tm(p_row,p_col)
   DEFINE   p_row,p_col   LIKE type_file.num5,          #No.FUN-680121 SMALLINT
            l_cmd         LIKE type_file.chr1000        #No.FUN-680121 VARCHAR(400)
 
 
   LET p_row = 4
   LET p_col = 12
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 6
      LET p_col = 5
   ELSE
      LET p_row = 4
      LET p_col = 12
   END IF
 
   OPEN WINDOW asfp640_w AT p_row,p_col
        WITH FORM "asf/42f/asfp640"
################################################################################
# START genero shell script ADD
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.a    = 'Y'
   WHILE TRUE
      CLEAR FORM
      CONSTRUCT BY NAME tm.wc ON sfb02,sfb01,sfb05,sfb15
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON ACTION locale
          CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
         ON ACTION exit                            #加離開功能
            LET INT_FLAG = 1
            EXIT CONSTRUCT
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
      END CONSTRUCT
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW asfp640_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
      DISPLAY BY NAME tm.a     # Condition
 
      INPUT BY NAME tm.a   WITHOUT DEFAULTS
 
         AFTER FIELD a
            IF tm.a NOT MATCHES "[YN]" THEN
               NEXT FIELD a
            END IF
            CALL cl_err(g_user,'asf-515',1)
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()    # Command execution
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
         ON ACTION exit                            #加離開功能
            LET INT_FLAG = 1
            EXIT INPUT
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
      END INPUT
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW asfp640_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
      EXIT WHILE
      ERROR ""
   END WHILE
END FUNCTION
 
FUNCTION asfp640_1()
   DEFINE
      l_name       LIKE type_file.chr20,         #No.FUN-680121 VARCHAR(20)# External(Disk) file name
#       l_time      LIKE type_file.chr8           #No.FUN-6A0090
      l_sql        LIKE type_file.chr1000,       # RDSQL STATEMENT                      #No.FUN-680121 VARCHAR(600)
      l_chr        LIKE type_file.chr1,                                                 #No.FUN-680121 VARCHAR(1)
      l_za05       LIKE type_file.chr1000,                                              #No.FUN-680121 VARCHAR(40)
      l_order      ARRAY[4] OF LIKE apm_file.apm08,                                     #No.FUN-680121 VARCHAR(07)
      sr           RECORD
                   sfb01  LIKE sfb_file.sfb01,
                   sfb02  LIKE sfb_file.sfb02,
                   sfb05  LIKE sfb_file.sfb05,
                   sfb071 LIKE sfb_file.sfb071,
                   sfb08  LIKE sfb_file.sfb08,
                   sfb13  LIKE sfb_file.sfb13,
                   sfb15  LIKE sfb_file.sfb15,
                   sfb40  LIKE sfb_file.sfb40,
                   sfb06  LIKE sfb_file.sfb06,
                   sfb34  LIKE sfb_file.sfb34,
                   sfb23  LIKE sfb_file.sfb23,
                   sfb24  LIKE sfb_file.sfb24,
                   sfb93  LIKE sfb_file.sfb93,
                   sfb251 LIKE sfb_file.sfb251
                   END RECORD
   DEFINE  l_flag  LIKE type_file.chr1       #No.FUN-7B0018
   DEFINE  b_flag  LIKE type_file.chr1       #No.FUN-7B0018
 
   #CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No:BUG-580088  HCN 20050818 #MOD-580222 mark  #No.FUN-6A0090
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
   SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'asfp640'
   IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
   FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND sfbuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND sfbgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET tm.wc = tm.wc clipped," AND sfbgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('sfbuser', 'sfbgrup')
   #End:FUN-980030
 
   LET l_sql = "SELECT sfb01,sfb02,sfb05,sfb071,sfb08, ",
               "       sfb13,sfb15,sfb40,sfb06,sfb34,  ",
               "       sfb23,sfb24,sfb93,sfb251 ",
               "  FROM sfb_file ",
               " WHERE sfb04 = '8' AND ", tm.wc
 
   PREPARE asfp640_prepare1 FROM l_sql
   IF SQLCA.sqlcode  THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
   DECLARE asfp640_curs1 CURSOR FOR asfp640_prepare1
   CALL cl_outnam('asfp640') RETURNING l_name
# genero  script marked    LET g_pageno = 0
   CALL s_showmsg_init()    #NO.FUN-710026
   FOREACH asfp640_curs1 INTO sr.*
#NO.FUN-710026-----begin add
         IF g_success='N' THEN                                                                                                          
            LET g_totsuccess='N'                                                                                                       
            LET g_success="Y"                                                                                                          
         END IF                    
#NO.FUN-710026-----end
 
      IF SQLCA.sqlcode != 0 THEN
#        CALL cl_err('foreach:',SQLCA.sqlcode,1)       #NO.FUN-710026
         EXIT FOREACH
      END IF
      SELECT * INTO g_sfi.*  FROM sfb_file WHERE sfb01 = sr.sfb01
      LET g_sfi.sfioriu = g_user      #No.FUN-980030 10/01/04
      LET g_sfi.sfiorig = g_grup      #No.FUN-980030 10/01/04
      LET g_sfi.sfiplant= g_plant     #FUN-A60081
      LET g_sfi.sfilegal= g_legal     #FUN-A60081
      INSERT INTO sfi_file VALUES(g_sfi.*)
      IF SQLCA.sqlcode THEN
#        CALL cl_err('Insert sfi_file Error :',SQLca.sqlcode,1)   #No.FUN-660128
#        CALL cl_err3("ins","sfi_file",g_sfi.sfi01,"",SQLCA.sqlcode,"","Insert sfi_file Error :",1)    #No.FUN-660128 #NO.FUN-710026
         CALL s_errmsg('sfb01','sr.sfb01','Insert sfi_file Error :',SQLca.sqlcode,1)                   #NO.FUn-710026
         LET g_success = 'N'
         EXIT FOREACH
      ELSE
         DECLARE asfp640_sfa_cur1 CURSOR FOR
         SELECT * FROM sfa_file WHERE sfa01 = sr.sfb01
         FOREACH asfp640_sfa_cur1 INTO g_sfj.*
#NO.FUN-710026-----begin add
         IF g_success='N' THEN                                                                                                          
            LET g_totsuccess='N'                                                                                                       
            LET g_success="Y"                                                                                                          
         END IF                    
#NO.FUN-710026-----end
 
            LET g_sfj.sfjplant= g_plant     #FUN-A60081
            LET g_sfj.sfjlegal= g_legal     #FUN-A60081
            IF cl_null(g_sfj.sfj07) THEN LET g_sfj.sfj07=0 END IF #FUN-A60081
            INSERT INTO sfj_file VALUES(g_sfj.*)
            IF SQLCA.sqlcode THEN
#              CALL cl_err('Insert sfj_file Error :',SQLca.sqlcode,1)   #No.FUN-660128
#              CALL cl_err3("ins","sfj_file",g_sfj.sfj01,g_sfj.sfj03,SQLCA.sqlcode,"","Insert sfj_file Error :",1)    #No.FUN-660128 #NO.FUN-710026
               CALL s_errmsg('sfa01','sr.sfb01','Insert sfj_file Error :',SQLca.sqlcode,1)           #NO.FUN-710026
               LET g_success = 'N'
               EXIT FOREACH
            END IF
         END FOREACH
 
      END IF
      IF sr.sfb93 ='Y' AND g_sma.sma26 !='1' THEN
         DELETE FROM ecm_file WHERE ecm01 = sr.sfb01
         IF SQLCA.sqlcode THEN
#           CALL cl_err('Del ecm_file:',SQLCA.sqlcode,1)   #No.FUN-660128
#           CALL cl_err3("del","ecm_file",sr.sfb01,"",SQLCA.sqlcode,"","Del ecm_file:",1)    #No.FUN-660128 #NO.FUN-710026
            CALL s_errmsg('ecm01','sr.sfb01','Del ecm_file:',SQLCA.sqlcode,1)                #NO.FUN-710026
            LET g_success ='N'
         END IF
      END IF
      IF g_success != 'N' THEN
         DELETE FROM sfb_file WHERE sfb01 = sr.sfb01
         #NO.FUN-7B0018 08/02/20 add --begin
         IF NOT s_industry('std') THEN
            LET l_flag = s_del_sfbi(sr.sfb01,'')
         END IF
         #NO.FUN-7B0018 08/02/20 add --end
         DELETE FROM sfa_file WHERE sfa01 = sr.sfb01
         #NO.FUN-7B0018 08/02/20 add --begin
         IF NOT s_industry('std') THEN
            LET b_flag = s_del_sfai(sr.sfb01,'','','','','','','') #CHI-7B0034      #FUN-A60081 add 2''
         END IF
         #NO.FUN-7B0018 08/02/20 add --end
      END IF
   END FOREACH
#NO.FUN-710026----begin 
         IF g_totsuccess="N" THEN                                                                                                         
            LET g_success="N"                                                                                                             
         END IF 
#NO.FUN-710026----end
     #CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No:BUG-580088  HCN 20050818 #MOD-580222 mark  #No.FUN-6A0090
END FUNCTION
 
FUNCTION asfp640_2()
   DEFINE
      l_name           LIKE type_file.chr20,         #No.FUN-680121 VARCHAR(20)# External(Disk) file name
#       l_time      LIKE type_file.chr8               #No.FUN-6A0090
      l_sql            LIKE type_file.chr1000,       # RDSQL STATEMENT                      #No.FUN-680121 VARCHAR(600)
      l_chr            LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
      l_za05           LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(40)
      l_order          ARRAY[4] OF LIKE apm_file.apm08,#No.FUN-680121 VARCHAR(7)
      g_arrcnt         LIKE type_file.num5,          #No.FUN-680121 SMALLINT
      l_ac,l_sl,l_cnt  LIKE type_file.num5,          #No.FUN-680121 SMALLINT
      l_cmd            LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(60)
      l_sfb06          LIKE sfb_file.sfb06,
      l_sfb23          LIKE sfb_file.sfb23,
      l_sfb24          LIKE sfb_file.sfb24,
      l_sfb251         LIKE sfb_file.sfb251,
      l_sfb93          ARRAY[40] OF LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
      l_sfb            DYNAMIC ARRAY OF RECORD
          sure         LIKE type_file.chr1,                       #No.FUN-680121 VARCHAR(1)
          sfb01        LIKE sfb_file.sfb01,      #工單編號
          sfb05        LIKE sfb_file.sfb05,      #料件編號
          sfb02        LIKE sfb_file.sfb02,      #型態
          sfb071       LIKE sfb_file.sfb071,     #BOM 有效日
          sfb40        LIKE sfb_file.sfb40,      #優先比率
          sfb34        LIKE sfb_file.sfb34,      #緊急比率
          sfb13        LIKE sfb_file.sfb13,      #開工日期
          sfb15        LIKE sfb_file.sfb15,      #完工日期
          sfb08        LIKE sfb_file.sfb08,      #生產數量
          ima55        LIKE ima_file.ima55       #生產單位
                   END RECORD,
      g_i              LIKE type_file.num5,      #No.FUN-680136 SMALLINT      #FUN-660047 add
      l_allow_insert   LIKE type_file.num5,      #No.FUN-680136 SMALLINT      #FUN-660047 add
      l_allow_delete   LIKE type_file.num5       #No.FUN-680136 SMALLINT      #FUN-660047 add
  DEFINE  l_flag       LIKE type_file.chr1       #No.FUN-7B0018
  DEFINE  b_flag       LIKE type_file.chr1       #No.FUN-7B0018
 
  #CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No:BUG-580088  HCN 20050818 #MOD-580222 mark  #No.FUN-6A0090
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
   SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'asfp640'
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND sfbuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND sfbgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET tm.wc = tm.wc clipped," AND sfbgrup IN ",cl_chk_tgrup_list()
   #   END IF
   #End:FUN-980030
 
  #LET l_sql = "SELECT '',sfb01,sfb05,sfb02,sfb071,sfb40,sfb34, ",    #FUN-660047 mark
   LET l_sql = "SELECT 'N',sfb01,sfb05,sfb02,sfb071,sfb40,sfb34, ",   #FUN-660047
               "       sfb13,sfb15,sfb08,ima55,sfb93 ",
               "  FROM sfb_file,ima_file ",
               " WHERE sfb04 = '8' AND  ima01 = sfb05 AND ",
               tm.wc CLIPPED
   PREPARE p640_prepare2 FROM l_sql
   IF SQLCA.sqlcode  THEN
#     CALL cl_err('prepare:',SQLCA.sqlcode,1)                         #NO.FUN-710026
      CALL s_errmsg('','','prepare:',SQLCA.sqlcode,1)                 #NO.FUN-710026
      LET g_success = 'N'
      RETURN
   END IF
   DECLARE p640_curs2 CURSOR WITH HOLD FOR p640_prepare2
   WHILE TRUE
   LET g_arrcnt = 40
      CALL l_sfb.clear()
      LET g_cnt=1                                               #總選取筆數
      CALL s_showmsg_init()    #NO.FUN-710026
      FOREACH p640_curs2 INTO l_sfb[g_cnt].*,l_sfb93[g_cnt]     #逐筆抓出
#NO.FUN-710026-----begin add
         IF g_success='N' THEN                                                                                                          
            LET g_totsuccess='N'                                                                                                       
            LET g_success="Y"                                                                                                          
         END IF                    
#NO.FUN-710026-----end
         IF SQLCA.sqlcode THEN                                  #有問題
#           CALL cl_err('FOREACH:',SQLCA.sqlcode,1)             #NO.FUN-710026
            LET g_success = 'N'  #No.FUN-8A0086
            CALL s_errmsg('','','FOREACH:',SQLCA.sqlcode,1)     #NO.FUN-710026
#           EXIT FOREACH                                        #NO.FUN-710026
            CONTINUE FOREACH                                    #NO.FUN-710026
         END IF
         LET g_cnt = g_cnt + 1                           #累加筆數
         IF g_cnt > g_arrcnt THEN                         #超過肚量了
#           CALL cl_err('','9035',0)                      #NO.FUN-710026
            CALL s_errmsg('','','','9035',0)              #NO.FUN-710026   
#           EXIT FOREACH
            CONTINUE FOREACH                              #NO.FUN-710026
         END IF
      END FOREACH
#NO.FUN-710026----begin 
     IF g_totsuccess="N" THEN                                                                                                         
        LET g_success="N"                                                                                                             
        END IF 
#NO.FUN-710026----end
 
      CALL l_sfb.deleteElement(g_cnt)        #FUN-660047 add
      IF g_cnt <= 1 THEN                                 #沒有抓到
         CALL cl_err('','asf-332',1)                     #顯示錯誤, 並回去
         EXIT WHILE
      END IF
      LET g_cnt=g_cnt-1                                  #正確的總筆數
      CALL SET_COUNT(g_cnt)                              #告之DISPALY ARRAY
      CALL cl_getmsg('asf-331',g_lang) RETURNING g_msg
      MESSAGE g_msg
      CALL ui.Interface.refresh()
     #DISPLAY g_cnt TO FORMONLY.cn3  #顯示總筆數 #TQC-940121 
      LET l_cnt=0                                     #已選筆數
      DISPLAY l_cnt TO FORMONLY.cn2
 
     #start FUN-660047 mark
     #CALL cl_set_act_visible("accept,cancel", TRUE)
     #DISPLAY ARRAY l_sfb TO s_sfb.*  #顯示並進行選擇
     #    ON ACTION CONTROLR
     #        CALL cl_show_req_fields()
     #    ON ACTION CONTROLG
     #       CALL cl_cmdask()
     #    ON ACTION select_cancel #選擇或取消
     #       LET l_ac = ARR_CURR()
     #       LET l_sl = SCR_LINE()
     #       IF l_sfb[l_ac].sure IS NULL OR l_sfb[l_ac].sure=' ' THEN
     #          LET l_sfb[l_ac].sure='Y'          #設定為選擇
     #          LET l_cnt=l_cnt+1                   #累加已選筆數
     #       ELSE
     #          LET l_sfb[l_ac].sure=''           #設定為不選擇
     #          LET l_cnt=l_cnt-1                   #減少已選筆數
     #       END IF
     #       DISPLAY l_sfb[l_ac].sure TO s_sfb[l_sl].sure
     #    ON ACTION qry_wo  #查詢工單明細
     #       LET l_ac = ARR_CURR()
     #       LET l_cmd="asfi301 '",l_sfb[l_ac].sfb01,"' " #,"'","1","' ",
     #       CALL cl_cmdrun(l_cmd)
     #    ON IDLE g_idle_seconds
     #       CALL cl_on_idle()
     #       CONTINUE DISPLAY
     #END DISPLAY
     #CALL cl_set_act_visible("accept,cancel", TRUE)
     #IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF #使用者中斷
     #IF l_cnt < 1 THEN                               #已選筆數超過 0筆
     #   EXIT WHILE
     #END IF
     #end FUN-660047 mark
 
     #start FUN-660047 add
      LET g_rec_b = g_cnt
      LET l_ac = 0
      LET l_allow_insert = FALSE
      LET l_allow_delete = FALSE
 
      INPUT ARRAY l_sfb WITHOUT DEFAULTS FROM s_sfb.*
        ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                  INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
         BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
         BEFORE ROW
            LET l_ac = ARR_CURR()
 
         AFTER FIELD sure
            IF NOT cl_null(l_sfb[l_ac].sure) THEN
               IF l_sfb[l_ac].sure NOT MATCHES "[YN]" THEN
                  NEXT FIELD sure
               END IF
            END IF
 
         AFTER INPUT
            LET l_cnt  = 0
            FOR g_i =1 TO g_rec_b
               IF l_sfb[g_i].sure = 'Y' AND
                  NOT cl_null(l_sfb[g_i].sfb01)  THEN
                  LET l_cnt = l_cnt + 1
               END IF
            END FOR
            DISPLAY l_cnt TO FORMONLY.cn2
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
         ON ACTION select_all
            FOR g_i = 1 TO g_rec_b
                LET l_sfb[g_i].sure="Y"
            END FOR
            LET l_cnt = g_rec_b
            DISPLAY g_rec_b TO FORMONLY.cn2
 
         ON ACTION cancel_all
            FOR g_i = 1 TO g_rec_b
                LET l_sfb[g_i].sure="N"
            END FOR
            LET l_cnt = 0
            DISPLAY 0 TO FORMONLY.cn2
 
         AFTER ROW
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
 
         ON ACTION qry_wo  #查詢工單明細
            LET l_ac = ARR_CURR()
            LET l_cmd="asfi301 '",l_sfb[l_ac].sfb01,"' " #,"'","1","' ",
            CALL cl_cmdrun(l_cmd)
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
 
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
 
      END INPUT
     #end FUN-660047 add
 
      IF NOT cl_sure(0,0) THEN
         EXIT WHILE
      END IF
      CALL cl_wait()
      LET l_sl=0
      CALL cl_outnam('asfp640') RETURNING l_name
# genero  script marked       LET g_pageno = 0
      FOR l_ac=1 TO g_cnt
#NO.FUN-710026-----begin add
         IF g_success='N' THEN                                                                                                          
            LET g_totsuccess='N'                                                                                                       
            LET g_success="Y"                                                                                                          
         END IF                    
#NO.FUN-710026-----end 
 
         IF l_sfb[l_ac].sure='Y' THEN          #該單據要結案
            SELECT * INTO g_sfi.* FROM sfb_file
            WHERE sfb01 = l_sfb[l_ac].sfb01
            LET g_sfi.sfioriu = g_user      #No.FUN-980030 10/01/04
            LET g_sfi.sfiorig = g_grup      #No.FUN-980030 10/01/04
            LET g_sfi.sfiplant= g_plant     #FUN-A60081
            LET g_sfi.sfilegal= g_legal     #FUN-A60081
            INSERT INTO sfi_file VALUES(g_sfi.*)
            IF SQLCA.sqlcode THEN
#              CALL cl_err('Insert sfi_file Error :',SQLca.sqlcode,1)   #No.FUN-660128
#              CALL cl_err3("ins","sfi_file",g_sfi.sfi01,"",SQLca.sqlcode,"","Insert sfi_file Error :",1)    #No.FUN-660128 #NO.FUN-710026
               CALL s_errmsg('sfb01',l_sfb[l_ac].sfb01,'Insert sfi_file Error :',SQLca.sqlcode,1)          #NO.FUN-710026
               LET g_success = 'N'
               EXIT FOR
            ELSE
               DECLARE asfp640_sfa_cur CURSOR FOR
               SELECT * FROM sfa_file WHERE sfa01 = l_sfb[l_ac].sfb01
               FOREACH asfp640_sfa_cur INTO g_sfj.*
                  LET g_sfj.sfjplant= g_plant     #FUN-A60081
                  LET g_sfj.sfjlegal= g_legal     #FUN-A60081
                  IF cl_null(g_sfj.sfj07) THEN LET g_sfj.sfj07=0 END IF #FUN-A60081
                  INSERT INTO sfj_file VALUES(g_sfj.*)
                  IF SQLCA.sqlcode THEN
#                    CALL cl_err('Insert sfj_file Error :',SQLca.sqlcode,1)   #No.FUN-660128
#                    CALL cl_err3("ins","sfj_file",g_sfj.sfj01,g_sfj.sfj03,SQLCA.sqlcode,"","Insert sfj_file Error :",1)    #No.FUN-660128 #NO.FUN-710026
                     CALL s_errmsg('sfa01',l_sfb[l_ac].sfb01,'Insert sfj_file Error :',SQLca.sqlcode,1)                     #NO.FUN-710026
                     LET g_success = 'N'
                     EXIT FOREACH
                  END IF
               END FOREACH
               IF l_sfb93[l_ac]='Y' AND g_sma.sma26 !='1' THEN
                  DELETE FROM ecm_file WHERE ecm01 = l_sfb[l_ac].sfb01
                  IF SQLCA.sqlcode THEN
#                    CALL cl_err('Del ecm_file:',SQLCA.sqlcode,1)   #No.FUN-660128
#                    CALL cl_err3("del","ecm_file",l_sfb[l_ac].sfb01,"",SQLCA.sqlcode,"","Del ecm_file:",1)    #No.FUN-660128  #NO.FUN-710026
                     CALL s_errmsg('ecm01',l_sfb[l_ac].sfb01,'Del ecm_file:',SQLCA.sqlcode,1)                #NO.FUN-710026
                     LET g_success ='N'
                  END IF
               END IF
               IF g_success != 'N' THEN
                  DELETE FROM sfb_file WHERE sfb01 = l_sfb[l_ac].sfb01
                  #NO.FUN-7B0018 08/02/20 add --begin
                  IF NOT s_industry('std') THEN
                     LET l_flag = s_del_sfbi(l_sfb[l_ac].sfb01,'')
                  END IF
                  #NO.FUN-7B0018 08/02/20 add --end
                  DELETE FROM sfa_file WHERE sfa01 = l_sfb[l_ac].sfb01
                  #NO.FUN-7B0018 08/02/20 add --begin
                  IF NOT s_industry('std') THEN
                     LET b_flag = s_del_sfai(l_sfb[l_ac].sfb01,'','','','','','','') #CHI-7B0034    #FUN-A60081  add 2''
                  END IF
                  #NO.FUN-7B0018 08/02/20 add --end
               END IF
            END IF
         END IF
      END FOR
#NO.FUN-710026----begin 
     IF g_totsuccess="N" THEN                                                                                                         
        LET g_success="N"                                                                                                             
     END IF 
#NO.FUN-710026----end
 
        #CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No:BUG-580088  HCN 20050818 #MOD-580222 mark  #No.FUN-6A0090
      ERROR""
      EXIT WHILE
   END WHILE
END FUNCTION
#Patch....NO.TQC-610037 <001> #
