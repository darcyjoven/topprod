# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: acop400.4gl
# Descriptions...: 模擬合同轉入合同作業
# Date & Author..: 03/04/17 By Carrier
# Modify.........: No.MOD-490371 04/09/23 By Kitty Controlp 未加display
# Modify.........: No.MOD-490398 04/11/27 By Carrier
# Modify.........: No.FUN-550036 05/05/23 By Trisy 單據編號加大
# Modify.........: NO.FUN-560002 05/06/06 By jackie 單據編號修改
# Modify.........: No.TQC-660045 06/06/12 By hellen cl_err --> cl_err3
# Modify.........: No.TQC-670008 06/07/04 By rainy 權限修正
# MOdify.........: No.FUN-680069 06/08/23 By Czl  類型轉換
# Modify.........: No.FUN-690109 06/10/16 By johnray cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By Jackho 本（原）幣取位修改
# Modify.........: No.FUN-6A0063 06/10/26 By czl l_time轉g_time
# Modify.........: No.FUN-6B0033 06/11/16 By Carrier 新增單頭折疊功能
# Modify.........: No.FUN-980002 09/08/05 By TSD.SusanWu GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B90075 11/09/15 By zhangll 單號控管改善
# Modify.........: No.FUN-910088 12/01/13 By chenjing 增加數量欄位小數取位
# Modify.........: No.CHI-C80041 12/12/19 By bart 排除作廢
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   
    g_rec_b         LIKE type_file.num5,                #單身筆數               #No.FUN-680069 SMALLINT
    g_cng           RECORD LIKE cng_file.*,
    g_coc           RECORD LIKE coc_file.*,
    tm              RECORD                                                      
        cng01       LIKE cng_file.cng01,
        curr        LIKE azi_file.azi01,  #No.FUN-680069 VARCHAR(4)
        coc10       LIKE coc_file.coc10,  #No.MOD-490398
        choice      LIKE type_file.chr1,         #No.FUN-680069 VARCHAR(1)
        coc01       LIKE coc_file.coc01,  
        coc03       LIKE coc_file.coc03, 
        coc04       LIKE coc_file.coc04,
        coc05       LIKE coc_file.coc05,  
        coc06       LIKE coc_file.coc06  
                    END RECORD,                              
    g_cnh           DYNAMIC ARRAY OF RECORD  
        cnh02       LIKE cnh_file.cnh02, 
        cnh03       LIKE cnh_file.cnh03,  
        ima02       LIKE ima_file.ima02,
        cnh05       LIKE cnh_file.cnh05, 
        cnh06       LIKE cnh_file.cnh06,
        a           LIKE cob_file.cob01,
        d           LIKE cob_file.cob02,
        ver         LIKE cod_file.cod041,
        c           LIKE cnh_file.cnh05,
        e           LIKE cob_file.cob04
                    END RECORD,
    g_cnh_t         RECORD                
        cnh02       LIKE cnh_file.cnh02, 
        cnh03       LIKE cnh_file.cnh03,
        ima02       LIKE ima_file.ima02,
        cnh05       LIKE cnh_file.cnh05,   
        cnh06       LIKE cnh_file.cnh06,  
        a           LIKE cob_file.cob01,
        d           LIKE cob_file.cob02,
        ver         LIKE cod_file.cod041,
        c           LIKE cnh_file.cnh05,
        e           LIKE cob_file.cob04
                    END RECORD,
    l_exit          LIKE type_file.chr1,         #No.FUN-680069 VARCHAR(1)   #目前處理的ARRAY CNT
    l_sql           LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(300)
    g_coytype       LIKE coy_file.coytype,
    l_ac            LIKE type_file.num5,                #目前處理的ARRAY CNT        #No.FUN-680069 SMALLINT
    g_ac            LIKE type_file.num5,         #No.FUN-680069 SMALLINT   #目前處理的ARRAY CNT
    l_sl            LIKE type_file.num5,         #No.FUN-680069 SMALLINT   #目前處理的SCREEN LINE
    p_row,p_col     LIKE type_file.num5          #No.FUN-680069 SMALLINT
 
DEFINE   g_cnt      LIKE type_file.num10            #No.FUN-680069 INTEGER
DEFINE   g_i        LIKE type_file.num5     #count/index for any purpose        #No.FUN-680069 SMALLINT
DEFINE   g_msg      LIKE type_file.chr1000       #No.FUN-680069 VARCHAR(72)
 
MAIN
#     DEFINE    l_time LIKE type_file.chr8       #No.FUN-6A0063
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ACO")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690109
 
 
    LET p_row = 4 LET p_col = 13
 
    OPEN WINDOW p400_w AT p_row,p_col WITH FORM "aco/42f/acop400" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
    CALL cl_opmsg('b')
    CALL p400_t()
    CLOSE WINDOW p400_w                #結束畫面
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
END MAIN
 
