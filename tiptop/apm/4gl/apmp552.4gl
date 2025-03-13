# Prog. Version..: '5.30.06-13.04.10(00010)'     #
#
# Pattern name...: apmp552.4gl
# Descriptions...: 採購單重新開啟作業(含委外)
# Input parameter: 
# Return code....: 
# Date & Author..: 91/09/27 By Wu 
# Modify.........: No.MOD-550029 05/05/06 By Carol 委外工單的委外採購單不可單獨開啟
#                                                  應由asfp410處理
# Modify.........: No.FUN-660129 06/06/19 By Wujie cl_err --> cl_err3
# Modify.........: No.FUN-660216 06/07/10 By Rainy CALL cl_cmdrun()中的程式如果是"p"或"t"，則改成CALL cl_cmdrun_wait()
# Modify.........: No.FUN-680136 06/08/31 By Jackho 欄位類型修改
# Modify.........: No.FUN-6B0032 06/11/16 By Czl 增加雙檔單頭折疊功能
# Modify.........: No.FUN-710030 07/01/19 By johnray 錯誤訊息匯總顯示修改
# Modify.........: No.MOD-750150 07/05/31 By claire 排除委外採購單以採購單頭SUB為判斷依據
# Modify.........: No.CHI-910004 09/08/17 By lutingting開放可處理委外采購單取消結案 
# Modify.........: No.MOD-980237 09/08/27 By mike 取消結案，但結案量未更新成0 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-A20023 10/02/03 By Dido 應排除多角單據 
# Modify.........: No:MOD-B50246 11/06/15 By Summer 還原MOD-A20023,要是多角且已拋轉的單據才可執行
# Modify.........: No:MOD-BB0263 12/02/23 By Vampire 確認碼為Y已確認,且狀況碼為2發出採購單、6結案者才可做結案還原,單身只要有一筆是未結案的,單頭狀況碼就會是2發出採購單
# Modify.........: No:MOD-C20197 12/02/23 By Vampire 由系統產生的pmm905是null值
# Modify.........: No:TQC-C80041 12/08/06 By zhuhao 修改pmm01的控制邏輯
# Modify.........: No:CHI-CA0037 12/11/30 By Elise 單身為製程委外,將委外加工量加回,並確認回加後total數量不會超出WIP量
# Modify.........: No:18010101    by shawn    增加SCM开启结案接口 

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm RECORD
          pmm01 LIKE pmm_file.pmm01,   #採購單號
          pmm09 LIKE pmm_file.pmm09,   #廠商編號
          y     LIKE type_file.chr1    #已開啟資料是否顯示 #No.FUN-680136 VARCHAR(1)
          END RECORD,
        g_pmn DYNAMIC ARRAY OF RECORD
            sure     LIKE type_file.chr1,     # 確定否   #No.FUN-680136 VARCHAR(1)
            pmn02    LIKE pmn_file.pmn02,     # 項次
            pmn04    LIKE pmn_file.pmn04,     # 料號
            pmn011   LIKE pmn_file.pmn011,    # 性質
            pmn16    LIke pmn_file.pmn16,     # 狀況碼
            pmn16_d  LIKE ze_file.ze03        # 目前狀況 #No.FUN-680136 VARCHAR(15)
        END RECORD,
        g_cmd        LIKE type_file.chr1000,  #No.FUN-680136 VARCHAR(60)
        g_rec_b      LIKE type_file.num5,     #No.FUN-680136 SMALLINT
        l_update_sw  LIKE type_file.chr1,     #No.FUN-680136 VARCHAR(1)
        l_ac         LIKE type_file.num5      #No.FUN-680136 SMALLINT
DEFINE  g_error      LIKE type_file.chr1      #No.FUN-680136 VARCHAR(1)
DEFINE  g_cnt        LIKE type_file.num10     #No.FUN-680136 INTEGER
DEFINE  l_pmm02       LIKE pmm_file.pmm02     #CHI-910004                                                                             
DEFINE  l_sfb04       LIKE sfb_file.sfb04     #CHI-910004 
 
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
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 

   CALL p552_tm()				# 
   CLOSE WINDOW p552_w

   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION p552_tm()
   DEFINE p_row,p_col	LIKE type_file.num5,       #No.FUN-680136 SMALLINT 
          l_pmm09       LIKE pmm_file.pmm09,
          l_pmc03       LIKE pmc_file.pmc03
   DEFINE l_pmn09       LIKE pmn_file.pmn09,
          l_pmn20       LIKE pmn_file.pmn20,
          l_pmn50       LIKE pmn_file.pmn20,
          l_pmn55       LIKE pmn_file.pmn55,
          l_no          LIKE type_file.num5,       #No.FUN-680136 SMALLINT
          g_sta         LIKE type_file.chr1        #No.FUN-680136 VARCHAR(1)
