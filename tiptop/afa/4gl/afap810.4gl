# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: afap810.4gl
# Descriptions...: 免稅核准作業  
# Date & Author..: 96/05/30 By Star
# Modify.........: No.MOD-490193 04/10/01 By Kitty 若按放棄則不可回寫afat800的單頭
# Modify.........: No.FUN-660136 06/06/20 By Ice cl_err --> cl_err3
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-690113 06/10/13 By yjkhero cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.TQC-770080 07/07/13 By wujie 免費年限輸入負數沒管控
# Modify.........: No.TQC-980037 09/08/05 By lilingyu "免稅金額"對負數沒有控管
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9A0024 09/10/10 By destiny display xxx.*改為display對應欄位
# Modify.........: No:CHI-A70049 10/08/27 By Pengu  將多餘的DISPLAY程式mark
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_fch RECORD
             fch01  LIKE fch_file.fch01,   #申請編號
             fch02  LIKE fch_file.fch02,   #申請日期
             fch05  LIKE fch_file.fch05,   #核准文號
             fch06  LIKE fch_file.fch06,   #免稅核准日期
             fch07  LIKE fch_file.fch07,   #免稅核准文號
             fch08  LIKE fch_file.fch08,   #免稅年限
             fch09  LIKE fch_file.fch09    #免稅金額
             END RECORD,
       g_fci DYNAMIC ARRAY OF RECORD
             sure     LIKE type_file.chr1,                   # 確定否         #No.FUN-680070 VARCHAR(1)
             fci02    LIKE fci_file.fci02,     # 項次
             fci03    LIKE fci_file.fci03,     # 財產編號
             fci031   LIKE fci_file.fci031,    # 附號
             fci05    LIKE fci_file.fci05,     # 英文名稱
             fci15    LIKE fci_file.fci15      # 成本
             END RECORD,
       g_fci_t  RECORD
             sure     LIKE type_file.chr1,                   # 確定否         #No.FUN-680070 VARCHAR(1)
             fci02    LIKE fci_file.fci02,     # 項次
             fci03    LIKE fci_file.fci03,     # 財產編號
             fci031   LIKE fci_file.fci031,    # 附號
             fci05    LIKE fci_file.fci05,     # 英文名稱
             fci15    LIKE fci_file.fci15      # 成本
             END RECORD,
    l_fci  RECORD
             fci01    LIKE fci_file.fci01,     # 申請編號
             fci03    LIKE fci_file.fci03,     # 財產編號
             fci031   LIKE fci_file.fci031,    # 附號
             fci07    LIKE fci_file.fci07,     # 合併編號
             fci071   LIKE fci_file.fci071    # 合併編號附號
             END RECORD,
        l_fci19      LIKE fci_file.fci19,
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
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690113
 
 
   CALL p810_tm(0,0)                            # 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
END MAIN
 
FUNCTION p810_tm(p_row,p_col)
   DEFINE   p_row,p_col   LIKE type_file.num5,         #No.FUN-680070 SMALLINT
            l_flag        LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
            l_i           LIKE type_file.num5         #No.FUN-680070 SMALLINT
#       l_time            LIKE type_file.chr8            #No.FUN-6A0069
 
 
   LET p_row = 3 LET p_col = 2
   OPEN WINDOW p810_w AT p_row,p_col WITH FORM "afa/42f/afap810" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
   CALL cl_opmsg('z')
   WHILE TRUE
      IF s_shut(0) THEN
         RETURN
      END IF
      CLEAR FORM 
      CALL g_fci.clear()
      INITIALIZE g_fch.* TO NULL                   # Default condition
 
      INPUT BY NAME g_fch.* WITHOUT DEFAULTS 
 
       ON ACTION locale
#            CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
             LET g_action_choice = "locale"
             EXIT INPUT     
 
         AFTER FIELD fch01
            IF cl_null(g_fch.fch01) THEN
               NEXT FIELD fch01
            END IF
            SELECT fch02,fch05,fch06,fch07,fch08,fch09
              INTO g_fch.fch02,g_fch.fch05,g_fch.fch06,g_fch.fch07,g_fch.fch08,g_fch.fch09
              FROM fch_file 
             WHERE fch01 = g_fch.fch01 AND fchconf IN ('y','Y')
            IF STATUS THEN
