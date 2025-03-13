# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
#Pattern name..:"artt211.4gl"
#Descriptions..:盤點清單
#Date & Author..:08/09/25 By Sunyanchun
# Modify.........: No:FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-9B0068 09/11/10 By lilingyu 臨時表字段改成LIKE的形式
# Modify.........: No:FUN-960130 09/12/09 By Cockroach PASS NO.
# Modify.........: No:TQC-A10128 10/01/18 By Cockroach 添加g_data_plant管控
# Modify.........: No:TQC-A30041 10/03/16 By Cockroach add oriu/orig
# Modify.........: No:FUN-A70130 10/08/06 By shaoyong  ART單據性質調整,q_smy改为q_oay
# Modify.........: No:FUN-AA0059 10/10/26 By chenying 料號開窗控管 
# Modify.........: No:FUN-AA0046 10/10/26 By huangtao 修改單別開窗只返回3碼的bug
# Modify.........: No:FUN-AA0092 10/10/29 By houlia   倉庫權限使用控管修改
# Modify.........: No:FUN-AB0025 10/11/25 By chenying 修改料件編號
# Modify.........: No:FUN-AB0078 10/11/17 By houlia 倉庫營運中心權限控管審核段控管
# Modify.........: No:TQC-AB0288 10/11/30 By huangtao   
# Modify.........: No:TQC-B20084 11/02/18 By baogc 修改單身限制條件，允許輸入不同貨架相同料件的資料
# Modify.........: No:FUN-B40062 11/04/26 By shiwuying 料号控管不可输入商户料号和联营料号
# Modify.........: No.FUN-B50064 11/06/02 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-B60170 11/06/17 By yangxf BUG修改,錄入一筆資料後，立即打印，報錯【9057 無打印條件，請重新做QBE查詢後再開始打印報表！】
# Modify.........: No.TQC-B80036 11/08/03 By lilingyu 盘点计划artt210限定了产品范围,但是在盘点清单artt211里面可以录入限定范围以外的产品
# Modify.........: No.FUN-BB0085 11/12/27 By xianghui 增加數量欄位小數取位

# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No.CHI-C30002 12/05/24 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-C80046 12/08/17 By bart 複製後停在新資料畫面
# Modify.........: No:TQC-C90064 12/09/14 By dongsz artt210限定產品為多個時，artt211應正確檢查產品編號
# Modify.........: No:TQC-C90123 12/09/29 By baogc 盤點單身產品開窗邏輯調整
# Modify.........: No.CHI-C80041 12/11/28 By bart 取消單頭資料控制
# Modify.........: No:FUN-D20039 13/01/20 By huangtao 將原本的「作廢」功能鍵拆為二個「作廢」/「取消作廢」
# Modify.........: No.CHI-D20015 13/03/26 By xumm 取消確認賦值確認異動時間和人員
# Modify.........: No:FUN-D30033 13/04/12 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE  g_ruu    RECORD LIKE ruu_file.*,
        g_ruu_t  RECORD LIKE ruu_file.*,
        g_ruu_o  RECORD LIKE ruu_file.*,
        g_ruu01_t       LIKE ruu_file.ruu01,
        g_ruv   DYNAMIC ARRAY OF RECORD 
                ruv02   LIKE ruv_file.ruv02,
                ruv03   LIKE ruv_file.ruv03,
                ruv04   LIKE ruv_file.ruv04,
                ruv04_desc   LIKE ima_file.ima02,
                ruv05   LIKE ruv_file.ruv05,
                ruv05_desc   LIKE ima_file.ima25,
                ruv06   LIKE ruv_file.ruv06,
                ruv07   LIKE ruv_file.ruv07,
                ruv08   LIKE ruv_file.ruv08,
                ruv09   LIKE ruv_file.ruv09,
                ruv10   LIKE ruv_file.ruv10
                        END RECORD,
        g_ruv_t RECORD
                ruv02   LIKE ruv_file.ruv02,
                ruv03   LIKE ruv_file.ruv03,
                ruv04   LIKE ruv_file.ruv04,
                ruv04_desc   LIKE ima_file.ima02,
                ruv05   LIKE ruv_file.ruv05,
                ruv05_desc   LIKE ima_file.ima25,
                ruv06   LIKE ruv_file.ruv06,
                ruv07   LIKE ruv_file.ruv07,
                ruv08   LIKE ruv_file.ruv08,
                ruv09   LIKE ruv_file.ruv09,
                ruv10   LIKE ruv_file.ruv10
                        END RECORD,
        g_ruv_o RECORD
                ruv02   LIKE ruv_file.ruv02,
                ruv03   LIKE ruv_file.ruv03,
                ruv04   LIKE ruv_file.ruv04,
                ruv04_desc   LIKE ima_file.ima02,
                ruv05   LIKE ruv_file.ruv05,
                ruv05_desc   LIKE ima_file.ima25,
                ruv06   LIKE ruv_file.ruv06,
                ruv07   LIKE ruv_file.ruv07,
                ruv08   LIKE ruv_file.ruv08,
                ruv09   LIKE ruv_file.ruv09,
                ruv10   LIKE ruv_file.ruv10
                        END RECORD,
        g_sql   STRING,
        g_wc    STRING,
        g_wc2   STRING,
        g_rec_b LIKE type_file.num5,
        l_ac    LIKE type_file.num5
DEFINE  p_row,p_col     LIKE type_file.num5
DEFINE  g_forupd_sql    STRING
DEFINE  g_before_input_done     LIKE type_file.num5
DEFINE  g_chr           LIKE type_file.chr1
DEFINE  g_cnt           LIKE type_file.num10
DEFINE  g_msg           LIKE ze_file.ze03
DEFINE  g_row_count     LIKE type_file.num10
DEFINE  g_curs_index    LIKE type_file.num10
DEFINE  g_jump          LIKE type_file.num10
DEFINE  mi_no_ask       LIKE type_file.num5
DEFINE  l_table         STRING
DEFINE  g_str           STRING
DEFINE  g_result        DYNAMIC ARRAY OF LIKE ima_file.ima01
DEFINE  g_ruv05_t       LIKE ruv_file.ruv05   #FUN-BB0085
MAIN
        OPTIONS                            
        INPUT NO WRAP
    DEFER INTERRUPT                      
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ART")) THEN
      EXIT PROGRAM
   END IF
 
    CALL  cl_used(g_prog,g_time,1)      
         RETURNING g_time   
          
    LET g_forupd_sql="SELECT * FROM ruu_file WHERE ruu01=? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t211_cl    CURSOR FROM g_forupd_sql
    
    LET p_row = 4 LET p_col = 10
    OPEN WINDOW t211_w AT p_row,p_col WITH FORM "art/42f/artt211"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
 
    CALL t211_menu()
    CLOSE WINDOW t211_w                   
    CALL  cl_used(g_prog,g_time,2)        
         RETURNING g_time    
END MAIN
 
