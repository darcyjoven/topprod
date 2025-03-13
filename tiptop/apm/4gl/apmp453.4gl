# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: apmp453.4gl
# Descriptions...: 請購單取消作業
# Date & Author..: 91/09/27 By Nora 
# Modify.........: 99/04/16 BY Carol:modify s_pmksta()
# Modify.........: No.MOD-480237 04/08/10 By Wiky q_azf 開窗問題 
# Modify.........: No.MOD-480531 04/09/15 By Melody 單身有問題,多顯示一筆
# Modify.........: No.FUN-630040 06/03/23 By Nicola 已拋轉的請購單,不可自行作廢
# Modify.........: No.FUN-660129 06/06/19 By Wujie cl_err --> cl_err3
# Modify.........: No.FUN-680136 06/08/31 By Jackho 欄位類型修改
# Modify.........: No.FUN-6B0032 06/11/16 By Czl 增加雙檔單頭折疊功能
# Modify.........: No.FUN-710030 07/01/17 By johnray 錯誤訊息匯總顯示修改
# Modify.........: No.MOD-840055 08/04/08 By Dido 僅未確認的請購單方可輸入
# Modify.........: No.FUN-930104 09/03/23 By dxfwo   理由碼的分類改善
# Modify.........: No.TQC-950119 09/05/19 By chenyu 簽核中及已核准的狀態不可以作廢
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0067 09/11/10 By lilingyu 去掉ATTRIBUTE
# Modify.........: No.FUN-A10034 10/01/10 By hongmei 加上pml92<>'Y'条件 
# Modify.........: No:CHI-A70049 10/08/27 By Pengu  將多餘的DISPLAY程式mark
# Modify.........: No:MOD-C10115 12/02/09 By jt_chen 增加作廢時,狀況碼pmk25與確認碼pmk18一致顯示為"作廢"
# Modify.........: No:MOD-C50007 12/06/15 By Vampire 將pml16改為pml16_d顯示

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
        tm RECORD
          pmk01 LIKE pmk_file.pmk01,   #請購單號
          pmk27 LIKE pmk_file.pmk27,   #狀況異動日期
          pmk26 LIKE pmk_file.pmk26    #理由碼
          END RECORD,
        g_pml DYNAMIC ARRAY OF RECORD
            sure     LIKE type_file.chr1,     # 確定否   #No.FUN-680136 VARCHAR(1)
            pml02    LIKE pml_file.pml02,     # 項次 
            pml04    LIKE pml_file.pml04,     # 料號
            pml16_d  LIKE ze_file.ze03        # 目前狀況 #MOD-C50007 add
            #pml16    LIKE pml_file.pml16     # 目前狀況 #No.FUN-680136 VARCHAR(10) #MOD-C50007 mark
        END RECORD,
        g_exit     LIKE type_file.chr1,       #判斷ARRAY 是否太大 #No.FUN-680136 VARCHAR(1)
        g_rec_b    LIKE type_file.num5,       #No.FUN-680136 SMALLINT
        l_ac       LIKE type_file.num5,       #No.FUN-680136 SMALLINT
        l_sl       LIKE type_file.num5,       #No.FUN-680136 SMALLINT
#       g_pml16_d  ARRAY[30] of LIKE pml_file.pml16   # 狀況碼
        g_pml16_d  ARRAY[200] of LIKE pml_file.pml16  # 狀況碼
DEFINE   g_chr           LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
DEFINE   g_flag          LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680136 INTEGER
DEFINE   g_msg           LIKE ze_file.ze03            #No.FUN-680136 VARCHAR(72)
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
 
   IF g_sma.sma31 matches'[Nn]' THEN    #無使用請購功能
       CALL cl_err(g_sma.sma31,'mfg0032',1)
       EXIT PROGRAM  
   END IF
 
   OPEN WINDOW p453_w WITH FORM "apm/42f/apmp453" 
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   CALL cl_ui_init()
 
   IF s_shut(0) THEN EXIT PROGRAM END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818

   CALL p453_tm()				# 
   CLOSE WINDOW p453_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818
