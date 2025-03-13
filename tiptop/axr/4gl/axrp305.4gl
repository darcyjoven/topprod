# Prog. Version..: '5.30.06-13.04.17(00010)'     #
#
# Pattern name...: axrp305.4gl
# Descriptions...: 退款衝帳單整批生成作業
# Date & Author..: #FUN-960140 09/06/30 By lutingting
# Modify.........: No.FUN-980011 09/08/18 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-9C0009 09/12/02 by dxfwo  GP5.2 變更檔案權限時應使用 os.Path.chrwx 指令
# Modify.........: No:TQC-9C0057 09/12/09 By Carrier 状况码赋值
# Modify.........: No.FUN-9C0168 10/01/04 By lutingting 款別對應銀行改由axri060抓取
# Modify.........: No.FUN-A50102 10/06/21 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-A40076 10/07/02 By xiaofeizhu ooa37 = 'Y' 改成 ooa37 = '2'
# Modify.........: No.FUN-A60056 10/07/09 By lutingting GP5.2財務串前段問題整批調整
# Modify.........: No.TQC-B10050 11/01/10 By wuxj 條件選項衝賬單應該為ooytype='32'類型的單別,退款方式為儲值卡時,報錯修改,生成預收
# Modify.........: NO.FUN-B30166 11/03/29 By zhangweib nme_file add nme27
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:FUN-B80072 11/08/08 By Lujh 模組程序撰寫規範修正
# Modify.........: No:TQC-B90044 11/09/06 By guoch 营运中心编号设置默认值
# Modify.........: No.FUN-B90062 11/09/15 By wujie 产生nme_file时同时产生tic_file 
# Modify.........: No:FUN-D30097 13/04/01 By Sakura 訂金退回單據優化
# Modify.........: No:MOD-D40115 13/04/17 By apo 自動取號性質改為32
  
IMPORT os   #No.FUN-9C0009 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
         tm       RECORD
                  emp           LIKE   ooa_file.ooa14,
                  dept          LIKE   ooa_file.ooa15,
                  con_no        LIKE   ooa_file.ooa01,
                  col_date      LIKE   ooa_file.ooa02
                  END RECORD
DEFINE   g_oma    RECORD        LIKE   oma_file.*
DEFINE   g_rxa    RECORD        LIKE   rxa_file.*
DEFINE   g_ooa    RECORD        LIKE   ooa_file.*
DEFINE   g_oob    RECORD        LIKE   oob_file.*
DEFINE   b_oob    RECORD        LIKE   oob_file.*
DEFINE   g_ooy    RECORD        LIKE   ooy_file.*
DEFINE   g_bookno1              LIKE   aza_file.aza81
DEFINE   g_bookno2              LIKE   aza_file.aza82
DEFINE   g_flag                 LIKE   type_file.chr1
DEFINE   g_t1                   LIKE   ooy_file.ooyslip
DEFINE   g_t2                   LIKE   ooy_file.ooyslip
DEFINE   g_wc     STRING
DEFINE   g_sql    STRING
DEFINE   g_cnt                  LIKE type_file.num10
DEFINE   g_start_no,g_end_no    LIKE ooa_file.ooa01
DEFINE   g_a                    DYNAMIC ARRAY OF RECORD
             ooa01              LIKE ooa_file.ooa01
         END RECORD
DEFINE   g_wc_gl                STRING
DEFINE   g_str                  STRING
DEFINE   g_fla                  LIKE type_file.chr1
DEFINE   g_wc2                  STRING    #FUN-A60056 
DEFINE   l_azw01                LIKE azw_file.azw01    #FUN-A60056
MAIN
DEFINE p_row,p_col LIKE type_file.num5
   OPTIONS
        INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXR")) THEN
      EXIT PROGRAM
   END IF
 
   OPEN WINDOW p305_w AT p_row,p_col WITH FORM "axr/42f/axrp305"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   CALL cl_opmsg('z')
 
   CALL p305()
 
   CLOSE WINDOW p305_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
 
   IF INT_FLAG THEN LET INT_FLAG = 0 END IF
 
END MAIN
 
FUNCTION p305()
 
  DEFINE   l_flag       LIKE type_file.chr1
  DEFINE   li_result    LIKE type_file.num5
  DEFINE   l_ooyacti    LIKE ooy_file.ooyacti
  DEFINE   l_gen01      LIKE gen_file.gen01
  DEFINE   l_gen03      LIKE gen_file.gen03
  DEFINE   l_genacti    LIKE gen_file.genacti
  DEFINE   l_gem01      LIKE gem_file.gem01
  DEFINE   l_gemacti    LIKE gem_file.gemacti
  DEFINE   l_cmd        LIKE type_file.chr1000
 
WHILE TRUE
   LET g_action_choice = ""
 
   CLEAR FORM

#FUN-A60056--add--str--
      CONSTRUCT BY NAME g_wc2 ON azw01

         BEFORE CONSTRUCT
             CALL cl_qbe_init()
             DISPLAY g_plant TO azw01   #TQC-B90044 add

         ON ACTION exit
            LET INT_FLAG = 1
            EXIT CONSTRUCT

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT

         ON ACTION about
            CALL cl_about()

         ON ACTION help
            CALL cl_show_help()

         ON ACTION controlg
            CALL cl_cmdask()

         ON ACTION qbe_select
            CALL cl_qbe_select()

         ON ACTION CONTROLP
            CASE
              WHEN INFIELD(azw01)   #來源營運中心
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_azw"
                   LET g_qryparam.where = "azw02 = '",g_legal,"' "
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO azw01
                   NEXT FIELD azw01
            END CASE
      END CONSTRUCT

      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p305_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
