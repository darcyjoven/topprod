# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: afap700.4gl
# Descriptions...: 管理局核准作業  
# Date & Author..: 96/06/04 By Star
# Modify.........: No.MOD-490228 04/09/27 By Kitty 執行管理局核准作業,資料無法更新成功   
# Modify.........: No.FUN-660136 06/06/20 By Ice cl_err --> cl_err3
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.TQC-6C0208 06/12/30 By wujie   UPDATE faj42 SQL條件修改 
# Modify.........: No.MOD-740090 07/04/23 By Smapmin 該申請編號對應的財產皆屬合併應秀出訊息.
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9A0024 09/10/10 By destiny display xxx.*改為display對應欄位
# Modify.........: No:CHI-A70049 10/08/27 By Pengu  將多餘的DISPLAY程式mark
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting   1、離開MAIN時沒有cl_used(1)和cl_used(2)
#                                                           2、未加離開前得cl_used(2)
# Modify.........: No:FUN-B40028 11/04/12 By xianghui  加cl_used(g_prog,g_time,2)

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_fcb RECORD
             fcb01  LIKE fcb_file.fcb01,   #申請編號
             fcb02  LIKE fcb_file.fcb02,   #申請日期
             fcb03  LIKE fcb_file.fcb03,   #管理局核准日期
             fcb04  LIKE fcb_file.fcb04    #管理局核准文號
             END RECORD,
       g_fcc DYNAMIC ARRAY OF RECORD
             sure     LIKE type_file.chr1,                   # 確定否         #No.FUN-680070 VARCHAR(1)
             fcc02    LIKE fcc_file.fcc02,     # 項次
             fcc03    LIKE fcc_file.fcc03,     # 財產編號
             fcc031   LIKE fcc_file.fcc031,    # 附號
             fcc06    LIKE fcc_file.fcc06,     # 英文名稱
             fcc13    LIKE fcc_file.fcc13      # 成本
             END RECORD,
       g_fcc_t  RECORD
             sure     LIKE type_file.chr1,                   # 確定否         #No.FUN-680070 VARCHAR(1)
             fcc02    LIKE fcc_file.fcc02,     # 項次
             fcc03    LIKE fcc_file.fcc03,     # 財產編號
             fcc031   LIKE fcc_file.fcc031,    # 附號
             fcc06    LIKE fcc_file.fcc06,     # 英文名稱
             fcc13    LIKE fcc_file.fcc13      # 成本
             END RECORD,
    l_fcc  RECORD
             fcc01    LIKE fcc_file.fcc01,     # 申請編號
             fcc03    LIKE fcc_file.fcc03,     # 財產編號
             fcc031   LIKE fcc_file.fcc031     # 附號
             END RECORD,
        g_argv1       LIKE fcb_file.fcb01,     # 申請編號 
        l_fcc20       LIKE fcc_file.fcc20,
         g_wc,g_wc2,g_sql    string,  #No.FUN-580092 HCN
        g_cmd        LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(30)
        g_rec_b      LIKE type_file.num5,         #No.FUN-680070 SMALLINT
        l_exit_sw    LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
        l_ac,l_sl    LIKE type_file.num5         #No.FUN-680070 SMALLINT
DEFINE   g_cnt           LIKE type_file.num10           #No.FUN-680070 INTEGER
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
 
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                              # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF
 
 
   LET g_argv1=ARG_VAL(1)
   CALL cl_used(g_prog,g_time,1) RETURNING g_time      #FUN-B30211
   CALL p700_tm(4,2)                            # 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
END MAIN
 
FUNCTION p700_tm(p_row,p_col)
   DEFINE   p_row,p_col   LIKE type_file.num5         #No.FUN-680070 SMALLINT
