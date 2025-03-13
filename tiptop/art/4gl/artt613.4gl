# Prog. Version..: '5.30.06-13.04.09(00010)'     #
#
# Pattern name...: artt613.4gl
# Descriptions...: 待抵變更單維護作業
# Date & Author..: NO.FUN-BB0117 11/11/23 By xumm 
# Modify.........: No:FUN-C20019 12/02/06 By minpp 添加“拋轉財務”按鈕 
# Modify.........: No:FUN-C20079 12/02/14 By xumeimei 客戶簡稱從occ_file表中抓取
# Modify.........: No.TQC-C20204 12/02/15 By xuxz 調整傳入參數的取值方法
# Modify.........: No.TQC-C20464 12/02/24 By minpp 增加判斷。若待抵變更單的狀況碼<>2則報錯 
# Modify.........: No.TQC-C20430 12/02/28 By wangrr 拋轉財務中，將cl_wait() mark
# Modify.........: No:FUN-C30029 12/03/20 By minpp 添加'拋轉還原'按鈕
# Modify.........: No:TQC-C40007 12/04/05 By suncx 已拋轉財務的再點擊“拋轉財務”按鈕需要提示
# Modify.........: No.FUN-C10024  12/05/17 By jinjj 帳套取歷年主會計帳別檔tna_file
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-C90050 12/10/25 By Lori 預設單別/預設POS上傳單別改以s_get_defslip取得
# Modify.........: No.FUN-CB0076 12/11/12 By xumeimei 添加GR打印功能
# Modify.........: No.CHI-D20015 13/03/26 By minpp 修改审核人员审核日期为审核异动人员审核异动日期，取消审核给人员日期值
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_lum            RECORD LIKE lum_file.*,    
       g_lum_t          RECORD LIKE lum_file.*,   
       g_lum_o          RECORD LIKE lum_file.*,  
       g_lum01_t        LIKE lum_file.lum01,      
       g_lun            DYNAMIC ARRAY OF RECORD
           lun02        LIKE lun_file.lun02,
           lun03        LIKE lun_file.lun03,
           lun04        LIKE lun_file.lun04,
           lun05        LIKE lun_file.lun05,
           oaj02        LIKE oaj_file.oaj02,
           oaj05        LIKE oaj_file.oaj05,
           lun06        LIKE lun_file.lun06,
           lun07        LIKE lun_file.lun07,
           lun08        LIKE lun_file.lun08,
           amt_1        LIKE lul_file.lul08, 
           oaj04        LIKE oaj_file.oaj04,
           aag02        LIKE aag_file.aag02,
           oaj041       LIKE oaj_file.oaj041,
           aag02_1      LIKE aag_file.aag02
                        END RECORD,
       g_lun_t          RECORD                    
           lun02        LIKE lun_file.lun02,
           lun03        LIKE lun_file.lun03,
           lun04        LIKE lun_file.lun04,
           lun05        LIKE lun_file.lun05,
           oaj02        LIKE oaj_file.oaj02,
           oaj05        LIKE oaj_file.oaj05,
           lun06        LIKE lun_file.lun06,
           lun07        LIKE lun_file.lun07,
           lun08        LIKE lun_file.lun08,
           amt_1        LIKE lul_file.lul08, 
           oaj04        LIKE oaj_file.oaj04,
           aag02        LIKE aag_file.aag02,
           oaj041       LIKE oaj_file.oaj041,
           aag02_1      LIKE aag_file.aag02
                        END RECORD,
       g_lun_o          RECORD                     
           lun02        LIKE lun_file.lun02,
           lun03        LIKE lun_file.lun03,
           lun04        LIKE lun_file.lun04,
           lun05        LIKE lun_file.lun05,
           oaj02        LIKE oaj_file.oaj02,
           oaj05        LIKE oaj_file.oaj05,
           lun06        LIKE lun_file.lun06,
           lun07        LIKE lun_file.lun07,
           lun08        LIKE lun_file.lun08,
           amt_1        LIKE lul_file.lul08, 
           oaj04        LIKE oaj_file.oaj04,
           aag02        LIKE aag_file.aag02,
           oaj041       LIKE oaj_file.oaj041,
           aag02_1      LIKE aag_file.aag02
                        END RECORD,
          g_sql            STRING,                      
          g_wc             STRING,                     
          g_wc2            STRING,                    
          g_rec_b          LIKE type_file.num5,      
          l_ac             LIKE type_file.num5      
DEFINE g_forupd_sql        STRING            
DEFINE g_before_input_done LIKE type_file.num5 
DEFINE g_chr               LIKE type_file.chr1
DEFINE g_cnt               LIKE type_file.num10
DEFINE li_result           LIKE type_file.num5  
DEFINE g_msg               LIKE ze_file.ze03  
DEFINE g_curs_index        LIKE type_file.num10 
DEFINE g_row_count         LIKE type_file.num10 
DEFINE g_jump              LIKE type_file.num10 
DEFINE g_no_ask            LIKE type_file.num5                        
DEFINE g_confirm           LIKE type_file.chr1
DEFINE g_void              LIKE type_file.chr1
DEFINE g_t1                LIKE oay_file.oayslip
DEFINE g_argv1             LIKE lum_file.lum01
#FUN-CB0076----add---str
DEFINE g_wc1             STRING
DEFINE g_wc3             STRING
DEFINE g_wc4             STRING
DEFINE l_table           STRING
TYPE sr1_t RECORD
    lumplant  LIKE lum_file.lumplant,
    lum01     LIKE lum_file.lum01,
    lum05     LIKE lum_file.lum05,
    lum02     LIKE lum_file.lum02,
    lum07     LIKE lum_file.lum07,
    lum08     LIKE lum_file.lum08,
    lum06     LIKE lum_file.lum06,
    lum03     LIKE lum_file.lum03,
    lum051    LIKE lum_file.lum051,
    lum09     LIKE lum_file.lum09,
    lum071    LIKE lum_file.lum071,
    lum081    LIKE lum_file.lum081,
    lum061    LIKE lum_file.lum061,
    lum10     LIKE lum_file.lum10,
    lum11     LIKE lum_file.lum11,
    lum12     LIKE lum_file.lum12,
    lumcond   LIKE lum_file.lumcond,
    lumcont   LIKE lum_file.lumcont,
    lumconu   LIKE lum_file.lumconu,
    lun02     LIKE lun_file.lun02,
    lun03     LIKE lun_file.lun03,
    lun04     LIKE lun_file.lun04,
    lun05     LIKE lun_file.lun05,
    lun06     LIKE lun_file.lun06,
    lun07     LIKE lun_file.lun07,
    lun08     LIKE lun_file.lun08,
    rtz13     LIKE rtz_file.rtz13,
    occ02     LIKE occ_file.occ02,
    occ02_1   LIKE occ_file.occ02,
    gen02     LIKE gen_file.gen02,
    oaj02     LIKE oaj_file.oaj02,
    oaj05     LIKE oaj_file.oaj05,
    amt       LIKE lum_file.lum10,
    amt_1     LIKE lun_file.lun06
END RECORD
#FUN-CB0076----add---end