FUNCTION t211_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = ''
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ruv TO s_ruv.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
        CALL cl_navigator_setting(g_curs_index,g_row_count)
        
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   
      
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION first
         CALL t211_fetch('F')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
      ON ACTION previous
         IF g_curs_index>1 THEN
          CALL t211_fetch('P')
          CALL cl_navigator_setting(g_curs_index,g_row_count)
          CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY 
      ON ACTION jump
         CALL t211_fetch('/')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
      ON ACTION next
         IF g_curs_index<g_row_count THEN
          CALL t211_fetch('N')
          CALL cl_navigator_setting(g_curs_index,g_row_count)
          CALL fgl_set_arr_curr(1)
          ACCEPT DISPLAY 
         END IF
      ON ACTION LAST
         CALL t211_fetch('L')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
         #
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY 
        #秏
      ON ACTION unconfirm
         LET g_action_choice="unconfirm"
         EXIT DISPLAY
        #釬煙
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY 
      #FUN-D20039 -----------sta
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY
      #FUN-D20039 -----------end
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY   
#      ON ACTION reproduce
#         LET g_action_choice="reproduce"
#         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
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
         IF g_ruu.ruuconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
         CALL cl_set_field_pic(g_ruu.ruuconf,"","","",g_chr,"")
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
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
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()      
            
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      ON ACTION controls                    
           CALL cl_set_head_visible("","AUTO")  
      AFTER DISPLAY
         CONTINUE DISPLAY
 
  END DISPLAY
  CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION t211_menu()
 
   WHILE TRUE
      CALL t211_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t211_q()
            END IF
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t211_a()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t211_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t211_u()
            END IF
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL t211_x()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t211_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t211_out()
            END IF
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t211_confirm()
            END IF
         WHEN "unconfirm"
            IF cl_chk_act_auth() THEN
               CALL t211_unconfirm()
            END IF
         WHEN "void"
            IF cl_chk_act_auth() THEN
               CALL t211_void(1)
            END IF
         #FUN-D20039 ----------sta
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               CALL t211_void(2)
            END IF
         #FUN-D20039 ----------end
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()       
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_ruv),'','')
             END IF        
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t211_cs()
 
    CLEAR FORM
    CONSTRUCT BY NAME g_wc ON                               
        ruu01,ruu02,ruu03,ruu04,ruu05,ruuconf,ruucond,
   #     ruucont,ruuconu,ruuplant,ruu900,ruu06,                #TQC-AB0288  mark
        ruucont,ruuconu,ruuplant,ruu06,                        #TQC-AB0288
	ruuuser,ruugrup,ruumodu,ruudate,ruuacti,ruucrat
       ,ruuoriu,ruuorig        #TQC-A30041 ADD
 
    BEFORE CONSTRUCT
        CALL cl_qbe_init()
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(ruu01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ruu01"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ruu01
                 NEXT FIELD ruu01
              WHEN INFIELD(ruu02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ruu02"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ruu02
                 NEXT FIELD ruu02
              WHEN INFIELD(ruu04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ruu04"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.where = "ruuplant = '",g_plant,"'"      #FUN-AA0092  --add
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ruu04
                 NEXT FIELD ruu04
              WHEN INFIELD(ruu05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ruu05"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ruu05
                 NEXT FIELD ruu05
              WHEN INFIELD(ruuconu)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ruuconu"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ruuconu
                 NEXT FIELD ruuconu
              OTHERWISE
                 EXIT CASE
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
    IF INT_FLAG THEN RETURN END IF
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           
    #        LET g_wc = g_wc CLIPPED," AND ruuuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           
    #        LET g_wc = g_wc CLIPPED," AND ruugrup MATCHES '",
    #                   g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN              
    #        LET g_wc = g_wc clipped," AND ruugrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('ruuuser', 'ruugrup')
    #End:FUN-980030
   
    CONSTRUCT g_wc2 ON ruv02,ruv03,ruv04,ruv05,ruv06,ruv07,ruv08,ruv09,ruv10
    FROM s_ruv[1].ruv02,s_ruv[1].ruv03,s_ruv[1].ruv04,s_ruv[1].ruv05,s_ruv[1].ruv06,
         s_ruv[1].ruv07,s_ruv[1].ruv08,s_ruv[1].ruv09,s_ruv[1].ruv10
           ON ACTION controlp
           CASE
              WHEN INFIELD(ruv04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ruv04"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ruv04
                 NEXT FIELD ruv04
              WHEN INFIELD(ruv05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ruv05"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ruv05
                 NEXT FIELD ruv05
              OTHERWISE
                 EXIT CASE
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
    IF INT_FLAG THEN 
        RETURN
        END IF
    LET g_wc2=g_wc2 CLIPPED
    IF  g_wc2=" 1=1" THEN       
        LET g_sql="SELECT ruu01 FROM ruu_file ", 
        " WHERE ",g_wc CLIPPED,
        " ORDER BY ruu01"
    ELSE
        LET g_sql="SELECT UNIQUE ruu01",
        " FROM ruu_file,ruv_file",
        " WHERE ruu01=ruv01 AND ruuplant = ruvplant ",
        " AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
        " ORDER BY ruu01"
    END IF
    PREPARE t211_prepare FROM g_sql
    DECLARE t211_cs SCROLL CURSOR WITH HOLD FOR t211_prepare
    IF g_wc2=" 1=1" THEN
        LET g_sql="SELECT COUNT(*) FROM ruu_file WHERE ",
                  g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(DISTINCT ruu01) FROM ruu_file,ruv_file WHERE",
                " ruu01=ruv01 ",
                " AND ruuplant=ruvplant ",
                " AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF 
    PREPARE t211_precount FROM g_sql
    DECLARE t211_count CURSOR FOR t211_precount
END FUNCTION
 
FUNCTION t211_confirm()
   DEFINE l_ruu01      LIKE   ruu_file.ruu01
   DEFINE l_n          LIKE type_file.num5
   DEFINE l_time       LIKE ruu_file.ruucont
 
   IF (g_ruu.ruu01 IS NULL) THEN
      CALL cl_err('',-400,0)
      RETURN 
   END IF
#CHI-C30107 ------------- add ------------- begin
   IF g_ruu.ruuconf = 'Y' THEN
      CALL cl_err('','aap-232',0)
      RETURN
   END IF

   IF g_ruu.ruuconf = 'X' THEN
      CALL cl_err('','art-380',0)
      RETURN
   END IF

   IF g_ruu.ruuacti='N' THEN
      CALL cl_err('','mfg0301',0)
      RETURN
   END IF
   IF NOT cl_confirm('aim-301') THEN RETURN END IF 
   SELECT * INTO g_ruu.* FROM ruu_file WHERE ruu01 = g_ruu.ruu01
#CHI-C30107 ------------- add ------------- end
   IF g_ruu.ruuconf = 'Y' THEN
      CALL cl_err('','aap-232',0)
      RETURN
   END IF
 
   IF g_ruu.ruuconf = 'X' THEN
      CALL cl_err('','art-380',0)
      RETURN
   END IF
 
   IF g_ruu.ruuacti='N' THEN 
      CALL cl_err('','mfg0301',0)
      RETURN
   END IF
   #add  FUN-AB0078
   IF NOT s_chk_ware(g_ruu.ruu04) THEN #检查仓库是否属于当前门店
      LET g_success='N'
      RETURN
   END IF
   #end  FUN-AB0078
   
#  IF NOT cl_confirm('aim-301') THEN RETURN END IF #CHI-C30107 mark
   BEGIN WORK
 
   OPEN t211_cl USING g_ruu.ruu01
   IF STATUS THEN
       CALL cl_err("OPEN t211_cl:", STATUS, 1)
       CLOSE t211_cl
       ROLLBACK WORK
       RETURN
   END IF
   FETCH t211_cl INTO g_ruu.*
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,1)
      RETURN
   END IF
   CALL t211_show()
   LET g_ruu.ruuconf = 'Y'
   LET g_ruu.ruuacti = 'Y'
   LET g_ruu.ruu900 = '1'
   LET l_time = TIME(CURRENT)
   UPDATE ruu_file 
      SET ruuconf=g_ruu.ruuconf,
          ruuconu=g_user,
          ruucond=g_today,
          ruucont=l_time,        
          ruu900 = g_ruu.ruu900 
    WHERE ruu01 = g_ruu.ruu01 
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
      CALL cl_err3("upd","ruu_file",g_ruu.ruu01,"",SQLCA.sqlcode,"","",1)
      ROLLBACK WORK
   END IF
   CLOSE t211_cl
   COMMIT WORK
   SELECT * INTO g_ruu.* FROM ruu_file where ruu01 = g_ruu.ruu01 
   CALL t211_show()
END FUNCTION
 
FUNCTION t211_unconfirm()
   DEFINE l_ruu01 LIKE ruu_file.ruu01
   DEFINE l_n     LIKE type_file.num5
   DEFINE l_ruucont    LIKE ruu_file.ruucont   #CHI-D20015 Add
 
   IF (g_ruu.ruu01 IS NULL) THEN
      CALL cl_err('',-400,0)
      RETURN 
   END IF
 
   IF g_ruu.ruuacti='N' THEN 
      CALL cl_err('','mfg0301',0)
      RETURN
   END IF
 
   IF g_ruu.ruuconf = 'N' THEN
      CALL  cl_err('','atm-365',0)
      RETURN
   END IF
 
   IF g_ruu.ruuconf = 'X' THEN
      CALL  cl_err('','art-382',0)
      RETURN
   END IF
 
   SELECT COUNT(*) INTO l_n FROM ruw_file WHERE ruw02=g_ruu.ruu02 
   IF l_n>0 THEN
      CALL cl_err('','art-401',0)
      RETURN
   END IF
 
   IF NOT cl_confirm('aim-302') THEN RETURN END IF
   BEGIN WORK
 
   OPEN t211_cl USING g_ruu.ruu01
   IF STATUS THEN
       CALL cl_err("OPEN t211_cl:", STATUS, 1)
       CLOSE t211_cl
       ROLLBACK WORK
       RETURN
   END IF
   FETCH t211_cl INTO g_ruu.*
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,1)
      RETURN
   END IF
   CALL t211_show()
   LET l_ruucont = TIME     #CHI-D20015 Add
   UPDATE ruu_file 
     #SET ruuconf='N',ruuconu='',ruucond='',ruucont = NULL,ruu900='0'              #CHI-D20015 Mark
      SET ruuconf='N',ruuconu=g_user,ruucond=g_today,ruucont=l_ruucont,ruu900='0'  #CHI-D20015 Add
    WHERE ruu01 = g_ruu.ruu01 
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
      CALL cl_err3("upd","ruu_file",g_ruu.ruu01,"",SQLCA.sqlcode,"","",1)
      ROLLBACK WORK
   END IF
   CLOSE t211_cl
   COMMIT WORK
   SELECT * INTO g_ruu.* FROM ruu_file where ruu01 = g_ruu.ruu01 
   CALL t211_show()
END FUNCTION
 
FUNCTION t211_void(p_type)
   DEFINE p_type    LIKE type_file.chr1   #FUN-D20039  add '1' 作废  '2' 取消作废
   DEFINE l_ruu01 LIKE ruu_file.ruu01
 
   IF (g_ruu.ruu01 IS NULL) THEN
      CALL cl_err('',-400,0)
      RETURN 
   END IF
   
   #FUN-D20039 ----------sta
    IF p_type = 1 THEN
       IF g_ruu.ruuconf='X' THEN RETURN END IF
    ELSE
       IF g_ruu.ruuconf<>'X' THEN RETURN END IF
    END IF
   #FUN-D20039 ----------end
   
   IF g_ruu.ruuacti='N' THEN 
      CALL cl_err('','mfg0301',0)
      RETURN
   END IF
 
 #TQC-AB0288 --------------mark
 # IF g_ruu.ruuconf = 'X' THEN
 #    CALL  cl_err('','art-378',0)
 #    RETURN
 # END IF
 #TQC-AB0288 --------------mark
 
   IF g_ruu.ruuconf = 'Y' THEN
      CALL cl_err('','art-225',0)
      RETURN
   END IF

 
 #  IF NOT cl_confirm('art-381') THEN RETURN END IF      #TQC-AB0288  mark
   BEGIN WORK
 
   OPEN t211_cl USING g_ruu.ruu01
   IF STATUS THEN
       CALL cl_err("OPEN t211_cl:", STATUS, 1)
       CLOSE t211_cl
       ROLLBACK WORK
       RETURN
   END IF
   FETCH t211_cl INTO g_ruu.*
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,1)
      RETURN
   END IF
#TQC-AB0288 ----------------STA
   IF cl_void(0,0,g_ruu.ruuconf) THEN
      LET g_chr = g_ruu.ruuconf
      IF g_ruu.ruuconf = 'N' THEN
         LET g_ruu.ruuconf = 'X'
      ELSE
         LET g_ruu.ruuconf = 'N'
      END IF
#TQC-AB0288 ----------------END
      CALL t211_show()
      UPDATE ruu_file 
         SET ruuconf=g_ruu.ruuconf,ruuconu='',ruucond=''
       WHERE ruu01 = g_ruu.ruu01 
      IF SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","ruu_file",g_ruu.ruu01,"",SQLCA.sqlcode,"","",1)
         ROLLBACK WORK
      END IF
   END IF                                       #TQC-AB0288 
   CLOSE t211_cl
   COMMIT WORK
   SELECT * INTO g_ruu.* FROM ruu_file where ruu01 = g_ruu.ruu01 
   CALL t211_show()
END FUNCTION
 
FUNCTION t211_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    CALL cl_opmsg('q')   
    CLEAR FORM 
    CALL g_ruv.clear()      
    MESSAGE ""
    
    DISPLAY ' ' TO FORMONLY.cnt
    CALL t211_cs()                      
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_ruu.* TO NULL
        RETURN
    END IF
    OPEN t211_cs                
    
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        CALL g_ruv.clear()
    ELSE
        OPEN t211_count
        FETCH t211_count INTO g_row_count
        IF g_row_count>0 THEN
           DISPLAY g_row_count TO FORMONLY.cn2
           CALL t211_fetch('F') 
        ELSE 
           CALL cl_err('',100,0)
        END IF             
    END IF
END FUNCTION
 
FUNCTION t211_fetch(p_flruu)
    DEFINE
        p_flruu         LIKE type_file.chr1           
    CASE p_flruu
        WHEN 'N' FETCH NEXT     t211_cs INTO g_ruu.ruu01
        WHEN 'P' FETCH PREVIOUS t211_cs INTO g_ruu.ruu01
        WHEN 'F' FETCH FIRST    t211_cs INTO g_ruu.ruu01
        WHEN 'L' FETCH LAST     t211_cs INTO g_ruu.ruu01
        WHEN '/'
            IF (NOT mi_no_ask) THEN                   
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
 
                  ON ACTION about         
                     CALL cl_about()      
 
                  ON ACTION help          
                     CALL cl_show_help()  
 
                  ON ACTION controlg      
                     CALL cl_cmdask()    
 
               END PROMPT
               IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
               END IF
            END IF
            FETCH ABSOLUTE g_jump t211_cs INTO g_ruu.ruu01
            LET mi_no_ask = FALSE        
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ruu.ruu01,SQLCA.sqlcode,0)
        INITIALIZE g_ruu.* TO NULL       
        RETURN
    ELSE
      CASE p_flruu
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.cnt                 
    END IF
 
    SELECT * INTO g_ruu.* FROM ruu_file    
       WHERE ruu01=g_ruu.ruu01 
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","ruu_file","","",SQLCA.sqlcode,"","",0)  
    ELSE
        LET g_data_owner=g_ruu.ruuuser           
        LET g_data_group=g_ruu.ruugrup
        LET g_data_plant=g_ruu.ruuplant  #TQC-A10128 ADD
        CALL t211_show()                   
    END IF
END FUNCTION
 
FUNCTION t211_ruu02(p_cmd)         
DEFINE    l_ruu02_desc    LIKE rus_file.rus02,
          p_cmd      LIKE type_file.chr1
 
   SELECT rus02 INTO l_ruu02_desc FROM rus_file
    WHERE rus01 = g_ruu.ruu02 AND rusconf ='Y' 
 
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_ruu02_desc TO FORMONLY.ruu02_desc
  END IF
END FUNCTION
 
FUNCTION t211_ruu03(p_cmd)         
DEFINE    l_ruu03    LIKE rus_file.rus04,
          p_cmd      LIKE type_file.chr1
 
   SELECT rus04 INTO g_ruu.ruu03 FROM rus_file
     WHERE rus01=g_ruu.ruu02 AND rusconf='Y' 
 
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY BY NAME g_ruu.ruu03
  END IF
END FUNCTION
FUNCTION t211_ruu05()
DEFINE l_gen02      LIKE gen_file.gen02
DEFINE l_genacti    LIKE gen_file.genacti
 
   SELECT gen02,genacti INTO l_gen02,l_genacti FROM gen_file
       WHERE gen01 = g_ruu.ruu05
   CASE WHEN SQLCA.SQLCODE = 100  
                            LET g_errno = 'art-391'
        WHEN l_genacti='N'  LET g_errno = '9028'
        OTHERWISE           LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF cl_null(g_errno) THEN
      DISPLAY l_gen02 TO FORMONLY.ruu05_desc
   END IF
END FUNCTION
FUNCTION t211_ruu04(p_cmd)         
DEFINE    l_ruu04_desc    LIKE imd_file.imd02,
          p_cmd      LIKE type_file.chr1
 
   SELECT imd02 INTO l_ruu04_desc
     FROM imd_file
     WHERE imd01=g_ruu.ruu04 AND imd11='Y' AND imdacti='Y' AND imd20=g_ruu.ruuplant
 
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_ruu04_desc TO FORMONLY.ruu04_desc
  END IF
END FUNCTION
 
FUNCTION t211_ruu04_1()
DEFINE l_rus05    LIKE rus_file.rus05
DEFINE l_rusacti  LIKE rus_file.rusacti
DEFINE l_rusconf  LIKE rus_file.rusconf
DEFINE l_count    LIKE type_file.num5
DEFINE l_ck            LIKE type_file.chr50
DEFINE tok             base.StringTokenizer
DEFINE l_imd02    LIKE imd_file.imd02
 
   LET g_errno = ""
   
   IF g_ruu.ruu02 IS NULL OR g_ruu.ruu04 IS NULL THEN
      RETURN
   END IF
 
   SELECT rus05,rusacti,rusconf INTO l_rus05,l_rusacti,l_rusconf 
      FROM rus_file WHERE rus01 = g_ruu.ruu02 
   CASE WHEN SQLCA.SQLCODE = 100  
                            LET g_errno = 'art-392'
        WHEN l_rusacti='N'  LET g_errno = '9028'
        WHEN l_rusconf<>'Y' LET g_errno = 'art-384'
        OTHERWISE           LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF cl_null(g_errno) THEN
      LET tok = base.StringTokenizer.createExt(l_rus05,"|",'',TRUE)
      LET l_count = 0
      WHILE tok.hasMoreTokens()
         LET l_ck = tok.nextToken()
         IF l_ck = g_ruu.ruu04 THEN LET l_count = 1 END IF 
      END WHILE
      IF l_count = 0 THEN LET g_errno = 'art-385' END IF 
   END IF 
 
   IF cl_null(g_errno) THEN
      SELECT * FROM ruu_file
          WHERE ruu01 = g_ruu.ruu01 AND ruuconf = 'Y'
            AND ruu04 = g_ruu.ruu04
      IF SQLCA.SQLCODE <> 100 THEN
         LET g_errno = 'art-390'
      END IF
   END IF
END FUNCTION 
 
 
FUNCTION t211_ruuconu(p_cmd)         
DEFINE    l_ruuconu_desc    LIKE gen_file.gen02,
          p_cmd      LIKE type_file.chr1
 
   SELECT gen02 INTO l_ruuconu_desc
     FROM gen_file
     WHERE gen01=g_ruu.ruuconu AND genacti='Y'
 
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_ruuconu_desc TO FORMONLY.ruuconu_desc
  END IF
END FUNCTION
 
FUNCTION t211_ruuplant(p_cmd)         
DEFINE    l_ruuplant_desc    LIKE azp_file.azp02,
          p_cmd              LIKE type_file.chr1
 
   SELECT azp02 INTO l_ruuplant_desc
     FROM azp_file
     WHERE azp01=g_ruu.ruuplant 
 
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_ruuplant_desc TO FORMONLY.ruuplant_desc
  END IF
END FUNCTION
 
#FUNCTION t211_ruv04_1()
#DEFINE l_rtz04         LIKE tqb_file.rtz04
#DEFINE l_ck            LIKE type_file.chr50
#DEFINE tok             base.StringTokenizer
#DEFINE l_rte07         LIKE rte_file.rte07
 
#   LET g_errno = ''
#   SELECT rtz04 INTO l_rtz04 FROM tqb_file WHERE tqb01 = g_ruu.ruuplant
#   LET tok = base.StringTokenizer.createExt(g_ruv[l_ac].ruv04,"|",'',TRUE)
#   WHILE tok.hasMoreTokens()
#      LET l_ck = tok.nextToken()
#      IF l_ck IS NULL THEN 
#         LET g_errno = 'art-358'
#         RETURN
#      END IF
#      SELECT rte07 INTO l_rte07 FROM rte_file
#          WHERE rte03 = l_ck AND rte01 = l_rtz04
#      IF SQLCA.sqlcode = 100  THEN
#         LET g_errno = 'art-356'
#         RETURN
#      END IF
#      IF l_rte07 IS NULL OR l_rte07 = 'N' THEN
#         LET g_errno = 'art-357'
#         RETURN
#      END IF
#   END WHILE
#END FUNCTION
 
FUNCTION t211_ruv04()
DEFINE l_imaacti LIKE ima_file.imaacti
DEFINE l_rtz04   LIKE rtz_file.rtz04
DEFINE l_n       LIKE type_file.num5
DEFINE l_i       LIKE type_file.num5
DEFINE l_flag    LIKE type_file.num5
DEFINE l_rus07   LIKE rus_file.rus07
DEFINE l_rus09   LIKE rus_file.rus09
DEFINE l_rus11   LIKE rus_file.rus11
DEFINE l_rus13   LIKE rus_file.rus13
 
   LET g_errno = ""
 
   SELECT ima02,imaacti,ima25,gfe02
      INTO g_ruv[l_ac].ruv04_desc,l_imaacti,
           g_ruv[l_ac].ruv05,g_ruv[l_ac].ruv05_desc
      FROM ima_file,gfe_file 
      WHERE ima01 = g_ruv[l_ac].ruv04 AND gfe01 = ima25
 
   CASE WHEN SQLCA.SQLCODE = 100  
                           LET g_errno = 'art-037'
        WHEN l_imaacti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
                           DISPLAY g_ruv[l_ac].ruv04_desc TO FORMONLY.ruv04_desc
                           DISPLAY g_ruv[l_ac].ruv05_desc TO FORMONLY.ruv05_desc
                           DISPLAY BY NAME g_ruv[l_ac].ruv05
                           
   END CASE
   
   IF cl_null(g_errno) THEN
      SELECT rtz04 INTO l_rtz04 
         FROM rtz_file WHERE rtz01=g_ruu.ruuplant
      IF NOT cl_null(l_rtz04) THEN
         SELECT rus07,rus09,rus11,rus13 
       	   INTO l_rus07,l_rus09,l_rus11,l_rus13
           FROM rus_file 
          WHERE rus01 = g_ruu.ruu02 
           #AND rus930 = g_ruu.ruuplant   #TQC-C90123 Mark
            AND rusplant = g_ruu.ruuplant #TQC-C90123 Add
         CALL t211_get_shop(l_rus07,l_rus09,l_rus11,l_rus13) RETURNING l_flag
         IF l_flag = 0 THEN
            SELECT COUNT(*) INTO l_n FROM rte_file 
               WHERE rte01 = l_rtz04 AND rte03 = g_ruv[l_ac].ruv04
            IF l_n = 0 OR l_n IS NULL THEN
               LET g_errno = 'art-054'
            END IF    
         ELSE
       	    FOR l_i=1 TO g_result.getLength()
               IF g_result[l_i] = g_ruv[l_ac].ruv04 THEN
                  LET l_flag = 3
               END IF
            END FOR
            IF l_flag <> '3' THEN
               LET g_errno = 'art-387'
            END IF
         END IF
     #TQC-C90123 Add Begin ---
      ELSE
         INITIALIZE l_rus07,l_rus09,l_rus11,l_rus13 TO NULL
         SELECT rus07,rus09,rus11,rus13
           INTO l_rus07,l_rus09,l_rus11,l_rus13
           FROM rus_file
          WHERE rus01 = g_ruu.ruu02
            AND rusplant = g_ruu.ruuplant
         CALL t211_get_shop(l_rus07,l_rus09,l_rus11,l_rus13) RETURNING l_flag
         IF l_flag > 0 THEN
            FOR l_i=1 TO g_result.getLength()
               IF g_result[l_i] = g_ruv[l_ac].ruv04 THEN
                  LET l_flag = 3
               END IF
            END FOR
            IF l_flag <> '3' THEN
               LET g_errno = 'art-387'
            END IF
         ELSE
            LET g_errno = 'art-387'
         END IF
     #TQC-C90123 Add End -----
      END IF
   END IF
 
END FUNCTION
 
FUNCTION t211_get_shop(p_sort,p_sign,p_factory,p_shop)
DEFINE l_ck            LIKE type_file.chr50
DEFINE tok             base.StringTokenizer
DEFINE l_n1            LIKE type_file.num5
DEFINE l_n2            LIKE type_file.num5
DEFINE l_n3            LIKE type_file.num5   
DEFINE l_n4            LIKE type_file.num5
DEFINE l_sql           STRING
DEFINE p_sort          LIKE rus_file.rus07
DEFINE p_sign          LIKE rus_file.rus09
DEFINE p_factory       LIKE rus_file.rus11
DEFINE p_shop          LIKE rus_file.rus13
 
   LET g_errno = ''
   
   IF cl_null(p_sort) AND cl_null(p_sign)
      AND cl_null(p_factory) AND cl_null(p_shop) THEN
      RETURN 0
   END IF
 
#FUN-9B0068 --BEGIN--
#   CREATE TEMP TABLE sort(ima01 varchar(40))
#   CREATE TEMP TABLE sign(ima01 varchar(40))
#   CREATE TEMP TABLE factory(ima01 varchar(40))
#   CREATE TEMP TABLE no(ima01 varchar(40))
   CREATE TEMP TABLE sort(
                ima01 LIKE ima_file.ima01)
   CREATE TEMP TABLE sign(
                ima01 LIKE ima_file.ima01)
   CREATE TEMP TABLE factory(
                ima01 LIKE ima_file.ima01)
   CREATE TEMP TABLE no(
                ima01 LIKE ima_file.ima01)
#FUN-9B0068 
   CALL t210_get_sort(p_sort)
   CALL t210_get_sign(p_sign)
   CALL t210_get_factory(p_factory)
   CALL t210_get_no(p_shop)
 
   SELECT count(*) INTO l_n1 FROM sort
   SELECT count(*) INTO l_n2 FROM sign
   SELECT count(*) INTO l_n3 FROM factory
   SELECT count(*) INTO l_n4 FROM no
  
   CALL g_result.clear()
 
  #TQC-C90123 Mark Begin ---
  #IF l_n1 != 0 THEN
  #   IF l_n2 != 0 THEN
  #      IF l_n3 != 0 THEN
  #         IF l_n4 != 0 THEN
  #            LET l_sql = "SELECT A.ima01 FROM sort A,sign B,factory C,no D ",
  #                        " WHERE A.ima01 = B.ima01 AND B.ima01 = C.ima01 ",
  #                        " C.ima01 = D.ima01 "
  #         ELSE
  #            LET l_sql = "SELECT A.ima01 FROM sort A,sign B,factory C ",
  #                        " WHERE A.ima01 = B.ima01 AND B.ima01 = C.ima01 "
  #         END IF
  #      ELSE                     
  #         IF l_n4 != 0 THEN
  #            LET l_sql = "SELECT A.ima01 FROM sort A,sign B,no D ",
  #                        " WHERE A.ima01 = B.ima01 AND B.ima01 = D.ima01 "
  #         ELSE
  #            LET l_sql = "SELECT A.ima01 FROM sort A,sign B ",
  #                        " WHERE A.ima01 = B.ima01 "
  #         END IF
  #      END IF
  #   ELSE
  #      IF l_n3 != 0 THEN
  #         IF l_n4 != 0 THEN
  #            LET l_sql = "SELECT A.ima01 FROM sort A,factory C,no D ",
  #                        " WHERE A.ima01 = C.ima01 AND D.ima01 = C.ima01 "
  #         ELSE
  #            LET l_sql = "SELECT A.ima01 FROM sort A,factory C ",
  #                        " WHERE A.ima01 = C.ima01 "
  #         END IF
  #      ELSE
  #         IF l_n4 != 0 THEN
  #            LET l_sql = "SELECT A.ima01 FROM sort A,no D ",
  #                        " WHERE A.ima01 = D.ima01"
  #         ELSE
  #            LET l_sql = "SELECT A.ima01 FROM sort A "
  #         END IF
  #      END IF
  #   END IF
  #ELSE
  #   IF l_n2 != 0 THEN
  #      IF l_n3 != 0 THEN
  #         IF l_n4 != 0 THEN
  #            LET l_sql = "SELECT B.ima01 FROM sign B,factory C,no D ",
  #                        " WHERE B.ima01 = C.ima01 AND D.ima01 = C.ima01 " 
  #         ELSE
  #            LET l_sql = "SELECT B.ima01 FROM sign B,factory C ",
  #                        " WHERE B.ima01 = C.ima01 "
  #         END IF
  #      ELSE
  #         IF l_n4 != 0 THEN
  #            LET l_sql = "SELECT B.ima01 FROM sign B,no D ",
  #                        " WHERE B.ima01 = D.ima01 "
  #         ELSE
  #            LET l_sql = "SELECT B.ima01 FROM sign B "
  #         END IF
  #      END IF
  #   ELSE
  #      IF l_n3 != 0 THEN
  #         IF l_n4 != 0 THEN
  #            LET l_sql = "SELECT C.ima01 FROM factory C,no D ",
  #                        " WHERE C.ima01 = D.ima01 "
  #         ELSE
  #            LET l_sql = "SELECT C.ima01 FROM factory C "
  #         END IF
  #      ELSE
  #         IF l_n4 != 0 THEN
  #            LET l_sql = "SELECT D.ima01 FROM no D "
  #         END IF
  #      END IF
  #   END IF
  #END IF
  #TQC-C90123 Mark End -----
  #TQC-C90123 Add Begin ---
   IF NOT cl_null(p_sort) THEN
      IF NOT cl_null(p_sign) THEN
         IF NOT cl_null(p_factory) THEN
            IF NOT cl_null(p_shop) THEN
               LET l_sql = "SELECT A.ima01 FROM sort A,sign B,factory C,no D ",
                           " WHERE A.ima01 = B.ima01 AND B.ima01 = C.ima01 ",
                           "   AND C.ima01 = D.ima01 "
            ELSE
               LET l_sql = "SELECT A.ima01 FROM sort A,sign B,factory C ",
                           " WHERE A.ima01 = B.ima01 AND B.ima01 = C.ima01 "
            END IF
         ELSE
            IF NOT cl_null(p_shop) THEN
               LET l_sql = "SELECT A.ima01 FROM sort A,sign B,no D ",
                           " WHERE A.ima01 = B.ima01 AND B.ima01 = D.ima01 "
            ELSE
               LET l_sql = "SELECT A.ima01 FROM sort A,sign B ",
                           " WHERE A.ima01 = B.ima01 "
            END IF
         END IF
      ELSE
         IF NOT cl_null(p_factory) THEN
            IF NOT cl_null(p_shop) THEN
               LET l_sql = "SELECT A.ima01 FROM sort A,factory C,no D ",
                           " WHERE A.ima01 = C.ima01 AND D.ima01 = C.ima01 "
            ELSE
               LET l_sql = "SELECT A.ima01 FROM sort A,factory C ",
                           " WHERE A.ima01 = C.ima01 "
            END IF
         ELSE
            IF NOT cl_null(p_shop) THEN
               LET l_sql = "SELECT A.ima01 FROM sort A,no D ",
                           " WHERE A.ima01 = D.ima01"
            ELSE
               LET l_sql = "SELECT A.ima01 FROM sort A "
            END IF
         END IF
      END IF
   ELSE
      IF NOT cl_null(p_sign) THEN
         IF NOT cl_null(p_factory) THEN
            IF NOT cl_null(p_shop) THEN
               LET l_sql = "SELECT B.ima01 FROM sign B,factory C,no D ",
                           " WHERE B.ima01 = C.ima01 AND D.ima01 = C.ima01 "
            ELSE
               LET l_sql = "SELECT B.ima01 FROM sign B,factory C ",
                           " WHERE B.ima01 = C.ima01 "
            END IF
         ELSE
            IF NOT cl_null(p_shop) THEN
               LET l_sql = "SELECT B.ima01 FROM sign B,no D ",
                           " WHERE B.ima01 = D.ima01 "
            ELSE
               LET l_sql = "SELECT B.ima01 FROM sign B "
            END IF
         END IF
      ELSE
         IF NOT cl_null(p_factory) THEN
            IF NOT cl_null(p_shop) THEN
               LET l_sql = "SELECT C.ima01 FROM factory C,no D ",
                           " WHERE C.ima01 = D.ima01 "
            ELSE
               LET l_sql = "SELECT C.ima01 FROM factory C "
            END IF
         ELSE
            IF NOT cl_null(p_shop) THEN
               LET l_sql = "SELECT D.ima01 FROM no D "
            END IF 
         END IF            
      END IF
   END IF      
  #TQC-C90123 Add End -----
   
   IF l_sql IS NULL THEN RETURN 0 END IF
   PREPARE t211_get_pb FROM l_sql
   DECLARE rus_get_cs1 CURSOR FOR t211_get_pb
   LET g_cnt = 1
   FOREACH rus_get_cs1 INTO g_result[g_cnt]
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      
      LET g_cnt = g_cnt + 1
   END FOREACH  
   CALL g_result.deleteElement(g_cnt)
 
   DROP TABLE sort
   DROP TABLE sign
   DROP TABLE factory
   DROP TABLE no
 
   IF g_result.getLength() = 0 THEN
      RETURN -1
   ELSE
      IF cl_null(g_result[1]) THEN
         RETURN -1
      END IF
      RETURN 1
   END IF
END FUNCTION
 
FUNCTION t211_show()
    LET g_ruu_t.* = g_ruu.*
    LET g_ruu_o.*=g_ruu.*
    DISPLAY BY NAME g_ruu.ruu01,g_ruu.ruu02,g_ruu.ruu03,g_ruu.ruu04,g_ruu.ruu05,g_ruu.ruu06, g_ruu.ruuoriu,g_ruu.ruuorig,
       #             g_ruu.ruu900,g_ruu.ruuconf,g_ruu.ruucond,g_ruu.ruucont,                 #TQC-AB0288  mark
                    g_ruu.ruuconf,g_ruu.ruucond,g_ruu.ruucont,                               #TQC-AB0288
                    g_ruu.ruuconu,g_ruu.ruuplant,g_ruu.ruuuser,g_ruu.ruugrup,
                    g_ruu.ruumodu,g_ruu.ruudate,g_ruu.ruuacti,g_ruu.ruucrat
    IF g_ruu.ruuconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
    CALL cl_set_field_pic(g_ruu.ruuconf,"","","",g_chr,"")
    CALL t211_ruu02('d')
    #CALL t211_ruu03('d')
    CALL t211_ruu04('d')
    CALL t211_ruu05()
    CALL t211_ruuconu('d')
    CALL t211_ruuplant('d')
    CALL t211_b_fill(g_wc2) 
    CALL cl_show_fld_cont()                   
END FUNCTION
 
FUNCTION t211_b_fill(p_wc2)              
DEFINE   p_wc2       STRING        
 
    LET g_sql =
        "SELECT ruv02,ruv03,ruv04,'',ruv05,'',ruv06,ruv07,ruv08,ruv09,ruv10 FROM ruv_file ",
        " WHERE ruv01='",g_ruu.ruu01,"'",
        " AND ruvplant='",g_ruu.ruuplant,"'"
    IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
    END IF
    PREPARE t211_pb FROM g_sql
    DECLARE ruv_cs CURSOR FOR t211_pb
 
    CALL g_ruv.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH ruv_cs INTO g_ruv[g_cnt].*  
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) 
           EXIT FOREACH
        END IF
        SELECT ima02 INTO g_ruv[g_cnt].ruv04_desc FROM ima_file WHERE ima01 = g_ruv[g_cnt].ruv04 AND imaacti='Y'
        SELECT ima25 INTO g_ruv[g_cnt].ruv05 FROM ima_file WHERE ima01 = g_ruv[g_cnt].ruv04 AND imaacti='Y'
        SELECT gfe02 INTO g_ruv[g_cnt].ruv05_desc FROM gfe_file WHERE gfe01 = g_ruv[g_cnt].ruv05 AND gfeacti='Y'
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
 
    CALL g_ruv.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    LET g_cnt = 0
END FUNCTION
 
FUNCTION t211_a()
   DEFINE li_result   LIKE type_file.num5
   DEFINE ls_doc      STRING
   DEFINE li_inx      LIKE type_file.num10
 
   MESSAGE ""
   CLEAR FORM
   CALL g_ruv.clear()
   LET g_wc = NULL
   LET g_wc2= NULL
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   INITIALIZE g_ruu.* LIKE ruu_file.*
   LET g_ruu01_t = NULL
 
   LET g_ruu_t.* = g_ruu.*
   LET g_ruu_o.* = g_ruu.*
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_ruu.ruuuser=g_user
      LET g_ruu.ruuoriu = g_user #FUN-980030
      LET g_ruu.ruuorig = g_grup #FUN-980030
      LET g_data_plant  = g_plant #TQC-A10128 ADD
      LET g_ruu.ruugrup=g_grup
      LET g_ruu.ruucrat=g_today
      LET g_ruu.ruuacti='Y'
      LET g_ruu.ruu05=g_user
      LET g_ruu.ruuconf='N'
      LET g_ruu.ruuplant=g_plant
      LET g_ruu.ruulegal=g_legal
      LET g_ruu.ruu900 = '0'
      CALL t211_ruu05()
      CALL t211_ruuplant("a")
      
      CALL t211_i("a")
 
      IF INT_FLAG THEN
         INITIALIZE g_ruu.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF cl_null(g_ruu.ruu01) THEN
         CONTINUE WHILE
      END IF
 
      BEGIN WORK 
#     CALL s_auto_assign_no('art',g_ruu.ruu01,g_today,'I','ruu_file','ruu01','','','') #FUN-A70130 mark
      CALL s_auto_assign_no('art',g_ruu.ruu01,g_today,'E1','ruu_file','ruu01','','','') #FUN-A70130 mod
        RETURNING li_result,g_ruu.ruu01
      IF (NOT li_result) THEN
         CONTINUE WHILE
      END IF
      DISPLAY BY NAME g_ruu.ruu01
 
      INSERT INTO ruu_file VALUES (g_ruu.*)
      IF SQLCA.sqlcode THEN
         CALL cl_err(g_ruu.ruu01,SQLCA.sqlcode,1)
         CALL cl_err3("ins","ruu_file",g_ruu.ruu01,"",SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      ELSE
         COMMIT WORK
         CALL cl_flow_notify(g_ruu.ruu01,'I')
      END IF
 
      LET g_ruu01_t = g_ruu.ruu01
      LET g_ruu_t.* = g_ruu.*
      LET g_ruu_o.* = g_ruu.*
      CALL g_ruv.clear()
 
      LET g_rec_b = 0
      CALL t211_b()
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION t211_i(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1,
            l_input   LIKE type_file.chr1,
            l_n       LIKE type_file.num5,
            l_acti    LIKE type_file.chr1,
     #       g_t1      LIKE type_file.chr3,       #FUN-AA0046  mark    
            g_t1      LIKE type_file.chr30,        #FUN-AA0046
            li_result LIKE type_file.num5,
            l_ck      LIKE type_file.chr50,
            tok       base.StringTokenizer,
            l_rus05   LIKE rus_file.rus05,
            l_temp    LIKE type_file.chr1000
 
   DISPLAY BY NAME
      g_ruu.ruu01,g_ruu.ruu02,g_ruu.ruu03,g_ruu.ruu04,g_ruu.ruu05,
      g_ruu.ruuconf,g_ruu.ruucond,g_ruu.ruuconu,g_ruu.ruuplant,g_ruu.ruu06,
 #     g_ruu.ruuuser,g_ruu.ruugrup,g_ruu.ruumodu,g_ruu.ruu900,         #TQC-AB0288  mark
      g_ruu.ruuuser,g_ruu.ruugrup,g_ruu.ruumodu,                       #TQC-AB0288
      g_ruu.ruudate,g_ruu.ruuacti,g_ruu.ruucrat
     ,g_ruu.ruuoriu,g_ruu.ruuorig             #TQC-A30041 ADD
 
   INPUT BY NAME g_ruu.ruuoriu,g_ruu.ruuorig,
      g_ruu.ruu01,g_ruu.ruu02,g_ruu.ruu04,g_ruu.ruu05,g_ruu.ruu06
      WITHOUT DEFAULTS
 
      BEFORE INPUT
          LET g_before_input_done = FALSE
          CALL t211_set_entry(p_cmd)
          CALL t211_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
          CALL cl_set_docno_format("ruu01")
 
      AFTER FIELD ruu01
         DISPLAY "AFTER FIELD ruu01"
         IF NOT cl_null(g_ruu.ruu01) THEN
            IF g_ruu.ruu01 !=g_ruu01_t OR g_ruu01_t IS NULL THEN
#              CALL s_check_no('art',g_ruu.ruu01,g_ruu01_t,'I','ruu_file','ruu01','') #FUN-A70130 mark
               CALL s_check_no('art',g_ruu.ruu01,g_ruu01_t,'E1','ruu_file','ruu01','') #FUN-A70130 mod
                    RETURNING li_result,g_ruu.ruu01
               IF (NOT li_result) THEN
                  LET g_ruu.ruu01=g_ruu01_t
                  DISPLAY BY NAME g_ruu.ruu01
                  NEXT FIELD ruu01
               END IF
            END IF
         ELSE
            CALL cl_err('','art-347',0)
            LET g_ruu.ruu01=g_ruu01_t
            DISPLAY BY NAME g_ruu.ruu01
            NEXT FIELD ruu01  
         END IF
         
     AFTER FIELD ruu02
         DISPLAY "AFTER FIELD ruu02"
         IF NOT cl_null(g_ruu.ruu02) THEN
            SELECT COUNT(*) INTO l_n FROM ruw_file WHERE ruw02=g_ruu.ruu02 
            IF l_n>0 THEN
               CALL cl_err('','art-489',0)
               LET g_ruu.ruu02=g_ruu_t.ruu02
               DISPLAY BY NAME g_ruu.ruu02
               NEXT FIELD ruu02
            ELSE
               SELECT COUNT(*) INTO l_n FROM rus_file 
                  WHERE rus01=g_ruu.ruu02 AND rusplant = g_ruu.ruuplant
               IF l_n>0 THEN
                  CALL t211_ruu02('a')
                  CALL t211_ruu03('a')
                  CALL t211_ruu04_1()
               ELSE
                  CALL cl_err('','art-397',0)
                  LET g_ruu.ruu02=g_ruu_t.ruu02
                  DISPLAY BY NAME g_ruu.ruu02
                  NEXT FIELD ruu02
               END IF
            END IF
         END IF
 
     AFTER FIELD ruu04
         IF NOT cl_null(g_ruu.ruu04) THEN
            IF p_cmd='a' OR 
               (p_cmd='u' AND g_ruu.ruu04 != g_ruu_t.ruu04) THEN
               CALL t211_ruu04_1()
               CALL t211_ruu04('a')
               IF NOT cl_null(g_errno)  THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD ruu04
               END IF
            END IF
         END IF
        #FUN-AA0092  --add
         IF NOT s_chk_ware(g_ruu.ruu04) THEN
            NEXT FIELD ruu04
         END IF
        #FUN-AA0092  --end

 
     AFTER FIELD ruu05
         IF NOT cl_null(g_ruu.ruu05) THEN
            IF p_cmd='a' OR 
               (p_cmd='u' AND g_ruu.ruu05 != g_ruu_t.ruu05) THEN
               CALL t211_ruu05()
               IF NOT cl_null(g_errno)  THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD ruu05
               END IF
            END IF
         END IF
     AFTER INPUT
        LET g_ruu.ruuuser = s_get_data_owner("ruu_file") #FUN-C10039
        LET g_ruu.ruugrup = s_get_data_group("ruu_file") #FUN-C10039
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            IF g_ruu.ruu01 IS NULL THEN
               DISPLAY BY NAME g_ruu.ruu01
               LET l_input='Y'
            END IF
            IF l_input='Y' THEN
               NEXT FIELD ruu01
            END IF
 
      ON ACTION CONTROLO                        
         IF INFIELD(ruu01) THEN
            LET g_ruu.* = g_ruu_t.*
            CALL t211_show()
            NEXT FIELD ruu01
         END IF
 
     ON ACTION controlp
        CASE
           WHEN INFIELD(ruu01)
              LET g_t1=s_get_doc_no(g_ruu.ruu01)   #籵徹等擂晤瘍堤等梗
#             CALL q_smy(FALSE,FALSE,g_t1,'ART','I') RETURNING g_t1               #羲敦  #FUN-A70130--mark--
              CALL q_oay(FALSE,FALSE,g_t1,'E1','ART') RETURNING g_t1               #羲敦  #FUN-A70130--add--
              LET g_ruu.ruu01=g_t1
              DISPLAY BY NAME g_ruu.ruu01
              NEXT FIELD ruu01
           WHEN INFIELD(ruu02)
              CALL cl_init_qry_var()
	      LET g_qryparam.form = "q_rus01"
              LET g_qryparam.arg1 = g_ruu.ruuplant
              LET g_qryparam.default1 = g_ruu.ruu02
              CALL cl_create_qry() RETURNING g_ruu.ruu02
              DISPLAY BY NAME g_ruu.ruu02
              CALL t211_ruu02('a')
              NEXT FIELD ruu02
           WHEN INFIELD(ruu04)
#              CALL cl_init_qry_var()
#              LET g_qryparam.form = "q_rus05"
#              LET g_qryparam.default1 = g_ruu.ruu04
#              CALL cl_create_qry() RETURNING g_ruu.ruu04
#              DISPLAY BY NAME g_ruu.ruu04
#              CALL t211_ruu04('a')
#              NEXT FIELD ruu04
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_ruw05"
              SELECT rus05 INTO l_rus05 FROM rus_file
                 WHERE rus01 = g_ruu.ruu02
                   AND rusplant = g_plant       #FUN-AA0092  --add
              LET tok = base.StringTokenizer.createExt(l_rus05,"|",'',TRUE)
              LET g_qryparam.where = " imd01 IN ('"
              WHILE tok.hasMoreTokens()
                 LET l_ck = tok.nextToken()
                 LET g_qryparam.where = g_qryparam.where,l_ck,"','"
              END WHILE
              LET g_qryparam.where = g_qryparam.where.trimRight()
              LET l_temp = g_qryparam.where
              LET g_qryparam.where = l_temp[1,g_qryparam.where.getLength()-2]
              LET g_qryparam.where = g_qryparam.where,")"
              LET g_qryparam.default1 = g_ruu.ruu04
              CALL cl_create_qry() RETURNING g_ruu.ruu04
              DISPLAY BY NAME g_ruu.ruu04
              CALL t211_ruu04_1()
              NEXT FIELD ruu04
           WHEN INFIELD(ruu05)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_gen"
              LET g_qryparam.default1 = g_ruu.ruu05
              CALL cl_create_qry() RETURNING g_ruu.ruu05
              DISPLAY BY NAME g_ruu.ruu05
              CALL t211_ruu05()
              NEXT FIELD ruu05
           OTHERWISE
              EXIT CASE
        END CASE
 
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF                       
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()
 
      ON ACTION HELP
         CALL cl_show_help()
 
   END INPUT
 
END FUNCTION
 
FUNCTION t211_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1          
 
     IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("ruu01",TRUE)
     END IF
 
END FUNCTION
 
FUNCTION t211_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1         
 
    IF p_cmd = 'u' AND g_chkey = 'N'AND (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("ruu01",FALSE)
       
    END IF
 
END FUNCTION
 
FUNCTION t211_b()
        DEFINE l_ac_t LIKE type_file.num5,
                l_n     LIKE type_file.num5,
                l_cnt   LIKE type_file.num5,
                l_lock_sw       LIKE type_file.chr1,
                p_cmd   LIKE type_file.chr1,
                l_misc  LIKE gef_file.gef01,
                l_allow_insert  LIKE type_file.num5,
                l_allow_delete  LIKE type_file.num5,
                l_gen02 LIKE gen_file.gen02
DEFINE l_rtz04   LIKE rtz_file.rtz04
DEFINE l_i       LIKE type_file.num5
DEFINE l_flag    LIKE type_file.num5
DEFINE l_rus07   LIKE rus_file.rus07
DEFINE l_rus09   LIKE rus_file.rus09
DEFINE l_rus11   LIKE rus_file.rus11
DEFINE l_rus13   LIKE rus_file.rus13
#DEFINE l_temp    LIKE type_file.chr1000 #TQC-C90123 Mark
DEFINE l_temp    STRING                  #TQC-C90123 Add
DEFINE l_sql STRING #FUN-AA0059 add
DEFINE l_rus12   LIKE rus_file.rus12   #TQC-B80036
DEFINE l_case    STRING                #FUN-BB0085
DEFINE tok       base.StringTokenizer  #TQC-C90064
DEFINE l_ruv04   LIKE ruv_file.ruv04   #TQC-C90064 
 
        LET g_action_choice=""
        IF s_shut(0) THEN 
                RETURN
        END IF
        
        IF g_ruu.ruu01 IS NULL THEN
                RETURN 
        END IF
        
        IF g_ruu.ruuconf = 'Y' THEN
           CALL cl_err('','art-024',0)
           RETURN
        END IF
        IF g_ruu.ruuconf = 'X' THEN                                                                                             
           CALL cl_err('','art-025',0)                                                                                          
           RETURN                                                                                                               
        END IF
        
        SELECT * INTO g_ruu.* FROM ruu_file
           WHERE ruu01=g_ruu.ruu01
        
        IF g_ruu.ruuacti='N' THEN 
           CALL cl_err(g_ruu.ruu01,'mfg1000',0)
           RETURN 
        END IF
        
        CALL cl_opmsg('b')
        
        SELECT rtz04 INTO l_rtz04 FROM rtz_file WHERE rtz01=g_ruu.ruuplant                                     
        
        LET g_forupd_sql="SELECT ruv02,ruv03,ruv04,'',ruv05,'',ruv06,ruv07,ruv08,ruv09,ruv10",
                        " FROM ruv_file",
                        " WHERE ruv01=? AND ruv02=? ",
                        " FOR UPDATE "
        LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
        DECLARE t211_bcl CURSOR FROM g_forupd_sql
        LET l_allow_insert=cl_detail_input_auth("insert")
        LET l_allow_delete=cl_detail_input_auth("delete")
        INPUT ARRAY g_ruv WITHOUT DEFAULTS FROM s_ruv.*
                ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                        APPEND ROW= l_allow_insert)
        BEFORE INPUT
                IF g_rec_b !=0 THEN 
                   CALL fgl_set_arr_curr(l_ac)
                END IF
        BEFORE ROW
                LET p_cmd =''
                LET l_ac =ARR_CURR()
                LET l_lock_sw ='N'
                LET l_n =ARR_COUNT()
 
                BEGIN WORK 
                OPEN t211_cl USING g_ruu.ruu01
                IF STATUS THEN
                   CALL cl_err("OPEN t211_cl:",STATUS,1)
                   CLOSE t211_cl
                   ROLLBACK WORK
                END IF
 
                FETCH t211_cl INTO g_ruu.*
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_ruu.ruu01,SQLCA.sqlcode,0)
                   CLOSE t211_cl
                   ROLLBACK WORK 
                   RETURN
                END IF
                IF g_rec_b>=l_ac THEN 
                   LET p_cmd ='u'
                   LET g_ruv_t.*=g_ruv[l_ac].*
                   LET g_ruv_o.*=g_ruv[l_ac].*
                   LET g_ruv05_t=g_ruv[l_ac].ruv05     #FUN-BB0085
                   OPEN t211_bcl USING g_ruu.ruu01,g_ruv_t.ruv02
                   IF STATUS THEN
                      CALL cl_err("OPEN t211_bcl:",STATUS,1)
                      LET l_lock_sw='Y'
                   ELSE
                      FETCH t211_bcl INTO g_ruv[l_ac].*
                      IF SQLCA.sqlcode THEN
                         CALL cl_err(g_ruv_t.ruv03,SQLCA.sqlcode,1)
                         LET l_lock_sw="Y"
                      END IF
                      CALL t211_ruv04()
                   END IF
                   CALL t211_set_entry_b(p_cmd)
                   CALL t211_set_no_entry_b(p_cmd)
                END IF
       BEFORE INSERT
                LET l_n=ARR_COUNT()
                LET p_cmd='a'
                INITIALIZE g_ruv[l_ac].* TO NULL
                LET g_ruv_t.*=g_ruv[l_ac].*
                LET g_ruv_o.*=g_ruv[l_ac].*
                LET g_ruv05_t=NULL                  #FUN-BB0085
                CALL cl_show_fld_cont()
                CALL t211_set_entry_b(p_cmd)
                CALL t211_set_no_entry_b(p_cmd)
                NEXT FIELD ruv02
       AFTER INSERT
                IF INT_FLAG THEN
                        CALL cl_err('',9001,0)
                        LET INT_FLAG=0
                        CANCEL INSERT
                END IF
                INSERT INTO ruv_file(ruv01,ruv02,ruv03,ruv04,ruv05,ruv06,ruv07,ruv08,ruv09,ruv10,ruvplant,ruvlegal)
                VALUES(g_ruu.ruu01,g_ruv[l_ac].ruv02,g_ruv[l_ac].ruv03,g_ruv[l_ac].ruv04,g_ruv[l_ac].ruv05,
                g_ruv[l_ac].ruv06,g_ruv[l_ac].ruv07,g_ruv[l_ac].ruv08,g_ruv[l_ac].ruv09,g_ruv[l_ac].ruv10,
                g_ruu.ruuplant,g_ruu.ruulegal)
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("ins","ruv_file",g_ruu.ruu01,g_ruv[l_ac].ruv02,SQLCA.sqlcode,"","",1)
                   CANCEL INSERT
                ELSE
                   MESSAGE 'INSERT Ok'
                   COMMIT WORK
                   LET g_rec_b=g_rec_b+1
                END IF
                
      BEFORE FIELD ruv02
        IF cl_null(g_ruv[l_ac].ruv02) OR g_ruv[l_ac].ruv02=0 THEN 
           SELECT max(ruv02)+1 INTO g_ruv[l_ac].ruv02 FROM ruv_file
              WHERE ruv01=g_ruu.ruu01 
              IF g_ruv[l_ac].ruv02 IS NULL THEN
                 LET g_ruv[l_ac].ruv02=1
              END IF
         END IF
      AFTER FIELD ruv02
        IF NOT cl_null(g_ruv[l_ac].ruv02) THEN 
           IF g_ruv[l_ac].ruv02!=g_ruv_t.ruv02
              OR g_ruv_t.ruv02 IS NULL THEN
              SELECT count(*) INTO l_n FROM ruv_file
                  WHERE ruv01= g_ruu.ruu01 AND ruv02=g_ruv[l_ac].ruv02 
              IF l_n>0 THEN
                 CALL cl_err('',-239,0)
                 LET g_ruv[l_ac].ruv02=g_ruv_t.ruv02
                 DISPLAY BY NAME g_ruv[l_ac].ruv02
                 NEXT FIELD ruv02
              END IF
          END IF
        END IF
         
#TQC-B20084 ADD-BEGIN---
      AFTER FIELD ruv03
         IF NOT cl_null(g_ruv[l_ac].ruv04) THEN
            IF g_ruv_o.ruv03 IS NULL OR g_ruv[l_ac].ruv03 != g_ruv_o.ruv03 THEN
               SELECT COUNT(*) INTO l_n FROM ruv_file 
                WHERE ruv01 = g_ruu.ruu01 
                  AND ruv03 = g_ruv[l_ac].ruv03
                  AND ruv04 = g_ruv[l_ac].ruv04
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  NEXT FIELD ruv03
               END IF
            END IF
         END IF
#TQC-B20084 ADD-END-----

      AFTER FIELD ruv04
         IF NOT cl_null(g_ruv[l_ac].ruv04) THEN

#TQC-B80036 --BEGIN--
              SELECT rus12,rus13 INTO l_rus12,l_rus13 FROM rus_file
               WHERE rus01 = g_ruu.ruu02
              IF l_rus12 = 'Y' THEN
              #TQC-C90064 add str---
                 LET tok = base.StringTokenizer.create(l_rus13,"|")
                 LET l_ruv04 = ''
                 LET l_i = 0
                 WHILE tok.hasMoreTokens()
                    LET l_ruv04 = tok.nextToken()
                     IF l_ruv04 = g_ruv[l_ac].ruv04 THEN
                        LET l_i = l_i + 1
                     END IF
                 END WHILE
                 IF l_i = 0 THEN
                    CALL cl_err('','ruv-001',0)
                    NEXT FIELD CURRENT
                 END IF
              END IF
              #TQC-C90064 add end---
              #TQC-C90064 mark str---
            #    IF l_rus13 <> g_ruv[l_ac].ruv04 THEN
            #       CALL cl_err('','art-135',0)
            #       NEXT FIELD CURRENT
            #    END IF
            # END IF
              #TQC-C90064 mark end---
#TQC-B80036 --END--

#FUN-AA0059 ---------------------start----------------------------
            IF NOT s_chk_item_no(g_ruv[l_ac].ruv04,"") THEN
               CALL cl_err('',g_errno,1)
               LET g_ruv[l_ac].ruv04= g_ruv_t.ruv04
               NEXT FIELD ruv04
            END IF
#FUN-AA0059 ---------------------end-------------------------------
           #FUN-B40062 Begin---
            IF s_joint_venture(g_ruv[l_ac].ruv04,'') OR NOT s_internal_item(g_ruv[l_ac].ruv04,'') THEN
               LET g_ruv[l_ac].ruv04= g_ruv_t.ruv04
               NEXT FIELD ruv04
            END IF
           #FUN-B40062 End-----
            IF g_ruv_o.ruv04 IS NULL OR
               (g_ruv[l_ac].ruv04 != g_ruv_o.ruv04 ) THEN
            #  SELECT COUNT(*) INTO l_n FROM ruv_file WHERE ruv01 = g_ruu.ruu01 AND ruv04 = g_ruv[l_ac].ruv04  #TQC-B20084 MARK
            #TQC-B20084 ADD-BEGIN---
               SELECT COUNT(*) INTO l_n FROM ruv_file 
                WHERE ruv01 = g_ruu.ruu01 
                  AND ruv03 = g_ruv[l_ac].ruv03
                  AND ruv04 = g_ruv[l_ac].ruv04
            #TQC-B20084 ADD-END-----
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  NEXT FIELD ruv04
               END IF
               CALL t211_ruv04()          
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_ruv[l_ac].ruv04,g_errno,0)
                  LET g_ruv[l_ac].ruv04 = g_ruv_o.ruv04
                  DISPLAY BY NAME g_ruv[l_ac].ruv04
                  NEXT FIELD ruv04
               END IF
               IF NOT cl_null(l_rtz04) THEN
                  SELECT COUNT(*) INTO l_n FROM rte_file 
                     WHERE rte01 = l_rtz04 AND rte03 = g_ruv[l_ac].ruv04
                  IF l_n = 0 OR l_n IS NULL THEN
                     CALL cl_err('','art-389',0)
                     NEXT FIELD ruv04
                  END IF
               END IF
               #FUN-BB0085-add-str--
               LET l_case = '' 
               IF NOT t211_ruv09_check() THEN LET l_case = 'rvu09' END IF
               IF NOT t211_ruv08_check() THEN LET l_case = 'rvu08' END IF
               IF NOT t211_ruv07_check() THEN LET l_case = 'rvu07' END IF
               IF NOT t211_ruv06_check() THEN LET l_case = 'rvu06' END IF
               LET g_ruv05_t = g_ruv[l_ac].ruv05
               CASE l_case
                  WHEN 'ruv06'  NEXT FIELD ruv06
                  WHEN 'ruv07'  NEXT FIELD ruv07
                  WHEN 'ruv08'  NEXT FIELD ruv08
                  WHEN 'ruv09'  NEXT FIELD ruv09
               END CASE
               #FUN-BB0085-add-end--
            END IF
         END IF
 
       AFTER FIELD ruv06
          IF NOT t211_ruv06_check() THEN NEXT FIELD ruv06 END IF   #FUN-BB0085
          #FUN-BB0085-mark-str--
          #IF g_ruv[l_ac].ruv06 < 0 THEN
          #   CALL cl_err('','art-184',0)
          #   NEXT FIELD ruv06
          #END IF
          #FUN-BB0085-mark-end--
       
       AFTER FIELD ruv07
          IF NOT t211_ruv07_check() THEN NEXT FIELD ruv07 END IF   #FUN-BB0085
          #FUN-BB0085-mark-str--
          #IF g_ruv[l_ac].ruv07 < 0 THEN
          #   CALL cl_err('','art-184',0)
          #   NEXT FIELD ruv07
          #END IF
          #FUN-BB0085-mark-end--
       
       AFTER FIELD ruv08
          IF NOT t211_ruv08_check() THEN NEXT FIELD ruv08 END IF   #FUN-BB0085
          #FUN-BB0085-mark-str--
          #IF g_ruv[l_ac].ruv08 < 0 THEN
          #   CALL cl_err('','art-184',0)
          #   NEXT FIELD ruv08
          #END IF
          #FUN-BB0085-mark-end--
       
       AFTER FIELD ruv09
          IF NOT t211_ruv09_check() THEN NEXT FIELD ruv09 END IF   #FUN-BB0085
          #FUN-BB0085-mark-str--
          #IF g_ruv[l_ac].ruv09 < 0 THEN
          #   CALL cl_err('','art-184',0)
          #   NEXT FIELD ruv09
          #END IF
          #FUN-BB0085-mark-end--
 
       BEFORE DELETE
           DISPLAY "BEFORE DELETE"
           IF g_ruv_t.ruv02 > 0 AND g_ruv_t.ruv02 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM ruv_file
               WHERE ruv01 = g_ruu.ruu01
                 AND ruv02 = g_ruv_t.ruv02
              IF SQLCA.sqlcode THEN   
                 CALL cl_err3("del","ruv_file",g_ruu.ruu01,g_ruv_t.ruv02,SQLCA.sqlcode,"","",1)  
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b=g_rec_b-1
           END IF
           COMMIT WORK
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_ruv[l_ac].* = g_ruv_t.*
              CLOSE t211_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_ruv[l_ac].ruv02,-263,1)
              LET g_ruv[l_ac].* = g_ruv_t.*
           ELSE
             
              UPDATE ruv_file SET ruv02=g_ruv[l_ac].ruv02,
                                  ruv03=g_ruv[l_ac].ruv03,
                                  ruv04=g_ruv[l_ac].ruv04,
                                  ruv05=g_ruv[l_ac].ruv05,
                                  ruv06=g_ruv[l_ac].ruv06,
                                  ruv07=g_ruv[l_ac].ruv07,
                                  ruv08=g_ruv[l_ac].ruv08,
                                  ruv09=g_ruv[l_ac].ruv09,
                                  ruv10=g_ruv[l_ac].ruv10
                 WHERE ruv01=g_ruu.ruu01
                   AND ruv02=g_ruv_t.ruv02
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","ruv_file",g_ruu.ruu01,g_ruv_t.ruv02,SQLCA.sqlcode,"","",1) 
                 LET g_ruv[l_ac].* = g_ruv_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
           DISPLAY  "AFTER ROW!!"
           LET l_ac = ARR_CURR()
        #  LET l_ac_t = l_ac   #FUN-D30033 mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_ruv[l_ac].* = g_ruv_t.*
            #FUN-D30033--add--str--
              ELSE
                 CALL g_ruv.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
            #FUN-D30033--add--end--
              END IF
              CLOSE t211_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac   #FUN-D30033 add
           CLOSE t211_bcl
           COMMIT WORK
      ON ACTION CONTROLO                        
           IF INFIELD(ruv02) AND l_ac > 1 THEN
              LET g_ruv[l_ac].* = g_ruv[l_ac-1].*
              LET g_ruv[l_ac].ruv02 = g_rec_b + 1
              NEXT FIELD ruv02
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION controlp                         
          CASE
            WHEN INFIELD(ruv04)