#       l_time            LIKE type_file.chr8            #No.FUN-6A0069
 
 
     CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0069
   LET p_row = 3 LET p_col = 2
   OPEN WINDOW p700_w AT p_row,p_col WITH FORM "afa/42f/afap700" 
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
   CALL cl_opmsg('z')
   WHILE TRUE
      IF s_shut(0) THEN
         RETURN 
      END IF
      CLEAR FORM 
      CALL g_fcc.clear()
      IF NOT cl_null(g_argv1) THEN
         LET g_fcb.fcb01 = g_argv1 
          LET g_fcb.fcb02 = null    #No.MOD-470566
          LET g_fcb.fcb03 = null    #No.MOD-470566
      ELSE 
         INITIALIZE g_fcb.* TO NULL                   # Default condition
      END IF 
      CALL cl_set_head_visible("","YES")              #No.FUN-6B0029 
      INPUT BY NAME g_fcb.* WITHOUT DEFAULTS 
 
         AFTER FIELD fcb01
           IF NOT cl_null(g_fcb.fcb01) THEN
            SELECT fcb02,fcb03,fcb04
              INTO g_fcb.fcb02,g_fcb.fcb03,g_fcb.fcb04
              FROM fcb_file 
             WHERE fcb01 = g_fcb.fcb01 
               AND fcbconf IN ('y','Y')
            IF STATUS THEN
#              CALL cl_err('sel fcb',STATUS,1)   #No.FUN-660136
               CALL cl_err3("sel","fcb_file",g_fcb.fcb01 ,"",STATUS,"","sel fcb",1)   #No.FUN-660136
               NEXT FIELD fcb01 
            END IF
            #No.FUN-9A0024--begin  
            #DISPLAY BY NAME g_fcb.*
            DISPLAY BY NAME g_fcb.fcb01,g_fcb.fcb02,g_fcb.fcb03,g_fcb.fcb04
            #No.FUN-9A0024--end 
            CALL p700_show()
           END IF
         
         BEFORE FIELD fcb02
           IF cl_null(g_fcb.fcb02) THEN
              LET g_fcb.fcb02=g_today
              DISPLAY BY NAME g_fcb.fcb02
           END IF
 
         AFTER INPUT 
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
      
         ON ACTION CONTROLP
               CASE
                  WHEN INFIELD(fcb01) #申請單號
#                    CALL q_fcb(7,3,'1','2')
#                    RETURNING g_fcb.fcb01,g_fcb.fcb02,g_fcb.fcb03,g_fcb.fcb04
#                    CALL FGL_DIALOG_SETBUFFER( g_fcb.fcb01 )
#                    CALL FGL_DIALOG_SETBUFFER( g_fcb.fcb02 )
#                    CALL FGL_DIALOG_SETBUFFER( g_fcb.fcb03 )
#                    CALL FGL_DIALOG_SETBUFFER( g_fcb.fcb04 )
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_fcb01"
                     LET g_qryparam.default1 = g_fcb.fcb01
                     CALL cl_create_qry() RETURNING g_fcb.fcb01,g_fcb.fcb03,g_fcb.fcb04
#                     CALL FGL_DIALOG_SETBUFFER( g_fcb.fcb01 )
#                     CALL FGL_DIALOG_SETBUFFER( g_fcb.fcb03 )
#                     CALL FGL_DIALOG_SETBUFFER( g_fcb.fcb04 )
                    #SELECT fcb02 INTO g_fcb02 FROM fcb_file
                    # WHERE fcbconf = 'Y' AND fcb01 = g_fcj01 AND fcb03 = g_fcb03
                    #   AND fcb04 = g_fcb04
                     #No.FUN-9A0024--begin                                                                                                   
                     #DISPLAY BY NAME g_fcb.*                                                                                                
                     DISPLAY BY NAME g_fcb.fcb01,g_fcb.fcb02,g_fcb.fcb03,g_fcb.fcb04                                                         
                     #No.FUN-9A0024--end 
                     NEXT FIELD fcb01
              OTHERWISE EXIT CASE
           END CASE
      
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
         ON ACTION locale
#            CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
             LET g_action_choice = "locale"
             EXIT INPUT     
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      
      ON ACTION exit                            #加離開功能
         LET INT_FLAG = 1
         EXIT INPUT