#FUN-A60056--add--end

  #CONSTRUCT BY NAME g_wc ON rxaplant,rxa01,rxa02,oma01,rxa03   #FUN-A60056
   CONSTRUCT BY NAME g_wc ON rxa01,rxa02,oma01,rxa03   #FUN-A60056
 
     BEFORE CONSTRUCT
       CALL cl_qbe_init()
 
     ON ACTION CONTROLP
        CASE
         #FUN-A60056--mark--str--
         #WHEN INFIELD(rxaplant)
         #  CALL cl_init_qry_var()
         #  LET g_qryparam.form = 'q_azp'
         #  LET g_qryparam.where = " azp03 = '",g_dbs,"' " 
         #  LET g_qryparam.state = 'c'
         #  CALL cl_create_qry()  RETURNING g_qryparam.multiret
         #  DISPLAY  g_qryparam.multiret   TO rxaplant 
         #  NEXT FIELD rxaplant
         #FUN-A60056--mark--end
          WHEN INFIELD(rxa01)
            CALL cl_init_qry_var()
            LET g_qryparam.form = 'q_rxa04'
            LET g_qryparam.state = 'c'
            CALL cl_create_qry()  RETURNING g_qryparam.multiret
            DISPLAY  g_qryparam.multiret  TO rxa01
            NEXT FIELD rxa01
          WHEN INFIELD(rxa02)
            CALL cl_init_qry_var()
            LET g_qryparam.form = 'q_oea21'
            LET g_qryparam.state = 'c'
            CALL cl_create_qry()  RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO rxa02
            NEXT FIELD rxa02
          WHEN INFIELD(oma01)
            CALL cl_init_qry_var()
            LET g_qryparam.form = 'q_oma01'
            LET g_qryparam.state = 'c'
            CALL cl_create_qry()  RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO oma01
            NEXT FIELD oma01
          WHEN INFIELD(rxa03)
            CALL cl_init_qry_var()
            LET g_qryparam.form = 'q_occ'
            LET g_qryparam.state = 'c'
            CALL cl_create_qry()  RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO rxa03
            NEXT FIELD rxa03
        END CASE
     ON ACTION locale
        LET g_action_choice='locale'
        EXIT CONSTRUCT
     ON ACTION exit
        LET INT_FLAG = 1
        EXIT CONSTRUCT
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
 
     ON ACTION about
        CALL cl_about()
 
     ON ACTION help
        CALL cl_show_help()
 
     ON ACTION controlg
        CALL cl_cmdask()
 
     ON ACTION qbe_select
        CALL cl_qbe_select()
 
   END CONSTRUCT
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
   IF g_action_choice = 'locale' THEN
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
 
   IF INT_FLAG THEN
      RETURN
   END IF
 
   IF g_wc = ' 1=1' THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
 
   LET tm.emp = NULL
   LET tm.dept = NULL
   LET tm.con_no = NULL
   LET tm.col_date = NULL #FUN-D30097 add 
  #LET tm.col_date = g_today #FUN-D30097 mark 
 
   INPUT BY NAME tm.emp,tm.dept,tm.con_no,tm.col_date
                 WITHOUT DEFAULTS
 
   AFTER FIELD emp
      IF NOT cl_null(tm.emp)  THEN
         SELECT gen01,gen03,genacti INTO l_gen01,l_gen03,l_genacti
           FROM gen_file  WHERE gen01 = tm.emp
         IF SQLCA.SQLCODE = 100 THEN
            CALL cl_err3("sel","gen_file",tm.emp,"","mfg3096","","",1)
            NEXT FIELD emp
         END IF
         IF l_genacti = 'N'  THEN
            CALL cl_err('','9028',1)
            NEXT FIELD emp
         END IF
         IF cl_null(tm.dept)  THEN
            LET tm.dept = l_gen03
            DISPLAY tm.dept  TO dept
         END IF
      END IF
    AFTER FIELD dept
       IF NOT cl_null(tm.dept)  THEN
          SELECT gem01,gemacti INTO l_gem01,l_gemacti
            FROM gem_file WHERE gem01 = tm.dept
          IF SQLCA.SQLCODE = 100 THEN
            CALL cl_err3("sel","gem_file",tm.dept,"","mfg3097","","",1)
            NEXT FIELD dept
          END IF
          IF l_gemacti = 'N'  THEN
             CALL cl_err('','9028',1)
             NEXT FIELD dept
          END IF
       END IF
    AFTER FIELD con_no
       IF NOT cl_null(tm.con_no) THEN
          LET g_t1 = s_get_doc_no(tm.con_no)
          LET l_ooyacti = NULL
          SELECT ooyacti INTO l_ooyacti FROM ooy_file
           WHERE ooyslip = g_t1
          IF l_ooyacti <> 'Y' THEN
             CALL cl_err(g_t1,'axr-956',1)
             NEXT FIELD con_no
          END IF
        # CALL s_check_no('axr',g_t1,'','30','ooa_file','ooa01','')   #TQC-B10050  MARK 
          CALL s_check_no('axr',g_t1,'','32','ooa_file','ooa01','')   #TQC-B10050  ADD 
          RETURNING li_result,tm.con_no
          LET tm.con_no = tm.con_no[1,g_doc_len]
          DISPLAY BY NAME tm.con_no
          IF (NOT li_result)  THEN
             CALL cl_err(tm.con_no,g_errno,0)
             NEXT FIELD con_no
          END IF
       END IF
    AFTER FIELD col_date
       IF NOT cl_null(tm.col_date) THEN #FUN-D30097 add 
          CALL s_get_bookno(YEAR(tm.col_date))
               RETURNING g_flag,g_bookno1,g_bookno2
          IF g_flag = '1'  THEN   #抓不到帳別
             CALL cl_err(tm.col_date,'aoo-081',1)
             NEXT FIELD col_date
          END IF
       END IF  #FUN-D30097 add
 
    ON ACTION CONTROLP
       CASE
           WHEN INFIELD(emp)  # 人員
             CALL cl_init_qry_var()
             LET g_qryparam.form = 'q_gen'
             LET g_qryparam.default1 = tm.emp
             CALL cl_create_qry()  RETURNING tm.emp
             DISPLAY tm.emp  TO  emp
             NEXT FIELD emp
           WHEN INFIELD(dept) #部門
             CALL cl_init_qry_var()
             LET g_qryparam.form = 'q_gem'
             LET g_qryparam.default1 = tm.dept
             CALL  cl_create_qry()  RETURNING tm.dept
             DISPLAY tm.dept  TO  dept
             NEXT FIELD dept
           WHEN INFIELD(con_no)  #衝帳單號
            #CALL q_ooy(FALSE,TRUE,tm.con_no,'30','AXR')   #TQC-B10050  mark
             CALL q_ooy(FALSE,TRUE,tm.con_no,'32','AXR')   #TQC-B10050  add 
               RETURNING g_t2
             LET tm.con_no = g_t2
             DISPLAY tm.con_no TO con_no
             NEXT FIELD con_no
       END CASE
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
       ON ACTION CONTROLG
          CALL cl_cmdask()
       ON ACTION locale
          LET g_action_choice='locale'
          EXIT INPUT
       ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
       ON ACTION about
          CALL cl_about()
       ON ACTION help
          CALL cl_show_help()
       ON ACTION qbe_save
          CALL cl_qbe_save()
 
   END INPUT
 
   IF g_action_choice = 'locale' THEN
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
   IF INT_FLAG THEN
      RETURN
   END IF
 
   IF cl_sure(0,0) THEN
      LET g_success = 'Y'
      CALL s_showmsg_init()
      LET g_fla = 'N'
      BEGIN WORK
      CALL p305_process()
      CALL s_showmsg()
      IF g_success = 'Y' THEN
         COMMIT WORK
         CALL p305_carry_voucher()   #拋轉
         OPEN WINDOW p305_w2 AT 10,16 WITH FORM "axr/42f/axrp305_2"
                                 ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
         CALL cl_ui_locale("axrp305_2")
         DISPLAY BY NAME g_cnt,g_start_no,g_end_no
         CALL cl_end2(1) RETURNING l_flag
         CLOSE WINDOW p305_w2
      ELSE
         ROLLBACK WORK
         CALL cl_end2(2) RETURNING l_flag
      END IF
      IF l_flag THEN CONTINUE WHILE ELSE EXIT WHILE END IF
   END IF
END WHILE
 
END FUNCTION
 
FUNCTION p305_process()
  DEFINE   l_n          LIKE  type_file.num5
  DEFINE   l_name       LIKE type_file.chr20
  DEFINE   l_cmd        LIKE type_file.chr1000
 
    LET g_cnt = 0
    LET g_start_no = NULL
    LET g_end_no = NULL
    CALL cl_outnam('axrp305') RETURNING l_name
    START REPORT axrp305_rep TO l_name
#FUN-A60056--add--str--
  LET g_sql = "SELECT azw01 FROM azw_file",
              " WHERE azwacti = 'Y' AND azw02 = '",g_legal,"'",
              "   AND ",g_wc2 CLIPPED 
  PREPARE sel_azw01_pre FROM g_sql
  DECLARE sel_azw01_cs CURSOR FOR sel_azw01_pre
  FOREACH sel_azw01_cs INTO l_azw01
#FUN-A60056--add--end
    LET g_sql = "SELECT rxa_file.*,oma01,oma23,oma24,oma18,oma181",
               #"  FROM rxa_file,oma_file ",   #FUN-A60056
                "  FROM ",cl_get_target_table(l_azw01,'rxa_file'),",oma_file",   #FUN-A60056
                " WHERE oma16=rxa02 ", #FUN-960140 090907 mark 
                " AND oma00 = '23' ",  #FUN-960140 090907 mark
                #" WHERE   oma00 = '23' ",  #FUN-960140 090907 add 
                "   AND ",g_wc CLIPPED,
                "   AND rxaconf = 'Y' "
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql            #FUN-A60056
    CALL cl_parse_qry_sql(g_sql,l_azw01) RETURNING g_sql    #FUN-A60056
    PREPARE p305_prepare FROM g_sql
    IF STATUS THEN
       CALL s_errmsg('','','p305_pre',STATUS,0)
       LET g_success = 'N'
       RETURN
    END IF
    DECLARE p305_cs CURSOR FOR p305_prepare
    CALL s_showmsg_init()
    FOREACH p305_cs INTO g_rxa.*,g_oma.oma01,g_oma.oma23,g_oma.oma24,g_oma.oma18,g_oma.oma181
       IF  STATUS  THEN
           CALL s_errmsg('','','p305_pre',STATUS,1)
           LET g_success = 'N'
           RETURN
       END IF
       IF g_success = 'N'  THEN
          LET g_totsuccess = 'N'
          LET g_success = 'Y'
       END IF
####判斷此預售款退回單對應訂單是否有預收款,若沒有預售款則報錯
       SELECT COUNT(*) INTO l_n FROM oma_file WHERE oma16 = g_rxa.rxa02
       IF l_n<=0 THEN
          CALL s_errmsg('oea01',g_rxa.rxa02,'','axr-136',1) 
          LET g_success = 'N'
       END IF        
###判斷此預收款退回單是否已有退款衝賬單,不能重復產生
       SELECT COUNT(*) INTO l_n  FROM ooa_file WHERE ooa36 = g_rxa.rxa01
       IF l_n>0 THEN
          CONTINUE FOREACH
       END IF
 
       LET g_fla = 'Y'
       OUTPUT TO REPORT axrp305_rep(g_rxa.*,g_oma.oma01,g_oma.oma23,g_oma.oma24,g_oma.oma18,g_oma.oma181)
    END FOREACH
  END FOREACH    #FUN-A60056
    FINISH REPORT axrp305_rep
     IF g_totsuccess = 'N'  THEN
        LET g_success = 'N'
     END IF
     IF g_fla  = 'N' THEN 
        LET g_success = 'N' 
     END IF
#   LET l_cmd = "chmod 777 ", l_name                   #No.FUN-9C0009
#   RUN l_cmd                                          #No.FUN-9C0009
    IF os.Path.chrwx(l_name CLIPPED,511) THEN END IF   #No.FUN-9C0009
END FUNCTION
 
REPORT axrp305_rep(l_rxa,l_oma01,l_oma23,l_oma24,l_oma18,l_oma181)
  DEFINE l_rxa     RECORD    LIKE  rxa_file.*
  DEFINE l_oma01             LIKE  oma_file.oma01
  DEFINE l_oma23             LIKE  oma_file.oma23
  DEFINE l_oma24             LIKE  oma_file.oma24
  DEFINE l_oma18             LIKE  oma_file.oma18
  DEFINE l_oma181            LIKE  oma_file.oma181
 
  FORMAT
     ON EVERY ROW
       IF g_success = 'Y'   THEN
           CALL p305_ins_ooa()   #退款衝賬單頭
       END IF
        IF g_success = 'Y'  THEN
           LET g_rxa.* = l_rxa.*
           LET g_oma.oma01 = l_oma01
           LET g_oma.oma23 = l_oma23
           LET g_oma.oma24 = l_oma24
           LET g_oma.oma18 = l_oma18
           LET g_oma.oma181 = l_oma181
           CALL p305_ins_oob_1()  #預收款退回單單身借方
        END IF
        IF g_success = 'Y'  THEN
           CALL p305_ins_oob_2()  #預收款單身貸方
        END IF
        IF g_success = 'Y'  THEN
           CALL p305_upd_ooa()    #更新axrt400單頭
        END IF
        IF g_success = 'Y'  THEN
           CALL p305_get_entry()  #分錄底稿
        END IF
        IF g_success = 'Y'  THEN
           CALL p305_y_upd()      #審核
        END IF
        IF g_start_no IS NULL THEN
           LET g_start_no = g_ooa.ooa01
        END IF
        LET g_end_no = g_ooa.ooa01
        LET g_cnt = g_cnt+1
        LET g_a[g_cnt].ooa01 = g_ooa.ooa01
