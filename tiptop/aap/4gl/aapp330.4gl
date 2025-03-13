# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aapp330.4gl
# Descriptions...: 付款單票據資料修改及拋轉
# Date & Author..: 92/12/21 By Roger
# Modify.........: 94/01/17 By Wenni  單別輸入及檢查
# Modify ........: No.FUN-4B0079 04/11/30 By ching 單價,金額改成 DEC(20,6)
# Modify.........: No.FUN-660117 06/06/16 By Rainy Char改為 Like
# Modify.........: No.FUN-660122 06/06/27 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-690028 06/09/07 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0055 06/10/25 By douzh l_time轉g_time
# Modify.........: No.FUN-6B0033 06/11/16 By hellen 新增單頭折疊功能	
# Modify.........: No.FUN-710014 07/01/12 By Jackho 新增錯誤統整功能	
# Modify.........: No.MOD-750134 07/05/30 By Smapmin 修改INT_FLAG
# Modify.........: No.FUN-8A0086 08/10/17 By chenmoyan 添加s_showmsg_init()
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-A40065 10/05/12 By Summer 1.簿號給預設值 2.增加"可用張數"欄位
# Modify.........: No:MOD-AA0092 10/10/18 By Dido b_fill 無須異動 aph15 
# Modify.........: No:FUN-B50016 11/05/10 By guoch 付款單號範圍、廠商編號進行開創查詢 
# Modify.........: No:TQC-C20221 12/02/16 By wangrr 當前帳款沒有銀行編號無法執行"整批預算銀行"操作
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE 
    g_aph           DYNAMIC ARRAY OF RECORD
                    aph01        LIKE aph_file.aph01,
                    aph02        LIKE aph_file.aph02,
                    aph13        LIKE aph_file.aph13,
                    aph05f       LIKE aph_file.aph05f,
                    aph05        LIKE aph_file.aph05,
                    apf12_b      LIKE apf_file.apf12,
                    aph07        LIKE aph_file.aph07,
                    aph08_b      LIKE aph_file.aph08,
                    aph15        LIKE aph_file.aph15,    #No.B095  #CHI-A40065 add ,
                    pcnt         LIKE type_file.num10              #CHI-A40065 add
                    END RECORD,
    #CHI-A40065 add --start--
    g_aph_t         RECORD
                    aph01        LIKE aph_file.aph01,
                    aph02        LIKE aph_file.aph02,
                    aph13        LIKE aph_file.aph13,
                    aph05f       LIKE aph_file.aph05f,
                    aph05        LIKE aph_file.aph05,
                    apf12_b      LIKE apf_file.apf12,
                    aph07        LIKE aph_file.aph07,
                    aph08_b      LIKE aph_file.aph08,
                    aph15        LIKE aph_file.aph15, 
                    pcnt         LIKE type_file.num10 
                    END RECORD,
    #CHI-A40065 add --end--
    g_aph2          DYNAMIC ARRAY OF RECORD
                    aph04        LIKE aph_file.aph04,
                    apf03        LIKE apf_file.apf03,
                    apf05        LIKE apf_file.apf05,
                    apf06        LIKE apf_file.apf06,
                    apf07        LIKE apf_file.apf07,
                    apf11        LIKE apf_file.apf11,
                    apf12        LIKE apf_file.apf12,
                    apf13        LIKE apf_file.apf13,
                    apf44        LIKE apf_file.apf44,
                    apf43        LIKE apf_file.apf43,
                    pmc27        LIKE pmc_file.pmc27
                    END RECORD,
    g_rec_b         LIKE type_file.num5,    #No.FUN-690028 SMALLINT
    i,j,l_ac,l_sl   LIKE type_file.num5,    #No.FUN-690028 SMALLINT
    g_maxno         LIKE type_file.num5        # No.FUN-690028 SMALLINT
   #DEFINE bank_actno      VARCHAR(24)              #FUN-660117 remark
    DEFINE bank_actno      LIKE nma_file.nma05   #FUN-660117
    DEFINE l_nma16         LIKE nma_file.nma16
     DEFINE g_wc,g_sql     string  #No.FUN-580092 HCN
    DEFINE g_tot           LIKE type_file.num20_6       # No.FUN-690028 DEC(20,6)  #FUN-4B0079
    DEFINE g_start_no,g_end_no    LIKE type_file.num10       # No.FUN-690028  INTEGER
    DEFINE g_slip LIKE nmy_file.nmyslip
 
 