#No.18010101   #add closePurchaseOrder interface  -- begin --  
   DEFINE l_data DYNAMIC ARRAY OF RECORD 
                poNo        LIKE pmn_file.pmn01,
                serNo       LIKE pmn_file.pmn02,
                groupCode   LIKE type_file.chr100,
                sta      LIKE type_file.chr1
                 END RECORD 
   DEFINE l_j    LIKE type_file.num5 
   DEFINE l_ret        RECORD
             success   LIKE type_file.chr1,
             code      LIKE type_file.chr10,
             msg       STRING
                       END RECORD
   DEFINE  l_return_msg  STRING 
   #No.18010101 --end 
   LET p_row = 2 LET p_col = 19
 
   OPEN WINDOW p552_w AT p_row,p_col WITH FORM "apm/42f/apmp552" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
   CALL cl_opmsg('z')
   IF s_shut(0) THEN RETURN END IF
 
   WHILE TRUE
     CLEAR FORM 
     CALL g_pmn.clear()
     INITIALIZE tm.* TO NULL			# Default condition
     LET tm.y = 'N'
 
     ERROR ''
     CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
     INPUT BY NAME tm.pmm01,tm.y    WITHOUT DEFAULTS 
  
        AFTER FIELD pmm01            #採購單號
           IF NOT cl_null(tm.pmm01) THEN
              CALL p552_pmm01()
 #MOD-BB0263 ----- remark start -----
 #No.CHI-910004--mark--str--  
 #MOD-550029
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(tm.pmm01,g_errno,1)
                NEXT FIELD pmm01
             END IF
 #No.CHI-910004--mark--end 
 #MOD-BB0263 -----  remark end  -----
           END IF
 
        AFTER FIELD y               #已開啟資料是否顯示
           IF NOT cl_null(tm.y) THEN 
              IF tm.y NOT MATCHES "[YNyn]"  THEN 
                 NEXT FIELD y 
              END IF
           END IF
  
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(pmm01) #單號
                CALL q_pmm2(FALSE,TRUE,tm.pmm01,'26') RETURNING tm.pmm01
#               CALL FGL_DIALOG_SETBUFFER( tm.pmm01 )
                DISPLAY tm.pmm01 TO pmm01 
                CALL p552_pmm01()
                NEXT FIELD pmm01
             OTHERWISE EXIT CASE
          END CASE
        
        ON ACTION qry_po_detail
           #CALL cl_cmdrun("apmt540 ")      #FUN-660216 remark
           CALL cl_cmdrun_wait("apmt540 ")  #FUN-660216 add
  
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
     
     LET g_success='Y'
     CALL p552_b_fill()
     IF g_success = 'N' THEN
        CONTINUE WHILE 
     END IF
     CALL  p552_sure()         #確定否
     IF INT_FLAG THEN 
        LET INT_FLAG = 0 
        CONTINUE WHILE 
     END IF 
 
     IF cl_sure(0,0) THEN 
        LET l_update_sw = 'n'  #當單身有一筆開啟則單頭必需開啟
        CALL s_showmsg_init()        #No.FUN-710030
         #NO.18010101  --begin ---
         INITIALIZE l_ret TO NULL
         LET l_j = 1
         LET l_return_msg = " "
         #NO.18010101   --END
        FOR l_no = 1 TO g_rec_b
#No.FUN-710030 -- begin --
        IF g_success="N" THEN
           LET g_totsuccess="N"
           LET g_success="Y"
        END IF