END REPORT
 
FUNCTION p305_ins_ooa()
  DEFINE  li_result   LIKE  type_file.num5
 
  INITIALIZE  g_ooa.*  TO  NULL
  IF NOT cl_null(tm.col_date) THEN #FUN-D30097 add
    #CALL s_auto_assign_no(g_sys,tm.con_no,tm.col_date,'30','ooy_file','ooyslip','','','')  #MOD-D40115 mark
     CALL s_auto_assign_no(g_sys,tm.con_no,tm.col_date,'32','ooy_file','ooyslip','','','')  #MOD-D40115
          RETURNING  li_result,g_ooa.ooa01
 #FUN-D30097---add---START 
  ELSE   
    #CALL s_auto_assign_no(g_sys,tm.con_no,g_rxa.rxa09,'30','ooy_file','ooyslip','','','')  #MOD-D40115 mark
     CALL s_auto_assign_no(g_sys,tm.con_no,g_rxa.rxa09,'32','ooy_file','ooyslip','','','')  #MOD-D40115 
          RETURNING  li_result,g_ooa.ooa01
  END IF 
 #FUN-D30097---add---END
  IF (NOT li_result) THEN
     LET g_success = 'N'
     RETURN
  END IF
  LET g_ooa.ooa00 = '1'
  IF NOT cl_null(tm.col_date) THEN #FUN-D30097 add
     LET g_ooa.ooa02 = tm.col_date
 #FUN-D30097---add---START 
  ELSE
     LET g_ooa.ooa02 = g_rxa.rxa09
  END IF
 #FUN-D30097---add---END
  LET g_ooa.ooa03 = g_rxa.rxa03
  SELECT occ02  INTO  g_ooa.ooa032 FROM  occ_file
   WHERE occ01 = g_rxa.rxa03
  LET g_ooa.ooa13 = g_ooz.ooz08
  LET g_ooa.ooa14 = tm.emp
  LET g_ooa.ooa15 = tm.dept
  LET g_ooa.ooa20 = 'Y'
  LET g_ooa.ooa23 = g_oma.oma23
  LET g_ooa.ooa24 = g_oma.oma24
  LET g_ooa.ooa25 = '0'
  LET g_ooa.ooa31d = 0
  LET g_ooa.ooa31c = 0
  LET g_ooa.ooa32d = 0
  LET g_ooa.ooa32c = 0
  LET g_ooa.ooaconf = 'N'
  LET g_ooa.ooa34 = '0'          #No.TQC-9C0057
  LET g_ooa.ooaprsw = 0
  LET g_ooa.ooauser = g_user
  LET g_ooa.ooagrup = g_grup
  LET g_ooa.ooadate = g_today
  LET g_ooa.ooamksg = 'N'
  LET g_ooa.ooa35 = '3'
  LET g_ooa.ooa36 = g_rxa.rxa01
# LET g_ooa.ooa37 = 'Y'            #FUN-A40076 Mark
  LET g_ooa.ooa37 = '2'            #FUN-A40076 Add
  LET g_ooa.ooa38 = '2'
  LET g_ooa.ooalegal = g_legal #FUN-980011 add
 
  LET g_ooa.ooaoriu = g_user      #No.FUN-980030 10/01/04
  LET g_ooa.ooaorig = g_grup      #No.FUN-980030 10/01/04
  
  INSERT INTO ooa_file  VALUES(g_ooa.*)
  IF SQLCA.sqlcode THEN
     CALL s_errmsg('ooa01',g_ooa.ooa01,'ins ooa_file',SQLCA.sqlcode,1)
     LET g_success = 'N'
  END IF
END FUNCTION
 
FUNCTION p305_ins_oob_1()
 DEFINE  l_t       LIKE   type_file.num5
 DEFINE  l_rxx04   LIKE   rxx_file.rxx04
 DEFINE  l_amt1    LIKE   oma_file.oma54t
 
   INITIALIZE g_oob.* TO NULL
   SELECT azi03,azi04 INTO t_azi03,t_azi04  FROM azi_file
    WHERE azi01 = g_oma.oma23
   LET g_oob.oob01 = g_ooa.ooa01
   SELECT MAX(oob02)+1  INTO l_t  FROM oob_file WHERE oob01 = g_ooa.ooa01
   IF cl_null(l_t) THEN
      LET l_t = 1
   END IF
   LET g_oob.oob02 = l_t
   LET g_oob.oob07 = g_oma.oma23
   LET g_oob.oob08 = g_oma.oma24
   LET g_oob.oob03 = '1'
   LET g_oob.oob04 = '3'
   LET g_oob.oob06 = g_oma.oma01
#FUN-A60056--mod--str--
#  SELECT SUM(rxx04)  INTO l_rxx04  FROM rxx_file
#   WHERE rxx00 = '04' AND rxx01 = g_rxa.rxa01  AND rxx03 = '-1'
   LET g_sql = "SELECT SUM(rxx04)  FROM ",cl_get_target_table(l_azw01,'rxx_file'),
               " WHERE rxx00 = '04' AND rxx01 = '",g_rxa.rxa01,"' AND rxx03 = '-1'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,l_azw01) RETURNING g_sql
   PREPARE sel_rxx04_pre FROM g_sql
   EXECUTE sel_rxx04_pre INTO l_rxx04
#FUN-A60056--mod--end
   LET g_oob.oob09 = l_rxx04
   IF cl_null(g_oob.oob09)  THEN
      LET g_oob.oob09 = 0
   END IF
   CALL cl_digcut(g_oob.oob09,t_azi04) RETURNING g_oob.oob09
   SELECT oma54t-oma55  INTO l_amt1  FROM oma_file WHERE oma01 = g_oma.oma01
   IF l_amt1 < g_oob.oob09  THEN
      CALL s_errmsg('',l_amt1,'','axr-242',1)
      LET g_success = 'N'
      RETURN
   END IF
   LET g_oob.oob10 = g_oob.oob08 * g_oob.oob09
   IF cl_null(g_oob.oob10) THEN
      LET g_oob.oob10 = 0
   END IF
   CALL cl_digcut(g_oob.oob10,g_azi04) RETURNING g_oob.oob10
   LET g_oob.oob11 = g_oma.oma18
   IF g_aza.aza63 = 'Y' THEN
      LET g_oob.oob111 = g_oma.oma181
   END IF
   LET g_oob.oob20 = 'N'
   LET g_oob.oob22 = 0
   LET g_oob.ooblegal = g_legal  #FUN-A60056 
   INSERT  INTO  oob_file  VALUES(g_oob.*)
   DISPLAY "add oob(",SQLCA.sqlcode,"):",g_oob.oob01,'',
                      g_oob.oob03,'',g_oob.oob04,'',g_oob.oob06 AT 2,1
   IF SQLCA.sqlcode  THEN
      CALL s_errmsg('oob01',g_oob.oob01,'ins oob_file',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
END FUNCTION
 
FUNCTION p305_ins_oob_2()   #根據退款明細產生
 DEFINE  l_t            LIKE   type_file.num5
 DEFINE  l_rxx  RECORD  LIKE   rxx_file.*
 #DEFINE  l_ryd05        LIKE   ryd_file.ryd05   #FUN-9C0168
 DEFINE  l_ooe02        LIKE   ooe_file.ooe02    #FUN-9C0168
 DEFINE  l_aag05        LIKE   aag_file.aag05
 DEFINE  l_oow04        LIKE   oow_file.oow04
 
   INITIALIZE g_oob.* TO NULL
   SELECT azi03,azi04 INTO t_azi03,t_azi04  FROM azi_file
    WHERE azi01 = g_oma.oma23
   LET g_oob.oob01 = g_ooa.ooa01
   LET g_oob.oob07 = g_oma.oma23
   LET g_oob.oob08 = g_oma.oma24
   CALL s_get_bookno(year(g_ooa.ooa02))  RETURNING g_flag,g_bookno1,g_bookno2
   IF g_flag = '1'  THEN #抓不到帳別
      CALL s_errmsg('ooa02',g_ooa.ooa02,'','aoo-081',1)
      LET g_success = 'N'
   END IF
   INITIALIZE l_rxx.* TO NULL
#FUN-A60056--mod--str--
#  DECLARE p305_oob_cs CURSOR FOR
#    SELECT * FROM rxx_file WHERE rxx01 = g_rxa.rxa01 AND rxx00 = '04' AND rxx03 = '-1'
   LET g_sql = "SELECT * FROM ",cl_get_target_table(l_azw01,'rxx_file'),
               " WHERE rxx01 = '",g_rxa.rxa01,"' AND rxx00 = '04' AND rxx03 = '-1'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,l_azw01) RETURNING g_sql
   PREPARE p305_oob_pre FROM g_sql
   DECLARE p305_oob_cs CURSOR FOR p305_oob_pre
#FUN-A60056--mod--end
   FOREACH p305_oob_cs INTO l_rxx.*
      IF cl_null(l_rxx.rxx04)  THEN
         LET l_rxx.rxx04 = 0
      END IF
      SELECT MAX(oob02)+1  INTO l_t  FROM oob_file  WHERE oob01  = g_ooa.ooa01
        IF cl_null(l_t) THEN
           LET l_t = 1
        END IF
      LET g_oob.oob02 = l_t
     #FUN-9C0168--mod--str--
     #SELECT ryd05  INTO l_ryd05  FROM ryd_file,rxx_file
     # WHERE ryd01 = rxx02 AND rxx00 = '04' AND rxx02 = l_rxx.rxx02
     #   AND rxx01 = g_rxa.rxa01 AND rxx03 = '-1'
#FUN-A60056--mod--str--
#     SELECT ooe02  INTO l_ooe02  FROM ooe_file,rxx_file
#      WHERE ooe01 = rxx02 AND rxx00 = '04' AND rxx02 = l_rxx.rxx02
#        AND rxx01 = g_rxa.rxa01 AND rxx03 = '-1'
      LET g_sql = "SELECT ooe02 FROM ooe_file,",cl_get_target_table(l_azw01,'rxx_file'),
                  " WHERE ooe01 = rxx02 AND rxx00 = '04' AND rxx02 = '",l_rxx.rxx02,"'",
                  "   AND rxx01 = '",g_rxa.rxa01,"' AND rxx03 = '-1'" 
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,l_azw01) RETURNING g_sql
      PREPARE sel_ooe02 FROM g_sql
      EXECUTE sel_ooe02 INTO l_ooe02
