# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: afai1001.4gl
# Descriptions...: 固定資產其它資料維護作業
# Date & Author..: 96/05/21 By Melody
# Date & Modity..: 03/07/17 By Wiky #No:7620 科目faj53/faj54/faj55 重新調整
# Modify.........: No.FUN-660136 06/06/20 By Ice cl_err --> cl_err3
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B10053 11/01/25 By yinhy 科目查询自动过滤
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_faj   RECORD LIKE faj_file.*,
    g_faj_t RECORD LIKE faj_file.*,
    g_faj_o RECORD LIKE faj_file.*,
    g_faj01_t LIKE faj_file.faj01,
    g_faj02_t LIKE faj_file.faj02,
    g_argv1             LIKE faj_file.faj01,         #No.FUN-680070 VARCHAR(10)
    g_argv2             LIKE faj_file.faj02,         #No.FUN-680070 VARCHAR(10)
    g_argv3             LIKE faj_file.faj022,        #No.FUN-680070 VARCHAR(04)
    c1                  LIKE type_file.chr20,        #No.FUN-680070 VARCHAR(12)
    d1                  LIKE type_file.chr20,        #No.FUN-680070 VARCHAR(12)
    e1                  LIKE type_file.chr20,        #No.FUN-680070 VARCHAR(12)
    f1                  LIKE type_file.chr20,        #No.FUN-680070 VARCHAR(12)
    g1                  LIKE type_file.chr20,        #No.FUN-680070 VARCHAR(12)
    aag02_1             LIKE aag_file.aag02,         #No.FUN-680070 VARCHAR(20)
    aag02_2             LIKE aag_file.aag02,         #No.FUN-680070 VARCHAR(20)
    aag02_3             LIKE aag_file.aag02,         #No.FUN-680070 VARCHAR(20)
    l_count             LIKE type_file.num5          #No.FUN-680070 SMALLINT
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done   STRING
 
FUNCTION i100_1(g_argv1,g_argv2,g_argv3)
DEFINE g_argv1        LIKE faj_file.faj01,         #No.FUN-680070 VARCHAR(10)
       g_argv2        LIKE faj_file.faj02,         #No.FUN-680070 VARCHAR(10)
       g_argv3        LIKE faj_file.faj022,        #No.FUN-680070 VARCHAR(04)
       l_sw           LIKE type_file.num5,         #No.FUN-680070 SMALLINT
       l_chr          LIKE type_file.chr1          #No.FUN-680070 VARCHAR(01)
 
    WHENEVER ERROR CONTINUE
 
    INITIALIZE g_faj.* TO NULL
    INITIALIZE g_faj_t.* TO NULL
    INITIALIZE g_faj_o.* TO NULL
 
    OPEN WINDOW i100_1_w WITH FORM "afa/42f/afai1001" 
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_locale("afai1001")
 
    SELECT * INTO g_faj.* FROM faj_file 
       WHERE faj01=g_argv1        
         AND faj02=g_argv2
         AND faj022=g_argv3
    IF SQLCA.sqlcode THEN  
       CALL cl_err3("sel","faj_file",g_argv1,g_argv2,SQLCA.sqlcode,"","",1)  #No.FUN-660136
       RETURN 
    END IF
 
    IF g_faj.faj01 IS NULL OR g_faj.faj02 IS NULL THEN RETURN END IF
 
    LET g_forupd_sql = "SELECT * FROM faj_file WHERE faj01=? AND faj02=? AND faj022=? FOR UPDATE"
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i100_cl1 CURSOR  FROM g_forupd_sql              # LOCK CURSOR
 
    CALL i100_1_show()
    CALL i100_1_u()
    CLOSE WINDOW i100_1_w
 
END FUNCTION
 
