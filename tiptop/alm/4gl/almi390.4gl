# Prog. Version..: '5.30.06-13.04.22(00008)'     #
#
# Pattern name...: almi390.4gl
# Descriptions...: 付款方式優惠減免作業
# Date & Author..: FUN-870015 08/07/11 By shiwuying
# Modify.........: No.FUN-960134 09/07/14 By shiwuying 市場移植
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0136 09/11/27 By shiwuying
# Modify.........: No:FUN-A10060 10/01/13 By shiwuying 權限處理
# Modify.........: No:MOD-A30117 10/03/17 By Smapmin 修改"預設上筆資料"的邏輯
# Modify.........: No:FUN-A60064 10/06/24 By chenls 非T/S類table中的xxxplant替換成xxxstore
# Modify.........: No:TQC-A70043 10/07/09 BY houlia 添加顯示azt02資料
# Modify.........: NO:FUN-A80148 10/09/01 By wangxin 因為lma_file已不使用,所以將lma_file改為rtz_file的相應欄位
# Modify.........: No.FUN-D30033 13/04/12 By minpp 單身新增時按下放棄鍵未執行AFTER INSERT的問題

 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_lns           DYNAMIC ARRAY OF RECORD
           lnsstore       LIKE lns_file.lnsstore,
           rtz13       LIKE rtz_file.rtz13,  #FUN-A80148 add
           lnslegal    LIKE lns_file.lnslegal,
           azt02       LIKE azt_file.azt02,
           lns02       LIKE lns_file.lns02,
           lnr02       LIKE lnr_file.lnr02,
           lns03       LIKE lns_file.lns03,
           oaj02       LIKE oaj_file.oaj02,
           lns04       LIKE lns_file.lns04,
           lns05       LIKE lns_file.lns05,
           lns06       LIKE lns_file.lns06
                       END RECORD,
       g_lns_t         RECORD             
           lnsstore       LIKE lns_file.lnsstore,
           rtz13       LIKE rtz_file.rtz13,  #FUN-A80148 add
           lnslegal    LIKE lns_file.lnslegal,
           azt02       LIKE azt_file.azt02,
           lns02       LIKE lns_file.lns02,
           lnr02       LIKE lnr_file.lnr02,
           lns03       LIKE lns_file.lns03,
           oaj02       LIKE oaj_file.oaj02,
           lns04       LIKE lns_file.lns04,
           lns05       LIKE lns_file.lns05,
           lns06       LIKE lns_file.lns06
                       END RECORD,
       g_wc2,g_sql     STRING, 
       g_rec_b         LIKE type_file.num5,               
       l_ac            LIKE type_file.num5                
 
DEFINE g_forupd_sql         STRING                  
DEFINE g_cnt                LIKE type_file.num10    
DEFINE g_msg                LIKE type_file.chr1000 
DEFINE g_before_input_done  LIKE type_file.num5     
DEFINE g_i                  LIKE type_file.num5     
 
MAIN     
    OPTIONS                              
        INPUT NO WRAP    #No.FUN-9B0136
    #   FIELD ORDER FORM #No.FUN-9B0136
    DEFER INTERRUPT                    
 
    IF (NOT cl_user()) THEN
      EXIT PROGRAM
    END IF
  
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
    END IF
      
    CALL cl_used(g_prog,g_time,1) RETURNING g_time 
         
    OPEN WINDOW i390_w WITH FORM "alm/42f/almi390"
          ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
    CALL cl_ui_init()
    LET g_wc2 = '1=1' CALL i390_b_fill(g_wc2)
    CALL i390_menu()
    CLOSE WINDOW i390_w               
 
    CALL cl_used(g_prog,g_time,2) RETURNING g_time   
END MAIN
 
FUNCTION i390_menu()
 
   WHILE TRUE
      CALL i390_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i390_q()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               LET l_ac = ARR_CURR()
               IF l_ac > 0 THEN
               #  IF cl_chk_mach_auth(g_lns[l_ac].lnsstore,g_plant) THEN
                     CALL i390_b()
               #  END IF 
               ELSE 
                  CALL i390_b()
                  LET g_action_choice = NULL
               END IF
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output" 
            IF cl_chk_act_auth() THEN
               #CALL i390_out()
               IF cl_null(g_wc2) THEN LET g_wc2 = " 1=1" END IF
               LET g_msg = 'p_query "almi390" "',g_wc2 CLIPPED,'"'
               CALL cl_cmdrun(g_msg)
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg" 
            CALL cl_cmdask()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_lns),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i390_q()
   CALL i390_b_askkey()
