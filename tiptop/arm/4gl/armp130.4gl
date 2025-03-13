# Prog. Version..: '5.30.06-13.04.02(00010)'     #
#
# Pattern name...: armp130.4gl
# Descriptions...: RMA覆出應收立帳作業
# Date & Author..: 98/05/07 By Danny
# Modify.........: No.FUN-4B0045 04/11/15 By Smapmin 客戶編號開窗
# Modify.........: No.FUN-550064 05/05/27 By Trisy 單據編號加大
# Modify.........: No.MOD-5A0301 05/10/21 By elva  insert帳款資料時新增oma65='1'
# Modify.........: No.TQC-630163 06/03/15 By 無法拋轉應收帳款
# Modify.........: No.TQC-5C0086 06/05/08 By ice AR月底重評修改
# Modify.........: No.FUN-5C0014 06/05/29 By rainy 新增欄位oma67存放INVOICE NO.
# Modify.........: No.FUN-660111 06/06/12 By pxlpxl substitute cl_err() for cl_err3()
# Modify.........: No.FUN-650142 06/06/28 By Sarah 拋轉應收帳款只轉入應收帳款的本幣金額,應包括原幣金額欄位也要轉入應收帳款
# Modify.........: No.FUN-680006 06/08/03 By kim GP3.5 利潤中心
# Modify.........: No.FUN-690010 06/09/05 By huchenghao 類型轉換
# Modify.........: No.FUN-6A0085 06/10/26 By douzh l_time轉g_time
# Modify.........: No.TQC-6C0213 07/01/04 By chenl 拋轉應收帳款只轉入應收帳款的本幣金額,應包括原幣金額欄位也要轉入應收帳款。根據11區MOD-530655修改。
# Modify.........: No.CHI-810016 08/02/19 By Judy 寫入多帳期資料(omc_file)
# Modify.........: No.MOD-960293 09/06/30 By Smapmin 產生的應收帳款單頭多個欄位都是空白
# Modify.........: No.MOD-970013 09/07/06 By Smapmin rme08應秀出帳款上的發票號碼
#                                                    產生的應收帳款單身參考單號為空白
# Modify.........: No.FUN-980007 09/08/17 By TSD.zeak GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980020 09/09/10 By douzh GP5.2集團架構sub相關參數修改
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-A10028 10/01/07 By Carrier 没有资料处理时,报提示信息
# Modify.........: No:FUN-AB0034 10/12/16 By wujie   oma73/oma73f预设0
# Modify.........: No:FUN-B30211 11/03/30 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:MOD-BB0075 11/11/12 By johung 寫入oma_file/omb_file時應給來源營運中心值 rmeplant
# Modify.........: No.FUN-D10101 13/01/22 By lujh axrt300單身新增已開票數量欄位，賦默認值0
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_wc,g_sql       string  #No.FUN-580092 HCN
DEFINE ar_slip          LIKE rmz_file.rmz11    #No.FUN-690010 VARCHAR(5)      #No.FUN-550064
DEFINE g_date           LIKE type_file.dat     #No.FUN-690010 DATE         # 應收立帳日
DEFINE g_rme		RECORD LIKE rme_file.*
DEFINE g_oma01          LIKE oma_file.oma01
DEFINE g_oma02          LIKE oma_file.oma02
DEFINE g_oma            RECORD LIKE oma_file.*
DEFINE g_omb            RECORD LIKE omb_file.*
DEFINE g_argv1          LIKE rme_file.rme01
DEFINE begin_no         LIKE oma_file.oma01  #No.FUN-690010 VARCHAR(16)     #No.FUN-550064
DEFINE g_start,g_end    LIKE oma_file.oma01  #No.FUN-690010 VARCHAR(16)     #No.FUN-550064
DEFINE l_flag           LIKE type_file.num5    #No.FUN-690010 SMALLINT
DEFINE g_change_lang    LIKE type_file.chr1    #No.FUN-690010 VARCHAR(01)     #No.FUN-570149 是否有做語言切換
DEFINE g_i              LIKE type_file.num5     #count/index for any purpose  #No.FUN-690010 SMALLINT