#                CALL cl_init_qry_var()   #FUN-AB0025 mark
                 IF cl_null(l_rtz04) THEN
#FUN-AB0025------mod----------str----------------------------
#                    LET g_qryparam.form = "q_ima"
                   #TQC-C90123 Add Begin ---
                    SELECT rus07,rus09,rus11,rus13
                      INTO l_rus07,l_rus09,l_rus11,l_rus13
                      FROM rus_file
                      WHERE rus01 = g_ruu.ruu02
                    CALL t211_get_shop(l_rus07,l_rus09,l_rus11,l_rus13) RETURNING l_flag
                    IF l_flag = 0 THEN
                       LET l_sql = "1=0"
                    ELSE
                      LET l_sql = " ima01 IN ('"
                      FOR l_i = 1 TO g_result.getLength()
                          LET l_sql = l_sql,g_result[l_i],"','"
                      END FOR
                      LET l_temp = l_sql
                      LET l_sql = l_temp.subString(1,l_sql.getLength()-2)
                      LET l_sql = l_sql,")"
                    END IF
                   #TQC-C90123 Add End -----
                     CALL q_sel_ima(FALSE, "q_ima",l_sql,g_ruv[l_ac].ruv04,"","","","","",'' ) #TQC-C90123 Mod 
                        RETURNING g_ruv[l_ac].ruv04