FUNCTION i100_1_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
        l_n             LIKE type_file.num5,         #No.FUN-680070 SMALLINT
        m_aag02         LIKE aag_file.aag02          #No.FUN-680070 VARCHAR(20)
 
    INPUT BY NAME
        g_faj.faj53,g_faj.faj23,g_faj.faj24,g_faj.faj54,
        g_faj.faj55,g_faj.faj37,
        g_faj.faj38,g_faj.faj39,g_faj.faj40,g_faj.faj41,
        g_faj.faj42,g_faj.faj421,g_faj.faj422,g_faj.faj423,g_faj.faj56
        WITHOUT DEFAULTS 
      
       #03/07/17 By Wiky #No:7620 科目faj53/faj54/faj55重新調整
       BEFORE FIELD faj53
           IF cl_null(g_faj.faj53) THEN
              SELECT fab11 INTO g_faj.faj53
                FROM fab_file
               WHERE fab01 = g_faj.faj04
           END IF
           IF g_faj.faj53<>' ' AND g_faj.faj53 IS NOT NULL THEN
              CALL i1001_faj53(g_faj.faj53) RETURNING aag02_1   
              DISPLAY BY NAME g_faj.faj53
              DISPLAY aag02_1 TO FORMONLY.aag02_1 
           ELSE
              DISPLAY ' ' TO FORMONLY.aag02_1 
           END IF
       AFTER FIELD faj53
           IF NOT cl_null(g_faj.faj53) THEN
              CALL i1001_faj53(g_faj.faj53)  RETURNING aag02_1
              IF NOT cl_null(g_errno) THEN
                 #No.FUN-B10053  --Begin
                 #CALL cl_err(g_faj.faj53,g_errno,1)
                 CALL cl_err(g_faj.faj53,g_errno,0)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_aag"
                 LET g_qryparam.construct = 'N'
                 LET g_qryparam.default1 = g_faj.faj53
                 LET g_qryparam.arg1 = g_aza.aza81
                 LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2' AND aagacti = 'Y' AND aag01 LIKE '",g_faj.faj53 CLIPPED,"%'"
                 CALL cl_create_qry() RETURNING g_faj.faj53
                 DISPLAY BY NAME g_faj.faj53
                 #No.FUN-B10053  --End
                 DISPLAY ' ' TO FORMONLY.aag02_1
                 NEXT FIELD faj53
              END IF 
           END IF
           IF cl_null(g_faj.faj53) THEN
              DISPLAY ' ' TO FORMONLY.aag02_1
              DISPLAY BY NAME g_faj.faj53
           END IF
       
       AFTER FIELD faj23
           IF g_faj.faj23 NOT MATCHES "[12]" THEN
              CALL cl_err(g_faj.faj23,'afa-124',0)
              NEXT FIELD faj23
           END IF
 
       BEFORE FIELD faj24
           IF g_faj.faj23='1' THEN 
              DISPLAY g_faj.faj20 TO faj24 
           END IF
 
       AFTER FIELD faj24
           IF g_faj.faj23='1' THEN
              SELECT * FROM gem_file WHERE gem01=g_faj.faj24
                 AND gemacti='Y'   #NO:6950
              IF STATUS=100 THEN
