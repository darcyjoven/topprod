# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: afap710.4gl
# Descriptions...: 國稅局核准作業  
# Date & Author..: 96/06/04 By Star
# Modify.........: No.MOD-480444 04/08/20 By echo 修改單身UPDATE
# Modify.........: No.MOD-480620 04/09/01 By Nicola 修改輸入單號的錯誤訊息
# Modify.........: No.MOD-560011 05/07/27 By Smapmin 不用管理局核準,國稅局即可進行核準動作
# Modify.........: No.MOD-580380 05/10/07 By Smapmin SQL條件修改
# Modify.........: No.FUN-660136 06/06/20 By Ice cl_err --> cl_err3
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-690113 06/10/13 By yjkhero cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.TQC-6C0208 06/12/30 By wujie   UPDATE faj42 SQL條件修改 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9A0024 09/10/10 By destiny display xxx.*改為display對應欄位
# Modify.........: No:CHI-A70049 10/08/27 By Pengu  將多餘的DISPLAY程式mark
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_fcb RECORD
             fcb01  LIKE fcb_file.fcb01,   #申請編號
             fcb02  LIKE fcb_file.fcb02,   #申請日期
             fcb03  LIKE fcb_file.fcb03,   #管理局核准日期
             fcb04  LIKE fcb_file.fcb04,   #管理局核准文號
             fcb05  LIKE fcb_file.fcb05,   #國稅局核准日期
             fcb06  LIKE fcb_file.fcb06    #國稅局核准文號
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
        g_argv1       LIKE fcc_file.fcc01,     # 申請編號 
        l_fcc20       LIKE fcc_file.fcc20,
         g_wc,g_wc2,g_sql    string,  #No.FUN-580092 HCN
        g_cmd            LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(30)
        g_rec_b      LIKE type_file.num5,         #No.FUN-680070 SMALLINT
        l_exit_sw    LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
        l_ac         LIKE type_file.num5         #No.FUN-680070 SMALLINT
DEFINE  g_cnt           LIKE type_file.num10           #No.FUN-680070 INTEGER
DEFINE  g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
 
 
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
 
 
   LET g_argv1=ARG_VAL(1)
   CALL p710_tm(4,2)                            # 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
END MAIN
 
FUNCTION p710_tm(p_row,p_col)
   DEFINE   p_row,p_col   LIKE type_file.num5         #No.FUN-680070 SMALLINT
#       l_time            LIKE type_file.chr8            #No.FUN-6A0069
 
 
   LET p_row = 3 LET p_col = 2
   OPEN WINDOW p710_w AT p_row,p_col WITH FORM "afa/42f/afap710" 
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
      ELSE 
         INITIALIZE g_fcb.* TO NULL                   # Default condition
      END IF 
      CALL cl_set_head_visible("","YES")              #No.FUN-6B0029
 
      INPUT BY NAME g_fcb.* WITHOUT DEFAULTS 
 
         AFTER FIELD fcb01
           IF NOT cl_null(g_fcb.fcb01) THEN
            SELECT fcb02,fcb03,fcb04,fcb05,fcb06
              INTO g_fcb.fcb02,g_fcb.fcb03,g_fcb.fcb04,g_fcb.fcb05,g_fcb.fcb06
              FROM fcb_file 
             WHERE fcb01 = g_fcb.fcb01 AND fcbconf IN ('y','Y')
##Modify:2633 
       #   AND (fcb06 = ' '  OR fcb06 IS NULL)
            IF SQLCA.sqlcode THEN 