#FUN-AB0025------mod----------end---------------------------
                 ELSE
               	    SELECT rus07,rus09,rus11,rus13 
                      INTO l_rus07,l_rus09,l_rus11,l_rus13
                      FROM rus_file 
                      WHERE rus01 = g_ruu.ruu02  
                    CALL t211_get_shop(l_rus07,l_rus09,l_rus11,l_rus13)
                       RETURNING l_flag
                      
                    IF l_flag = 0 THEN
                       CALL cl_init_qry_var()          #FUN-AB0025 add 
                       LET g_qryparam.form = "q_rte03"
                       LET g_qryparam.arg1 = l_rtz04
                       LET g_qryparam.default1 = g_ruv[l_ac].ruv04
                       CALL cl_create_qry() RETURNING g_ruv[l_ac].ruv04
                    ELSE
##FUN-AB0025------mod----------str----------------------------
#                    	 LET g_qryparam.where = " ima01 IN ('"
#                    	 FOR l_i = 1 TO g_result.getLength()
#                    	     LET g_qryparam.where = g_qryparam.where,g_result[l_i],"','"
#                    	 END FOR
#                       LET l_temp = g_qryparam.where
#                    	 LET g_qryparam.where = l_temp[1,g_qryparam.where.getLength()-2]
#                    	 LET g_qryparam.where = g_qryparam.where,")"
#                    	 LET g_qryparam.form = "q_ima" 
#                         LET g_qryparam.where = g_qryparam.where," AND ima01 IN (SELECT ",
#                                                " rte03 FROM rte_file WHERE rte01='",l_rtz04,"') "
                      LET l_sql = " ima01 IN ('"  
                      FOR l_i = 1 TO g_result.getLength()
                          LET l_sql = l_sql,g_result[l_i],"','"
                      END FOR
                      LET l_temp = l_sql
                     #LET l_sql = l_temp[1,l_sql.getLength()-2]           #TQC-C90123 Mark
                      LET l_sql = l_temp.subString(1,l_sql.getLength()-2) #TQC-C90123 Add
                      LET l_sql = l_sql,")" 
                      LET l_sql = l_sql, " AND ima01 IN (SELECT ",
                                         " rte03 FROM rte_file WHERE rte01='",l_rtz04,"') "   
                      CALL q_sel_ima(FALSE, "q_ima",l_sql,g_ruv[l_ac].ruv04,"","","","","",'' ) 
                          RETURNING  g_ruv[l_ac].ruv04        
