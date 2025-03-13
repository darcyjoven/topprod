# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: afai1011.4gl
# Descriptions...: 固定資產其它資料維護作業
# Date & Author..: 96/05/21 By Melody
# Modify.........: No.FUN-660136 06/06/20 By Ice cl_err --> cl_err3
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B10053 11/01/25 By yinhy 科目查询自动过滤
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_fak   RECORD LIKE fak_file.*,
    g_fak_t RECORD LIKE fak_file.*,
    g_fak_o RECORD LIKE fak_file.*,
    g_fak01_t LIKE fak_file.fak01,
    g_fak02_t LIKE fak_file.fak02,
    g_argv1             LIKE fak_file.fak01,         #No.FUN-680070 VARCHAR(10)
    g_argv2             LIKE fak_file.fak02,         #No.FUN-680070 VARCHAR(10)
    g_argv3             LIKE fak_file.fak022,        #No.FUN-680070 VARCHAR(04)
    c1                  LIKE type_file.chr20,        #No.FUN-680070 VARCHAR(12)
    d1                  LIKE type_file.chr20,        #No.FUN-680070 VARCHAR(12)
    e1                  LIKE type_file.chr20,        #No.FUN-680070 VARCHAR(12)
    f1                  LIKE type_file.chr20,        #No.FUN-680070 VARCHAR(12)
    g1                  LIKE type_file.chr20,        #No.FUN-680070 VARCHAR(12)
    aag02_1             LIKE aag_file.aag02,         #No.FUN-680070 VARCHAR(20)
    aag02_2             LIKE aag_file.aag02,         #No.FUN-680070 VARCHAR(20)
    aag02_3             LIKE aag_file.aag02,         #No.FUN-680070 VARCHAR(20)
    l_count             LIKE type_file.num5          #No.FUN-680070 SMALLINT
 
FUNCTION i101_1(g_argv1,g_argv2,g_argv3)
DEFINE g_argv1        LIKE fak_file.fak01,            #No.FUN-680070 VARCHAR(10)
       g_argv2        LIKE fak_file.fak02,            #No.FUN-680070 VARCHAR(10)
       g_argv3        LIKE fak_file.fak022,           #No.FUN-680070 VARCHAR(04)
       l_sw           LIKE type_file.num5,            #No.FUN-680070 SMALLINT
       l_chr          LIKE type_file.chr1             #No.FUN-680070 VARCHAR(01)
 
    INITIALIZE g_fak.* TO NULL
    INITIALIZE g_fak_t.* TO NULL
    INITIALIZE g_fak_o.* TO NULL
 
    OPEN WINDOW i101_1_w WITH FORM "afa/42f/afai1011" 
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_locale("afai1011")
 
    SELECT * INTO g_fak.* FROM fak_file 
       WHERE fak01=g_argv1        
         AND fak02=g_argv2
         AND fak022=g_argv3
    IF SQLCA.sqlcode THEN  
       CALL cl_err3("sel","fak_file",g_argv1,g_argv2,SQLCA.sqlcode,"","",1)  #No.FUN-660136
       RETURN 
    END IF
    IF g_fak.fak01 IS NULL OR g_fak.fak02 IS NULL THEN RETURN END IF
    CALL i101_1_show()
    CALL i101_1_u()
    CLOSE WINDOW i101_1_w
 
END FUNCTION
 