MAIN
   DEFINE ls_date       STRING         #No.FUN-570149
 
   OPTIONS
        INPUT NO WRAP
   DEFER INTERRUPT
 
   #No.FUN-570149 --start--
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_argv1  = ARG_VAL(1)             #No.FUN-570149
   LET ar_slip  = ARG_VAL(2)
   LET ls_date  = ARG_VAL(3)
   LET g_date   = cl_batch_bg_date_convert(ls_date)
   LET g_wc     = ARG_VAL(4)
   LET g_bgjob  = ARG_VAL(5)
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
   #No.FUN-570149 --end---
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ARM")) THEN
      EXIT PROGRAM
   END IF
 
    SELECT azi03,azi04 INTO g_azi03,g_azi04 FROM azi_file WHERE azi01 = g_aza.aza17     #No.TQC-6C0213
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0085


   WHILE TRUE
      IF g_bgjob = "N" AND cl_null(g_argv1) THEN
         CALL p130()
         IF cl_sure(21,21) THEN
            CALL cl_wait()
            LET g_success = 'Y'
            BEGIN WORK
            CALL p130_p()
            IF g_success = 'Y' THEN
               MESSAGE 'AR NO. from ',begin_no,' to ',g_end
               CALL ui.Interface.refresh()
               COMMIT WORK
               CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
            ELSE
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
            END IF
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p130_w
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
         CLOSE WINDOW p130_w
      ELSE
         IF NOT cl_null(g_argv1) THEN
            IF cl_null(ar_slip) OR cl_null(g_date) THEN
               CALL cl_batch_bg_javamail('N')
               EXIT PROGRAM
            END IF
            LET g_wc = " rme01 = '",g_argv1,"'"
         END IF
         LET g_success = 'Y'
         BEGIN WORK
         CALL p130_p()
         IF g_success = "Y" THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
   #No.FUN-570149 --end---
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
END MAIN
 
FUNCTION p130()
   DEFINE li_result   LIKE type_file.num5          #No.FUN-550064  #No.FUN-690010 SMALLINT
   DEFINE lc_cmd      LIKE type_file.chr1000       #No.FUN-690010 VARCHAR(500)       #No.FUN-570149
 
   CLEAR FORM
   CALL cl_opmsg('w')
 
   OPEN WINDOW p130_w WITH FORM "arm/42f/armp130"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
   CLEAR FORM
 
   WHILE TRUE
      CONSTRUCT BY NAME g_wc ON rme01,rme021,rme03

         BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
         ON ACTION CONTROLP
               IF INFIELD(rme03) THEN #客戶編號   #FUN-4B0045
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_occ"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rme03
                  NEXT FIELD rme03
               END IF
         ON ACTION locale
#           LET g_action_choice='locale'             #No.FUN-570149
            LET g_change_lang = TRUE                 #No.FUN-570149
            EXIT CONSTRUCT
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT CONSTRUCT
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
 
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
 
         ON ACTION controlg      #MOD-4C0121
            CALL cl_cmdask()     #MOD-4C0121
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
      END CONSTRUCT
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('rmeuser', 'rmegrup') #FUN-980030
#NO.FUN-570149 start--
      #No.FUN-570149 --start--
#     IF g_action_choice = 'locale' THEN
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CONTINUE WHILE
#        EXIT WHILE
      END IF
 
#     IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p130_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
      #No.FUN-570149 ---end---
 
      IF g_wc = ' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
#NO.FUN-570149 mark--
#      ELSE
#         EXIT WHILE
#      END IF
#   END WHILE
#   IF g_action_choice = 'locale' THEN
#      CALL cl_dynamic_locale()
#      CALL cl_show_fld_cont()   #FUN-550037(smin)
#      CONTINUE WHILE
#   END IF
#NO.FUN-570149 mark--
 
   LET g_date=g_today
   LET ar_slip = g_rmz.rmz11
   LET g_bgjob = 'N'                  #No.FUN-570149
   CALL cl_opmsg('a')
 
   #INPUT BY NAME ar_slip,g_date WITHOUT DEFAULTS
   INPUT BY NAME ar_slip,g_date,g_bgjob WITHOUT DEFAULTS  #NO.FUN-570149 
 
      AFTER FIELD ar_slip
         IF NOT cl_null(ar_slip) THEN
            SELECT ooyslip FROM ooy_file WHERE ooyslip = ar_slip
            IF STATUS THEN
 #              CALL cl_err('sel ooy',STATUS,1) # FUN-660111
            CALL cl_err3("sel","ooy_file",ar_slip,"",STATUS,"","sel ooy",1) # FUN-660111 
               NEXT FIELD ar_slip
            END IF
         END IF
         LET g_errno=NULL
        #No.FUN-550064 --start--
            CALL s_check_no("axr",ar_slip,"","14","","","")
            RETURNING li_result,ar_slip
            IF (NOT li_result) THEN