#FUN-A60056--mod--end
     #FUN-9C0168--mod--end
      LET g_oob.oob03 = '2'
      LET g_oob.oob06 = NULL
      LET g_oob.oob09 = l_rxx.rxx04
      LET g_oob.oob22 = l_rxx.rxx04
      LET g_oob.oob20 = 'N'
      LET g_oob.ooblegal = g_legal #FUN-980011 add
      CALL cl_digcut(g_oob.oob09,t_azi04) RETURNING g_oob.oob09
      CALL cl_digcut(g_oob.oob22,t_azi04) RETURNING g_oob.oob22 
      LET g_oob.oob10 = g_oob.oob08 * g_oob.oob09
      IF cl_null(g_oob.oob10)    THEN
         LET g_oob.oob10 = 0
      END IF
      CALL cl_digcut(g_oob.oob10,g_azi04) RETURNING g_oob.oob10
 
      IF l_rxx.rxx02 MATCHES '0[128]'  THEN     #TT（不含支票）
         LET g_oob.oob04 = 'A'
        #FUN-9C0168--mod--str--
        #IF l_ryd05 IS NOT NULL  THEN
        #   LET g_oob.oob17 = l_ryd05
        #   SELECT nma05 INTO g_oob.oob11 FROM nma_file
        #    WHERE nma01 = l_ryd05
        #   IF g_aza.aza63 = 'Y' THEN
        #      SELECT nma051 INTO g_oob.oob111 FROM nma_file   WHERE nma01 = l_ryd05
         IF l_ooe02 IS NOT NULL  THEN
            LET g_oob.oob17 = l_ooe02
            SELECT nma05 INTO g_oob.oob11 FROM nma_file
             WHERE nma01 = l_ooe02
            IF g_aza.aza63 = 'Y' THEN
               SELECT nma051 INTO g_oob.oob111 FROM nma_file   WHERE nma01 = l_ooe02
        #FUN-9C0168--mod--end
            ELSE
               LET g_oob.oob111 = NULL
            END IF
         ELSE
 
         END IF
         SELECT oow04 INTO l_oow04 FROM oow_file  
         LET g_oob.oob18 = l_oow04
         SELECT nmc05 INTO g_oob.oob21 FROM nmc_file WHERE nmc01 = g_oob.oob18
      END IF

#TQC-B10050   ---BEGIN---
      IF l_rxx.rxx02 = '06' THEN #儲值卡
         LET g_oob.oob04 = 'C' 
         SELECT ool21 INTO g_oob.oob11 FROM ool_file WHERE ool01 = g_ooa.ooa13
         IF cl_null(g_oob.oob11) THEN
            LET g_success = 'N'
            CALL s_errmsg('ool21',g_ooa.ooa13,'sel ool',STATUS,1)
         END IF
         IF g_aza.aza63 = 'Y' THEN
            SELECT ool211 INTO g_oob.oob111 FROM ool_file WHERE ool01 = g_ooa.ooa13
            IF cl_null(g_oob.oob111) THEN
               LET g_success = 'N'
               CALL s_errmsg('ool211',g_ooa.ooa13,'sel ool',STATUS,1)
            END IF
         END IF
         LET g_oob.oob19 = 1
         SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag01=g_oob.oob11  AND aag00=g_bookno1
         IF l_aag05 = 'Y' THEN
            LET g_oob.oob13 = g_ooa.ooa15
         ELSE
            LET g_oob.oob13 = ''
         END IF
      END IF 
#TQC-B10050   ---END--- 

      IF l_rxx.rxx02 = '05'  THEN   #聯盟卡
         LET g_oob.oob04 = 'E'
        #FUN-9C0168--mod--str--
        #IF l_ryd05 IS NOT NULL THEN
        #   LET g_oob.oob17 = l_ryd05
        #   SELECT nma05 INTO g_oob.oob11 FROM nma_file WHERE nma01 = l_ryd05
        #   IF g_aza.aza63 = 'Y' THEN
        #      SELECT nma051 INTO g_oob.oob111 FROM nma_file WHERE nma01= l_ryd05
         IF l_ooe02 IS NOT NULL THEN
            LET g_oob.oob17 = l_ooe02
            SELECT nma05 INTO g_oob.oob11 FROM nma_file WHERE nma01 = l_ooe02
            IF g_aza.aza63 = 'Y' THEN
               SELECT nma051 INTO g_oob.oob111 FROM nma_file WHERE nma01= l_ooe02
        #FUN-9C0168--mod--end
            ELSE
               LET g_oob.oob111 = NULL
            END IF
         ELSE
         END IF
      END IF
      IF l_rxx.rxx02 = '04' THEN #券
         LET g_oob.oob04 = 'Q'
        #FUN-9C0168--mod--str--
        #IF l_ryd05 IS NOT NULL THEN
        #   LET g_oob.oob17 = l_ryd05
        #   SELECT nma05 INTO g_oob.oob11 FROM nma_file  WHERE nma01 = l_ryd05
        #   IF g_aza.aza63 = 'Y' THEN
        #      SELECT nma051 INTO g_oob.oob111 FROM nma_file WHERE nma01 = l_ryd05
         IF l_ooe02 IS NOT NULL THEN
            LET g_oob.oob17 = l_ooe02
            SELECT nma05 INTO g_oob.oob11 FROM nma_file  WHERE nma01 = l_ooe02
            IF g_aza.aza63 = 'Y' THEN
               SELECT nma051 INTO g_oob.oob111 FROM nma_file WHERE nma01 = l_ooe02
        #FUN-9C0168--mod--end
            ELSE
               LET g_oob.oob111 = NULL
            END IF
         ELSE
 
         END IF
      END IF
      SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag01 = g_oob.oob11 AND aag00 = g_bookno1
      IF l_aag05 = 'Y'  THEN
         LET g_oob.oob13 = g_ooa.ooa15
      ELSE
         LET g_oob.oob13 = NULL
      END IF
 
      IF g_aza.aza63='Y' AND cl_null(g_oob.oob111) THEN
         CALL s_errmsg('','','','axr-076',1)
         LET g_success = 'N'                                                                                               
      END IF
      IF cl_null(g_oob.oob11) THEN 
         CALL s_errmsg('','','','axr-076',1) 
         LET g_success = 'N'
      END IF
      LET g_oob.ooblegal = g_legal   #FUN-A60056
      INSERT INTO oob_file  VALUES(g_oob.*)
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('','','p305_ins_oob:',SQLCA.sqlcode,1)
         LET g_success = 'N'
         EXIT  FOREACH
      END IF
   END FOREACH
END FUNCTION
 
FUNCTION p305_upd_ooa()
  DEFINE  l_ooa31d      LIKE   ooa_file.ooa31d
  DEFINE  l_ooa31c      LIKE   ooa_file.ooa31c
  DEFINE  l_ooa32d      LIKE   ooa_file.ooa32d
  DEFINE  l_ooa32c      LIKE   ooa_file.ooa32c
 
  SELECT azi03,azi04 INTO t_azi03,t_azi04  FROM azi_file
   WHERE azi01 = g_oma.oma23
  SELECT SUM(oob09),SUM(oob10) INTO l_ooa31d,l_ooa32d
    FROM oob_file  WHERE oob01 = g_ooa.ooa01 AND oob03 = '1'
  SELECT SUM(oob09),SUM(oob10) INTO l_ooa31c,l_ooa32c
    FROM oob_file  WHERE oob01 = g_ooa.ooa01 AND oob03 = '2'
  CALL cl_digcut(l_ooa31d,t_azi04) RETURNING l_ooa31d
  CALL cl_digcut(l_ooa32d,g_azi04) RETURNING l_ooa32d
  SELECT SUM(oob09),SUM(oob10) INTO l_ooa31c,l_ooa32c
    FROM oob_file  WHERE oob01 = g_ooa.ooa01 AND oob03 = '2'
  CALL cl_digcut(l_ooa31c,t_azi04) RETURNING l_ooa31c
  CALL cl_digcut(l_ooa32c,g_azi04) RETURNING l_ooa32c
  IF cl_null(l_ooa31c) THEN LET l_ooa31c = 0 END IF
  IF cl_null(l_ooa32c) THEN LET l_ooa32c = 0 END IF
 
  UPDATE ooa_file SET  ooa31d = l_ooa31d,
                       ooa31c = l_ooa31c,
                       ooa32d = l_ooa32d,
                       ooa32c = l_ooa32c
                WHERE  ooa01 = g_ooa.ooa01
  IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
     CALL s_errmsg('ooa01',g_ooa.ooa01,'upd ooa_file',SQLCA.sqlcode,1)
     LET g_success = 'N'
     RETURN
  END IF