#No.FUN-6B0029--begin                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end 
 
      END INPUT
 
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p700_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM
      END IF
      LET g_success='Y'
      LET l_exit_sw = 'N'
      IF l_exit_sw = 'n' THEN
         CALL cl_end(0,0) 
      END IF
      CALL p700_b()
      IF INT_FLAG THEN 
         LET INT_FLAG = 0
         CLOSE WINDOW p700_w 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B40028
        EXIT PROGRAM
      END IF
      UPDATE fcb_file SET fcb03=g_fcb.fcb03, fcb04=g_fcb.fcb04
                    WHERE fcb01 = g_fcb.fcb01
   END WHILE
 
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0069
   ERROR ""
   CLOSE WINDOW p700_w
END FUNCTION
   
FUNCTION p700_show()
    CALL p700_b_fill('1=1') 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION p700_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(1000)
    LET g_sql =
         "SELECT ' ',fcc02,fcc03,fcc031,fcc06,fcc13 ",
         "  FROM fcc_file",
         " WHERE fcc01 ='",g_fcb.fcb01,"'",
         "   AND fcc04 != '0'  ",
         " ORDER BY 2 "
 
    PREPARE p700_pb FROM g_sql
    DECLARE fcc_curs                       #SCROLL CURSOR
        CURSOR FOR p700_pb
 
    CALL g_fcc.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH fcc_curs INTO g_fcc[g_cnt].*   #單身 ARRAY 填充
       IF SQLCA.sqlcode THEN 
          CALL cl_err('fcc_curs',SQLCA.sqlcode,0)  
          EXIT FOREACH 
        END IF
        SELECT fcc20 INTO l_fcc20 FROM fcc_file  
         WHERE fcc01  = g_fcb.fcb01 AND fcc03 = g_fcc[g_cnt].fcc03
           AND fcc031 = g_fcc[g_cnt].fcc031
           IF SQLCA.sqlcode THEN
#              CALL cl_err('foreach:',SQLCA.sqlcode,1)   #No.FUN-660136
               CALL cl_err3("sel","fcc_file",g_fcb.fcb01,g_fcc[g_cnt].fcc03,SQLCA.sqlcode,"","foreach:",1)   #No.FUN-660136
               EXIT FOREACH
           END IF
         CASE  
          WHEN l_fcc20 ='3'  
             LET g_fcc[g_cnt].sure = 'Y'
          WHEN l_fcc20 ='4'  
             LET g_fcc[g_cnt].sure = 'N'
          OTHERWISE LET g_fcc[g_cnt].sure = ' ' 
        END CASE 
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_fcc.deleteElement(g_cnt)
    LET g_rec_b = g_cnt -1 
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
    #-----MOD-740090---------
    IF g_rec_b = 0 THEN
       CALL cl_err('','afa-410',1)
    END IF
    #-----END MOD-740090-----
END FUNCTION
 
FUNCTION p700_b()
DEFINE     
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT       #No.FUN-680070 SMALLINT
    l_row,l_col     LIKE type_file.num5,                #分段輸入之行,列數       #No.FUN-680070 SMALLINT
    l_n,l_cnt       LIKE type_file.num5,                #檢查重複用       #No.FUN-680070 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否       #No.FUN-680070 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態       #No.FUN-680070 VARCHAR(1)
    g_cmd           LIKE type_file.chr1000,       #No.FUN-680070 VARCHAR(100)
    l_possible      LIKE type_file.num5,                #用來設定判斷重複的可能性       #No.FUN-680070 SMALLINT
    l_flag          LIKE type_file.num10,        #No.FUN-680070 INTEGER
    l_allow_insert  LIKE type_file.num5,                #可新增否       #No.FUN-680070 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否       #No.FUN-680070 SMALLINT
 
    LET g_action_choice = ""
 
    IF g_fcb.fcb01 IS NULL THEN RETURN END IF
 
    LET g_forupd_sql = 
    "SELECT ' ',fcc02,fcc03,fcc031,fcc06,fcc13 ",
    "  FROM fcc_file  ",
    " WHERE fcc01  = ? ",
    "   AND fcc04 != ? ",
    "   AND fcc03  = ? ",
    "   AND fcc031 = ? ",
    "   FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE p700_bcl CURSOR FROM g_forupd_sql # LOCK CURSOR
 
    LET l_ac_t =  0
 
        INPUT ARRAY g_fcc WITHOUT DEFAULTS FROM s_fcc.* 
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=FALSE ,DELETE ROW=FALSE,APPEND ROW=FALSE)
 