FUNCTION p400_t()
  DEFINE l_i,l_n     LIKE type_file.num5          #No.FUN-680069 SMALLINT
  DEFINE l_coyslip   LIKE aba_file.aba00      #No.FUN-560002
  DEFINE li_result   LIKE type_file.num5          #No.FUN-550036         #No.FUN-680069 SMALLINT
 
  LET l_exit   = 'n'
  WHILE TRUE
    CLEAR FORM 
   CALL g_cnh.clear()
    IF s_shut(0) THEN EXIT WHILE END IF
    INITIALIZE tm.* TO NULL
    LET tm.choice='1'
    LET g_coytype='10'   #FUN-B90075 add
     CALL cl_set_head_visible("","YES")  #No.FUN-6B0033
     INPUT BY NAME tm.cng01,tm.curr,tm.choice,tm.coc01,tm.coc10,  #No.MOD-490398
                  tm.coc03,tm.coc04,tm.coc05,tm.coc06
      WITHOUT DEFAULTS 
    
         #No.FUN-550036 --start--                                                                                                   
    BEFORE INPUT
         CALL cl_set_docno_format("coc01")                                                                                          
         #No.FUN-550036 ---end---         
      AFTER FIELD cng01
         IF cl_null(tm.cng01) THEN NEXT FIELD cng01 END IF
         CALL p400_cng01()
         IF NOT cl_null(g_errno) THEN
             CALL cl_err(tm.cng01,g_errno,0) 
             NEXT FIELD cng01
         END IF
 
      AFTER FIELD curr
         IF cl_null(tm.curr) THEN NEXT FIELD curr END IF
         SELECT azi01 FROM azi_file WHERE azi01 = tm.curr
         IF STATUS THEN 
#           CALL cl_err(tm.curr,'mfg3008',0)  #No.TQC-660045
            CALL cl_err3("sel","azi_file",tm.curr,"","mfg3008","","",0) #TQC-660045
            NEXT FIELD curr
         END IF
 
       #No.MOD-490398  --begin
      AFTER FIELD coc10
         IF cl_null(tm.coc10) THEN NEXT FIELD coc10 END IF
         CALL p400_coc10('a')
         IF NOT cl_null(g_errno) THEN
            CALL cl_err(tm.coc10,g_errno,0)
            NEXT FIELD coc10
         END IF
       #No.MOD-490398  --end
         
      AFTER FIELD choice
         IF cl_null(tm.choice) OR tm.choice NOT MATCHES '[12]' THEN
            NEXT FIELD choice
         END IF
         IF tm.choice = '1' THEN LET g_coytype='10' END IF
         IF tm.choice = '2' THEN LET g_coytype='12' END IF
         #FUN-B90075 add
         IF NOT cl_null(tm.coc01) THEN
            CALL s_check_no("aco",tm.coc01,"*",g_coytype,"coc_file","coc01","")  
            RETURNING li_result,tm.coc01                                                   
            DISPLAY BY NAME tm.coc01                                                                                             
            IF (NOT li_result) THEN                                                                                                 
               NEXT FIELD coc01                                                                                                     
            END IF                                                                                                                  
         END IF
         #FUN-B90075 add--end
 
      AFTER FIELD coc01    
#No.FUN-550036 --start--                                                                                                   
        #IF NOT cl_null(g_coc.coc01) THEN                                                                                           
         IF NOT cl_null(tm.coc01) THEN          #FUN-B90075 mod                                                                                 
           #FUN-B90075 mod
           #CALL s_check_no("aco",g_coc.coc01,"*","*","coc_file","coc01","")  
           #RETURNING li_result,g_coc.coc01                                                   
           #DISPLAY BY NAME g_coc.coc01                                                                                             
            CALL s_check_no("aco",tm.coc01,"*",g_coytype,"coc_file","coc01","")
            RETURNING li_result,tm.coc01                                                   
            DISPLAY BY NAME tm.coc01                                                                                             
           #FUN-B90075 mod--end
            IF (NOT li_result) THEN                                                                                                 
               NEXT FIELD coc01                                                                                                     
            END IF                                                                                                                  
            DISPLAY g_smy.smydesc TO smydesc     
 
#        IF NOT cl_null(tm.coc01) THEN
#           LET l_coyslip= tm.coc01[1,3]
#           CALL s_acoslip(l_coyslip,g_coytype,g_sys)       #檢查單別
#           IF NOT cl_null(g_errno) THEN                    #抱歉, 有問題
#              CALL cl_err(l_coyslip,g_errno,0)
#              NEXT FIELD coc01
#           END IF
#           IF tm.coc01[1,3] IS NOT NULL AND                #並且單號空白時,
#    	       cl_null(tm.coc01[5,10]) THEN                 #請用戶自行輸入
#              IF g_coy.coyauno = 'N' THEN                  #新增並要不自動編號
#                 NEXT FIELD coc01
#              ELSE					 #要不, 則單號不用
 #                 NEXT FIELD coc10                       #輸入  #No.MOD-490398
# 	       END IF
#           END IF
#           IF tm.coc01[1,3] IS NOT NULL AND	         #並且單號空白時,
#              NOT cl_null(tm.coc01[5,10]) THEN	         #請用戶自行輸入
#              IF NOT cl_chk_data_continue(tm.coc01[5,10]) THEN
#                 CALL cl_err('','9056',0)
#                 NEXT FIELD coc01
#              END IF
#           END IF
#No.FUN-550036 --end--                                                                                                   
#No.FUN-560002 --start--
#            SELECT COUNT(*) INTO l_n FROM coc_file
#             WHERE coc01 = tm.coc01
#            IF l_n > 0 THEN   #單據編號重複
#               CALL cl_err(tm.coc01,-239,0)
#               NEXT FIELD coc01
#            END IF
#No.FUN-560002 ---end--
         END IF
 
       #No.MOD-490398
      AFTER FIELD coc03
         IF NOT cl_null(tm.coc03) THEN 
            IF tm.choice = '2' THEN
               LET l_i = 0
               SELECT unique coc04,coc05,coc06 INTO tm.coc04,tm.coc05,tm.coc06
                 FROM coc_file
                WHERE coc03 = tm.coc03
               IF SQLCA.sqlcode = 100 THEN 