#        CALL s_axrslip(ar_slip,'14','AXR')        #檢查單別NO:6842
#        IF NOT cl_null(g_errno) THEN              #抱歉, 有問題
#           CALL cl_err(ar_slip,g_errno,0)
         #No.FUN-550064 ---end---
            NEXT FIELD ar_slip
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG
         CALL cl_cmdask()
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(ar_slip)
#              CALL q_ooy(FALSE,FALSE,ar_slip,'14','AXR') RETURNING ar_slip
#              CALL FGL_DIALOG_SETBUFFER( ar_slip )
               DISPLAY BY NAME ar_slip
               NEXT FIELD ar_slip
         END CASE
      ON ACTION locale
#         LET g_action_choice='locale'  #NO.FUN-570149
          LET g_change_lang = TRUE      #NO.FUN-570149
         EXIT INPUT
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT INPUT
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
#   IF g_action_choice = 'locale' THEN
   IF g_change_lang THEN                   #No.FUN-570149
      LET g_change_lang = FALSE            #No.FUN-570149
      CALL cl_dynamic_locale()
      CALL cl_show_fld_cont()   #FUN-550037(smin)
      CONTINUE WHILE
   END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p130_w                           #No.FUN-570149
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM                                  #No.FUN-570149
#     RETURN                                        #No.FUN-570149
   END IF
 
#NO.FUN-570149 mark--
#   IF cl_sure(20,20) THEN
#      LET g_success = 'Y'
#      BEGIN WORK
#      CALL p130_p()
#      IF g_success = 'Y' THEN
#         MESSAGE 'AR NO. from ',begin_no,' to ',g_end
#         CALL ui.Interface.refresh()
#         COMMIT WORK
#         CALL cl_end2(1) RETURNING l_flag
#      ELSE
#         ROLLBACK WORK
#         CALL cl_end2(2) RETURNING l_flag
#      END IF
#      IF l_flag THEN CONTINUE WHILE ELSE EXIT WHILE END IF
#   END IF
#NO.FUN-570149 mark--
 