#              CALL cl_err('sel fcb',STATUS,1)     #No.FUN-660136
               CALL cl_err3("sel","fcb_file",g_fcb.fcb01,"",STATUS,"","sel fcb",1)   #No.FUN-660136
               NEXT FIELD fcb01
            END IF
 #MOD-560011
{
            IF cl_null(g_fcb.fcb03) OR cl_null(g_fcb.fcb04) THEN
                CALL cl_err('','afa-334',1) NEXT FIELD fcb01     #No.MOD-480620 
            END IF 
}
 #END MOD-560011
            #No.FUN-9A0024--begin   
            #DISPLAY BY NAME g_fcb.*  
            DISPLAY BY NAME g_fcb.fcb01,g_fcb.fcb02,g_fcb.fcb03,g_fcb.fcb04,
                            g_fcb.fcb05,g_fcb.fcb06 
            #No.FUN-9A0024--end      
            CALL p710_show()
          END IF
 
         AFTER FIELD fcb05
          IF NOT cl_null(g_fcb.fcb05) THEN
            IF g_fcb.fcb05 < g_fcb.fcb03 THEN 
               CALL cl_err(g_fcb.fcb03,'afa-323',0)
               NEXT FIELD fcb05
            END IF
          END IF
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(fcb01) #申請單號
#                 CALL q_fcb(7,3,'2','1')
#                 RETURNING g_fcb.fcb01,g_fcb.fcb02,g_fcb.fcb03,g_fcb.fcb04
#                 CALL FGL_DIALOG_SETBUFFER( g_fcb.fcb01 )
#                 CALL FGL_DIALOG_SETBUFFER( g_fcb.fcb02 )
#                 CALL FGL_DIALOG_SETBUFFER( g_fcb.fcb03 )
#                 CALL FGL_DIALOG_SETBUFFER( g_fcb.fcb04 )
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_fcb02"
                  LET g_qryparam.default1 = g_fcb.fcb01
                  CALL cl_create_qry() RETURNING g_fcb.fcb01,g_fcb.fcb03,g_fcb.fcb04
#                  CALL FGL_DIALOG_SETBUFFER( g_fcb.fcb01 )
#                  CALL FGL_DIALOG_SETBUFFER( g_fcb.fcb03 )
#                  CALL FGL_DIALOG_SETBUFFER( g_fcb.fcb04 )
                 #SELECT fcb02 INTO g_fcb02 FROM fcb_file
                 # WHERE fcbconf = 'Y' AND fcb01 = g_fcj01 AND fcb03 = g_fcb03
                 #   AND fcb04 = g_fcb04
                 #No.FUN-9A0024--begin   
                 #DISPLAY BY NAME g_fcb.*  
                 DISPLAY BY NAME g_fcb.fcb01,g_fcb.fcb02,g_fcb.fcb03,g_fcb.fcb04,
                 g_fcb.fcb05,g_fcb.fcb06  
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
 
      END INPUT
 
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN 
         LET INT_FLAG = 0 
         CLOSE WINDOW p710_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
      END IF
      LET g_success='Y'
      LET l_exit_sw = 'N'
      IF l_exit_sw = 'n' THEN
         CALL cl_end(0,0)
      END IF
 
      CALL p710_b()
      IF INT_FLAG THEN
         LET INT_FLAG = 0 
         CLOSE WINDOW p710_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
      END IF
      UPDATE fcb_file SET fcb05=g_fcb.fcb05, fcb06=g_fcb.fcb06 
       WHERE fcb01 = g_fcb.fcb01
   END WHILE
 
   ERROR ""
   CLOSE WINDOW p710_w
END FUNCTION
 
FUNCTION p710_show()
    CALL p710_b_fill(1=1) 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION p710_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(1000)
 
    LET g_sql =
         "SELECT ' ',fcc02,fcc03,fcc031,fcc06,fcc13 FROM fcc_file ",
         "WHERE fcc01 ='",g_fcb.fcb01,"'",
#         "  AND (fcc20 MATCHES '[356]') ",   #MOD-580380
         "  AND (fcc20 IN ('2','3','4','5','6')) ",   #MOD-580380
         "  AND fcc04 != '0'",
         " ORDER BY 2"              
 