#              CALL cl_err('sel fch',STATUS,1)   #No.FUN-660136
               CALL cl_err3("sel","fch_file",g_fch.fch01,"",STATUS,"","sel fch",1)   #No.FUN-660136
               NEXT FIELD fch01
            END IF
            #No.FUN-9A0024--begin   
            #DISPLAY BY NAME g_fch.*  
            DISPLAY BY NAME g_fch.fch01,g_fch.fch02,g_fch.fch05,g_fch.fch06,
            g_fch.fch07,g_fch.fch08,g_fch.fch09
            #No.FUN-9A0024--end   
            CALL p810_show()
 
         AFTER FIELD fch02
            IF cl_null(g_fch.fch02) THEN
               NEXT FIELD fch02 
            END IF
         
         AFTER FIELD fch05
            IF cl_null(g_fch.fch05) THEN
               NEXT FIELD fch05 
            END IF
#No.TQC-770080--begin                                                                                                               
         AFTER FIELD fch08                                                                                                          
            IF NOT cl_null(g_fch.fch08) THEN                                                                                        
               IF g_fch.fch08 <0 THEN                                                                                               
                  LET g_fch.fch08 =0                                                                                                
                  CALL cl_err('','asf-108',1)
                  NEXT FIELD fch08                                                                                                  
               END IF                                                                                                               
            END IF                                                                                                                  
#No.TQC-770080--end 
 
#TQC-980037 --begin--
         AFTER FIELD fch09
           IF NOT cl_null(g_fch.fch09) THEN
              IF g_fch.fch09 < 0 THEN 
                 CALL cl_err('','aim-223',0)
                 NEXT FIELD fch09
              END IF 
           END IF 
#TQC-980037 --end--
         
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(fch01) #申請單號
#              CALL q_fch1(7,3,g_fch.fch01,g_fch.fch02) 
#              RETURNING g_fch.fch01,g_fch.fch02,g_fch.fch05,g_fch.fch06,
#                        g_fch.fch07,g_fch.fch08,g_fch.fch09
#              CALL FGL_DIALOG_SETBUFFER( g_fch.fch01 )
#              CALL FGL_DIALOG_SETBUFFER( g_fch.fch02 )
#              CALL FGL_DIALOG_SETBUFFER( g_fch.fch05 )
#              CALL FGL_DIALOG_SETBUFFER( g_fch.fch06 )
#              CALL FGL_DIALOG_SETBUFFER( # g_fch.fch07 )
#              CALL FGL_DIALOG_SETBUFFER( g_fch.fch08 )
#              CALL FGL_DIALOG_SETBUFFER( g_fch.fch09 )
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_fch1"
               LET g_qryparam.default1 = g_fch.fch01
               CALL cl_create_qry() RETURNING g_fch.fch01,g_fch.fch02,g_fch.fch05
#               CALL FGL_DIALOG_SETBUFFER( g_fch.fch01 )
#               CALL FGL_DIALOG_SETBUFFER( g_fch.fch02 )
#               CALL FGL_DIALOG_SETBUFFER( g_fch.fch05 )
               SELECT fch06,fch07,fch08,fch09
                 INTO g_fch.fch06,g_fch.fch07,g_fch.fch08,g_fch.fch09
                 FROM fch_file WHERE fch01 = g_fch.fch01
               DISPLAY g_fch.fch01,g_fch.fch02,g_fch.fch05,g_fch.fch06,
                       g_fch.fch07,g_fch.fch08,g_fch.fch09
                    TO fch01,fch02,fch05,fch06,fch07,fch08,fch09
                
                 NEXT FIELD fch01
              OTHERWISE EXIT CASE
           END CASE
      
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
 
      
         ON ACTION exit                            #加離開功能
            LET INT_FLAG = 1
            EXIT INPUT
 
      END INPUT
 
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
      IF INT_FLAG THEN 
         LET INT_FLAG = 0  
         CLOSE WINDOW p810_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM 
      END IF
      UPDATE fch_file SET fch06=g_fch.fch06, fch07=g_fch.fch07,
                          fch08=g_fch.fch08, fch09=g_fch.fch09
       WHERE fch01 = g_fch.fch01
      LET g_success='Y'
      LET l_exit_sw = 'N'
      IF l_exit_sw = 'n' THEN
         CALL cl_end(0,0)
      END IF
      CALL p810_b()