#No.FUN-710030 -- end --
            IF g_pmn[l_no].sure = 'Y' THEN  
               #CHI-910004--mod--str--    #若委外采購單對應工單已結案,則委外采購單不可取消結案                                      
               SELECT pmm02 INTO l_pmm02 FROM pmm_file                                                                              
                WHERE pmm01 = tm.pmm01                                                                                              
               IF l_pmm02 = 'SUB' THEN    #為委外采購單                                                                             
                  SELECT sfb04 INTO l_sfb04 FROM sfb_file,pmn_file,pmm_file                                                         
                   WHERE sfb01 = pmn41                                                                                              
                     AND pmm01 = pmn01                                                                                              
                     AND pmm01 = tm.pmm01                                                                                           
                     AND pmn02 = g_pmn[l_no].pmn02                                                                                  
                  IF l_sfb04 = '8' THEN   #工單已結案                                                                               
                     LET g_success = 'N'                                                                                            
                     IF g_bgerr THEN                                                                                                
                        CALL s_errmsg('pmn01',tm.pmm01,'','apm-308',1)                                                              
                        CONTINUE FOR                                                                                                
                     ELSE                                                                                                           
                        CALL cl_err3("","pmn_file",tm.pmm01,g_pmn[l_no].pmn02,'apm-308',"","",1)                                    
                     END IF                                                                                                         
                  END IF                                                                                                            
               END IF                                                                                                               
               #CHI-910004--mod--end 
               UPDATE pmn_file SET pmn16 = '2', #MOD-980237 add ,                                                                   
                                   pmn57 = 0    #MOD-980237 
                WHERE pmn01 = tm.pmm01 
                  AND pmn02 = g_pmn[l_no].pmn02 
               IF SQLCA.sqlcode THEN 
                  LET g_success='N' 
#                 CALL cl_err('(p552:ckp#2)',SQLCA.sqlcode,1)   #No.FUN-660129
#No.FUN-710030 -- begin --
#                  CALL cl_err3("upd","pmn_file",tm.pmm01,g_pmn[l_no].pmn02,SQLCA.sqlcode,"","(p552:ckp#2)",1)  #No.FUN-660129
#                  EXIT FOR
                  IF g_bgerr THEN
                     LET g_showmsg = tm.pmm01,"/",g_pmn[l_no].pmn02
                     CALL s_errmsg("pmn01,pmn02",g_showmsg,"(p552:ckp#2)",SQLCA.sqlcode,1)
                     CONTINUE FOR
                  ELSE
                     CALL cl_err3("upd","pmn_file",tm.pmm01,g_pmn[l_no].pmn02,SQLCA.sqlcode,"","(p552:ckp#2)",1)
                     EXIT FOR
                  END IF
#No.FUN-710030 -- begin --
	               #No.18010101   #add closePurchaseOrder interface  -- begin --  
	               ELSE
	                   LET l_data[l_j].poNo = tm.pmm01
	                   LET l_data[l_j].serNo = g_pmn[l_no].pmn02
	                   LET l_data[l_j].sta = '2'
	                   LET l_data[l_j].groupCode = g_plant
	                   LET l_j = l_j + 1
	               #No.18010101 --end
               END IF
               LET l_update_sw = 'y'
             # MODIFY BY MAY 92/01/10
               SELECT pmn20,pmn50,pmn55,pmn09
                 INTO l_pmn20,l_pmn50,l_pmn55,l_pmn09
                 FROM pmn_file WHERE pmn01 = tm.pmm01 AND 
                                   pmn02 = g_pmn[l_no].pmn02
               IF SQLCA.sqlcode THEN     
                  LET l_pmn09 = 1 LET l_pmn20 = 0
                  LET l_pmn50 = 0 
                  LET l_pmn55 = 0
              END IF  
            END IF  
        END FOR 
#NO.18010101  --BEGIN --
         IF cl_getscmparameter() THEN
	         FOR l_no=1 TO l_j-1
	             CALL cjc_zmx_json_closepmnorder(l_data[l_no].poNo,l_data[l_no].serNo,l_data[l_no].sta) RETURNING l_ret.* 
	             IF l_ret.success <> 'Y' THEN
	                 LET l_return_msg = l_return_msg,"   ",l_data[l_no].poNo CLIPPED,"/",l_data[l_no].serNo CLIPPED
	             END IF
	         END FOR 
	        IF NOT cl_null(l_return_msg) THEN 
	            LET l_return_msg = l_return_msg,"同步失败"
	            CALL cl_err(l_return_msg,'!',1)
	        END IF
        END IF  
         #NO.18010101  ---END --- 