#display 'g_sql:',g_sql        #CHI-A70049 mark
    PREPARE p710_pb FROM g_sql
    DECLARE fcc_curs                       #SCROLL CURSOR
        CURSOR FOR p710_pb
 
    CALL g_fcc.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH fcc_curs INTO g_fcc[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN 
           CALL cl_err('fcc_curs',SQLCA.sqlcode,0)   
           EXIT FOREACH
        END IF
    #display 'foreach'         #CHI-A70049 mark
        SELECT fcc20 INTO l_fcc20 FROM fcc_file  
         WHERE fcc01  = g_fcb.fcb01 AND fcc02 = g_fcc[g_cnt].fcc02
        #WHERE fcc01  = g_fcb.fcb01 AND fcc03 = g_fcc[g_cnt].fcc03
        #  AND fcc031 = g_fcc[g_cnt].fcc031
        IF SQLCA.sqlcode THEN LET l_fcc20= ' ' END IF  
        CASE 
           WHEN l_fcc20 = '5'  LET g_fcc[g_cnt].sure = 'Y'
           WHEN l_fcc20 = '6'  LET g_fcc[g_cnt].sure = 'N'
           OTHERWISE  LET g_fcc[g_cnt].sure = ' '
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
END FUNCTION
 
FUNCTION p710_b()
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
    "   AND (fcc20 = ? OR fcc20 = ? OR fcc20 = ?) ",
    "   AND fcc04 != ? ",
    "   AND fcc03  = ? ",
    "   AND fcc031 = ? ",
    "   FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE p710_bcl CURSOR FROM g_forupd_sql  # LOCK CURSOR
 
    LET l_ac_t =  0
   # LET l_allow_insert = cl_detail_input_auth("insert")
   # LET l_allow_delete = cl_detail_input_auth("delete")
 
        INPUT ARRAY g_fcc WITHOUT DEFAULTS FROM s_fcc.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=FALSE ,DELETE ROW=FALSE,APPEND ROW=FALSE)
 
  #      BEFORE INPUT
  #         CALL fgl_set_arr_curr(l_ac)
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()       #目前筆數
           #LET g_fcc_t.* = g_fcc[l_ac].*  #BACKUP
            LET l_lock_sw = 'N'                   #DEFAULT
            LET l_n  = ARR_COUNT()                #目前的array共有幾筆
            BEGIN WORK
 
            IF g_rec_b >= l_ac THEN
                LET p_cmd='u'
                LET g_fcc_t.* = g_fcc[l_ac].*  #BACKUP
                OPEN p710_bcl USING g_fcb.fcb01,'3','5','6','0',g_fcc_t.fcc03,g_fcc_t.fcc031
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_fcc[l_ac].fcc02,SQLCA.sqlcode,1)  
                   LET l_lock_sw = "Y"
                ELSE
                  # FETCH p710_bcl INTO g_fcc[l_ac].* 
                   FOREACH p710_bcl INTO g_fcc[l_ac].* 
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_fcc[l_ac].fcc02,SQLCA.sqlcode,1)   
                       LET l_lock_sw = "Y"
                   END IF
                   END FOREACH
                END IF
                IF cl_null(g_fcc[l_ac].sure) THEN
                   LET g_fcc[l_ac].sure = g_fcc_t.sure 
                END IF 
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF 
           #NEXT FIELD sure 
 
   #-----若國稅局核准，單身成本可修改(modi in 98/10/13)
   #    AFTER FIELD sure
   #       IF NOT cl_null(g_fcc[l_ac].sure) THEN
   #          IF g_fcc[l_ac].sure NOT MATCHES '[YN]' THEN 
   #             NEXT FIELD sure 
   #          END IF
   #       END IF
 
 
        AFTER FIELD fcc13
           IF cl_null(g_fcc[l_ac].fcc13) THEN
              LET g_fcc[l_ac].fcc13 = g_fcc_t.fcc13
              DISPLAY g_fcc[l_ac].fcc13 TO fcc13
           END IF
 
        AFTER ROW 
          LET l_ac = ARR_CURR()
          LET l_ac_t = l_ac
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             # LET INT_FLAG = 0                 #MOD-480444
             IF p_cmd='u' THEN
                LET g_fcc[l_ac].* = g_fcc_t.*
             END IF
             CLOSE p710_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
         #LET g_fcc_t.* = g_fcc[l_ac].*
          CLOSE p710_bcl
          COMMIT WORK
 
 
         ON ACTION accept
          FOR l_ac = 1 TO g_rec_b 
            IF g_fcc[l_ac].sure = 'N' THEN 
                #---->更新對應抵減單身檔之狀態碼為「6.國稅局刪除」
                #     同時更新項次相同之財產編號之狀態碼為「6.國稅局刪除」
                UPDATE fcc_file SET fcc20 = '6'
                 WHERE fcc01 = g_fcb.fcb01 
                   AND fcc02 = g_fcc[l_ac].fcc02
                #---->更新對應資產主檔之抵減碼[faj42]為「6.國稅局刪除」
                #     更新合併編號為此財產編號之資產主檔之免稅碼[faj40]
                #     為「6.國稅局刪除」
                DECLARE p700_bc3 CURSOR  FOR      # LOCK CURSOR
                 SELECT fcc01,fcc03,fcc031
                   FROM fcc_file 
                  WHERE fcc01 = g_fcb.fcb01
                    AND fcc02 = g_fcc[l_ac].fcc02  
                FOREACH p700_bc3 INTO l_fcc.*
                   IF SQLCA.sqlcode != 0 THEN 
                      CALL cl_err('foreach:',SQLCA.sqlcode,1)  
                      EXIT FOREACH 
                   END IF
                   UPDATE faj_file SET faj42 = '6',