#                 CALL cl_err(tm.coc03,'aco-062',0)  #No.TQC-660045
                  CALL cl_err3("sel","coc_file",tm.coc03,"","aco-062","","",0) #TQC-660045
                  NEXT FIELD coc03          
               ELSE      
                  LET g_success = 'Y'
                  CALL p400_coc03()
                  IF g_success = 'N' THEN
                     CALL cl_err('','aco-178',0)
                     NEXT FIELD cng01
                  END IF 
                  DISPLAY BY NAME tm.coc04
                  DISPLAY BY NAME tm.coc05
                  DISPLAY BY NAME tm.coc06
                  EXIT INPUT
               END IF
            ELSE
              LET l_i = 0
              SELECT COUNT(*) INTO l_i FROM coc_file
               WHERE coc03 = tm.coc03
              IF l_i > 0 THEN
                 CALL cl_err(tm.coc03,-239,0)
                 NEXT FIELD coc03
              END IF
            END IF
         END IF
          #No.MOD-490398  end
        
      AFTER FIELD coc05
         IF NOT cl_null(tm.coc05) AND tm.coc05 < g_today THEN
            NEXT FIELD coc05
         END IF
         
      AFTER INPUT       
        IF INT_FLAG THEN
             LET l_exit   = 'y'
             EXIT INPUT
        END IF
        IF cl_null(tm.cng01) THEN NEXT FIELD cng01 END IF  #重要欄位不可空白
         IF cl_null(tm.coc10) THEN NEXT FIELD coc10 END IF  #No.MOD-490398
        IF cl_null(tm.coc01) THEN NEXT FIELD coc01 END IF
        IF cl_null(tm.coc04) THEN NEXT FIELD coc04 END IF
        IF cl_null(tm.coc03) THEN NEXT FIELD coc03 END IF
         #No.MOD-490398  --begin
        #LET g_success = 'Y'
        #CALL p400_b()
        #IF g_success = 'Y' THEN
        #   CALL p400_go_next()
        #END IF
         #No.MOD-490398  --end
 
      ON ACTION CONTROLP
         CASE
         WHEN INFIELD(cng01) 
#             CALL q_cng(8,3,tm.cng01) RETURNING tm.cng01
#             CALL FGL_DIALOG_SETBUFFER( tm.cng01 )
              CALL cl_init_qry_var()
              LET g_qryparam.form = 'q_cng'
              LET g_qryparam.default1 = tm.cng01
              CALL cl_create_qry() RETURNING tm.cng01
#              CALL FGL_DIALOG_SETBUFFER( tm.cng01 )
              DISPLAY tm.cng01 TO cng01
              NEXT FIELD cng01
         WHEN INFIELD(curr) 
#             CALL q_azi(8,3,tm.curr) RETURNING tm.curr
#             CALL FGL_DIALOG_SETBUFFER( tm.curr )
              CALL cl_init_qry_var()
              LET g_qryparam.form = 'q_azi'
              LET g_qryparam.default1 = tm.curr
              CALL cl_create_qry() RETURNING tm.curr
#              CALL FGL_DIALOG_SETBUFFER( tm.curr )
              DISPLAY BY NAME tm.curr
              NEXT FIELD curr
          #No.MOD-490398  --begin
         WHEN INFIELD(coc10)    #海關代號
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_cna"
                LET g_qryparam.default1 = tm.coc10
                CALL cl_create_qry() RETURNING tm.coc10
                DISPLAY BY NAME tm.coc10
                NEXT FIELD coc10
         WHEN INFIELD(coc03)      #手冊編號                                
              IF tm.choice = '2' THEN
                 CALL q_coc2(FALSE,TRUE,tm.coc03,'',g_today,
                             '0',tm.coc10,'')
                      RETURNING tm.coc03,tm.coc04
                 DISPLAY BY NAME tm.coc03,tm.coc04
                 NEXT FIELD coc03
               END IF
          #No.MOD-490398  --end
         WHEN INFIELD(coc01)
#             LET l_coyslip=tm.coc01[1,3]
             #LET l_coyslip=s_get_doc_no(g_coc.coc01)     #No.FUN-550036      
              LET l_coyslip=s_get_doc_no(tm.coc01)     #No.FUN-550036      #FUN-B90075 mod
#             CALL q_coy(10,3,l_coyslip,g_coytype,g_sys) RETURNING l_coyslip
              #CALL q_coy(FALSE,TRUE,l_coyslip,g_coytype,g_sys) RETURNING l_coyslip   #TQC-670008
              CALL q_coy(FALSE,TRUE,l_coyslip,g_coytype,'ACO') RETURNING l_coyslip    #TQC-670008
#              CALL FGL_DIALOG_SETBUFFER( l_coyslip )
#             LET tm.coc01[1,3]=l_coyslip
              LET tm.coc01 = l_coyslip                 #No.FUN-550036 
              DISPLAY tm.coc01 TO coc01
              NEXT FIELD coc01
         WHEN INFIELD(coc04)        #合同編號
              IF tm.choice = '2' THEN
#                CALL q_coc1(10,3,tm.coc04,tm.cng01) RETURNING tm.coc04 
#                CALL FGL_DIALOG_SETBUFFER( tm.coc04 )
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_coc'
                 LET g_qryparam.default1 = tm.coc04
                 CALL cl_create_qry() RETURNING tm.coc04