END FUNCTION
 
FUNCTION p305_get_entry()
   DEFINE  l_t        LIKE    ooy_file.ooyslip
   DEFINE  l_ooydmy1  LIKE    ooy_file.ooydmy1
 
     LET  l_t = s_get_doc_no(g_ooa.ooa01)
     SELECT * INTO g_ooy.*  FROM ooy_file  WHERE  ooyslip = l_t
     LET l_ooydmy1 = ''
     SELECT ooydmy1  INTO l_ooydmy1  FROM ooy_file
      WHERE ooyslip = l_t
     IF STATUS  THEN
        CALL cl_err(l_t,STATUS,0)
     END IF
     IF l_ooydmy1 = 'Y' THEN
        CALL s_t400_gl(g_ooa.ooa01,'0')
        IF g_aza.aza63 = 'Y' THEN
           CALL s_t400_gl(g_ooa.ooa01,'1')
        END IF
     END IF
END FUNCTION
 
FUNCTION p305_y_upd()
  DEFINE   l_cnt  LIKE    type_file.num5
 
    LET g_success = 'Y'
    IF  g_ooa.ooamksg = 'Y' THEN
        IF g_ooa.ooa34 != '1'  THEN
           CALL cl_err('','aws-078',1)
           LET g_success = 'N'
           RETURN
        END IF
    END IF
    SELECT * INTO g_ooa.* FROM ooa_file WHERE ooa01 = g_ooa.ooa01
    IF g_ooa.ooa32d != g_ooa.ooa32c THEN
       CALL  cl_err('','axr-203',0)
       LET g_success = 'N'
       RETURN
    END IF
    IF  g_ooa.ooa02 <= g_ooz.ooz09  THEN
        CALL cl_err('','axr-164',0)
        LET g_success = 'N'
        RETURN
    END IF
    SELECT COUNT(*)  INTO l_cnt FROM oob_file
     WHERE oob01 = g_ooa.ooa01
    IF l_cnt = 0 THEN
       CALL cl_err('','mfg-009',0)
       LET g_success = 'N'
       RETURN
    END IF
    IF g_ooz.ooz62 = 'Y'  THEN
       SELECT COUNT(*)  INTO l_cnt FROM  oob_file
        WHERE oob01 = g_ooa.ooa01
          AND oob03 = '2'
          AND oob04 = '1'
          AND (oob06 IS NULL OR oob06 =  '' OR oob15 IS NULL OR oob15<=0 )
      IF cl_null(l_cnt) THEN
         LET l_cnt = 0
      END IF
 
      IF l_cnt > 0 THEN
         CALL cl_err('','axr-900',0)
         LET g_success = 'N'
         RETURN
      END IF
    END IF
 
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt
     FROM oob_file,oma_file
    WHERE ( YEAR(oma02) > YEAR(g_ooa.ooa02)
       OR (YEAR(oma02) = YEAR(g_ooa.ooa02)
      AND MONTH(oma02) > MONTH(g_ooa.ooa02)) )
      AND oob03 = '2'
      AND oob04 = '1'
      AND oob06 = oma01
      AND oob01 = g_ooa.ooa01
 
   IF l_cnt >0 THEN
      CALL cl_err(g_ooa.ooa01,'axr-371',1)
      LET g_success = 'N'
      RETURN
   END IF
   IF g_ooy.ooydmy1 = 'Y' AND g_ooy.ooyglcr = 'N' THEN
      CALL s_chknpq(g_ooa.ooa01,'AR',1,'0',g_bookno1)
      IF g_aza.aza63='Y' AND g_success='Y' THEN
         CALL s_chknpq(g_ooa.ooa01,'AR',1,'1',g_bookno2)
      END IF
      #LET g_dbs_new = g_dbs CLIPPED,'.'   #FUN-A50102
   END IF
 
   IF g_success = 'N' THEN
      RETURN
   END IF
   CALL p305_y1()
   CALL p305_cvoucher()
END FUNCTION
 
FUNCTION p305_y1()
   DEFINE  n         LIKE       type_file.num5
   DEFINE  l_cnt     LIKE       type_file.num5
   DEFINE  l_flag    LIKE       type_file.chr1
   DEFINE  l_n       LIKE       type_file.num5   #TQC-B10050  add 

     UPDATE  ooa_file  SET ooaconf = 'Y',ooa34 = '1'  WHERE ooa01 = g_ooa.ooa01  #No.TQC-9C0057
     IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
        CALL cl_err3('upd','ooa_file',g_ooa.ooa01,'',SQLCA.sqlcode,'','upd ooaconf',1)
        LET g_success = 'N'
        RETURN
     END IF
     CALL p305_hu2()
     IF g_success = 'N'  THEN
        RETURN
     END IF
 
     INITIALIZE b_oob.* TO NULL
     DECLARE  p305_y1_c  CURSOR FOR
     SELECT * FROM oob_file  WHERE  oob01 = g_ooa.ooa01 ORDER BY oob02
     LET l_cnt = 1
     LET l_n = 1      #TQC-B10050  add 
     LET l_flag = '0'
     CALL s_showmsg_init()
     FOREACH p305_y1_c  INTO b_oob.*
        IF STATUS THEN
           CALL s_errmsg('oob01',g_ooa.ooa01,'foreach',STATUS,1)
           LET g_success = 'N'
        END IF
        IF g_success = 'N'   THEN
           LET g_totsuccess = 'N'
           LET g_success = 'Y'
        END IF
        IF l_flag = '0' THEN
           LET l_flag = b_oob.oob03
        END IF
 
        IF l_flag != b_oob.oob03 THEN
           LET l_cnt = l_cnt + 1
        END IF
 
        IF b_oob.oob03 = '1' AND b_oob.oob04 = '3' THEN
           CALL p305_bu_13()
        END IF
#       IF g_ooa.ooa37 = 'Y'  THEN  # 產生nme_file    #FUN-A40076 Mark
        IF g_ooa.ooa37 = '2'  THEN                    #FUN-A40076 Add 
           IF b_oob.oob03 = '2' AND b_oob.oob04 = 'A'  THEN
              CALL p305_bu_2A()
           END IF
#TQC-B10050   ---begin---
           IF b_oob.oob03 = '2' AND b_oob.oob04 = 'C' THEN
              CALL p305_bu_2C('+',l_n)
           END IF 
#TQC-B10050   ---end---
        END IF
        LET l_n = l_n + 1   #TQC-B10050   add 
        LET l_cnt = l_cnt + 1
     END FOREACH
     IF g_totsuccess = 'N'  THEN
        LET g_success = 'N'
     END IF
     SELECT COUNT(*)  INTO n  FROM oob_file
      WHERE oob01 = g_ooa.ooa01
        AND oob04 = '9'
     IF n>0 THEN
        CALL ins_apf()
     END IF
     CALL s_showmsg()
END FUNCTION
 
FUNCTION p305_hu2()   #最近交易日
    DEFINE  l_occ      RECORD    LIKE     occ_file.*
 
    INITIALIZE l_occ.* TO NULL
    SELECT * INTO l_occ.*  FROM occ_file  WHERE occ01 = g_ooa.ooa03
    IF STATUS  THEN
       CALL cl_err3('sel','occ_file',g_ooa.ooa03,'',STATUS,'','s ccc',1)
       LET g_success = 'N'
       RETURN
    END IF
    IF l_occ.occ16 IS NULL THEN
       LET l_occ.occ16 = g_ooa.ooa02
    END IF
    IF l_occ.occ174 IS NULL OR l_occ.occ174 < g_ooa.ooa02 THEN
       LET l_occ.occ174=g_ooa.ooa02
    END IF
    UPDATE occ_file SET * = l_occ.* WHERE occ01=g_ooa.ooa03
    IF STATUS THEN
       CALL cl_err3("upd","occ_file",g_ooa.ooa03,"",SQLCA.sqlcode,"","u ccc",1)  #No.FUN-660116
       LET g_success='N'
       RETURN
    END IF
END FUNCTION
 
FUNCTION p305_bu_13()   #oma_file
  DEFINE l_omaconf      LIKE oma_file.omaconf,
         l_omavoid      LIKE oma_file.omavoid,
         l_cnt          LIKE type_file.num5
  DEFINE l_oma00        LIKE oma_file.oma00
  DEFINE tot4,tot4t     LIKE type_file.num20_6
  DEFINE tot5,tot6      LIKE type_file.num20_6
  DEFINE tot8           LIKE type_file.num20_6
  DEFINE l_omc10        LIKE omc_file.omc10,
         l_omc11        LIKE omc_file.omc11,
         l_omc13        LIKE omc_file.omc13
  DEFINE tot,tot1       LIKE type_file.num20_6
  DEFINE tot2,tot3      LIKE type_file.num20_6
  DEFINE un_pay1,un_pay2  LIKE type_file.num20_6
 
   IF g_bgjob='N' OR cl_null(g_bgjob) THEN
      DISPLAY "bu_13:",b_oob.oob02,' ',b_oob.oob03,' ',b_oob.oob04 AT 2,1
   END IF
 