#FUN-AB0025------mod----------end---------------------------         
                   END IF
                 END IF
#                LET g_qryparam.default1 = g_ruv[l_ac].ruv04      #FUN-AB0025 mark
#                CALL cl_create_qry() RETURNING g_ruv[l_ac].ruv04 #FUN-AB0025 mark
                 DISPLAY BY NAME g_ruv[l_ac].ruv04
                 CALL t211_ruv04()
               NEXT FIELD ruv04
            OTHERWISE EXIT CASE
          END CASE
 
        ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about       
           CALL cl_about()     
 
        ON ACTION help          
           CALL cl_show_help()  
 
        ON ACTION controls                    
           CALL cl_set_head_visible("","AUTO")  
    END INPUT
 
    LET g_ruu.ruumodu = g_user
    LET g_ruu.ruudate = g_today
    UPDATE ruu_file SET ruumodu = g_ruu.ruumodu,ruudate = g_ruu.ruudate
       WHERE ruu01 = g_ruu.ruu01 
    DISPLAY BY NAME g_ruu.ruumodu,g_ruu.ruudate
 
    CLOSE t211_bcl
    COMMIT WORK
#   CALL t211_delall() #CHI-C30002 mark
    CALL t211_delHeader()     #CHI-C30002 add
    CALL t211_show()