END FUNCTION
 
FUNCTION i390_b()
    DEFINE
       l_ac_t          LIKE type_file.num5,    
       l_n             LIKE type_file.num5,
       l_cnt           LIKE type_file.num5,
       l_lock_sw       LIKE type_file.chr1,  
       p_cmd           LIKE type_file.chr1,   
       l_allow_insert  LIKE type_file.chr1,   
       l_allow_delete  LIKE type_file.chr1 
#   DEFINE l_tqa06     LIKE tqa_file.tqa06
 
    LET g_action_choice = ""
 
####判斷當前組織機構是否是門店，只能在門店錄資料######
#  SELECT tqa06 INTO l_tqa06 FROM tqa_file
#   WHERE tqa03 = '14'
#     AND tqaacti = 'Y'
#     AND tqa01 IN(SELECT tqb03 FROM tqb_file
#                   WHERE tqbacti = 'Y'
#                     AND tqb09 = '2'
#                     AND tqb01 = g_plant)
#  IF cl_null(l_tqa06) OR l_tqa06 = 'N' THEN
#     CALL cl_err('','alm-600',1)
#     CALL g_lns.clear()
#     RETURN
#  END IF
 
   SELECT COUNT(*) INTO l_cnt FROM rtz_file
    WHERE rtz01 = g_plant
      AND rtz28 = 'Y'
   IF l_cnt < 1 THEN
      CALL cl_err('','alm-606',1)
      CALL g_lns.clear()
      RETURN 
   END IF