MAIN
   OPTIONS                              
      INPUT NO WRAP
   DEFER INTERRUPT

   LET g_argv1=ARG_VAL(1)
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ART")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
  #FUN-CB0076----add---str
   LET g_pdate = g_today
   LET g_sql ="lumplant.lum_file.lumplant,",
    "lum01.lum_file.lum01,",
    "lum05.lum_file.lum05,",
    "lum02.lum_file.lum02,",
    "lum07.lum_file.lum07,",
    "lum08.lum_file.lum08,",
    "lum06.lum_file.lum06,",
    "lum03.lum_file.lum03,",
    "lum051.lum_file.lum051,",
    "lum09.lum_file.lum09,",
    "lum071.lum_file.lum071,",
    "lum081.lum_file.lum081,",
    "lum061.lum_file.lum061,",
    "lum10.lum_file.lum10,",
    "lum11.lum_file.lum11,",
    "lum12.lum_file.lum12,",
    "lumcond.lum_file.lumcond,",
    "lumcont.lum_file.lumcont,",
    "lumconu.lum_file.lumconu,",
    "lun02.lun_file.lun02,",
    "lun03.lun_file.lun03,",
    "lun04.lun_file.lun04,",
    "lun05.lun_file.lun05,",
    "lun06.lun_file.lun06,",
    "lun07.lun_file.lun07,",
    "lun08.lun_file.lun08,",
    "rtz13.rtz_file.rtz13,",
    "occ02.occ_file.occ02,",
    "occ02_1.occ_file.occ02,",
    "gen02.gen_file.gen02,",
    "oaj02.oaj_file.oaj02,",
    "oaj05.oaj_file.oaj05,",
    "amt.lum_file.lum10,",
    "amt_1.lun_file.lun06"
   LET l_table = cl_prt_temptable('artt613',g_sql) CLIPPED
   IF l_table = -1 THEN
      CALL cl_used(g_prog, g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
   END IF
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
             " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,
                      ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog, g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
   END IF
   #FUN-CB0076------add-----end 

   LET g_forupd_sql = "SELECT * FROM lum_file WHERE lum01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t613_cl CURSOR FROM g_forupd_sql
 
   OPEN WINDOW t613_w WITH FORM "art/42f/artt613"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   CALL cl_set_locale_frm_name("artt613")   
   CALL cl_ui_init()

   IF NOT cl_null(g_argv1) THEN
       CALL t613_q()
   END IF
   LET g_pdate = g_today   
 
   IF g_aza.aza63 <> 'Y' THEN
      CALL cl_set_comp_visible("oaj041,aag02_1",FALSE)
   END IF
   CALL t613_menu()
   CLOSE WINDOW t613_w               
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
    CALL cl_gre_drop_temptable(l_table)    #FUN-CB0076 add
END MAIN
 
FUNCTION t613_cs()
   CLEAR FORM 
   CALL g_lun.clear()
 
   IF g_wc =' ' THEN
      LET g_wc=' 1=1'
   END IF

   CALL cl_set_head_visible("","YES")   
   INITIALIZE g_lum.* TO NULL    
   IF cl_null(g_argv1) THEN
      DIALOG ATTRIBUTE (UNBUFFERED) 
      CONSTRUCT BY NAME g_wc ON lum01,lum03,lum04,lum02,lumplant,lumlegal,lum05,lum06,lum07,lum08,
                                lum10,lum11,lum12,lum051,lum061,lum071,lum081,lum09,lum13,lum14,
                                lum17,lummksg,lum16,lumconf,lumconu,lumcond,lumcont,lum15,lumuser,lumgrup,
                                lumoriu,lummodu,lumdate,lumorig,lumacti,lumcrat
 
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(lum01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_lum01"
                  LET g_qryparam.state = 'c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lum01
                  NEXT FIELD lum01

               WHEN INFIELD(lum02)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_lum02"
                  LET g_qryparam.state = 'c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lum02
                  NEXT FIELD lum02
                  
               WHEN INFIELD(lumplant)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_lumplant"
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.default1 = g_plant
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lumplant
                  NEXT FIELD lumplant
      
               WHEN INFIELD(lumlegal)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_lumlegal"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.default1 = g_legal
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lumlegal
                  NEXT FIELD lumlegal

                WHEN INFIELD(lum05)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_lum05"
                  LET g_qryparam.state = 'c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lum05
                  NEXT FIELD lum05 

                WHEN INFIELD(lum06)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_lum06"
                  LET g_qryparam.state = 'c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lum06
                  NEXT FIELD lum06

                WHEN INFIELD(lum07)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_lum07"
                  LET g_qryparam.state = 'c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lum07
                  NEXT FIELD lum07

                WHEN INFIELD(lum051)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_lum051"
                  LET g_qryparam.state = 'c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lum051
                  NEXT FIELD lum051

                WHEN INFIELD(lum061)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_lum061"
                  LET g_qryparam.state = 'c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lum061
                  NEXT FIELD lum061

                WHEN INFIELD(lum071)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_lum071"
                  LET g_qryparam.state = 'c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lum071
                  NEXT FIELD lum071

                WHEN INFIELD(lum09)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_lum09"
                  LET g_qryparam.state = 'c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lum09
                  NEXT FIELD lum09

                WHEN INFIELD(lum13)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_lum13"
                  LET g_qryparam.state = 'c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lum13
                  NEXT FIELD lum13

                WHEN INFIELD(lum14)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_lum14"
                  LET g_qryparam.state = 'c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lum14
                  NEXT FIELD lum14
                  
                WHEN INFIELD(lumconu)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_lumconu"
                  LET g_qryparam.state = 'c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lumconu
                  NEXT FIELD lumconu 
                  
               OTHERWISE EXIT CASE
            END CASE
      
      END CONSTRUCT
      
      CONSTRUCT g_wc2 ON lun02,lun03,lun04,lun05,lun06,lun07,lun08
                    FROM s_lun[1].lun02,s_lun[1].lun03,s_lun[1].lun04,s_lun[1].lun05,
                         s_lun[1].lun06,s_lun[1].lun07,s_lun[1].lun08                
 
            BEFORE CONSTRUCT
      
            ON ACTION CONTROLP
               CASE
                  WHEN INFIELD(lun03) 
                       CALL cl_init_qry_var()
                       LET g_qryparam.state = 'c'
                       LET g_qryparam.form ="q_lun03" 
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO lun03
                       NEXT FIELD lun03
                       
                  WHEN INFIELD(lun05) 
                       CALL cl_init_qry_var()
                       LET g_qryparam.state = 'c'
                       LET g_qryparam.form ="q_lun05"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO lun05
                       NEXT FIELD lun05
               END CASE
 
        END CONSTRUCT

        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE DIALOG

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

        ON ACTION close
           LET INT_FLAG=1
           EXIT DIALOG

        ON ACTION accept
           EXIT DIALOG

        ON ACTION cancel
           LET INT_FLAG=1
           EXIT DIALOG

      END DIALOG   
   END IF
   IF INT_FLAG THEN
      RETURN
   END IF

   IF NOT cl_null(g_argv1) THEN
      LET g_sql = "SELECT lum01 FROM lum_file ",
                  " WHERE lum09 = '",g_argv1,"'",
                  " ORDER BY lum01"
   ELSE
      IF g_wc2 = " 1=1" THEN    
         LET g_sql = "SELECT lum01 FROM lum_file ",
                     " WHERE ", g_wc CLIPPED,
                     " ORDER BY lum01"
      ELSE                     
         LET g_sql = "SELECT UNIQUE lum_file.lum01 ",
                     "  FROM lum_file, lun_file ",
                     " WHERE lum01 = lun01",
                     "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                     " ORDER BY lum01"
      END IF
   END IF
 
   PREPARE t613_prepare FROM g_sql
   DECLARE t613_cs  SCROLL CURSOR WITH HOLD FOR t613_prepare

   IF NOT cl_null(g_argv1) THEN
      LET g_sql="SELECT COUNT(*) FROM lum_file WHERE lum09 = '",g_argv1,"'" 
   ELSE
      IF g_wc2 = " 1=1" THEN 
         LET g_sql="SELECT COUNT(*) FROM lum_file WHERE ",g_wc CLIPPED
      ELSE
         LET g_sql="SELECT COUNT(DISTINCT lum01) FROM lum_file,lun_file WHERE ",
                   "lun01=lum01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
      END IF
   END IF
 
   PREPARE t613_precount FROM g_sql
   DECLARE t613_count CURSOR FOR t613_precount
 
END FUNCTION
 
FUNCTION t613_menu()
 
   WHILE TRUE
      CALL t613_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t613_a()
            END IF
 
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t613_q()
            END IF
 
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t613_r()
            END IF
 
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t613_u()
            END IF
        
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()

         WHEN "exporttoexcel"  
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_lun),'','')
            END IF 

         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t613_confirm()
               CALL t613_pic()
            END IF   
                    
         WHEN "unconfirm"
            IF cl_chk_act_auth() THEN
               CALL t613_unconfirm()
               CALL t613_pic()
            END IF

         WHEN "change_post"
            IF cl_chk_act_auth() THEN
               CALL t613_post()
            END IF  
          #FUN-C20019--add--str
         WHEN "spin_fin"                      #拋轉財務
            IF cl_chk_act_auth() THEN
               CALL t613_axrp604()
            END IF 
         #FUN-C20019--add--end  

         #FUN-C30029--ADD--STR
         WHEN "undo_spin_fin"                      #拋轉財務
            IF cl_chk_act_auth() THEN
               CALL t613_axrp608()
            END IF
         #FUN-C30029--ADD--END
         WHEN "related_document" 
              IF cl_chk_act_auth() THEN
                 IF g_lum.lum01 IS NOT NULL THEN
                 LET g_doc.column1 = "lum01"
                 LET g_doc.value1 = g_lum.lum01
                 CALL cl_doc()
               END IF
         END IF
         
         #FUN-CB0076------add----str
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t613_out()
            END IF
         #FUN-CB0076------add----end
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t613_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1 
 
   IF p_ud <> "G"  THEN
      RETURN
   END IF

   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_lun TO s_lun.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()      
 
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
 
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      
       #FUN-CB0076------add-----str
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      #FUN-CB0076------add-----end

      ON ACTION locale
         CALL cl_dynamic_locale()

      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
      
      ON ACTION unconfirm
         LET g_action_choice="unconfirm"
         EXIT DISPLAY

      ON ACTION change_post
         LET g_action_choice="change_post"
         EXIT DISPLAY 

      ON ACTION first
         CALL t613_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   
 
      ON ACTION previous
         CALL t613_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
 
      ON ACTION jump
         CALL t613_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
      ON ACTION next
         CALL t613_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
      ON ACTION last
         CALL t613_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
#---------FUN-C20019--add--str
      ON ACTION spin_fin
         LET g_action_choice = "spin_fin"
         EXIT DISPLAY
#---------FUN-C20019--add-end
#FUN-C30029--ADD--STR
     ON ACTION undo_spin_fin
         LET g_action_choice = "undo_spin_fin"
         EXIT DISPLAY
#FUN-C30029--ADD--END
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY

      ON ACTION exporttoexcel 
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE       
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about        
         CALL cl_about()    
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION controls         
         CALL cl_set_head_visible("","AUTO")     
 
      ON ACTION related_document                
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION t613_bp_refresh()
   DISPLAY ARRAY g_lun TO s_lun.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY
         
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
         
   END DISPLAY
END FUNCTION
 
FUNCTION t613_a()
   MESSAGE ""
   CLEAR FORM
   CALL g_lun.clear()
   LET g_wc = NULL 
   LET g_wc2= NULL
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   INITIALIZE g_lum.* LIKE lum_file.*      
   LET g_lum01_t = NULL

 
   LET g_lum_t.* = g_lum.*
   LET g_lum_o.* = g_lum.*
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_lum.lum03 = g_today
      LET g_lum.lum04 = g_today
      LET g_lum.lum13 = g_user
      LET g_lum.lum14 = g_grup
      LET g_lum.lummksg = 'N'
      LET g_lum.lum16 = '0'
      LET g_lum.lumconf = 'N'
      LET g_lum.lumuser = g_user
      LET g_lum.lumoriu = g_user
      LET g_lum.lumorig = g_grup
      LET g_lum.lumgrup = g_grup
      LET g_lum.lumdate = g_today
      LET g_lum.lumacti = 'Y' 
      LET g_lum.lumcrat = g_today 
      LET g_lum.lumplant = g_plant
      LET g_lum.lumlegal = g_legal
      CALL t613_desc()
      CALL t613_i("a")         
 
      IF INT_FLAG THEN              
         INITIALIZE g_lum.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         CLEAR FORM
         CALL g_lun.clear()
         EXIT WHILE
      END IF
 
      IF cl_null(g_lum.lum01) THEN     
         CONTINUE WHILE
      END IF
 
      BEGIN WORK
      
      CALL s_auto_assign_no("art",g_lum.lum01,g_today,'B3',"lum_file","lum01","","","")
           RETURNING li_result,g_lum.lum01
      IF (NOT li_result) THEN  
          ROLLBACK WORK
          CONTINUE WHILE
      END IF
      DISPLAY BY NAME g_lum.lum01
 
      INSERT INTO lum_file VALUES (g_lum.*)
 
      IF SQLCA.sqlcode THEN               
         CALL cl_err3("ins","lum_file",g_lum.lum01,"",SQLCA.sqlcode,"","",1) 
         ROLLBACK WORK      
         CONTINUE WHILE
      ELSE
         COMMIT WORK     
         CALL cl_flow_notify(g_lum.lum01,'I')
      END IF
 
      SELECT lum01 INTO g_lum.lum01 FROM lum_file
       WHERE lum01 = g_lum.lum01
      LET g_lum01_t = g_lum.lum01   
      LET g_lum_t.* = g_lum.*
      LET g_lum_o.* = g_lum.*
       
      LET g_rec_b = 0  
      CALL t613_ins_lun()   
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION t613_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_lum.lum01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   IF g_lum.lum16 = '2' THEN
      CALL cl_err('','alm-941',1)
      RETURN
   END IF
   
   SELECT * INTO g_lum.* FROM lum_file
    WHERE lum01=g_lum.lum01

   IF g_lum.lumconf = 'Y' THEN
      CALL cl_err('','alm1061',0)
      RETURN
   END IF
 
   IF g_lum.lumacti ='N' THEN    
      CALL cl_err(g_lum.lum01,'mfg1000',0)
      RETURN
   END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_lum01_t = g_lum.lum01
   BEGIN WORK

   OPEN t613_cl USING g_lum.lum01
   IF STATUS THEN
      CALL cl_err("OPEN t613_cl:", STATUS, 1)
      CLOSE t613_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t613_cl INTO g_lum.*           
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_lum.lum01,SQLCA.sqlcode,0) 
       CLOSE t613_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   CALL t613_show()
 
   WHILE TRUE
      LET g_lum01_t = g_lum.lum01
      LET g_lum_o.* = g_lum.*
      LET g_lum.lummodu = g_user
      LET g_lum.lumdate = g_today          
      
 
      CALL t613_i("u")                 
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_lum.*=g_lum_t.*
         CALL t613_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      IF g_lum.lum01 != g_lum01_t THEN       
         UPDATE lum_file SET lum01 = g_lum.lum01
          WHERE lum01 = g_lum01_t
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","lum_file",g_lum01_t,"",SQLCA.sqlcode,"","lum",1)  
            CONTINUE WHILE
         END IF
      END IF
 
      UPDATE lum_file SET lum_file.* = g_lum.*
       WHERE lum01 = g_lum_t.lum01
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","lum_file","","",SQLCA.sqlcode,"","",1) 
         CONTINUE WHILE
      END IF
 
      IF g_lum.lum02 <> g_lum_t.lum02 THEN
         CALL g_lun.clear()
         DELETE FROM lun_file WHERE lun01 = g_lum.lum01
         CALL t613_ins_lun()
      END IF
      EXIT WHILE
   END WHILE
 
   CLOSE t613_cl
   COMMIT WORK
   CALL cl_flow_notify(g_lum.lum01,'U')
 
   CALL t613_b_fill("1=1")
   CALL t613_bp_refresh()
 