##No.2896 modify 1998/12/07
      LET l_flag = 'N'
      LET g_cnt = ARR_COUNT()
      FOR l_i = 1 TO  g_cnt
         IF g_fci[l_i].sure = 'Y' THEN
            LET l_flag = 'Y'
            EXIT FOR
         END IF
      END FOR
     #display 'l_flag:',l_flag   #CHI-A70049 mark   
      IF l_flag = 'Y' THEN
         UPDATE fch_file SET fch06=g_fch.fch06, fch07=g_fch.fch07,
                             fch08=g_fch.fch08, fch09=g_fch.fch09
          WHERE fch01 = g_fch.fch01
      ELSE
         UPDATE fch_file SET fch06=NULL, fch07=NULL,
                             fch08=0, fch09=0
          WHERE fch01 = g_fch.fch01
        #display 'upd null'      #CHI-A70049 mark
      END IF
##------------------------------------
   END WHILE
 
   ERROR ""
   CLOSE WINDOW p810_w
END FUNCTION
 
FUNCTION p810_show()
    CALL p810_b_fill(1=1) 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION p810_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(300)
 
   LET g_sql=
        "SELECT ' ',fci02,fci03,fci031,fci05,fci15 ",
         " FROM fci_file",
        " WHERE fci01 ='", g_fch.fch01,"'",
        "   AND (fci19 IN ('4','5') OR fci19 = '2') ",
         "  AND (fci07 = '' OR fci07 IS NULL) ",
        " ORDER BY 2"
   #DISPLAY 'g_sql:',g_sql                 #CHI-A70049 mark
    PREPARE p810_pb FROM g_sql
    DECLARE fci_curs                       #SCROLL CURSOR
        CURSOR FOR p810_pb
 
    CALL g_fci.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH fci_curs INTO g_fci[g_cnt].*   #單身 ARRAY 填充
        SELECT fci19 INTO l_fci19 FROM fci_file  
         WHERE fci01  = g_fch.fch01 AND fci03 = g_fci[g_cnt].fci03
           AND fci031 = g_fci[g_cnt].fci031
       #IF l_fci19 = '4' THEN LET g_fci[g_cnt].sure = 'Y' END IF 
        IF l_fci19 MATCHES '[124]' THEN LET g_fci[g_cnt].sure = 'Y'
        ELSE LET g_fci[g_cnt].sure = 'N' END IF 
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_fci.deleteElement(g_cnt)
    LET g_rec_b = g_cnt -1 
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
END FUNCTION
 