#                CALL cl_err(g_faj.faj24,'afa-083',0)   #No.FUN-660136
                 CALL cl_err3("sel","gem_file",g_faj.faj24,"","afa-083","","",1)  #No.FUN-660136
                 NEXT FIELD faj24
              END IF
           ELSE
              SELECT COUNT(*) INTO l_count FROM fad_file 
                 WHERE fad03=g_faj.faj53    
                   AND fad04=g_faj.faj24
              IF l_count=0 THEN
                 CALL cl_err(g_faj.faj24,'afa-084',0)
                 NEXT FIELD faj24
              END IF
           END IF
       #03/07/17 By Wiky#No:7620 科目faj53/faj54/faj55重新調整
       AFTER FIELD faj54
           IF NOT cl_null(g_faj.faj54) THEN
              CALL i1001_faj53(g_faj.faj54) RETURNING aag02_2
              IF NOT cl_null(g_errno) THEN
                 #No.FUN-B10053  --Begin
                 #CALL cl_err(g_faj.faj54,g_errno,1)
                 CALL cl_err(g_faj.faj54,g_errno,0)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_aag"
                 LET g_qryparam.construct = 'N'
                 LET g_qryparam.default1 = g_faj.faj54
                 LET g_qryparam.arg1 = g_aza.aza81
                 LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2' AND aagacti = 'Y' AND aag01 LIKE '",g_faj.faj54 CLIPPED,"%'"
                 CALL cl_create_qry() RETURNING g_faj.faj54
                 DISPLAY BY NAME g_faj.faj54
                 #No.FUN-B10053  --End
                 DISPLAY ' ' TO FORMONLY.aag02_2
                 NEXT FIELD faj54
              END IF 
           END IF
           DISPLAY BY NAME g_faj.faj54
           IF cl_null(g_faj.faj54) THEN
              DISPLAY ' ' TO FORMONLY.aag02_2
           ELSE
              DISPLAY aag02_2 TO FORMONLY.aag02_2
           END IF
       #03/07/17 By Wiky#No:7620 科目faj53/faj54/faj55重新調整
       AFTER FIELD faj55
           IF NOT cl_null(g_faj.faj55) THEN
              CALL i1001_faj53(g_faj.faj55) RETURNING aag02_3
              IF NOT cl_null(g_errno) THEN
                 #No.FUN-B10053  --Begin
                 #CALL cl_err(g_faj.faj55,g_errno,1)
                 CALL cl_err(g_faj.faj55,g_errno,0)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_aag"
                 LET g_qryparam.construct = 'N'
                 LET g_qryparam.default1 = g_faj.faj55
                 LET g_qryparam.arg1 = g_aza.aza81
                 LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2' AND aagacti = 'Y' AND aag01 LIKE '",g_faj.faj55 CLIPPED,"%'"
                 CALL cl_create_qry() RETURNING g_faj.faj55
                 DISPLAY BY NAME g_faj.faj55
                 #No.FUN-B10053  --End
                 DISPLAY ' ' TO FORMONLY.aag02_3
                 NEXT FIELD faj55
              END IF 
           END IF
           DISPLAY BY NAME g_faj.faj55
           IF cl_null(g_faj.faj55) THEN
              DISPLAY ' ' TO FORMONLY.aag02_3
           ELSE
              DISPLAY aag02_3 TO FORMONLY.aag02_3
           END IF
 
       AFTER FIELD faj38
           IF g_faj.faj38 NOT MATCHES "[0-1]" THEN
              CALL cl_err(g_faj.faj38,'afa-087',0)
              NEXT FIELD faj38
           END IF
           CALL i100_1_faj38(g_faj.faj38) RETURNING c1        
           DISPLAY c1 TO FORMONLY.c1 
 
       AFTER FIELD faj39
           IF g_faj.faj39 NOT MATCHES "[0-2]" THEN
              CALL cl_err(g_faj.faj39,'afa-088',0)
              NEXT FIELD faj39
           END IF
           CALL i100_1_faj39(g_faj.faj39) RETURNING d1        
           DISPLAY d1 TO FORMONLY.d1 
 
       AFTER FIELD faj40
           IF g_faj.faj40 NOT MATCHES "[0-5]" THEN
              CALL cl_err(g_faj.faj40,'afa-090',0)
              NEXT FIELD faj40
           END IF
           CALL i100_1_faj40(g_faj.faj40) RETURNING e1        
           DISPLAY e1 TO FORMONLY.e1 
 
       AFTER FIELD faj41
           IF g_faj.faj41 NOT MATCHES "[0-4]" THEN
              CALL cl_err(g_faj.faj41,'afa-089',0)
              NEXT FIELD faj41
           END IF
           CALL i100_1_faj41(g_faj.faj41) RETURNING f1        
           DISPLAY f1 TO FORMONLY.f1 
 
       AFTER FIELD faj42
           IF g_faj.faj42 NOT MATCHES "[0-6]" THEN
              CALL cl_err(g_faj.faj42,'afa-090',0)
              NEXT FIELD faj42
           END IF
           CALL i100_1_faj42(g_faj.faj42) RETURNING g1        
           DISPLAY g1 TO FORMONLY.g1 
 
       AFTER INPUT
           IF INT_FLAG THEN                         # 若按了DEL鍵
              CALL cl_err('',9001,0)
              EXIT INPUT 
           END IF
       #----------  重要欄位判斷不可空白  ----------------#
           IF g_faj.faj23=' ' OR g_faj.faj23 IS NULL THEN
              CALL cl_err(g_faj.faj23,'afa-124',0)
              NEXT FIELD faj23
           END IF
           IF g_faj.faj24=' ' OR g_faj.faj24 IS NULL THEN
              CALL cl_err(g_faj.faj24,'afa-083',0)
              NEXT FIELD faj24
           END IF
           IF cl_null(g_faj.faj55) AND g_faj.faj28<>'0' THEN
              CALL cl_err(g_faj.faj55,'afa-091',0)
              NEXT FIELD faj55
           END IF
           IF g_faj.faj37=' ' OR g_faj.faj37 IS NULL THEN
              CALL cl_err(g_faj.faj37,'afa-086',0)
              NEXT FIELD faj37
           END IF
           IF g_faj.faj38=' ' OR g_faj.faj38 IS NULL THEN
              CALL cl_err(g_faj.faj38,'afa-087',0)
              NEXT FIELD faj38
           END IF
           IF g_faj.faj39=' ' OR g_faj.faj39 IS NULL THEN
              CALL cl_err(g_faj.faj39,'afa-088',0)
              NEXT FIELD faj39
           END IF
           IF g_faj.faj40=' ' OR g_faj.faj40 IS NULL THEN
              CALL cl_err(g_faj.faj40,'afa-090',0)
              NEXT FIELD faj40
           END IF
           IF g_faj.faj41=' ' OR g_faj.faj41 IS NULL THEN
              CALL cl_err(g_faj.faj41,'afa-089',0)
              NEXT FIELD faj41
           END IF
           IF g_faj.faj42=' ' OR g_faj.faj42 IS NULL THEN
              CALL cl_err(g_faj.faj42,'afa-090',0)
              NEXT FIELD faj42
           END IF
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(faj53) 
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
                 LET g_qryparam.default1 = g_faj.faj53
                 LET g_qryparam.arg1 = g_aza.aza81                 #FUN-B10053 add
                 CALL cl_create_qry() RETURNING g_faj.faj53