#                 CALL FGL_DIALOG_SETBUFFER( tm.coc04 )
                 DISPLAY tm.coc04 TO coc04
                 NEXT FIELD coc04
              END IF
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
 
 
       ON ACTION locale
          CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
       ON ACTION exit
          LET g_action_choice='exit'
          EXIT WHILE
    
    END INPUT
     #No.MOD-490398  --begin
    IF INT_FLAG THEN
        LET INT_FLAG = 0 
        EXIT WHILE
    END IF
    LET g_success = 'Y'
    CALL p400_b()
    IF g_success = 'Y' THEN
       CALL p400_go_next()
    END IF
     #No.MOD-490398  --end
    IF l_exit = 'n' THEN 
       CALL g_cnh.clear()
       CALL p400_b_fill()              #單身填充
    ELSE
       EXIT WHILE
    END IF
  END WHILE
END FUNCTION
 
FUNCTION p400_go_next()
        IF cl_sure(0,0) THEN
           LET g_success ='Y'
           BEGIN WORK
           CALL p400_process()
           IF g_success='Y' THEN                                          
               COMMIT WORK                                                
               IF tm.choice = '1' THEN
                  IF cl_confirm('aco-175') THEN  
                     LET g_msg="acoi300 ","'",tm.coc01,"'"                   
                     CALL cl_cmdrun_wait(g_msg)                                   
                  END IF
               ELSE
                  IF cl_confirm('aco-176') THEN  
                     LET g_msg="acot300 ","'",tm.coc01,"'"                   
                     CALL cl_cmdrun_wait(g_msg)                                   
                  END IF
               END IF
           ELSE                                                           
               ROLLBACK WORK                                              
           END IF                                                         
        END IF
END FUNCTION
 
FUNCTION p400_b_fill()                 #單身填充
    DEFINE l_sql      LIKE type_file.chr1000    #No.FUN-680069 VARCHAR(300)
     #No.MOD-490398
    DEFINE l_coa03    LIKE coa_file.coa03  
    DEFINE l_coa04    LIKE coa_file.coa04 
    DEFINE l_ima25    LIKE ima_file.ima25 
    DEFINE l_sw       LIKE type_file.chr1         #No.FUN-680069 VARCHAR(01)           
    DEFINE l_fac      LIKE bmb_file.bmb10_fac 
     #No.MOD-490398 end
 
     #No.MOD-490398  --begin
    LET l_sql = "SELECT cnh02,cnh03,ima02,cnh05,cnh06,'','','',0,''",
                "  FROM cnh_file,ima_file",
                " WHERE cnh01 = '",tm.cng01,"'",
                "   AND cnh03 = ima01 ",
                " ORDER BY cnh02,cnh03 "
     #No.MOD-490398  --end
    PREPARE p400_prepare FROM l_sql
    MESSAGE " SEARCHING! " 
    DECLARE p400_cur CURSOR FOR p400_prepare
    LET g_cnt = 1
    LET g_ac = 1
    CALL g_cnh.clear()
    FOREACH p400_cur INTO g_cnh[g_ac].*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
        #No.MOD-490398  --begin
       LET g_cnt=0
       SELECT COUNT(*) INTO g_cnt FROM coa_file 
        WHERE coa01=g_cnh[g_ac].cnh03
          AND coa05=tm.coc10
       IF g_cnt=0 THEN CONTINUE FOREACH END IF
       LET l_coa03=NULL
       LET l_coa04=NULL
       IF g_cnt=1 THEN
          SELECT coa03,coa04 INTO l_coa03,l_coa04
            FROM coa_file,cob_file
           WHERE coa01=g_cnh[g_ac].cnh03 AND coa05=tm.coc10
             AND cob01=coa03
       ELSE
          CALL q_coa(FALSE,FALSE,l_coa03,l_coa04,g_cnh[g_ac].cnh03,tm.coc10)
               RETURNING l_coa03,l_coa04
          IF INT_FLAG THEN
             LET INT_FLAG=0
             CONTINUE FOREACH
          END IF
       END IF
       LET g_cnh[g_ac].a=l_coa03
       SELECT ima25 INTO l_ima25 FROM ima_file WHERE ima01=g_cnh[g_ac].cnh03
       SELECT cob02,cob04 INTO g_cnh[g_ac].d,g_cnh[g_ac].e FROM cob_file
        WHERE cob01=l_coa03
       LET l_fac=1
       IF g_cnh[g_ac].cnh06<>l_ima25 THEN
          CALL s_umfchk(g_cnh[g_ac].cnh03,g_cnh[g_ac].cnh06,l_ima25)
                RETURNING l_sw, l_fac    #單位換算
          IF l_sw  = '1'  THEN #有問題
             CALL cl_err(g_cnh[g_ac].cnh03,'abm-731',1)
             LET l_fac = 1
          END IF
       END IF
       LET g_cnh[g_ac].c=g_cnh[g_ac].cnh05*l_fac*l_coa04
       IF cl_null(g_cnh[g_ac].c) THEN LET g_cnh[g_ac].c = 0 END IF
        #No.MOD-490398
       LET g_ac = g_ac + 1
       IF g_ac > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_cnh.deleteElement(g_ac)
    LET g_ac = g_ac - 1 
    DISPLAY g_ac TO FORMONLY.cn2  
    LET g_cnt = 0
    LET g_rec_b = g_ac 