#No.FUN-710030 -- begin --
        IF g_totsuccess="N" THEN
           LET g_success="N"
        END IF
        CALL s_showmsg()
#No.FUN-710030 -- end --
 
 
        IF l_update_sw = 'y' THEN             #當單身有一筆開啟則單頭必需開啟
           CALL p552_ecm321()     #CHI-CA0037 add
           UPDATE pmm_file SET pmm25 = '2',   #update 單頭狀況碼
                               pmm27 = g_today
                              WHERE pmm01 = tm.pmm01
           IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN 
#             CALL cl_err('cannot update pmm_file',SQLCA.sqlcode,1)   #No.FUN-660129
              CALL cl_err3("upd","pmm_file",tm.pmm01,"",SQLCA.sqlcode,"","cannot update pmm_file",1)  #No.FUN-660129
              EXIT WHILE
           END IF
        END IF
 
     END IF
 
   END WHILE
 
   ERROR ""
 
END FUNCTION

#CHI-CA0037---add---S
FUNCTION p552_ecm321()
   DEFINE l_pmn41       LIKE pmn_file.pmn41,
          l_cnt         LIKE type_file.num5,
          l_pmn20       LIKE pmn_file.pmn20,
          l_pmn50       LIKE pmn_file.pmn20,
          l_pmn55       LIKE pmn_file.pmn55,
          l_pmn012      LIKE pmn_file.pmn012,
          l_pmn43       LIKE pmn_file.pmn43,
          l_no          LIKE type_file.num5,
          l_ecm321      LIKE ecm_file.ecm321,
          l_ecm301      LIKE ecm_file.ecm301,
          l_new_ecm321  LIKE ecm_file.ecm321

    FOR l_no = 1 TO g_rec_b
       SELECT pmn20,pmn50,pmn55,pmn012,pmn41,pmn43
         INTO l_pmn20,l_pmn50,l_pmn55,l_pmn012,l_pmn41,l_pmn43
         FROM pmn_file
        WHERE pmn01 = tm.pmm01 AND pmn02 = g_pmn[l_no].pmn02

       SELECT ecm321,ecm301 INTO l_ecm321,l_ecm301 FROM ecm_file
        WHERE ecm01 = l_pmn41
          AND ecm012= l_pmn012 AND ecm03 = l_pmn43

       SELECT COUNT(*) INTO l_cnt FROM ecm_file WHERE ecm01=l_pmn41
       IF l_cnt>0 THEN
          LET l_new_ecm321 = l_ecm321 + (l_pmn20-l_pmn50+l_pmn55)
          IF l_new_ecm321 > l_ecm301 THEN
             LET g_success ='N'
             CALL cl_err(tm.pmm01,'asf0047',1)
             RETURN
          ELSE
             UPDATE ecm_file SET ecm321 = ecm321 + (l_pmn20-l_pmn50+l_pmn55)
              WHERE ecm01 = l_pmn41
                AND ecm012= l_pmn012
                AND ecm03 = l_pmn43
          END IF
       END IF
    END FOR

END FUNCTION
#CHI-CA0037---add---E
 
FUNCTION p552_pmm01()
   DEFINE l_pmm09  LIKE pmm_file.pmm09,
          l_pmc03  LIKE pmc_file.pmc03,
          l_cnt    LIKE type_file.num5          #No.FUN-680136 SMALLINT
   DEFINE l_pmm25  LIKE pmm_file.pmm25          #MOD-BB0263 add
   DEFINE l_count  LIKE type_file.num5   #TQC-C80041 add

   LET g_errno=''
#TQC-C80041 -- add -- begin
   LET l_count = 0
   SELECT COUNT(pmm01) INTO l_count FROM pmm_file,pmn_file
    WHERE pmm01 = tm.pmm01 AND pmm01 = pmn01
      AND pmmacti IN ('y','Y') AND pmm18 <> 'X'
      AND pmm25 IN ('2','6')
      AND pmn16 IN ('6','7','8')
   IF l_count = 0 THEN
      LET g_errno = 'apm1080'
      RETURN
   END IF