#                CALL q_aag(10,3,g_faj.faj53,'23','2',' ') RETURNING g_faj.faj53
#                CALL FGL_DIALOG_SETBUFFER( g_faj.faj53 )
                 DISPLAY BY NAME g_faj.faj53 
                 NEXT FIELD faj53
              WHEN INFIELD(faj24)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gem"
                 LET g_qryparam.default1 = g_faj.faj24
                 LET g_qryparam.arg1 = g_aza.aza81                 #FUN-B10053 add
                 CALL cl_create_qry() RETURNING g_faj.faj24
#                 CALL q_gem(10,3,g_faj.faj24) RETURNING g_faj.faj24
#                 CALL FGL_DIALOG_SETBUFFER( g_faj.faj24 )
                 DISPLAY BY NAME g_faj.faj24 
                 NEXT FIELD faj24
              WHEN INFIELD(faj54) 
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
                 LET g_qryparam.default1 = g_faj.faj54
                 LET g_qryparam.arg1 = g_aza.aza81                 #FUN-B10053 add
                 CALL cl_create_qry() RETURNING g_faj.faj54
#                CALL q_aag(10,3,g_faj.faj54,'23','2',' ') RETURNING g_faj.faj54
#                CALL FGL_DIALOG_SETBUFFER( g_faj.faj54 )
                 DISPLAY BY NAME g_faj.faj54 
                 NEXT FIELD faj54
              WHEN INFIELD(faj55) 
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
                 LET g_qryparam.default1 = g_faj.faj55
                 CALL cl_create_qry() RETURNING g_faj.faj55
#                CALL q_aag(10,3,g_faj.faj55,'23','2',' ') RETURNING g_faj.faj55
#                CALL FGL_DIALOG_SETBUFFER( g_faj.faj55 )
                 DISPLAY BY NAME g_faj.faj55 
                 NEXT FIELD faj55
              OTHERWISE EXIT CASE
           END CASE
 
        ON ACTION mntn_mul_dept_appor
                  CALL cl_cmdrun('afai030' CLIPPED)
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION CONTROLF                        # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
    
    END INPUT
END FUNCTION
FUNCTION i1001_faj53(p_char)
DEFINE
      l_aagacti  LIKE aag_file.aagacti,
      l_aag02    LIKE aag_file.aag02,
      l_aag03    LIKE aag_file.aag03,   #No.FUN-B10053
      l_aag07    LIKE aag_file.aag07,   #No.FUN-B10053
      p_char     LIKE faj_file.faj53,
      p_cmd      LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 
    LET g_errno = " "
    #SELECT aag02,aagacti INTO l_aag02,l_aagacti                             #No.FUN-B10053
    SELECT aag02,aag07,aag03,aagacti INTO l_aag02,l_aag07,l_aag03,l_aagacti  #No.FUN-B10053
      FROM aag_file
     WHERE aag01=p_char
       AND aag00=g_aza.aza81        #No.FUN-B10053 add
    CASE
         WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-025'
                                  LET l_aag02 = NULL
                                  LET l_aagacti = NULL
         WHEN l_aag07  = '1'      LET g_errno = 'agl-015'    #No.FUN-B10053
         WHEN l_aag03 != '2'      LET g_errno = 'agl-201'    #No.FUN-B10053
         WHEN l_aagacti='N'       LET g_errno = '9028'
         OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    RETURN(l_aag02)
    #IF cl_null(g_errno) OR p_cmd = 'd' THEN
    #   DISPLAY l_aag02 TO FORMONLY.aag02_1
    #END IF