#       BEFORE INPUT
#          CALL fgl_set_arr_curr(l_ac)
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()       #目前筆數
            LET l_lock_sw = 'N'                   #DEFAULT
            LET l_n  = ARR_COUNT()                #目前的array共有幾筆
            BEGIN WORK
            IF g_rec_b >= l_ac THEN
                LET p_cmd='u'
                LET g_fcc_t.* = g_fcc[l_ac].*  #BACKUP
                OPEN p700_bcl USING g_fcb.fcb01,'0',g_fcc_t.fcc03,g_fcc_t.fcc031
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_fcc[l_ac].fcc02,SQLCA.sqlcode,1)  
                   LET l_lock_sw = "Y"
                ELSE
                   FETCH p700_bcl INTO g_fcc[l_ac].* 
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_fcc[l_ac].fcc02,SQLCA.sqlcode,1)   
                       LET l_lock_sw = "Y"
                   END IF
                END IF
                IF cl_null(g_fcc[l_ac].sure) THEN
                   LET g_fcc[l_ac].sure = g_fcc_t.sure
                END IF 
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF 
 
        AFTER ROW 
          LET l_ac = ARR_CURR()
          LET l_ac_t = l_ac
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd='u' THEN
                LET g_fcc[l_ac].* = g_fcc_t.*
             END IF
             CLOSE p700_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
 
          LET g_fcc_t.* = g_fcc[l_ac].*
          CLOSE p700_bcl
          COMMIT WORK
 
        ON ACTION accept
          FOR l_ac = 1 TO g_rec_b     
            IF g_fcc[l_ac].sure = 'N' THEN 
               #---->更新對應抵減單身檔之狀態碼為「4.管理局刪除」
                UPDATE fcc_file SET fcc20 = '4'
                 WHERE fcc01 = g_fcb.fcb01 
                   AND fcc02 = g_fcc[l_ac].fcc02
                 IF SQLCA.sqlcode THEN             #No.MOD-490228
#                    CALL cl_err('upd fcc20',SQLCA.sqlcode,0)   #No.FUN-660136
                     CALL cl_err3("upd","fcc_file",g_fcb.fcb01,g_fcc[l_ac].fcc02,SQLCA.sqlcode,"","upd fcc20",0)   #No.FUN-660136
                     LET g_success = 'N'
                END IF
               #---->更新對應資產主檔之抵減碼[faj42]為「4.管理局刪除 」
                UPDATE faj_file SET faj42 = '4',
#No.TQC-6C0208--begin                                                                                                               
#                                      faj82 = ' ',                                                                                 
#                                      faj83 = ' '                                                                                  
                                       faj82 = '',                                                                                  
                                       faj83 = ''                                                                                   
#No.TQC-6C0208--end 
                 WHERE faj02  = g_fcc[l_ac].fcc03
                   AND faj022 = g_fcc[l_ac].fcc031 
                 IF SQLCA.sqlcode THEN                   #No.MOD-490228