######################################################
 
    IF s_shut(0) THEN RETURN END IF
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT lnsstore,'',lnslegal,'',lns02,'',lns03,'',lns04,lns05,lns06",
                       " FROM lns_file WHERE lnsstore=? AND lns02=? FOR UPDATE "
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i390_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    INPUT ARRAY g_lns WITHOUT DEFAULTS FROM s_lns.*
              ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,
              UNBUFFERED, INSERT ROW = l_allow_insert,
              DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac) 
            END IF
 
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b>=l_ac THEN
               LET p_cmd='u'
               LET  g_before_input_done = FALSE 
               CALL i390_set_entry(p_cmd)
               CALL i390_set_no_entry(p_cmd) 
               LET  g_before_input_done = TRUE 
 
               BEGIN WORK
               LET g_lns_t.* = g_lns[l_ac].*  #BACKUP
               OPEN i390_bcl USING g_lns_t.lnsstore,g_lns_t.lns02
               IF STATUS THEN
                  CALL cl_err("OPEN i390_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE   
                  FETCH i390_bcl INTO g_lns[l_ac].* 
#TQC-A70043 --add
                  SELECT azt02 INTO g_lns[l_ac].azt02 
                    FROM azt_file 
                   WHERE azt01 = g_lns[l_ac].lnslegal
                 DISPLAY BY NAME g_lns[l_ac].azt02      #houlia
#TQC-A70043 --end
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_lns_t.lnsstore,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
                  CALL i390_lnsstore('d')
                  CALL i390_lns02('d')
                  CALL i390_lns03('d')
               END IF
               CALL cl_show_fld_cont()  
            END IF
 
        BEFORE INSERT
            LET p_cmd='a'
            LET l_n = ARR_COUNT()
            INITIALIZE g_lns[l_ac].* TO NULL
            LET g_lns[l_ac].lnsstore = g_plant
            LET g_lns[l_ac].lnslegal = g_legal
 
            SELECT azt02 INTO g_lns[l_ac].azt02 FROM azt_file
             WHERE azt01 = g_lns[l_ac].lnslegal
 
            LET g_lns[l_ac].lns06 = 'Y'       #Body default
            LET g_lns_t.* = g_lns[l_ac].*
            LET  g_before_input_done = FALSE
            CALL i390_set_entry(p_cmd)
            CALL i390_set_no_entry(p_cmd)
            LET  g_before_input_done = TRUE
            CALL cl_show_fld_cont()    
            NEXT FIELD lnsstore
 
      AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO lns_file(lnslegal,lnsstore,lns02,lns03,lns04,lns05,lns06)
                 VALUES(g_lns[l_ac].lnslegal,g_lns[l_ac].lnsstore,g_lns[l_ac].lns02,
                        g_lns[l_ac].lns03,g_lns[l_ac].lns04,
                        g_lns[l_ac].lns05,g_lns[l_ac].lns06)
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","lns_file",g_lns[l_ac].lnsstore,"",SQLCA.sqlcode,"","",1) 
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2  
            END IF
 
        AFTER FIELD lnsstore
            IF NOT cl_null(g_lns[l_ac].lnsstore) THEN
               CALL i390_lnsstore(p_cmd)
               IF NOT cl_null(g_errno) THEN     
                  CALL cl_err(g_lns[l_ac].lnsstore,g_errno,0)
                  LET g_lns[l_ac].lnsstore = g_lns_t.lnsstore
                  NEXT FIELD lnsstore
               END IF
            END IF
 
        AFTER FIELD lns02
           IF NOT cl_null(g_lns[l_ac].lns02) THEN
              IF g_lns[l_ac].lns02!=g_lns_t.lns02 OR g_lns_t.lns02 IS NULL THEN
                 SELECT count(*) INTO l_n FROM lns_file 
                  WHERE lnsstore = g_lns[l_ac].lnsstore      
                    AND lns02 = g_lns[l_ac].lns02  
                 IF l_n > 0 THEN                       
                    CALL cl_err('',-239,0)                            
                    LET g_lns[l_ac].lns02 = g_lns_t.lns02 
                    NEXT FIELD lns02
                 END IF
                 CALL i390_lns02(p_cmd)
                 IF NOT cl_null(g_errno) THEN     
                    CALL cl_err(g_lns[l_ac].lns02,g_errno,0)
                    LET g_lns[l_ac].lns02 = g_lns_t.lns02
                    NEXT FIELD lns02
                 END IF
              END IF
           END IF
 
        AFTER FIELD lns03
           IF NOT cl_null(g_lns[l_ac].lns03) THEN
              CALL i390_lns03(p_cmd)
              IF NOT cl_null(g_errno) THEN     
                 CALL cl_err(g_lns[l_ac].lns03,g_errno,0)
                 LET g_lns[l_ac].lns03 = g_lns_t.lns03
                 NEXT FIELD lns03
              END IF
           END IF
           
        AFTER FIELD lns04
           IF NOT cl_null(g_lns[l_ac].lns04) THEN
              IF g_lns[l_ac].lns04<0 OR g_lns[l_ac].lns04 >100 THEN     
                 CALL cl_err(g_lns[l_ac].lns04,'atm-070',0)
                 LET g_lns[l_ac].lns03 = g_lns_t.lns03
                 NEXT FIELD lns04
              END IF
           END IF
           
        AFTER FIELD lns05
           IF NOT cl_null(g_lns[l_ac].lns05) THEN
              IF g_lns[l_ac].lns05 < 0 THEN     
                 CALL cl_err(g_lns[l_ac].lns05,'alm-053',0)
                 LET g_lns[l_ac].lns05 = g_lns_t.lns05
                 NEXT FIELD lns05
              END IF
           END IF
 
        BEFORE DELETE 
            IF g_lns_t.lnsstore IS NOT NULL THEN
               IF NOT cl_delete() THEN
                  CANCEL DELETE
               END IF
               IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
               END IF 
               DELETE FROM lns_file WHERE lnsstore = g_lns_t.lnsstore
                                      AND lns02 = g_lns_t.lns02
               IF SQLCA.sqlcode THEN
                   CALL cl_err3("del","lns_file",g_lns_t.lnsstore,"",SQLCA.sqlcode,"","",1) 
                   ROLLBACK WORK
                   CANCEL DELETE
               END IF
               LET g_rec_b=g_rec_b-1
               DISPLAY g_rec_b TO FORMONLY.cn2  
               MESSAGE "Delete OK" 
               CLOSE i390_bcl     
               COMMIT WORK
            END IF
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_lns[l_ac].* = g_lns_t.*
              CLOSE i390_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_lns[l_ac].lnsstore,-263,1)
              LET g_lns[l_ac].* = g_lns_t.*
           ELSE
              UPDATE lns_file SET lnsstore = g_lns[l_ac].lnsstore,
                                  lnslegal = g_lns[l_ac].lnslegal,
                                  lns02 = g_lns[l_ac].lns02,
                                  lns03 = g_lns[l_ac].lns03,
                                  lns04 = g_lns[l_ac].lns04,
                                  lns05 = g_lns[l_ac].lns05,
                                  lns06 = g_lns[l_ac].lns06
                            WHERE lnsstore = g_lns_t.lnsstore 
                              AND lns02 = g_lns_t.lns02
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","lns_file",g_lns_t.lnsstore,"",SQLCA.sqlcode,"","",1) 
                 LET g_lns[l_ac].* = g_lns_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 CLOSE i390_bcl
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                   LET g_lns[l_ac].* = g_lns_t.* 
               #FUN-D30033----add--str
               ELSE
                  CALL g_lns.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30033---add--end
               END IF
               CLOSE i390_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac 
            CLOSE i390_bcl
            COMMIT WORK 
 
        ON ACTION CONTROLN
            CALL i390_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO
            #IF INFIELD(lnsstore) AND l_ac > 1 THEN   #MOD-A30117
            IF INFIELD(lns02) AND l_ac > 1 THEN   #MOD-A30117
               LET g_lns[l_ac].* = g_lns[l_ac-1].*
               #LET g_lns[l_ac].lnsstore = NULL   #MOD-A30117
               #NEXT FIELD lnsstore   #MOD-A30117
               LET g_lns[l_ac].lns02 = NULL   #MOD-A30117
               NEXT FIELD lns02   #MOD-A30117
            END IF
            
        ON ACTION controlp
         CASE
            WHEN INFIELD(lnsstore)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_rtz"
               LET g_qryparam.default1 = g_lns[l_ac].lnsstore
               CALL cl_create_qry() RETURNING g_lns[l_ac].lnsstore
               DISPLAY BY NAME g_lns[l_ac].lnsstore
               CALL i390_lnsstore('d')
               NEXT FIELD lnsstore
            WHEN INFIELD(lns02)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_lnr2"
               LET g_qryparam.arg1 = g_lns[l_ac].lnsstore
               LET g_qryparam.default1 = g_lns[l_ac].lns02
               CALL cl_create_qry() RETURNING g_lns[l_ac].lns02
               DISPLAY BY NAME g_lns[l_ac].lns02
               CALL i390_lns02('d')
               NEXT FIELD lns02
            WHEN INFIELD(lns03)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_oaj1"
               LET g_qryparam.arg1 = g_aza.aza81
               LET g_qryparam.default1 = g_lns[l_ac].lns03
               CALL cl_create_qry() RETURNING g_lns[l_ac].lns03
               DISPLAY BY NAME g_lns[l_ac].lns03
               CALL i390_lns03('d')
               NEXT FIELD lns03
            OTHERWISE EXIT CASE
         END CASE
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF
            CALL cl_set_focus_form(ui.Interface.getRootNode()) 
                 RETURNING g_fld_name,g_frm_name 
            CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
          
        ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
        ON ACTION about       
            CALL cl_about()     
 
        ON ACTION help         
            CALL cl_show_help()
         
    END INPUT
    CLOSE i390_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i390_lnsstore(p_cmd)
    DEFINE l_rtz13    LIKE rtz_file.rtz13,
           l_rtz28    LIKE rtz_file.rtz28,
         # l_rtzacti  LIKE rtz_file.rtzacti,               #FUN-A80148 mark by vealxu 
           l_azwacti  LIKE azw_file.azwacti,               #FUN-A80148 add  by vealxu  
           p_cmd      LIKE type_file.chr1
 
   LET g_errno = ' '
   SELECT rtz13,rtz28,azwacti                              #FUN-A80148 mod rtzacti->azwacti by vealxu 
     INTO l_rtz13,l_rtz28,l_azwacti                        #FUN-A80148 mod l_rtzacti->l_azwacti by vealxu
     FROM rtz_file INNER JOIN azw_file                     #FUN-A80148 add azw_file by vealxu 
       ON rtz01 = azw01                                    #FUN-A80148 add by vealxu   
    WHERE rtz01 = g_lns[l_ac].lnsstore 
   CASE 
      WHEN SQLCA.SQLCODE = 100      LET g_errno = 'alm-001'
                                    LET l_rtz13 = NULL
    # WHEN l_rtzacti='N'            LET g_errno = '9028'             #FUN-A80148 mark bu vealxu 
      WHEN l_azwacti = 'N'          LET g_errno = '9028'             #FUN-A80148 add  by vealxu  
      WHEN l_rtz28='N'              LET g_errno = 'alm-002'
      OTHERWISE                     LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF cl_null(g_errno) or p_cmd = 'd' THEN
      LET g_lns[l_ac].rtz13  = l_rtz13
      DISPLAY BY NAME g_lns[l_ac].rtz13
   END IF