#TQC-C80041 -- add -- end
   #SELECT pmm09 INTO l_pmm09 FROM pmm_file              #MOD-BB0263 mark
   SELECT pmm09,pmm25 INTO l_pmm09,l_pmm25 FROM pmm_file #MOD-BB0263 add
    WHERE pmm01 = tm.pmm01
     #AND pmm25 IN ('2','6')                 #MOD-BB0263 mark
     #AND pmm02 NOT IN ('TRI','TAP')         #MOD-A20023 #MOD-B50246 mark 
     #AND pmm905 != 'Y'    #MOD-B50246 add   #MOD-C20197 mark
      AND (pmm905 != 'Y' OR pmm905 IS NULL)  #MOD-C20197 add
   IF SQLCA.sqlcode THEN
      # LET g_errno='mfg3058'   #MOD-550029  #CHI-910004
      LET g_errno='mfg3207'     #MOD-BB0263 add
      LET l_pmm09=NULL
      LET l_pmc03=NULL
   ELSE
      #MOD-BB0263 ----- start -----
      IF l_pmm25 NOT MATCHES '[26]' THEN
          LET g_errno='mfg3208'
      END IF
      #MOD-BB0263 -----  end  -----
      SELECT pmc03 INTO l_pmc03 FROM pmc_file
       WHERE pmc01 = l_pmm09
      DISPLAY l_pmm09 TO FORMONLY.pmm09
      DISPLAY l_pmc03 TO FORMONLY.pmc03
 
 #MOD-550029
 
 #No.CHI-910004--mark--str-- 
 ##MOD-750150-begin-modify
 #      LET l_cnt = 0
 ##     SELECT COUNT(*) INTO l_cnt FROM pmn_file
 ##      WHERE pmn01 = tm.pmm01
 ##        AND NOT ( pmn41 IS NULL OR pmn41 = ' ' )
 #      SELECT COUNT(*) INTO l_cnt FROM pmm_file
 #       WHERE pmm01 = tm.pmm01
 #         AND pmm02 = 'SUB'
 #     IF l_cnt > 0 THEN
 #        LET g_errno = 'apm-109'
 #     END IF
 #MOD-750150-end-modify
##
 #No.CHI-910004--mark--end  
   END IF
END FUNCTION
 
FUNCTION p552_b_fill()
   DEFINE l_pmn09       LIKE pmn_file.pmn09,
          l_pmn20       LIKE pmn_file.pmn20,
          l_pmn50       LIKE pmn_file.pmn20,
          l_pmn55       LIKE pmn_file.pmn55,
          l_cnt         LIKE type_file.num10,    # No.FUN-680136 INTEGER
          l_wc  	LIKE type_file.chr1000,  # RDSQL STATEMENT  #No.FUN-680136 VARCHAR(200)
          l_sql 	LIKE type_file.chr1000   # RDSQL STATEMENT  #No.FUN-680136 VARCHAR(600)
 
     LET l_sql= " SELECT 'N',pmn02,pmn04,pmn011,pmn16,' ' ",
                # "  FROM pmn_file,pmm_file "   #MOD-750150 add pmm_file  #CHI-910004 mark 
                "   FROM pmn_file "             #CHI-910004 add 
     IF tm.y matches '[Yy]' THEN 
        LET l_wc = "  WHERE pmn01 = '",tm.pmm01,"' ",
                  #"    AND ( pmn41 IS NULL OR pmn41 = ' ' ) ", #MOD-550029 add   #MOD-750150 mark
                  # "    AND pmm01 = pmn01 AND pmm02 <> 'SUB' ", #MOD-750150 add  #CHI-910004 mark
                   "  ORDER BY pmn02 "
     ELSE 
        LET l_wc = "  WHERE pmn01 = '",tm.pmm01,"' AND ",
                   "  pmn16 IN ('6','7','8') ",
                  #"    AND ( pmn41 IS NULL OR pmn41 = ' ' ) ", #MOD-550029 add  #MOD-750150 mark
                  # "    AND pmm01 = pmn01 AND pmm02 <> 'SUB' ", #MOD-750150 add #CHI-910004 mark
                   "  ORDER BY pmn02 "
     END IF
     LET l_sql = l_sql clipped, l_wc clipped
     PREPARE p552_prepare FROM l_sql
     IF SQLCA.sqlcode THEN 
        CALL cl_err('cannot prepare ',SQLCA.sqlcode,1) 
        LET g_success = 'N'
        RETURN
     END IF
 
     DECLARE p552_cur CURSOR FOR p552_prepare
     IF SQLCA.sqlcode THEN 
        CALL cl_err('cannot declare ',SQLCA.sqlcode,1) 
        LET g_success = 'N'
        RETURN
     END IF
 
     LET l_ac = 1
     LET g_rec_b = 0
     LEt l_cnt = 0 
     FOREACH p552_cur INTO g_pmn[l_ac].*
       IF SQLCA.sqlcode THEN 
          CALL cl_err('cannot foreach ',SQLCA.sqlcode,1) 
          LET g_success = 'N'
          EXIT FOREACH
       END IF
 
       CALL s_pmmsta('pmm',g_pmn[l_ac].pmn16,' ',' ') 
              RETURNING g_pmn[l_ac].pmn16_d
 
       LET l_ac = l_ac + 1
       IF l_ac > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
     END FOREACH
     CALL g_pmn.deleteElement(l_ac)
 
 
     LET g_rec_b=l_ac - 1
     DISPLAY g_rec_b TO FORMONLY.cn2  
     DISPLAY l_cnt   TO FORMONLY.cn3
 
     IF g_rec_b = 0 THEN     #單身無資料
        CALL cl_err(tm.pmm01,'mfg0039',1) 
       #LET g_success = 'Y'     #TQC-C80041 mark
        LET g_success = 'N'     #TQC-C80041
     END IF
 
     DISPLAY ARRAY g_pmn TO s_pmn.* ATTRIBUTE(COUNT = g_rec_b,UNBUFFERED)
       BEFORE DISPLAY
         EXIT DISPLAY 
     END DISPLAY 
 
