# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: apmp610.4gl
# Descriptions...: 委外發放作業
# Date & Author..: 94/08/03 By Danny
# Modify.........: 94/08/17 By Jackson
# Modify.........: 99/04/16 By Carol:modify s_pmmsta()
# Modify.........: No.MOD-490350 04/09/20 By Carol --> g_cnt 改為 g_rec_b
# Modify.........: No.FUN-4B0025 04/11/05 By Smapmin ARRAY轉為EXCEL檔
# Modify.........: No.MOD-4B0190 04/11/18 By Mandy 新增INSERT INTO pmh_file
# Modify         : No.MOD-530885 05/03/31 by alexlin VARCHAR->CHAR
# Modify.........: No.FUN-610018 06/01/09 By ice 採購含稅單價功能調整
# Modify         : No.MOD-630039 06/03/14 by Cliare 委外採購發出時, 不更新已結單的單身
# Modify.........: No.FUN-660129 06/06/19 By Wujie cl_err --> cl_err3
# Modify.........: No.FUN-670041 06/08/10 By Pengu 將sma29 [虛擬產品結構展開與否] 改為 no use
# Modify.........: No.FUN-670099 06/08/28 By Nicola 價格管理修改
# Modify.........: No.FUN-680136 06/09/13 By Jackho 欄位類型修改
# Modify.........: No.TQC-690085 06/11/16 By pengu  採購單發出時，若單價為0則單價不回寫pmh_file。
# Modify.........: No.FUN-710030 07/01/22 By johnray 錯誤訊息匯總顯示修改
# Modify.........: No.MOD-760015 07/06/05 By claire sma843價格更新參數要考慮最近單價=0
# MOdify.........: No.CHI-790003 07/09/02 By Nicole 修正Insert Into pmh_file Error
# Modify.........: No.MOD-730044 07/09/18 By claire 需考慮採購單位與料件採購資料的採購單位換算
# Modify.........: No.MOD-850188 08/05/20 By Smapmin 修改更新pmh_file的條件
# Modify.........: No.MOD-870163 08/07/14 By Smapmin 工單走Run Card無法抓到pmh_file的資料
# Modify.........: No.FUN-870124 08/09/10 By jan l_pmn.pmn23賦" "
# Modify.........: No.MOD-910113 09/01/12 By Smapmin  因為委外工單調整所以此處也一并調整
# Modify.........: No.CHI-910021 09/02/01 By xiaofeizhu 有select bmd_file或select pmh_file的部份，全部加入有效無效碼="Y"的判斷
# Modify.........: No.FUN-930108 09/04/07 By zhaijie都要增加判斷此料件是否需AVL才檢查
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-960033 09/10/03 By chenmoyan 加pmh22為條件者，再加pmh23=''
# Modify.........: No.FUN-A60027 10/06/18 By vealxu 製造功能優化-平行制程（批量修改）
# Modify.........: No.FUN-A60076 10/06/29 By vealxu 平行制程
# Modify.........: No.FUN-A80102 10/09/17 By kim 將採購發出邏輯拆至_sub
# Modify.........: No.TQC-AB0208 10/11/29 By lixh1 增加成功失敗否提示
# Modify.........: No:FUN-B30211 11/03/30 By lixiang  加cl_used(g_prog,g_time,2)
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_pmm DYNAMIC ARRAY OF RECORD
            sure     LIKE type_file.chr1,     #No.FUN-680136 VARCHAR(1)   # 確定否
            pmm01    LIKE pmm_file.pmm01,     # 採購單號
            pmn41    LIKE pmn_file.pmn41,     # 工單編號
            pmm02    LIKE pmm_file.pmm02,     # 性質
            pmm09    LIKE pmm_file.pmm09,     # 廠商編號
            pmc03    LIKE pmc_file.pmc03,     # 廠商簡稱
            pmm25    LIKE imd_file.imd01      #No.FUN-680136 VARCHAR(10)  # 目前狀況
        END RECORD,
      g_pmn  DYNAMIC ARRAY OF RECORD
             pmn04  LIKE pmn_file.pmn04,      #料件編號
             pmn02  LIKE pmn_file.pmn04,      #項次
             pmn041 LIKE pmn_file.pmn04,      #工單單號
             sfb251 LIKE sfb_file.sfb251,     #預計發放日
             pmn20  LIKE pmn_file.pmn20,      #數量
             pmn07  LIKE pmn_file.pmn07       #單位
     END RECORD,
        g_argv1     LIKE pmm_file.pmm01,
         g_wc        string,  #No.FUN-580092 HCN
         g_sql       string,  #No.FUN-580092 HCN
        g_cmd       LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(60)
        l_sw        LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
        g_rec_b     LIKE type_file.num5,    #No.FUN-680136 SMALLINT
        l_ac,l_sl   LIKE type_file.num5     #No.FUN-680136 SMALLINT
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
   LET g_argv1=ARG_VAL(1)
   IF cl_null(g_argv1) THEN
      CALL p610_tm(0,0)
   ELSE
      LET g_success = 'Y'
      CALL p610sub_update(g_argv1,TRUE)  #FUN-A80102
      IF g_success = 'Y' THEN
         CALL p610sub_sfb(g_argv1)
      END IF
      CALL s_showmsg()       #No.FUN-710030
      IF g_success = 'Y' THEN
         CALL cl_cmmsg(1) COMMIT WORK
      ELSE
         CALL cl_rbmsg(1) ROLLBACK WORK
      END IF
   END IF

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION p610_tm(p_row,p_col)
   DEFINE
      p_row,p_col   LIKE type_file.num5,    #No.FUN-680136 SMALLINT
      l_no,l_cnt    LIKE type_file.num5,    #No.FUN-680136 SMALLINT
      l_pmm04       LIKE pmm_file.pmm04,
      g_sta         LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
   DEFINE l_flag    LIKE type_file.chr1    #TQC-AB0208
    
   LET p_row = 2 LET p_col = 20
 
   OPEN WINDOW p610_w AT p_row,p_col WITH FORM "apm/42f/apmp610"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   WHILE TRUE
      IF s_shut(0) THEN RETURN END IF
      CLEAR FORM
      CALL g_pmm.clear()
      CALL g_pmn.clear()
      CALL cl_opmsg('q')
      ERROR ''
      CONSTRUCT g_wc ON pmm01,pmn41,pmm09
                FROM s_pmm[1].pmm01,s_pmm[1].pmn41,s_pmm[1].pmm09
 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
          ON ACTION CONTROLR
             CALL cl_show_req_fields()
 
          ON ACTION CONTROLG
 
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
          ON ACTION locale                    #genero
             LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
             EXIT CONSTRUCT
 
          ON ACTION exit              #加離開功能genero
             LET INT_FLAG = 1
             EXIT CONSTRUCT
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
      END CONSTRUCT
 
      IF g_action_choice = "locale" THEN  #genero
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         EXIT WHILE
      END IF
 
      #資料權限的檢查
      #Begin:FUN-980030
      #      IF g_priv2='4' THEN                           #只能使用自己的資料
      #        LET g_wc = g_wc clipped," AND pmmuser = '",g_user,"'"
      #      END IF
      #      IF g_priv3='4' THEN                           #只能使用相同群的資料
      #        LET g_wc = g_wc clipped," AND pmmgrup MATCHES '",g_grup CLIPPED,"*'"
      #      END IF
 
      #      IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
      #        LET g_wc = g_wc clipped," AND pmmgrup IN ",cl_chk_tgrup_list()
      #      END IF
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('pmmuser', 'pmmgrup')
      #End:FUN-980030
 
 
      LET g_sql="SELECT UNIQUE 'N',pmm01,pmn41,pmm02,pmm09,pmc03,pmm25",
                " FROM pmm_file,pmn_file,sfb_file, OUTER pmc_file",
                " WHERE pmm_file.pmm09=pmc_file.pmc01 AND pmm02='SUB' AND pmm25='1' ",
                "   AND pmm01=pmn01 AND pmn41=sfb01 AND sfb87!='X' ",
                "   AND pmn16<'6' ", #MOD-630039 不包括6,7,8(結案);9(作廢)
                "   AND ", g_wc CLIPPED,
                " ORDER BY pmm01"
      PREPARE p610_prepare FROM g_sql              # RUNTIME 編譯
      IF SQLCA.sqlcode THEN
         CALL cl_err('prepare: ',SQLCA.sqlcode,1)
         CONTINUE WHILE
      END IF
      DECLARE p610_cs CURSOR FOR p610_prepare
      IF SQLCA.sqlcode THEN
         CALL cl_err('declare: ',SQLCA.sqlcode,1)
         CONTINUE WHILE
      END IF
 
      CALL cl_opmsg('z')
      LET l_ac = 1
      LET g_rec_b = 0
      LET l_sw = 'y'
      FOREACH p610_cs INTO g_pmm[l_ac].*
         IF SQLCA.sqlcode THEN
            CALL cl_err('cannot foreach ',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         IF not cl_null(g_pmm[l_ac].pmm25) THEN
            CALL s_pmmsta('pmm',g_pmm[l_ac].pmm25,' ',' ')
                 RETURNING g_pmm[l_ac].pmm25
         END IF
         LET l_ac = l_ac + 1
      END FOREACH
      CALL g_pmm.deleteElement(l_ac)
 
      LET g_rec_b=l_ac - 1
 
      IF g_rec_b = 0 THEN
         CALL cl_err('','mfg3122',1)
         CONTINUE WHILE
      ELSE
         CALL p610_sure() RETURNING l_cnt         #確定否
         IF INT_FLAG THEN
            LET INT_FLAG = 0
            CONTINUE WHILE
         END IF
         IF l_cnt > 0 THEN
            IF cl_sure(10,10) THEN
                FOR l_no = 1 TO g_rec_b   #MOD-490350   g_cnt-> g_rec_b
                   LET g_success = 'Y'
                   IF g_pmm[l_no].sure = 'Y' THEN
                      SELECT pmm04 INTO l_pmm04 from pmm_file
                       WHERE pmm01 = g_pmm[l_no].pmm01
                      CALL p610sub_update(g_pmm[l_no].pmm01,TRUE)  #FUN-A80102
                      IF g_success = 'Y' THEN
                         CALL p610sub_sfb(g_pmm[l_no].pmm01)
                      END IF
                      CALL s_showmsg()       #No.FUN-710030
                      IF g_success = 'Y' THEN
                         CALL cl_cmmsg(1)
                         COMMIT WORK
                         CALL cl_end2(1) RETURNING l_flag   #TQC-AB0208
                      ELSE
                         CALL cl_rbmsg(1)
                         ROLLBACK WORK
                         CALL cl_end2(2) RETURNING l_flag   #TQC-AB0208
                      END IF
#TQC-AB0208 -------------------------Begin-----------------------------
                      IF l_flag THEN
                         CONTINUE WHILE
                      ELSE
                         EXIT WHILE
                      END IF
#TQC-AB0208 ------------------------End--------------------------------
                   END IF
                END FOR
            END IF
         END IF
      END IF
   END WHILE
   ERROR ""
   CLOSE WINDOW p610_w
 
END FUNCTION

FUNCTION p610_sure()
   DEFINE
      l_buf           LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(80)
      l_no            LIKE type_file.num5,    #No.FUN-680136 SMALLINT
      g_i             LIKE type_file.num5,    #No.FUN-680136 SMALLINT
      l_cnt           LIKE type_file.num5,    #所選擇筆數  #No.FUN-680136 SMALLINT
      l_allow_insert  LIKE type_file.num5,    #可新增否  #No.FUN-680136 SMALLINT
      l_allow_delete  LIKE type_file.num5     #No.FUN-680136 SMALLINT
 
   CALL cl_getmsg('mfg3076',g_lang) RETURNING l_buf
   MESSAGE l_buf CLIPPED
   CALL ui.Interface.refresh()
   LET l_cnt = 0
 
   DISPLAY ARRAY g_pmm TO s_pmm.* ATTRIBUTE(COUNT = g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
        EXIT DISPLAY
   END DISPLAY
 
   LET l_cnt = 0
   LET l_allow_insert = FALSE
   LET l_allow_delete = FALSE
 
   INPUT ARRAY g_pmm WITHOUT DEFAULTS FROM s_pmm.*
      ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
 
      AFTER FIELD sure
         IF NOT cl_null(g_pmm[l_ac].sure) THEN
            IF g_pmm[l_ac].sure NOT MATCHES "[YN]" THEN
               NEXT FIELD sure
            END IF
         END IF
         LET l_cnt  = 0
         FOR g_i =1 TO g_rec_b
            IF g_pmm[g_i].sure = 'Y' AND
               NOT cl_null(g_pmm[g_i].pmm01)  THEN
               LET l_cnt = l_cnt + 1
            END IF
         END FOR
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION select_all
         FOR g_i = 1 TO g_rec_b      #將所有的設為選擇
             LET g_pmm[g_i].sure="Y"
         END FOR
         LET l_cnt = g_rec_b
#        LET l_ac = ARR_CURR()
 
      ON ACTION cancel_all
         FOR g_i = 1 TO g_rec_b      #將所有的設為選擇
             LET g_pmm[g_i].sure="N"
         END FOR
         LET l_ac = ARR_CURR()
         LET l_cnt = 0
 
      ON ACTION exporttoexcel       #FUN-4B0025
         LET g_action_choice = 'exporttoexcel'
 
 
      AFTER ROW
        IF INT_FLAG THEN
           EXIT INPUT
        END IF
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
   RETURN l_cnt
END FUNCTION
 
FUNCTION p610_show(l_pmm01,l_pmm09,l_pmc03)
   DEFINE
      l_pmm01   LIKE pmm_file.pmm01,
      l_pmm09   LIKE pmm_file.pmm09,
      l_pmc03   LIKE pmc_file.pmc03,
      l_sql    LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(200)
      l_cnt    LIKE type_file.num5,    #No.FUN-680136 SMALLINT
      p_row,p_col LIKE type_file.num5    #No.FUN-680136 SMALLINT
 
   LET p_row = 2 LET p_col = 21
 
   OPEN WINDOW p6101_w AT p_row,p_col WITH FORM "apm/42f/apmp6101"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("apmp6101")
   IF s_shut(0) THEN RETURN END IF
   CALL cl_opmsg('q')
   LET l_sql=" SELECT pmn04,pmn02,pmn41,sfb251,pmn20,pmn07",
             " FROM pmn_file,sfb_file",
             " WHERE pmn41=sfb01 AND pmn01='",l_pmm01,"'",
             "   AND sfb87!='X' ",
             " ORDER BY pmn04,pmn02"
   PREPARE p610_p2 FROM l_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('prepare2:',SQLCA.sqlcode,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
   DECLARE p610_cs2 CURSOR FOR p610_p2
   FOR l_cnt=1 TO g_pmn.getLength()
       INITIALIZE g_pmn[l_cnt].* TO NULL
   END FOR
   LET l_cnt=1
   FOREACH p610_cs2 INTO g_pmn[l_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('prepare2:',SQLCA.sqlcode,1) EXIT FOREACH
      END IF
      LET l_cnt=l_cnt+1
   END FOREACH
   LET g_rec_b=l_cnt-1
   DISPLAY l_pmm01,l_pmm09,l_pmc03 TO pmm01,pmm09,pmc03
   CALL p6101_menu()
   CLOSE WINDOW p6101_w
END FUNCTION
 
FUNCTION p6101_menu()
   WHILE TRUE
      CALL p610_bp("G")
      CASE g_action_choice
         WHEN "exit"
            EXIT WHILE
         WHEN "exporttoexcel"     #FUN-4B0025
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_pmn),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION p610_bp(p_ud)
    DEFINE p_ud            LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
 
    IF p_ud <> "G" THEN
        RETURN
    END IF
 
    CALL SET_COUNT(g_rec_b)   #告訴I.單身筆數
    LET g_action_choice = " "
 
    CALL cl_set_act_visible("accept,cancel", FALSE)
    DISPLAY ARRAY g_pmn TO s_pmn.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
        BEFORE ROW
           CALL cl_show_fld_cont()                #No.FUN-560228
 
        ON ACTION exit
           LET g_action_choice="exit"
           EXIT DISPLAY
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
       ON ACTION exporttoexcel       #FUN-4B0025
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
    END DISPLAY
    CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