END MAIN
 
FUNCTION p453_tm()
   DEFINE l_i,l_n     LIKE type_file.num5           #No.FUN-680136 SMALLINT
   DEFINE l_azf09     LIKE azf_file.azf09           #No.FUN-930104
 
   WHILE TRUE
      CLEAR FORM 
      CALL g_pml.clear()
      INITIALIZE tm.* TO NULL			# Default condition
      LET tm.pmk27 = TODAY                         # Default 
     
      CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
      INPUT BY NAME tm.pmk01,tm.pmk27,tm.pmk26     WITHOUT DEFAULTS 
     
         AFTER FIELD pmk01            #請購單號
            IF NOT cl_null(tm.pmk01) THEN
               CALL p453_pmk01()
               IF g_chr = 'E' THEN
                  DISPLAY BY NAME tm.pmk01
                  NEXT FIELD pmk01
               END IF
            END IF
    
         AFTER FIELD pmk26
             IF NOT cl_null(tm.pmk26) THEN
                SELECT COUNT(*) INTO l_n FROM azf_file 
                 WHERE azf01 = tm.pmk26 AND azf02 = '2'                 
                IF l_n = 0 THEN
                   CALL cl_err('','mfg3088',0)
                   LET tm.pmk26 = NULL 
                   DISPLAY tm.pmk26 TO pmk26
                   NEXT FIELD pmk26
                END IF
                #No.FUN-930104 --begin--
                SELECT azf09 INTO l_azf09 FROM azf_file 
                 WHERE azf01 = tm.pmk26 AND azf02 = '2'    
                  IF l_azf09 !='B' THEN 
                    CALL cl_err('','aoo-410',1)
                    NEXT FIELD pmk26 
                  END IF   
                #No.FUN-930104 --end--  
             END IF
     
         AFTER INPUT 
            IF INT_FLAG THEN 
               EXIT INPUT
            END IF 
     
         ON ACTION CONTROLP
            CASE 
                WHEN INFIELD(pmk01) 
                   CALL cl_init_qry_var()
                  #LET g_qryparam.form = "q_pmk3"  #MOD-840055
                   LET g_qryparam.form = "q_pmk7"  #MOD-840055
                   LET g_qryparam.default1 = tm.pmk01
                   LET g_qryparam.arg1 = "29"
                   CALL cl_create_qry() RETURNING tm.pmk01
                   DISPLAY tm.pmk01 TO pmk01
                   CALL p453_pmk01()
                   NEXT FIELD pmk01
                WHEN INFIELD(pmk26) 
                   CALL cl_init_qry_var()
#                   LET g_qryparam.form = 'q_azf'           #No.FUN-930104
                   LET g_qryparam.form = 'q_azf01a'         #No.FUN-930104
                   LET g_qryparam.default1 = tm.pmk26       
#                    LET g_qryparam.arg1 = "2" #MOD-480237  #No.FUN-930104
                   LET g_qryparam.arg1 = "B"                #No.FUN-930104
                   CALL cl_create_qry() RETURNING tm.pmk26
                   DISPLAY tm.pmk26 TO pmk26
                   NEXT FIELD pmk26
                OTHERWISE EXIT CASE
            END CASE
     
          ON ACTION mntn_reason
             CALL cl_cmdrun("aooi080 '2' ")
     
          ON ACTION CONTROLR
             CALL cl_show_req_fields()
     
          ON ACTION CONTROLG
             CALL cl_cmdask()
     
          ON ACTION locale                    #genero
             LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
             EXIT INPUT
    
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
    
          ON ACTION exit  #加離開功能genero
             LET INT_FLAG = 1
             EXIT INPUT
       
       END INPUT
    
       IF g_action_choice = "locale" THEN  #genero
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
       IF INT_FLAG THEN 
          LET INT_FLAG = 0
          EXIT WHILE
       END IF
 
       LET g_success = 'Y'
       CALL p453_b_fill()   #ARRAY 的填充
       IF g_success = 'N' THEN 
          CONTINUE WHILE 
       END IF
 
       CALL p453_choice()   #選擇欲取消的請購單單身
       IF INT_FLAG THEN 
          LET INT_FLAG = 0
          CONTINUE WHILE 
       END IF
 
      IF cl_sure(0,0) THEN
         LET g_success = 'Y'
         BEGIN WORK
         CALL cl_wait()
 
         CALL p453_cancel()      #更改欲取消之請購單單身狀況碼