FUNCTION i101_1_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
        l_n             LIKE type_file.num5,         #No.FUN-680070 SMALLINT
        m_aag02         LIKE aag_file.aag02          #No.FUN-680070 VARCHAR(20)
 
    INPUT BY NAME
        g_fak.fak53,g_fak.fak23,g_fak.fak24,g_fak.fak54,
        g_fak.fak55,g_fak.fak37,
        g_fak.fak38,g_fak.fak39,g_fak.fak40,g_fak.fak41,
        g_fak.fak42,g_fak.fak421,g_fak.fak422,g_fak.fak423,g_fak.fak56
        WITHOUT DEFAULTS 
 
       AFTER FIELD fak53
           #No.FUN-B10053  --Begin
           #IF g_fak.fak53<>' ' AND g_fak.fak53 IS NOT NULL THEN
           IF NOT cl_null(g_fak.fak53) THEN
              CALL i101_1_fak53(g_fak.fak53) RETURNING aag02_1   
              #IF aag02_1='afa-085' THEN
               IF NOT cl_null(g_errno) THEN
                 #CALL cl_err(g_fak.fak53,'afa-085',0)
                 CALL cl_err('',g_errno,0)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.construct = 'N'
                 LET g_qryparam.default1 = g_fak.fak53
                 LET g_qryparam.arg1 = g_aza.aza81 
                 LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2' AND aggacti = 'Y' AND aag01 LIKE '",g_fak.fak53 CLIPPED,"%'"
                 CALL cl_create_qry() RETURNING g_fak.fak53
                 DISPLAY BY NAME g_fak.fak53
           #No.FUN-B10053  --Begin
                 NEXT FIELD fak53
              END IF
              DISPLAY aag02_1 TO FORMONLY.aag02_1 
           ELSE
              DISPLAY ' ' TO FORMONLY.aag02_1 
           END IF
        
       AFTER FIELD fak23
           IF NOT cl_null(g_fak.fak23) THEN
              IF g_fak.fak23 NOT MATCHES "[12]" THEN
                 CALL cl_err(g_fak.fak23,'afa-124',0)
                 NEXT FIELD fak23
              END IF
           END IF
 
       BEFORE FIELD fak24
           IF g_fak.fak23='1' THEN 
              DISPLAY g_fak.fak20 TO fak24 
           END IF
 
       AFTER FIELD fak24
           IF g_fak.fak23='1' THEN
              SELECT * FROM gem_file WHERE gem01=g_fak.fak24
                 AND gemacti='Y'   #NO:6950
              IF STATUS=100 THEN