#No.TQC-6C0208--begin                                                                                                               
#                                      faj84 = ' ',                                                                                 
#                                      faj85 = ' '                                                                                  
                                       faj84 = '',                                                                                  
                                       faj85 = ''                                                                                   
#No.TQC-6C0208--end 
                    WHERE faj02 = l_fcc.fcc03 AND faj022= l_fcc.fcc031  
                   IF SQLCA.sqlcode THEN 
                   END IF
                END FOREACH 
            END IF
            IF g_fcc[l_ac].sure = 'Y' THEN 
                #---->更新對應抵減單身檔之狀態碼為「5.國稅局已核准」
                #     同時更新項次相同之財產編號之狀態碼為「5.國稅局已核准」
             #  UPDATE fcc_file SET fcc20 = '5'
                UPDATE fcc_file SET fcc20='5',fcc13=g_fcc[l_ac].fcc13
                 WHERE fcc01 = g_fcb.fcb01 AND fcc02 = g_fcc[l_ac].fcc02
                  IF SQLCA.sqlcode THEN
                     LET g_success = 'N' RETURN 
                  END IF
                #---->更新對應資產主檔之抵減碼[faj42]為「5.已核准 」
                #     同時更新項次相同之資產主檔之狀態碼為「5.已核准 」
                DECLARE p700_bcy CURSOR  FOR      # LOCK CURSOR
                SELECT fcc01,fcc03,fcc031 FROM fcc_file 
                 WHERE fcc01 = g_fcb.fcb01
                   AND fcc02 = g_fcc[l_ac].fcc02  
                FOREACH p700_bcy INTO l_fcc.*
                   IF SQLCA.sqlcode != 0 THEN 
                      CALL cl_err('foreach:',SQLCA.sqlcode,1)   
                      EXIT FOREACH 
                   END IF
                   UPDATE faj_file SET faj42 = '5',
                                       faj84 = g_fcb.fcb05,
                                       faj85 = g_fcb.fcb06
                       WHERE faj02 = l_fcc.fcc03 AND faj022 = l_fcc.fcc031
                  IF SQLCA.sqlcode THEN LET g_success = 'N' RETURN END IF
                END FOREACH 
            END IF 
          END FOR
          CALL cl_end(0,0)
           ACCEPT INPUT                  #MOD-480444
       #    EXIT INPUT                   #MOD-480444
 
  
        ON ACTION seleall  
             CALL p710_t()
 
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
 
    IF INT_FLAG THEN 
        LET INT_FLAG = 0 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
        EXIT PROGRAM 
           
    END IF
  #  CLOSE p710_bcl
  # COMMIT WORK 
END FUNCTION
 
FUNCTION p710_t()
 DEFINE l_ac LIKE type_file.num5         #No.FUN-680070 SMALLINT
 
 FOR l_ac = 1 TO g_rec_b 
     LET g_fcc[l_ac].sure = 'Y'
     #---->更新對應抵減單身檔之狀態碼為「5.國稅局已核准」
     #     同時更新項次相同之財產編號之狀態碼為「5.國稅局已核准」
#    UPDATE fcc_file SET fcc20 = '5'
#     WHERE fcc01 = g_fcb.fcb01 AND fcc02 = g_fcc[l_ac].fcc02
#      IF SQLCA.sqlcode THEN
#         LET g_success = 'N' RETURN 
#      END IF
     #---->更新對應資產主檔之抵減碼[faj42]為「5.已核准 」
     #     同時更新項次相同之資產主檔之狀態碼為「5.已核准 」
#    DECLARE p700_bcy2 CURSOR  FOR      # LOCK CURSOR
#    SELECT fcc01,fcc03,fcc031 FROM fcc_file 
#     WHERE fcc01 = g_fcb.fcb01
#       AND fcc02 = g_fcc[l_ac].fcc02  
#    FOREACH p700_bcy2 INTO l_fcc.*
#       IF SQLCA.sqlcode != 0 THEN 
#          CALL cl_err('foreach:',SQLCA.sqlcode,1)
#          EXIT FOREACH 
#       END IF
#       UPDATE faj_file SET faj42 = '5',
#                           faj84 = g_fcb.fcb05,
#                           faj85 = g_fcb.fcb06
#           WHERE faj02 = l_fcc.fcc03 AND faj022 = l_fcc.fcc031
#      IF SQLCA.sqlcode THEN LET g_success = 'N' RETURN END IF
#    END FOREACH 
 END FOR 
# CALL p710_show()
END FUNCTION