END FUNCTION
 
FUNCTION i390_lns02(p_cmd)
    DEFINE l_lnr02    LIKE lnr_file.lnr02,
           l_lnr04    LIKE lnr_file.lnr04,
           p_cmd      LIKE type_file.chr1
 
   LET g_errno = ' '
   SELECT lnr02,lnr04
     INTO l_lnr02,l_lnr04
     FROM lnr_file WHERE lnr01 = g_lns[l_ac].lns02 
   CASE 
      WHEN SQLCA.SQLCODE = 100      LET g_errno = 'alm-080'
                                    LET l_lnr02 = NULL
      WHEN l_lnr04 ='N'             LET g_errno = '9028'
      OTHERWISE                     LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF cl_null(g_errno) or p_cmd = 'd' THEN
      LET g_lns[l_ac].lnr02  = l_lnr02
      DISPLAY BY NAME g_lns[l_ac].lnr02
   END IF
END FUNCTION
 
FUNCTION i390_lns03(p_cmd)
    DEFINE l_oaj02    LIKE oaj_file.oaj02,
           l_oajacti  LIKE oaj_file.oajacti,
           p_cmd      LIKE type_file.chr1
 
   LET g_errno = ' '
   SELECT oaj02,oajacti
     INTO l_oaj02,l_oajacti
     FROM oaj_file WHERE oaj01 = g_lns[l_ac].lns03
   CASE 
      WHEN SQLCA.SQLCODE = 100      LET g_errno = 'alm-075'
                                    LET l_oaj02 = NULL
      WHEN l_oajacti ='N'           LET g_errno = '9028'
      OTHERWISE                     LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF cl_null(g_errno) or p_cmd = 'd' THEN
      LET g_lns[l_ac].oaj02  = l_oaj02
      DISPLAY BY NAME g_lns[l_ac].oaj02
   END IF