#                CALL cl_err(g_fak.fak24,'afa-083',0)   #No.FUN-660136
                 CALL cl_err3("sel","gem_file",g_fak.fak24,"","afa-083","","",1)  #No.FUN-660136
                 NEXT FIELD fak24
              END IF
           ELSE
              SELECT COUNT(*) INTO l_count FROM fad_file 
                 WHERE fad03=g_fak.fak53    
                   AND fad04=g_fak.fak24
              IF l_count=0 THEN
                 CALL cl_err(g_fak.fak24,'afa-084',0)
                 NEXT FIELD fak24
              END IF
           END IF
 
       AFTER FIELD fak54
           IF NOT cl_null(g_fak.fak54) THEN
              CALL i101_1_fak53(g_fak.fak54) RETURNING aag02_2   
              #No.FUN-B10053  --Begin
              #IF aag02_2='afa-085' THEN
              IF NOT cl_null(g_errno) THEN
                 #CALL cl_err(g_fak.fak54,'afa-085',0)
                 CALL cl_err('',g_errno,0)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.construct = 'N'
                 LET g_qryparam.default1 = g_fak.fak54
                 LET g_qryparam.arg1 = g_aza.aza81 
                 LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'  AND aggacti = 'Y' AND aag01 LIKE '",g_fak.fak54 CLIPPED,"%'"
                 CALL cl_create_qry() RETURNING g_fak.fak54
                 DISPLAY BY NAME g_fak.fak54
              #No.FUN-B10053  --End 
                 NEXT FIELD fak54 
              END IF
              DISPLAY aag02_2 TO FORMONLY.aag02_2 
           ELSE
              DISPLAY ' ' TO FORMONLY.aag02_2 
           END IF
 
       AFTER FIELD fak55
           IF NOT cl_null(g_fak.fak55) THEN
              CALL i101_1_fak53(g_fak.fak55) RETURNING aag02_3   
              #No.FUN-B10053  --Begin
              #IF aag02_3='afa-085' THEN
              IF NOT cl_null(g_errno) THEN
                 #CALL cl_err(g_fak.fak55,'afa-085',0)
                 CALL cl_err('',g_errno,0)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.construct = 'N'
                 LET g_qryparam.default1 = g_fak.fak55
                 LET g_qryparam.arg1 = g_aza.aza81 
                 LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'  AND aggacti = 'Y' AND aag01 LIKE '",g_fak.fak54 CLIPPED,"%'"
                 CALL cl_create_qry() RETURNING g_fak.fak55
                 DISPLAY BY NAME g_fak.fak55
                 #No.FUN-B10053  --End
                 NEXT FIELD fak55
              END IF
              DISPLAY aag02_3 TO FORMONLY.aag02_3 
           END IF
 
       AFTER FIELD fak38
           IF NOT cl_null(g_fak.fak38) THEN
              IF g_fak.fak38 NOT MATCHES "[0-1]" THEN
                 CALL cl_err(g_fak.fak38,'afa-087',0)
                 NEXT FIELD fak38
              END IF
              CALL i101_1_fak38(g_fak.fak38) RETURNING c1        
              DISPLAY c1 TO FORMONLY.c1 
           END IF
 
       AFTER FIELD fak39
           IF NOT cl_null(g_fak.fak39) THEN
              IF g_fak.fak39 NOT MATCHES "[0-2]" THEN
                 CALL cl_err(g_fak.fak39,'afa-088',0)
                 NEXT FIELD fak39
              END IF
              CALL i101_1_fak39(g_fak.fak39) RETURNING d1        
              DISPLAY d1 TO FORMONLY.d1 
           END IF
   
       AFTER FIELD fak40
           IF NOT cl_null(g_fak.fak40) THEN
              IF g_fak.fak40 NOT MATCHES "[0-5]" THEN
                 CALL cl_err(g_fak.fak40,'afa-090',0)
                 NEXT FIELD fak40
              END IF
              CALL i101_1_fak40(g_fak.fak40) RETURNING e1        
              DISPLAY e1 TO FORMONLY.e1 
           END IF
 
       AFTER FIELD fak41
           IF NOT cl_null(g_fak.fak41) THEN
              IF g_fak.fak41 NOT MATCHES "[0-4]" THEN
                 CALL cl_err(g_fak.fak41,'afa-089',0)
                 NEXT FIELD fak41
              END IF
              CALL i101_1_fak41(g_fak.fak41) RETURNING f1        
              DISPLAY f1 TO FORMONLY.f1 
           END IF
 
       AFTER FIELD fak42
           IF NOT cl_null(g_fak.fak42) THEN
              IF g_fak.fak42 NOT MATCHES "[0-5]" THEN
                 CALL cl_err(g_fak.fak42,'afa-090',0)
                 NEXT FIELD fak42
              END IF
              CALL i101_1_fak42(g_fak.fak42) RETURNING g1        
              DISPLAY g1 TO FORMONLY.g1 
           END IF
 
       AFTER INPUT
           IF INT_FLAG THEN                         # 若按了DEL鍵
              CALL cl_err('',9001,0)
              EXIT INPUT 
           END IF
       #----------  重要欄位判斷不可空白  ----------------#
           IF g_fak.fak23=' ' OR g_fak.fak23 IS NULL THEN
              CALL cl_err(g_fak.fak23,'afa-124',0)
              NEXT FIELD fak23
           END IF
           IF g_fak.fak24=' ' OR g_fak.fak24 IS NULL THEN
              CALL cl_err(g_fak.fak24,'afa-083',0)
              NEXT FIELD fak24
           END IF
           IF g_fak.fak55=' ' OR g_fak.fak55 IS NULL THEN
              CALL cl_err(g_fak.fak55,'afa-091',0)
              NEXT FIELD fak55
           END IF
           IF g_fak.fak37=' ' OR g_fak.fak37 IS NULL THEN
              CALL cl_err(g_fak.fak37,'afa-086',0)
              NEXT FIELD fak37
           END IF
           IF g_fak.fak38=' ' OR g_fak.fak38 IS NULL THEN
              CALL cl_err(g_fak.fak38,'afa-087',0)
              NEXT FIELD fak38
           END IF
           IF g_fak.fak39=' ' OR g_fak.fak39 IS NULL THEN
              CALL cl_err(g_fak.fak39,'afa-088',0)
              NEXT FIELD fak39
           END IF
           IF g_fak.fak40=' ' OR g_fak.fak40 IS NULL THEN
              CALL cl_err(g_fak.fak40,'afa-090',0)
              NEXT FIELD fak40
           END IF
           IF g_fak.fak41=' ' OR g_fak.fak41 IS NULL THEN
              CALL cl_err(g_fak.fak41,'afa-089',0)
              NEXT FIELD fak41
           END IF
           IF g_fak.fak42=' ' OR g_fak.fak42 IS NULL THEN
              CALL cl_err(g_fak.fak42,'afa-090',0)
              NEXT FIELD fak42
           END IF
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(fak53) 
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
                 LET g_qryparam.default1 = g_fak.fak53
                 LET g_qryparam.arg1 = g_aza.aza81              #FUN-B10053 add
                 CALL cl_create_qry() RETURNING g_fak.fak53