DEFINE   g_cnt           LIKE type_file.num10      #No.FUN-690028 INTEGER
MAIN
#     DEFINE   l_time LIKE type_file.chr8             #No.FUN-6A0055
   DEFINE p_row,p_col    LIKE type_file.num5    #No.FUN-690028 SMALLINT
   OPTIONS
        INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF
 
 
   OPEN WINDOW p330_w AT p_row,p_col WITH FORM "aap/42f/aapp330"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
 
     CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
   WHILE TRUE
   CALL p330()
   IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
   END WHILE
   CLOSE WINDOW p330_w
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
END MAIN
 
FUNCTION p330()
    DEFINE l_vendor    LIKE faj_file.faj02,      # No.FUN-690028 VARCHAR(10)
           l_cnt       LIKE type_file.num5,      #No.FUN-690028 SMALLINT
           l_cur       LIKE azi_file.azi01,      # No.FUN-690028 VARCHAR(04)
           l_nmd       RECORD LIKE nmd_file.*,
           l_pmd02     LIKE pmd_file.pmd02,
#       l_time           LIKE type_file.chr8          #No.FUN-6A0055
           l_serial    LIKE type_file.num10,   # No.FUN-690028 INTEGER
           l_flag      LIKE type_file.chr1     #No.FUN-690028 VARCHAR(1)
    DEFINE l_aph15     LIKE aph_file.aph15   #CHI-A40065 add
    DEFINE l_pcnt      LIKE type_file.num10  #CHI-A40065 add

WHILE TRUE
   LET g_action_choice = ""
 
    CLEAR FORM
    CALL g_aph.clear()
    CALL cl_set_head_visible("","YES")     #No.FUN-6B0033	
 
    CONSTRUCT BY NAME g_wc ON apf01,apf02,apf03,apf12,aph08,apf44,aph13,
                              aph05f,aph05