#                    CALL cl_err('upd faj#1',SQLCA.sqlcode,0)   #No.FUN-660136
                     CALL cl_err3("upd","faj_file",g_fcc[l_ac].fcc03,g_fcc[l_ac].fcc031,SQLCA.sqlcode,"","upd faj#1",0)   #No.FUN-660136
                     LET g_success = 'N'
                END IF
               #---->更新合併編號為此財產編號之資產主檔之抵減碼[faj42]
               #     為「4.管理局不核准 」
                DECLARE p700_bcn CURSOR  FOR      # LOCK CURSOR
                 SELECT fcc01,fcc03,fcc031
                   FROM fcc_file 
                  WHERE fcc01 = g_fcb.fcb01
                    AND fcc02 = g_fcc[l_ac].fcc02  
                FOREACH p700_bcn INTO l_fcc.*
                   IF SQLCA.sqlcode != 0 THEN 
                      CALL cl_err('foreach:',SQLCA.sqlcode,1)  
                      EXIT FOREACH 
                   END IF
                   UPDATE faj_file SET faj42 = '4', 
#No.TQC-6C0208--begin                                                                                                               
#                                      faj82 = ' ',                                                                                 
#                                      faj83 = ' '                                                                                  
                                       faj82 = '',                                                                                  
                                       faj83 = ''                                                                                   
#No.TQC-6C0208--end 
                      WHERE faj02 = l_fcc.fcc03  
                        AND faj022= l_fcc.fcc031  
                   IF SQLCA.sqlcode THEN               #No.MOD-490228
#                      CALL cl_err('upd faj#2',SQLCA.sqlcode,0)   #No.FUN-660136
                       CALL cl_err3("upd","faj_file",l_fcc.fcc03,l_fcc.fcc031,SQLCA.sqlcode,"","upd faj#2",0)   #No.FUN-660136
                       LET g_success = 'N'
                  END IF
                END FOREACH 
            END IF
            IF g_fcc[l_ac].sure = 'Y' THEN 
               #---->更新對應抵減單身檔之狀態碼為「3.管理局已核准」
            
                UPDATE fcc_file SET fcc20 = '3'
                 WHERE fcc01 = g_fcb.fcb01 
                   AND fcc02 = g_fcc[l_ac].fcc02
                 IF SQLCA.sqlcode THEN                  #No.MOD-490228
#                    CALL cl_err('upd fcc20 = 3',SQLCA.sqlcode,0)   #No.FUN-660136
                     CALL cl_err3("upd","fcc_file",g_fcb.fcb01,g_fcc[l_ac].fcc02,SQLCA.sqlcode,"","upd fcc20 = 3",0)   #No.FUN-660136
                     LET g_success = 'N'
                ELSE 
                   #display 'upd fcc20=3'    #CHI-A70049 mark
                END IF
               #---->更新對應資產主檔之抵減碼[faj42]為「3.管理局核准 」
                UPDATE faj_file SET faj42 = '3',
                                    faj82 = g_fcb.fcb03,
                                    faj83 = g_fcb.fcb04
                     WHERE faj02  = g_fcc[l_ac].fcc03
                       AND faj022 = g_fcc[l_ac].fcc031 
                 IF SQLCA.sqlcode THEN                    #No.MOD-490228
#                    CALL cl_err('upd faj#3',SQLCA.sqlcode,0)   #No.FUN-660136
                     CALL cl_err3("upd","faj_file",g_fcc[l_ac].fcc03,g_fcc[l_ac].fcc031,SQLCA.sqlcode,"","upd faj#3",0)   #No.FUN-660136
                     LET g_success = 'N'
                END IF
               #---->更新合併編號為此財產編號之資產主檔之抵減碼[faj42]
               #     為「4.管理局不核准 」
                DECLARE p700_bcn2 CURSOR  FOR      # LOCK CURSOR
                 SELECT fcc01,fcc03,fcc031 FROM fcc_file 
                  WHERE fcc01 = g_fcb.fcb01
                    AND fcc02 = g_fcc[l_ac].fcc02  
                FOREACH p700_bcn2 INTO l_fcc.*
                   IF SQLCA.sqlcode != 0 THEN 
                      CALL cl_err('foreach:',SQLCA.sqlcode,1)  
                      EXIT FOREACH 
                   END IF
                   UPDATE faj_file SET faj42 = '3',
                                       faj82 = g_fcb.fcb03,
                                       faj83 = g_fcb.fcb04 
                      WHERE faj02 = l_fcc.fcc03  
                        AND faj022= l_fcc.fcc031  
                    IF SQLCA.sqlcode THEN           #No.MOD-490228