#同參考單號若有一筆以后僅衝款一次即可
   SELECT COUNT(*) INTO l_cnt FROM oob_file
          WHERE oob01=b_oob.oob01
            AND oob02<b_oob.oob02
            AND oob03='1'
            AND oob04='3'
            AND oob06=b_oob.oob06
   IF l_cnt>0 THEN RETURN END IF
 
#預防在收款衝帳確認前，多衝待扺貨款
    SELECT SUM(oob09),SUM(oob10) INTO tot1,tot2 FROM oob_file, ooa_file
     WHERE oob06=b_oob.oob06 AND oob01=ooa01
       AND oob03='1'  AND oob04 = '3' AND ooaconf='Y'
    IF cl_null(tot1) THEN LET tot1 = 0 END IF
    IF cl_null(tot2) THEN LET tot2 = 0 END IF
 
    SELECT SUM(oob09),SUM(oob10) INTO tot5,tot6 FROM oob_file, ooa_file
     WHERE oob06=b_oob.oob06 AND oob01=ooa01 AND oob19=b_oob.oob19
       AND oob03='1'  AND oob04 = '3' AND ooaconf='Y'
    IF cl_null(tot5) THEN LET tot5 = 0 END IF
    IF cl_null(tot6) THEN LET tot6 = 0 END IF
 
    SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = b_oob.oob07
    CALL cl_digcut(tot1,t_azi04) RETURNING tot1
    CALL cl_digcut(tot2,g_azi04) RETURNING tot2
   #FUN-A50102--mod--str--
   #LET g_sql="SELECT oma00,omavoid,omaconf,oma54t,oma56t ",
   #          "  FROM ",g_dbs_new CLIPPED,"oma_file",
   #          " WHERE oma01=?"
   #PREPARE p305_bu_13_p1 FROM g_sql
   #DECLARE p305_bu_13_c1 CURSOR FOR p305_bu_13_p1
   #OPEN p305_bu_13_c1 USING b_oob.oob06
   #FETCH p305_bu_13_c1 INTO l_oma00,l_omavoid,l_omaconf,un_pay1,un_pay2
    SELECT oma00,omavoid,omaconf,oma54t,oma56t
      INTO l_oma00,l_omavoid,l_omaconf,un_pay1,un_pay2
      FROM oma_file
     WHERE oma01=b_oob.oob06
   #FUN-A50102--mod--end
    IF  l_omavoid='Y' THEN
       CALL s_errmsg(' ',' ','b_oob.oob06','axr-103',1) LET g_success = 'N'
    END IF
    IF  l_omaconf='N' THEN
       CALL s_errmsg(' ',' ','b_oob.oob06','axr-104',1) LET g_success = 'N'
    END IF
    IF cl_null(un_pay1) THEN LET un_pay1 = 0 END IF
    IF cl_null(un_pay2) THEN LET un_pay2 = 0 END IF
#取得衡帳單的待扺金額
    CALL p305_mntn_offset_inv(b_oob.oob06) RETURNING tot4,tot4t
    CALL cl_digcut(tot4,t_azi04) RETURNING tot4
    CALL cl_digcut(tot4t,g_azi04) RETURNING tot4t
    IF g_ooz.ooz07 ='N' OR b_oob.oob07 = g_aza.aza17 THEN
       IF un_pay1 < tot1+tot4 OR un_pay2 < tot2+tot4t  THEN
          CALL s_errmsg(' ',' ','un_pay<pay#1','axr-196',1) LET g_success = 'N'
       END IF
    END IF
 
    SELECT SUM(oob09),SUM(oob10) INTO tot1,tot2 FROM oob_file, ooa_file
     WHERE oob06=b_oob.oob06 AND oob01=ooa01  AND ooaconf = 'Y'
       AND oob03='1'  AND oob04 = '3'
    IF cl_null(tot1) THEN LET tot1 = 0 END IF
    IF cl_null(tot2) THEN LET tot2 = 0 END IF
 
    SELECT SUM(oob09),SUM(oob10) INTO tot5,tot6 FROM oob_file, ooa_file
     WHERE oob06=b_oob.oob06 AND oob01=ooa01 AND oob19=b_oob.oob19
       AND ooaconf = 'Y' AND oob03='1'  AND oob04 = '3'
    IF cl_null(tot5) THEN LET tot5 = 0 END IF
    IF cl_null(tot6) THEN LET tot6 = 0 END IF
 
    SELECT omc10,omc11,omc13 INTO l_omc10,l_omc11,l_omc13 FROM omc_file
     WHERE omc01=b_oob.oob06 AND omc02 = b_oob.oob19
    IF cl_null(l_omc10) THEN LET l_omc10=0 END IF
    IF cl_null(l_omc11) THEN LET l_omc11=0 END IF
    IF cl_null(l_omc13) THEN LET l_omc13=0 END IF
    IF g_ooz.ooz07 ='Y' AND b_oob.oob07 != g_aza.aza17 THEN
#取得未衝金額
       CALL s_g_np('1',l_oma00,b_oob.oob06,0          ) RETURNING tot3
#未衡金額扣除待扺
       LET tot3 = tot3 - tot4t
    ELSE
       LET tot3 = un_pay2 - tot2 - tot4t
    END IF
   #FUN-A50102--mark--str--
   #LET g_sql="UPDATE ",g_dbs_new CLIPPED,"oma_file SET oma55=?,oma57=?,oma61=? ",
   #            " SET oma55=?,oma57=?,oma61=? ",
   #          " WHERE oma01=? "          
   #PREPARE p305_bu_13_p2 FROM g_sql
   #FUN-A50102--mark--end
    LET tot1 = tot1 + tot4
    LET tot2 = tot2 + tot4t
    CALL cl_digcut(tot1,t_azi04) RETURNING tot1
    CALL cl_digcut(tot2,g_azi04) RETURNING tot2
 
    #EXECUTE p305_bu_13_p2 USING tot1, tot2, tot3, b_oob.oob06   #FUN-A50102
    #FUN-A50102--add--str--
    UPDATE oma_file SET oma55=tot1,
                        oma57=tot2,
                        oma61=tot3
     WHERE oma01=b_oob.oob06
    #FUN-A50102--add--end
    IF STATUS THEN
       CALL s_errmsg('oma01',b_oob.oob06,'upd oma55,57',STATUS,1)
       LET g_success = 'N'
 
    END IF
    IF SQLCA.SQLERRD[3]=0 THEN
       CALL s_errmsg('oma01',b_oob.oob06,'upd oma55,57','axr-198',1) LET g_success = 'N'
    END IF
    IF SQLCA.sqlcode = 0 THEN
       CALL p305_omc()
    END IF
END FUNCTION
 
FUNCTION ins_apf()
  DEFINE l_oob      RECORD LIKE oob_file.*
  DEFINE l_apf      RECORD LIKE apf_file.*
  DEFINE l_apg      RECORD LIKE apg_file.*
  DEFINE l_aph      RECORD LIKE aph_file.*
  DEFINE l_amt      LIKE type_file.num20_6
  DEFINE l_apz27    LIKE apz_file.apz27
 
  INITIALIZE l_apf.* TO NULL
  LET l_apf.apf00='33'
  LET l_apf.apf01 =g_ooa.ooa01
  LET l_apf.apf02 =g_ooa.ooa02
  LET l_apf.apf03 =g_ooa.ooa03
  LET l_apf.apf12 =g_ooa.ooa032
  LET l_apf.apf04 =g_ooa.ooa14
  LET l_apf.apf05 =g_ooa.ooa15
  LET l_apf.apf06 =g_ooa.ooa23
  LET l_apf.apf07 =1
  LET l_apf.apf08f=g_ooa.ooa31d
  LET l_apf.apf08 =g_ooa.ooa32d
  LET l_apf.apf09f=0
  LET l_apf.apf09 =0
  LET l_apf.apf10f=g_ooa.ooa31c
  LET l_apf.apf10 =g_ooa.ooa32c
  LET l_apf.apf13 = ''
  SELECT pmc24 INTO l_apf.apf13 FROM pmc_file
   WHERE pmc01 = g_ooa.ooa03
  LET l_apf.apf41 ='Y'
  LET l_apf.apf44 =g_ooa.ooa33
  LET l_apf.apfinpd =TODAY
  LET l_apf.apfmksg ='N'
  LET l_apf.apfacti ='Y'
  LET l_apf.apfuser =g_user
  LET l_apf.apfgrup =g_grup
  LET l_apf.apflegal = g_legal #FUN-980011 add
 
  LET l_apf.apforiu = g_user      #No.FUN-980030 10/01/04
  LET l_apf.apforig = g_grup      #No.FUN-980030 10/01/04
  INSERT INTO apf_file VALUES(l_apf.*)
 
  IF STATUS OR SQLCA.SQLCODE THEN
     CALL s_errmsg('apf01','g_ooa.ooa01','ins apf',SQLCA.SQLCODE,1)
     LET g_success = 'N'
  END IF
  INITIALIZE l_oob.* TO NULL
  DECLARE ins_apf_c CURSOR FOR
    SELECT * FROM oob_file WHERE oob01=g_ooa.ooa01 ORDER BY 1,2
  FOREACH ins_apf_c INTO l_oob.*
    IF g_success='N' THEN
       LET g_totsuccess='N'
       LET g_success='Y'
    END IF
    IF l_oob.oob03='1' THEN
       INITIALIZE l_apg.* TO NULL
       LET l_apg.apg01 =g_ooa.ooa01
       LET l_apg.apg02 =l_oob.oob02
       LET l_apg.apg04 =l_oob.oob06
       LET l_apg.apg05f=l_oob.oob09
       LET l_apg.apg05 =l_oob.oob10
       LET l_apg.apg06 =l_oob.oob19
       LET l_apg.apglegal = g_legal #FUN-980011 add
 
       INSERT INTO apg_file VALUES(l_apg.*)
 
       IF STATUS OR SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
          LET g_showmsg=g_ooa.ooa01,"/",l_oob.oob02
          CALL s_errmsg('apg01,apg02',g_showmsg,'ins apg',SQLCA.SQLCODE,1)
          LET g_success = 'N'
       END IF
    END IF
    IF l_oob.oob03='2' THEN
       INITIALIZE l_aph.* TO NULL
       LET l_aph.aph01 =g_ooa.ooa01
       LET l_aph.aph02 =l_oob.oob02
       LET l_aph.aph03 ='0'
       LET l_aph.aph04 =l_oob.oob06
       LET l_aph.aph05f=l_oob.oob09
       LET l_aph.aph05 =l_oob.oob10
       LET l_aph.aph13 =l_oob.oob07
       LET l_aph.aph14 =l_oob.oob08
       LET l_aph.aph17 =l_oob.oob19
       LET l_aph.aphlegal = g_legal #FUN-980011 add
 
       INSERT INTO aph_file VALUES(l_aph.*)
 
       IF STATUS OR SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
          LET g_showmsg=g_ooa.ooa01,"/",l_oob.oob02
          CALL s_errmsg('aph01,aph02',g_showmsg,'ins aph',SQLCA.SQLCODE,1)
          LET g_success = 'N'
       END IF
    END IF
  END FOREACH
 
  IF g_totsuccess="N" THEN
     LET g_success="N"
  END IF