END FUNCTION                 
 
#CHI-C30002 -------- add -------- begin
FUNCTION t211_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_ruu.ruu01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM ruu_file ",
                  "  WHERE ruu01 LIKE '",l_slip,"%' ",
                  "    AND ruu01 > '",g_ruu.ruu01,"'"
      PREPARE t211_pb1 FROM l_sql 
      EXECUTE t211_pb1 INTO l_cnt
      
      LET l_action_choice = g_action_choice
      LET g_action_choice = 'delete'
      IF cl_chk_act_auth() AND l_cnt = 0 THEN
         CALL cl_getmsg('aec-130',g_lang) RETURNING g_msg
         LET l_num = 3
      ELSE
         CALL cl_getmsg('aec-131',g_lang) RETURNING g_msg
         LET l_num = 2
      END IF 
      LET g_action_choice = l_action_choice
      PROMPT g_msg CLIPPED,': ' FOR l_cho
         ON IDLE g_idle_seconds
            CALL cl_on_idle()

         ON ACTION about     
            CALL cl_about()

         ON ACTION help         
            CALL cl_show_help()

         ON ACTION controlg   
            CALL cl_cmdask() 
      END PROMPT
      IF l_cho > l_num THEN LET l_cho = 1 END IF 
      IF l_cho = 2 THEN 
         CALL t211_void(1)
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM ruu_file WHERE ruu01 = g_ruu.ruu01
         INITIALIZE g_ruu.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#CHI-C30002 -------- mark -------- begin