#        CALL p453_show()        #顯示己取消之請購單項次及版本
 
         IF g_success = 'Y' THEN 
            COMMIT WORK
            CALL cl_end2(1) RETURNING g_flag        #批次作業正確結束
         ELSE
            ROLLBACK WORK
            CALL cl_end2(2) RETURNING g_flag        #批次作業失敗
         END IF
      
         IF g_flag THEN
            CONTINUE WHILE
         ELSE
            EXIT WHILE
         END IF
      END IF
      ERROR ""
   END WHILE
 
END FUNCTION
 
FUNCTION p453_pmk01()
   DEFINE l_pmk03 LIKE pmk_file.pmk03,   #更動序號
          l_pmk02 LIKE pmk_file.pmk02,   #單據性質
          l_pmk09 LIKE pmk_file.pmk09,   #廠商編號
          l_pmk25 LIKE pmk_file.pmk09,   #請購狀況碼
          l_pmc03 LIKE pmc_file.pmc03    #廠商簡稱
 
    LET g_chr = ' '
    SELECT pmk03,pmk02,pmk09,pmk25 
           INTO l_pmk03,l_pmk02,l_pmk09,l_pmk25 
           FROM pmk_file 
     WHERE pmk01 = tm.pmk01  AND pmk25 not matches'[129S]'  #No.TQC-950119 add 1,S
       AND pmk18 = 'N'               #MOD-840055
    IF SQLCA.sqlcode THEN 
#      CALL cl_err('','mfg3137',0)   #No.FUN-660129
       CALL cl_err3("sel","pmk_file",tm.pmk01,"",SQLCA.sqlcode,"","",0)  #No.FUN-660129
       LET g_chr = 'E'
       LET l_pmk03 = NULL 
       LET l_pmk02 = NULL 
       LET l_pmk09 = NULL
       LET l_pmk25 = NULL
       LET tm.pmk01 = NULL
    ELSE
       SELECT pmc03 INTO l_pmc03 FROM pmc_file
        WHERE pmc01 = l_pmk09
       IF SQLCA.sqlcode THEN
          LET l_pmc03 = NULL 
       END IF
    END IF
 
    DISPLAY l_pmk03 TO FORMONLY.pmk03
    DISPLAY l_pmk02 TO FORMONLY.pmk02
    DISPLAY l_pmk09 TO FORMONLY.pmk09
    DISPLAY l_pmc03 TO FORMONLY.pmc03
 
END FUNCTION
    