#                       CALL cl_err('upd faj#4',SQLCA.sqlcode,0)   #No.FUN-660136
                        CALL cl_err3("upd","faj_file",l_fcc.fcc03,l_fcc.fcc031,SQLCA.sqlcode,"","upd faj#4",0)   #No.FUN-660136
                        LET g_success = 'N'
                   END IF
                END FOREACH 
            END IF
        END FOR
          IF g_success = 'Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF    #No.MOD-490228
         CALL cl_end(0,0) 
        EXIT INPUT
 
          ON ACTION seleall  
#            CALL p700_t()
             FOR l_ac = 1 TO g_fcc.getLength()
                 LET g_fcc[l_ac].sure = 'Y'
             END FOR
 
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
        
      ON ACTION exit                            #加離開功能
         LET INT_FLAG = 1
         EXIT INPUT
#No.FUN-6B0029--begin                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end 
 
        END INPUT
    IF INT_FLAG THEN LET INT_FLAG = 0 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
       EXIT PROGRAM  
    END IF
 
END FUNCTION
 
FUNCTION p700_t()         #以下皆為已確認
 DEFINE l_ac LIKE type_file.num5         #No.FUN-680070 SMALLINT
     
  FOR l_ac = 1 TO g_rec_b     
#        BEGIN WORK
         LET g_fcc[l_ac].sure = 'Y'
         DISPLAY g_fcc[l_ac].sure TO s_fcc[l_ac].sure
#       #---->更新對應抵減單身檔之狀態碼為「3.管理局已核准」
#        UPDATE fcc_file SET fcc20 = '3'
#         WHERE fcc01 = g_fcb.fcb01 
#           AND fcc02 = g_fcc[l_ac].fcc02
#        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 
#        THEN CALL cl_err('upd fcc20 = 3',SQLCA.sqlcode,0)
#             LET g_success = 'N'
#        END IF
#       #---->更新對應資產主檔之抵減碼[faj42]為「3.管理局核准 」
#        UPDATE faj_file SET faj42 = '3',
#                            faj82 = g_fcb.fcb03,
#                            faj83 = g_fcb.fcb04
#             WHERE faj02  = g_fcc[l_ac].fcc03
#               AND faj022 = g_fcc[l_ac].fcc031 
#        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 
#        THEN CALL cl_err('upd faj#3',SQLCA.sqlcode,0)
#             LET g_success = 'N'
#        END IF
#       #---->更新合併編號為此財產編號之資產主檔之抵減碼[faj42]
#       #     為「4.管理局不核准 」
#        DECLARE p700_bcn3 CURSOR  FOR      # LOCK CURSOR
#         SELECT fcc01,fcc03,fcc031 FROM fcc_file 
#          WHERE fcc01 = g_fcb.fcb01
#            AND fcc02 = g_fcc[l_ac].fcc02  
#        FOREACH p700_bcn3 INTO l_fcc.*
#           IF SQLCA.sqlcode != 0 THEN 
#              CALL cl_err('foreach:',SQLCA.sqlcode,1)
#              EXIT FOREACH 
#           END IF
#           UPDATE faj_file SET faj42 = '3',
#                               faj82 = g_fcb.fcb03,
#                               faj83 = g_fcb.fcb04 
#              WHERE faj02 = l_fcc.fcc03  
#                AND faj022= l_fcc.fcc031  
#           IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 
#           THEN CALL cl_err('upd faj#4',SQLCA.sqlcode,0)
#                LET g_success = 'N'
#           END IF
#        END FOREACH 
#   IF g_success = 'Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF 
  END FOR 
# CALL p700_show()
END FUNCTION
