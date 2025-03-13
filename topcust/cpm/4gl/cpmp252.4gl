# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: cpmp252.4gl
# Descriptions...: 询价转核价
# Date & Author..:darcy:2023/06/01



DATABASE ds
 
GLOBALS "../../config/top.global"

type pmj record
   check    like type_file.chr1,
   pmi01    like pmi_file.pmi01 , --单号
   pmi02    like pmi_file.pmi02 , --日期
   pmi09    like pmi_file.pmi09 , --申请人
   pmi10    like pmi_file.pmi10,
   gen02    like gen_file.gen02 , --姓名
   pmi03    like pmi_file.pmi03 , --供应商编号
   pmc03    like pmc_file.pmc03,  --简称
   pmi08    like pmi_file.pmi08 , --税别
   pmi081   like pmi_file.pmi081, --税种
   pmi04    like pmi_file.pmi04 , --备注
   pmj03    like pmj_file.pmj03 , --料件编号
   pmj031    like ima_file.ima02 ,
   pmj032   like ima_file.ima021,
   pmj10    like pmj_file.pmj10 , --作业编号
   pmj11    like pmj_file.pmj11 , -- no use
   pmj13    like pmj_file.pmj13 , --制程单元编号
   pmj05    like pmj_file.pmj05 , --币别
   pmj06    like pmj_file.pmj06 , --原未税
   pmj06t   like pmj_file.pmj06t, --原含税
   pmj07    like pmj_file.pmj07 , --新核准未税
   pmj07t   like pmj_file.pmj07t, --新核准含税
   pmj08    like pmj_file.pmj08 , --原核准日
   pmj09    like pmj_file.pmj09 , --新核准日
   tc_pmx01 like tc_pmx_file.tc_pmx01, --询价单号
   tc_pmx02 like tc_pmx_file.tc_pmx01 --询价项次
end record
 
DEFINE g_renew   LIKE type_file.num5
define g_chr     string
define g_pmj_color dynamic array of record
      check    string,
      pmi01    string,
      pmi02    string,
      pmi09    string,
      pmi10    string,
      gen02    string,
      pmi03    string,
      pmc03    string,
      pmi08    string,
      pmi081   string,
      pmi04    string,
      pmj03    string,
      ima02    string,
      ima021   string,
      pmj10    string,
      pmj11    string,
      pmj13    string,
      pmj05    string,
      pmj06    string,
      pmj06t   string,
      pmj07    string,
      pmj07t   string,
      pmj08    string,
      pmj09    string,
      tc_pmx01 string,
      tc_pmx02 string
   end record
DEFINE g_pmj  dynamic array of pmj,
       g_pmj_t pmj,
       begin_no,end_no     LIKE oga_file.oga01,
       lr_agc        DYNAMIC ARRAY OF RECORD LIKE agc_file.*,
      #g_wc2,g_sql    LIKE type_file.chr1000,#TQC-D20024 mark
       g_wc2,g_sql    STRING,#TQC-D20024 add
       g_ws1          LIKE type_file.chr1000,
       g_wc3          STRING,#TQC-D20024 add
       g_wc_pmm       LIKE type_file.chr1000,
       g_seq          LIKE type_file.num5,
       g_rec_b        LIKE type_file.num5,         
       g_rec_b1       LIKE type_file.num5,         
       l_ac          LIKE type_file.num5,         
       l_ac_t        LIKE type_file.num5         
DEFINE p_row,p_col    LIKE type_file.num5          
DEFINE g_cnt          LIKE type_file.num10         
DEFINE g_forupd_sql   STRING
DEFINE g_before_input_done STRING
DEFINE li_result      LIKE type_file.num5          
DEFINE g_msg          LIKE type_file.chr1000       
DEFINE mi_need_cons     LIKE type_file.num5
DEFINE g_dbs2          LIKE type_file.chr30   
DEFINE tm RECORD			     
          slip         LIKE oay_file.oayslip, #單據別
          dt           LIKE oeb_file.oeb16,   #出通/出貨日期
          g            LIKE type_file.chr1    #匯總方式
      END RECORD,
      g_pmn02          LIKE pmn_file.pmn02    #採購單號
DEFINE g_pmi1  RECORD LIKE pmi_file.*
DEFINE g_pmj1  RECORD LIKE pmj_file.*
DEFINE t_aza41   LIKE type_file.num5        #單別位數 (by aza41)
DEFINE slip      LIKE oay_file.oayslip
DEFINE g_no      STRING #TQC-C10062 請/採購單號存放字符串 
define g_argv1    string
 
 
 