#FUNCTION t211_delall()
#
#  SELECT COUNT(*) INTO g_cnt FROM ruv_file
#   WHERE ruv01 = g_ruu.ruu01
#
#  IF g_cnt = 0 THEN                  
#     CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#     ERROR g_msg CLIPPED
#     DELETE FROM ruu_file WHERE ruu01 = g_ruu.ruu01
#  END IF
#
#END FUNCTION
#CHI-C30002 -------- mark -------- end
 
FUNCTION t211_set_entry_b(p_cmd)
DEFINE p_cmd LIKE type_file.chr1
        
   CALL cl_set_comp_entry("ruv02,ruv03,ruv04,ruv06,ruv07,ruv08,ruv09,ruv10",TRUE)  
END FUNCTION
 
FUNCTION t211_set_no_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    
 
    IF INFIELD(ruv03) THEN
       IF g_ruv[l_ac].ruv03[1,4] <> 'MISC' THEN
          CALL cl_set_comp_entry("gen02",FALSE)
       END IF
    END IF
END FUNCTION                  
                                
FUNCTION t211_u()
DEFINE l_n        LIKE type_file.num5
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_ruu.ruu01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   IF g_ruu.ruuconf = 'Y' THEN
      CALL  cl_err('','art-383',0)
      RETURN
   END IF
 
   IF g_ruu.ruuconf = 'X' THEN
      CALL  cl_err('','art-382',0)
      RETURN
   END IF
 
   SELECT COUNT(*) INTO l_n FROM ruw_file WHERE ruw02=g_ruu.ruu02 
   IF l_n>0 THEN
      CALL cl_err('','art-401',0)
      RETURN
   END IF
 
   SELECT * INTO g_ruu.* FROM ruu_file
    WHERE ruu01=g_ruu.ruu01 
 
   IF g_ruu.ruuacti ='N' THEN    
      CALL cl_err(g_ruu.ruu01,'mfg1000',0)
      RETURN
   END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_ruu01_t = g_ruu.ruu01
   BEGIN WORK
 
   OPEN t211_cl USING g_ruu.ruu01
   IF STATUS THEN
      CALL cl_err("OPEN t211_cl:", STATUS, 1)
      CLOSE t211_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t211_cl INTO g_ruu.*                      
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_ruu.ruu01,SQLCA.sqlcode,0)    
       CLOSE t211_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   CALL t211_show()
 
   WHILE TRUE
      LET g_ruu01_t = g_ruu.ruu01
      LET g_ruu_o.* = g_ruu.*
      LET g_ruu.ruumodu=g_user
      LET g_ruu.ruudate=g_today
 
      CALL t211_i("u")                            
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_ruu.*=g_ruu_t.*
         CALL t211_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      IF g_ruu.ruu01 != g_ruu01_t THEN            
         UPDATE ruv_file SET ruv01 = g_ruu.ruu01,ruv02=g_ruv[l_ac].ruv02,ruv03=g_ruv[l_ac].ruv03,ruv04=g_ruv[l_ac].ruv04,
                             ruv05=g_ruv[l_ac].ruv05,ruv06=g_ruv[l_ac].ruv06,ruv07=g_ruv[l_ac].ruv07,ruv08=g_ruv[l_ac].ruv08,
                             ruv09=g_ruv[l_ac].ruv09,ruv10=g_ruv[l_ac].ruv10,ruvplant=g_ruu.ruuplant
          WHERE ruv01 = g_ruu01_t AND ruv02=g_ruv_t.ruv02
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","ruv_file",g_ruu01_t,"",SQLCA.sqlcode,"","ruv",1)  
            CONTINUE WHILE
         END IF
      END IF
 
      UPDATE ruu_file SET ruu_file.* = g_ruu.*
       WHERE ruu01=g_ruu.ruu01
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","ruu_file","","",SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
   IF g_ruu.ruuconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   CALL cl_set_field_pic(g_ruu.ruuconf,"","","",g_chr,"")
   CLOSE t211_cl
   COMMIT WORK
   CALL t211_show()
   CALL cl_flow_notify(g_ruu.ruu01,'U')
 
   CALL t211_b_fill("1=1")
   CALL t211_bp_refresh()
 
END FUNCTION          
                
FUNCTION t211_r()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_ruu.ruu01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   IF g_ruu.ruuconf = 'Y' THEN
      CALL  cl_err('','art-383',0)
      RETURN
   END IF
 
   IF g_ruu.ruuconf = 'X' THEN
      CALL  cl_err('','art-382',0)
      RETURN
   END IF
 
   SELECT * INTO g_ruu.* FROM ruu_file
    WHERE ruu01=g_ruu.ruu01
   IF g_ruu.ruuacti ='N' THEN    
      CALL cl_err(g_ruu.ruu01,'mfg1000',0)
      RETURN
   END IF
   BEGIN WORK
 
   OPEN t211_cl USING g_ruu.ruu01
   IF STATUS THEN
      CALL cl_err("OPEN t211_cl:", STATUS, 1)
      CLOSE t211_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t211_cl INTO g_ruu.*               
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ruu.ruu01,SQLCA.sqlcode,0)         
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL t211_show()
 
   IF cl_delh(0,0) THEN                   
      DELETE FROM ruu_file WHERE ruu01 = g_ruu.ruu01 
      DELETE FROM ruv_file WHERE ruv01 = g_ruu.ruu01 
      CLEAR FORM
      CALL g_ruv.clear()
      OPEN t211_count
      #FUN-B50064-add-start--
      IF STATUS THEN
         CLOSE t211_cs
         CLOSE t211_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end--
      FETCH t211_count INTO g_row_count
      #FUN-B50064-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE t211_cs
         CLOSE t211_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end--
      DISPLAY g_row_count TO FORMONLY.cn2
      OPEN t211_cs
      IF g_row_count >0 THEN
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL t211_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE      
            CALL t211_fetch('/')
         END IF
      END IF
   END IF
 
   CLOSE t211_cl
   COMMIT WORK
   CALL cl_flow_notify(g_ruu.ruu01,'D')