FUNCTION p453_b_fill()
 DEFINE l_sql      LIKE type_file.chr1000        #No.FUN-680136 VARCHAR(300)
 DEFINE l_pmk18    LIKE pmk_file.pmk18
 DEFINE l_pmkmksg  LIKE pmk_file.pmkmksg
 
    LET l_sql = " SELECT 'N',pml02,pml04,pml16,pmk18,pmkmksg",
                  " FROM pml_file,pmk_file",
                 " WHERE pml01 = '",tm.pmk01,"' AND pmk01=pml01 ",
                 "   AND pml192 = 'N'",   #No.FUN-630040
                 "   AND pml92<>'Y' ",   #FUN-A10034
                 " ORDER BY 2"
    PREPARE p453_prepare FROM l_sql
    DECLARE p453_cur CURSOR FOR p453_prepare
    LET l_ac = 1
    FOREACH p453_cur INTO g_pml[l_ac].*,l_pmk18,l_pmkmksg
       IF SQLCA.sqlcode THEN 
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
 
       DISPLAY g_rec_b TO FORMONLY.cn2  
       #LET g_pml16_d[l_ac] = g_pml[l_ac].pml16  #MOD-C50007 mark
       LET g_pml16_d[l_ac] = g_pml[l_ac].pml16_d #MOD-C50007 add
       CALL s_pmksta('pmk',g_pml16_d[l_ac],l_pmk18,l_pmkmksg)
            #RETURNING g_pml[l_ac].pml16  #MOD-C50007 mark
            RETURNING g_pml[l_ac].pml16_d #MOD-C50007 add
       LET l_ac = l_ac + 1
       IF l_ac > g_max_rec THEN
          CALL cl_err('',9035,1)
	  EXIT FOREACH
       END IF
    END FOREACH
     CALL g_pml.deleteElement(l_ac)  #No.MOD-480531
 
    LET g_rec_b=l_ac - 1
 
END FUNCTION
 
FUNCTION p453_choice()
   DEFINE l_ac            LIKE type_file.num5,         #No.FUN-680136 SMALLINT
          l_cnt           LIKE type_file.num5,         #可新增否  #No.FUN-680136 SMALLINT
          g_i             LIKE type_file.num5,         #可新增否  #No.FUN-680136 SMALLINT
          l_allow_insert  LIKE type_file.num5,         #可新增否  #No.FUN-680136 SMALLINT
          l_allow_delete  LIKE type_file.num5          #No.FUN-680136 SMALLINT
 
    LET g_cnt = 0 
    DISPLAY g_rec_b TO FORMONLY.cn2
    DISPLAY ARRAY g_pml TO s_pml.* ATTRIBUTE(COUNT=g_cnt)
       BEFORE DISPLAY
          EXIT DISPLAY
    END DISPLAY
 
    MESSAGE ''
 
    LET l_allow_insert = FALSE
    LET l_allow_delete = FALSE 
 
    LET l_ac = 1
    INPUT ARRAY g_pml WITHOUT DEFAULTS FROM s_pml.*
       ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                 INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
       BEFORE INPUT
          IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(l_ac)
          END IF
 
       BEFORE ROW
          LET l_ac = ARR_CURR()
 
       AFTER FIELD sure
          IF NOT cl_null(g_pml[l_ac].sure) THEN
             IF g_pml[l_ac].sure NOT MATCHES "[YN]" THEN
                NEXT FIELD sure
             END IF
          END IF
 
       AFTER INPUT
          LET l_cnt  = 0 
          FOR g_i =1 TO g_rec_b
             IF g_pml[g_i].sure = 'Y' AND 
                NOT cl_null(g_pml[g_i].pml02)  THEN
                LET l_cnt = l_cnt + 1
             END IF
          END FOR
          DISPLAY l_cnt TO FORMONLY.cn3 
 
       ON ACTION select_all           
          FOR g_i = 1 TO g_rec_b
              LET g_pml[g_i].sure="Y"
          END FOR
          DISPLAY g_rec_b TO FORMONLY.cn3 
 
       ON ACTION cancel_all
          FOR g_i = 1 TO g_rec_b
              LET g_pml[g_i].sure="N"
          END FOR
          DISPLAY 0 TO FORMONLY.cn3
 
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
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
    
    END INPUT
 
END FUNCTION
 
FUNCTION p453_cancel()
    DEFINE  l_i,l_n   LIKE type_file.num5          #No.FUN-680136 SMALLINT
    DEFINE  l_pml011  LIKE pml_file.pml01
    DEFINE  l_pml41   LIKE pml_file.pml41 
    CALL s_showmsg_init()        #No.FUN-710030
    FOR l_i = 1 TO g_rec_b 