END FUNCTION
 
FUNCTION p305_mntn_offset_inv(p_oob06)
   DEFINE p_oob06   LIKE oob_file.oob06,
          l_oot04t  LIKE oot_file.oot04t,
          l_oot05t  LIKE oot_file.oot05t
 
   SELECT SUM(oot04t),SUM(oot05t) INTO l_oot04t,l_oot05t
     FROM oot_file
    WHERE oot03 = p_oob06
   IF cl_null(l_oot04t) THEN LET l_oot04t = 0 END IF
   IF cl_null(l_oot05t) THEN LET l_oot05t = 0 END IF
   RETURN l_oot04t,l_oot05t
END FUNCTION
 
FUNCTION p305_omc()
DEFINE   l_omc10           LIKE omc_file.omc10
DEFINE   l_omc11           LIKE omc_file.omc11
DEFINE   l_omc13           LIKE omc_file.omc13
DEFINE   l_oob09           LIKE oob_file.oob09
DEFINE   l_oob10           LIKE oob_file.oob10
 
  SELECT SUM(oob09),SUM(oob10) INTO l_oob09,l_oob10 FROM oob_file, ooa_file
   WHERE oob06=b_oob.oob06 AND oob19 = b_oob.oob19
     AND oob01=ooa01  AND ooaconf = 'Y'
     AND ((oob03='1' AND oob04='3') OR (oob03='2' AND oob04='1'))
 
  IF cl_null(l_oob09) THEN LET l_oob09 = 0 END IF
  IF cl_null(l_oob10) THEN LET l_oob10 = 0 END IF
 
  SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = b_oob.oob07
 
  CALL cl_digcut(l_oob09,t_azi04) RETURNING l_oob09
  CALL cl_digcut(l_oob10,g_azi04) RETURNING l_oob10
 
#FUN-A50102--mod--str--
# LET g_sql=" UPDATE ",g_dbs_new CLIPPED,"omc_file SET omc10=?,omc11=? ",
#           " WHERE omc01=? AND omc02=? "          
# PREPARE p305_bu_13_p3 FROM g_sql
# EXECUTE p305_bu_13_p3 USING l_oob09,l_oob10,b_oob.oob06,b_oob.oob19
  UPDATE omc_file SET omc10=l_oob09,
                      omc11=l_oob10
   WHERE omc01=b_oob.oob06 AND omc02=b_oob.oob19    
#FUN-A50102--mod--end
 
#FUN-A50102--mod--str--
# LET g_sql=" UPDATE ",g_dbs_new CLIPPED,"omc_file SET omc13=omc09-omc11",
#           " WHERE omc01=? AND omc02=? "          
# PREPARE p305_bu_13_p4 FROM g_sql
# EXECUTE p305_bu_13_p4 USING b_oob.oob06,b_oob.oob19
  UPDATE omc_file SET omc13=omc09-omc11
   WHERE omc01=b_oob.oob06 AND omc02=b_oob.oob19
#FUN-A50102--mod--end
 
END FUNCTION
 
FUNCTION p305_bu_2A()
  DEFINE l_nme  RECORD   LIKE nme_file.*
#FUN-B30166--add--str
   DEFINE l_year     LIKE type_file.chr4
   DEFINE l_month    LIKE type_file.chr4
   DEFINE l_day      LIKE type_file.chr4
   DEFINE l_dt       LIKE type_file.chr20
   DEFINE l_date1    LIKE type_file.chr20
   DEFINE l_time     LIKE type_file.chr20
   DEFINE l_nme27    LIKE nme_file.nme27
#FUN-B30166--add--end
 
             INITIALIZE l_nme.* TO NULL
	     LET l_nme.nme00 = '0'
	     LET l_nme.nme01 = b_oob.oob17
	     LET l_nme.nme02 = g_ooa.ooa02
	     LET l_nme.nme03 = b_oob.oob18
	     LET l_nme.nme04 = b_oob.oob09
	     LET l_nme.nme07 = g_ooa.ooa24
	     LET l_nme.nme08 = b_oob.oob10
	     LET l_nme.nme10 = g_ooa.ooa33
	     LET l_nme.nme12 = b_oob.oob01
	     LET l_nme.nme13 = g_ooa.ooa032
	     LET l_nme.nme14 = b_oob.oob21
	     LET l_nme.nme15 = b_oob.oob13
	     LET l_nme.nme16 = g_ooa.ooa02
	     LET l_nme.nmeacti='Y'
	     LET l_nme.nmeuser=g_user
	     LET l_nme.nmegrup=g_grup
	     LET l_nme.nmedate=TODAY
	     LET l_nme.nme21=b_oob.oob02
	     LET l_nme.nme22='01'
	     LET l_nme.nme23=b_oob.oob04
	     LET l_nme.nme24='9'
             LET l_nme.nmelegal = g_legal #FUN-980011 add
	     LET l_nme.nmeoriu = g_user      #No.FUN-980030 10/01/04
	     LET l_nme.nmeorig = g_grup      #No.FUN-980030 10/01/04
#FUN-B30166--add--str
             LET l_date1 = g_today
             LET l_year = YEAR(l_date1)USING '&&&&'
             LET l_month = MONTH(l_date1) USING '&&'
             LET l_day = DAY(l_date1) USING  '&&'
             LET l_time = TIME(CURRENT)
             LET l_dt   = l_year CLIPPED,l_month CLIPPED,l_day CLIPPED,
                          l_time[1,2],l_time[4,5],l_time[7,8]
             SELECT MAX(nme27) + 1 INTO l_nme.nme27 FROM nme_file
              WHERE nme27[1,14] = l_dt
             IF cl_null(l_nme.nme27) THEN
                LET l_nme.nme27 = l_dt,'000001'
             END if
#FUN-B30166--add--end
	     INSERT INTO nme_file VALUES(l_nme.*)
	     IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
	        LET g_success = 'N'
	        CALL cl_err3("ins","nme_file","","",SQLCA.sqlcode,"","",1)
	        RETURN
	     END IF
       CALL s_flows_nme(l_nme.*,'1',g_plant)   #No.FUN-B90062    
END FUNCTION
 
FUNCTION p305_cvoucher()
  DEFINE l_cnt  LIKE type_file.num5
 
  IF g_ooy.ooydmy1 = 'Y' AND g_ooy.ooyglcr = 'Y' THEN
     SELECT COUNT(*) INTO l_cnt FROM npq_file
      WHERE npq01= g_ooa.ooa01
        AND npq00= 3
        AND npqsys= 'AR'
        AND npq011= 1
     IF l_cnt = 0 THEN
        CALL p305_gen_glcr(g_ooa.*,g_ooy.*)
     END IF
     IF g_success = 'Y' THEN
        CALL s_chknpq(g_ooa.ooa01,'AR',1,'0',g_bookno1)
        IF g_aza.aza63='Y' AND g_success='Y' THEN
           CALL s_chknpq(g_ooa.ooa01,'AR',1,'1',g_bookno2)
        END IF
        #LET g_dbs_new = g_dbs CLIPPED,'.'   #FUN-A50102
     END IF
     IF g_success = 'N' THEN
        ROLLBACK WORK
        RETURN
     END IF
  END IF
 
END FUNCTION
 
FUNCTION p305_gen_glcr(p_ooa,p_ooy)
  DEFINE p_ooa     RECORD LIKE ooa_file.*
  DEFINE p_ooy     RECORD LIKE ooy_file.*
 
    IF cl_null(p_ooy.ooygslp) THEN
       CALL cl_err(p_ooa.ooa01,'axr-070',1)
       LET g_success = 'N'
       RETURN
    END IF
    CALL s_t400_gl(p_ooa.ooa01,'0')
    IF g_aza.aza63='Y' THEN
       CALL s_t400_gl(p_ooa.ooa01,'1')
    END IF
    IF g_success = 'N' THEN RETURN END IF
END FUNCTION
 