#FUN-B50016  --Begin                           
       ON ACTION CONTROLP
           CASE
              WHEN INFIELD(apf01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_apf4"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO apf01
                 NEXT FIELD apf01
              WHEN INFIELD(apf03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_pmc2"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO apf03
                  NEXT FIELD apf03
              OTHERWISE
                 EXIT CASE
           END CASE
#FUN-B50016  --end
 
       ON ACTION locale
          LET g_action_choice = 'locale'
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
 
  
    END CONSTRUCT
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('apfuser', 'apfgrup') #FUN-980030
    IF g_action_choice = 'locale' THEN
       CALL cl_dynamic_locale()
       CALL cl_show_fld_cont()   #FUN-550037(smin)
       CONTINUE WHILE
    END IF
    IF INT_FLAG THEN RETURN END IF
 
    CALL p330_b_fill()
    IF g_rec_b = 0 THEN
       CALL cl_err('',100,1)
       RETURN
    END IF
 
    #顯示單身
    DISPLAY g_maxno  TO FORMONLY.cn3  #顯示總筆數
    INPUT ARRAY g_aph WITHOUT DEFAULTS FROM s_aph.* 
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)
       BEFORE ROW
          LET l_ac = ARR_CURR()
          DISPLAY l_ac TO cn2   
          LET g_aph_t.* = g_aph[l_ac].*  #CHI-A40065 add
       AFTER FIELD aph08_b  #-->銀行
          IF NOT cl_null(g_aph[l_ac].aph08_b) THEN
             IF g_aph[l_ac].aph08_b[1,1]='.' AND l_ac!=1 THEN
                LET g_aph[l_ac].aph08_b=g_aph[l_ac-1].aph08_b
                DISPLAY g_aph[l_ac].aph08_b TO s_aph[l_sl].aph08_b
             END IF
             SELECT nma05,nma16 INTO bank_actno,l_nma16 FROM nma_file
                  WHERE nma01 = g_aph[l_ac].aph08_b
             IF STATUS THEN 
#               CALL cl_err(g_aph[l_ac].aph08_b,'aap-265',0)   #No.FUN-660122
                CALL cl_err3("sel","nma_file",g_aph[l_ac].aph08_b,"","aap-265","","",0)   #No.FUN-660122
                NEXT FIELD aph08_b
             END IF

             #CHI-A40065 add --start--
             #銀行變動時,重新帶出簿號、可用張數
             IF g_aph[l_ac].aph08_b != g_aph_t.aph08_b OR
                (NOT cl_null(g_aph[l_ac].aph08_b) AND cl_null(g_aph_t.aph08_b))  THEN
                CALL p330_aph08(g_aph[l_ac].aph08_b,'') RETURNING l_aph15,l_pcnt
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err('',g_errno,0)
                   LET g_aph[l_ac].pcnt=0
                   NEXT FIELD aph08_b
                END IF
                IF l_aph15 !='' OR NOT cl_null(l_aph15) OR NOT cl_null(l_pcnt) THEN
                   LET g_aph[l_ac].aph15=l_aph15
                   LET g_aph[l_ac].pcnt=l_pcnt
                   DISPLAY g_aph[l_ac].aph15 TO s_aph[l_sl].aph15
                   DISPLAY g_aph[l_ac].pcnt TO s_aph[l_sl].pcnt
                END IF
             END IF
             #CHI-A40065 add --end--
          END IF
          IF g_apz.apz04 MATCHES '[Yy]' THEN
             IF cl_null(g_aph[l_ac].aph08_b) THEN 
                CALL cl_err(g_aph[l_ac].aph08_b,'aap-133',0)
                NEXT FIELD aph08_b
             END IF
          END IF
          IF cl_null(g_aph2[l_ac].aph04) THEN 
             LET g_aph2[l_ac].aph04 = bank_actno
          END IF 
 
       #No.B095 010508 by linda add 簿號
       AFTER FIELD aph15
           IF NOT cl_null(g_aph[l_ac].aph15) AND
              NOT cl_null(g_aph[l_ac].aph08_b) THEN
              LET l_cnt=0
              SELECT COUNT(*) INTO l_cnt 
                 FROM nna_file,nma_file
               WHERE nna01 = nma01
                 AND nna01 = g_aph[l_ac].aph08_b
                 AND nna02 =  g_aph[l_ac].aph15
              IF l_cnt = 0 THEN
                 CALL cl_err('','anm-954',0) 
                 NEXT FIELD aph15
              END IF
              #CHI-A40065 add --start--
              #簿號變動時,重新帶出可用張數
             IF g_aph[l_ac].aph15 != g_aph_t.aph15 OR
                (NOT cl_null(g_aph[l_ac].aph15) AND cl_null(g_aph_t.aph15))  THEN
                CALL p330_aph08(g_aph[l_ac].aph08_b,g_aph[l_ac].aph15) RETURNING l_aph15,l_pcnt
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err('',g_errno,0)
                   LET g_aph[l_ac].pcnt=0
                   NEXT FIELD aph15
                END IF
                IF l_aph15 !='' OR NOT cl_null(l_aph15) OR NOT cl_null(l_pcnt) THEN
                   LET g_aph[l_ac].pcnt=l_pcnt
                   DISPLAY g_aph[l_ac].pcnt TO s_aph[l_sl].pcnt
                END IF
             END IF
              #CHI-A40065 add --end--
           END IF
       #No.B095 end---
 
       ON ROW CHANGE
          UPDATE aph_file SET aph04 = g_aph2[l_ac].aph04,
                              aph07 = g_aph[l_ac].aph07,
                              aph08 = g_aph[l_ac].aph08_b,
                              aph15 = g_aph[l_ac].aph15
               WHERE aph01 = g_aph[l_ac].aph01 AND aph02 = g_aph[l_ac].aph02
       AFTER ROW
          #IF INT_FLAG THEN EXIT INPUT  END IF   #MOD-750134
          IF INT_FLAG THEN LET INT_FLAG = 0 EXIT INPUT  END IF   #MOD-750134
          MESSAGE g_aph[l_ac].aph05
          CALL ui.Interface.refresh()
 
       AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
           LET l_flag='N'
           #IF INT_FLAG THEN EXIT INPUT  END IF   #MOD-750134
           IF INT_FLAG THEN LET INT_FLAG = 0 EXIT INPUT  END IF   #MOD-750134
 
        ON ACTION batch_set_bank_no
           CALL p330_def(g_aph[l_ac].aph08_b)
            
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(aph08_b)
#                CALL q_nma(0,0,g_aph[l_ac].aph08_b) 
#                     RETURNING g_aph[l_ac].aph08_b
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_nma"
                 LET g_qryparam.default1 = g_aph[l_ac].aph08_b
                 CALL cl_create_qry() RETURNING g_aph[l_ac].aph08_b
                 DISPLAY g_aph[l_ac].aph08_b TO aph08_b
              OTHERWISE
                 EXIT CASE
           END CASE
        ON ACTION locale
           LET g_action_choice='locale'
           EXIT INPUT
        ON ACTION exit
           #LET INT_FLAG = 1   #MOD-750134
           EXIT INPUT
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      ON ACTION controls                       #No.FUN-6B0033                                                                       	
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
 
     END INPUT
     IF g_action_choice = 'locale' THEN
        CALL cl_dynamic_locale()
        CALL cl_show_fld_cont()   #FUN-550037(smin)
        CONTINUE WHILE
     END IF
END WHILE
END FUNCTION 
 
FUNCTION p330_b_fill()
  DEFINE l_aph15  LIKE aph_file.aph15   #CHI-A40065 add
  DEFINE l_pcnt   LIKE type_file.num10  #CHI-A40065 add

    #LET g_sql = "SELECT aph01,aph02,aph13,aph05f,aph05,apf12,aph07,aph08,aph15,",    #CHI-A40065 mark
    LET g_sql = "SELECT aph01,aph02,aph13,aph05f,aph05,apf12,aph07,aph08,aph15,'',",  #CHI-A40065 
                "       aph04,apf03,apf05,apf06,apf07,apf11,apf12,apf13,",
                "       apf44,apf43,pmc27",
                "  FROM apf_file LEFT OUTER JOIN pmc_file ON apf_file.apf03 = pmc_file.pmc01, aph_file ",
                " WHERE ", g_wc CLIPPED,
                "   AND apf01 = aph01",
      #         "   AND apf41 MATCHES '[Nn]'",
                "   AND apf41 <> 'X' ", #不可為作廢 modi in 01/08/09
                "   AND aph03 = '1'  ",
                "   AND (aph09 IS NULL OR aph09='N' OR aph09='n')", 
                " ORDER BY 1,2,3"
    PREPARE p330_prepare FROM g_sql
    DECLARE p330_cs CURSOR WITH HOLD FOR p330_prepare
    #-->清單身
    CALL g_aph.clear()
    CALL g_aph2.clear()
    LET g_cnt = 1
    FOREACH p330_cs INTO g_aph[g_cnt].*,g_aph2[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('p330(ckp#1):',SQLCA.sqlcode,1)
          RETURN
       END IF
       #CHI-A40065 add --start--
      #-MOD-AA0092-mark-
      #CALL p330_aph08(g_aph[g_cnt].aph08_b,'') RETURNING l_aph15,l_pcnt
      #IF l_aph15 !='' OR NOT cl_null(l_aph15) OR NOT cl_null(l_pcnt) THEN
      #   LET g_aph[g_cnt].aph15 = l_aph15
      #   LET g_aph[g_cnt].pcnt  = l_pcnt
      #END IF
      #-MOD-AA0092-end-
       #CHI-A40065 add --end--
       LET g_cnt = g_cnt + 1
    END FOREACH
    CALL g_aph.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1
    LET g_maxno = g_rec_b
   
END FUNCTION
 
#CHI-A40065 add --start--
FUNCTION p330_aph08(l_aph08,l_aph15)
DEFINE l_aph08    LIKE aph_file.aph08,
       l_aph15    LIKE aph_file.aph15,
       l_pcnt     LIKE type_file.num10,
       l_nmw03    LIKE nmw_file.nmw03,
       l_nmw04    LIKE nmw_file.nmw04,
       l_nmw05    LIKE nmw_file.nmw05,
       l_nmw06    LIKE nmw_file.nmw06,
       l_being    LIKE type_file.num10, 
       l_end      LIKE type_file.num10, 
       l_point    LIKE type_file.num5,  #可用張數
       l_nna03    LIKE nna_file.nna03,
       l_nna04    LIKE nna_file.nna04,
       l_nna05    LIKE nna_file.nna05,
       l_count2   LIKE type_file.num10,
       l_count4   LIKE type_file.num10,
       l_cnt2     LIKE type_file.num10,  #領用張數
       l_cnt1     LIKE type_file.num10   #已用張數

  #1.取該銀行最大取票日
  IF l_aph15 !='' OR NOT cl_null(l_aph15) THEN
     SELECT MAX(nmw03) INTO l_nmw03 
        FROM nmw_file 
       WHERE nmw01=l_aph08
         AND nmw06=l_aph15
  ELSE
     SELECT DISTINCT nmw03 INTO l_nmw03
       FROM nmw_file 
      WHERE nmw01=l_aph08 
        AND nmw03=(SELECT MAX(nmw03) FROM nmw_file 
                          WHERE nmw01=l_aph08 )
  END IF
  IF NOT cl_null(l_nmw03) THEN
     IF l_aph15 !='' OR NOT cl_null(l_aph15) THEN
        LET l_nmw06 = l_aph15
     ELSE
        #2.以該銀行最大取票日取最小簿號 
        SELECT MIN(nmw06) INTO l_nmw06
          FROM nmw_file
         WHERE nmw01=l_aph08
           AND nmw03=l_nmw03 
     END IF
     IF NOT cl_null(l_nmw06) THEN
        #3.算出可用張數=領用張數-已用張數
        SELECT nmw04,nmw05 INTO l_nmw04,l_nmw05
          FROM nmw_file
         WHERE nmw01=l_aph08
           AND nmw03=l_nmw03 
           AND nmw06=l_nmw06 
        LET g_errno = ' '
        SELECT nna03,nna04,nna05 INTO l_nna03,l_nna04,l_nna05
          FROM nna_file,nma_file
         WHERE nna01 = l_aph08
           AND nna02 = l_nmw06
           AND nna021= l_nmw03   
           AND nna01 = nma01 AND nmaacti = 'Y'
        CASE WHEN STATUS = 100 LET g_errno ='anm-954'
             WHEN l_nna04 is null or l_nna04 = ' ' or l_nna04 <= 0
                  LET g_errno = 'anm-238'
             WHEN l_nna05 is null or l_nna05 = ' ' or l_nna05 <= 0
                  LET g_errno = 'anm-239'
             OTHERWISE         
                  LET g_errno = SQLCA.SQLCODE USING '-------'
        END CASE
        IF NOT cl_null(g_errno) THEN 
           RETURN '','' 
        END IF
        LET l_point =(l_nna04 - l_nna05) + 1
        LET l_end   = l_nmw05[l_point,l_nna04]
        LET l_being = l_nmw04[l_point,l_nna04]
        LET l_cnt2 = l_end - l_being + 1  #領用張數
        SELECT COUNT(*)
          INTO l_count2 FROM nmd_file
         WHERE nmd03 = l_aph08
           AND nmd31 = l_nmw06
           AND nmd02 BETWEEN l_nmw04 AND l_nmw05
        SELECT COUNT(*)
          INTO l_count4 FROM nnz_file
         WHERE nnz01 = l_aph08
           AND nnz02 BETWEEN l_nmw04 AND l_nmw05
        LET l_cnt1 = l_count2+l_count4  #已用張數   
        LET l_pcnt = l_cnt2 - l_cnt1    #可用張數
      END IF 
  END IF

  RETURN l_nmw06,l_pcnt
END FUNCTION
#CHI-A40065 add --end--

#no.6650
FUNCTION p330_def(l_nma01)
   DEFINE l_nma01    LIKE nma_file.nma01
   DEFINE l_nma02    LIKE nma_file.nma02
   DEFINE l_nma05    LIKE nma_file.nma05
   DEFINE l_aph04    LIKE aph_file.aph04
 
   #IF cl_null(l_nma01) THEN RETURN END IF #TQC-C20221 mark--
 
   OPEN WINDOW p3301_w AT 8,20 WITH FORM "aap/42f/aapp3301"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("aapp3301")
                   
   SELECT nma02 INTO l_nma02 FROM nma_file WHERE nma01 = l_nma01
   DISPLAY l_nma01 TO FORMONLY.nma01
   DISPLAY l_nma02 TO FORMONLY.nma02
   CALL cl_set_head_visible("","YES")     #No.FUN-6B0033	
 
   INPUT l_nma01  WITHOUT DEFAULTS FROM nma01
       AFTER FIELD nma01
          IF cl_null(l_nma01) THEN NEXT FIELD nma01 END IF
          SELECT nma02,nma05 INTO l_nma02,l_nma05 FROM nma_file
           WHERE nma01 = l_nma01
          IF STATUS THEN
#            CALL cl_err('sel nma:',STATUS,1)   #No.FUN-660122
             CALL cl_err3("sel","nma_file",l_nma01,"",STATUS,"","sel nma",1)   #No.FUN-660122
             NEXT FIELD nma01 
          END IF
          DISPLAY l_nma02 TO FORMONLY.nma02
        ON ACTION CONTROLP
#          CALL q_nma(0,0,l_nma01) RETURNING l_nma01
           CALL cl_init_qry_var()
           LET g_qryparam.form = "q_nma"
           LET g_qryparam.default1 = l_nma01
           CALL cl_create_qry() RETURNING l_nma01
#           CALL FGL_DIALOG_SETBUFFER( l_nma01 )
           DISPLAY l_nma01 TO FORMONLY.nma01
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
   
   END INPUT
   IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW p3301_w RETURN END IF
   IF NOT cl_confirm('abx-080') THEN CLOSE WINDOW p3301_w RETURN END IF
   LET g_success='Y'
   CALL s_showmsg_init() #No.FUN-8A0086
   BEGIN WORK
   FOR g_cnt = 1 TO g_rec_b
       SELECT aph04 INTO l_aph04 FROM aph_file
        WHERE aph01 = g_aph[g_cnt].aph01
          AND aph02 = g_aph[g_cnt].aph02
       IF STATUS THEN LET l_aph04 = '' END IF
       IF cl_null(l_nma05) THEN LET l_nma05 = l_aph04 END IF
 
       LET g_aph[g_cnt].aph08_b = l_nma01
       UPDATE aph_file SET aph08 = l_nma01, 
                           aph04 = l_nma05
        WHERE aph01 = g_aph[g_cnt].aph01 AND aph02 = g_aph[g_cnt].aph02
       IF STATUS THEN
#No.FUN-710014--begin
#         CALL cl_err('upd aph08',STATUS,1)  #No.FUN-660122
#          CALL cl_err3("upd","aph_file",g_aph[g_cnt].aph01,g_aph[g_cnt].aph02,STATUS,"","upd aph08",1)   #No.FUN-660122
#          LET g_success='N' 
#          EXIT FOR
         LET g_showmsg=g_aph[g_cnt].aph01,"/",g_aph[g_cnt].aph02
         CALL s_errmsg('aph01,aph02',g_showmsg,'upd aph08',STATUS,1)
         LET g_totsuccess='N'
         CONTINUE FOR
       END IF
    END FOR
    IF g_totsuccess='N' THEN
       LET g_success='N'
       CALL s_showmsg()
    END IF
#No.FUN-710014--end
    IF g_success='Y' THEN 
       CALL cl_cmmsg(1) COMMIT WORK 
    ELSE
       CALL cl_rbmsg(1) ROLLBACK WORK 
    END IF
    CLOSE WINDOW p3301_w
END FUNCTION 
#no.6650(end)