END FUNCTION
 
 #No.MOD-490398
FUNCTION p400_coc10(p_cmd)  #
   DEFINE l_cna02   LIKE cna_file.cna02,
          l_cnaacti LIKE cna_file.cnaacti,
          p_cmd     LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
   LET g_errno = ' '
   SELECT cna02,cnaacti INTO l_cna02,l_cnaacti
     FROM cna_file WHERE cna01 = tm.coc10
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aco-016'
        WHEN l_cnaacti='N'        LET g_errno = '9028'
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   CALL p400_b_fill()
   DISPLAY ARRAY g_cnh TO s_cnh.* ATTRIBUTE(COUNT=g_rec_b)
     BEFORE DISPLAY
        EXIT DISPLAY
   END DISPLAY
  
END FUNCTION
 #No.MOD-490398 end
 
FUNCTION  p400_cng01()    #模擬單號
DEFINE
    l_cnh    LIKE type_file.num5,         #No.FUN-680069 SMALLINT
    l_cnh01  LIKE cnh_file.cnh01
 
    LET g_errno=' '
    SELECT cng_file.* INTO g_cng.* 
        FROM cng_file
        WHERE cng01=tm.cng01
    IF SQLCA.sqlcode THEN
        LET g_errno = 'aco-171' RETURN
    ELSE
        IF g_cng.cngacti = 'N' THEN
           LET g_errno='aco-172' RETURN
        END IF
        IF g_cng.cngconf = 'N' THEN 
           LET g_errno='9029' RETURN
        END IF
        IF NOT cl_null(g_cng.cng10) THEN
           LET g_errno='aco-173' RETURN
        END IF
        SELECT count(*) INTO g_cnt FROM cnh_file
               WHERE cnh01=tm.cng01
        IF g_cnt=0 THEN LET g_errno = 'mfg3111' RETURN END IF
    END IF
 
    LET tm.cng01 = g_cng.cng01
    DISPLAY tm.cng01 TO cng01
     #No.MOD-490398  --bein
    #CALL p400_b_fill()
    #DISPLAY ARRAY g_cnh TO s_cnh.* ATTRIBUTE(COUNT=g_rec_b)
    #  BEFORE DISPLAY
    #     EXIT DISPLAY
    #END DISPLAY
     #No.MOD-490398  --end
 
END FUNCTION
 
FUNCTION p400_process()
 DEFINE li_result   LIKE type_file.num5         #No.FUN-550036        #No.FUN-680069 SMALLINT
 DEFINE l_cnt,l_i   LIKE type_file.num5         #No.FUN-680069 SMALLINT
 DEFINE l_flag      LIKE type_file.num5         #No.FUN-680069 SMALLINT
 DEFINE l_type      LIKE coc_file.coc01
 DEFINE l_coc09     LIKE coc_file.coc09
 DEFINE p_cnh       RECORD LIKE cnh_file.*
 DEFINE l_ima77     LIKE ima_file.ima77     
 DEFINE l_cof03     LIKE cof_file.cof03     
 DEFINE sr1         RECORD LIKE cod_file.*
  DEFINE l_int,l_j  LIKE type_file.num5    #No.MOD-490398        #No.FUN-680069 SMALLINT
 DEFINE sr          RECORD
                    cod02  LIKE cod_file.cod02,
                    cod03  LIKE cod_file.cod03,
                    cod041 LIKE cod_file.cod041, 
                    cod05  LIKE cod_file.cod05,
                    cod06  LIKE cod_file.cod06,
                    cod07  LIKE cod_file.cod07,
                    cod08  LIKE cod_file.cod08,
                    cod10  LIKE cod_file.cod10,
                    cod11  LIKE cod_file.cod11,
                    cod12  LIKE cod_file.cod12
                    END RECORD
 
    #No.MOD-490398  --begin
      #No.FUN-550036 --start--                                                                                                      
   IF cl_null(tm.coc01[g_no_sp,g_no_ep]) THEN 
      CALL s_auto_assign_no("aco",tm.coc01,g_today,g_coytype,"coc_file","coc01","","","") 
        RETURNING li_result,tm.coc01                                                    
      IF (NOT li_result) THEN                                                                                                       
        LET g_success = 'N' 
        RETURN  
      END IF                                                                                                                        
      DISPLAY BY NAME tm.coc01                       
   END IF
#  IF cl_null(tm.coc01[5,10]) THEN
#     CALL s_acoauno(tm.coc01,g_today,g_coytype)
#          RETURNING g_i,tm.coc01                                                  
#     IF g_i THEN LET g_success = 'N' RETURN END IF
#     DISPLAY BY NAME tm.coc01
#  END IF
      #No.FUN-550036 ---end---  
   IF tm.choice = '1' THEN
      INSERT INTO coc_file(coc01,coc02,coc03,coc04,coc05,coc06,
                  coc08,coc09,coc10,cocuser,cocgrup,cocacti,cocdate,cocplant,coclegal,cocoriu,cocorig) #FUN-980002 add cocplant,coclegal
      VALUES (tm.coc01,tm.curr,tm.coc03,tm.coc04,tm.coc05,tm.coc06,
              0,0,tm.coc10,g_user,g_grup,'Y',g_today,g_plant,g_legal, g_user, g_grup)                  #FUN-980002 add g_plant,g_legal      #No.FUN-980030 10/01/04  insert columns oriu, orig
      IF SQLCA.sqlcode THEN LET g_success ='N' RETURN END IF
   ELSE
      INSERT INTO cog_file(cog01,cog02,cog03,cog04,cog05,coguser,
                  coggrup,cogacti,cogdate,cogconf,cogplant,coglegal,cogoriu,cogorig) #FUN-980002 add cogplant,coglegal
      VALUES (tm.coc01,g_today,tm.coc03,0,tm.coc10,g_user,g_grup,'Y',g_today,'N',g_plant,g_legal, g_user, g_grup) #FUN-980002 add g_plant,g_legal      #No.FUN-980030 10/01/04  insert columns oriu, orig
      IF SQLCA.sqlcode THEN LET g_success ='N' RETURN
      END IF
   END IF
   UPDATE cng_file SET cng03=tm.coc03, cng04=tm.coc04,
                       cng10=tm.coc01, cng05=tm.coc05,
                       cng06=tm.coc06, cng12=tm.coc10
    WHERE cng01 = tm.cng01
   IF SQLCA.sqlcode THEN 