#NO.FUN-570149 start--
   IF g_bgjob = "Y" THEN
         SELECT zz08 INTO lc_cmd FROM zz_file
          WHERE zz01 = "armp130"
         IF SQLCA.sqlcode OR cl_null(lc_cmd) THEN
            CALL cl_err('armp130','9031',1) 
         ELSE
            LET g_wc=cl_replace_str(g_wc, "'", "\"")
            LET lc_cmd = lc_cmd CLIPPED,
                         " ''",
                         " '",ar_slip CLIPPED,"'",
                         " '",g_date CLIPPED,"'",
                         " '",g_wc CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'"
            CALL cl_cmdat('armp130',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW p130_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
      EXIT WHILE
#FUN-570149 --end---
END WHILE
END FUNCTION
 
FUNCTION p130_p()
DEFINE  l_no_sp   LIKE type_file.num5    #No.FUN-690010 SMALLINT
DEFINE  l_cnt     LIKE type_file.num5    #No.TQC-A10028 
 
    LET l_no_sp=g_no_sp+1
    LET g_sql="SELECT * FROM rme_file ",
              " WHERE ",g_wc CLIPPED,
              "   AND (rme10 = ' ' OR rme10 IS NULL  ",
              "    OR rme10[",l_no_sp,",",g_no_ep,"] = ' ') ", #No.FUN-550064
              "   AND rmeconf = 'Y' AND rmevoid = 'Y' "
    PREPARE p130_prepare FROM g_sql
    IF STATUS THEN CALL cl_err('p130_pre',STATUS,1) RETURN END IF
    DECLARE p130_cs CURSOR WITH HOLD FOR p130_prepare
 
    LET begin_no  = NULL
    LET l_cnt = 0        #No.TQC-A10028
    FOREACH p130_cs INTO g_rme.*
      IF STATUS THEN
         CALL cl_err('p130(foreach):',STATUS,1) LET g_success='N' EXIT FOREACH
      END IF
      IF cl_null(ar_slip) AND cl_null(g_rme.rme10) THEN CONTINUE FOREACH END IF
      IF cl_null(ar_slip) THEN
#        LET g_oma01 = g_rme.rme10[1,3]
         LET g_oma01 = s_get_doc_no(g_rme.rme10)     #No.FUN-550064
 
      ELSE
         LET g_oma01 = ar_slip
      END IF
      IF cl_null(g_date) THEN
         LET g_oma02 = g_rme.rme021
      ELSE
         LET g_oma02 = g_date
      END IF
      CALL p130_ins_oma() IF g_success = 'N' THEN EXIT FOREACH END IF
      CALL p130_ins_omb() IF g_success = 'N' THEN EXIT FOREACH END IF
      UPDATE rme_file SET rme10 = g_oma01 WHERE rme01 = g_rme.rme01
      IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
#         CALL cl_err('upd rme',STATUS,1) # FUN-660111
        CALL cl_err3("upd","rme_file",g_rme.rme01,"",STATUS,"","upd rme",1) # FUN-660111 
          LET g_success = 'N' EXIT FOREACH
      END IF
      LET l_cnt = l_cnt + 1   #No.TQC-A10028
      IF begin_no IS NULL THEN LET begin_no = g_oma01 END IF
      LET g_end = g_oma01
    END FOREACH
    IF g_success = 'N' THEN
       LET begin_no = NULL
       LET g_end    = NULL
    END IF
    #No.TQC-A10028  --Begin
    IF l_cnt = 0 THEN
       LET g_success = 'N'
       CALL cl_err('','mfg3442',1)
    END IF
    #No.TQC-A10028  --End  
END FUNCTION
 
FUNCTION p130_ins_oma()
   DEFINE li_result   LIKE type_file.num5          #No.FUN-550064  #No.FUN-690010 SMALLINT
   DEFINE l_omc            RECORD LIKE omc_file.*  #CHI-810016
   DEFINE g_dbs2    LIKE type_file.chr30   #MOD-960293
   DEFINE g_plant2  LIKE type_file.chr10   #FUN-980020
 
    INITIALIZE g_oma.* TO NULL
    LET g_oma01[g_no_sp+1,g_no_ep] = '' #No.FUN-550064
 
      #No.FUN-550064 --start--
    CALL s_auto_assign_no("axr",g_oma01,g_oma02,"14","oma_file","oma01","","","")
      RETURNING li_result,g_oma.oma01
    IF (NOT li_result) THEN
#   CALL s_axrauno(g_oma01,g_oma02,'14') RETURNING g_i,g_oma01
#   IF g_i THEN
       #No.FUN-550064 ---end---
 
    LET g_success = 'N' RETURN END IF
    LET g_oma01 = g_oma.oma01    #No.TQC-630163  add
    LET g_oma.oma00 = '14'
    LET g_oma.oma01 = g_oma01
    LET g_oma.oma02 = g_oma02
    LET g_oma.oma03 = g_rme.rme03
    LET g_oma.oma032= g_rme.rme04
    LET g_oma.oma68 = g_rme.rme03   #MOD-960293
    LET g_oma.oma69= g_rme.rme04    #MOD-960293
    SELECT occ45 INTO g_oma.oma32 FROM occ_file
     WHERE occ01=g_rme.rme03

    IF cl_null(g_oma.oma32) THEN LET g_oma.oma32 = ' ' END IF
    LET g_plant2 = g_plant           #FUN-980020

    LET g_dbs2 = s_dbstring(g_dbs CLIPPED)

    CALL s_rdatem(g_oma.oma03,g_oma.oma32,g_oma.oma02,g_oma.oma02,g_oma.oma02,g_plant2)
          RETURNING g_oma.oma11,g_oma.oma12

    LET g_oma.oma05 = ' '
    LET g_oma.oma07 = 'N'
    LET g_oma.oma08 = g_rme.rme29
    LET g_oma.oma13 = '2'

    SELECT ool11,ool111 INTO g_oma.oma18,g_oma.oma181 FROM ool_file
     WHERE ool01 = g_oma.oma13
    #-----END MOD-960293-----
    LET g_oma.oma14 = g_rme.rme12
    LET g_oma.oma15 = g_rme.rme13
    LET g_oma.oma62 = g_rme.rme01    #NO:7257
    LET g_oma.oma17 = ' '
    LET g_oma.oma20 = 'Y'
    LET g_oma.oma21 = g_rme.rme15
    LET g_oma.oma211= g_rme.rme151
    LET g_oma.oma212= g_rme.rme152
    LET g_oma.oma213= g_rme.rme153
    LET g_oma.oma23 = g_rme.rme16
    LET g_oma.oma24 = g_rme.rme17
    #LET g_oma.oma32 = ' '  #MOD-960293
    LET g_oma.oma50 = 0
    LET g_oma.oma50t= 0
    LET g_oma.oma52 = 0
    LET g_oma.oma53 = 0
    LET g_oma.oma65 = '1'  #MOD-5A0301
   #No.TQC-6C0213--begin--
   #LET g_oma.oma54 = g_rme.rme18
   #LET g_oma.oma54x= g_rme.rme181
   #LET g_oma.oma54t= g_rme.rme182
    LET g_oma.oma54 = g_rme.rme19
    LET g_oma.oma54x= g_rme.rme191
    LET g_oma.oma54t= g_rme.rme192
   #No.TQC-6C0213--end--
    LET g_oma.oma55 = 0
   #No.TQC-6C0213--begin--
    LET g_oma.oma56 = g_rme.rme19
    LET g_oma.oma56x= g_rme.rme191
    LET g_oma.oma56t= g_rme.rme192
    LET g_oma.oma56 = g_oma.oma54 *g_oma.oma24
    LET g_oma.oma56x= g_oma.oma54x*g_oma.oma24
    LET g_oma.oma56t= g_oma.oma54t*g_oma.oma24
    CALL cl_digcut(g_oma.oma56 ,g_azi04) RETURNING g_oma.oma56
    CALL cl_digcut(g_oma.oma56x,g_azi04) RETURNING g_oma.oma56x
    CALL cl_digcut(g_oma.oma56t,g_azi04) RETURNING g_oma.oma56t
   #No.TQC-6C0213--end--
    LET g_oma.oma57 = 0
    LET g_oma.oma58 = s_curr3(g_rme.rme16,g_rme.rme021,g_rmz.rmz15)
    #No.TQC-5C0086 --start--                                                                                                        
    LET g_oma.oma60 = g_oma.oma24                                                                                                   
    LET g_oma.oma61 = g_oma.oma56t - g_oma.oma57                                                                                    
    #No.TQC-5C0086 --end-- 
   #No.TQC-6C0213--begin--
   #LET g_oma.oma59 = g_rme.rme18 * g_oma.oma58
   #LET g_oma.oma59x= g_rme.rme181* g_oma.oma58
    LET g_oma.oma59 = g_rme.rme19 * g_oma.oma58
    LET g_oma.oma59x= g_rme.rme191* g_oma.oma58
   #No.TQC-6C0213--end--
    LET g_oma.oma59t= g_oma.oma59 + g_oma.oma59x
    CALL cl_digcut(g_oma.oma59 ,g_azi04) RETURNING g_oma.oma59
    CALL cl_digcut(g_oma.oma59x,g_azi04) RETURNING g_oma.oma59x
    CALL cl_digcut(g_oma.oma59t,g_azi04) RETURNING g_oma.oma59t
    LET g_oma.omaconf = 'N'
    LET g_oma.omavoid = 'N'
    LET g_oma.omauser = g_user
    LET g_oma.omagrup = g_grup
    IF g_oma.oma24  IS NULL THEN LET g_oma.oma24=0  END IF
    IF g_oma.oma54  IS NULL THEN LET g_oma.oma54=0  END IF
    IF g_oma.oma54x IS NULL THEN LET g_oma.oma54x=0 END IF
    IF g_oma.oma54t IS NULL THEN LET g_oma.oma54t=0 END IF
    IF g_oma.oma56  IS NULL THEN LET g_oma.oma56=0  END IF
    IF g_oma.oma56x IS NULL THEN LET g_oma.oma56x=0 END IF
    IF g_oma.oma56t IS NULL THEN LET g_oma.oma56t=0 END IF
    IF g_oma.oma58  IS NULL THEN LET g_oma.oma58=0  END IF
    IF g_oma.oma59  IS NULL THEN LET g_oma.oma59=0  END IF
    IF g_oma.oma59x IS NULL THEN LET g_oma.oma59x=0 END IF
    IF g_oma.oma59t IS NULL THEN LET g_oma.oma59t=0 END IF
  
    #LET g_oma.oma67 = g_rme.rme08  #No.FUN-5C0014 Add   #MOD-970013
    LET g_oma.oma66 = g_rme.rmeplant   #MOD-BB0075 add
    LET g_oma.oma930=s_costcenter(g_oma.oma15) #FUN-680006
 
    LET g_oma.omalegal = g_legal  #FUN-980007
    LET g_oma.omaoriu = g_user      #No.FUN-980030 10/01/04
    LET g_oma.omaorig = g_grup      #No.FUN-980030 10/01/04
#No.FUN-AB0034 --begin
    IF cl_null(g_oma.oma73) THEN LET g_oma.oma73 =0 END IF
    IF cl_null(g_oma.oma73f) THEN LET g_oma.oma73f =0 END IF
    IF cl_null(g_oma.oma74) THEN LET g_oma.oma74 ='1' END IF
#No.FUN-AB0034 --end
    INSERT INTO oma_file VALUES(g_oma.*)
    IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
#       CALL cl_err('ins oma',STATUS,1) # FUN-660111
       CALL cl_err3("ins","oma_file",g_oma.oma01,"",STATUS,"","ins oma",1) # FUN-660111
        LET g_success = 'N' RETURN
   #CHI-810016.....begin
     ELSE
       INITIALIZE l_omc.* TO NULL
       LET l_omc.omc01=g_oma.oma01                                                                                                    
       LET l_omc.omc02=1                                                                                                              
       LET l_omc.omc03=g_oma.oma32                                                                                                    
       LET l_omc.omc04=g_oma.oma11                                                                                                    
       LET l_omc.omc05=g_oma.oma12                                                                                                    
       LET l_omc.omc06=g_oma.oma24                                                                                                    
       LET l_omc.omc07=g_oma.oma60                                                                                                    
       LET l_omc.omc08=g_oma.oma54t                                                                                                   
       LET l_omc.omc09=g_oma.oma56t                                                                                                   
       LET l_omc.omc10=g_oma.oma55                                                                                                    
       LET l_omc.omc11=g_oma.oma57                                                                                                    
       LET l_omc.omc12=g_oma.oma10                                                                                                    
       LET l_omc.omc13=l_omc.omc09-l_omc.omc11                                                                                        
       LET l_omc.omc14=g_oma.oma51f                                                                                                   
       LET l_omc.omc15=g_oma.oma51                                                                                                    
       LET l_omc.omclegal = g_legal #FUN-980007
       INSERT INTO omc_file VALUES(l_omc.*)                                                                                           
       IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
          CALL cl_err3("ins","omc_file",g_oma.oma01,"",STATUS,"","ins omc",1) 
          LET g_success='N'                                                                                                           
          RETURN                                                                                                                      
       END IF                                                                                                                         
   #CHI-810016.....end
    END IF
END FUNCTION
 
FUNCTION p130_ins_omb()
 
    INITIALIZE g_omb.* TO NULL
    LET g_omb.omb00 = '14'
    LET g_omb.omb01 = g_oma01
    LET g_omb.omb03 = 1
    LET g_omb.omb04 = 'MISC'
    LET g_omb.omb05 = 'SET'
    LET g_omb.omb06 = '維修材料'
    LET g_omb.omb12 = 1
   #No.TQC-6C0213--begin--
   #LET g_omb.omb13 = g_rme.rme18
   #LET g_omb.omb14 = g_rme.rme18
   #LET g_omb.omb14t= g_rme.rme182
   #LET g_omb.omb15 = g_rme.rme19
   #LET g_omb.omb16 = g_rme.rme19
   #LET g_omb.omb16t= g_rme.rme192
   #LET g_omb.omb17 = g_oma.oma59
   #LET g_omb.omb18 = g_oma.oma59
   #LET g_omb.omb18t= g_oma.oma59t
 
    LET g_omb.omb13 = g_rme.rme19
    LET g_omb.omb14 = g_rme.rme19
    LET g_omb.omb14t= g_rme.rme192
    LET g_omb.omb15 = g_omb.omb13 *g_oma.oma24
    LET g_omb.omb16 = g_omb.omb14 *g_oma.oma24
    LET g_omb.omb16t= g_omb.omb14t*g_oma.oma24
    LET g_omb.omb17 = g_omb.omb13 *g_oma.oma58
    LET g_omb.omb18 = g_omb.omb14 *g_oma.oma58
    LET g_omb.omb18t= g_omb.omb14t*g_oma.oma58
    CALL cl_digcut(g_omb.omb15 ,g_azi03) RETURNING g_omb.omb15  #本幣單價
    CALL cl_digcut(g_omb.omb16 ,g_azi04) RETURNING g_omb.omb16  #本幣未稅金額
    CALL cl_digcut(g_omb.omb16t,g_azi04) RETURNING g_omb.omb16t #本幣含稅金額
    CALL cl_digcut(g_omb.omb17 ,g_azi03) RETURNING g_omb.omb17  #本幣發票單價
    CALL cl_digcut(g_omb.omb18 ,g_azi04) RETURNING g_omb.omb18  #本幣發票未稅金額
    CALL cl_digcut(g_omb.omb18t,g_azi04) RETURNING g_omb.omb18t #本幣發票含稅金額
   #No.TQC-6C0213--end--
    IF g_omb.omb12  IS NULL THEN LET g_omb.omb12 =0 END IF
    IF g_omb.omb13  IS NULL THEN LET g_omb.omb13 =0 END IF
    IF g_omb.omb14  IS NULL THEN LET g_omb.omb14 =0 END IF
    IF g_omb.omb14t IS NULL THEN LET g_omb.omb14t=0 END IF
    IF g_omb.omb15  IS NULL THEN LET g_omb.omb15 =0 END IF
    IF g_omb.omb16  IS NULL THEN LET g_omb.omb16 =0 END IF
    IF g_omb.omb16t IS NULL THEN LET g_omb.omb16t=0 END IF
    IF g_omb.omb17  IS NULL THEN LET g_omb.omb17 =0 END IF
    IF g_omb.omb18  IS NULL THEN LET g_omb.omb18 =0 END IF
    IF g_omb.omb18t IS NULL THEN LET g_omb.omb18t=0 END IF
    IF g_omb.omb34  IS NULL THEN LET g_omb.omb34=0 END IF #NO:6683
    IF g_omb.omb35  IS NULL THEN LET g_omb.omb35=0 END IF #NO:6683
    #No.TQC-5C0086 --start--                                                                                                        
    LET g_omb.omb36=g_oma.oma24                                                                                                     
    LET g_omb.omb37=g_omb.omb16t-g_omb.omb35                                                                                        
    #No.TQC-5C0086 --end--
    LET g_omb.omb930=g_oma.oma930 #FUN-680006
    LET g_omb.omb38='99'   #MOD-970013
    LET g_omb.omb31=g_rme.rme01   #MOD-970013
    LET g_omb.omb44 = g_rme.rmeplant   #MOD-BB0075 add
 
    LET g_omb.omblegal = g_legal #FUN-980007 
    LET g_omb.omb48 = 0   #FUN-D10101 add
    INSERT INTO omb_file VALUES(g_omb.*)
    IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
 #      CALL cl_err('ins omb',STATUS,1) #FUN-660111
      CALL cl_err3("ins","omb_file",g_omb.omb01,g_omb.omb03,STATUS,"","ins omb",1) # FUN-660111 
        LET g_success = 'N' RETURN
    END IF
END FUNCTION
#Patch....NO.TQC-610037 <002> #