#                CALL q_aag(10,3,g_fak.fak53,'23','2',' ') RETURNING g_fak.fak53
#                CALL FGL_DIALOG_SETBUFFER( g_fak.fak53 )
                 DISPLAY BY NAME g_fak.fak53 
                 NEXT FIELD fak53
              WHEN INFIELD(fak24)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gem"
                 LET g_qryparam.default1 = g_fak.fak24
                 CALL cl_create_qry() RETURNING g_fak.fak24
#                 CALL q_gem(10,3,g_fak.fak24) RETURNING g_fak.fak24
#                 CALL FGL_DIALOG_SETBUFFER( g_fak.fak24 )
                 DISPLAY BY NAME g_fak.fak24 
                 NEXT FIELD fak24
              WHEN INFIELD(fak54) 
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
                 LET g_qryparam.default1 = g_fak.fak54
                 LET g_qryparam.arg1 = g_aza.aza81               #FUN-B10053 add
                 CALL cl_create_qry() RETURNING g_fak.fak54
#                CALL q_aag(10,3,g_fak.fak54,'23','2',' ') RETURNING g_fak.fak54
#                CALL FGL_DIALOG_SETBUFFER( g_fak.fak54 )
                 DISPLAY BY NAME g_fak.fak54 
                 NEXT FIELD fak54
              WHEN INFIELD(fak55) 
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
                 LET g_qryparam.default1 = g_fak.fak55
                 LET g_qryparam.arg1 = g_aza.aza81                 #FUN-B10053 add
                 CALL cl_create_qry() RETURNING g_fak.fak55
#                CALL q_aag(10,3,g_fak.fak55,'23','2',' ') RETURNING g_fak.fak55
#                CALL FGL_DIALOG_SETBUFFER( g_fak.fak55 )
                 DISPLAY BY NAME g_fak.fak55 
                 NEXT FIELD fak55
              OTHERWISE EXIT CASE
           END CASE
 
        ON ACTION multi_dept_depr
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
   
FUNCTION i101_1_show()
    DISPLAY BY NAME 
        g_fak.fak53,g_fak.fak23,g_fak.fak24,g_fak.fak54,
        g_fak.fak55,g_fak.fak37,
        g_fak.fak38,g_fak.fak39,g_fak.fak40,g_fak.fak41,
        g_fak.fak42,g_fak.fak421,g_fak.fak422,g_fak.fak423,g_fak.fak56
        
    CALL i101_1_fak53(g_fak.fak53) RETURNING aag02_1
    CALL i101_1_fak53(g_fak.fak54) RETURNING aag02_2
    CALL i101_1_fak53(g_fak.fak55) RETURNING aag02_3
    CALL i101_1_fak38(g_fak.fak38) RETURNING c1 
    CALL i101_1_fak39(g_fak.fak39) RETURNING d1 
    CALL i101_1_fak40(g_fak.fak40) RETURNING e1 
    CALL i101_1_fak41(g_fak.fak41) RETURNING f1 
    CALL i101_1_fak42(g_fak.fak41) RETURNING g1 
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
 