END FUNCTION
 
FUNCTION t613_i(p_cmd)
   DEFINE  p_cmd       LIKE type_file.chr1 
   DEFINE  l_ooz09     LIKE ooz_file.ooz09
   DEFINE  l_gen03     LIKE gen_file.gen03
   IF s_shut(0) THEN
      RETURN
   END IF
 
   DISPLAY BY NAME g_lum.lum01,g_lum.lum03,g_lum.lum04,g_lum.lum02,g_lum.lumplant,g_lum.lumlegal,
                   g_lum.lum05,g_lum.lum06,g_lum.lum07,g_lum.lum08,g_lum.lum10,g_lum.lum11,g_lum.lum12,
                   g_lum.lum051,g_lum.lum061,g_lum.lum071,g_lum.lum081,g_lum.lum09,g_lum.lum13,g_lum.lum14,
                   g_lum.lum17,g_lum.lummksg,g_lum.lum16,g_lum.lumconf,g_lum.lumconu,g_lum.lumcond,
                   g_lum.lumcont,g_lum.lum15,g_lum.lumuser,g_lum.lumgrup,g_lum.lumoriu,g_lum.lummodu,
                   g_lum.lumdate,g_lum.lumorig,g_lum.lumacti,g_lum.lumcrat
 
   CALL cl_set_head_visible("","YES")        
   INPUT BY NAME   g_lum.lum01,g_lum.lum03,g_lum.lum04,g_lum.lum02,g_lum.lumplant,g_lum.lumlegal,
                   g_lum.lum05,g_lum.lum06,g_lum.lum07,g_lum.lum08,g_lum.lum10,g_lum.lum11,g_lum.lum12,
                   g_lum.lum051,g_lum.lum061,g_lum.lum071,g_lum.lum081,g_lum.lum09,g_lum.lum13,g_lum.lum14,
                   g_lum.lum17,g_lum.lummksg,g_lum.lum16,g_lum.lumconf,g_lum.lumconu,g_lum.lumcond,
                   g_lum.lumcont,g_lum.lum15,g_lum.lumuser,g_lum.lumgrup,g_lum.lumoriu,g_lum.lummodu,
                   g_lum.lumdate,g_lum.lumorig,g_lum.lumacti,g_lum.lumcrat
                   
       WITHOUT DEFAULTS
 
     BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t613_set_entry(p_cmd)
         CALL t613_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
         CALL cl_set_docno_format("lum01")
 
      AFTER FIELD lum01
       DISPLAY "AFTER FIELD lum01"
         IF g_lum.lum01 IS NOT NULL THEN
            IF p_cmd = "a" OR (p_cmd = "u" AND g_lum.lum01 != g_lum01_t) THEN
               CALL s_check_no("art",g_lum.lum01,g_lum_t.lum01,"B3","lum_file","lum01,lumplant","")
                    RETURNING li_result,g_lum.lum01
               IF (NOT li_result) THEN
                  LET g_lum.lum01 = g_lum_t.lum01
                  NEXT FIELD lum01
               END IF
               LET g_t1=s_get_doc_no(g_lum.lum01)
               SELECT oayapr INTO g_lum.lummksg FROM oay_file WHERE oayslip = g_t1
               DISPLAY BY NAME g_lum.lummksg
            END IF
         END IF

      AFTER FIELD lum04
         IF NOT cl_null(g_lum.lum04) THEN
            SELECT ooz09 INTO l_ooz09 FROM ooz_file
            IF g_lum.lum04 <= l_ooz09 THEN
               LET g_lum.lum04 = l_ooz09 + 1
               DISPLAY BY NAME g_lum.lum04
            END IF
         END IF

      
      AFTER FIELD lum02
        IF NOT cl_null(g_lum.lum02) THEN
            IF p_cmd = 'a' OR (p_cmd = 'u' AND g_lum_t.lum02 <> g_lum.lum02) THEN
               CALL t613_lum02('d') 
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_lum.lum02,g_errno,0)
                  LET g_lum.lum02 = g_lum_t.lum02
                  DISPLAY BY NAME g_lum.lum02
                  NEXT FIELD lum02
               END IF
               CALL t613_lum02_1()
               IF NOT cl_null(g_lum.lum07) THEN
                  CALL t613_lnt30()
               ELSE
                  CALL t613_lne08()
               END IF
            END IF
         END IF

     AFTER FIELD lum051
       IF NOT cl_null(g_lum.lum051) THEN
          IF g_lum.lum051 = g_lum.lum05 THEN
             CALL cl_err(g_lum.lum051,'art1022',0)
             LET g_lum.lum051 = g_lum_t.lum051
             DISPLAY BY NAME g_lum.lum051
             NEXT FIELD lum051
          END IF
          CALL t613_lum051()
          IF NOT cl_null(g_errno) THEN
             CALL cl_err(g_lum.lum051,g_errno,0)
             LET g_lum.lum051 = g_lum_t.lum051
             DISPLAY BY NAME g_lum.lum051
             NEXT FIELD lum051
          END IF
          IF NOT cl_null(g_lum.lum071) THEN
             CALL t613_chk_lum071()
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_lum.lum051,g_errno,0)
                LET g_lum.lum051 = g_lum_t.lum051
                DISPLAY BY NAME g_lum.lum051
                NEXT FIELD lum051 
             END IF
          END IF
       END IF
       CALL t613_desc()

     AFTER FIELD lum061
       IF NOT cl_null(g_lum.lum061) THEN
          IF g_lum.lum061 = g_lum.lum06 THEN
             CALL cl_err(g_lum.lum061,'art1023',0)
             LET g_lum.lum061 = g_lum_t.lum061
             DISPLAY BY NAME g_lum.lum061
             NEXT FIELD lum061
          END IF
          CALL t613_lum061()
          IF NOT cl_null(g_errno) THEN
             CALL cl_err(g_lum.lum061,g_errno,0)
             LET g_lum.lum061 = g_lum_t.lum061
             DISPLAY BY NAME g_lum.lum061
             NEXT FIELD lum061
          END IF
          IF NOT cl_null(g_lum.lum071) THEN
             CALL t613_chk_lum071()
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_lum.lum061,g_errno,0)
                LET g_lum.lum061 = g_lum_t.lum061
                DISPLAY BY NAME g_lum.lum061
                NEXT FIELD lum061 
             END IF
          END IF
       END IF

     AFTER FIELD lum071
       IF NOT cl_null(g_lum.lum071) THEN
          IF g_lum.lum071 = g_lum.lum07 THEN
             CALL cl_err(g_lum.lum051,'art1024',0)
             LET g_lum.lum071 = g_lum_t.lum071
             DISPLAY BY NAME g_lum.lum071
             NEXT FIELD lum071
          END IF
          CALL t613_lum071()
          IF NOT cl_null(g_errno) THEN
             CALL cl_err(g_lum.lum071,g_errno,0)
             LET g_lum.lum071 = g_lum_t.lum071
             DISPLAY BY NAME g_lum.lum071
             NEXT FIELD lum071
          END IF
          CALL t613_chk_lum071()
          IF NOT cl_null(g_errno) THEN
             CALL cl_err(g_lum.lum071,g_errno,0)
             LET g_lum.lum071 = g_lum_t.lum071
             DISPLAY BY NAME g_lum.lum071
             NEXT FIELD lum071 
          END IF
          SELECT lnt02 INTO g_lum.lum081 FROM lnt_file WHERE lnt01 =  g_lum.lum071
       END IF
       
     AFTER FIELD lum13
       IF NOT cl_null(g_lum.lum13) THEN
          CALL t613_lum13()
          IF NOT cl_null(g_errno) THEN
             CALL cl_err(g_lum.lum13,g_errno,0)
             LET g_lum.lum13 = g_lum_t.lum13
             DISPLAY BY NAME g_lum.lum13
             NEXT FIELD lum13
          END IF
       END IF
       CALL t613_desc()

      AFTER FIELD lum14
       IF NOT cl_null(g_lum.lum14) THEN
          CALL t613_lum14()
          IF NOT cl_null(g_errno) THEN
             CALL cl_err(g_lum.lum14,g_errno,0)
             LET g_lum.lum14 = g_lum_t.lum14
             DISPLAY BY NAME g_lum.lum14
             NEXT FIELD lum14
          END IF
       END IF 
       CALL t613_desc()
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF       
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(lum01)
               LET g_t1=s_get_doc_no(g_lum.lum01)
               CALL q_oay(FALSE,FALSE,g_t1,'B3','ART') RETURNING g_t1
               LET g_lum.lum01 = g_t1
               DISPLAY BY NAME g_lum.lum01
               NEXT FIELD lum01

            WHEN INFIELD(lum02) 
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_luk"
               LET g_qryparam.default1 = g_lum.lum02
               CALL cl_create_qry() RETURNING g_lum.lum02
               DISPLAY BY NAME g_lum.lum02
               CALL t613_lum02('d')
               NEXT FIELD lum02
 
            WHEN INFIELD(lum13) 
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gen"
               LET g_qryparam.default1 = g_lum.lum13
               IF NOT cl_null(g_lum.lum14) THEN
                  LET g_qryparam.where = " gen03 = '", g_lum.lum14 ,"' "
               END IF
               CALL cl_create_qry() RETURNING g_lum.lum13
               DISPLAY BY NAME g_lum.lum13
               NEXT FIELD lum13

            WHEN INFIELD(lum14) 
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gem"
               LET g_qryparam.default1 = g_lum.lum14
               IF NOT cl_null(g_lum.lum13) THEN
                  SELECT gen03 INTO l_gen03 FROM  gen_file
                   WHERE gen01 = g_lum.lum13
                  LET g_qryparam.where = " gem01 = '", l_gen03 ,"' "
               END IF
               CALL cl_create_qry() RETURNING g_lum.lum14
               DISPLAY BY NAME g_lum.lum14
               NEXT FIELD lum14

            WHEN INFIELD(lum071)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_lnt01i"
               LET g_qryparam.default1 = g_lum.lum071
               LET g_qryparam.where = " lntplant IN ",g_auth," "
               CALL cl_create_qry() RETURNING g_lum.lum071
               DISPLAY BY NAME g_lum.lum071
               NEXT FIELD lum071

            WHEN INFIELD(lum061)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_lja06i"
               LET g_qryparam.default1 = g_lum.lum061
               LET g_qryparam.where = " lmfstore IN ",g_auth," "
               CALL cl_create_qry() RETURNING g_lum.lum061
               DISPLAY BY NAME g_lum.lum061
               NEXT FIELD lum061

            WHEN INFIELD(lum051)
               CALL cl_init_qry_var()
               #LET g_qryparam.form ="q_lja12i"   #FUN-C20079 mark
               LET g_qryparam.form ="q_occ"       #FUN-C20079 add
               LET g_qryparam.default1 = g_lum.lum051
               CALL cl_create_qry() RETURNING g_lum.lum051
               DISPLAY BY NAME g_lum.lum051
               NEXT FIELD lum051
             
            OTHERWISE EXIT CASE
          END CASE
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
       ON ACTION about        
          CALL cl_about()    
 
       ON ACTION help       
          CALL cl_show_help()
 
   END INPUT
 