FUNCTION p810_b()
DEFINE     
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT       #No.FUN-680070 SMALLINT
    l_row,l_col     LIKE type_file.num5,                #分段輸入之行,列數       #No.FUN-680070 SMALLINT
    l_n,l_cnt       LIKE type_file.num5,                #檢查重複用       #No.FUN-680070 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否       #No.FUN-680070 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態       #No.FUN-680070 VARCHAR(1)
    g_cmd           LIKE type_file.chr1000,       #No.FUN-680070 VARCHAR(100)
    l_flag          LIKE type_file.num10,        #No.FUN-680070 INTEGER
    l_allow_insert  LIKE type_file.num5,                #可新增否       #No.FUN-680070 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否       #No.FUN-680070 SMALLINT
 
    LET g_action_choice = ""
 
    IF g_fch.fch01 IS NULL THEN RETURN END IF
 
    LET g_forupd_sql = 
    "SELECT ' ',fci02,fci03,fci031,fci05,fci15 ",
    "  FROM fci_file ",
    " WHERE fci01= ? ",
    "   AND (fci19 IN ('4','5') OR fci19 = '2') ",
    "   AND (fci07='' OR fci07 IS NULL) ",
    "   AND fci03 = ? ",
    "   AND fci031= ? ",
    "   FOR UPDATE "
   #DISPLAY g_forupd_sql               #CHI-A70049 mark
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE p810_bcl CURSOR FROM g_forupd_sql # LOCK CURSOR
 
    LET l_ac_t =  0
        INPUT ARRAY g_fci WITHOUT DEFAULTS FROM s_fci.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)
 
      #  BEFORE INPUT
      #     CALL fgl_set_arr_curr(l_ac)
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()       #目前筆數
           #LET g_fci_t.* = g_fci[l_ac].*  #BACKUP
            LET l_lock_sw = 'N'                   #DEFAULT
            LET l_n  = ARR_COUNT()                #目前的array共有幾筆
            BEGIN WORK
 
            IF g_rec_b >= l_ac THEN
                LET p_cmd='u'
                LET g_fci_t.* = g_fci[l_ac].*  #BACKUP
                OPEN p810_bcl USING g_fch.fch01,g_fci_t.fci03,g_fci_t.fci031
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_fci[l_ac].fci02,SQLCA.sqlcode,1)  
                   LET l_lock_sw = "Y"
                ELSE
                   FETCH p810_bcl INTO g_fci[l_ac].* 
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_fci[l_ac].fci02,SQLCA.sqlcode,1)   
                       LET l_lock_sw = "Y"
                   END IF
                END IF
                IF cl_null(g_fci[l_ac].sure) THEN
                   LET g_fci[l_ac].sure = g_fci_t.sure 
                END IF 
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF 
           #NEXT FIELD sure 
 
          AFTER ROW 
          LET l_ac = ARR_CURR()
          LET l_ac_t = l_ac
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd='u' THEN
                LET g_fci[l_ac].* = g_fci_t.*
             END IF
             CLOSE p810_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
         #LET g_fci_t.* = g_fci[l_ac].*
          CLOSE p810_bcl
          COMMIT WORK
 
        ON ACTION accept
          FOR l_ac = 1 TO g_rec_b 
            IF g_fci[l_ac].sure = 'N' THEN 
                # 5.選擇「N」者,
                #   ぇ更新對應免稅單身檔之狀態碼為「5.免稅刪除」
                UPDATE fci_file SET fci19 = '5'
                 WHERE fci01 = g_fch.fch01 
                   AND fci03 = g_fci[l_ac].fci03
                   AND fci031 = g_fci[l_ac].fci031 
                #   え更新對應資產主檔之免稅碼[faj40]為「4.免稅刪除」
                UPDATE faj_file SET faj40 = '5' 
                 WHERE faj02 = g_fci[l_ac].fci03
                   AND faj022 = g_fci[l_ac].fci031 
                #   ぉ同時更新合併編號為此財產編號之狀態碼為「3.免稅刪除」
                UPDATE fci_file SET fci19 = '5'
                 WHERE fci01 = g_fch.fch01 
                   AND fci07 = g_fci[l_ac].fci03
                   AND fci071 = g_fci[l_ac].fci031 
                DECLARE p800_bc3 CURSOR  FOR      # LOCK CURSOR
                SELECT fci01,fci03,fci031,fci07,fci071 
                  FROM fci_file 
                 WHERE fci01 = g_fch.fch01
                   AND fci07 = g_fci[l_ac].fci03  
                   AND fci071= g_fci[l_ac].fci031  
                FOREACH p800_bc3 INTO l_fci.*
                   IF SQLCA.sqlcode != 0 THEN 
                      CALL cl_err('foreach:',SQLCA.sqlcode,1)   
                      EXIT FOREACH 
                   END IF
                   UPDATE fci_file SET fci19 = '5' 
                    WHERE fci01 = g_fch.fch01
                      AND fci03 = l_fci.fci03
                      AND fci031 = l_fci.fci031
                END FOREACH 
                #   お更新合併編號為此財產編號之資產主檔
                #     之免稅碼[faj40]為「4.免稅刪除」
                DECLARE p800_bcn CURSOR  FOR      # LOCK CURSOR
                SELECT fci01,fci03,fci031,fci07,fci071 
                  FROM fci_file 
                 WHERE fci01 = g_fch.fch01
                   AND fci07 = g_fci[l_ac].fci03  
                   AND fci071= g_fci[l_ac].fci031  
                FOREACH p800_bcn INTO l_fci.*
                   IF SQLCA.sqlcode != 0 THEN 
                      CALL cl_err('foreach:',SQLCA.sqlcode,1)  
                      EXIT FOREACH 
                   END IF
                   UPDATE faj_file SET faj40 = '5' 
                    WHERE faj02 = l_fci.fci03  
                      AND faj022= l_fci.fci031  
                END FOREACH 
            ELSE 
                # 4.選擇「Y」者,
                #   ぇ更新對應免稅單身檔之狀態碼為「4.免稅已核准」
                UPDATE fci_file SET fci19 = '4'
                 WHERE fci01 = g_fch.fch01 
                   AND fci03 = g_fci[l_ac].fci03
                   AND fci031 = g_fci[l_ac].fci031 