FUNCTION p305_carry_voucher()
   DEFINE   i         LIKE    type_file.num5
   DEFINE   l_t       LIKE    ooy_file.ooyslip   
   FOR i=1 TO g_cnt
      SELECT * INTO g_ooa.* FROM ooa_file WHERE ooa01 = g_a[i].ooa01
      CALL s_get_doc_no(g_a[i].ooa01) RETURNING l_t
      SELECT * INTO g_ooy.*  FROM ooy_file  WHERE  ooyslip = l_t 
      IF STATUS THEN
         LET g_success = 'N'
         CALL cl_err("","axr-277",0)
         RETURN
      END IF
      IF g_ooy.ooyglcr = 'Y' THEN
         LET g_wc_gl = 'npp01 = "',g_ooa.ooa01,'" AND npp011 = 1'
         LET g_str="axrp590 '",g_wc_gl CLIPPED,"' '",g_user,"' '",g_user,"' '",
                   g_ooz.ooz02p,"' '",g_ooz.ooz02b,"' '",g_ooy.ooygslp,"' '",
                   g_ooa.ooa02,"' 'Y' '0' 'Y' '",g_ooz.ooz02c,"' '",g_ooy.ooygslp1,"'"
         CALL cl_cmdrun_wait(g_str)
      END IF
   END FOR
END FUNCTION
#FUN-960140-add

#TQC-B10050   ---begin---
FUNCTION p305_bu_2C(p_sw,p_cnt)   #暫收
  DEFINE p_sw     LIKE type_file.chr1    # +:更新 -:還原
  DEFINE l_occ    RECORD LIKE occ_file.*
  DEFINE li_result  LIKE type_file.num5
  DEFINE l_omc    RECORD LIKE omc_file.*
  DEFINE l_oow    RECORD LIKE oow_file.* 
  DEFINE l_net           LIKE apv_file.apv04
  DEFINE p_cnt           LIKE type_file.num5

  SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = b_oob.oob07
  INITIALIZE l_occ.* TO NULL
  INITIALIZE l_omc.* TO NULL
  IF p_sw = '+'  THEN
     INITIALIZE g_oma.* LIKE oma_file.*
     CALL cl_digcut(b_oob.oob09,t_azi04) RETURNING b_oob.oob09
     CALL cl_digcut(b_oob.oob10,g_azi04) RETURNING b_oob.oob10
     LET g_oma.oma00 = '26'
     SELECT * INTO l_oow.* FROM oow_file WHERE oow00 = '0'
     CALL s_auto_assign_no("axr",l_oow.oow19,g_today,"26","oma_file","oma01","","","")
          RETURNING li_result,g_oma.oma01
     LET g_oma.oma02 = g_today
    #LET g_oma.oma03 = g_ooa.ooa03
     LET g_oma.oma03 = 'MISCCARD'
     LET g_oma.oma032 = g_ooa.ooa032
     LET g_oma.oma16 = g_ooa.ooa01
     SELECT * INTO l_occ.* FROM occ_file WHERE occ01=g_oma.oma03
     LET g_oma.oma68 = l_occ.occ07
     SELECT occ02 INTO g_oma.oma69 FROM occ_file WHERE occ01 = g_oma.oma68
     LET g_oma.oma04 = g_oma.oma03
     LET g_oma.oma05 = l_occ.occ08
     LET g_oma.oma21 = l_occ.occ41
     LET g_oma.oma23 = l_occ.occ42
     LET g_oma.oma40 = l_occ.occ37
     LET g_oma.oma25 = l_occ.occ43
     LET g_oma.oma32 = l_occ.occ45
     LET g_oma.oma042= l_occ.occ11
     LET g_oma.oma043= l_occ.occ18
     LET g_oma.oma044= l_occ.occ231
     CALL s_rdatem(g_oma.oma03,g_oma.oma32,g_oma.oma02,g_oma.oma09,g_oma.oma02,g_plant)
          RETURNING g_oma.oma11,g_oma.oma12
     SELECT gec04,gec05,gec07 INTO g_oma.oma211,g_oma.oma212,g_oma.oma213
       FROM gec_file WHERE gec01=g_oma.oma21 AND gec011='2'
     LET g_oma.oma08  = '1'
     IF g_oma.oma23=g_aza.aza17 THEN
        LET g_oma.oma24=1
        LET g_oma.oma58=1
     ELSE
        CALL s_curr3(g_oma.oma23,g_oma.oma02,g_ooz.ooz17) RETURNING g_oma.oma24
        CALL s_curr3(g_oma.oma23,g_oma.oma09,g_ooz.ooz17) RETURNING g_oma.oma58
     END IF
     LET g_oma.oma13 = g_ooa.ooa13
     LET g_oma.oma18 = b_oob.oob11
     IF g_aza.aza63 = 'Y' THEN
        LET g_oma.oma181 = b_oob.oob111
     END IF
     LET g_oma.oma60 = b_oob.oob08
     LET g_oma.oma61 = b_oob.oob10
     LET g_oma.oma70 = NULL
     LET g_oma.oma66 = g_plant
     LET g_oma.omalegal = g_azw.azw02
     LET g_oma.oma70 = '1'
     LET g_oma.oma50 = 0
     LET g_oma.oma50t = 0
     LET g_oma.oma51f = 0
     LET g_oma.oma51  = 0
     LET g_oma.oma52 = 0
     LET g_oma.oma53 = 0
     LET g_oma.oma54t = b_oob.oob09
     LET g_oma.oma56t=b_oob.oob09*g_oma.oma24
     IF cl_null(g_oma.oma213) THEN LET  g_oma.oma213 = 'N' END IF
     IF cl_null(g_oma.oma211) THEN LET g_oma.oma211 = 0 END IF
     IF g_oma.oma213 = 'N' THEN
        LET g_oma.oma54 = g_oma.oma54t
        LET g_oma.oma56 = g_oma.oma56t
     ELSE
        LET g_oma.oma54 = g_oma.oma54t/(1+g_oma.oma211/100)
        LET g_oma.oma56 = g_oma.oma56t/(1+g_oma.oma211/100)
     END IF
     LET g_oma.oma54x = g_oma.oma54t - g_oma.oma54
     LET g_oma.oma56x = g_oma.oma56t - g_oma.oma56
     CALL cl_digcut(g_oma.oma54,t_azi04) RETURNING g_oma.oma54
     CALL cl_digcut(g_oma.oma56,g_azi04) RETURNING g_oma.oma56
     CALL cl_digcut(g_oma.oma56x,g_azi04) RETURNING g_oma.oma56x
     CALL cl_digcut(g_oma.oma56t,g_azi04) RETURNING g_oma.oma56t
     LET g_oma.oma55 = 0
     LET g_oma.oma57 = 0
     LET g_oma.omaconf = 'Y'
     LET g_oma.omavoid = 'N'
     LET g_oma.omauser = g_user
     LET g_oma.omagrup = g_grup
     LET g_oma.oma64 = '0'
     LET g_oma.oma65 = '1'
     LET g_oma.omaoriu = g_user
     LET g_oma.omaorig = g_grup
     IF cl_null(g_oma.oma73) THEN LET g_oma.oma73 =0 END IF
     IF cl_null(g_oma.oma73f) THEN LET g_oma.oma73f =0 END IF
     IF cl_null(g_oma.oma74) THEN LET g_oma.oma74 ='1' END IF
     INSERT INTO oma_file VALUES(g_oma.*)
     IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
        LET g_success = 'N'
        CALL s_errmsg('oma01',g_oma.oma01,'ins oma',SQLCA.sqlcode,1)       #FUN-B80072    ADD
        ROLLBACK WORK
       # CALL s_errmsg('oma01',g_oma.oma01,'ins oma',SQLCA.sqlcode,1)       #FUN-B80072    MARK
     END IF

     CALL s_ar_oox03(g_oma.oma01) RETURNING l_net
     LET l_omc.omc01 = g_oma.oma01
     LET l_omc.omc02 = 1
     LET l_omc.omc03 = g_oma.oma32
     LET l_omc.omc04 = g_oma.oma11
     LET l_omc.omc05 = g_oma.oma12
     LET l_omc.omc06 = g_oma.oma24
     LET l_omc.omc07 = g_oma.oma60
     LET l_omc.omc08 = g_oma.oma54t
     LET l_omc.omc09 = g_oma.oma56t
     LET l_omc.omc10 = 0
     LET l_omc.omc11 = 0
     LET l_omc.omc12 = g_oma.oma10
     LET l_omc.omc13 = l_omc.omc09-l_omc.omc11+l_net
     LET l_omc.omc14 = 0
     LET l_omc.omc15 = 0
     CALL cl_digcut(l_omc.omc08,t_azi04) RETURNING l_omc.omc08
     CALL cl_digcut(l_omc.omc09,g_azi04) RETURNING l_omc.omc09
     CALL cl_digcut(l_omc.omc13,g_azi04) RETURNING l_omc.omc13

     LET l_omc.omclegal = g_legal
     INSERT INTO omc_file VALUES(l_omc.*)
     IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
       LET g_success = 'N'
       CALL s_errmsg('omc01',l_omc.omc01,'ins omc',SQLCA.sqlcode,1)
     END IF

     UPDATE oob_file SET oob06 = g_oma.oma01               #單據回寫oob06
       WHERE oob01 = b_oob.oob01 AND oob02 = b_oob.oob02
     IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
        LET g_success = 'N'
        CALL s_errmsg('oob01',g_oma.oma01,'upd oob06',SQLCA.sqlcode,1)
     END IF
  END IF
END FUNCTION
#TQC-B10050   ---end---