END FUNCTION

FUNCTION t613_desc()
  DEFINE l_rtz13          LIKE rtz_file.rtz13
  DEFINE l_azt02          LIKE azt_file.azt02
  DEFINE l_lum05_desc     LIKE occ_file.occ02
  DEFINE l_lum051_desc    LIKE lne_file.lne05
  DEFINE l_gen02          LIKE gen_file.gen02
  DEFINE l_gem02          LIKE gem_file.gem02
  DEFINE l_gen02_1        LIKE gen_file.gen02
  DEFINE l_amt            LIKE lum_file.lum12 
  
  SELECT rtz13 INTO l_rtz13 FROM rtz_file WHERE rtz01 = g_lum.lumplant
  SELECT azt02 INTO l_azt02 FROM azt_file WHERE azt01 = g_lum.lumlegal
  SELECT occ02 INTO l_lum05_desc FROM occ_file WHERE occ01 = g_lum.lum05
  #SELECT lne05 INTO l_lum051_desc FROM lne_file WHERE lne01 = g_lum.lum051   #FUN-C20079 mark
  SELECT occ02 INTO l_lum051_desc FROM occ_file WHERE occ01 = g_lum.lum051    #FUN-C20079 add
  SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_lum.lum13
  SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01 = g_lum.lum14
  SELECT gen02 INTO l_gen02_1 FROM gen_file WHERE gen01 = g_lum.lumconu
  LET l_amt = g_lum.lum10 - g_lum.lum11 - g_lum.lum12
  DISPLAY l_rtz13 TO FORMONLY.rtz13
  DISPLAY l_azt02 TO FORMONLY.azt02
  DISPLAY l_lum05_desc TO FORMONLY.lum05_desc
  DISPLAY l_lum051_desc TO FORMONLY.lum051_desc
  DISPLAY l_gen02 TO FORMONLY.gen02
  DISPLAY l_gem02 TO FORMONLY.gem02
  DISPLAY l_gen02_1 TO FORMONLY.gen02_1
  DISPLAY l_amt TO FORMONLY.amt

END FUNCTION

FUNCTION t613_lnt30()
  DEFINE l_lnt30          LIKE lnt_file.lnt30
  DEFINE l_tqa02          LIKE tqa_file.tqa02
  

  SELECT lnt30 INTO l_lnt30 FROM lnt_file WHERE lnt01 = g_lum.lum07
  SELECT tqa02 INTO l_tqa02 FROM tqa_file WHERE tqa01 = l_lnt30 AND tqa03 = '2'

  DISPLAY l_lnt30 TO FORMONLY.lnt30
  DISPLAY l_tqa02 TO FORMONLY.tqa02
  
END FUNCTION

FUNCTION t613_lne08()
  DEFINE l_lne08          LIKE lne_file.lne08
  DEFINE l_tqa02          LIKE tqa_file.tqa02

  SELECT lne08 INTO l_lne08 FROM lne_file WHERE lne01 = g_lum.lum05
  SELECT tqa02 INTO l_tqa02 FROM tqa_file WHERE tqa01 = l_lne08 AND tqa03 = '2'

  DISPLAY l_lne08 TO FORMONLY.lnt30
  DISPLAY l_tqa02 TO FORMONLY.tqa02
  
END FUNCTION

FUNCTION t613_lum02(p_cmd)  
   DEFINE l_luk10         LIKE luk_file.luk10,
          l_luk11         LIKE luk_file.luk11,
          l_luk12         LIKE luk_file.luk12,
          l_amt           LIKE luk_file.luk12,
          p_cmd           LIKE type_file.chr1  
           
   LET g_errno = ' '
   SELECT luk10,luk11,luk12
     INTO l_luk10,l_luk11,l_luk12  
     FROM luk_file
    WHERE luk01 = g_lum.lum02
      AND lukacti = 'Y'
 
   CASE WHEN SQLCA.SQLCODE = 100        LET g_errno = 'alm1204'
        WHEN l_luk10 = l_luk11 +l_luk12 LET g_errno = 'alm1205'
        OTHERWISE                       LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF cl_null(g_errno) OR p_cmd = 'd' OR p_cmd = 'a' THEN
      LET g_lum.lum10 = l_luk10
      LET g_lum.lum11 = l_luk11
      LET g_lum.lum12 = l_luk12
      LET l_amt = l_luk10 - l_luk11 - l_luk12
      DISPLAY BY NAME g_lum.lum10,g_lum.lum11,g_lum.lum12
      DISPLAY l_amt TO FORMONLY.amt
   END IF
   
END FUNCTION

FUNCTION t613_lum02_1()  
   DEFINE l_luk06         LIKE luk_file.luk06,
          l_luk07         LIKE luk_file.luk07,
          l_luk08         LIKE luk_file.luk08,
          l_luk09         LIKE luk_file.luk09,
          l_lum05_desc    LIKE lne_file.lne05
 
   SELECT luk06,luk07,luk08,luk09
     INTO l_luk06,l_luk07,l_luk08,l_luk09  
     FROM luk_file
    WHERE luk01 = g_lum.lum02
      AND lukacti = 'Y'
      
   #SELECT lne05 INTO l_lum05_desc FROM lne_file WHERE lne01 = l_luk06   #FUN-C20079 mark
   SELECT occ02 INTO l_lum05_desc FROM occ_file WHERE occ01 = l_luk06    #FUN-C20079 add
   LET g_lum.lum05 = l_luk06
   LET g_lum.lum06 = l_luk07
   LET g_lum.lum07 = l_luk08
   LET g_lum.lum08 = l_luk09
   DISPLAY BY NAME g_lum.lum05,g_lum.lum06,g_lum.lum07,g_lum.lum08
   DISPLAY l_lum05_desc TO FORMONLY.lum05_desc
   
END FUNCTION
#FUN-C20079----mark----str----
#FUNCTION t613_lum051()  
#    DEFINE  l_lne01        LIKE lne_file.lne01,
#            l_lne36        LIKE lne_file.lne36 
# 
#    LET g_errno = " "
#    SELECT lne01,lne36 INTO l_lne01,l_lne36
#      FROM lne_file 
#     WHERE lne01 = g_lum.lum051 
#    CASE WHEN SQLCA.SQLCODE = 100         LET g_errno = 'alm-a01'
#         WHEN l_lne36 = 'N'               LET g_errno = 'alm-997'
#         OTHERWISE                        LET g_errno = SQLCA.SQLCODE USING '-------'
#    END CASE
#END FUNCTION
#FUN-C20079----mark----end----


#FUN-C20079----add----str----
FUNCTION t613_lum051()
    DEFINE  l_occ01      LIKE occ_file.occ01
    DEFINE  l_occacti    LIKE occ_file.occacti

    LET g_errno = " "
    SELECT occ01,occacti INTO l_occ01,l_occacti
      FROM occ_file
     WHERE occ01 = g_lum.lum051

    CASE WHEN SQLCA.SQLCODE = 100         LET g_errno = 'alm-a01'
         WHEN l_occacti  = 'N'            LET g_errno = 'alm-997'
         OTHERWISE                        LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
#FUN-C20079----add----end----
FUNCTION t613_lum061()  
    DEFINE  l_lmf01        LIKE lmf_file.lmf01,
            l_lmf06        LIKE lmf_file.lmf06 
 
    LET g_errno = " "
    SELECT lmf01,lmf06 INTO l_lmf01,l_lmf06
      FROM lmf_file 
     WHERE lmf01 = g_lum.lum061 
    CASE WHEN SQLCA.SQLCODE = 100         LET g_errno = 'alm-042'
         WHEN l_lmf06 = 'N'               LET g_errno = 'alm1063'
         OTHERWISE                        LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION

FUNCTION t613_lum071()  
    DEFINE  l_lnt01        LIKE lnt_file.lnt01,
            l_lnt26        LIKE lnt_file.lnt26 
 
    LET g_errno = " "
    SELECT lnt01,lnt26 INTO l_lnt01,l_lnt26
      FROM lnt_file 
     WHERE lnt01 = g_lum.lum071 
    CASE WHEN SQLCA.SQLCODE = 100         LET g_errno = 'alm-132'
         WHEN l_lnt26 = 'N'               LET g_errno = 'alm1041'
         OTHERWISE                        LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION

FUNCTION t613_chk_lum071()  
    DEFINE  l_lnt04        LIKE lnt_file.lnt04,
            l_lnt06        LIKE lnt_file.lnt06 
 
    LET g_errno = " "
    IF NOT cl_null(g_lum.lum051)  THEN
       SELECT lnt04 INTO l_lnt04 FROM lnt_file WHERE lnt01 = g_lum.lum071 AND lnt26 = 'Y'
       IF l_lnt04 <> g_lum.lum051 THEN
          LET g_errno = 'alm-174'
       END IF
    ELSE
       SELECT lnt04 INTO l_lnt04 FROM lnt_file WHERE lnt01 = g_lum.lum071 AND lnt26 = 'Y'
       LET g_lum.lum051 = l_lnt04 
       DISPLAY BY NAME g_lum.lum051
    END IF
    IF NOT cl_null(g_lum.lum061) THEN
       SELECT lnt06 INTO l_lnt06 FROM lnt_file WHERE lnt01 = g_lum.lum071 AND lnt26 = 'Y'
       IF l_lnt06 <> g_lum.lum061 THEN
          LET g_errno = 'alm-467'
       END IF 
    ELSE
       SELECT lnt06 INTO l_lnt06 FROM lnt_file WHERE lnt01 = g_lum.lum071 AND lnt26 = 'Y'
       LET g_lum.lum061 = l_lnt06 
       DISPLAY BY NAME g_lum.lum061
    END IF
    
END FUNCTION

FUNCTION t613_lum13()  
    DEFINE  l_gen01        LIKE gen_file.gen01,
            l_genacti      LIKE gen_file.genacti  
 
    LET g_errno = " "
    SELECT gen01,genacti INTO l_gen01,l_genacti
      FROM gen_file 
     WHERE gen01 = g_lum.lum13 
    CASE WHEN SQLCA.SQLCODE = 100           LET g_errno = 'mfg1312'
         WHEN l_genacti = 'N'               LET g_errno = '9028'
         OTHERWISE                          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE

END FUNCTION

FUNCTION t613_lum14()  
    DEFINE  l_gem01        LIKE gem_file.gem01,
            l_gemacti      LIKE gem_file.gemacti
 
    LET g_errno = " "
    SELECT gem01,gemacti INTO l_gem01,l_gemacti
      FROM gem_file 
     WHERE gem01 = g_lum.lum14
    CASE WHEN SQLCA.SQLCODE = 100           LET g_errno = 'mfg3097'
         WHEN l_gemacti = 'N'               LET g_errno = '9028'
         OTHERWISE                          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE

END FUNCTION
 
FUNCTION t613_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_lun.clear()
   DISPLAY ' ' TO FORMONLY.cnt
 
   CALL t613_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_lum.* TO NULL
      LET g_lum01_t = NULL
      LET g_wc = NULL
      RETURN
   END IF
 
   OPEN t613_cs                           
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_lum.* TO NULL
      LET g_lum01_t = NULL
      LET g_wc = NULL
   ELSE
      OPEN t613_count
      FETCH t613_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL t613_fetch('F')                  
   END IF
 
END FUNCTION
 
FUNCTION t613_fetch(p_flag)
   DEFINE  p_flag          LIKE type_file.chr1
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     t613_cs INTO g_lum.lum01
      WHEN 'P' FETCH PREVIOUS t613_cs INTO g_lum.lum01
      WHEN 'F' FETCH FIRST    t613_cs INTO g_lum.lum01
      WHEN 'L' FETCH LAST     t613_cs INTO g_lum.lum01
      WHEN '/'
            IF (NOT g_no_ask) THEN      
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
 
                   ON ACTION about         
                      CALL cl_about()      
  
                   ON ACTION HELP          
                      CALL cl_show_help()  
 
                   ON ACTION controlg      
                      CALL cl_cmdask()     
 
                END PROMPT
                IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
                END IF
            END IF
            FETCH ABSOLUTE g_jump t613_cs INTO g_lum.lum01
            LET g_no_ask = FALSE     
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lum.lum01,SQLCA.sqlcode,0)
      INITIALIZE g_lum.* TO NULL        
      LET g_lum01_t = NULL       
      RETURN
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
      CALL cl_navigator_setting( g_curs_index, g_row_count )
      DISPLAY g_curs_index TO FORMONLY.idx                    
   END IF
 
   SELECT * INTO g_lum.* FROM lum_file WHERE lum01 = g_lum.lum01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","lum_file","","",SQLCA.sqlcode,"","",1)  
      INITIALIZE g_lum.* TO NULL
      LET g_lum01_t = NULL
      RETURN
   END IF
   
   LET g_data_owner = g_lum.lumuser      
   LET g_data_group = g_lum.lumgrup      
   LET g_data_plant = g_lum.lumplant
 
   CALL t613_show()
 
END FUNCTION
 

FUNCTION t613_show()
    
   LET g_lum_t.* = g_lum.*                
   LET g_lum_o.* = g_lum.*                
   DISPLAY BY NAME g_lum.lum01,g_lum.lum03,g_lum.lum04,g_lum.lum02,g_lum.lumplant,g_lum.lumlegal,
                   g_lum.lum05,g_lum.lum06,g_lum.lum07,g_lum.lum08,g_lum.lum10,g_lum.lum11,g_lum.lum12,
                   g_lum.lum051,g_lum.lum061,g_lum.lum071,g_lum.lum081,g_lum.lum09,g_lum.lum13,g_lum.lum14,
                   g_lum.lum17,g_lum.lummksg,g_lum.lum16,g_lum.lumconf,g_lum.lumconu,g_lum.lumcond,
                   g_lum.lumcont,g_lum.lum15,g_lum.lumuser,g_lum.lumgrup,g_lum.lumoriu,g_lum.lummodu,
                   g_lum.lumdate,g_lum.lumorig,g_lum.lumacti,g_lum.lumcrat
                             
   CALL t613_desc()
   CALL t613_b_fill(g_wc2)          
   IF NOT cl_null(g_lum.lum07) THEN
      CALL t613_lnt30()
   ELSE
      CALL t613_lne08()
   END IF       
   CALL t613_pic() 
   CALL cl_show_fld_cont()                   
END FUNCTION
 
 
FUNCTION t613_r()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_lum.lum01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF

   IF g_lum.lum16 = '2' THEN
      CALL cl_err('','alm-945',1)
      RETURN
   END IF

   SELECT * INTO g_lum.* FROM lum_file
    WHERE lum01=g_lum.lum01
   IF g_lum.lumconf = 'Y' THEN
      CALL cl_err('','alm1061',0)
      RETURN
   END IF
 
   BEGIN WORK
 
   OPEN t613_cl USING g_lum.lum01
   IF STATUS THEN
      CALL cl_err("OPEN t613_cl:", STATUS, 1)
      CLOSE t613_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t613_cl INTO g_lum.*               
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lum.lum01,SQLCA.sqlcode,0)          
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL t613_show()
 
   IF cl_delh(0,0) THEN                   
      INITIALIZE g_doc.* TO NULL          
      LET g_doc.column1 = "lum01"         
      LET g_doc.value1 = g_lum.lum01      
      CALL cl_del_doc()                
      DELETE FROM lum_file WHERE lum01 = g_lum.lum01
      DELETE FROM lun_file WHERE lun01 = g_lum.lum01
      CLEAR FORM
      CALL g_lun.clear()
      OPEN t613_count
      FETCH t613_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t613_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t613_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE      
         CALL t613_fetch('/')
      END IF
   END IF
 
   CLOSE t613_cl
   COMMIT WORK
   CALL cl_flow_notify(g_lum.lum01,'D')
END FUNCTION
 

FUNCTION t613_ins_lun()

DEFINE l_sql        STRING
DEFINE l_lun02      LIKE lun_file.lun02

   LET l_sql = "SELECT '',lul01,lul02,lul05,'','',lul06,lul07,lul08,'','','',''",
               "  FROM lul_file,luk_file",
               " WHERE lul01 = '",g_lum.lum02,"'",
               "   AND luk01 = lul01 ",
               "   AND lukconf = 'Y' "
               
   DECLARE t613_lun_cr CURSOR FROM l_sql
 
   LET g_cnt = 1
   FOREACH t613_lun_cr INTO g_lun[g_cnt].*
      LET l_lun02 = g_cnt
      LET g_lun[g_cnt].lun02 = l_lun02
      IF SQLCA.SQLCODE THEN
         CALL cl_err('foreach:',SQLCA.SQLCODE,1)
         EXIT FOREACH
      END IF
      INSERT INTO lun_file(lun01,lun02,lun03,lun04,lun05,lun06,lun07,lun08,lunplant,lunlegal)
                    VALUES(g_lum.lum01,g_lun[g_cnt].lun02,g_lun[g_cnt].lun03,g_lun[g_cnt].lun04,g_lun[g_cnt].lun05,g_lun[g_cnt].lun06,
                           g_lun[g_cnt].lun07,g_lun[g_cnt].lun08,g_lum.lumplant,g_lum.lumlegal)
      LET g_cnt=g_cnt+1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH 
   CALL t613_b_fill("1=1")
   CALL t613_delall()
END FUNCTION

FUNCTION t613_delall()

   SELECT COUNT(*) INTO g_cnt FROM lun_file
    WHERE lun01 = g_lum.lum01 AND lunplant = g_lum.lumplant

   IF g_cnt = 0 THEN                   
      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
      ERROR g_msg CLIPPED
      DELETE FROM lum_file WHERE lum01 = g_lum.lum01 AND lumplant = g_lum.lumplant
   END IF

END FUNCTION

FUNCTION t613_b_fill(p_wc2)
DEFINE p_wc2           STRING
DEFINE l_sql           STRING
#FUN-C10024--add--str--
DEFINE    l_bookno1 LIKE aag_file.aag00,
          l_bookno2 LIKE aag_file.aag00,
          l_flag    LIKE type_file.chr1