END FUNCTION
  
 
FUNCTION i100_1_show()
    DISPLAY BY NAME 
        g_faj.faj53,g_faj.faj23,g_faj.faj24,g_faj.faj54,
        g_faj.faj55,g_faj.faj37,
        g_faj.faj38,g_faj.faj39,g_faj.faj40,g_faj.faj41,
        g_faj.faj42,g_faj.faj421,g_faj.faj422,g_faj.faj423,g_faj.faj56
        
    CALL i1001_faj53(g_faj.faj53) RETURNING aag02_1
    CALL i1001_faj53(g_faj.faj54) RETURNING aag02_2
    CALL i1001_faj53(g_faj.faj55) RETURNING aag02_3
    CALL i100_1_faj38(g_faj.faj38) RETURNING c1 
    CALL i100_1_faj39(g_faj.faj39) RETURNING d1 
    CALL i100_1_faj40(g_faj.faj40) RETURNING e1 
    CALL i100_1_faj41(g_faj.faj41) RETURNING f1 
    CALL i100_1_faj42(g_faj.faj42) RETURNING g1 
    DISPLAY aag02_1 TO FORMONLY.aag02_1 
    DISPLAY aag02_2 TO FORMONLY.aag02_2 
    DISPLAY aag02_3 TO FORMONLY.aag02_3 
    DISPLAY c1 TO FORMONLY.c1 
    DISPLAY d1 TO FORMONLY.d1 
    DISPLAY e1 TO FORMONLY.e1
    DISPLAY f1 TO FORMONLY.f1
    DISPLAY g1 TO FORMONLY.g1 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i100_1_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_faj.faj01 IS NULL OR g_faj.faj02 IS NULL THEN
        CALL cl_err('',-421,0)
        RETURN
    END IF
    MESSAGE ""
    LET g_faj01_t = g_faj.faj01
    LET g_faj02_t = g_faj.faj02
    BEGIN WORK
    #No.B375 010517 by linda add
 
    OPEN i100_cl1 USING g_argv1,g_argv2,g_argv3
 
    IF STATUS THEN
       CALL cl_err("OPEN i100_cl1:", STATUS, 1)
       CLOSE i100_cl1
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i100_cl1 INTO g_faj.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_faj.faj01,SQLCA.sqlcode,0)
        RETURN
    END IF
    #No.B375 end---
    WHILE TRUE
        LET g_faj_o.* = g_faj.*
        CALL i100_1_i("u")        
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_faj.*=g_faj_t.*
            CALL i100_1_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE faj_file SET faj_file.* = g_faj.* 
            WHERE faj01=g_faj.faj01
              AND faj02=g_faj.faj02
              AND faj022=g_faj.faj022
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_faj.faj01,SQLCA.sqlcode,0)   #No.FUN-660136
            CALL cl_err3("upd","faj_file",g_faj.faj01,g_faj.faj02,SQLCA.sqlcode,"","",1)  #No.FUN-660136
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i100_cl1   #No.B375 add
    COMMIT WORK
END FUNCTION
{
FUNCTION i100_1_faj53(l_faj53)
DEFINE
      l_faj53   LIKE faj_file.faj53,
      l_bn      LIKE type_file.chr20        #No.FUN-680070 VARCHAR(20)
 
      IF l_faj53=' ' OR l_faj53 IS NULL THEN
         LET l_bn=' '
      ELSE
         SELECT aag02 INTO l_bn FROM aag_file
            WHERE aag01=l_faj53
         IF STATUS=100 THEN LET l_bn=NULL END IF
      END IF
      RETURN(l_bn)
END FUNCTION
}
FUNCTION i100_1_faj38(l_faj38)
DEFINE
      l_faj38   LIKE faj_file.faj38,
      l_bn      LIKE type_file.chr6         #No.FUN-680070 VARCHAR(06)
 
     CASE l_faj38
         WHEN '0'
            CALL cl_getmsg('afa-060',g_lang) RETURNING l_bn
         WHEN '1' 
            CALL cl_getmsg('afa-061',g_lang) RETURNING l_bn
         OTHERWISE EXIT CASE
      END CASE
      RETURN(l_bn)