FUNCTION i101_1_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_fak.fak01 IS NULL OR g_fak.fak02 IS NULL THEN
        CALL cl_err('',-421,0)
        RETURN
    END IF
    MESSAGE ""
    LET g_fak01_t = g_fak.fak01
    LET g_fak02_t = g_fak.fak02
    BEGIN WORK
    WHILE TRUE
        LET g_fak_o.* = g_fak.*
        CALL i101_1_i("u")        
        IF INT_FLAG THEN
            LET g_fak.*=g_fak_t.*
            CALL i101_1_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE fak_file SET fak_file.* = g_fak.* 
            WHERE fak01=g_fak.fak01
              AND fak02=g_fak.fak02
              AND fak022=g_fak.fak022
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_fak.fak01,SQLCA.sqlcode,0)   #No.FUN-660136
            CALL cl_err3("upd","fak_file",g_fak.fak01,g_fak.fak02,SQLCA.sqlcode,"","",1)  #No.FUN-660136
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    COMMIT WORK
END FUNCTION
 
FUNCTION i101_1_fak53(l_fak53)
DEFINE
      l_fak53   LIKE fak_file.fak53,
      l_aag03    LIKE aag_file.aag03,   #No.FUN-B10053
      l_aag07    LIKE aag_file.aag07,   #No.FUN-B10053 
      l_aagacti  LIKE aag_file.aagacti, #No.FUN-B10053
      l_bn      LIKE type_file.chr20        #No.FUN-680070 VARCHAR(20)
 
      LET g_errno = " "                 #No.FUN-B10053
      IF l_fak53=' ' OR l_fak53 IS NULL THEN
         LET l_bn=' '
      ELSE
      #No.FUN-B10053  --Begin
         #SELECT aag02 INTO l_bn FROM aag_file
         SELECT aag02,aag03,aag07,aagacti INTO l_fak53,l_aag03,l_aag07,l_aagacti FROM aag_file
            WHERE aag01=l_fak53  
              AND aag00=g_aza.aza81
         #IF STATUS=100 THEN LET l_bn='afa-085' END IF
         CASE
             WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-025'
                                      LET l_fak53 = NULL
                                      LET l_aagacti = NULL
             WHEN l_aag07  = '1'      LET g_errno = 'agl-015'
             WHEN l_aag03 != '2'      LET g_errno = 'agl-201'
             WHEN l_aagacti='N'       LET g_errno = '9028'
             OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
         END CASE
      END IF
      RETURN(l_bn)
      #No.FUN-B10053  --End
END FUNCTION
 
FUNCTION i101_1_fak38(l_fak38)
DEFINE
      l_fak38   LIKE fak_file.fak38,
      l_bn       LIKE type_file.chr6         #No.FUN-680070 VARCHAR(06)
 
     CASE l_fak38
         WHEN '0'
            CALL cl_getmsg('afa-060',g_lang) RETURNING l_bn
         WHEN '1' 
            CALL cl_getmsg('afa-061',g_lang) RETURNING l_bn
         OTHERWISE EXIT CASE
      END CASE
      RETURN(l_bn)
END FUNCTION
 
FUNCTION i101_1_fak39(l_fak39)
DEFINE
      l_fak39   LIKE fak_file.fak39,
      l_bn       LIKE type_file.chr6         #No.FUN-680070 VARCHAR(06)
 
     CASE l_fak39
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
 
FUNCTION i101_1_fak40(l_fak40)
DEFINE
      l_fak40   LIKE fak_file.fak40,
      l_bn       LIKE type_file.chr8         #No.FUN-680070 VARCHAR(08)
 
     CASE l_fak40
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
         OTHERWISE EXIT CASE
      END CASE
      RETURN(l_bn)
END FUNCTION
 
FUNCTION i101_1_fak41(l_fak41)
DEFINE
      l_fak41   LIKE fak_file.fak41,
      l_bn       LIKE type_file.chr8         #No.FUN-680070 VARCHAR(08)
 
     CASE l_fak41
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
 
FUNCTION i101_1_fak42(l_fak42)
DEFINE
      l_fak42   LIKE fak_file.fak42,
      l_bn       LIKE type_file.chr20        #No.FUN-680070 VARCHAR(12)
 
     CASE l_fak42
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