#FUN-C10024--add--end--
 
   LET l_sql = "SELECT lun02,lun03,lun04,lun05,'','',lun06,lun07,lun08,'','','','',''",
               "  FROM lun_file",   
               " WHERE lun01 ='",g_lum.lum01,"'"
 
   IF NOT cl_null(p_wc2) THEN
      LET l_sql=l_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET l_sql=l_sql CLIPPED," ORDER BY lun02,lun03 "
   DISPLAY l_sql
 
   PREPARE t613_pb FROM l_sql
   DECLARE lun_cs CURSOR FOR t613_pb
 
   CALL g_lun.clear()
   LET g_rec_b = 0
   LET g_cnt = 1
 
   FOREACH lun_cs INTO g_lun[g_cnt].*   
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      CALL s_get_bookno(YEAR(g_lum.lum03)) RETURNING l_flag,l_bookno1,l_bookno2   #FUN-C10024 add
      SELECT oaj02,oaj04 INTO g_lun[g_cnt].oaj02,g_lun[g_cnt].oaj04
        FROM oaj_file WHERE oaj01 = g_lun[g_cnt].lun05 AND oajacti = 'Y'
      IF g_aza.aza63='Y' THEN
         SELECT oaj041 INTO g_lun[g_cnt].oaj041 
           FROM oaj_file WHERE oaj01 = g_lun[g_cnt].lun05 AND oajacti = 'Y'
         SELECT aag02 INTO g_lun[g_cnt].aag02_1  
           FROM aag_file WHERE aag01 = g_lun[g_cnt].oaj041 AND aag00=l_bookno2 ##FUN-C10024 add
      END IF
      SELECT oaj05 INTO g_lun[g_cnt].oaj05
        FROM oaj_file WHERE oaj01 = g_lun[g_cnt].lun05
      SELECT aag02 INTO g_lun[g_cnt].aag02
        FROM aag_file WHERE aag01 = g_lun[g_cnt].oaj04 AND aag00=l_bookno1 ##FUN-C10024 add  
      LET g_lun[g_cnt].amt_1 = g_lun[g_cnt].lun06 - g_lun[g_cnt].lun07 - g_lun[g_cnt].lun08

      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_lun.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
   CALL t613_bp_refresh()
 
END FUNCTION
 