#     CALL cl_err('upd npg',STATUS,0)  #No.TQC-660045
      CALL cl_err3("upd","cng_file",tm.cng01,"",STATUS,"","upd npg",0) #TQC-660045
      LET g_success ='N' RETURN 
   END IF
    #No.MOD-490398  --end
  
   DROP TABLE p400_temp  
#No.FUN-680069-begin
   CREATE TEMP TABLE p400_temp(
          cod02 LIKE cod_file.cod02,
          cod03 LIKE cod_file.cod03,
          cod041 LIKE cod_file.cod041,
          cod05 LIKE cod_file.cod05,
          cod06 LIKE cod_file.cod06,
          cod07 LIKE cod_file.cod07,
          cod08 LIKE cod_file.cod08,
          cod10 LIKE cod_file.cod10,
          cod11 LIKE cod_file.cod11,
          cod12 LIKE cod_file.cod12)
#NO.FUN-680069-end
   IF STATUS THEN 
      CALL cl_err('create tmp',STATUS,0) LET g_success = 'N' RETURN 
   END IF
   
   SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = tm.curr        #No.CHI-6A0004 g_azi04-->t_azi04
    #No.MOD-490398  --begin
   LET l_int=1
   FOR l_i = 1 TO g_rec_b
      SELECT cnh_file.* INTO p_cnh.*
        FROM cnh_file,cng_file
       WHERE cng01 = cnh01 AND cng01 = tm.cng01
         AND cnh02 = g_cnh[l_i].cnh02
         AND cngconf <> 'X'  #CHI-C80041
      #取單價
      SELECT cof03 INTO l_cof03 FROM cof_file
       WHERE cof01 = g_cnh[l_i].a AND cof02 = tm.curr
     #IF SQLCA.sqlcode THEN 
     #   CALL cl_err('',SQLCA.sqlcode,0) LET g_success = 'N' RETURN 
     #END IF
      LET sr.cod02 = l_int
      LET sr.cod03 = g_cnh[l_i].a     #Goods No.
      LET sr.cod041= g_cnh[l_i].ver   #version
      LET sr.cod05 = g_cnh[l_i].c     #qty
      LET sr.cod06 = g_cnh[l_i].e     #unit
      LET sr.cod05 = s_digqty(sr.cod05,sr.cod06)    #FUN-910088--add--
      LET sr.cod10 = 0
      LET sr.cod07 = l_cof03
      LET sr.cod08 = sr.cod05*sr.cod07
      LET sr.cod08 = cl_digcut(sr.cod08,t_azi04)                     #No.CHI-6A0004 g_azi04-->t_azi04
      LET sr.cod11 = p_cnh.cnh11
      SELECT cob10 INTO sr.cod11 FROM cob_file WHERE cob01=sr.cod03
      LET sr.cod12 = p_cnh.cnh12
      IF cl_null(sr.cod05) THEN LET sr.cod05 = 0 END IF
      IF cl_null(sr.cod10) THEN LET sr.cod10 = 0 END IF
      IF cl_null(sr.cod07) THEN LET sr.cod07 = 0 END IF
      IF cl_null(sr.cod08) THEN LET sr.cod08 = 0 END IF
      SELECT COUNT(*) INTO l_j FROM p400_temp 
       WHERE cod03=sr.cod03 AND cod041=sr.cod041 
         AND cod06=sr.cod06 AND cod07 =sr.cod07
      IF l_j > 0 THEN   #duplicate
         UPDATE p400_temp SET cod05=cod05+sr.cod05,cod08=cod08+sr.cod08
          WHERE cod03=sr.cod03 AND cod041=sr.cod041 
            AND cod06=sr.cod06 AND cod07 =sr.cod07
         IF SQLCA.sqlcode THEN 
#           CALL cl_err('update p400_temp',SQLCA.sqlcode,0) #No.TQC-660045
            CALL cl_err3("upd","p400_temp","","",SQLCA.sqlcode,"","update p400_temp",0) #TQC-660045
            LET g_success='N'
            RETURN
         END IF
      ELSE
         INSERT INTO p400_temp VALUES (sr.*)
         IF SQLCA.sqlcode THEN 