MAIN
   OPTIONS                               #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("CPM")) THEN
      EXIT PROGRAM
   END IF
 
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time
 
   LET p_row = 2 LET p_col = 3
   let g_argv1 = ARG_VAL(1)
   
 
   #OPEN WINDOW p252_w AT p_row,p_col WITH FORM "asf/42f/asfp252"  #No.FUN-AB0067  
   OPEN WINDOW p252_w AT p_row,p_col WITH FORM "cpm/42f/cpmp252"   #No.FUN-AB0067  
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   CALL p252_init() 
   LET mi_need_cons = 1  #讓畫面一開始進去就停在查詢
   LET g_renew = 1
   CALL p252()
 
   CLOSE WINDOW p252_w
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time  
END MAIN
 
 
 
FUNCTION p252()
 
   CLEAR FORM
   WHILE TRUE
      if not cl_null(g_argv1) then
         let g_wc2 = g_argv1
      end if
      IF (mi_need_cons) THEN
         LET mi_need_cons = 0
         CALL p252_q()
      END IF 
      CALL p252_p1()
      LET g_no = NULL #TQC-C10062
      IF INT_FLAG THEN EXIT WHILE END IF
      CASE g_action_choice
         WHEN "select_all"   #全部選取
           CALL p252_sel_all('Y')
 
         WHEN "select_non"   #全部不選
           CALL p252_sel_all('N')
 
         WHEN "exporttoexcel" #匯出excel
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_pmj),'','')
            END IF
         when "gen_pmj"
            if cl_chk_act_auth() then
               call p252_gen_pmj()
            end if
         WHEN "exit"
           EXIT WHILE
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION p252_p1()
   define l_cnt2 integer

      LET g_action_choice = " "
      CALL cl_set_act_visible("accept,cancel", FALSE)
 
      INPUT ARRAY g_pmj WITHOUT DEFAULTS FROM s_pmj.*  #顯示並進行選擇
        ATTRIBUTE(COUNT=g_rec_b1,MAXCOUNT=g_max_rec,UNBUFFERED,
                  INSERT ROW = FALSE,DELETE ROW = FALSE,APPEND ROW= FALSE)
         #-----FUN-A30021---------
         BEFORE INPUT
            IF g_rec_b1 != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
            CALL DIALOG.setCellAttributes(g_pmj_color)
         #-----END FUN-A30021-----

         BEFORE ROW
             IF g_renew THEN
               LET l_ac = ARR_CURR()
               IF l_ac = 0 THEN
                  LET l_ac = 1
               END IF
             END IF
             CALL fgl_set_arr_curr(l_ac)
             CALL cl_show_fld_cont()
             LET l_ac_t = l_ac
             LET g_pmj_t.* = g_pmj[l_ac].*
             LET g_renew = 1
 
             if g_pmj[l_ac].pmi03 ='MISC' then
               call cl_set_comp_entry("pmi03",true)
             else
               call cl_set_comp_entry("pmi03",false)
             end if
             if g_pmj[l_ac].pmj03 ='MISC' then
               call cl_set_comp_entry("pmj03",true)
             else
               call cl_set_comp_entry("pmj03",false)
             end if
 
         ON CHANGE check
            IF cl_null(g_pmj[l_ac].check) THEN 
               LET g_pmj[l_ac].check = 'Y'
            END IF
 
         ON ACTION query
            LET mi_need_cons = 1
            EXIT INPUT
         
         on action gen_pmj
            let g_action_choice ="gen_pmj"
            exit INPUT

         ON ACTION exporttoexcel
            LET g_action_choice = "exporttoexcel"
            EXIT INPUT
         
         ON ACTION select_all
            LET g_action_choice = "select_all"
            EXIT INPUT
         
          ON ACTION select_non
            LET g_action_choice = "select_non"
            EXIT INPUT

         on action controlp infield pmi01
            call cl_set_act_visible("accept,cancel",true)
            CALL q_smy(FALSE,FALSE,g_pmj[l_ac].pmi01,'APM','5') RETURNING g_qryparam.multiret
            call cl_set_act_visible("accept,cancel",false)
            let g_pmj[l_ac].pmi01 = g_qryparam.multiret
            DISPLAY g_qryparam.multiret to pmi01
            NEXT FIELD pmi01

         after field pmi01
            CALL s_check_no("apm",g_pmj[l_ac].pmi01,"","5","pmi_file","pmi01","")
               RETURNING g_success,g_pmj[l_ac].pmi01
            DISPLAY g_pmj[l_ac].pmi01 to pmi01
            IF (NOT g_success) THEN
               NEXT FIELD pmi01
            END IF
         
         on action controlp infield pmi03
            CALL cl_init_qry_var()
            LET g_qryparam.form ="q_pmc1"
            LET g_qryparam.default1 = g_pmj[l_ac].pmi03
            call cl_set_act_visible("accept,cancel",true)
            CALL cl_create_qry() RETURNING g_pmj[l_ac].pmi03
            call cl_set_act_visible("accept,cancel",false)
            DISPLAY BY NAME g_pmj[l_ac].pmi03
            CALL p252_pmi03('d')
            NEXT FIELD pmi03
         
         before field pmi03
            if NOT cl_null(g_pmj[l_ac].pmi03) and g_pmj[l_ac].pmi03 != 'MISC' then
               call cl_set_comp_entry("pmi03",false)
            else
               call cl_set_comp_entry("pmi03",true)
            end if

         after field pmi03
            IF NOT cl_null(g_pmj[l_ac].pmi03) THEN
               CALL p252_pmi03('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_pmj[l_ac].pmi03,g_errno,0)
                  NEXT FIELD pmi03
               END IF
               if g_pmj[l_ac].pmi03 !='MISC' then
                  let g_pmj_color[l_ac].pmi03 = ''
               end if
            END IF

         on action controlp infield pmj03
            call cl_set_act_visible("accept,cancel",true)
            CALL q_sel_ima(FALSE, "q_ima", "", g_pmj[l_ac].pmj03, "", "", "", "" ,"",'' )
               RETURNING g_pmj[l_ac].pmj03
            call cl_set_act_visible("accept,cancel",false)
            DISPLAY BY NAME g_pmj[l_ac].pmj03
            IF NOT cl_null(g_pmj[l_ac].pmj03) AND
               g_pmj[l_ac].pmj03[1,4] !='MISC' THEN
               CALL p252_pmj03('d')
               NEXT FIELD pmj03
            END IF

         before field pmj03
            if NOT cl_null(g_pmj[l_ac].pmj03) and g_pmj[l_ac].pmj03 != 'MISC' then
               call cl_set_comp_entry("pmj03",false)
            else
               call cl_set_comp_entry("pmj03",true)
            end if

         after field pmj03
            IF NOT cl_null(g_pmj[l_ac].pmj03) THEN
               IF NOT s_chk_item_no(g_pmj[l_ac].pmj03,"") THEN
                  CALL cl_err(g_pmj[l_ac].pmj03,g_errno,1)
                  LET g_pmj[l_ac].pmj03= g_pmj_t.pmj03
                  NEXT FIELD pmj03
               END IF
               SELECT COUNT(*) INTO l_cnt2 FROM ima_file 
                WHERE ima01 = g_pmj[l_ac].pmj03
                  AND ima08 = 'X'
               IF l_cnt2 > 0 THEN 
                     CALL cl_err(g_pmj[l_ac].pmj03,'mfg9022',0)
                     NEXT FIELD pmj03
               END IF
               IF g_pmj_t.pmj03 IS NULL OR g_pmj_t.pmj031 IS NULL OR
                     (g_pmj[l_ac].pmj03 != g_pmj_t.pmj03) THEN
                     CALL p252_pmj03('a')
                     IF NOT cl_null(g_errno) AND g_pmj[l_ac].pmj03[1,4] !='MISC' THEN #NO:6808
                        CALL cl_err(g_pmj[l_ac].pmj03,g_errno,0)
                        LET g_pmj[l_ac].pmj03 = g_pmj_t.pmj03
                        DISPLAY BY NAME g_pmj[l_ac].pmj03
                        NEXT FIELD pmj03
                     END IF
               END IF
               LET g_pmj_t.pmj03 = g_pmj[l_ac].pmj03
               if g_pmj[l_ac].pmj03 !='MISC' then
                  let g_pmj_color[l_ac].pmj03 = ''
               else
                  call cl_err('不可为MISC','!',0)
                  next field pmj03
               end if
            END IF

         ON ACTION help
            CALL cl_show_help()
            EXIT INPUT
 
         ON ACTION controlg
            CALL cl_cmdask()
 
         ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()
 
         ON ACTION exit
            LET g_action_choice="exit"
            EXIT INPUT
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION about
            CALL cl_about()
 
      END INPUT
      CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION p252_q()
   CLEAR FORM
   CALL g_pmj.clear()
   
   if cl_null(g_wc2) or g_wc2 == ' 1=1' then

      CALL cl_set_act_visible("accept,cancel", TRUE)
      CONSTRUCT g_wc2 ON tc_pmw01,tc_pmw02,tc_pmw09,tc_pmx03,tc_pmw08
                  FROM FORMONLY.tc_pmw01,FORMONLY.tc_pmw02,FORMONLY.tc_pmw09,FORMONLY.tc_pmx03,FORMONLY.tc_pmw08
            BEFORE CONSTRUCT
               CALL cl_qbe_init()
   
            ON ACTION CONTROLP
               CASE
                  WHEN INFIELD(tc_pmw01)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state ="c"
                     LET g_qryparam.form ="cq_tc_pmw01"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO tc_pmw01
                     NEXT FIELD tc_pmw01

                  WHEN INFIELD(tc_pmw09)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state ="c"
                     LET g_qryparam.form ="q_gen"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO tc_pmw09
                     NEXT FIELD tc_pmw09

                  WHEN INFIELD(tc_pmx03)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state ="c"
                     LET g_qryparam.form ="q_azi"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO tc_pmx03
                     NEXT FIELD tc_pmx03
                  
                  WHEN INFIELD(tc_pmw08)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state ="c"
                     LET g_qryparam.form ="q_gec"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO tc_pmw08
                     NEXT FIELD tc_pmw08
   
            END CASE
   
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
   
         ON ACTION about
            CALL cl_about()
   
         ON ACTION help
            CALL cl_show_help()
   
         ON ACTION controlg
            CALL cl_cmdask()
   
         ON ACTION qbe_select
            CALL cl_qbe_select()
         ON ACTION qbe_save
            CALL cl_qbe_save()
      END CONSTRUCT

   #TQC-D20024--add--str
   #TQC-D20024--add--end
      CALL cl_set_act_visible("accept,cancel", FALSE)
   

      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
   end if
   CALL p252_b1_fill(g_wc2)
 
   LET l_ac = 1
   LET g_pmj_t.* = g_pmj[l_ac].*
 
END FUNCTION
 
FUNCTION p252_b1_fill(p_wc2)
   DEFINE p_wc2     STRING
 
   LET g_sql = "SELECT  'Y',",
	            " CASE SUBSTR(tc_pmw01,1,3) WHEN 'PMW' THEN  'PRL' WHEN 'PMY' THEN 'PRM' ELSE '' END pmi01,",
	            " to_char(SYSDATE,'yy/mm/dd') pmi02,",
	            " '",g_user,"',",
               " tc_pmw10, ",
	            " gen02,",
	            " tc_pmx04,",
	            " CASE tc_pmx04 WHEN 'MISC' THEN tc_pmx05 ELSE pmc03 END pmc03,",
	            " tc_pmw08,",
	            " tc_pmw081,",
	            " '',",
	            " tc_pmx03,",
	            " tc_pmx031,tc_pmx032,",
	            " tc_pmx10,",
	            " tc_pmx11,",
	            " tc_pmx13,",
	            " tc_pmw03,",
	            " tc_pmx06,",
	            " tc_pmx06t,",
	            " tc_pmx07,",
	            " tc_pmx07t,",
	            " tc_pmx08,",
	            " to_char(SYSDATE,'yy/mm/dd') pmj09,",
	            " tc_pmx01,",
	            " tc_pmx02",
               " FROM tc_pmw_file,tc_pmx_file ",
               " LEFT JOIN gen_file ON gen01 = '",g_user,"'",
               " LEFT JOIN pmc_file ON tc_pmx04 = pmc01",
               " WHERE tc_pmw01=tc_pmx01 and tc_pmwconf='Y' and tc_pmx20 ='Y' and ",
               " tc_pmx18 is null ",
               " and ",p_wc2
 
   PREPARE p252_pb1 FROM g_sql
   DECLARE sfb_curs CURSOR FOR p252_pb1
  
   CALL g_pmj.clear()
  
   LET g_cnt = 1
   MESSAGE "Searching!"
 
   FOREACH sfb_curs INTO g_pmj[g_cnt].*
      IF STATUS THEN
         CALL cl_err("foreach:",STATUS,1)   
         EXIT FOREACH
      END IF
      if g_pmj[g_cnt].pmi03 = 'MISC' then
         let g_pmj_color[g_cnt].pmi03 = 'reverse red'
      end if
      if g_pmj[g_cnt].pmj03 = 'MISC' then
         let g_pmj_color[g_cnt].pmj03 = 'reverse red'
      end if
      # TODO: 核价
 
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err("",9035,0)
         EXIT FOREACH
      END IF
   END FOREACH
 
   CALL  g_pmj.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b1 = g_cnt - 1
   CALL ui.Interface.refresh()
   DISPLAY g_rec_b1 TO FORMONLY.cntb
   LET g_cnt = 0
END FUNCTION
 
 
#全部選取/全部不選
FUNCTION p252_sel_all(p_flag)
  DEFINE  p_flag   LIKE type_file.chr1 
  DEFINE  l_i      LIKE type_file.num5
  FOR l_i = 1 TO g_rec_b1 
    LET g_pmj[l_i].check = p_flag
    DISPLAY BY NAME g_pmj[l_i].check
  END FOR
END FUNCTION
 
 
FUNCTION p252_init()
   LET g_dbs2 = s_dbstring(g_dbs CLIPPED)   #FUN-9B0106
   CASE g_aza.aza41
     WHEN "1"
       LET t_aza41 = 3
     WHEN "2"
       LET t_aza41 = 4
     WHEN "3"
       LET t_aza41 = 5 
   END CASE
END FUNCTION


FUNCTION p252_pmi03(p_cmd)  #廠商編號
    DEFINE l_pmc03 LIKE pmc_file.pmc03,
           l_pmc05 LIKE pmc_file.pmc05,
           l_pmc47 LIKE pmc_file.pmc47,        #No.FUN-550019
           l_pmcacti LIKE pmc_file.pmcacti,
           l_pmc30 LIKE pmc_file.pmc30,   #MOD-920024
           p_cmd   LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
 
   LET g_errno = " "
   SELECT pmc03,pmc05,pmc47,pmcacti,pmc30   #MOD-920024
     INTO l_pmc03,l_pmc05,l_pmc47,l_pmcacti,l_pmc30   #MOD-920024
     FROM pmc_file
    WHERE pmc01 = g_pmj[l_ac].pmi03
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3001'
                                  LET l_pmc03 = NULL
        WHEN l_pmcacti='N' LET g_errno = '9028'
        WHEN l_pmcacti MATCHES '[PH]'  LET g_errno = '9038'    #No.FUN-690024
        WHEN l_pmc30 = "2" LET g_errno='mfg3290'   #MOD-920024       
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF p_cmd='s' THEN
      DISPLAY l_pmc03 TO FORMONLY.pmc03
      RETURN
   END IF
 
   CASE
        WHEN l_pmc05 = '0'   #尚待核准           #No.FUN-690025
             CALL cl_getmsg('mfg3174',g_lang) RETURNING g_msg
             WHILE g_chr IS NULL OR g_chr NOT MATCHES'[YyNn]'
            LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED FOR CHAR g_chr
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
               END PROMPT
               IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
                IF g_chr MATCHES '[Nn]' THEN LET g_errno='apm-132' END IF #MOD-570056
             END WHILE
        WHEN l_pmc05 = '3'    #No.FUN-690025
             LET g_errno='mfg3042'
        OTHERWISE EXIT CASE
   END CASE
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_pmc03 TO FORMONLY.pmc03
   END IF
 
END FUNCTION

FUNCTION p252_pmj03(p_cmd)  #料件編號
    DEFINE l_ima02    LIKE ima_file.ima02,
           l_ima021   LIKE ima_file.ima021,
           l_imaacti  LIKE ima_file.imaacti,
           p_cmd      LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
      
 
    LET g_errno = ' '
    SELECT ima02,ima021,imaacti INTO l_ima02,l_ima021,l_imaacti
      FROM ima_file WHERE ima01=g_pmj[l_ac].pmj03
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3006'
                                   LET l_ima02 = NULL
                                   LET l_ima021= NULL
         WHEN l_imaacti='N' LET g_errno = '9028'
         WHEN l_imaacti MATCHES '[PH]'  LET g_errno = '9038'   #No.FUN-690022
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
    IF cl_null(g_errno) OR p_cmd = 'd' OR g_pmj[l_ac].pmj03[1,4]='MISC' THEN #6808
       LET g_pmj[l_ac].pmj031= l_ima02
       LET g_pmj[l_ac].pmj032= l_ima021
       DISPLAY BY NAME g_pmj[l_ac].pmj031   #No.FUN-830114
       DISPLAY BY NAME g_pmj[l_ac].pmj032   #No.FUN-830114
    END IF
 
END FUNCTION

function p252_gen_pmj()
   define l_i,l_j,l_cnt integer
   define l_pmi  record like pmi_file.*
   define l_pmj  record like pmj_file.*
   define l_pmi01 like pmi_file.pmi01
   define l_pmi10 like pmi_file.pmi10
   define sr dynamic array of record
         pmi01    like pmi_file.pmi01,
         pmi10    like pmi_file.pmi10
      end record
   define li_result integer
   define l_begin,l_end  like pmi_file.pmi01
   define l_begin_1,l_end_1  like pmi_file.pmi01
   define l_msg  string
   define l_tc_pmx01  like tc_pmx_file.tc_pmx01
   define l_tc_pmx02  like tc_pmx_file.tc_pmx02
   define l_sql      string

   # 建临时表
   DROP TABLE cpmp252_tmp
   CREATE TEMP TABLE cpmp252_tmp(
      pmi01    LIKE pmi_file.pmi01, --单号
      pmi02    LIKE pmi_file.pmi02, --日期
      pmi09    LIKE pmi_file.pmi09, --申请人
      pmi10    LIKE pmi_file.pmi10,
      gen02    LIKE gen_file.gen02, --姓名
      pmi03    LIKE pmi_file.pmi03, --供应商编号
      pmc03    LIKE pmc_file.pmc03,  --简称
      pmi08    LIKE pmi_file.pmi08, --税别
      pmi081   LIKE pmi_file.pmi081, --税种
      pmi04    LIKE pmi_file.pmi04, --备注
      pmj03    LIKE pmj_file.pmj03, --料件编号
      pmj031   LIKE ima_file.ima02,
      pmj032   LIKE ima_file.ima021,
      pmj10    LIKE pmj_file.pmj10, --作业编号
      pmj11    LIKE pmj_file.pmj11, -- no use
      pmj13    LIKE pmj_file.pmj13, --制程单元编号
      pmj05    LIKE pmj_file.pmj05, --币别
      pmj06    LIKE pmj_file.pmj06, --原未税
      pmj06t   LIKE pmj_file.pmj06t, --原含税
      pmj07    LIKE pmj_file.pmj07, --新核准未税
      pmj07t   LIKE pmj_file.pmj07t, --新核准含税
      pmj08    LIKE pmj_file.pmj08, --原核准日
      pmj09    LIKE pmj_file.pmj09, --新核准日
      tc_pmx01 LIKE tc_pmx_file.tc_pmx01, --询价单号
      tc_pmx02 INTEGER--询价项次
   )

   # 上次核价单价
   DECLARE p252_gen_pmj_cl2 CURSOR FOR
        SELECT pmi03,pmi08,pmj05,pmj09,pmj07,pmj07t
            FROM pmj_file,pmi_file
            WHERE pmj01=pmi01 AND pmiconf = 'Y'
            AND pmj03 = ?
            AND pmj10 = ?
            AND pmj12 = ?
            AND pmj13 = ?
            AND pmj09 = (SELECT MAX(pmj09) FROM pmi_file,pmj_file
            WHERE pmj01=pmi01 AND pmiconf = 'Y'
            AND pmj03 = ?
            AND pmj10 = ?
            AND pmj12 = ?
            AND pmj13 = ?)
            ORDER BY pmi01 desc

   # 插入中间表
   CALL s_showmsg_init()
   let g_success = 'Y'
   for l_i = 1 to g_pmj.getlength()
      if g_pmj[l_i].check!='Y' then
         continue for
      end if
      if g_pmj[l_i].pmi03 ='MISC' then
         CALL s_errmsg("pmi03,pmj03",g_pmj[l_i].pmi03||","||g_pmj[l_i].pmj03,'','cpm-072',1)
         let g_success ='N'
      end if
      if cl_null(g_pmj[l_i].pmi01) then
         CALL s_errmsg("pmi03,pmj03",g_pmj[l_i].pmi03||","||g_pmj[l_i].pmj03,'','cpm-074',1)
         let g_success ='N'
      end if
      # if g_pmj[l_i].pmj03 ='MISC' then
      #    CALL s_errmsg("pmi03,pmj03",g_pmj[l_i].pmi03||","||g_pmj[l_i].pmj03,'','cpm-073',1)
      #    let g_success ='N'
      # end if
      insert into cpmp252_tmp values(
         g_pmj[l_i].pmi01,g_pmj[l_i].pmi02,g_pmj[l_i].pmi09,g_pmj[l_i].pmi10,g_pmj[l_i].gen02,g_pmj[l_i].pmi03,
         g_pmj[l_i].pmc03,g_pmj[l_i].pmi08,g_pmj[l_i].pmi081,g_pmj[l_i].pmi04,g_pmj[l_i].pmj03,
         g_pmj[l_i].pmj031,g_pmj[l_i].pmj032,g_pmj[l_i].pmj10,g_pmj[l_i].pmj11,g_pmj[l_i].pmj13,
         g_pmj[l_i].pmj05,g_pmj[l_i].pmj06,g_pmj[l_i].pmj06t,g_pmj[l_i].pmj07,g_pmj[l_i].pmj07t,
         g_pmj[l_i].pmj08,g_pmj[l_i].pmj09,g_pmj[l_i].tc_pmx01,g_pmj[l_i].tc_pmx02
      )
      if sqlca.sqlcode then
         call cl_err('ins cpmp252_tmp',sqlca.sqlcode,1)
         exit for
      end if
   end for
   if g_success ='N' then
      drop table cpmp252_tmp
      CALL s_showmsg()
      return
   end if

   let l_sql = "SELECT pmi01,pmi02,pmi03,pmi04,'N' pmi05,'0' pmi06,'N' pmi07,'N' pmiconf,'Y' pmiacti,'",g_user,"','",g_grup,
                "','','",g_today,"',pmi08,pmi081,pmi09, ",
               " pmi10,'",g_plant,"','",g_legal,"','",g_user,"','",g_grup,"',",
               " '', ",
               " row_number() OVER(PARTITION BY pmi01,pmi02,pmi09,pmi03,pmi08 ORDER BY pmj03) pmj02, ", --此为项次
               " pmj03,pmj031,pmj032,''pmj04,pmj05,pmj06,pmj07,pmj08,pmj09,pmj10,pmj06t,pmj07t,pmj11, ",
               " pmi10 pmj12,pmj13,'",g_plant,"','",g_legal,"','' pmj14,'' pmjcd14,",
               " '','','','',0,0,'','','','',0,0,0,'','', ",  #darcy:2023/08/09 add
               " tc_pmx01,tc_pmx02 ",
               " from cpmp252_tmp order by pmi01,pmi02,pmi09,pmi03,pmi08 "
   prepare p252_gen_pmj from l_sql
   declare p252_gen_pmj_cl cursor for p252_gen_pmj

   let g_success = 'Y'
   begin work
   initialize l_pmi.* to null
   initialize l_pmj.* to null
   let l_j = 0 
   let l_i = 0
   let l_begin = "" let l_begin_1 =""
   let l_end = "" let l_end_1 = ""
   foreach p252_gen_pmj_cl into l_pmi.*,l_pmj.*,l_tc_pmx01,l_tc_pmx02
      if sqlca.sqlcode then
         call cl_err('p252_gen_pmj_cl',sqlca.sqlcode,1)
         exit foreach
      end if
      if l_pmj.pmj02 = 1 then
         #新增单别
         let l_pmi01 = ""
         call s_auto_assign_no("apm",l_pmi.pmi01,l_pmi.pmi02,"5","pmi_file","pmi01","","","")
               returning li_result,l_pmi01
         if (not li_result) then
            call cl_err(l_pmi.pmi01,'wag-673',1)
            let g_success ='N'
            rollback work
            exit foreach
         end if
         if l_pmi.pmi01 = 'PRL' then
            if not l_i then
               # 一般核价
               let l_begin = l_pmi01
               let l_i = 1
            end if
            let l_end = l_pmi01
         end if
         if l_pmi.pmi01 = 'PRM' then
            if not l_j then
               # 一般核价
               let l_begin_1 = l_pmi01
               let l_j = 1
            end if
            let l_end_1 = l_pmi01
         end if
         select smyapr into l_pmi.pmi07 from smy_file
             where smyslip = l_pmi.pmi01
         if cl_null(l_pmi.pmi07) then let l_pmi.pmi07 = 'N' end if
         let l_pmi.pmi01 = l_pmi01
         #插入单头
         insert into pmi_file values (l_pmi.*)
         if sqlca.sqlcode then
            call cl_err(l_pmi.pmi01,sqlca.sqlcode,1)
            let g_success = 'N'
            rollback work
         end if
      end if
      #darcy:2023/07/29 add s---
      # 依据料号设置上次核价单价和核价日期
      let l_pmj.ta_pmj01 = null
      let l_pmj.ta_pmj02 = null
      let l_pmj.ta_pmj03 = null
      let l_pmj.ta_pmj04 = null
      let l_pmj.ta_pmj05 = null
      let l_pmj.ta_pmj06 = null
      open p252_gen_pmj_cl2 using l_pmj.pmj03,l_pmj.pmj10,l_pmj.pmj12,l_pmj.pmj13,l_pmj.pmj03,l_pmj.pmj10,l_pmj.pmj12,l_pmj.pmj13
      fetch p252_gen_pmj_cl2 into l_pmj.ta_pmj01,l_pmj.ta_pmj02,l_pmj.ta_pmj03,l_pmj.ta_pmj04,l_pmj.ta_pmj05,l_pmj.ta_pmj06
      close p252_gen_pmj_cl2
      #darcy:2023/07/29 add e---
      # 插入单身
      let l_pmj.pmj01 = l_pmi01
      insert into pmj_file values (l_pmj.*)
      if sqlca.sqlcode then
         call cl_err(l_pmj.pmj01||"-"||l_pmj.pmj02,sqlca.sqlcode,1)
         let g_success = 'N'
         rollback work
      end if

      update tc_pmx_file set tc_pmx18 = l_pmj.pmj01,tc_pmx19 = l_pmj.pmj02
       where tc_pmx01 = l_tc_pmx01 and tc_pmx02 = l_tc_pmx02
      if sqlca.sqlcode then
         call cl_err(l_tc_pmx01||"-"||l_tc_pmx02,sqlca.sqlcode,1)
         let g_success = 'N'
         rollback work
      end if
   end foreach
   if g_success = 'Y' then
      commit work
   else 
      rollback work
      return
   end if

   let l_msg = "产生成功，",l_begin,"~",l_end,",",l_begin_1,"~",l_end_1

   call cl_err(l_msg,'!',0)

   #darcy:2023/06/27 add s---
   # 删除已经成功的资料 
   for l_i = 1 to g_pmj.getlength()
      label checkpiont:
      let l_cnt = 0
      select count(1) into l_cnt from tc_pmx_file
      where tc_pmx01 = g_pmj[l_i].tc_pmx01 and tc_pmx02 = g_pmj[l_i].tc_pmx02
         and tc_pmx18 is not null and tc_pmx18 !=" "
      if l_cnt > 0 then
         # 已产生
         call g_pmj.deleteElement(l_i)
         if l_i > g_pmj.getLength() then
            exit for
         end if
         goto checkpiont
      end if
   end for 
   #darcy:2023/06/27 add e---

   # if g_user!='tiptop' then
   #    if cl_confirm('cpm-077') then

   #       if not cl_null(l_begin) then
   #          let l_msg = " apmi255 ",l_begin," query ",l_end
   #          call cl_cmdrun(l_msg)
            
   #       end if

   #       if not cl_null(l_begin_1) then
   #          let l_msg = " apmi265 ",l_begin_1," query ",l_end_1
   #          call cl_cmdrun(l_msg)
   #       end if
   #    end if
   #    return
   # end if
   if cl_confirm('cpm-076') then 
      declare cpmp252_ef_cl cursor for 
         select pmi01,pmi10 from pmi_file where pmi01 between l_begin and l_end or pmi01 between l_begin_1 and l_end_1
      let l_i = 1
      call sr.clear()
      foreach cpmp252_ef_cl into sr[l_i].*
         if sqlca.sqlcode then
            call cl_err("cpmp252_ef_c;",sqlca.sqlcode,1)
            let g_success = 'N'
            exit foreach
         end if 
         let l_i = l_i + 1
      end foreach
      call sr.deleteElement(l_i)
      let g_success = 'Y'
      for l_i = 1 to sr.getlength()
         if sr[l_i].pmi10 = '1' then
            let g_prog ='apmi255'
         else
            let g_prog ='apmi265'
         end if
         if not aws_efcli2(sr[l_i].pmi01) then
            let g_success = 'N'
            exit for
         end if
      end for
      if g_success ='Y' then
         call cl_err('开单成功', '!', 1)
      else
         if cl_confirm('cpm-077') then

            if not cl_null(l_begin) then
               let l_msg = " apmi255 ",l_begin," query ",l_end
               call cl_cmdrun(l_msg)
            end if

            if not cl_null(l_begin_1) then
               let l_msg = " apmi265 ",l_begin_1," query ",l_end_1
               call cl_cmdrun(l_msg)
            end if
         end if
      end if
   end if

end function