END FUNCTION
   
FUNCTION p552_sure()
    DEFINE l_cnt,l_i        LIKE type_file.num5          #No.FUN-680136 SMALLINT 
    DEFINE l_ac             LIKE type_file.num5,         #No.FUN-680136 SMALLINT
           l_allow_insert   LIKE type_file.num5,         #可新增否 #No.FUN-680136 SMALLINT
           l_allow_delete   LIKE type_file.num5          #No.FUN-680136 SMALLINT
 
    LET l_allow_insert = FALSE
    LET l_allow_delete = FALSE 
 
    LET l_ac = 1
    INPUT ARRAY g_pmn WITHOUT DEFAULTS FROM s_pmn.*
       ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                 INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
       BEFORE INPUT
          FOR l_i = 1 TO g_rec_b     #將所有的設為選擇
              LET g_pmn[l_i].sure="Y"
          END FOR
 
       BEFORE ROW
          LET l_ac = ARR_CURR()
 
       AFTER FIELD sure
          IF NOT cl_null(g_pmn[l_ac].sure) THEN
             IF g_pmn[l_ac].sure NOT MATCHES "[YN]" THEN
                NEXT FIELD sure
             END IF
             LET l_cnt = 0 
             FOR l_i = 1 TO g_rec_b 
                 IF g_pmn[l_ac].sure = 'Y' THEN
                    LET l_cnt = l_cnt + 1
                 END IF
             END FOR
             DISPLAY l_cnt TO FORMONLY.cn3
          END IF
 
       ON ACTION select_all           
          FOR l_i = 1 TO g_rec_b     #將所有的設為選擇
              LET g_pmn[l_i].sure="Y"
          END FOR
          LET l_cnt = g_rec_b
          DISPLAY g_rec_b TO FORMONLY.cn3 
 
       ON ACTION cancel_all
          FOR l_i = 1 TO g_rec_b      #將所有的設為取消
              LET g_pmn[l_i].sure="N"
          END FOR
          LET l_cnt = 0
          DISPLAY 0 TO FORMONLY.cn3
 
       AFTER ROW
         IF INT_FLAG THEN 
            EXIT INPUT
         END IF 
 
       AFTER INPUT
          LET l_cnt = 0
          FOR l_i =1 TO g_rec_b
             IF g_pmn[l_i].sure = 'Y' AND 
                NOT cl_null(g_pmn[l_i].pmn02)  THEN
                LET l_cnt = l_cnt + 1
             END IF
          END FOR
          DISPLAY l_cnt TO FORMONLY.cn3 
   
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
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
 
    END INPUT
 
END FUNCTION