#           CALL cl_err('insert p400_temp',SQLCA.sqlcode,0) #No.TQC-660045
            CALL cl_err3("ins","p400_temp","","",SQLCA.sqlcode,"","insert p400_temp",0) #TQC-660045
            LET g_success='N' 
            RETURN 
         END IF
         LET l_int=l_int+1
      END IF
   END FOR
    #No.MOD-490398  --end
   IF tm.choice = '1' THEN
       #No.MOD-490398  --begin
      DECLARE p400_cod CURSOR FOR
              SELECT cod02,cod03,cod041,SUM(cod05),cod06,cod07,
                     SUM(cod08),SUM(cod10),cod11,cod12
                FROM p400_temp
               GROUP BY cod02,cod03,cod041,cod06,cod07,cod11,cod12
               ORDER BY cod02,cod03,cod041
       #No.MOD-490398  --end
      LET l_coc09 = 0
      FOREACH p400_cod INTO sr.*
         IF STATUS THEN 
            CALL cl_err('foreach:',STATUS,1) LET g_success='N' EXIT FOREACH 
         END IF
         LET sr1.cod01 = tm.coc01
         LET sr1.cod02 = sr.cod02
         LET sr1.cod03 = sr.cod03
          LET sr1.cod04 = tm.coc10   #No.MOD-490398
          LET sr1.cod041= sr.cod041  #No.MOD-490398
         LET sr1.cod05 = sr.cod05
         LET sr1.cod06 = sr.cod06
         LET sr1.cod07 = sr.cod07
         LET sr1.cod08 = sr.cod08
         LET sr1.cod10 = sr.cod10
         LET sr1.cod11 = sr.cod11
         LET sr1.cod12 = sr.cod12
         LET sr1.cod09 = 0
         LET sr1.cod091= 0
         LET sr1.cod101= 0
         LET sr1.cod102= 0
         LET sr1.cod103= 0
         LET sr1.cod104= 0
         LET sr1.cod105= 0
         LET sr1.cod106= 0
         LET sr1.codplant = g_plant  #FUN-980002
         LET sr1.codlegal = g_legal  #FUN-980002
         INSERT INTO cod_file VALUES (sr1.*)
         IF STATUS THEN 
            CALL cl_err('insert:',STATUS,1) LET g_success='N' RETURN
         END IF
         LET l_coc09 = l_coc09 + sr.cod08
      END FOREACH
      IF cl_null(l_coc09) THEN LET l_coc09 = 0 END IF
      UPDATE coc_file SET coc09 = l_coc09 WHERE coc01 = tm.coc01
      IF STATUS THEN 
#        CALL cl_err('update:',STATUS,1)  #No.TQC-660045
         CALL cl_err3("upd","coc_file",tm.coc01,"",STATUS,"","update:",1) #TQC-660045
         LET g_success='N' RETURN
      END IF
   ELSE
      DECLARE p400_coh CURSOR FOR
              SELECT cod02,cod03,cod041,SUM(cod05),cod06,
                     cod07,SUM(cod08),0,'',''
              FROM p400_temp
              GROUP BY cod02,cod03,cod041,cod06,cod07
              ORDER BY cod02,cod03,cod041
      LET l_coc09 = 0
      FOREACH p400_coh INTO sr.*
         IF STATUS THEN 
            CALL cl_err('foreach:',STATUS,1) LET g_success='N' EXIT FOREACH 
         END IF
#         SELECT UNIQUE cod02,cod041 INTO sr.cod02,sr.cod041 
#           FROM cod_file,coc_file
          #No.MOD-490398  --begin
         SELECT UNIQUE cod02 INTO sr.cod02
           FROM cod_file,coc_file
           WHERE coc01 = cod01     AND coc04 = tm.coc04
             AND cod03 = sr.cod03  AND cod04 = tm.coc10
             AND cod041 =sr.cod041
          IF SQLCA.sqlcode<> 0 AND SQLCA.sqlcode <> 100 THEN
             LET g_success = 'N'
             RETURN
          END IF
          INSERT INTO coh_file(coh01,coh02,coh03,coh04,coh041,coh05,coh06,
                               coh07,coh08,cohplant,cohlegal) #FUN-980002 add cohplant,cohlegal
                        VALUES(tm.coc01,sr.cod02,sr.cod03,tm.coc10,sr.cod041,
                               sr.cod05,sr.cod06,sr.cod07,sr.cod08,g_plant,g_legal)  #FUN-980002 add g_plant,g_legal 
           #No.MOD-490398  --end
          IF STATUS THEN 
#            CALL cl_err('insert:',STATUS,1)  #No.TQC-660045
             CALL cl_err3("ins","coh_file",tm.coc01,sr.cod02,STATUS,"","insert:",1) #TQC-660045
             LET g_success='N' RETURN
          END IF
          LET l_coc09 = l_coc09 + sr.cod08
      END FOREACH
      IF cl_null(l_coc09) THEN LET l_coc09 = 0 END IF
      UPDATE cog_file SET cog04 = l_coc09 WHERE cog01 = tm.coc01
      IF STATUS THEN 
#        CALL cl_err('update:',STATUS,1)  #No.TQC-660045
         CALL cl_err3("upd","cog_file",tm.coc01,"",STATUS,"","update:",1) #TQC-660045
         LET g_success='N' RETURN
      END IF
   END IF
END FUNCTION
 
 #No.MOD-490398