FUNCTION t613_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("lum01",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION t613_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("lum01",FALSE)
    END IF

END FUNCTION

FUNCTION t613_confirm()
  DEFINE l_lumcond         LIKE lum_file.lumcond 
  DEFINE l_lumconu         LIKE lum_file.lumconu
  DEFINE l_lummodu         LIKE lum_file.lummodu
  DEFINE l_lumdate         LIKE lum_file.lumdate
  DEFINE l_lumcont         LIKE lum_file.lumcont
  DEFINE l_lum16           LIKE lum_file.lum16


   IF cl_null(g_lum.lum01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
#CHI-C30107 ------------- add ----------- begin
   IF g_lum.lumconf = 'Y' THEN
      CALL cl_err('','alm1061',0)
      RETURN
   END IF
   IF g_lum.lumacti = 'N' THEN
      CALL cl_err('','alm1067',0)
      RETURN
   END IF

   IF NOT cl_confirm("alm1070") THEN
       RETURN
   END IF
#CHI-C30107 ------------- add ----------- end
   SELECT lum_file.* INTO g_lum.* FROM lum_file
    WHERE lum01 = g_lum.lum01
   IF g_lum.lumconf = 'Y' THEN
      CALL cl_err('','alm1061',0)
      RETURN
   END IF
   IF g_lum.lumacti = 'N' THEN
      CALL cl_err('','alm1067',0)
      RETURN
   END IF
 

   LET l_lumcond = g_lum.lumcond
   LET l_lumconu = g_lum.lumconu
   LET l_lummodu = g_lum.lummodu
   LET l_lumdate = g_lum.lumdate   
   LET l_lumcont = g_lum.lumcont  
   LET l_lum16 = g_lum.lum16

   IF g_lum.lumacti ='N' THEN
      CALL cl_err(g_lum.lum01,'alm1068',1)
      RETURN
   END IF
   IF g_lum.lumconf = 'Y' THEN
      CALL cl_err(g_lum.lum01,'alm1069',1)
      RETURN
   END IF
   
   BEGIN WORK
 
   OPEN t613_cl USING g_lum.lum01
   IF STATUS THEN
      CALL cl_err("OPEN t613_cl:",STATUS,0)
      CLOSE t613_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t613_cl INTO g_lum.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lum.lum01,SQLCA.sqlcode,0)
      CLOSE t613_cl
      ROLLBACK WORK
      RETURN
   END IF
    
#CHI-C30107 ----------- mark ------------- begin
#  IF NOT cl_confirm("alm1070") THEN
#      RETURN
#  ELSE
#CHI-C30107 ----------- mark ------------- end
      LET g_lum.lumconf = 'Y'
      LET g_lum.lum16 = '1'
      LET g_lum.lumcond = g_today 
      LET g_lum.lumconu = g_user 
      LET g_lum.lummodu = g_user
      LET g_lum.lumdate = g_today 
      LET g_lum.lumcont = TIME 
      UPDATE lum_file
         SET lumconf = 'Y',
             lum16 = '1',
             lumcond = g_lum.lumcond,
             lumconu = g_lum.lumconu,
             lummodu = g_lum.lummodu,
             lumdate = g_lum.lumdate,
             lumcont = g_lum.lumcont
       WHERE lum01 = g_lum.lum01
       IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err('upd lum:',SQLCA.SQLCODE,0)
         LET g_lum.lumconf = 'N'
         LET g_lum.lum16 = '1'
         LET g_lum.lumcond = l_lumcond
         LET g_lum.lumconu = l_lumconu
         LET g_lum.lummodu = l_lummodu
         LET g_lum.lumdate = l_lumdate
         LET g_lum.lumdate = l_lumcont 
         DISPLAY BY NAME g_lum.lumconf,g_lum.lum16,g_lum.lumcond,g_lum.lumconu,g_lum.lummodu,g_lum.lumdate,g_lum.lumcont
         RETURN
       ELSE
         CALL t613_desc()
         DISPLAY BY NAME g_lum.lumconf,g_lum.lum16,g_lum.lumcond,g_lum.lumconu,g_lum.lummodu,g_lum.lumdate,g_lum.lumcont
       END IF
#   END IF #CHI-C30107 mark
    
   CLOSE t613_cl
   COMMIT WORK  
   CALL t613_pic() 
END FUNCTION

FUNCTION t613_pic()
   CASE g_lum.lumconf
      WHEN 'Y'  LET g_confirm = 'Y'
      WHEN 'N'  LET g_confirm = 'N'
      OTHERWISE LET g_confirm = ''
   END CASE

   CALL cl_set_field_pic(g_confirm,"","","","",g_lum.lumacti)
END FUNCTION

FUNCTION t613_unconfirm()
   IF cl_null(g_lum.lum01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT lum_file.* INTO g_lum.* FROM lum_file
    WHERE lum01 = g_lum.lum01
    
  
   IF g_lum.lumacti ='N' THEN
      CALL cl_err(g_lum.lum01,'alm1071',1)
      RETURN
   END IF
   IF g_lum.lumconf = 'N' THEN
      CALL cl_err(g_lum.lum01,'alm1072',1)
      RETURN
   END IF
   IF g_lum.lum16 = '2' THEN
      CALL cl_err('','alm-943',1)
      RETURN
   END IF
   
   BEGIN WORK
 
   OPEN t613_cl USING g_lum.lum01
   IF STATUS THEN
      CALL cl_err("OPEN t613_cl:",STATUS,0)
      CLOSE t613_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t613_cl INTO g_lum.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lum.lum01,SQLCA.sqlcode,0)
      CLOSE t613_cl
      ROLLBACK WORK
      RETURN
   END IF
   
 
   IF NOT cl_confirm('alm1073') THEN
      RETURN
   ELSE
      LET g_lum.lumcont = TIME        #CHI-D20015
      UPDATE lum_file
         SET lumconf = 'N',
             lum16 = '0',
             #CHI-D20015---MOD--STR
            #lumcond = '',
            #lumconu = '',
             lumcond = g_today,
             lumconu = g_user,
             #CHI-D20015---mod--end
             lummodu = g_user,
             lumdate = g_today,
            #lumcont = '00:00:00'    #CHI-D20015
             lumcont =  g_lum.lumcont          #CHI-D20015
       WHERE lum01 = g_lum.lum01
       IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err('upd lum:',SQLCA.SQLCODE,0)
         LET g_lum.lumconf = 'Y' 
         LET g_lum.lum16 = '1'
         LET g_lum.lumcond = g_lum_t.lumcond 
         LET g_lum.lumconu = g_lum_t.lumconu
         LET g_lum.lummodu = g_lum_t.lummodu
         LET g_lum.lumdate = g_lum_t.lumdate
         LET g_lum.lumcont = g_lum_t.lumcont
         DISPLAY BY NAME g_lum.lumconf,g_lum.lum16,g_lum.lumcond,g_lum.lumconu,g_lum.lummodu,g_lum.lumdate,g_lum.lumcont
       ELSE
         LET g_lum.lumconf = 'N'
        #LET g_lum.lumcond = ''   #CHI-D20015
        #LET g_lum.lumconu = ''   #CHI-D20015
         LET g_lum.lumcond = g_today   #CHI-D20015
         LET g_lum.lumconu = g_user    #CHI-D20015
         LET g_lum.lummodu = g_user
         LET g_lum.lumdate = g_today 
        #LET g_lum.lumcont = '00:00:00' #CHI-D20015
         LET g_lum.lumcont = TIME       #CHI-D20015 
         CALL t613_desc()
         DISPLAY BY NAME g_lum.lumconf,g_lum.lum16,g_lum.lumcond,g_lum.lumconu,g_lum.lummodu,g_lum.lumdate,g_lum.lumcont
       END IF
    END IF 

   CLOSE t613_cl
   COMMIT WORK   
END FUNCTION


FUNCTION t613_post()
DEFINE l_sql        STRING,
       l_luk01      LIKE luk_file.luk01,
       l_lul01      LIKE lul_file.lul01,
       l_lul02      LIKE lul_file.lul02,
       l_lul03      LIKE lul_file.lul03,
       l_lul04      LIKE lul_file.lul04,
       l_lul07      LIKE lul_file.lul07,
       l_lul08      LIKE lul_file.lul08,
       l_lul09      LIKE lul_file.lul09,
       l_lul10      LIKE lul_file.lul10,
       l_amt_1      LIKE lul_file.lul08,
       l_amt_2      LIKE lul_file.lul08,
       l_max02      LIKE lun_file.lun02,
       l_lun02      LIKE lun_file.lun02,
       l_lun03      LIKE lun_file.lun03,
       l_lun04      LIKE lun_file.lun04,
       l_lun05      LIKE lun_file.lun05,
       l_lun06      LIKE lun_file.lun06,
       l_lun07      LIKE lun_file.lun07,
       l_lun08      LIKE lun_file.lun08,
       l_lun06_s    LIKE lun_file.lun06,
       l_lun07_s    LIKE lun_file.lun07,
       l_lun08_s    LIKE lun_file.lun08

   IF g_lum.lum01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   SELECT * INTO g_lum.*
     FROM lum_file
    WHERE lum01 = g_lum.lum01

   #資料沒確認不可以变更发出
   IF g_lum.lumconf <> 'Y' THEN
      CALL cl_err ('','alm-936',0)
      RETURN
   END IF 

   #变更发出过了不可以再次变更发出
   IF g_lum.lum16 = '2' THEN
      CALL cl_err ('','alm-937',0)
      RETURN
   END IF  

   #原待抵單金額發生變化不可變更發出#
   LET g_cnt = 1
   LET l_sql = " SELECT lul07,lul08 ",
               "   FROM lul_file ",
               "  WHERE lul01 = '",g_lun[g_cnt].lun03,"'",
               "    AND lul02 = '",g_lun[g_cnt].lun04,"'"
               
   DECLARE t613_chk_cr CURSOR FROM l_sql
   FOREACH t613_chk_cr INTO l_lul07,l_lul08
     IF SQLCA.SQLCODE THEN
        CALL cl_err('foreach:',SQLCA.SQLCODE,1)
        EXIT FOREACH
     END IF
     IF l_lul07 <> g_lun[g_cnt].lun07 OR l_lul08 <> g_lun[g_cnt].lun08 THEN
        CALL cl_err('','art1021',0)
        RETURN
     ELSE
        LET g_cnt=g_cnt+1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
      END IF
   END FOREACH
   
   LET g_success = 'Y'
   
   BEGIN WORK
   
   OPEN t613_cl USING g_lum.lum01
   IF STATUS THEN
      CALL cl_err("OPEN t613_cl:", STATUS, 1)
      CLOSE t613_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t613_cl INTO g_lum.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lum.lum01,SQLCA.sqlcode,0)
      CLOSE t613_cl
      ROLLBACK WORK
      RETURN
   END IF

   #修改状态码
   UPDATE lum_file
      SET lum16 = '2'
    WHERE lum01 = g_lum.lum01

   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
      CALL cl_err(g_lum.lum01,SQLCA.sqlcode,0)
      ROLLBACK WORK
      RETURN
   END IF

   #更新原待抵單的已冲金額#
   UPDATE luk_file
      SET luk11 = luk10 - luk12
    WHERE luk01 = g_lum.lum02
    
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
      CALL cl_err('update luk_file',SQLCA.sqlcode,0)
      ROLLBACK WORK
      RETURN
   END IF


   LET g_cnt = 1
   LET l_sql = " SELECT lul01,lul02 ",
               "   FROM lul_file ",
               "  WHERE lul01 = '",g_lun[g_cnt].lun03,"'"
   DECLARE t613_sel_cr CURSOR FROM l_sql
   FOREACH t613_sel_cr INTO l_lul01,l_lul02
     IF SQLCA.SQLCODE THEN
        CALL cl_err('foreach:',SQLCA.SQLCODE,1)
        EXIT FOREACH
     END IF
     UPDATE lul_file
        SET lul07 = lul06 - lul08
      WHERE lul01 = l_lul01 AND lul02 = l_lul02
     IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
        CALL cl_err('update lul_file',SQLCA.sqlcode,0)
        ROLLBACK WORK
        RETURN
     END IF
     LET g_cnt=g_cnt+1
     IF g_cnt > g_max_rec THEN
        CALL cl_err( '', 9035, 0 )
        EXIT FOREACH
     END IF
   END FOREACH

   #新增一筆待抵單資料#
   #FUN-C90050 mark begin---
   #SELECT rye03 INTO l_luk01 FROM rye_file
   # WHERE rye01 = 'art'
   #   AND rye02 = 'B2'
   #FUN-C90050 mark end-----

   CALL s_get_defslip('art','B2',g_plant,'N') RETURNING l_luk01   #FUN-C90050 add

   IF cl_null(l_luk01) THEN
      CALL s_errmsg('luk01',l_luk01,'sel_rye','aar-001',1)
      LET g_success = 'N'
      ROLLBACK WORK
      RETURN
   END IF
   CALL s_auto_assign_no("art",l_luk01,g_today,'B2',"luk_file","luk01","","","")
      RETURNING li_result,l_luk01
   IF (NOT li_result) THEN
      LET g_success = 'N'
      ROLLBACK WORK
      RETURN
   END IF
   UPDATE lum_file SET lum09 = l_luk01 WHERE lum01 = g_lum.lum01
   LET g_lum.lum09 = l_luk01
   DISPLAY BY NAME g_lum.lum09

   SELECT SUM(lun06),SUM(lun07),SUM(lun08) INTO l_lun06_s,l_lun07_s,l_lun08_s FROM lun_file WHERE lun01 = g_lum.lum01
   LET l_amt_1 = l_lun06_s - l_lun07_s - l_lun08_s 
   INSERT INTO luk_file(luk01,luk02,luk03,luk04,luk05,luk06,luk07,luk08,luk09,luk10,luk11,
                        luk12,luk13,luk14,luk15,lukconf,lukcond,lukcont,lukconu,lukmksg,
                        lukacti,lukcrat,lukdate,lukgrup,lukmodu,lukuser,lukoriu,lukorig,lukplant,luklegal)
                 VALUES(l_luk01,g_today,g_today,'3',g_lum.lum01,g_lum.lum051,g_lum.lum061,g_lum.lum071,g_lum.lum081,
                        l_amt_1,'0','0',g_user,g_grup,'','Y',g_today,g_time,g_user,'N','Y',g_today,g_today,
                        g_grup,'',g_user,g_user,g_grup,g_lum.lumplant,g_lum.lumlegal)

   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
       CALL s_errmsg('ins luk',l_luk01,'',SQLCA.sqlcode,1)
       LET g_success = 'N'
       ROLLBACK WORK
       RETURN
   END IF

   LET g_cnt = 1
   LET l_max02 = 1
   LET l_sql = " SELECT lul02,lul03,lul04,lul09,lul10",
               "   FROM lul_file ",
               "  WHERE lul01 = '",g_lum.lum02,"'"
               
   DECLARE t613_sel_lul_cr CURSOR FROM l_sql
   FOREACH t613_sel_lul_cr INTO l_lul02,l_lul03,l_lul04,l_lul09,l_lul10
     IF SQLCA.SQLCODE THEN
        CALL cl_err('foreach:',SQLCA.SQLCODE,1)
        EXIT FOREACH
     END IF
     SELECT lun05,lun06,lun07,lun08 INTO l_lun05,l_lun06,l_lun07,l_lun08 FROM lun_file WHERE lun01 = g_lum.lum01 AND lun02 = l_lul02
     LET l_amt_2 = l_lun06 - l_lun07 - l_lun08
     IF l_amt_2 <> '0' THEN
        INSERT INTO lul_file(lul01,lul02,lul03,lul04,lul05,lul06,lul07,lul08,lul09,lul10,lulplant,lullegal)
                      VALUES(g_lum.lum09,l_max02,l_lul03,l_lul04,l_lun05,
                             l_amt_2,'0','0',l_lul09,l_lul10,g_lum.lumplant,g_lum.lumlegal)
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
           CALL s_errmsg('ins lul',g_lum.lum09,'',SQLCA.sqlcode,1)
           LET g_success = 'N'
           ROLLBACK WORK
           RETURN
        END IF
     END IF
     LET l_max02 = l_max02 + 1
     LET g_cnt=g_cnt+1
     IF g_cnt > g_max_rec THEN
        CALL cl_err( '', 9035, 0 )
        EXIT FOREACH
     END IF
   END FOREACH
   
   IF g_success = 'Y' THEN
      CALL cl_err('','alm-940',0)
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF

   SELECT * INTO g_lum.* FROM lum_file WHERE lum01 = g_lum.lum01
   DISPLAY BY NAME g_lum.lum16
   CLOSE t613_cl
END FUNCTION
#FUN-BB0117

#FUN-C20019--add-str
FUNCTION t613_axrp604()
   DEFINE l_cnt LIKE type_file.num5
   DEFINE l_azp01 LIKE azp_file.azp01
   DEFINE li_sql STRING
   DEFINE li_str STRING 
   DEFINE l_wc STRING 
   DEFINE l_wc1 STRING 
   IF s_shut(0) THEN
       RETURN
    END IF
    
   IF cl_null(g_lum.lum01)  THEN 
      RETURN 
   END IF
   
   IF NOT cl_null(g_lum.lum17) OR g_lum.lum17 IS NOT NULL THEN
      CALL cl_err('','alm1616',0)   #TQC-C40007
      RETURN
   END IF 
    
   LET l_cnt = 0 
   SELECT azp01 INTO l_azp01 FROM azp_file,azw_file 
    WHERE azw01 = azp01 AND azw02 = g_legal AND azw01 = g_lum.lumplant
    LET l_cnt = 0 
    LET li_sql = " SELECT count(*)  ",
               "   FROM ",cl_get_target_table(l_azp01,'lum_file'),
               "  WHERE lumconf='Y'",
          #    "    AND lum16='2'",     #TQC-C20464  MARK
               "    AND lumplant = ? ",
               "    AND lum01 = ? "   
   CALL cl_replace_sqldb(li_sql) RETURNING li_sql
   CALL cl_parse_qry_sql(li_sql,l_azp01) RETURNING li_sql
   PREPARE p604_lum_pre FROM li_sql
   EXECUTE p604_lum_pre USING l_azp01,g_lum.lum01 INTO l_cnt
   #TQC-C20464--ADD--STR
    IF g_lum.lum16 <> '2' THEN
       CALL s_errmsg('','',g_lum.lum16,'axr-105',1)
       LET g_success = 'N'
       RETURN
    END IF
   #TQC-C20464--ADD--END
   IF l_cnt = 0 THEN 
      RETURN 
   END IF 
   
    IF NOT (cl_confirm("axr119")) THEN 
      RETURN 
   END IF 