## No:2461 modify 1998/09/30 -----------------
                #   え更新對應資產主檔之免稅碼[faj40]為「3.已免稅」
                UPDATE faj_file SET faj40 = '3' 
                 WHERE faj02 = g_fci[l_ac].fci03
                   AND faj022 = g_fci[l_ac].fci031 
## ---
                #   え同時更新合併編號為此財產編號之狀態碼為「4.免稅已核准」
                DECLARE p800_bcy CURSOR  FOR      # LOCK CURSOR
                SELECT fci01,fci03,fci031,fci07,fci071 
                  FROM fci_file 
                 WHERE fci01 = g_fch.fch01
                   AND fci07 = g_fci[l_ac].fci03  
                   AND fci071= g_fci[l_ac].fci031  
                FOREACH p800_bcy INTO l_fci.*
                   IF SQLCA.sqlcode != 0 THEN 
                      CALL cl_err('foreach:',SQLCA.sqlcode,1)   
                      EXIT FOREACH 
                   END IF
                   UPDATE fci_file SET fci19 = '4'
                    WHERE fci01 = g_fch.fch01 
                      AND fci03 = l_fci.fci03
                      AND fci031 = l_fci.fci031 
## No:2461 modify 1998/09/30 -----------------
                   UPDATE faj_file SET faj40 = '3'
                    WHERE faj02 = l_fci.fci03
                      AND faj022= l_fci.fci031
## ----
                END FOREACH 
            END IF 
           END FOR
            CALL cl_end(0,0) 
            EXIT INPUT
 
         #No.MOD-490193 add
        ON ACTION cancel
          FOR l_ac = 1 TO g_rec_b 
            LET g_fci[l_ac].sure = 'N' 
          END FOR
          LET INT_FLAG = 0
          EXIT INPUT
        #End 
 
        # ON ACTION select_cancel
        #    IF g_fci[l_ac].sure = 'Y' THEN 
        #       LET g_fci[l_ac].sure = 'N'
        #    ELSE
        #       LET g_fci[l_ac].sure = 'Y'
        #    END IF 
        #    NEXT FIELD sure
 
          ON ACTION seleall
             CALL p810_t()
 
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
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
       EXIT PROGRAM  
    END IF
 
    CLOSE p810_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION p810_t()
 DEFINE i LIKE type_file.num5         #No.FUN-680070 SMALLINT
 FOR i = ARR_CURR() TO ARR_COUNT() 
     LET g_fci[i].sure = 'Y'
     # 4.選擇「Y」者,
     #   ぇ更新對應免稅單身檔之狀態碼為「4.免稅已核准」
   # UPDATE fci_file SET fci19 = '4'
   #  WHERE fci01 = g_fch.fch01 
   #    AND fci03 = g_fci[i].fci03
   #    AND fci031 = g_fci[i].fci031 
     #   え同時更新合併編號為此財產編號之狀態碼為「4.免稅已核准」
   # DECLARE p800_bct CURSOR  FOR      # LOCK CURSOR
   # SELECT fci01,fci03,fci031,fci07,fci071 
   #   FROM fci_file 
   #  WHERE fci01 = g_fch.fch01
   #    AND fci07 = g_fci[i].fci03  
   #    AND fci071= g_fci[i].fci031  
   # FOREACH p800_bct INTO l_fci.*
   #    IF SQLCA.sqlcode != 0 THEN 
   #       CALL cl_err('foreach:',SQLCA.sqlcode,1)
   #       EXIT FOREACH 
   #    END IF
   #    UPDATE fci_file SET fci19 = '4'
   #     WHERE fci01 = g_fch.fch01 
   #       AND fci03 = l_fci.fci03
   #       AND fci031 = l_fci.fci031 
   # END FOREACH 
 END FOR 
#CALL p810_show()
END FUNCTION
 