FUNCTION p400_coc03()
   DEFINE l_i,l_n,l_flag   LIKE type_file.num5         #No.FUN-680069 SMALLINT
   DEFINE l_coh03          LIKE coh_file.coh03
   DEFINE l_coh041         LIKE coh_file.coh041
   LET l_flag = 1
   FOR l_i = 1 TO g_rec_b
       SELECT COUNT(*) INTO l_n FROM coc_file,cod_file
        WHERE coc03 = tm.coc03
          AND coc01 = cod01
          AND cod03 = g_cnh[l_i].a
       IF l_n = 0 THEN LET l_flag = 0 EXIT FOR END IF  
    END FOR
    IF l_flag = 0 THEN LET g_success = 'N' RETURN END IF
END FUNCTION
 #No.MOD-490398 end 
 
FUNCTION p400_b()
 DEFINE
    l_exit_sw       LIKE type_file.chr1,         #No.FUN-680069 VARCHAR(1)  #Esc結束INPUT ARRAY 否
    l_n             LIKE type_file.num5,         #No.FUN-680069 SMALLINT
    l_lock_sw       LIKE type_file.chr1,         #No.FUN-680069 VARCHAR(1)
    l_i             LIKE type_file.num5,         #No.FUN-680069 SMALLINT
    l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680069 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否        #No.FUN-680069 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(tm.cng01) THEN
        RETURN
    END IF
    CALL cl_opmsg('b')
 
    WHILE TRUE
        LET l_exit_sw = "y"                #正常結束,除非 ^N
       #LET l_allow_insert = cl_detail_input_auth("insert")
       #LET l_allow_delete = cl_detail_input_auth("delete")
        LET l_allow_insert = FALSE
        LET l_allow_delete = FALSE
 
        INPUT ARRAY g_cnh WITHOUT DEFAULTS FROM s_cnh.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
         #No.MOD-490398  --begin
        BEFORE INPUT
            CALL fgl_set_arr_curr(l_ac)
 
        BEFORE ROW
            LET l_ac = ARR_CURR()
            CALL cl_show_fld_cont()     #FUN-550037(smin)
 
        AFTER FIELD ver
            IF g_cnh[l_ac].ver IS NULL THEN LET g_cnh[l_ac].ver = ' ' END IF
            IF NOT cl_null(g_cnh[l_ac].a) THEN
               LET l_n = 0
               IF tm.choice = '1' THEN
                  SELECT COUNT(*) INTO l_n FROM com_file
                   WHERE com01= g_cnh[l_ac].a AND com02 = g_cnh[l_ac].ver
                      AND com03= tm.coc10  #No.MOD-490398
               ELSE
                  SELECT COUNT(*) INTO l_n FROM coc_file,cod_file
                   WHERE cocacti ='Y'    AND cod03 = g_cnh[l_ac].a
                     AND coc01   = cod01 AND coc04 = tm.coc04
                     AND cod041  = g_cnh[l_ac].ver
                      AND cod04   = tm.coc10  #No.MOD-490398
               END IF
               IF l_n = 0 THEN
                  CALL cl_err(g_cnh[l_ac].ver,'aco-180',0)
                  NEXT FIELD ver
               END IF
            END IF
            
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_cnh[l_ac].* = g_cnh_t.*
               CLOSE p400_cur
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_cnh[l_ac].cnh02,-263,1)
               LET g_cnh[l_ac].* = g_cnh_t.*
            ELSE
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_cnh[l_ac].* = g_cnh_t.*
               CLOSE p400_cur
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET g_cnh_t.* = g_cnh[l_ac].*
            CLOSE p400_cur
            COMMIT WORK
 
        AFTER INPUT       
            IF INT_FLAG THEN
               LET INT_FLAG = 0
               LET g_success = 'N'
               RETURN
            END IF
            FOR l_i = 1 TO g_rec_b 
                LET l_n = 0
                IF tm.choice = '1' THEN
                   SELECT COUNT(*) INTO l_n FROM com_file
                    WHERE com01= g_cnh[l_i].a AND com02 = g_cnh[l_i].ver
                       AND com03= tm.coc10  #No.MOD-490398
                ELSE
                   SELECT COUNT(*) INTO l_n FROM coc_file,cod_file
                    WHERE cocacti='Y'    AND cod03 = g_cnh[l_i].a
                      AND coc01  = cod01 AND coc04 = tm.coc04
                      AND cod041 = g_cnh[l_i].ver
                       AND cod04  = tm.coc10  #No.MOD-490398                      
                END IF
                IF l_n = 0 THEN
                   CALL cl_err(g_cnh[l_ac].ver,'aco-180',0)
                   NEXT FIELD ver
                END IF
            END FOR
 
         #No.MOD-490398  --begin
        ON ACTION CONTROLP                        # 沿用所有欄位                 
            IF INFIELD(ver) THEN                                              
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_com'
               LET g_qryparam.default1 = g_cnh[l_ac].a
               LET g_qryparam.default2 = g_cnh[l_ac].ver
               LET g_qryparam.where    = " com01='",g_cnh[l_ac].a,"'"
               LET g_qryparam.arg1     = tm.coc10
               CALL cl_create_qry() RETURNING g_cnh[l_ac].a, g_cnh[l_ac].ver
               NEXT FIELD ver                                                   
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
 
           
         #No.MOD-490398
 
#NO.FUN-6B0033--BEGIN                                                                                                               
      ON ACTION CONTROLS                                                                                                          
         CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0033--END   
 
        END INPUT
        IF l_exit_sw = "y" THEN
            EXIT WHILE                     #ESC 或 DEL 結束 INPUT
        ELSE
            CONTINUE WHILE                 #^N 結束 INPUT
        END IF
    END WHILE
 
END FUNCTION