END FUNCTION
 
FUNCTION i100_1_faj39(l_faj39)
DEFINE
      l_faj39   LIKE faj_file.faj39,
      l_bn       LIKE type_file.chr6         #No.FUN-680070 VARCHAR(06)
 
     CASE l_faj39
         WHEN '0'
            CALL cl_getmsg('afa-062',g_lang) RETURNING l_bn
         WHEN '1' 
            CALL cl_getmsg('afa-063',g_lang) RETURNING l_bn
         WHEN '2' 
            CALL cl_getmsg('afa-064',g_lang) RETURNING l_bn
         OTHERWISE EXIT CASE
      END CASE
      RETURN(l_bn)
END FUNCTION
 
FUNCTION i100_1_faj40(l_faj40)
DEFINE
      l_faj40   LIKE faj_file.faj40,
      l_bn       LIKE type_file.chr8         #No.FUN-680070 VARCHAR(08)
 
     CASE l_faj40
         WHEN '0'
            CALL cl_getmsg('afa-065',g_lang) RETURNING l_bn
         WHEN '1' 
            CALL cl_getmsg('afa-066',g_lang) RETURNING l_bn
         WHEN '2' 
            CALL cl_getmsg('afa-067',g_lang) RETURNING l_bn
         WHEN '3' 
            CALL cl_getmsg('afa-068',g_lang) RETURNING l_bn
         WHEN '4' 
            CALL cl_getmsg('afa-069',g_lang) RETURNING l_bn
         WHEN '5' 
            CALL cl_getmsg('afa-070',g_lang) RETURNING l_bn
         WHEN '6' 
            CALL cl_getmsg('afa-369',g_lang) RETURNING l_bn
         OTHERWISE EXIT CASE
      END CASE
      RETURN(l_bn)
END FUNCTION
 
FUNCTION i100_1_faj41(l_faj41)
DEFINE
      l_faj41   LIKE faj_file.faj41,
      l_bn       LIKE type_file.chr8         #No.FUN-680070 VARCHAR(08)
 
     CASE l_faj41
         WHEN '0'
            CALL cl_getmsg('afa-071',g_lang) RETURNING l_bn
         WHEN '1' 
            CALL cl_getmsg('afa-072',g_lang) RETURNING l_bn
         WHEN '2' 
            CALL cl_getmsg('afa-073',g_lang) RETURNING l_bn
         WHEN '3' 
            CALL cl_getmsg('afa-074',g_lang) RETURNING l_bn
         WHEN '4' 
            CALL cl_getmsg('afa-075',g_lang) RETURNING l_bn
         OTHERWISE EXIT CASE
      END CASE
      RETURN(l_bn)
END FUNCTION
 
FUNCTION i100_1_faj42(l_faj42)
DEFINE
      l_faj42   LIKE faj_file.faj42,
      l_bn       LIKE type_file.chr20        #No.FUN-680070 VARCHAR(12)
 
     CASE l_faj42
         WHEN '0'
            CALL cl_getmsg('afa-076',g_lang) RETURNING l_bn
         WHEN '1' 
            CALL cl_getmsg('afa-077',g_lang) RETURNING l_bn
         WHEN '2' 
            CALL cl_getmsg('afa-078',g_lang) RETURNING l_bn
         WHEN '3' 
            CALL cl_getmsg('afa-079',g_lang) RETURNING l_bn
         WHEN '4' 
            CALL cl_getmsg('afa-080',g_lang) RETURNING l_bn
         WHEN '5' 
            CALL cl_getmsg('afa-081',g_lang) RETURNING l_bn
         WHEN '6' 
            CALL cl_getmsg('afa-082',g_lang) RETURNING l_bn
         OTHERWISE EXIT CASE
      END CASE
      RETURN(l_bn)
END FUNCTION