END FUNCTION
 
FUNCTION i390_b_askkey()
    CLEAR FORM
    CALL g_lns.clear()
    CONSTRUCT g_wc2 ON lnsstore,lnslegal,lns02,lns03,lns04,lns05,lns06
            FROM s_lns[1].lnsstore,s_lns[1].lnslegal,
                 s_lns[1].lns02,s_lns[1].lns03,s_lns[1].lns04,
                 s_lns[1].lns05,s_lns[1].lns06
 
      BEFORE CONSTRUCT
          CALL cl_qbe_init()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about       
         CALL cl_about()     
 
      ON ACTION help        
         CALL cl_show_help()
 
      ON ACTION controlg    
         CALL cl_cmdask() 
         
      ON ACTION controlp
         CASE
            WHEN INFIELD(lnsstore)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form = "q_lnsstore"
               LET g_qryparam.where = " lnsstore IN ",g_auth," "  #No.FUN-A10060
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lnsstore
               NEXT FIELD lnsstore
             WHEN INFIELD(lnslegal)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_lnslegal"
               LET g_qryparam.state = "c"
               LET g_qryparam.where = " lnsstore IN ",g_auth," "  #No.FUN-A10060
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lnslegal
               NEXT FIELD lnslegal
            WHEN INFIELD(lns02)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_lns02"
               LET g_qryparam.state = "c"
               LET g_qryparam.where = " lnsstore IN ",g_auth," "  #No.FUN-A10060
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lns02
               NEXT FIELD lns02
            WHEN INFIELD(lns03)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_lns03"
               LET g_qryparam.state = "c"
               LET g_qryparam.where = " lnsstore IN ",g_auth," "  #No.FUN-A10060
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lns03
               NEXT FIELD lns03
            OTHERWISE EXIT CASE
         END CASE
      
      ON ACTION qbe_select
         CALL cl_qbe_select() 
         
      ON ACTION qbe_save
	 CALL cl_qbe_save()
 
    END CONSTRUCT
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
    
    IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      LET g_rec_b = 0
      RETURN
    END IF
    CALL i390_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i390_b_fill(p_wc2)
    DEFINE p_wc2     LIKE type_file.chr1000  
    LET g_sql = "SELECT lnsstore,'',lnslegal,'',lns02,'',lns03,'',lns04,lns05,lns06",
                " FROM lns_file",
                " WHERE ", p_wc2 CLIPPED,
                "   AND lnsstore IN ",g_auth,
                " ORDER BY lnsstore,lns02 "
    PREPARE i390_pb FROM g_sql
    DECLARE lns_curs CURSOR FOR i390_pb
 
    CALL g_lns.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH lns_curs INTO g_lns[g_cnt].*  
       IF STATUS THEN 
          CALL cl_err('foreach:',STATUS,1)
          EXIT FOREACH
       END IF
       SELECT rtz13 INTO g_lns[g_cnt].rtz13 FROM rtz_file
        WHERE rtz01 = g_lns[g_cnt].lnsstore
       IF SQLCA.sqlcode THEN
          CALL cl_err3("sel","rtz_file",g_lns[g_cnt].rtz13,"",SQLCA.sqlcode,"","",0)
          LET g_lns[g_cnt].rtz13 = NULL
       END IF 
       SELECT lnr02 INTO g_lns[g_cnt].lnr02 FROM lnr_file
        WHERE lnr01 = g_lns[g_cnt].lns02
       IF SQLCA.sqlcode THEN
          CALL cl_err3("sel","lnr_file",g_lns[g_cnt].lnr02,"",SQLCA.sqlcode,"","",0)
          LET g_lns[g_cnt].lnr02 = NULL
       END IF     
       SELECT oaj02 INTO g_lns[g_cnt].oaj02 FROM oaj_file
        WHERE oaj01 = g_lns[g_cnt].lns03
       IF SQLCA.sqlcode THEN
          CALL cl_err3("sel","oaj_file",g_lns[g_cnt].oaj02,"",SQLCA.sqlcode,"","",0)
          LET g_lns[g_cnt].oaj02 = NULL
       END IF
       SELECT azt02 INTO g_lns[g_cnt].azt02 FROM azt_file
        WHERE azt01 = g_lns[g_cnt].lnslegal
       IF SQLCA.sqlcode THEN
          CALL cl_err3("sel","azt_file",g_lns[g_cnt].azt02,"",SQLCA.sqlcode,"","",0)
          LET g_lns[g_cnt].azt02 = NULL
       END IF     
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_lns.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i390_bp(p_ud)
 
   DEFINE   p_ud   LIKE type_file.chr1    
   IF p_ud <> "G" OR g_action_choice = "detail" THEN                            
      RETURN                                                                    
   END IF                                                                       
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_lns TO s_lns.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         EXIT DISPLAY
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY
      ON ACTION accept                                                          
         LET g_action_choice="detail"                                           
         LET l_ac = ARR_CURR()                                                  
         EXIT DISPLAY                                                                                                                                      
      ON ACTION cancel                                                          
         LET INT_FLAG=FALSE 		
         LET g_action_choice="exit"                                             
         EXIT DISPLAY                                                           
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
      ON ACTION about         
         CALL cl_about() 
         
      AFTER DISPLAY
         CONTINUE DISPLAY
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i390_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
  IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN 
     CALL cl_set_comp_entry("lnsstore,lns02",TRUE)
  END IF
END FUNCTION 
 
FUNCTION i390_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1 
  IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN 
     CALL cl_set_comp_entry("lnsstore,lns02",FALSE)
  END IF
  CALL cl_set_comp_entry("lnsstore",FALSE)
END FUNCTION
#No.FUN-960134
#FUN-A60064 10/06/24 By chenls 非T/S類table中的xxxplant替換成xxxstore