#---TQC-C20204--mod--str
   
  # LET l_wc = " azp01='",l_azp01,"'"
  # LET l_wc1 ="lum01='",g_lum.lum01,"',lum05='",g_lum.lum05,"',lum03='",g_lum.lum03,"'" 
# LET li_str = "axrp604 ",
#               ' "',l_wc,'" ',
#               ' "',l_wc1,'" ',
#               ' " "',
#               ' "Y" '
   
   LET l_wc  = 'azp01 = "',l_azp01,'"'
  LET l_wc1 = 'lum01 = "',g_lum.lum01,'" AND lum05 = "',g_lum.lum05,'" AND lum03 = "',g_lum.lum03,'"'
   LET li_str = "axrp604 '",l_wc,"' '",l_wc1,"' '' 'Y'"
#--TQC-C20204--mod--end
   #CALL cl_wait()   #TQC-C20430 mark--
   CALL cl_cmdrun_wait(li_str CLIPPED) 
   SELECT lum17 INTO g_lum.lum17 FROM lum_file
     WHERE lum01=g_lum.lum01
     DISPLAY BY NAME g_lum.lum17 
END FUNCTION 
#FUN-C20019--add-end

#FUN-B30029--add--str
FUNCTION t613_axrp608()
   DEFINE l_cnt LIKE type_file.num5
   DEFINE l_azp01 LIKE azp_file.azp01
   DEFINE li_sql STRING
   DEFINE li_str STRING
   DEFINE l_wc STRING
   DEFINE l_wc1 STRING

   IF s_shut(0) THEN
       RETURN
    END IF

   IF cl_null(g_lum.lum01)  THEN
      RETURN
   END IF

   IF cl_null(g_lum.lum17) OR g_lum.lum17 IS  NULL THEN
      CALL cl_err('','axr-393',1) 
      RETURN
    END IF

    LET l_cnt = 0
   SELECT azp01 INTO l_azp01 FROM azp_file,azw_file
    WHERE azw01 = azp01 AND azw02 = g_legal AND azw01 = g_lum.lumplant
   
   IF NOT (cl_confirm("axr-391")) THEN
      RETURN
   END IF

   LET l_wc  = 'azp01 = "',l_azp01,'"'
   LET l_wc1 = 'lum01 = "',g_lum.lum01,'"'
   LET li_str = "axrp608 '",l_wc,"' '",l_wc1,"'  'Y'"
   CALL cl_cmdrun_wait(li_str CLIPPED)
   SELECT lum17 INTO g_lum.lum17 FROM lum_file
     WHERE lum01=g_lum.lum01
     DISPLAY BY NAME g_lum.lum17
END FUNCTION
#FUN-B30029--add--end

#FUN-CB0076-------add------str
FUNCTION t613_out()
DEFINE l_sql     LIKE type_file.chr1000, 
       l_rtz13   LIKE rtz_file.rtz13,
       l_occ02   LIKE occ_file.occ02,
       l_occ02_1 LIKE occ_file.occ02,
       l_gen02   LIKE gen_file.gen02,
       l_oaj02   LIKE oaj_file.oaj02,
       l_oaj05   LIKE oaj_file.oaj05,
       l_amt     LIKE lum_file.lum10,
       l_amt_1   LIKE lul_file.lul06,
       sr        RECORD
    lumplant  LIKE lum_file.lumplant,
    lum01     LIKE lum_file.lum01,
    lum05     LIKE lum_file.lum05,
    lum02     LIKE lum_file.lum02,
    lum07     LIKE lum_file.lum07,
    lum08     LIKE lum_file.lum08,
    lum06     LIKE lum_file.lum06,
    lum03     LIKE lum_file.lum03,
    lum051    LIKE lum_file.lum051,
    lum09     LIKE lum_file.lum09,
    lum071    LIKE lum_file.lum071,
    lum081    LIKE lum_file.lum081,
    lum061    LIKE lum_file.lum061,
    lum10     LIKE lum_file.lum10,
    lum11     LIKE lum_file.lum11,
    lum12     LIKE lum_file.lum12,
    lumcond   LIKE lum_file.lumcond,
    lumcont   LIKE lum_file.lumcont,
    lumconu   LIKE lum_file.lumconu,
    lun02     LIKE lun_file.lun02,
    lun03     LIKE lun_file.lun03,
    lun04     LIKE lun_file.lun04,
    lun05     LIKE lun_file.lun05,
    lun06     LIKE lun_file.lun06,
    lun07     LIKE lun_file.lun07,
    lun08     LIKE lun_file.lun08
                 END RECORD
                 
     CALL cl_del_data(l_table) 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     LET g_wc = g_wc CLIPPED,cl_get_extra_cond('lumser', 'lumgrup') 
     IF cl_null(g_wc) THEN LET g_wc = " lum01 = '",g_lum.lum01,"'" END IF
     LET l_sql = "SELECT lumplant,lum01,lum05,lum02,lum07,lum08,lum06,lum03,lum051,lum09,",
                 "       lum071,lum081,lum061,lum10,lum11,lum12,lumcond,lumcont,lumconu,",
                 "       lun02,lun03,lun04,lun05,lun06,lun07,lun08",
                 "  FROM lum_file,lun_file",
                 " WHERE lum01 = lun01",
                 "   AND ",g_wc CLIPPED,
                 "   AND ",g_wc2 CLIPPED
     PREPARE t613_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        CALL cl_gre_drop_temptable(l_table)   
        EXIT PROGRAM
     END IF
     DECLARE t613_cs1 CURSOR FOR t613_prepare1

     DISPLAY l_table
     FOREACH t613_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF

       LET l_rtz13 = ' '
       SELECT rtz13 INTO l_rtz13 FROM rtz_file WHERE rtz01 = sr.lumplant
       LET l_occ02 = ' '
       SELECT occ02 INTO l_occ02 FROM occ_file WHERE occ01 = sr.lum05
       LET l_occ02_1 = ' '
       SELECT occ02 INTO l_occ02_1 FROM occ_file WHERE occ01 = sr.lum051
       LET l_gen02 = ' '
       SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = sr.lumconu
       LET l_oaj02 = ' '
       SELECT oaj02 INTO l_oaj02 FROM oaj_file WHERE oaj01 = sr.lun05
       LET l_oaj05 = ' '
       SELECT oaj05 INTO l_oaj05 FROM oaj_file WHERE oaj01 = sr.lun05
       LET l_amt = 0
       LET l_amt = sr.lum10-sr.lum11-sr.lum12
       LET l_amt_1 = 0
       LET l_amt_1 = sr.lun06-sr.lun07-sr.lun08
       EXECUTE insert_prep USING sr.*,l_rtz13,l_occ02,l_occ02_1,l_gen02,l_oaj02,l_oaj05,l_amt,l_amt_1
     END FOREACH
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     CALL cl_wcchp(g_wc,'lum01,lum03,lum04,lum02,lumplant,lumlegal,lum05,lum06,lum07,lum08,lum10,lum11,lum12,lum051,lum061,lum071,lum081,lum09,lum13,lum14,lum17,lummksg,lum16,lumconf,lumconu,lumcond,lumcont,lum15,lumuser,lumgrup,lumoriu,lummodu,lumdate,lumorig,lumacti,lumcrat')
          RETURNING g_wc1
     CALL cl_wcchp(g_wc2,'lun02,lun03,lun04,lun05,lun06,lun07,lun08')
          RETURNING g_wc3
     IF g_wc = " 1=1" THEN
        LET g_wc1=''
     END IF
     IF g_wc2 = " 1=1" THEN
        LET g_wc3=''
     END IF
     IF g_wc <> " 1=1" AND g_wc2 <> " 1=1" THEN
        LET g_wc4 = g_wc1," AND ",g_wc3
     ELSE
        IF g_wc = " 1=1" AND g_wc2 = " 1=1" THEN
           LET g_wc4 = "1=1"
        ELSE
           LET g_wc4 = g_wc1,g_wc3
        END IF
     END IF
     CALL t613_grdata()
END FUNCTION

FUNCTION t613_grdata()
   DEFINE l_sql    STRING
   DEFINE handler  om.SaxDocumentHandler
   DEFINE sr1      sr1_t
   DEFINE l_cnt    LIKE type_file.num10

   LET l_cnt = cl_gre_rowcnt(l_table)
   IF l_cnt <= 0 THEN 
      RETURN 
   END IF
   
   WHILE TRUE
       CALL cl_gre_init_pageheader()            
       LET handler = cl_gre_outnam("almt613")
       IF handler IS NOT NULL THEN
           START REPORT t613_rep TO XML HANDLER handler
           LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                       " ORDER BY lum01,lun02"
           DECLARE t613_datacur1 CURSOR FROM l_sql
           FOREACH t613_datacur1 INTO sr1.*
               OUTPUT TO REPORT t613_rep(sr1.*)
           END FOREACH
           FINISH REPORT t613_rep
       END IF
       IF INT_FLAG = TRUE THEN
           LET INT_FLAG = FALSE
           EXIT WHILE
       END IF
   END WHILE
   CALL cl_gre_close_report()
END FUNCTION

REPORT t613_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno      LIKE type_file.num5
    DEFINE l_lun06_sum   LIKE lun_file.lun06
    DEFINE l_lun07_sum   LIKE lun_file.lun07
    DEFINE l_lun08_sum   LIKE lun_file.lun08
    DEFINE l_amt_1_sum   LIKE lun_file.lun06
    DEFINE l_lub09       STRING    
    DEFINE l_plant       STRING
   
    ORDER EXTERNAL BY sr1.lum01
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name 
            PRINTX g_wc1
            PRINTX g_wc3
            PRINTX g_wc4
              
        BEFORE GROUP OF sr1.lum01
            LET l_lineno = 0
        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            LET l_lub09 = cl_gr_getmsg('gre-316',g_lang,sr1.oaj05)
            PRINTX l_lub09
            PRINTX sr1.*
            LET l_plant = sr1.lumplant,' ',sr1.rtz13
            PRINTX l_plant

        AFTER GROUP OF sr1.lum01
            LET l_lun06_sum = GROUP SUM(sr1.lun06)
            LET l_lun07_sum = GROUP SUM(sr1.lun07)
            LET l_lun08_sum = GROUP SUM(sr1.lun08)
            LET l_amt_1_sum = GROUP SUM(sr1.amt_1)
            PRINTX l_lun06_sum
            PRINTX l_lun07_sum
            PRINTX l_lun08_sum
            PRINTX l_amt_1_sum
            
        ON LAST ROW

END REPORT
#FUN-CB0076-------add------end