#No.FUN-710030 -- begin --
    IF g_success='N' THEN
       LET g_totsuccess='N'
       LET g_success='Y'
    END IF
#No.FUN-710030 -- end --
        IF g_pml[l_i].sure = 'Y' THEN
           IF g_pml16_d[l_i] != '2' THEN
              UPDATE pml_file SET pml16 = '9'
               WHERE pml01 = tm.pmk01 
                 AND pml02 = g_pml[l_i].pml02
              IF SQLCA.sqlcode THEN
                 LET g_success = 'N'
#                CALL cl_err('(ckp#1)',SQLCA.sqlcode,1)   #No.FUN-660129
#No.FUN-710030 -- begin --
#                 CALL cl_err3("upd","pml_file",tm.pmk01,g_pml[l_i].pml02,SQLCA.sqlcode,"","",1)  #No.FUN-660129
#                 EXIT FOR 
                 IF g_bgerr THEN
                    LET g_showmsg = tm.pmk01,"/",g_pml[l_i].pml02
                    CALL s_errmsg("pml01,pml02",g_showmsg,"(ckp#1)",SQLCA.sqlcode,1)
                    CONTINUE FOR
                 ELSE
                    CALL cl_err3("upd","pml_file",tm.pmk01,g_pml[l_i].pml02,SQLCA.sqlcode,"","(ckp#1)",1)
                    EXIT FOR
                 END IF
#No.FUN-710030 -- end --
              END IF
           END IF
        END IF
    END FOR
#No.FUN-710030 -- begin --
    IF g_totsuccess="N" THEN
       LET g_success="N"
    END IF
    CALL s_showmsg()
#No.FUN-710030 -- end --
 
    SELECT COUNT(*) INTO l_n FROM pml_file
     WHERE pml01 = tm.pmk01 AND pml16 != '9' 
 
    IF l_n = 0 THEN
       UPDATE pmk_file SET pmk25='9',
                           pmk26=tm.pmk26,
                           pmk27=tm.pmk27,
                           pmkmodu=g_user,
                           pmkacti='N',
                           pmkdate=TODAY,
                           pmk18='X'        #MOD-C10115 add
        WHERE pmk01 = tm.pmk01
       IF SQLCA.sqlcode THEN
          LET g_success = 'N'
#         CALL cl_err('(ckp#3)',SQLCA.sqlcode,1)   #No.FUN-660129
          CALL cl_err3("upd","pmk_file",tm.pmk01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
       END IF
    END IF
 
END FUNCTION
 
FUNCTION p453_show()   #顯示己取消之請購單項次及版本
  DEFINE l_i   LIKE type_file.num5        #No.FUN-680136 SMALLINT
 
  CALL cl_getmsg('mfg3114',g_lang) RETURNING g_msg
  OPEN WINDOW p453_w3 AT 16,20 WITH 3 ROWS,40 COLUMNS 
#       ATTRIBUTES(BORDER,RED)    #FUN-9B0067
 #DISPLAY g_msg AT 1,1  #CHI-A70049 mark
  CALL cl_getmsg('mfg3087',g_lang) RETURNING g_msg
 #DISPLAY g_msg AT 3,4  #CHI-A70049 mark
  CALL cl_getmsg('mfg3115',g_lang) RETURNING g_msg
 #DISPLAY g_msg AT 3,20 #CHI-A70049 mark
 
 #FOR l_i = 1 TO g_pml.getLength()                             #CHI-A70049 mark
     #IF g_pml[l_i].sure = 'Y' AND g_pml16_d[l_i] != '9' THEN  #CHI-A70049 mark
        #DISPLAY g_pml[l_i].pml02 AT 3,10                      #CHI-A70049 mark
     #END IF                                                   #CHI-A70049 mark
 #END FOR                                                      #CHI-A70049 mark
  CLOSE WINDOW p453_w3 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