END FUNCTION
 
FUNCTION t211_copy()
   DEFINE l_newno     LIKE ruu_file.ruu01,
          l_oldno     LIKE ruu_file.ruu01,
          l_cnt       LIKE type_file.num5 
   DEFINE li_result   LIKE type_file.num5
 # DEFINE g_t1        LIKE type_file.chr3       #FUN-AA0046   mark
   DEFINE g_t1        LIKE type_file.chr30       #FUN-AA0046
 
   IF s_shut(0) THEN RETURN END IF
 
   IF g_ruu.ruu01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   LET g_before_input_done = FALSE
   CALL t211_set_entry('a')
 
   CALL cl_set_head_visible("","YES")
   INPUT l_newno FROM ruu01
       BEFORE INPUT 
           CALL cl_set_docno_format("ruu01")
 
       AFTER FIELD ruu01
          IF l_newno IS NULL THEN                                                                                                  
              NEXT FIELD ruu01                                                                                                      
           ELSE                                                                                                                    
#             CALL s_check_no("art",l_newno,"","I","ruu_file","ruu01","")  #FUN-A70130 mark                                                         
              CALL s_check_no("art",l_newno,"","E1","ruu_file","ruu01","")  #FUN-A70130 mod                                                         
                 RETURNING li_result,l_newno
              IF (NOT li_result) THEN                                                                                               
                 LET g_ruu.ruu01=g_ruu_t.ruu01                                                                                      
                 NEXT FIELD ruu01                                                                                                   
              END IF                                                                                                                
              BEGIN WORK                                                                                                            
#             CALL s_auto_assign_no("art",l_newno,g_today,"","ruu_file","ruu01","","","")   #FUN-A70130 mark                                        
              CALL s_auto_assign_no("art",l_newno,g_today,"E1","ruu_file","ruu01","","","")   #FUN-A70130 mod                                        
                 RETURNING li_result,l_newno                                                                                        
              IF (NOT li_result) THEN                                                                                               
                 ROLLBACK WORK                                                                                                      
                 NEXT FIELD ruu01                                                                                                   
              ELSE                                                                                                                  
                 COMMIT WORK                                                                                                        
              END IF                                                                                                                
           END IF
 
       ON ACTION controlp
          CASE
             WHEN INFIELD(ruu01)
                LET g_t1=s_get_doc_no(g_ruu.ruu01)
#               CALL q_smy(FALSE,FALSE,g_t1,'ART','I') RETURNING g_t1                #FUN-A70130--mark--
                CALL q_oay(FALSE,FALSE,g_t1,'E1','ART') RETURNING g_t1               #羲敦  #FUN-A70130--add--
                LET l_newno = g_t1
                DISPLAY l_newno TO ruu01
             NEXT FIELD ruu01
             OTHERWISE EXIT CASE
          END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
     ON ACTION about
        CALL cl_about()
 
     ON ACTION HELP
        CALL cl_show_help()
 
     ON ACTION controlg
        CALL cl_cmdask()
 
   END INPUT
 
   BEGIN WORK
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY BY NAME g_ruu.ruu01
   
      ROLLBACK WORK
  
      RETURN
   END IF
 
   DROP TABLE y
 
   SELECT * FROM ruu_file         
       WHERE ruu01=g_ruu.ruu01 
       INTO TEMP y
 
   UPDATE y
       SET ruu01=l_newno,    
           ruuuser=g_user,   
           ruugrup=g_grup,   
           ruuoriu=g_user,     #TQC-A30041 ADD
           ruuorig=g_grup,     #TQC-A30041 ADD
           ruumodu=NULL,     
           ruucrat=g_today,  
           ruuacti='Y',
           ruuconf = 'N',
           ruucond = NULL,
           ruuconu = NULL,
           ruuplant = g_plant,
           ruulegal = g_legal
   INSERT INTO ruu_file SELECT * FROM y
   
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","ruu_file","","",SQLCA.sqlcode,"","",1) 
      ROLLBACK WORK
      RETURN
   ELSE
  
   DROP TABLE x
 
   SELECT * FROM ruv_file         
       WHERE ruv01=g_ruu.ruu01 
       INTO TEMP x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1) 
      RETURN
   END IF
 
   UPDATE x SET ruv01=l_newno,ruvplant=g_plant,ruvlegal=g_legal
 
   INSERT INTO ruv_file
       SELECT * FROM x
   IF SQLCA.sqlcode THEN
#     ROLLBACK WORK           #TQC-B80036
      CALL cl_err3("ins","ruv_file","","",SQLCA.sqlcode,"","",1)
      ROLLBACK WORK           #TQC-B80036
      RETURN
   ELSE
       COMMIT WORK 
   END IF
   END IF
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
   LET l_oldno = g_ruu.ruu01
   SELECT ruu_file.* INTO g_ruu.* FROM ruu_file WHERE ruu01 = l_newno 
   CALL t211_u()
   CALL t211_b()
   #SELECT ruu_file.* INTO g_ruu.* FROM ruu_file WHERE ruu01 = l_oldno  #FUN-C80046
   #CALL t211_show()  #FUN-C80046
 
END FUNCTION
FUNCTION t211_x()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_ruu.ruu01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   IF g_ruu.ruuconf = 'Y' THEN
      CALL  cl_err('','art-383',0)
      RETURN
   END IF
 
   IF g_ruu.ruuconf = 'X' THEN
      CALL  cl_err('','art-382',0)
      RETURN
   END IF
 
   BEGIN WORK
 
   OPEN t211_cl USING g_ruu.ruu01
   IF STATUS THEN
      CALL cl_err("OPEN t211_cl:", STATUS, 1)
      CLOSE t211_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t211_cl INTO g_ruu.*               
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ruu.ruu01,SQLCA.sqlcode,0)          
      ROLLBACK WORK
      RETURN
   END IF
 
   LET g_success = 'Y'
 
   CALL t211_show()
 
   IF cl_exp(0,0,g_ruu.ruuacti) THEN                   
      LET g_chr=g_ruu.ruuacti
      IF g_ruu.ruuacti='Y' THEN
         LET g_ruu.ruuacti='N'
      ELSE
         LET g_ruu.ruuacti='Y'
      END IF
 
      UPDATE ruu_file SET ruuacti=g_ruu.ruuacti,
                          ruumodu=g_user,
                          ruudate=g_today
       WHERE ruu01=g_ruu.ruu01 
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","ruu_file",g_ruu.ruu01,"",SQLCA.sqlcode,"","",1)  
         LET g_ruu.ruuacti=g_chr
      END IF
   END IF
 
   CLOSE t211_cl
 
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_ruu.ruu01,'V')
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT ruuacti,ruumodu,ruudate
     INTO g_ruu.ruuacti,g_ruu.ruumodu,g_ruu.ruudate FROM ruu_file
    WHERE ruu01=g_ruu.ruu01 
   DISPLAY BY NAME g_ruu.ruuacti,g_ruu.ruumodu,g_ruu.ruudate
 
END FUNCTION
 
FUNCTION t211_bp_refresh()
  DISPLAY ARRAY g_ruv TO s_ruv.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
  CALL t211_show()
END FUNCTION
 
FUNCTION t211_out()
#p_query
DEFINE l_cmd  STRING
#No.TQC-B60170   ---start---
    IF g_wc IS NULL AND g_ruu.ruu01 IS NOT NULL THEN
       LET g_wc = " ruu01='",g_ruu.ruu01,"'"
    END IF
    IF cl_null(g_wc2) THEN
       LET g_wc2 = ' 1=1'
    END IF
#No.TQC-B60170  ---end--- 
    IF cl_null(g_wc) THEN
       CALL cl_err('','9057',0) RETURN
    END IF
 #   LET l_cmd = 'p_query "artt211" "',g_wc CLIPPED,'"'      #TQC-AB0288  mark
    LET l_cmd = 'p_query "artt211" "',g_wc CLIPPED,'" "',g_wc2 CLIPPED,'"'       #TQC-AB0288
    CALL cl_cmdrun(l_cmd) 
 
END FUNCTION

#FUN-BB0085----add----str----
FUNCTION t211_ruv06_check()
   IF NOT cl_null(g_ruv[l_ac].ruv06) AND NOT cl_null(g_ruv[l_ac].ruv05) THEN 
      IF cl_null(g_ruv05_t) OR g_ruv05_t != g_ruv[l_ac].ruv05 OR
         cl_null(g_ruv_t.ruv06) OR g_ruv_t.ruv06 != g_ruv[l_ac].ruv06 THEN 
         LET g_ruv[l_ac].ruv06 = s_digqty(g_ruv[l_ac].ruv06,g_ruv[l_ac].ruv05)
         DISPLAY BY NAME g_ruv[l_ac].ruv06
      END IF
   END IF
   IF g_ruv[l_ac].ruv06 < 0 THEN
      CALL cl_err('','art-184',0)
      RETURN FALSE    
   END IF
  RETURN TRUE
END FUNCTION
FUNCTION t211_ruv07_check()
   IF NOT cl_null(g_ruv[l_ac].ruv07) AND NOT cl_null(g_ruv[l_ac].ruv05) THEN 
      IF cl_null(g_ruv05_t) OR g_ruv05_t != g_ruv[l_ac].ruv05 OR
         cl_null(g_ruv_t.ruv07) OR g_ruv_t.ruv07 != g_ruv[l_ac].ruv07 THEN 
         LET g_ruv[l_ac].ruv07 = s_digqty(g_ruv[l_ac].ruv07,g_ruv[l_ac].ruv05)
         DISPLAY BY NAME g_ruv[l_ac].ruv07
      END IF
   END IF
   IF g_ruv[l_ac].ruv07 < 0 THEN
      CALL cl_err('','art-184',0)
      RETURN FALSE    
   END IF
   RETURN TRUE
END FUNCTION
FUNCTION t211_ruv08_check()
   IF NOT cl_null(g_ruv[l_ac].ruv08) AND NOT cl_null(g_ruv[l_ac].ruv05) THEN 
      IF cl_null(g_ruv05_t) OR g_ruv05_t != g_ruv[l_ac].ruv05 OR
         cl_null(g_ruv_t.ruv08) OR g_ruv_t.ruv08 != g_ruv[l_ac].ruv08 THEN 
         LET g_ruv[l_ac].ruv08 = s_digqty(g_ruv[l_ac].ruv08,g_ruv[l_ac].ruv05)
         DISPLAY BY NAME g_ruv[l_ac].ruv08
      END IF
   END IF
   IF g_ruv[l_ac].ruv08 < 0 THEN
      CALL cl_err('','art-184',0)
      RETURN FALSE    
   END IF
   RETURN TRUE
END FUNCTION
FUNCTION t211_ruv09_check()
   IF NOT cl_null(g_ruv[l_ac].ruv09) AND NOT cl_null(g_ruv[l_ac].ruv05) THEN 
      IF cl_null(g_ruv05_t) OR g_ruv05_t != g_ruv[l_ac].ruv05 OR
         cl_null(g_ruv_t.ruv09) OR g_ruv_t.ruv09 != g_ruv[l_ac].ruv09 THEN 
         LET g_ruv[l_ac].ruv09 = s_digqty(g_ruv[l_ac].ruv09,g_ruv[l_ac].ruv05)
         DISPLAY BY NAME g_ruv[l_ac].ruv09
      END IF
   END IF
   IF g_ruv[l_ac].ruv09 < 0 THEN
      CALL cl_err('','art-184',0)
      RETURN FALSE  
   END IF
   RETURN TRUE
END FUNCTION
#FUN-BB0085----add----end----
#FUN-960130

