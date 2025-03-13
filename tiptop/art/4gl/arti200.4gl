# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: arti200.4gl
# Descriptions...: 員工資料維護作業
# Date & Author..: 10/09/01 By shaoyong
# Modify.........: NO:FUN-A80148 10/10/09 By chenying
# Modify.........: NO:FUN-AA0054 10/10/21 By shiwuying 同步到32区
# Modify.........: No.FUN-AA0062 10/11/02 By yinhy 倉庫權限使用控管修改
# Modify.........: No.FUN-A80117 10/11/08 By huangtao 用ON CHANGE 代替AFTER FIELD 控管
# Modify.........: No.FUN-AB0078 10/11/17 By houlia 倉庫營運中心權限控管審核段控管
# Modify.........: No.FUN-AC0022 10/12/08 By suncx1 修改后按上下筆回到修改的哪一筆，還是顯示舊值
# Modify.........: No.TQC-AC0114 10/12/09 By destiny倉庫營運中心權限控管審核段控管
# Modify.........: No:FUN-B30211 11/03/30 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:FUN-B40032 11/04/13 By baogc 添加散客代碼欄位(rtz06)的控管
# Modify.........: No:FUN-B40071 11/05/03 by jason 已傳POS否狀態調整
# Modify.........: No:FUN-B50005 11/05/09 By baogc 添加rtz29欄位
# Modify.........: No:FUN-B80141 11/08/30 By yangxf 添加rtz30欄位
# Modify.........: No:FUN-B70075 11/10/25 By nanbing 更新已传pos否的状态
# Modify.........: No:MOD-C10114 12/01/12 By Vampire 放棄更新不應該再回寫資料
# Modify.........: No:FUN-C50036 12/05/22 By yangxf 新增rtz31,rtz32,rtz33栏位，添加相关逻辑
# Modify.........: NO:FUN-C50036 12/06/11 By yangxf 取消確認時控管是營運中心是否存在與pos下傳營運中心维护作业中
# Modify.........: NO:FUN-C60050 12/06/14 By yangxf 修改在更改时退出后pos状态显示错误BUG
# Modify.........: No.CHI-C30107 12/06/21 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.FUN-D10021 13/01/05 By dongsz 門店相關資料增加快速設置功能
# Modify.........: No.FUN-D10117 13/01/28 By dongsz 門店快速設置添加卡、券和促銷資料設置

DATABASE ds
GLOBALS "../../config/top.global"

DEFINE g_rtz        RECORD LIKE rtz_file.*
DEFINE g_rtz_t      RECORD LIKE rtz_file.*
DEFINE g_rtz01_t    LIKE rtz_file.rtz01
DEFINE g_wc         STRING
DEFINE g_wc2        STRING
DEFINE g_sql        STRING
DEFINE g_str        STRING
DEFINE g_forupd_sql STRING
DEFINE g_chr        LIKE type_file.chr1
DEFINE g_cmd        LIKE type_file.chr1000
DEFINE g_rec_b      LIKE type_file.num5
DEFINE l_ac         LIKE type_file.num5
DEFINE g_cnt        LIKE type_file.num10
DEFINE g_row_count  LIKE type_file.num5
DEFINE g_rec_b1     LIKE type_file.num5
DEFINE g_rec_b2     LIKE type_file.num5
DEFINE l_ac1        LIKE type_file.num5
DEFINE l_ac2        LIKE type_file.num5
DEFINE g_argv1      LIKE gen_file.gen07
DEFINE g_curs_index         LIKE type_file.num10
DEFINE g_curs_index1        LIKE type_file.num10
DEFINE g_curs_index2        LIKE type_file.num10
DEFINE g_no_ask           LIKE type_file.num5 
DEFINE g_msg               LIKE ze_file.ze03
DEFINE g_msg1              LIKE ze_file.ze03           #FUN-D10021 add
DEFINE g_msg2              LIKE ze_file.ze03           #FUN-D10021 add
DEFINE g_msg3              LIKE ze_file.ze03           #FUN-D10021 add
DEFINE g_flag              LIKE type_file.chr1         #FUN-D10117 add
DEFINE g_jump              LIKE type_file.num10
DEFINE g_before_input_done LIKE type_file.num5
DEFINE g_screen1   DYNAMIC ARRAY OF RECORD
               gen01   LIKE gen_file.gen01,
               gen02   LIKE gen_file.gen02,
               gen03   LIKE gen_file.gen03,
               gem02_1 LIKE gem_file.gem02,
               gen04   LIKE gen_file.gen04,
               gen05   LIKE gen_file.gen05,
               gen08   LIKE gen_file.gen08,
               gen06   LIKE gen_file.gen06,
               genacti LIKE gen_file.genacti
                   END RECORD
DEFINE g_screen2   DYNAMIC ARRAY OF RECORD
               ryi01   LIKE ryi_file.ryi01,
               ryi02   LIKE ryi_file.ryi02,
               gen02_2 LIKE gen_file.gen02,
               gen03_2 LIKE gen_file.gen03,
               gem02_2 LIKE gem_file.gem02,
               ryi04   LIKE ryi_file.ryi04,
               ryi05   LIKE ryi_file.ryi05,
               ryi06   LIKE ryi_file.ryi06,
               ryiacti LIKE ryi_file.ryiacti
                   END RECORD
DEFINE sr          RECORD
                rtz01    LIKE   rtz_file.rtz01,
                azw08    LIKE   azw_file.azw08,
                rtz13    LIKE   rtz_file.rtz13,
                azw07    LIKE   azw_file.azw07,
                azw08_2  LIKE   azw_file.azw08,
                rtz12    LIKE   rtz_file.rtz12,
                rtz03    LIKE   rtz_file.rtz03,
                rtz02    LIKE   rtz_file.rtz02,
                tqa02    LIKE   tqa_file.tqa02,
                rtz28    LIKE   rtz_file.rtz28,
                rtz11    LIKE   rtz_file.rtz11,
                rtz04    LIKE   rtz_file.rtz04,
                rtd02    LIKE   rtd_file.rtd02,
                rtz05    LIKE   rtz_file.rtz05,
                rtf02    LIKE   rtf_file.rtf02,
                rtz18    LIKE   rtz_file.rtz18,
                rtz19    LIKE   rtz_file.rtz19,
                rtz17    LIKE   rtz_file.rtz17,
                rtz21    LIKE   rtz_file.rtz21 
                   END RECORD
#FUN-D10021--add--str---
DEFINE g_rtz01   LIKE rtz_file.rtz01
DEFINE g_set       RECORD
                gys     LIKE rtz_file.rtz28,       #供應商資料
                khzl    LIKE rtz_file.rtz28,       #客戶資料
                khdj    LIKE rtz_file.rtz28,       #客戶訂價
                jyjg    LIKE rtz_file.rtz28,       #營運中心交易價格
                cgcl    LIKE rtz_file.rtz28,       #採購策略
                ckzl    LIKE rtz_file.rtz28,       #倉庫資料
                poscs   LIKE rtz_file.rtz28,       #POS傳輸設置
                posjh   LIKE rtz_file.rtz28,       #POS機號資料
                posmdcs LIKE rtz_file.rtz28,       #POS門店參數
                posmdjh LIKE rtz_file.rtz28,       #POS門店機號參數
                card    LIKE rtz_file.rtz28,       #卡資料    #FUN-D10117 add
                coupon  LIKE rtz_file.rtz28,       #券資料    #FUN-D10117 add
                promote LIKE rtz_file.rtz28        #促銷資料  #FUN-D10117 add
                   END RECORD
#FUN-D10021--add---end---

MAIN
   OPTIONS
      INPUT  NO WRAP
   DEFER INTERRUPT

   LET g_argv1 = ARG_VAL(1)

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("ART")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   LET g_forupd_sql = "SELECT * FROM rtz_file WHERE rtz01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i200_cl CURSOR FROM g_forupd_sql
   
   OPEN WINDOW i200_w AT 4,3 WITH FORM "art/42f/arti200"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()

   IF g_aza.aza88 = 'Y' THEN
      CALL cl_set_comp_visible("rtzpos",TRUE)
   ELSE
      CALL cl_set_comp_visible("rtzpos",FALSE)
   END IF
###-FUN-B50005- ADD - BEGIN --------------------------
   IF NOT cl_null(g_rtz.rtz03) THEN
      IF g_rtz.rtz03 = '3' THEN
         CALL cl_set_comp_visible("Page8",TRUE)
      ELSE
         CALL cl_set_comp_visible("Page8",FALSE)
      END IF
   END IF
###-FUN-B50005-  ADD -  END  --------------------------

   IF NOT cl_null(g_argv1) THEN
      CALL i200_q()
   END IF

   CALL i200_menu()
   CLOSE WINDOW i200_w
   
 # CALL cl_used(g_prog,g_time,0) RETURNING g_time
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
END MAIN

FUNCTION i200_menu()
   WHILE TRUE
      CALL i200_bp('d')
      CASE g_action_choice
        WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i200_q()          
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i200_u()
            END IF
        WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL i200_confirm()
            END IF
        WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL i200_undo_confirm()
            END IF
        WHEN "staff_data"
            IF cl_chk_act_auth() THEN
               IF cl_null(g_rtz.rtz01) THEN
                  CALL cl_err("",-400,1)
               ELSE
                  LET g_msg = "aooi040 '",g_rtz.rtz01,"'"
                  CALL cl_cmdrun_wait(g_msg)
               END IF
            END IF
        WHEN "cashier_data"
           IF cl_chk_act_auth() THEN
              IF cl_null(g_rtz.rtz01) THEN
                 CALL cl_err("",-400,1)
              ELSE
                 LET g_msg = "apci060 '",g_rtz.rtz01,"'"
                 CALL cl_cmdrun_wait(g_msg)
              END IF
           END IF

         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i200_out2()
            END IF
#        WHEN "invalid"
#           IF cl_chk_act_auth() THEN
#              CALL i200_x()
#           END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()

         WHEN "exporttoexcel"   
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_screen1),base.TypeInfo.create(g_screen2),'')
            END IF
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_rtz.rtz01 IS NOT NULL THEN
                 LET g_doc.column1 = "rtz01"
                 LET g_doc.value1 = g_rtz.rtz01
                 CALL cl_doc()
               END IF
         END IF
        #FUN-D10021--add--str---
         WHEN "quickly_set"     #快速設置   
            IF cl_chk_act_auth() THEN
               IF cl_null(g_rtz.rtz01) THEN
                  CALL cl_err("",-400,1)
               ELSE
                  CALL i200_set(g_rtz.rtz01)
               END IF
            END IF
        #FUN-D10021--add--end---
      END CASE
        
   END WHILE

END FUNCTION


FUNCTION i200_cs()
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01  
 
   CLEAR FORM 
   INITIALIZE g_rtz TO NULL
   INITIALIZE sr    TO NULL

   CALL cl_set_head_visible("","YES")           
   INITIALIZE g_rtz.* TO NULL  
      
   IF cl_null(g_argv1) THEN
      CONSTRUCT BY NAME g_wc  ON rtz01,rtz13,rtz12,rtz03,rtz02,rtz28,rtz11,rtzpos,
                                 rtzuser,rtzgrup,rtzoriu,rtzorig,rtzmodu,rtzdate,rtzcrat,
                                 rtz04,rtz05,rtz06,rtz08,rtz07,rtz09,
                                 rtz31,rtz32,rtz33,                                            #FUN-C50036 add 
                                 rtz18,rtz19,rtz14,rtz15,rtz10,rtz16,rtz17,rtz20,rtz21,
                              #  rtz22,rtz23,rtz24,rtz25,rtz26,rtz27         #FUN-B50005 MARK
                              #  rtz22,rtz23,rtz24,rtz25,rtz26,rtz27,rtz29   #FUN-B50005 ADD   #FUN-B80141 MARK 
                                 rtz22,rtz30,rtz23,rtz24,rtz25,rtz26,rtz27,rtz29               #FUN-B80141 ADD
      BEFORE CONSTRUCT
         CALL cl_qbe_init()

      ON ACTION CONTROLP
         CASE 
            WHEN INFIELD(rtz01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_rtz01"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO rtz01
            WHEN INFIELD(rtz02)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_rtz02"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO rtz02
            WHEN INFIELD(rtz04)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_rtz04"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO rtz04
            WHEN INFIELD(rtz05)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_rtz05"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO rtz05
            WHEN INFIELD(rtz06)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_rtz06_1"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret 
               DISPLAY g_qryparam.multiret TO rtz06
            WHEN INFIELD(rtz08)
#No.FUN-AA0062  --Begin            
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_rtz08"
#               LET g_qryparam.state = "c"
#               CALL cl_create_qry() RETURNING g_qryparam.multiret
               CALL q_imd_1(TRUE,TRUE,g_rtz.rtz08,"",g_rtz.rtz01,"N","") RETURNING g_qryparam.multiret
#No.FUN-AA0062  --End              
               DISPLAY g_qryparam.multiret TO rtz08
            WHEN INFIELD(rtz07)
#No.FUN-AA0062  --Begin                
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_rtz07"
#               LET g_qryparam.state = "c"
#               CALL cl_create_qry() RETURNING g_qryparam.multiret
               CALL q_imd_1(TRUE,TRUE,g_rtz.rtz07,"",g_rtz.rtz01,"Y","") RETURNING g_qryparam.multiret
#No.FUN-AA0062  --End   
               DISPLAY g_qryparam.multiret TO rtz07
            WHEN INFIELD(rtz10)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_rtz10_1"
               LET g_qryparam.state = "c"
               CALL cl_create_qry()RETURNING g_qryparam.multiret 
               DISPLAY g_qryparam.multiret TO rtz10
            WHEN INFIELD(rtz25)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_rtz25"
               LET g_qryparam.state = "c"
               CALL cl_create_qry()RETURNING g_qryparam.multiret 
               DISPLAY g_qryparam.multiret TO rtz25
#-FUN-B50005-  ADD ---------BEGIN ---------
            WHEN INFIELD(rtz29)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_occ02"
               LET g_qryparam.state = "c"
               CALL cl_create_qry()RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO rtz29
#-FUN-B50005-  ADD --------- END  ---------
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
      END CONSTRUCT
      
      IF INT_FLAG THEN
         RETURN
      END IF
   ELSE
      LET g_wc = " rtz01 = '",g_argv1,"'"
   END IF
 

   #LET g_sql = "SELECT * FROM rtz_file ",       #FUN-AC0022 mark
   LET g_sql = "SELECT rtz01 FROM rtz_file ",    #FUN-AC0022 add
               " WHERE ",g_wc CLIPPED
   PREPARE i200_prepare FROM g_sql
   DECLARE i200_cs SCROLL CURSOR WITH HOLD FOR i200_prepare
 
   LET g_sql="SELECT COUNT(*) FROM rtz_file WHERE ",g_wc CLIPPED
   PREPARE i200_precount FROM g_sql
   DECLARE i200_count CURSOR FOR i200_precount
 
END FUNCTION

FUNCTION i200_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   INITIALIZE g_rtz TO NULL
   CALL g_screen1.clear()
   CALL g_screen2.clear()
   DISPLAY ' ' TO FORMONLY.cnt
 
   CALL i200_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_rtz.* TO NULL
      RETURN
   END IF
 
   OPEN i200_cs                           
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_rtz.* TO NULL
   ELSE
      OPEN i200_count
      FETCH i200_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
 
      CALL i200_fetch('F')                  
   END IF
 
END FUNCTION

FUNCTION i200_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1                
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     i200_cs INTO g_rtz.rtz01    #FUN-AC0022 Modify g_rtz.* to g_rtz.rtz01
      WHEN 'P' FETCH PREVIOUS i200_cs INTO g_rtz.rtz01    #FUN-AC0022 Modify g_rtz.* to g_rtz.rtz01
      WHEN 'F' FETCH FIRST    i200_cs INTO g_rtz.rtz01    #FUN-AC0022 Modify g_rtz.* to g_rtz.rtz01
      WHEN 'L' FETCH LAST     i200_cs INTO g_rtz.rtz01    #FUN-AC0022 Modify g_rtz.* to g_rtz.rtz01
      WHEN '/'
            IF (NOT g_no_ask) THEN     
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
            FETCH ABSOLUTE g_jump i200_cs INTO g_rtz.rtz01    #FUN-AC0022 Modify g_rtz.* to g_rtz.rtz01
            LET g_no_ask = FALSE     
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err("",SQLCA.sqlcode,0)
      INITIALIZE g_rtz.* TO NULL               
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
   #FUN-AC0022 add --begin--------------------------------------
   SELECT * INTO g_rtz.* FROM rtz_file WHERE rtz01 = g_rtz.rtz01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","rtz_file",g_rtz.rtz01,"",SQLCA.sqlcode,"","",0)
   ELSE
      CALL i200_show()                   # 重新顯示
   END IF
   #FUN-AC0022 add ---end---------------------------------------
   #CALL i200_show()    #FUN-AC0022 mark
 
END FUNCTION

FUNCTION i200_show()
DEFINE  l_occ02              LIKE occ_file.occ02
 
   LET g_rtz_t.* = g_rtz.*             
   DISPLAY BY NAME g_rtz.rtz01,g_rtz.rtz02,g_rtz.rtz03,g_rtz.rtz04,g_rtz.rtz05,
                   g_rtz.rtz06,g_rtz.rtz07,g_rtz.rtz08,g_rtz.rtz09,g_rtz.rtz31,g_rtz.rtz32,g_rtz.rtz33,g_rtz.rtz10,         #FUN-C50036 add g_rtz.rtz31,g_rtz.rtz32,g_rtz.rtz33
                   g_rtz.rtz11,g_rtz.rtzpos,g_rtz.rtz12,g_rtz.rtz13,g_rtz.rtz14,
                   g_rtz.rtz15,g_rtz.rtz16,g_rtz.rtz17,g_rtz.rtz18,g_rtz.rtz19,
               #   g_rtz.rtz20,g_rtz.rtz21,g_rtz.rtz22,g_rtz.rtz23,g_rtz.rtz24,    #FUN-B80141  MARK
                   g_rtz.rtz20,g_rtz.rtz21,g_rtz.rtz22,g_rtz.rtz30,g_rtz.rtz23,g_rtz.rtz24,  #FUN-B80141
               #   g_rtz.rtz25,g_rtz.rtz26,g_rtz.rtz27,g_rtz.rtz28,                #FUN-B50005 MARK
                   g_rtz.rtz25,g_rtz.rtz26,g_rtz.rtz27,g_rtz.rtz28,g_rtz.rtz29,    #FUN-B50005 ADD
                   g_rtz.rtzcrat,g_rtz.rtzdate,g_rtz.rtzgrup,g_rtz.rtzmodu,g_rtz.rtzorig,
                   g_rtz.rtzoriu,g_rtz.rtzuser
                              
   CALL i200_azw07()
   CALL i200_rtz01()
   CALL i200_tqa02()
   CALL i200_rtz04()
   CALL i200_rtz05()
   CALL i200_rtz06()
   CALL i200_rtz08()
   CALL i200_rtz07()
   CALL i200_rtz10()
   CALL i200_rtz25()

###-FUN-B50005- ADD - BEGIN ------------------------------------
   IF NOT cl_null(g_rtz.rtz03) THEN
      IF g_rtz.rtz03 = '3' THEN
         CALL cl_set_comp_visible("Page8",TRUE)
      ELSE    
         CALL cl_set_comp_visible("Page8",FALSE)
      END IF  
   END IF
   SELECT occ02 INTO l_occ02 FROM occ_file WHERE occ01 = g_rtz.rtz29 AND occacti = 'Y'
   DISPLAY l_occ02 TO FORMONLY.rtz29_desc
###-FUN-B50005- ADD -  END  ------------------------------------
   
          
   CALL i200_b_fill(g_wc2)              
 
   CALL cl_show_fld_cont()               
END FUNCTION

FUNCTION i200_b_fill(p_wc2)
   DEFINE  p_wc2    STRING
   DEFINE  l_sql1   STRING
   DEFINE  l_sql2   STRING
   DEFINE  l_s      LIKE type_file.chr1000 
   DEFINE  l_m      LIKE type_file.chr1000 
   DEFINE  i        LIKE type_file.num5

   LET l_sql1 = "SELECT gen01, gen02, gen03, gem02, gen04, gen05, gen08, gen06, genacti ",
                "  FROM gen_file LEFT JOIN gem_file ",
                "    ON gen03 = gem01 ",
                " WHERE gen07 = '",g_rtz.rtz01,"' "
   LET l_sql2 = "SELECT ryi01, ryi02, gen02, gen03, gem02, ryi04, ryi05, ryi06, ryiacti ",
                "  FROM ryi_file LEFT JOIN gen_file ",
                "    ON ryi02 = gen01 LEFT JOIN gem_file ",
                "    ON gen03 = gem01 ",
                " WHERE gen07 = '",g_rtz.rtz01,"' "

#  LET l_sql1 = l_sql1 CLIPPED," ORDER BY gen01 "
#  LET l_sql2 = l_sql2 CLIPPED," ORDER BY ryi01 "
 
   PREPARE i200_pb1 FROM l_sql1
   DECLARE s_cs1 CURSOR FOR i200_pb1

   PREPARE i200_pb2 FROM l_sql2
   DECLARE s_cs2 CURSOR FOR i200_pb2
 
   CALL g_screen1.clear()
   CALL g_screen2.clear()

   LET g_cnt = 1
   FOREACH s_cs1 INTO g_screen1[g_cnt].*   
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF   
       LET g_cnt = g_cnt + 1
   END FOREACH
   CALL g_screen1.deleteElement(g_cnt)
   
   LET g_cnt = 1
   FOREACH s_cs2 INTO g_screen2[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF   
       LET g_cnt = g_cnt + 1
   END FOREACH
   CALL g_screen2.deleteElement(g_cnt)

   LET g_cnt = 0
END FUNCTION


FUNCTION i200_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1  
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
  
#  IF g_rtz.rtz28 = 'Y' THEN
#     CALL cl_set_act_visible("undo_confirm",TRUE)
#     CALL cl_set_act_visible("confirm",FALSE)
#  ELSE
#     CALL cl_set_act_visible("undo_confirm",FALSE)
#     CALL cl_set_act_visible("confirm",TRUE)
#  END IF

      DIALOG ATTRIBUTES(UNBUFFERED) 
      
         DISPLAY ARRAY g_screen1 TO s_screen1.* ATTRIBUTE(COUNT=g_rec_b1)
            BEFORE DISPLAY
               CALL cl_navigator_setting(g_curs_index, g_row_count)
         
            BEFORE ROW
               LET l_ac1 = ARR_CURR()
               CALL cl_show_fld_cont()
               LET g_rec_b1= ARR_COUNT()
            AFTER DISPLAY
               CONTINUE DIALOG 
         END DISPLAY

         DISPLAY ARRAY g_screen2 TO s_screen2.* ATTRIBUTE(COUNT=g_rec_b2)
            BEFORE DISPLAY
               CALL cl_navigator_setting(g_curs_index, g_row_count)
            BEFORE ROW
               LET l_ac2 = ARR_CURR()
               CALL cl_show_fld_cont()
               LET g_rec_b2= ARR_COUNT()
            AFTER DISPLAY
               CONTINUE DIALOG 
         END DISPLAY

         ON ACTION query
            LET g_action_choice="query"
            EXIT DIALOG
           
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DIALOG
      ON ACTION confirm
         LET g_action_choice = "confirm"
         EXIT DIALOG
      ON ACTION undo_confirm
         LET g_action_choice = "undo_confirm"
         EXIT DIALOG
      ON ACTION staff_data
         LET g_action_choice = "staff_data"
         EXIT DIALOG
      ON ACTION cashier_data
         LET g_action_choice = "cashier_data"
         EXIT DIALOG
 
      ON ACTION first
         CALL i200_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG   
 
      ON ACTION previous
         CALL i200_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG   
 
      ON ACTION jump
         CALL i200_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG   
 
      ON ACTION next
         CALL i200_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG   
 
      ON ACTION last
         CALL i200_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG   
 
#     ON ACTION invalid
#        LET g_action_choice="invalid"
#        EXIT DIALOG
 
  
         ON ACTION output
            LET g_action_choice="output"
            EXIT DIALOG

         ON ACTION help
            LET g_action_choice="help"
            EXIT DIALOG

         ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()

         ON ACTION exit
            LET g_action_choice="exit"
            EXIT DIALOG

         ON ACTION cancel
            LET INT_FLAG=FALSE
            LET g_action_choice="exit"
            EXIT DIALOG

         ON ACTION close              
            LET INT_FLAG=FALSE
            LET g_action_choice="exit"
            EXIT DIALOG

         ON ACTION controlg
            LET g_action_choice="controlg"
            EXIT DIALOG

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DIALOG

         ON ACTION about
            CALL cl_about()
         ON ACTION related_document
            LET g_action_choice="related_document"
            EXIT DIALOG

         ON ACTION exporttoexcel
            LET g_action_choice = 'exporttoexcel'
            EXIT DIALOG
        #FUN-D10021--add--str---
         ON ACTION quickly_set
            LET g_action_choice = 'quickly_set'
            EXIT DIALOG
        #FUN-D10021--add--end---
      END DIALOG
      CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION


FUNCTION i200_u()
   DEFINE l_azp051 LIKE azp_file.azp051
   DEFINE l_azp06  LIKE azp_file.azp06
   DEFINE l_azp07  LIKE azp_file.azp07
   DEFINE l_rtzpos  LIKE rtz_file.rtzpos  #FUN-B70075 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_rtz.rtz01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   
#FUN-A80148 mark
#   IF g_rtz.rtz28 = 'Y' THEN
#     CALL cl_err("",1209,0)                                    
#      RETURN
#   END IF
#FUN-A80148 mark
 
#  IF g_rtz.rtzacti ='N' THEN    #
#     CALL cl_err("",'mfg1000',0)
#     RETURN
#  END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_rtz_t.* = g_rtz.*
#FUN-B70075  str-------
   IF g_aza.aza88 = 'Y' THEN
      #FUN-C60050 add begin ---
      BEGIN WORK
      OPEN i200_cl USING g_rtz.rtz01
      IF STATUS THEN
         CALL cl_err("OPEN i200_cl:", STATUS, 1)
         CLOSE i200_cl
         ROLLBACK WORK
         RETURN
      END IF
      FETCH i200_cl INTO g_rtz.*                      # 鎖住將被更改或取消的資料
      IF SQLCA.sqlcode THEN
          CALL cl_err("",SQLCA.sqlcode,0)             # 資料被他人LOCK
          CLOSE i200_cl
          ROLLBACK WORK
          RETURN
      END IF
      #FUN-C60050 add end  ---
      LET g_rtz_t.* = g_rtz.*
      LET l_rtzpos = g_rtz.rtzpos
      UPDATE rtz_file SET rtzpos = '4' 
       WHERE rtz01 = g_rtz.rtz01
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
          CALL cl_err3("upd","rtz_file",g_rtz_t.rtz01,"",SQLCA.sqlcode,"","",1)
          CLOSE i200_cl                                  #FUN-C60050 add
          ROLLBACK WORK                                  #FUN-C60050 add
          RETURN
      END IF
      LET g_rtz.rtzpos = '4'
      DISPLAY BY NAME g_rtz.rtzpos  
      CLOSE i200_cl                                      #FUN-C60050 add
      COMMIT WORK                                        #FUN-C60050 add
   END IF 
#FUN-B70075  end------   
   BEGIN WORK
 
   OPEN i200_cl USING g_rtz.rtz01
   IF STATUS THEN
      CALL cl_err("OPEN i200_cl:", STATUS, 1)
      CLOSE i200_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i200_cl INTO g_rtz.*                      # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err("",SQLCA.sqlcode,0)             # 資料被他人LOCK
       CLOSE i200_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   CALL i200_show()
 
   WHILE TRUE
      LET g_rtz01_t = g_rtz.rtz01
      LET g_rtz.rtzmodu = g_user
      LET g_rtz.rtzdate = g_today

      CALL i200_i("u")                      #欄位更改
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_rtz.*=g_rtz_t.*
        #MOD-C10114 ----- start modify -----
        #FUN-B70075   str-------
         #LET g_rtz.rtzpos = l_rtzpos
         #UPDATE rtz_file SET rtzpos = g_rtz.rtzpos
         # WHERE rtz01 = g_rtz.rtz01
         #IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         #   CALL cl_err3("upd","rtz_file",g_rtz_t.rtz01,"",SQLCA.sqlcode,"","",1)
         #   CONTINUE WHILE
         #END IF
         IF g_aza.aza88 = 'Y' THEN            #FUN-C60050 add
#           IF g_rtz_t.rtzpos <> '1' THEN     #FUN-C60050 mark
            IF l_rtzpos <> '1' THEN           #FUN-C60050 add
               LET g_rtz.rtzpos='2'
            ELSE
               LET g_rtz.rtzpos='1'
            END IF
#FUN-C60050 add begin ---
            UPDATE rtz_file SET rtzpos = g_rtz.rtzpos
             WHERE rtz01 = g_rtz.rtz01
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               CALL cl_err3("upd","rtz_file",g_rtz_t.rtz01,"",SQLCA.sqlcode,"","",1)
               CONTINUE WHILE
            END IF
#FUN-C60050 add end -----
        END IF                          #FUN-C60050 add
        IF g_aza.aza88 = 'Y' THEN
           DISPLAY BY NAME g_rtz.rtzpos
        END IF
        #FUN-B70075   end-------         
        #MOD-C10114 ----- end modify -----
         CALL i200_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
     #FUN-B70075 Begin ---------
       IF g_aza.aza88 = 'Y' THEN
          IF l_rtzpos <> '1' THEN
             LET g_rtz.rtzpos='2'
          ELSE
             LET g_rtz.rtzpos='1'
          END IF
          DISPLAY BY NAME g_rtz.rtzpos
       END IF
      #FUN-B70075 End ----------- 
#FUN-A80148--MOD--STR
#      IF g_rtz.rtz17 != g_rtz_t.rtz17 OR g_rtz.rtz18 != g_rtz_t.rtz18 OR g_rtz.rtz19 != g_rtz_t.rtz19 THEN
#            IF (cl_confirm('art-936')) THEN
#               UPDATE azp_file SET azp051 = g_rtz.rtz17,
#                                   azp06  = g_rtz.rtz18,
#                                   azp07  = g_rtz.rtz19
#                WHERE azp01 = g_rtz.rtz01
#            END IF
#      END IF
       IF g_rtz.rtz17 <> g_rtz_t.rtz17 OR g_rtz.rtz18<> g_rtz_t.rtz18 OR g_rtz.rtz19 <> g_rtz_t.rtz19 OR
          (cl_null(g_rtz.rtz17) AND NOT cl_null(g_rtz_t.rtz17)) OR
          (cl_null(g_rtz.rtz18) AND NOT cl_null(g_rtz_t.rtz18)) OR
          (cl_null(g_rtz.rtz19) AND NOT cl_null(g_rtz_t.rtz19)) OR
          (NOT cl_null(g_rtz.rtz17) AND cl_null(g_rtz_t.rtz17)) OR
          (NOT cl_null(g_rtz.rtz18) AND cl_null(g_rtz_t.rtz18)) OR
          (NOT cl_null(g_rtz.rtz19) AND cl_null(g_rtz_t.rtz19)) THEN
          IF g_azw.azw04='2' THEN
             IF cl_confirm("art-936") THEN
                IF g_rtz.rtz17 <> g_rtz_t.rtz17 OR 
                   (cl_null(g_rtz.rtz17) AND NOT cl_null(g_rtz_t.rtz17)) OR
                   (NOT cl_null(g_rtz.rtz17) AND cl_null(g_rtz_t.rtz17)) THEN
                   UPDATE azp_file SET azp051 = g_rtz.rtz17
                    WHERE azp01 =  g_rtz.rtz01 
                   IF SQLCA.sqlcode THEN
                      CALL cl_err3("upd","azp_file",g_rtz.rtz01,"",SQLCA.sqlcode,"","Update azp_file",1)  
                      CONTINUE WHILE
                   END IF
                END IF  
             
                IF g_rtz.rtz18 <> g_rtz_t.rtz18 OR cl_null(l_azp06) OR
                   (cl_null(g_rtz.rtz18) AND NOT cl_null(g_rtz_t.rtz18)) OR
                   (NOT cl_null(g_rtz.rtz18) AND cl_null(g_rtz_t.rtz18)) THEN
                   UPDATE azp_file SET azp06 = g_rtz.rtz18
                    WHERE azp01 =  g_rtz.rtz01 
                   IF SQLCA.sqlcode THEN
                      CALL cl_err3("upd","azp_file",g_rtz.rtz01,"",SQLCA.sqlcode,"","Update azp_file",1)  
                      CONTINUE WHILE
                   END IF
                END IF
             
                IF g_rtz.rtz19<> g_rtz_t.rtz19 OR cl_null(l_azp07) OR
                   (cl_null(g_rtz.rtz19) AND NOT cl_null(g_rtz_t.rtz19)) OR
                   (NOT cl_null(g_rtz.rtz19) AND cl_null(g_rtz_t.rtz19)) THEN
                   UPDATE azp_file SET azp07 = g_rtz.rtz19
                    WHERE azp01 =  g_rtz.rtz01 
                   IF SQLCA.sqlcode THEN
                      CALL cl_err3("upd","azp_file",g_rtz.rtz01,"",SQLCA.sqlcode,"","Update azp_file",1)  
                      CONTINUE WHILE
                   END IF
                END IF  
             END IF
          ELSE
             UPDATE azp_file SET azp051 = g_rtz.rtz17,
                                azp06  = g_rtz.rtz18,
                                azp07  = g_rtz.rtz19
              WHERE azp01 = g_rtz.rtz01
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","azp_file",g_rtz.rtz01,"",SQLCA.sqlcode,"","Update azp_file",1)  
                CONTINUE WHILE
             END IF
          END IF
       END IF    
#FUN-A80148--MOD--END
            
      IF g_rtz.rtz01 != g_rtz01_t THEN            # 更改營運中心
         UPDATE gen_file SET gen07 = g_rtz.rtz01
          WHERE gen07 = g_rtz01_t
         UPDATE gem_file SET gem11 = g_rtz.rtz01
          WHERE gem11 = g_rtz01_t
         UPDATE ryi_file SET ryi00 = g_rtz.rtz01
          WHERE ryi00 = g_rtz01_t
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","gen_file",g_rtz01_t,"",SQLCA.sqlcode,"","rtz",1)  
            CONTINUE WHILE
         END IF
      END IF
 
      UPDATE rtz_file SET rtz_file.* = g_rtz.*
       WHERE rtz01 = g_rtz.rtz01
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","rtz_file","","",SQLCA.sqlcode,"","",1)  
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
 
   CLOSE i200_cl
   COMMIT WORK
   CALL cl_flow_notify(g_rtz.rtz01,'U')
 
   CALL i200_b_fill("1=1")
   CALL i200_bp_refresh()
 
END FUNCTION


FUNCTION i200_i(p_cmd)
DEFINE
   l_n       LIKE type_file.num5,    
   p_cmd     LIKE type_file.chr1    
   DEFINE li_result LIKE type_file.num5  
   DEFINE l_tqa02   LIKE tqa_file.tqa02
   DEFINE l_rtd02   LIKE rtd_file.rtd02
   DEFINE l_rtf02   LIKE rtf_file.rtf02
   DEFINE l_occ02   LIKE occ_file.occ02
   DEFINE l_imd02_1 LIKE imd_file.imd02
   DEFINE l_imd02_2 LIKE imd_file.imd02
   DEFINE l_ryf02   LIKE ryf_file.ryf02
   DEFINE l_ryb02   LIKE ryb_file.ryb02
   DEFINE l_nma02   LIKE nma_file.nma02
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   DISPLAY BY NAME g_rtz.rtz01,g_rtz.rtz02,g_rtz.rtz03,g_rtz.rtz04,g_rtz.rtz05,
                   g_rtz.rtz06,g_rtz.rtz07,g_rtz.rtz08,g_rtz.rtz09,g_rtz.rtz31,g_rtz.rtz32,g_rtz.rtz33,g_rtz.rtz10,     #FUN-C50036 add g_rtz.rtz31,g_rtz.rtz32,g_rtz.rtz33
                   g_rtz.rtz11,g_rtz.rtzpos,g_rtz.rtz12,g_rtz.rtz13,g_rtz.rtz14,
                   g_rtz.rtz15,g_rtz.rtz16,g_rtz.rtz17,g_rtz.rtz18,g_rtz.rtz19,
                #  g_rtz.rtz20,g_rtz.rtz21,g_rtz.rtz22,g_rtz.rtz23,g_rtz.rtz24,               #FUN-B80141  MARK
                   g_rtz.rtz20,g_rtz.rtz21,g_rtz.rtz22,g_rtz.rtz30,g_rtz.rtz23,g_rtz.rtz24,   #FUN-B80141  ADD
                #  g_rtz.rtz25,g_rtz.rtz26,g_rtz.rtz27,g_rtz.rtz28,             #FUN-B50005 MARK
                   g_rtz.rtz25,g_rtz.rtz26,g_rtz.rtz27,g_rtz.rtz28,g_rtz.rtz29, #FUN-B50005 ADD
                   g_rtz.rtzcrat,g_rtz.rtzdate,g_rtz.rtzgrup,g_rtz.rtzmodu,g_rtz.rtzorig,
                   g_rtz.rtzoriu,g_rtz.rtzuser
 
   CALL cl_set_head_visible("","YES")          
   IF p_cmd = "u" THEN
     #FUN-B40071 --START--
      #LET g_rtz.rtzpos = 'N'
#FUN-B70075   str----------
#      IF g_rtz.rtzpos <> '1' THEN
#         LET g_rtz.rtzpos = '2'
#      END IF
#FUN-B70075   end---------
     #FUN-B40071 --END--
      CALL cl_set_comp_entry("rtzpos",FALSE)
       #FUN-A80148--add--str
      IF g_rtz.rtz28 = 'Y' THEN
         CALL cl_set_comp_entry("rtz13,rtz12,rtz03,rtz03,rtz11",TRUE)   
      END IF 
      #FUN-A80148--add--str   
   END IF

   INPUT  BY NAME             g_rtz.rtz01,g_rtz.rtz13,g_rtz.rtz12,g_rtz.rtz03,g_rtz.rtz02,g_rtz.rtz28,g_rtz.rtz11,g_rtz.rtzpos,
                              g_rtz.rtzuser,g_rtz.rtzgrup,g_rtz.rtzoriu,g_rtz.rtzorig,g_rtz.rtzmodu,g_rtz.rtzcrat,
                              g_rtz.rtz04,g_rtz.rtz05,g_rtz.rtz06,g_rtz.rtz08,g_rtz.rtz07,g_rtz.rtz09,
                              g_rtz.rtz31,g_rtz.rtz32,g_rtz.rtz33,                               #FUN-C50036 add
                              g_rtz.rtz18,g_rtz.rtz19,g_rtz.rtz14,g_rtz.rtz15,g_rtz.rtz10,g_rtz.rtz16,g_rtz.rtz17,g_rtz.rtz20,g_rtz.rtz21,
                         #    g_rtz.rtz22,g_rtz.rtz23,g_rtz.rtz24,g_rtz.rtz25,g_rtz.rtz26,g_rtz.rtz27              #FUN-B50005 MARK
                         #    g_rtz.rtz22,g_rtz.rtz23,g_rtz.rtz24,g_rtz.rtz25,g_rtz.rtz26,g_rtz.rtz27,g_rtz.rtz29  #FUN-B50005 ADD   MARK
                              g_rtz.rtz22,g_rtz.rtz30,g_rtz.rtz23,g_rtz.rtz24,g_rtz.rtz25,g_rtz.rtz26,g_rtz.rtz27,g_rtz.rtz29  #FUN-B80141  ADD
       WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = TRUE
         #FUN-A80148--add--str
         IF g_rtz.rtz28 = 'Y' THEN
            CALL i200_set_no_entry('u')
            CALL i200_set_entry('u') 
         END IF 
         #FUN-A80148--add--str   
#FUN-A80117 --------------STR
#     AFTER FIELD rtz12
#        IF g_rtz.rtz12 = '1' THEN
#           LET g_rtz.rtz03 = '1'
#           DISPLAY BY NAME g_rtz.rtz03
#           CALL cl_set_comp_entry("rtz03",FALSE)
#        ELSE
#           CALL cl_set_comp_entry("rtz03",TRUE)
#        END IF
      ON CHANGE rtz12
         IF g_rtz.rtz12 = '1' THEN
            LET g_rtz.rtz03 = '1'
            DISPLAY BY NAME g_rtz.rtz03
            CALL cl_set_comp_entry("rtz03",FALSE)
         ELSE       
            CALL cl_set_comp_entry("rtz03",TRUE)
         END IF     
#FUN-A80117 --------------END
      
      AFTER FIELD rtz02
         IF not cl_null(g_rtz.rtz02) THEN
            CALL i200_rtz02()
            IF not cl_null(g_errno) THEN
               CALL cl_err("",g_errno,0)
               LET g_rtz.rtz02 = g_rtz_t.rtz02
               DISPLAY BY NAME g_rtz.rtz02
               NEXT FIELD rtz02
            END IF
         ELSE 
            LET l_tqa02 = ' '
            DISPLAY l_tqa02 TO FORMONLY.tqa02
            LET sr.tqa02 = l_tqa02
         END IF
         
###-FUN-B50005- ADD - BEGIN -----------------------
      AFTER FIELD rtz03
         IF NOT cl_null(g_rtz.rtz03) THEN
            IF g_rtz.rtz03 = '3' THEN
               CALL cl_set_comp_visible("Page8",TRUE)
            ELSE 
               CALL cl_set_comp_visible("Page8",FALSE)
            END IF     
         END IF 
###-FUN-B50005- ADD -  END  -----------------------
      AFTER FIELD rtz04
         IF not cl_null(g_rtz.rtz04) THEN
            CALL i200_rtz04()
            IF not cl_null(g_errno) THEN
               CALL cl_err("",g_errno,0)
               LET g_rtz.rtz04 = g_rtz_t.rtz04
               DISPLAY BY NAME g_rtz.rtz04
               NEXT FIELD rtz04
            END IF
         ELSE 
            LET l_rtd02 = ' '
            DISPLAY l_rtd02 TO FORMONLY.rtd02
            LET sr.rtd02 = l_rtd02
         END IF
         
      AFTER FIELD rtz05
         IF not cl_null(g_rtz.rtz05) THEN
            CALL i200_rtz05()
            IF not cl_null(g_errno) THEN
               CALL cl_err("",g_errno,0)
               LET g_rtz.rtz05 = g_rtz_t.rtz05
               DISPLAY BY NAME g_rtz.rtz05
               NEXT FIELD rtz05
            END IF
         ELSE 
            LET l_rtf02 = ' '
            DISPLAY l_rtf02 TO FORMONLY.rtf02
            LET sr.rtf02 = l_rtf02
         END IF         
         
      AFTER FIELD rtz06
         IF not cl_null(g_rtz.rtz06) THEN
            CALL i200_rtz06()
            IF not cl_null(g_errno) THEN
               CALL cl_err("",g_errno,0)
               LET g_rtz.rtz06 = g_rtz_t.rtz06
               DISPLAY BY NAME g_rtz.rtz06
               NEXT FIELD rtz06
            END IF
            CALL i200_rtz06_check()  #FUN-B40032 ADD 檢查客戶資料中按交款產生應收是否勾選
         ELSE 
            LET l_occ02 = ' '
            DISPLAY l_occ02 TO FORMONLY.occ02
         END IF 
         
      AFTER FIELD rtz08
         IF not cl_null(g_rtz.rtz08) THEN
            CALL i200_rtz08()
            IF not cl_null(g_errno) THEN
               CALL cl_err("",g_errno,0)
               LET g_rtz.rtz08 = g_rtz_t.rtz08
               DISPLAY BY NAME g_rtz.rtz08
               NEXT FIELD rtz08
            END IF
            #No.FUN-AA0062  --Begin
            IF NOT s_chk_ware1(g_rtz.rtz08,g_rtz.rtz01) THEN
               NEXT FIELD rtz08
            END IF
            #No.FUN-AA0062  --End
         ELSE 
            LET l_imd02_1 = ' '
            DISPLAY l_imd02_1 TO FORMONLY.imd02_1
         END IF 
         

      AFTER FIELD rtz07
         IF not cl_null(g_rtz.rtz07) THEN
            CALL i200_rtz07()
            IF not cl_null(g_errno) THEN
               CALL cl_err("",g_errno,0)
               LET g_rtz.rtz07 = g_rtz_t.rtz07
               DISPLAY BY NAME g_rtz.rtz07
               NEXT FIELD rtz07
            END IF
            #No.FUN-AA0062  --Begin
           #IF NOT s_chk_ware1(g_rtz.rtz08,g_rtz.rtz01) THEN
            IF NOT s_chk_ware1(g_rtz.rtz07,g_rtz.rtz01) THEN
               NEXT FIELD rtz08
            END IF
            #No.FUN-AA0062  --End
         ELSE
            LET l_imd02_2 = ' '
            DISPLAY l_imd02_2 TO FORMONLY.imd02_2
         END IF

      AFTER FIELD rtz10
         IF not cl_null(g_rtz.rtz10) THEN
            CALL i200_rtz10()
            IF not cl_null(g_errno) THEN
               CALL cl_err("",g_errno,0)
               LET g_rtz.rtz10 = g_rtz_t.rtz10
               DISPLAY BY NAME g_rtz.rtz10
               NEXT FIELD rtz10
            END IF
         ELSE 
            LET l_ryf02 = ' '
            LET l_ryb02 = ' '
            DISPLAY l_ryf02,l_ryb02 TO FORMONLY.ryf02,FORMONLY.ryb02
         END IF
         
      AFTER FIELD rtz25
         IF not cl_null(g_rtz.rtz25) THEN
            CALL i200_rtz25()
            IF not cl_null(g_errno) THEN
               CALL cl_err("",g_errno,0)
               LET g_rtz.rtz25 = g_rtz_t.rtz25
               DISPLAY BY NAME g_rtz.rtz25
               NEXT FIELD rtz25
            END IF
         ELSE 
            LET l_nma02 = ' '
            LET g_rtz.rtz26 = ' '
            LET g_rtz.rtz27 = ' '            
            DISPLAY l_nma02,g_rtz.rtz26,g_rtz.rtz27 TO FORMONLY.nma02,rtz26,rtz27
         END IF
###-FUN-B50005 ---- ADD - BEGIN ---------------------------
      AFTER FIELD rtz29
         IF NOT cl_null(g_rtz.rtz29) THEN
            LET l_occ02 = NULL
            SELECT occ02 INTO l_occ02 FROM occ_file WHERE occ01 = g_rtz.rtz29
               AND occacti = 'Y'
            IF SQLCA.sqlcode THEN
               CALL cl_err('',SQLCA.sqlcode,0)
               NEXT FIELD rtz29
            END IF
            DISPLAY l_occ02 TO FORMONLY.rtz29_desc
         END IF
###-FUN-B50005 ---- ADD -  END  ---------------------------
         
      AFTER FIELD rtz09
         IF g_rtz.rtz09 < 0 THEN
            CALL cl_err("",'aim-223',0)
            NEXT FIELD rtz09
         END IF
         
#FUN-C50036 add begin ---
      AFTER FIELD rtz31,rtz32,rtz33
         CASE 
            WHEN INFIELD(rtz31)
                 IF NOT cl_null(g_rtz.rtz31) THEN
                    IF g_rtz.rtz31 < 0 OR g_rtz.rtz31 > 100 THEN
                       CALL cl_err('','art1070',0)
                       LET g_rtz.rtz31 = g_rtz_t.rtz31 
                       NEXT FIELD rtz31
                    END IF 
                 END IF 
            WHEN INFIELD(rtz32)
                 IF NOT cl_null(g_rtz.rtz32) THEN
                    IF g_rtz.rtz32 < 0 OR g_rtz.rtz32 > 100 THEN
                       CALL cl_err('','art1070',0)
                       LET g_rtz.rtz32 = g_rtz_t.rtz32
                       NEXT FIELD rtz32
                    END IF
                 END IF
            WHEN INFIELD(rtz33)
                 IF NOT cl_null(g_rtz.rtz33) THEN
                    IF g_rtz.rtz33 < 0 OR g_rtz.rtz33 > 100 THEN
                       CALL cl_err('','art1070',0)
                       LET g_rtz.rtz33 = g_rtz_t.rtz33
                       NEXT FIELD rtz33
                    END IF
                 END IF
         END CASE
#FUN-C50036 add end ---

      AFTER FIELD rtz14
         IF g_rtz.rtz14 < 0 THEN
            CALL cl_err("",'aim-223',0)
            NEXT FIELD rtz14
         END IF
         
      AFTER FIELD rtz15
         IF g_rtz.rtz15 < 0 THEN
            CALL cl_err("",'aim-223',0)
            NEXT FIELD rtz15
         END IF
         

      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(rtz02) 
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_tqa01"
               LET g_qryparam.default1 = g_rtz.rtz02
               CALL cl_create_qry() RETURNING g_rtz.rtz02
               DISPLAY BY NAME g_rtz.rtz02
               NEXT FIELD rtz02
            WHEN INFIELD(rtz04) 
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_rtd01"
               LET g_qryparam.default1 = g_rtz.rtz04
               CALL cl_create_qry() RETURNING g_rtz.rtz04
               DISPLAY BY NAME g_rtz.rtz04
               NEXT FIELD rtz04
            WHEN INFIELD(rtz05) 
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_rtf01"
               LET g_qryparam.default1 = g_rtz.rtz05
               CALL cl_create_qry() RETURNING g_rtz.rtz05
               DISPLAY BY NAME g_rtz.rtz05
               NEXT FIELD rtz05
            WHEN INFIELD(rtz06) 
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_occ"
               LET g_qryparam.default1 = g_rtz.rtz06
               CALL cl_create_qry() RETURNING g_rtz.rtz06
               DISPLAY BY NAME g_rtz.rtz06
               NEXT FIELD rtz06       
            WHEN INFIELD(rtz08) 
#No.FUN-AA0062  --Begin
#               CALL cl_init_qry_var()
#               LET g_qryparam.form ="q_imd02_2"
#               LET g_qryparam.arg1 = g_rtz.rtz01
#               LET g_qryparam.default1 = g_rtz.rtz08
#               CALL cl_create_qry() RETURNING g_rtz.rtz08
               CALL q_imd_1(FALSE,TRUE,g_rtz.rtz08,"",g_rtz.rtz01,'N',"") RETURNING g_rtz.rtz08
#No.FUN-AA0062  --End
               DISPLAY BY NAME g_rtz.rtz08
               NEXT FIELD rtz08    
            WHEN INFIELD(rtz07) 
#No.FUN-AA0062  --Begin    
#               CALL cl_init_qry_var()
#               LET g_qryparam.form ="q_imd02_1"
#               LET g_qryparam.arg1 = g_rtz.rtz01
#               LET g_qryparam.default1 = g_rtz.rtz07
#               CALL cl_create_qry() RETURNING g_rtz.rtz07
                CALL q_imd_1(FALSE,TRUE,g_rtz.rtz08,"",g_rtz.rtz01,'Y',"") RETURNING g_rtz.rtz07
#No.FUN-AA0062  --End
               DISPLAY BY NAME g_rtz.rtz07
               NEXT FIELD rtz07    
            WHEN INFIELD(rtz10) 
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_ryf"
               LET g_qryparam.default1 = g_rtz.rtz10
               CALL cl_create_qry() RETURNING g_rtz.rtz10
               DISPLAY BY NAME g_rtz.rtz10
               NEXT FIELD rtz10
            WHEN INFIELD(rtz25) 
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_nma"
               LET g_qryparam.default1 = g_rtz.rtz25
               CALL cl_create_qry() RETURNING g_rtz.rtz25
               DISPLAY BY NAME g_rtz.rtz25
               NEXT FIELD rtz25    
            WHEN INFIELD(rtz29) 
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_occ02"
               LET g_qryparam.default1 = g_rtz.rtz29
               CALL cl_create_qry() RETURNING g_rtz.rtz29
               DISPLAY BY NAME g_rtz.rtz29
               NEXT FIELD rtz29    
 
         OTHERWISE 
            EXIT CASE
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


FUNCTION i200_bp_refresh()
  DISPLAY ARRAY g_screen1 TO s_screen1.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
  DISPLAY ARRAY g_screen2 TO s_screen2.* ATTRIBUTE(COUNT=g_rec_b2,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY 
END FUNCTION


FUNCTION i200_rtz02()
   DEFINE l_tqa02   LIKE tqa_file.tqa02
   DEFINE l_tqaacti LIKE tqa_file.tqaacti

   SELECT tqa02,tqaacti INTO l_tqa02,l_tqaacti FROM tqa_file
    WHERE tqa01 = g_rtz.rtz02
      AND tqa03 = '14'
   CASE 
      WHEN SQLCA.sqlcode = 100 LET g_errno = 'atm-001'
                               LET l_tqa02 = ' '
      WHEN l_tqaacti = 'N'     LET g_errno = 'art-942'
   OTHERWISE  LET g_errno = SQLCA.sqlcode USING '-------'
   END CASE
   DISPLAY l_tqa02 TO FORMONLY.tqa02
   LET sr.tqa02 = l_tqa02
END FUNCTION

FUNCTION i200_rtz04()
   DEFINE l_rtd02   LIKE rtd_file.rtd02
   DEFINE l_rtdacti LIKE rtd_file.rtdacti
   DEFINE l_rtdconf LIKE rtd_file.rtdconf

   SELECT rtd02,rtdacti,rtdconf INTO l_rtd02,l_rtdacti,l_rtdconf FROM rtd_file
    WHERE rtd01 = g_rtz.rtz04
   CASE 
      WHEN SQLCA.sqlcode = 100 LET g_errno = 'art-937'
                               LET l_rtd02 = ' '
      WHEN l_rtdacti = 'N'     LET g_errno = 'art-943'
      WHEN l_rtdconf = 'N'     LET g_errno = 'art-944' 
   OTHERWISE  LET g_errno = SQLCA.sqlcode USING '-------'
   END CASE
   DISPLAY l_rtd02 TO FORMONLY.rtd02
   LET sr.rtd02 = l_rtd02
END FUNCTION

FUNCTION i200_rtz05()
   DEFINE l_rtf02   LIKE rtf_file.rtf02
   DEFINE l_rtfacti LIKE rtf_file.rtfacti
   DEFINE l_rtfconf LIKE rtf_file.rtfconf

   SELECT rtf02,rtfacti,rtfconf INTO l_rtf02,l_rtfacti,l_rtfconf FROM rtf_file
    WHERE rtf01 = g_rtz.rtz05
   CASE 
      WHEN SQLCA.sqlcode = 100 LET g_errno = 'art-342'
                               LET l_rtf02 = ' '
      WHEN l_rtfconf = 'N'     LET g_errno = 'art-140'
      WHEN l_rtfacti = 'N'     LET g_errno = 'art-945'
   OTHERWISE  LET g_errno = SQLCA.sqlcode USING '-------'
   END CASE
   DISPLAY l_rtf02 TO FORMONLY.rtf02
   LET sr.rtf02 = l_rtf02
END FUNCTION

FUNCTION i200_rtz06()
   DEFINE l_occ02   LIKE occ_file.occ02
   DEFINE l_occacti LIKE occ_file.occacti
   SELECT occ02,occacti INTO l_occ02,l_occacti FROM occ_file
    WHERE occ01 = g_rtz.rtz06
   CASE 
      WHEN SQLCA.sqlcode = 100 LET g_errno = 'art-938'
                               LET l_occ02 = ' '
      WHEN l_occacti = 'N'     LET g_errno = 'art-946'
   OTHERWISE  LET g_errno = SQLCA.sqlcode USING '-------'
   END CASE
   DISPLAY l_occ02 TO FORMONLY.occ02
END FUNCTION

###-FUN-B40032- ADD - BEGIN ----------------------------------
###-檢查客戶資料中的按交款產生應收是否勾選-###
FUNCTION i200_rtz06_check()
DEFINE l_occ73 LIKE occ_file.occ73

   SELECT occ73 INTO l_occ73 FROM occ_file WHERE occ01 = g_rtz.rtz06
   IF l_occ73 <> 'Y' THEN
      CALL cl_err('','art-134',1)
   END IF
END FUNCTION
###-FUN-B40032- ADD -  END  ----------------------------------

FUNCTION i200_rtz08()
   DEFINE l_imd02_1 LIKE imd_file.imd02
   DEFINE l_imdacti LIKE imd_file.imdacti
   SELECT imd02,imdacti INTO l_imd02_1,l_imdacti FROM imd_file
    WHERE imd01 = g_rtz.rtz08
      AND imd20 = g_rtz.rtz01
      AND imd01 IN (SELECT jce02 FROM jce_file)
   CASE 
      WHEN SQLCA.sqlcode = 100 LET g_errno = 'aic-217'
                               LET l_imd02_1 = ' '
      WHEN l_imdacti = 'N'     LET g_errno = 'art-947'
   OTHERWISE  LET g_errno = SQLCA.sqlcode USING '-------'
   END CASE
   DISPLAY l_imd02_1 TO FORMONLY.imd02_1
END FUNCTION

FUNCTION i200_rtz07()
   DEFINE l_imd02_2 LIKE imd_file.imd02
   DEFINE l_imdacti LIKE imd_file.imdacti
   SELECT imd02,imdacti INTO l_imd02_2,l_imdacti FROM imd_file
    WHERE imd01 = g_rtz.rtz07
      AND imd20 = g_rtz.rtz01
      AND imd01 NOT IN (SELECT jce02 FROM jce_file)
   CASE 
      WHEN SQLCA.sqlcode = 100 LET g_errno = 'aic-218'
                               LET l_imd02_2 = ' '
      WHEN l_imdacti = 'N'     LET g_errno = 'art-948'
   OTHERWISE  LET g_errno = SQLCA.sqlcode USING '-------'
   END CASE
   DISPLAY l_imd02_2 TO FORMONLY.imd02_2
END FUNCTION

FUNCTION i200_rtz10()
   DEFINE l_ryf02 LIKE ryf_file.ryf02
   DEFINE l_ryf03 LIKE ryf_file.ryf03
   DEFINE l_ryb02 LIKE ryb_file.ryb02
   DEFINE l_ryfacti LIKE ryf_file.ryfacti
   SELECT ryf02,ryf03,ryfacti INTO l_ryf02,l_ryf03,l_ryfacti FROM ryf_file
    WHERE ryf01 = g_rtz.rtz10
   CASE 
      WHEN SQLCA.sqlcode = 100 LET g_errno = 'art-344'
                               LET l_ryf02 = ' '
                               LET l_ryf03 = ' '
      WHEN l_ryfacti = 'N'     LET g_errno = 'art-949'
   OTHERWISE  LET g_errno = SQLCA.sqlcode USING '-------'
   END CASE
   DISPLAY l_ryf02 TO FORMONLY.ryf02

   SELECT ryb02 INTO l_ryb02 FROM ryb_file
    WHERE ryb01 = l_ryf03
   DISPLAY l_ryb02 TO FORMONLY.ryb02
END FUNCTION


FUNCTION i200_rtz25()
   DEFINE l_nma02   LIKE nma_file.nma02
   DEFINE l_nmaacti LIKE nma_file.nmaacti
   SELECT nma02,nma04,nma44,nmaacti INTO l_nma02,g_rtz.rtz26,g_rtz.rtz27,l_nmaacti FROM nma_file
    WHERE nma01 = g_rtz.rtz25
   CASE 
      WHEN SQLCA.sqlcode = 100 LET g_errno = 'aap-007'
                               LET l_nma02 = ' '
                               LET g_rtz.rtz26 = ' '
                               LET g_rtz.rtz27 = ' '
      WHEN l_nmaacti = 'N'     LET g_errno = 'axr-093'
   OTHERWISE  LET g_errno = SQLCA.sqlcode USING '-------'
   END CASE
   DISPLAY l_nma02,g_rtz.rtz26,g_rtz.rtz27 TO FORMONLY.nma02,rtz26,rtz27
END FUNCTION

FUNCTION i200_rtz01()
   DEFINE l_azw08 LIKE azw_file.azw08
   SELECT azw08 INTO l_azw08 FROM azw_file
    WHERE azw01 = g_rtz.rtz01
   DISPLAY l_azw08 TO FORMONLY.azw08
   LET sr.azw08 = l_azw08
END FUNCTION

FUNCTION i200_tqa02()
   DEFINE l_tqa02 LIKE tqa_file.tqa02
   SELECT tqa02 INTO l_tqa02 FROM tqa_file
    WHERE tqa01 = g_rtz.rtz02
      AND tqa03 = '14'
      AND tqaacti = 'Y'
   DISPLAY l_tqa02 TO FORMONLY.tqa02
END FUNCTION

FUNCTION i200_azw07()
   DEFINE l_azw08_2 LIKE azw_file.azw08
   DEFINE l_azw07   LIKE azw_file.azw07
   SELECT azw07 INTO l_azw07 FROM azw_file
    WHERE azw01 = g_rtz.rtz01
   SELECT azw08 INTO l_azw08_2 FROM azw_file
    WHERE azw01 = l_azw07
   DISPLAY l_azw07,l_azw08_2 TO FORMONLY.azw07,FORMONLY.azw08_2
   LET sr.azw08_2 = l_azw08_2
   LET sr.azw07   = l_azw07
END FUNCTION

FUNCTION i200_confirm()
   IF g_rtz.rtz01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
   #add FUN-AB0078
  #IF NOT s_chk_ware(g_rtz.rtz08) THEN #检查仓库是否属于当前门店       #TQC-AC0114
   IF NOT s_chk_ware1(g_rtz.rtz08,g_rtz.rtz01) THEN                    #TQC-AC0114
      LET g_success='N'
      RETURN
   END IF
  #IF NOT s_chk_ware(g_rtz.rtz07) THEN #检查仓库是否属于当前门店       #TQC-AC0114 
   IF NOT s_chk_ware1(g_rtz.rtz07,g_rtz.rtz01) THEN                    #TQC-AC0114
      LET g_success='N'
      RETURN
   END IF
   #end FUN-AB0078
   IF g_rtz.rtz28 = 'Y' THEN
      CALL cl_err("",9023,1)
      RETURN
   ELSE
      IF cl_confirm('aap-222')  THEN
#CHI-C30107 --------------- add --------------- begin
         SELECT * INTO g_rtz.* FROM rtz_file WHERE rtz01 = g_rtz.rtz01
         IF g_rtz.rtz28 = 'Y' THEN
            CALL cl_err("",9023,1)
            RETURN
         END IF
#CHI-C30107 --------------- add --------------- end
         BEGIN WORK
        #FUN-B70075  str-----
         OPEN i200_cl USING g_rtz.rtz01
         IF STATUS THEN
            CALL cl_err("OPEN i200_cl:", STATUS, 1)
            CLOSE i200_cl
            ROLLBACK WORK
            RETURN
         END IF

         FETCH i200_cl INTO g_rtz.*
         IF SQLCA.sqlcode THEN
            CALL cl_err(g_rtz.rtz01,SQLCA.sqlcode,0)
            CLOSE i200_cl
            ROLLBACK WORK
            RETURN
         END IF
        #FUN-B70075  end-----          
         UPDATE rtz_file SET rtz28 = 'Y'
          WHERE rtz01 = g_rtz.rtz01
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","rtz_file",g_rtz.rtz01,"",SQLCA.sqlcode,"","",1)
            ROLLBACK WORK
            RETURN
         ELSE
            LET g_rtz.rtz28 = 'Y'
            DISPLAY BY NAME g_rtz.rtz28
            COMMIT WORK
         END IF
          COMMIT WORK
      END IF
   END IF
END FUNCTION

FUNCTION i200_undo_confirm()
   DEFINE l_n LIKE type_file.num5
   IF g_rtz.rtz01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
   IF g_rtz.rtz28 = 'N' THEN
      CALL cl_err("",9025,1)
      RETURN
   END IF

   LET l_n = 0
   SELECT COUNT(*) INTO l_n FROM lmb_file
    WHERE lmbstore = g_rtz.rtz01
      AND lmb02 IS NOT NULL
   IF l_n > 0 THEN
      CALL cl_err("",'alm-018',1)
      RETURN
   END IF

   LET l_n = 0
   SELECT COUNT(*) INTO l_n FROM lnl_file
    WHERE lnlstore = g_rtz.rtz01
   IF l_n > 0 THEN
      CALL cl_err("",'alm-503',1)
      RETURN
   END IF

   LET l_n = 0 
   SELECT COUNT(*) INTO l_n FROM lnm_file
    WHERE lnmstore = g_rtz.rtz01
   IF l_n > 0 THEN
      CALL cl_err("",'alm-504',1)
      RETURN
   END IF

#FUN-C50036 add begin ---
   LET l_n = 0
   SELECT COUNT(*) INTO l_n FROM ryg_file
    WHERE ryg01 = g_rtz.rtz01
   IF l_n > 0 THEN
      CALL cl_err("",'alm1624',1)
      RETURN
   END IF
#FUN-C50036 add end -----

   IF (cl_confirm('alm-008')) THEN
     #FUN-B70075  str-----
      IF g_aza.aza88 = 'Y' THEN
         IF g_rtz_t.rtzpos <> '1' THEN
            LET g_rtz.rtzpos='2'
         ELSE
            LET g_rtz.rtzpos='1'
         END IF
         DISPLAY BY NAME g_rtz.rtzpos 
      END IF 
     #FUN-B70075  end-----   
      BEGIN WORK
     #FUN-B70075  str-----
      OPEN i200_cl USING g_rtz.rtz01
      IF STATUS THEN
         CALL cl_err("OPEN i200_cl:", STATUS, 1)
         CLOSE i200_cl
         ROLLBACK WORK
         RETURN
      END IF

      FETCH i200_cl INTO g_rtz.*
      IF SQLCA.sqlcode THEN
         CALL cl_err(g_rtz.rtz01,SQLCA.sqlcode,0)
         CLOSE i200_cl
         ROLLBACK WORK
         RETURN
      END IF  
     #FUN-B70075  end-----       
      UPDATE rtz_file SET rtz28 = 'N',
                          rtzpos = g_rtz.rtzpos            #FUN-B70075   add g_rtz.rtzpos      
       WHERE rtz01 = g_rtz.rtz01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","rtz_file",g_rtz.rtz01,"",SQLCA.sqlcode,"","",1)
         ROLLBACK WORK
         LET g_rtz.rtzpos = g_rtz_t.rtzpos         #FUN-B70075
         DISPLAY BY NAME g_rtz.rtzpos              #FUN-B70075
         RETURN
      ELSE
         LET g_rtz.rtz28 = 'N'
         DISPLAY BY NAME g_rtz.rtz28,g_rtz.rtzpos          #FUN-B70075add g_rtz.rtzpos
      END IF
      COMMIT WORK
   END IF
END FUNCTION



#这个函数是Crystal Report报表，但是在本程序中未被调用，本程序调用的是p_query报表i200_out2()
#如果要换成Crystal Report报表，则可以直接调用该函数，已实现
#FUNCTION i200_out()
#   DEFINE l_table STRING
#   DEFINE l_sql   STRING
#   DEFINE g_str   STRING
#   
#   LET g_sql = "rtz01.rtz_file.rtz01,",
#               "azw08.azw_file.azw08,",
#               "rtz13.rtz_file.rtz13,",
#               "azw07.azw_file.azw07,",
#               "azw08_2.azw_file.azw08,",
#               "rtz12.rtz_file.rtz12,",
#               "rtz03.rtz_file.rtz03,",
#               "rtz02.rtz_file.rtz02,",
#               "tqa02.tqa_file.tqa02,",
#               "rtz28.rtz_file.rtz28,",
#               "rtz11.rtz_file.rtz11,",
#               "rtz04.rtz_file.rtz04,",
#               "rtd02.rtd_file.rtd02,",
#               "rtz05.rtz_file.rtz05,",
#               "rtf02.rtf_file.rtf02,",
#               "rtz18.rtz_file.rtz18,",
#               "rtz19.rtz_file.rtz19,",
#               "rtz17.rtz_file.rtz17,",
#               "rtz21.rtz_file.rtz21"
#   LET l_table = cl_prt_temptable('arti200',g_sql) CLIPPED
#   IF l_table = -1 THEN
#      EXIT PROGRAM 
#   END IF
#   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
#               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?)"
#   PREPARE insert_prep FROM g_sql
#   IF STATUS THEN
#      CALL cl_err('insert_prep:',status,1) 
#      EXIT PROGRAM
#   END IF
#
#   CALL cl_del_data(l_table)
#
#   LET sr.rtz01   = g_rtz.rtz01
#   LET sr.rtz13   = g_rtz.rtz13
#   LET sr.rtz12   = g_rtz.rtz12
#   LET sr.rtz03   = g_rtz.rtz03
#   LET sr.rtz02   = g_rtz.rtz02
#   LET sr.rtz28   = g_rtz.rtz28
#   LET sr.rtz11   = g_rtz.rtz11
#   LET sr.rtz04   = g_rtz.rtz04
#   LET sr.rtz05   = g_rtz.rtz05
#   LET sr.rtz18   = g_rtz.rtz18
#   LET sr.rtz19   = g_rtz.rtz19
#   LET sr.rtz17   = g_rtz.rtz17
#   LET sr.rtz21   = g_rtz.rtz21
#  
#   EXECUTE insert_prep USING sr.*
#  
#   LET g_str = g_wc
#   LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED
#   CALL cl_prt_cs3('arti200','arti200',l_sql,g_str)
#
#END FUNCTION



#FUNCTION i200_x()
#   IF g_rtz.rtz01 IS NULL THEN
#      CALL cl_err("",-400,1)
#      RETURN
#   END IF
#  
#   BEGIN WORK
#   OPEN i200_cl USING g_rtz.rtz01
#   IF STATUS THEN
#      CALL cl_err("",STATUS,0)
#      CLOSE i200_cl
#      ROLLBACK WORK
#      RETURN
#   END IF
# 
#   FETCH i200_cl INTO g_rtz.*
#   IF SQLCA.sqlcode THEN
#      CALL cl_Err("",SQLCA.sqlcode,1)
#      RETURN
#   END IF
# 
#   IF cl_exp(0,0,g_rtz.rtzacti) THEN
#      LET g_chr = g_rtz.rtzacti
#      IF g_rtz.rtzacti = 'Y' THEN
#         LET g_rtz.rtzacti = 'N'
#      ELSE
#         LET g_rtz.rtzacti = 'Y'
#      END IF
#      
#      UPDATE rtz_file SET rtzacti = g_rtz.rtzacti 
#       WHERE rtz01 = g_rtz.rtz01
#      IF SQLCA.SQLERRD[3] = 0 THEN
#         CALL cl_err("",SQLCA.sqlcode,0)
#         LET g_rtz.rtzacti = g_chr
#         DISPLAY BY NAME g_rtz.rtzacti 
#         CLOSE i200_cl
#         ROLLBACK WORK
#         RETURN
#      END IF
#      DISPLAY BY NAME g_rtz.rtzacti
#   END IF
#  
#   CLOSE i200_cl
#   COMMIT WORK
#END FUNCTION


#这里用的是p_query报表
FUNCTION i200_out2()
    DEFINE l_cmd  LIKE type_file.chr1000
    IF g_rtz.rtz01 IS NULL THEN CALL cl_err('',-400,1) RETURN END IF
    IF cl_null(g_wc) THEN LET g_wc = " 1=1" END IF
    LET l_cmd = 'p_query "arti200" "',g_wc CLIPPED,'" '                    #Mod By shi
    CALL cl_cmdrun(l_cmd)
END FUNCTION

#FUN-A80148--add-str
FUNCTION i200_set_entry(p_cmd)
DEFINE p_cmd   LIKE type_file.chr1
IF p_cmd ='u' THEN
 CALL cl_set_comp_entry("rtz13,rtz12,rtz03,rtz02,rtz11,
                    rtz04,rtz05,rtz06,rtz08,rtz07,rtz09,
                    rtz18,rtz19,rtz14,rtz15,rtz10,rtz16,rtz17,rtz20,rtz21,
                    rtz25 ",TRUE) 
END IF                       
END FUNCTION

FUNCTION i200_set_no_entry(p_cmd)
DEFINE p_cmd   LIKE type_file.chr1

IF p_cmd ='u' THEN
CALL cl_set_comp_entry("rtz01,rtz13,rtz12,rtz03,rtz02,rtz28,rtz11,rtzpos,
                      rtzuser,rtzgrup,rtzoriu,rtzorig,rtzmodu,rtzcrat,
                      rtz04,rtz05,rtz06,rtz08,rtz07,rtz09,
                      rtz18,rtz19,rtz14,rtz15,rtz10,rtz16,rtz17,rtz20,rtz21,
                      rtz22,rtz23,rtz24,rtz25,rtz26,rtz27 ",FALSE) 
END IF                       
END FUNCTION

#FUN-D10021--add--str---
FUNCTION i200_set(p_rtz01)
DEFINE l_n       LIKE type_file.num5
DEFINE l_rtz28   LIKE rtz_file.rtz28
DEFINE p_rtz01   LIKE rtz_file.rtz01
   
   CALL s_showmsg_init()

   OPEN WINDOW arti200a_w WITH FORM "art/42f/arti200a"
          ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_locale("arti200a")

   SELECT * INTO g_rtz.* FROM rtz_file WHERE rtz01 = p_rtz01

   #初始化
   LET g_set.gys     = 'Y'
   LET g_set.khzl    = 'Y'
   LET g_set.khdj    = 'Y'
   LET g_set.jyjg    = 'Y'
   LET g_set.cgcl    = 'Y'
   LET g_set.ckzl    = 'Y'
   LET g_set.poscs   = 'Y'
   LET g_set.posjh   = 'Y'
   LET g_set.posmdcs = 'Y'
   LET g_set.posmdjh = 'Y'
   LET g_set.card    = 'Y'    #FUN-D10117 add
   LET g_set.coupon  = 'Y'    #FUN-D10117 add
   LET g_set.promote = 'Y'    #FUN-D10117 add
   DISPLAY g_set.* TO gys,khzl,khdj,jyjg,cgcl,ckzl,poscs,posjh,posmdcs,posmdjh,
                      card,coupon,promote     #FUN-D10117 add
   
   INPUT g_rtz01,g_set.* WITHOUT DEFAULTS FROM
         rtz01,gys,khzl,khdj,jyjg,cgcl,ckzl,poscs,posjh,posmdcs,posmdjh,
         card,coupon,promote     #FUN-D10117 add 

      AFTER FIELD rtz01
         IF NOT cl_null(g_rtz01) THEN
            SELECT COUNT(*) INTO l_n FROM rtz_file WHERE rtz01 = g_rtz01
            SELECT rtz28 INTO l_rtz28 FROM rtz_file WHERE rtz01 = g_rtz01
            IF l_n < 1 OR l_rtz28 != 'Y' THEN  
               CALL cl_err(g_rtz01,'art1112',1)
               LET g_rtz01 = g_rtz01
               DISPLAY BY NAME g_rtz01
               NEXT FIELD rtz01
            END IF
         END IF

      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(rtz01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_rtz_1"
               LET g_qryparam.default1 = g_rtz01
               CALL cl_create_qry() RETURNING g_rtz01
               DISPLAY BY NAME  g_rtz01
               NEXT FIELD rtz01
            OTHERWISE EXIT CASE
         END CASE


      AFTER INPUT
         IF INT_FLAG THEN
            LET g_success = 'N'
            EXIT INPUT
         END IF

      #全部选择
      ON ACTION select_all 
         LET g_action_choice="select_all"
         CALL i200_y()

      #全部取消
      ON ACTION cancel_all
         LET g_action_choice="cancel_all"
         CALL i200_n()

   END INPUT

   IF INT_FLAG THEN
      LET INT_FLAG=0
      LET g_success = 'N'
      CLOSE WINDOW arti200a_w
      RETURN 
   END IF
   
   DROP TABLE pmc_temp
   SELECT * FROM pmc_file WHERE 1=0 INTO TEMP pmc_temp
   DROP TABLE occ_temp
   SELECT * FROM occ_file WHERE 1=0 INTO TEMP occ_temp
   DROP TABLE tqo_temp
   SELECT * FROM tqo_file WHERE 1=0 INTO TEMP tqo_temp
   DROP TABLE rtl_temp
   SELECT * FROM rtl_file WHERE 1=0 INTO TEMP rtl_temp
   DROP TABLE rty_temp
   SELECT * FROM rty_file WHERE 1=0 INTO TEMP rty_temp
   DROP TABLE imd_temp
   SELECT * FROM imd_file WHERE 1=0 INTO TEMP imd_temp
   DROP TABLE ryg_temp
   SELECT * FROM ryg_file WHERE 1=0 INTO TEMP ryg_temp
   DROP TABLE ryc_temp
   SELECT * FROM ryc_file WHERE 1=0 INTO TEMP ryc_temp
   DROP TABLE rze_temp
   SELECT * FROM rze_file WHERE 1=0 INTO TEMP rze_temp 

   CALL i200_set_pmc(p_rtz01)
   CALL i200_set_occ(p_rtz01)
   CALL i200_set_tqo(p_rtz01)
   CALL i200_set_rtl(p_rtz01)
   CALL i200_set_imd(p_rtz01)
   CALL i200_set_rty(p_rtz01)
   CALL i200_set_ryg(p_rtz01)
   CALL i200_set_ryc(p_rtz01)
   CALL i200_set_rze01(p_rtz01)
   CALL i200_set_rze02(p_rtz01)
   CALL i200_set_card(p_rtz01)     #FUN-D10117 add
   CALL i200_set_coupon(p_rtz01)   #FUN-D10117 add
   CALL i200_set_promote(p_rtz01)  #FUN-D10117 add

   CALL i200_set_upd(p_rtz01)

   CALL s_showmsg()
   CLOSE WINDOW arti200a_w
   CALL i200_show()
            
END FUNCTION             

#供应厂商资料
FUNCTION i200_set_pmc(l_rtz01)
DEFINE l_n       LIKE type_file.num5
DEFINE l_cnt     LIKE type_file.num5
DEFINE l_azw05   LIKE azw_file.azw05
DEFINE l_azw05_2 LIKE azw_file.azw05
DEFINE l_sql     STRING
DEFINE l_rtz01   LIKE rtz_file.rtz01

   IF g_set.gys = 'N' THEN RETURN END IF
   BEGIN WORK
   LET g_success = 'Y'

   SELECT azw05 INTO l_azw05 FROM azw_file
    WHERE azw01 = l_rtz01

   #检查当前门店对应的供应商资料是否存在
   LET l_n = 0
   LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_rtz01,'pmc_file'),
               " WHERE pmc01 = '",l_rtz01,"' "
   PREPARE sel_pmc_count_pre FROM l_sql
   EXECUTE sel_pmc_count_pre INTO l_n
   IF l_n < 1 THEN
      LET g_msg1 = cl_getmsg("art1102",g_lang) #供应商资料

      #将参考门店的资料复制到临时表中
      LET l_sql = " INSERT INTO pmc_temp ",
                  " SELECT * FROM ",cl_get_target_table(g_rtz01,'pmc_file')," WHERE pmc01 = '",g_rtz01,"' "
      PREPARE ins_pmc_temp_pre FROM l_sql
      EXECUTE ins_pmc_temp_pre

      #更新临时表中对应字段
      UPDATE pmc_temp SET pmc01 = l_rtz01,pmc04 = l_rtz01,pmc901 = l_rtz01,pmc930 = l_rtz01,
                          pmcuser = g_user,pmcgrup = g_grup,pmcmodu = g_user,pmcdate = g_today,
                          pmccrat = g_today,pmcoriu = g_user,pmcorig = g_grup
                             
      #将临时表资料Ins到数据库
      LET l_sql = " INSERT INTO ",cl_get_target_table(l_rtz01,'pmc_file'),
                  " SELECT * FROM pmc_temp"
      PREPARE trans_ins_pmc1 FROM l_sql
      EXECUTE trans_ins_pmc1
      LET l_cnt = SQLCA.sqlerrd[3]
      IF STATUS OR SQLCA.SQLCODE THEN
         LET g_msg2 = cl_getmsg("anm-973",g_lang),l_cnt
         CALL s_errmsg(g_msg1,g_msg2,'',SQLCA.sqlcode,1)
         LET g_success = 'N'
      ELSE
         #将新增的供应厂商资料抛转至系统下所有DB中
         LET l_sql = "SELECT DISTINCT azw05 FROM azw_file WHERE azw05 <> '",l_azw05,"'", 
                     "   AND azwacti = 'Y'"
         PREPARE i200_pmc_pre FROM l_sql
         DECLARE i200_pmc_curs CURSOR FOR i200_pmc_pre
         FOREACH i200_pmc_curs INTO l_azw05_2
            LET l_sql = " INSERT INTO ",l_azw05_2 CLIPPED,".pmc_file",
                        " SELECT * FROM pmc_temp"
            PREPARE trans_ins_pmc2 FROM l_sql
            EXECUTE trans_ins_pmc2
            LET l_cnt = l_cnt + SQLCA.sqlerrd[3]
            IF STATUS OR SQLCA.SQLCODE THEN
               LET g_msg3 = "db:",l_azw05_2
               CALL s_errmsg(g_msg1,g_msg3,'',SQLCA.sqlcode,1)
               LET g_success = 'N' 
               EXIT FOREACH
            END IF
         END FOREACH
         IF g_success = 'Y' THEN
            LET g_msg2 = cl_getmsg("anm-973",g_lang),l_cnt #成功笔数：
            IF l_cnt > 0 THEN
               CALL s_errmsg(g_msg1,g_msg2,'INSERT INTO pmc_file',SQLCA.sqlcode,2)
            ELSE
               CALL s_errmsg(g_msg1,g_msg2,'','art1113',2)   #參考門店無對應資料
            END IF
         END IF
      END IF
   ELSE
      LET l_cnt = 0
      LET g_msg1 = cl_getmsg("art1102",g_lang)
      LET g_msg2 = cl_getmsg("anm-973",g_lang),l_cnt
      CALL s_errmsg(g_msg1,g_msg2,'','art1101',1)  #已经存在此资料
   END IF
   IF g_success = 'Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF
END FUNCTION

#客戶資料
FUNCTION i200_set_occ(l_rtz01)
DEFINE l_n       LIKE type_file.num5
DEFINE l_cnt     LIKE type_file.num5
DEFINE l_azw05   LIKE azw_file.azw05
DEFINE l_azw05_2 LIKE azw_file.azw05
DEFINE l_sql     STRING
DEFINE l_rtz01   LIKE rtz_file.rtz01

   IF g_set.khzl = 'N' THEN RETURN END IF
   BEGIN WORK
   LET g_success = 'Y'

   SELECT azw05 INTO l_azw05 FROM azw_file
    WHERE azw01 = l_rtz01

   #检查当前门店对应的客戶資料是否存在
   LET l_n = 0
   LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_rtz01,'occ_file'),
               " WHERE occ01 = '",l_rtz01,"' "
   PREPARE sel_occ_count_pre FROM l_sql
   EXECUTE sel_occ_count_pre INTO l_n
   IF l_n < 1 THEN
      LET g_msg1 = cl_getmsg("art1103",g_lang)      #客戶資料
  
      #将参考门店的资料复制到临时表中
      LET l_sql = " INSERT INTO occ_temp ",
                  " SELECT * FROM ",cl_get_target_table(g_rtz01,'occ_file')," WHERE occ01 = '",g_rtz01,"' "
      PREPARE ins_occ_temp_pre FROM l_sql
      EXECUTE ins_occ_temp_pre

      #更新临时表中对应字段
      UPDATE occ_temp SET occ01 = l_rtz01,occ07 = l_rtz01,occ09 = l_rtz01,
                          occ930 = l_rtz01,occpos = '1',occuser = g_user,
                          occgrup = g_grup,occoriu = g_user,occorig = g_grup,
                          occmodu = g_user,occdate = g_today

      #将临时表资料Ins到数据库
      LET l_sql = " INSERT INTO ",cl_get_target_table(l_rtz01,'occ_file'),
                  " SELECT * FROM occ_temp"
      PREPARE trans_ins_occ1 FROM l_sql
      EXECUTE trans_ins_occ1
      LET l_cnt = SQLCA.sqlerrd[3]
      IF STATUS OR SQLCA.SQLCODE THEN
         LET g_msg2 = cl_getmsg("anm-973",g_lang),l_cnt
         CALL s_errmsg(g_msg1,g_msg2,'',SQLCA.sqlcode,1)
         LET g_success = 'N'
      ELSE
         #将新增的客戶資料抛转至系统下所有DB中            
         LET l_sql = "SELECT DISTINCT azw05 FROM azw_file WHERE azw05 <> '",l_azw05,"'",
                     "   AND azwacti = 'Y'"
         PREPARE i200_occ_pre FROM l_sql
         DECLARE i200_occ_curs CURSOR FOR i200_occ_pre
         FOREACH i200_occ_curs INTO l_azw05_2
            LET l_sql = " INSERT INTO ",l_azw05_2 CLIPPED,".occ_file",
                        " SELECT * FROM occ_temp"
            PREPARE trans_ins_occ2 FROM l_sql
            EXECUTE trans_ins_occ2
            LET l_cnt = l_cnt + SQLCA.sqlerrd[3]
            IF STATUS OR SQLCA.SQLCODE THEN
               LET g_msg3 = "db:",l_azw05_2
               CALL s_errmsg(g_msg1,g_msg3,'',SQLCA.sqlcode,1)
               LET g_success = 'N'
               EXIT FOREACH
            END IF
         END FOREACH
         IF g_success = 'Y' THEN
            LET g_msg2 = cl_getmsg("anm-973",g_lang),l_cnt     #成功笔数：
            IF l_cnt > 0 THEN
               CALL s_errmsg(g_msg1,g_msg2,'INSERT INTO occ_file',SQLCA.sqlcode,2)
            ELSE
               CALL s_errmsg(g_msg1,g_msg2,'','art1113',2)     #參考門店無對應資料
            END IF
         END IF
      END IF
   ELSE
      LET l_cnt = 0
      LET g_msg1 = cl_getmsg("art1103",g_lang)
      LET g_msg2 = cl_getmsg("anm-973",g_lang),l_cnt
      CALL s_errmsg(g_msg1,g_msg2,'','art1101',1)       #已经存在此资料
   END IF
   IF g_success = 'Y' THEN 
      COMMIT WORK 
   ELSE 
      ROLLBACK WORK 
   END IF
END FUNCTION

#客戶訂價
FUNCTION i200_set_tqo(l_rtz01)
DEFINE l_n       LIKE type_file.num5
DEFINE l_cnt     LIKE type_file.num5
DEFINE l_sql     STRING
DEFINE l_rtz01   LIKE rtz_file.rtz01

   IF g_set.khdj = 'N' THEN RETURN END IF
   BEGIN WORK
   LET g_success = 'Y'

   #检查当前门店对应的客戶訂價是否存在
   LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_rtz01,'tqo_file'),
               " WHERE tqo01 = '",l_rtz01,"' "
   PREPARE sel_tqo_count_pre FROM l_sql
   EXECUTE sel_tqo_count_pre INTO l_n
   IF l_n < 1 THEN
      #将参考门店的资料复制到临时表中
      LET l_sql = " INSERT INTO tqo_temp ",
                  " SELECT * FROM ",cl_get_target_table(g_rtz01,'tqo_file')," WHERE tqo01 = '",g_rtz01,"' "
      PREPARE ins_tqo_temp_pre FROM l_sql
      EXECUTE ins_tqo_temp_pre
         
      #更新临时表中对应字段
      UPDATE tqo_temp SET tqo01 = l_rtz01,tqo04 = l_rtz01,tqouser = g_user,
                          tqogrup = g_grup,tqomodu = g_user,tqodate = g_today,
                          tqooriu = g_user,tqoorig = g_grup

      #将临时表资料Ins到数据库
      LET l_sql = " INSERT INTO ",cl_get_target_table(l_rtz01,'tqo_file'),
                  " SELECT * FROM tqo_temp"
      PREPARE trans_ins_tqo FROM l_sql
      EXECUTE trans_ins_tqo
      LET l_cnt = SQLCA.sqlerrd[3]
      IF STATUS OR SQLCA.SQLCODE THEN
         LET g_msg1 = cl_getmsg("art1104",g_lang)         #客戶訂價
         LET g_msg2 = cl_getmsg("anm-973",g_lang),l_cnt   #成功笔数:
         CALL s_errmsg(g_msg1,g_msg2,'',SQLCA.sqlcode,1)
         LET g_success = 'N'
      ELSE
         LET g_msg1 = cl_getmsg("art1104",g_lang)        
         LET g_msg2 = cl_getmsg("anm-973",g_lang),l_cnt 
         IF l_cnt > 0 THEN
            CALL s_errmsg(g_msg1,g_msg2,'INSERT INTO tqo_file',SQLCA.sqlcode,2)
         ELSE
            CALL s_errmsg(g_msg1,g_msg2,'','art1113',2)   #參考門店無對應資料
         END IF
      END IF
   ELSE
      LET l_cnt = 0
      LET g_msg1 = cl_getmsg("art1104",g_lang)
      LET g_msg2 = cl_getmsg("anm-973",g_lang),l_cnt
      CALL s_errmsg(g_msg1,g_msg2,'','art1101',1)          #已经存在此资料
   END IF
   IF g_success = 'Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF
END FUNCTION

#營運中心交易價格
FUNCTION i200_set_rtl(l_rtz01)
DEFINE l_n       LIKE type_file.num5 
DEFINE l_cnt     LIKE type_file.num5
DEFINE l_sql     STRING
DEFINE l_rtz01   LIKE rtz_file.rtz01

   IF g_set.jyjg = 'N' THEN RETURN END IF
   BEGIN WORK
   LET g_success = 'Y'

   #检查当前门店对应的營運中心交易價格是否存在
   LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_rtz01,'rtl_file'),
               " WHERE rtl01 = '",l_rtz01,"' OR rtl03 = '",l_rtz01,"' "
   PREPARE sel_rtl_count_pre FROM l_sql
   EXECUTE sel_rtl_count_pre INTO l_n
   IF l_n < 1 THEN
      #将参考门店的资料复制到临时表中
      LET l_sql = " INSERT INTO rtl_temp ",
                  " SELECT * FROM ",cl_get_target_table(g_rtz01,'rtl_file')," WHERE rtl01 = '",g_rtz01,"' OR rtl03 = '",g_rtz01,"' "
      PREPARE ins_rtl_temp_pre FROM l_sql
      EXECUTE ins_rtl_temp_pre

      #更新临时表中对应字段 
      UPDATE rtl_temp SET rtl01 = l_rtz01,rtlcrat = g_today,rtldate = g_today,
                          rtlgrup = g_grup,rtlmodu = g_user,rtluser = g_user,rtlorig = g_grup,
                          rtloriu = g_user WHERE rtl01 = g_rtz01

      UPDATE rtl_temp SET rtl_temp.rtl03   = l_rtz01, 
                          rtl_temp.rtlcrat = g_today,
                          rtl_temp.rtldate = g_today,
                          rtl_temp.rtl02   = (SELECT COALESCE(MAX(b.rtl02)+1,1) FROM rtl_file b WHERE b.rtl01 = rtl_temp.rtl01),
                          rtl_temp.rtlgrup = g_grup,
                          rtl_temp.rtlmodu = g_user,
                          rtl_temp.rtluser = g_user,
                          rtl_temp.rtlorig = g_grup,
                          rtl_temp.rtloriu = g_user 
       WHERE rtl_temp.rtl03 = g_rtz01
         
      #将临时表资料Ins到数据库
      LET l_sql = " INSERT INTO ",cl_get_target_table(l_rtz01,'rtl_file'),
                  " SELECT * FROM rtl_temp"
      PREPARE trans_ins_rtl FROM l_sql
      EXECUTE trans_ins_rtl
      LET l_cnt = SQLCA.sqlerrd[3]
      IF STATUS OR SQLCA.SQLCODE THEN
         LET g_msg1 = cl_getmsg("art1105",g_lang)
         LET g_msg2 = cl_getmsg("anm-973",g_lang),l_cnt
         CALL s_errmsg(g_msg1,g_msg2,'',SQLCA.sqlcode,1)
         LET g_success = 'N'
      ELSE
         LET g_msg1 = cl_getmsg("art1105",g_lang)          #營運中心交易價格
         LET g_msg2 = cl_getmsg("anm-973",g_lang),l_cnt    #成功笔数:
         IF l_cnt > 0 THEN
            CALL s_errmsg(g_msg1,g_msg2,'INSERT INTO rtl_file',SQLCA.sqlcode,2)
         ELSE
            CALL s_errmsg(g_msg1,g_msg2,'','art1113',2)    #參考門店無對應資料
         END IF
      END IF
   ELSE
      LET l_cnt = 0
      LET g_msg1 = cl_getmsg("art1105",g_lang)
      LET g_msg2 = cl_getmsg("anm-973",g_lang),l_cnt
      CALL s_errmsg(g_msg1,g_msg2,'','art1101',1)          #已经存在此资料
   END IF
   IF g_success = 'Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF
END FUNCTION

#倉庫資料
FUNCTION i200_set_imd(l_rtz01)
DEFINE l_rtz07   LIKE rtz_file.rtz07
DEFINE l_rtz08   LIKE rtz_file.rtz08
DEFINE l_string  LIKE rtz_file.rtz01
DEFINE l_n       LIKE type_file.num5
DEFINE l_cnt     LIKE type_file.num5
DEFINE l_str     STRING
DEFINE l_sql     STRING
DEFINE l_rtz01   LIKE rtz_file.rtz01

   IF g_set.ckzl = 'N' THEN RETURN END IF
   BEGIN WORK
   LET g_success = 'Y'

   #當前倉庫為空時做倉庫的處理 
   IF NOT cl_null(g_rtz.rtz07) OR NOT cl_null(g_rtz.rtz08) THEN 
      ROLLBACK WORK
      LET l_cnt = 0
      LET g_msg1 = cl_getmsg("art1107",g_lang)
      LET g_msg2 = cl_getmsg("anm-973",g_lang),l_cnt
      CALL s_errmsg(g_msg1,g_msg2,'','art1101',1)          #已经存在此资料      
      RETURN
   END IF       
   #成本倉自動編碼
   CALL s_auno(g_rtz.rtz07,'C',l_rtz01) RETURNING g_rtz.rtz07,l_str
   IF cl_null(g_rtz.rtz07) THEN
      LET g_rtz.rtz07 = l_rtz01,"01"
   END IF

   SELECT rtz07 INTO l_rtz07 FROM rtz_file WHERE rtz01 = g_rtz01

   #检查当前门店对应的成本倉倉庫資料是否存在
   LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_rtz01,'imd_file'),
               " WHERE imd01 = '",g_rtz.rtz07,"'"
   PREPARE sel_imd_count_pre FROM l_sql
   EXECUTE sel_imd_count_pre INTO l_n 
   IF l_n < 1 THEN
      #将参考门店的资料复制到临时表中
      LET l_sql = " INSERT INTO imd_temp ",
                  " SELECT * FROM ",cl_get_target_table(g_rtz01,'imd_file')," WHERE imd01 = '",l_rtz07,"' "
      PREPARE ins_imd_temp_pre FROM l_sql
      EXECUTE ins_imd_temp_pre 

      #更新临时表中对应字段 
      UPDATE imd_temp SET imd01 = g_rtz.rtz07,imd20 = l_rtz01,imdpos = '1',imduser = g_user,
                          imdgrup = g_grup,imdmodu = g_user,imddate = g_today,
                          imdoriu = g_user,imdorig = g_grup WHERE imd01 = l_rtz07
 
      #将临时表资料Ins到数据库
      LET l_sql = " INSERT INTO ",cl_get_target_table(l_rtz01,'imd_file'),
                  " SELECT * FROM imd_temp"
      PREPARE trans_ins_imd FROM l_sql
      EXECUTE trans_ins_imd
      LET l_cnt = SQLCA.sqlerrd[3]
      IF STATUS OR SQLCA.SQLCODE THEN
         LET g_success = 'N'
         LET g_msg1 = cl_getmsg("art1107",g_lang)          #倉庫資料
         LET g_msg2 = cl_getmsg("anm-973",g_lang),l_cnt    #成功笔数：
         CALL s_errmsg(g_msg1,g_msg2,'',SQLCA.sqlcode,1)
         ROLLBACK WORK
         RETURN
      END IF
   ELSE
      ROLLBACK WORK
      LET l_cnt = 0
      LET g_msg1 = cl_getmsg("art1107",g_lang)
      LET g_msg2 = cl_getmsg("anm-973",g_lang),l_cnt
      CALL s_errmsg(g_msg1,g_msg2,'','art1101',1)          #已经存在此资料
      RETURN
   END IF

   #非成本倉自動編碼
   CALL s_auno(g_rtz.rtz08,'C',l_rtz01) RETURNING g_rtz.rtz08,l_str
   IF cl_null(g_rtz.rtz08) THEN
      LET g_rtz.rtz08 = l_rtz01,"02"
   END IF

   SELECT rtz08 INTO l_rtz08 FROM rtz_file WHERE rtz01 = g_rtz01

   #检查当前门店对应的非成本倉倉庫資料是否存在
   LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_rtz01,'imd_file'),
               " WHERE imd01 = '",g_rtz.rtz08,"'"
   PREPARE sel_imd_count_pre1 FROM l_sql
   EXECUTE sel_imd_count_pre1 INTO l_n
   IF l_n < 1 THEN
      DELETE FROM imd_temp
      #将参考门店的资料复制到临时表中
      LET l_sql = " INSERT INTO imd_temp ",
                  " SELECT * FROM ",cl_get_target_table(g_rtz01,'imd_file')," WHERE imd01 = '",l_rtz08,"' "
      PREPARE ins_imd_temp_pre1 FROM l_sql
      EXECUTE ins_imd_temp_pre1

      #更新临时表中对应字段
      UPDATE imd_temp SET imd01 = g_rtz.rtz08,imd20 = l_rtz01,imdpos = '1',imduser = g_user,
                          imdgrup = g_grup,imdmodu = g_user,imddate = g_today,
                          imdoriu = g_user,imdorig = g_grup WHERE imd01 = l_rtz08

      #新增一筆資料到axci500
      LET l_sql = " INSERT INTO ",cl_get_target_table(l_rtz01,'jce_file'),"(",
                  " jce01,jce02,jceuser,jcegrup,jcemodu,jcedate,jceorig,jceoriu) ", 
                  " VALUES(?,?,?,?,?,?,?,?) "
      PREPARE trans_ins_jce FROM l_sql
      EXECUTE trans_ins_jce USING g_rtz.rtz08,g_rtz.rtz08,g_user,g_grup,g_user,g_today,g_grup,g_user 

      #将临时表资料Ins到数据库
      LET l_sql = " INSERT INTO ",cl_get_target_table(l_rtz01,'imd_file'),
                  " SELECT * FROM imd_temp"
      PREPARE trans_ins_imd1 FROM l_sql
      EXECUTE trans_ins_imd1
      LET l_cnt = l_cnt + SQLCA.sqlerrd[3]
      IF STATUS OR SQLCA.SQLCODE THEN
         LET g_success = 'N'
         LET g_msg1 = cl_getmsg("art1107",g_lang)          #倉庫資料
         LET g_msg2 = cl_getmsg("anm-973",g_lang),l_cnt    #成功笔数：
         CALL s_errmsg(g_msg1,g_msg2,'',SQLCA.sqlcode,1)
         ROLLBACK WORK
         RETURN
      ELSE
         UPDATE rtz_file SET rtz07 = g_rtz.rtz07,rtz08 = g_rtz.rtz08 WHERE rtz01 = l_rtz01
         IF STATUS OR SQLCA.SQLCODE THEN
            LET g_success = 'N'
            LET l_cnt = 0
            LET g_msg1 = cl_getmsg("art1107",g_lang)
            LET g_msg2 = cl_getmsg("anm-973",g_lang),l_cnt
            CALL s_errmsg(g_msg1,g_msg2,'upd rtz_file rtz07,rtz08',SQLCA.sqlcode,1)
            ROLLBACK WORK
            RETURN
         END IF
      END IF
   ELSE 
      ROLLBACK WORK
      LET l_cnt = 0
      LET g_msg1 = cl_getmsg("art1107",g_lang)
      LET g_msg2 = cl_getmsg("anm-973",g_lang),l_cnt
      CALL s_errmsg(g_msg1,g_msg2,'','art1101',1)          #已经存在此资料
      RETURN
   END IF
   LET g_msg1 = cl_getmsg("art1107",g_lang)          #倉庫資料
   LET g_msg2 = cl_getmsg("anm-973",g_lang),l_cnt    #成功笔数：
   IF l_cnt > 0 THEN
      CALL s_errmsg(g_msg1,g_msg2,'INSERT INTO imd_file',SQLCA.sqlcode,2)
   ELSE
      CALL s_errmsg(g_msg1,g_msg2,'','art1113',2)    #參考門店無對應資料
   END IF
   IF g_success = 'Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF
   
END FUNCTION

#採購策略
FUNCTION i200_set_rty(l_rtz01)
DEFINE l_n       LIKE type_file.num5
DEFINE l_cnt     LIKE type_file.num5
DEFINE l_sql     STRING
DEFINE l_rtz01   LIKE rtz_file.rtz01

   IF g_set.cgcl = 'N' THEN RETURN END IF
   BEGIN WORK
   LET g_success = 'Y'

   #检查当前门店对应的採購策略是否存在
   LET l_sql = " SELECT COUNT(*) FROM ",cl_get_target_table(l_rtz01,'rty_file'),
               " WHERE rty01 = '",l_rtz01,"' "
   PREPARE sel_rty_count_pre FROM l_sql
   EXECUTE sel_rty_count_pre INTO l_n
   IF l_n < 1 THEN
      #将参考门店的资料复制到临时表中
      LET l_sql = " INSERT INTO rty_temp ",
                  " SELECT * FROM ",cl_get_target_table(g_rtz01,'rty_file')," WHERE rty01 = '",g_rtz01,"' "
      PREPARE ins_rty_temp_pre FROM l_sql
      EXECUTE ins_rty_temp_pre
      #更新临时表中对应字段 
      UPDATE rty_temp SET rty01 = l_rtz01,rty06 = '1',rty14 = g_rtz.rtz07,rty15 = g_rtz.rtz08

      #将临时表资料Ins到数据库
      LET l_sql = " INSERT INTO ",cl_get_target_table(l_rtz01,'rty_file'),
                  " SELECT * FROM rty_temp"
      PREPARE trans_ins_rty FROM l_sql
      EXECUTE trans_ins_rty
      LET l_cnt = SQLCA.sqlerrd[3]
      IF STATUS OR SQLCA.SQLCODE THEN
         LET g_msg1 = cl_getmsg("art1106",g_lang)              #採購策略
         LET g_msg2 = cl_getmsg("anm-973",g_lang),l_cnt        #成功笔数:
         CALL s_errmsg(g_msg1,g_msg2,'',SQLCA.sqlcode,1)
         LET g_success = 'N'
      ELSE
         LET g_msg1 = cl_getmsg("art1106",g_lang)           
         LET g_msg2 = cl_getmsg("anm-973",g_lang),l_cnt   
         IF l_cnt > 0 THEN
            CALL s_errmsg(g_msg1,g_msg2,'INSERT INTO rty_file',SQLCA.sqlcode,2)
         ELSE
            CALL s_errmsg(g_msg1,g_msg2,'','art1113',2)        #參考門店無對應資料
         END IF
      END IF
   ELSE
      LET l_cnt = 0
      LET g_msg1 = cl_getmsg("art1106",g_lang)
      LET g_msg2 = cl_getmsg("anm-973",g_lang),l_cnt
      CALL s_errmsg(g_msg1,g_msg2,'','art1101',1)              #已經存在此資料
   END IF
   IF g_success = 'Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF
END FUNCTION

#POS傳輸設置
FUNCTION i200_set_ryg(l_rtz01)
DEFINE l_n       LIKE type_file.num5
DEFINE l_cnt     LIKE type_file.num5
DEFINE l_sql     STRING
DEFINE l_rtz01   LIKE rtz_file.rtz01
 
   IF g_set.poscs = 'N' THEN RETURN END IF
   BEGIN WORK
   LET g_success = 'Y'

   #检查当前门店对应的POS傳輸設置是否存在
   LET l_sql = " SELECT COUNT(*) FROM ",cl_get_target_table(l_rtz01,'ryg_file'),
               " WHERE ryg01 = '",l_rtz01,"' "
   PREPARE sel_ryg_count_pre FROM l_sql
   EXECUTE sel_ryg_count_pre INTO l_n
   IF l_n < 1 THEN
      #将参考门店的资料复制到临时表中
      LET l_sql = " INSERT INTO ryg_temp ",
                  " SELECT * FROM ",cl_get_target_table(g_rtz01,'ryg_file')," WHERE ryg01 = '",g_rtz01,"' " 
      PREPARE ins_ryg_temp_pre FROM l_sql
      EXECUTE ins_ryg_temp_pre
      #更新临时表中对应字段
      UPDATE ryg_temp SET ryg01 = l_rtz01,rygcrat = g_today,rygdate = g_today,ryguser = g_user,
                          ryggrup = g_grup,rygmodu = g_user,rygorig = g_grup,rygoriu = g_user
      UPDATE ryg_temp SET ryg03 = l_rtz01 WHERE ryg03 = g_rtz01

      #将临时表资料Ins到数据库
      LET l_sql = " INSERT INTO ",cl_get_target_table(l_rtz01,'ryg_file'),
                  " SELECT * FROM ryg_temp"
      PREPARE trans_ins_ryg FROM l_sql
      EXECUTE trans_ins_ryg
      LET l_cnt = SQLCA.sqlerrd[3]
      IF STATUS OR SQLCA.SQLCODE THEN
         LET g_msg1 = cl_getmsg("art1108",g_lang)              #POS傳輸設置
         LET g_msg2 = cl_getmsg("anm-973",g_lang),l_cnt        #成功笔数:
         CALL s_errmsg(g_msg1,g_msg2,'',SQLCA.sqlcode,1)
         LET g_success = 'N'
      ELSE
         LET g_msg1 = cl_getmsg("art1108",g_lang)       
         LET g_msg2 = cl_getmsg("anm-973",g_lang),l_cnt      
         IF l_cnt > 0 THEN
            CALL s_errmsg(g_msg1,g_msg2,'INSERT INTO ryg_file',SQLCA.sqlcode,2)
         ELSE
            CALL s_errmsg(g_msg1,g_msg2,'','art1113',2)        #參考門店無對應資料
         END IF
      END IF
   ELSE
      LET l_cnt = 0
      LET g_msg1 = cl_getmsg("art1108",g_lang)
      LET g_msg2 = cl_getmsg("anm-973",g_lang),l_cnt
      CALL s_errmsg(g_msg1,g_msg2,'','art1101',1)              #已經存在此資料
   END IF
   IF g_success = 'Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF
END FUNCTION

#POS機號資料
FUNCTION i200_set_ryc(l_rtz01)
DEFINE l_n       LIKE type_file.num5
DEFINE l_cnt     LIKE type_file.num5
DEFINE l_sql     STRING
DEFINE l_rtz01   LIKE rtz_file.rtz01

   IF g_set.posjh = 'N' THEN RETURN END IF
   BEGIN WORK
   LET g_success = 'Y'

   #检查当前门店对应的POS機號資料是否存在
   LET l_sql = " SELECT COUNT(*) FROM ",cl_get_target_table(l_rtz01,'ryc_file'),
               "  WHERE ryc01 = '",l_rtz01,"' "
   PREPARE sel_ryc_count_pre FROM l_sql
   EXECUTE sel_ryc_count_pre INTO l_n
   IF l_n < 1 THEN
      #将参考门店的资料复制到临时表中
      LET l_sql = " INSERT INTO ryc_temp ",
                  " SELECT * FROM ",cl_get_target_table(g_rtz01,'ryc_file')," WHERE ryc01 = '",g_rtz01,"' "
      PREPARE ins_ryc_temp_pre FROM l_sql
      EXECUTE ins_ryc_temp_pre
      #更新临时表中对应字段 
      UPDATE ryc_temp SET ryc01 = l_rtz01,rycpos = '1',ryccrat = g_today,rycdate = g_today,
                          rycgrup = g_grup,rycmodu = g_user,rycuser = g_user,rycorig = g_grup,rycoriu = g_user

      #将临时表资料Ins到数据库
      LET l_sql = " INSERT INTO ",cl_get_target_table(l_rtz01,'ryc_file'),
                  " SELECT * FROM ryc_temp"
      PREPARE trans_ins_ryc FROM l_sql
      EXECUTE trans_ins_ryc
      LET l_cnt = SQLCA.sqlerrd[3]
      IF STATUS OR SQLCA.SQLCODE THEN
         LET g_msg1 = cl_getmsg("art1109",g_lang)              #POS機號資料
         LET g_msg2 = cl_getmsg("anm-973",g_lang),l_cnt        #成功笔数:
         CALL s_errmsg(g_msg1,g_msg2,'',SQLCA.sqlcode,1)
         LET g_success = 'N'
      ELSE
         LET g_msg1 = cl_getmsg("art1109",g_lang)           
         LET g_msg2 = cl_getmsg("anm-973",g_lang),l_cnt    
         IF l_cnt > 0 THEN
            CALL s_errmsg(g_msg1,g_msg2,'INSERT INTO ryc_file',SQLCA.sqlcode,2)
         ELSE
            CALL s_errmsg(g_msg1,g_msg2,'','art1113',2)        #參考門店無對應資料
         END IF
      END IF
   ELSE
      LET l_cnt = 0
      LET g_msg1 = cl_getmsg("art1109",g_lang)
      LET g_msg2 = cl_getmsg("anm-973",g_lang),l_cnt
      CALL s_errmsg(g_msg1,g_msg2,'','art1101',1)              #已經存在此資料
   END IF
   IF g_success = 'Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF
END FUNCTION

#POS門店參數
FUNCTION i200_set_rze01(l_rtz01)
DEFINE l_n       LIKE type_file.num5
DEFINE l_cnt     LIKE type_file.num5
DEFINE l_sql     STRING
DEFINE l_rtz01   LIKE rtz_file.rtz01

   IF g_set.posmdcs = 'N' THEN RETURN END IF
   BEGIN WORK
   LET g_success = 'Y'

   #检查当前门店对应的POS門店參數是否存在
   LET l_sql = " SELECT COUNT(*) FROM ",cl_get_target_table(l_rtz01,'rze_file'),
               " WHERE rze01 = '",l_rtz01,"' AND rze02 = ' ' "
   PREPARE sel_rze_count_pre FROM l_sql
   EXECUTE sel_rze_count_pre INTO l_n
   IF l_n < 1 THEN
      #将参考门店的资料复制到临时表中
      DELETE FROM rze_temp
      LET l_sql = " INSERT INTO rze_temp ",
                  " SELECT * FROM ",cl_get_target_table(g_rtz01,'rze_file')," WHERE rze01 = '",g_rtz01,"' AND rze02 = ' ' "
      PREPARE ins_rze_temp_pre FROM l_sql
      EXECUTE ins_rze_temp_pre
      #更新临时表中对应字段
      UPDATE rze_temp SET rze01 = l_rtz01,rzepos = '1'

      #将临时表资料Ins到数据库
      LET l_sql = " INSERT INTO ",cl_get_target_table(l_rtz01,'rze_file'),
                  " SELECT * FROM rze_temp"
      PREPARE trans_ins_rze1 FROM l_sql
      EXECUTE trans_ins_rze1
      LET l_cnt = SQLCA.sqlerrd[3]
      IF STATUS OR SQLCA.SQLCODE THEN
         LET g_msg1 = cl_getmsg("art1110",g_lang)                   #POS門店參數
         LET g_msg2 = cl_getmsg("anm-973",g_lang),l_cnt             #成功笔数:
         CALL s_errmsg(g_msg1,g_msg2,'',SQLCA.sqlcode,1)
         LET g_success = 'N'
      ELSE
         LET g_msg1 = cl_getmsg("art1110",g_lang)         
         LET g_msg2 = cl_getmsg("anm-973",g_lang),l_cnt  
         IF l_cnt > 0 THEN
            CALL s_errmsg(g_msg1,g_msg2,'INSERT INTO rze_file',SQLCA.sqlcode,2)
         ELSE
            CALL s_errmsg(g_msg1,g_msg2,'','art1113',2)             #參考門店無對應資料
         END IF
      END IF
   ELSE
      LET l_cnt = 0
      LET g_msg1 = cl_getmsg("art1110",g_lang)
      LET g_msg2 = cl_getmsg("anm-973",g_lang),l_cnt
      CALL s_errmsg(g_msg1,g_msg2,'','art1101',1)                   #已經存在此資料
   END IF
   IF g_success = 'Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF
END FUNCTION

#POS門店機號參數
FUNCTION i200_set_rze02(l_rtz01)
DEFINE l_n       LIKE type_file.num5
DEFINE l_cnt     LIKE type_file.num5
DEFINE l_sql     STRING
DEFINE l_rtz01   LIKE rtz_file.rtz01

   IF g_set.posmdjh = 'N' THEN RETURN END IF
   BEGIN WORK
   LET g_success = 'Y'
 
   #检查当前门店对应的POS門店機號參數是否存在
   LET l_sql = " SELECT COUNT(*) FROM ",cl_get_target_table(l_rtz01,'rze_file'),
               "  WHERE rze01 = '",l_rtz01,"' AND rze02 != ' ' "
   PREPARE sel_rze_count_pre1 FROM l_sql
   EXECUTE sel_rze_count_pre1 INTO l_n
   IF l_n < 1 THEN
      #将参考门店的资料复制到临时表中
      DELETE FROM rze_temp
      LET l_sql = " INSERT INTO rze_temp ",
                  " SELECT * FROM ",cl_get_target_table(g_rtz01,'rze_file')," WHERE rze01 = '",g_rtz01,"' AND rze02 != ' ' "
      PREPARE ins_rze_temp_pre1 FROM l_sql
      EXECUTE ins_rze_temp_pre1
      #更新临时表中对应字段
      UPDATE rze_temp SET rze01 = l_rtz01,rzepos = '1'
      #将临时表资料Ins到数据库
      LET l_sql = " INSERT INTO ",cl_get_target_table(l_rtz01,'rze_file'),
                  " SELECT * FROM rze_temp"
      PREPARE trans_ins_rze2 FROM l_sql
      EXECUTE trans_ins_rze2
      LET l_cnt = SQLCA.sqlerrd[3]
      IF STATUS OR SQLCA.SQLCODE THEN
         LET g_msg1 = cl_getmsg("art1111",g_lang)              #POS門店機號參數
         LET g_msg2 = cl_getmsg("anm-973",g_lang),l_cnt        #成功笔数:
         CALL s_errmsg(g_msg1,g_msg2,'',SQLCA.sqlcode,1)
         LET g_success = 'N'
      ELSE
         LET g_msg1 = cl_getmsg("art1111",g_lang)          
         LET g_msg2 = cl_getmsg("anm-973",g_lang),l_cnt   
         IF l_cnt > 0 THEN
            CALL s_errmsg(g_msg1,g_msg2,'INSERT INTO rze_file',SQLCA.sqlcode,2)
         ELSE
            CALL s_errmsg(g_msg1,g_msg2,'','art1113',2)        #參考門店無對應資料
         END IF
      END IF
   ELSE
      LET l_cnt = 0
      LET g_msg1 = cl_getmsg("art1111",g_lang)
      LET g_msg2 = cl_getmsg("anm-973",g_lang),l_cnt
      CALL s_errmsg(g_msg1,g_msg2,'','art1101',1)              #已經存在此資料
   END IF
   IF g_success = 'Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF
END FUNCTION

#FUN-D10117--add--str---
#卡資料
FUNCTION i200_set_card(l_rtz01)
DEFINE l_lta  RECORD LIKE lta_file.*
DEFINE l_ltb  RECORD LIKE ltb_file.*
DEFINE l_ltc  RECORD LIKE ltc_file.*
DEFINE l_ltb03       LIKE ltb_file.ltb03
DEFINE l_rtz01       LIKE rtz_file.rtz01
DEFINE l_lph01       LIKE lph_file.lph01
DEFINE l_lph01_1     LIKE lph_file.lph01
DEFINE l_lphpos      LIKE lph_file.lphpos
DEFINE l_n           LIKE type_file.num5
DEFINE l_cnt         LIKE type_file.num5
DEFINE l_sql         STRING
DEFINE l_str         STRING
DEFINE li_result     LIKE type_file.num5
DEFINE l_i           LIKE type_file.num5
DEFINE l_rye04       LIKE rye_file.rye04 

   IF g_set.card = 'N' THEN RETURN END IF
   #創建臨時表
   CALL i200_set_card_temp('cre')

   BEGIN WORK
   LET g_success = 'Y'

   #檢查當前門店是否存在對應生效卡種資料
   LET l_n = 0
   LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_rtz01,'lph_file'),
               "                    ,",cl_get_target_table(l_rtz01,'lnk_file'),
               " WHERE lph01 = lnk01 AND lnk03 = '",l_rtz01,"' AND lnk02 = '1' AND lph24 = 'Y' "
   PREPARE sel_count_card_pre FROM l_sql
   EXECUTE sel_count_card_pre INTO l_n
   IF l_n < 1 THEN
      #卡种资料(almi550)
      INITIALIZE l_lta.lta01 TO NULL #初始化
      LET l_sql = "SELECT DISTINCT lph01 FROM ",cl_get_target_table(g_rtz01,'lph_file'),
                  "                 ,",cl_get_target_table(g_rtz01,'lnk_file'),
                  " WHERE lph01 = lnk01 AND lnk03 = '",g_rtz01,"' AND lnk02 = '1' AND lph24 = 'Y' ",
                  "   AND (lph09 = '0' OR (lph09 = '1' AND lph10 > '",g_today,"') OR lph09 = '2') "
      PREPARE sel_lph01_pre FROM l_sql
      DECLARE sel_lph01_cs CURSOR FOR sel_lph01_pre
      FOREACH sel_lph01_cs INTO l_lph01
         #如果卡種資料不為空則新增變更單
         IF NOT cl_null(l_lph01) THEN
            #如果單據號為空則新增變更單單頭和生效門店單身資料
            IF cl_null(l_lta.lta01) THEN
               #單據自動編號
               CALL s_get_defslip('alm','O1',g_rtz01,'N') RETURNING l_rye04
               CALL s_auto_assign_no('alm',l_rye04,g_today,'O1',"lta_file","lta01",l_rtz01,"","")
                  RETURNING li_result,l_lta.lta01
               IF cl_null(l_lta.lta01) THEN
                  LET g_msg1 = cl_getmsg("art1114",g_lang)
                  LET g_msg2 = cl_getmsg("anm-973",g_lang),0
                  CALL s_errmsg(g_msg1,g_msg2,'','art1116',1)     #自動編號出錯
                  ROLLBACK WORK
                  RETURN
               END IF
               #單頭對應欄位賦值
               LET l_lta.lta02 = '1'
               LET l_lta.lta03 = 'N'
               LET l_lta.lta04 = ' '
               LET l_lta.lta05 = ' '
               LET l_lta.lta06 = ' '
               LET l_lta.ltaacti = 'Y'
               LET l_lta.ltacrat = g_today
               LET l_lta.ltadate = ' '
               LET l_lta.ltagrup = g_grup
               LET l_lta.ltamodu = ' '
               LET l_lta.ltaorig = g_grup
               LET l_lta.ltaoriu = g_user
               LET l_lta.ltauser = g_user

               #INSERT 單頭
               INSERT INTO lta_temp VALUES (l_lta.*)
               IF STATUS OR SQLCA.SQLCODE THEN
                  CALL s_errmsg('ins','lta_temp','',SQLCA.SQLCODE,1)
                  LET g_success = 'N'
               END IF

               #單身一對應欄位賦值
               SELECT MAX(ltb03) INTO l_ltb03 FROM ltb_file WHERE ltb01 = l_lta.lta01
               IF cl_null(l_ltb03) THEN
                  LET l_ltb03 = 0
               END IF
               LET l_ltb.ltb01 = l_lta.lta01
               LET l_ltb.ltb02 = '1'
               LET l_ltb.ltb03 = l_ltb03 + 1
               LET l_ltb.ltb04 = l_rtz01
               LET l_ltb.ltb05 = ' '
               LET l_ltb.ltb06 = '1'
               LET l_ltb.ltb07 = 'Y'

               #INSERT 單身一
               INSERT INTO ltb_temp VALUES (l_ltb.*)
               IF STATUS OR SQLCA.SQLCODE THEN
                  CALL s_errmsg('ins','ltb_temp','',SQLCA.SQLCODE,1)
                  LET g_success = 'N'
               END IF
            END IF
         
            #單身二對應欄位賦值 
            LET l_ltc.ltc01 = l_lta.lta01
            LET l_ltc.ltc02 = '1'
            LET l_ltc.ltc03 = l_lph01
            #INSERT 單身二
            INSERT INTO ltc_temp VALUES (l_ltc.*)
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('ins','ltc_temp','',SQLCA.SQLCODE,1)
               LET g_success = 'N'
            END IF
         END IF
      END FOREACH

      #審核該筆卡種生效範圍變更單
      UPDATE lta_temp SET lta03 = 'Y',lta04 = g_user,lta05 = g_today,
                          ltadate = g_today,ltamodu = g_user
      IF STATUS OR SQLCA.SQLCODE THEN
         CALL s_errmsg('upd','lta_temp','',SQLCA.SQLCODE,1)
         LET g_success = 'N'
      END IF
      #將當前門店新增至卡種資料的生效範圍中
      LET l_sql = "INSERT INTO lnk_temp ",
                  "SELECT ltc03,'1','",l_rtz01,"',' ','Y' FROM ltc_temp "
      PREPARE ins_lnk_temp_pre FROM l_sql
      EXECUTE ins_lnk_temp_pre
      IF STATUS OR SQLCA.SQLCODE THEN
         CALL s_errmsg('ins','lnk_temp','',SQLCA.SQLCODE,1)
         LET g_success = 'N'
      END IF
      #更新對應卡種的已傳POS欄位
      LET l_sql = " SELECT lph01,lphpos FROM lnk_temp,",cl_get_target_table(g_rtz01,'lph_file'),
                  "  WHERE lph01 = lnk01 "
      PREPARE sel_lphpos_pre FROM l_sql
      DECLARE sel_lphpos_curs CURSOR FOR sel_lphpos_pre
      FOREACH sel_lphpos_curs INTO l_lph01_1,l_lphpos
         IF l_lphpos <> '1' THEN
            LET l_sql = " UPDATE ",cl_get_target_table(g_rtz01,'lph_file'),
                        "    SET lphpos = '2' ",
                        "  WHERE lph01  = '",l_lph01_1,"' "
            PREPARE upd_lphpos_pre FROM l_sql
            EXECUTE upd_lphpos_pre
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('upd','lph_file','',SQLCA.SQLCODE,1)
               LET g_success = 'N'
            END IF
         ELSE
            LET l_sql = " UPDATE ",cl_get_target_table(g_rtz01,'lph_file'),
                        "    SET lphpos = '1' ",
                        "  WHERE lph01  = '",l_lph01_1,"' "
            PREPARE upd_lphpos_pre1 FROM l_sql
            EXECUTE upd_lphpos_pre1
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('upd','lph_file','',SQLCA.SQLCODE,1)
               LET g_success = 'N'
            END IF
         END IF
      END FOREACH 
      #將臨時表資料Insert到數據庫
      LET l_sql = " INSERT INTO ",cl_get_target_table(l_rtz01,'lta_file'),
                  " SELECT * FROM lta_temp"
      PREPARE trans_ins_lta FROM l_sql
      EXECUTE trans_ins_lta
      IF STATUS OR SQLCA.SQLCODE THEN
         CALL s_errmsg('ins','lta_file','',SQLCA.SQLCODE,1)
         LET g_success = 'N' 
      END IF
      LET l_sql = " INSERT INTO ",cl_get_target_table(l_rtz01,'ltb_file'),
                  " SELECT * FROM ltb_temp"
      PREPARE trans_ins_ltb FROM l_sql
      EXECUTE trans_ins_ltb
      IF STATUS OR SQLCA.SQLCODE THEN
         CALL s_errmsg('ins','ltb_file','',SQLCA.SQLCODE,1)
         LET g_success = 'N' 
      END IF
      LET l_sql = " INSERT INTO ",cl_get_target_table(l_rtz01,'ltc_file'),
                  " SELECT * FROM ltc_temp"
      PREPARE trans_ins_ltc FROM l_sql
      EXECUTE trans_ins_ltc
      IF STATUS OR SQLCA.SQLCODE THEN
         CALL s_errmsg('ins','ltc_file','',SQLCA.SQLCODE,1)
         LET g_success = 'N'
      END IF
      LET l_sql = " INSERT INTO ",cl_get_target_table(l_rtz01,'lnk_file'),
                  " SELECT * FROM lnk_temp"
      PREPARE trans_ins_lnk FROM l_sql
      EXECUTE trans_ins_lnk
      LET l_cnt = SQLCA.sqlerrd[3]
      IF STATUS OR SQLCA.SQLCODE THEN
         CALL s_errmsg('ins','lnk_file','',SQLCA.SQLCODE,1)
         LET g_success = 'N'
      ELSE 
         LET g_msg1 = cl_getmsg("art1114",g_lang)         #卡資料
         LET g_msg2 = cl_getmsg("anm-973",g_lang),l_cnt   #成功笔数: 
         IF l_cnt > 0 THEN
            CALL s_errmsg(g_msg1,g_msg2,'INSERT INTO lnk_file',SQLCA.sqlcode,2)
         ELSE
            CALL s_errmsg(g_msg1,g_msg2,'','art1113',2)   #參考門店無對應資料
         END IF
      END IF

      #卡積分、折扣、儲值加值規則資料設置
      FOR l_i = 1 TO 3
         CALL i200_set_card_point(l_rtz01,l_i)
         IF g_success = 'N' THEN
            EXIT FOR
         END IF
      END FOR
   ELSE
      LET l_cnt = 0
      LET g_msg1 = cl_getmsg("art1114",g_lang)
      LET g_msg2 = cl_getmsg("anm-973",g_lang),l_cnt
      CALL s_errmsg(g_msg1,g_msg2,'','art1101',1)              #已經存在此資料
   END IF

   IF g_success = 'Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF

   #刪除臨時表
   CALL i200_set_card_temp('del')

END FUNCTION

FUNCTION i200_set_card_point(p_rtz01,p_type)
DEFINE l_rtz01      LIKE rtz_file.rtz01
DEFINE p_rtz01      LIKE rtz_file.rtz01
DEFINE l_azw02      LIKE azw_file.azw02
DEFINE l_ltn04      LIKE ltn_file.ltn04
DEFINE l_lrp06      LIKE lrp_file.lrp06 
DEFINE l_lrp07      LIKE lrp_file.lrp07
DEFINE l_lrp08      LIKE lrp_file.lrp08
DEFINE l_lrppos     LIKE lrp_file.lrppos
DEFINE l_cnt        LIKE type_file.num5
DEFINE p_type       LIKE type_file.chr1
DEFINE l_rye04      LIKE rye_file.rye04
DEFINE li_result    LIKE type_file.num5
DEFINE l_lrp07_no   LIKE lrp_file.lrp07
DEFINE l_sql        STRING

   LET l_rtz01 = p_rtz01
   IF g_success = 'N' THEN RETURN END IF

   #卡积分规则(almi555)、折扣規則(almi556)、儲值加值規則(almi558)
   INITIALIZE l_lrp06,l_lrp07,l_lrp08,l_lrppos TO NULL
   LET l_cnt = 0

   LET l_sql = "SELECT DISTINCT lrp06,lrp07,lrp08,lrppos FROM ",cl_get_target_table(g_rtz01,'lrp_file'),
                  "                                          ,",cl_get_target_table(g_rtz01,'lso_file'),
                  " WHERE lso01 = lrp06 AND lso02 = lrp07 AND lsoplant = lrpplant ",
                  "   AND lrp00 = '",p_type,"' ",
                  "   AND lrp01 IN (SELECT ltc03 FROM ltc_temp) ",
                  "   AND lrp04 <= '",g_today,"' AND lrp05 >= '",g_today,"' ",
                  "   AND lso04 = '",g_rtz01,"' ",
                  "   AND lrpacti = 'Y' AND lrpconf = 'Y' AND lrp09 = 'Y' ",
                  "   AND lrpplant = '",g_rtz01,"' "
   PREPARE sel_lrp_pre FROM l_sql
   DECLARE sel_lrp_curs CURSOR FOR sel_lrp_pre
   FOREACH sel_lrp_curs INTO l_lrp06,l_lrp07,l_lrp08,l_lrppos
      DELETE FROM lti_temp
      DELETE FROM ltj_temp
      DELETE FROM ltk_temp
      DELETE FROM ltl_temp
      DELETE FROM ltn_temp
      DELETE FROM lrp_temp
      DELETE FROM lrq_temp
      DELETE FROM lth_temp
      DELETE FROM lrr_temp
      DELETE FROM lso_temp
      #如果參考門店為制定門店，則直接由參考門店複製資料
      IF l_lrp06 = g_rtz01 THEN
         #Ins lrp_temp
         LET l_sql = "INSERT INTO lrp_temp ",
                     "SELECT * FROM ",cl_get_target_table(g_rtz01,'lrp_file'),
                     " WHERE lrp06    = '",l_lrp06,"' ",
                     "   AND lrp07    = '",l_lrp07,"' ",
                     "   AND lrp08    = '",l_lrp08+1,"' ",
                     "   AND lrpplant = '",g_rtz01,"' "
         PREPARE ins_lrp_temp_pre1 FROM l_sql
         EXECUTE ins_lrp_temp_pre1
         IF STATUS OR SQLCA.SQLCODE THEN
            CALL s_errmsg('ins','lrp_temp','',SQLCA.SQLCODE,1)
            LET g_success = 'N'
            CALL i200_set_card_temp('del')
            RETURN
         END IF
         #Ins lrq_temp
         LET l_sql = "INSERT INTO lrq_temp ",
                     "SELECT * FROM ",cl_get_target_table(g_rtz01,'lrq_file'),
                     " WHERE lrq12    = '",l_lrp06,"' ",
                     "   AND lrq13    = '",l_lrp07,"' ",
                     "   AND lrqplant = '",g_rtz01,"' "
         PREPARE ins_lrq_temp_pre1 FROM l_sql
         EXECUTE ins_lrq_temp_pre1
         IF STATUS OR SQLCA.SQLCODE THEN
            CALL s_errmsg('ins','lrq_temp','',SQLCA.SQLCODE,1)
            LET g_success = 'N'
            CALL i200_set_card_temp('del')
            RETURN
         END IF
         #Ins lth_temp
         LET l_sql = "INSERT INTO lth_temp ",
                     "SELECT * FROM ",cl_get_target_table(g_rtz01,'lth_file'),
                     " WHERE lth13    = '",l_lrp06,"' ",
                     "   AND lth14    = '",l_lrp07,"' ",
                     "   AND lthplant = '",g_rtz01,"' "
         PREPARE ins_lth_temp_pre1 FROM l_sql
         EXECUTE ins_lth_temp_pre1
         IF STATUS OR SQLCA.SQLCODE THEN
            CALL s_errmsg('ins','lth_temp','',SQLCA.SQLCODE,1)
            LET g_success = 'N'
            CALL i200_set_card_temp('del')
            RETURN
         END IF
         #Ins lrr_temp
         LET l_sql = "INSERT INTO lrr_temp ",
                     "SELECT * FROM ",cl_get_target_table(g_rtz01,'lrr_file'),
                     " WHERE lrr05    = '",l_lrp06,"' ",
                     "   AND lrr06    = '",l_lrp07,"' ",
                     "   AND lrrplant = '",g_rtz01,"' "
         PREPARE ins_lrr_temp_pre1 FROM l_sql
         EXECUTE ins_lrr_temp_pre1
         IF STATUS OR SQLCA.SQLCODE THEN
            CALL s_errmsg('ins','lrr_temp','',SQLCA.SQLCODE,1)
            LET g_success = 'N'
            CALL i200_set_card_temp('del')
            RETURN
         END IF
         #Ins lso_temp
         LET l_sql = "INSERT INTO lso_temp ",
                     "SELECT * FROM ",cl_get_target_table(g_rtz01,'lso_file'),
                     " WHERE lso01    = '",l_lrp06,"' ",
                     "   AND lso02    = '",l_lrp07,"' ",
                     "   AND lsoplant = '",g_rtz01,"' "
         PREPARE ins_lso_temp_pre2 FROM l_sql
         EXECUTE ins_lso_temp_pre2
         IF STATUS OR SQLCA.SQLCODE THEN
            CALL s_errmsg('ins','lso_temp','',SQLCA.SQLCODE,1)
            LET g_success = 'N'
            CALL i200_set_card_temp('del')
            RETURN
         END IF
         LET l_sql = "DELETE FROM lso_temp ",
                     " WHERE lso04 <> '",g_rtz01,"' "
         PREPARE del_lso_temp_pre FROM l_sql
         EXECUTE del_lso_temp_pre
         IF STATUS OR SQLCA.SQLCODE THEN
            CALL s_errmsg('del','lso_temp','',SQLCA.SQLCODE,1)
            LET g_success = 'N'
            CALL i200_set_card_temp('del')
            RETURN      
         END IF         

         #更新所屬門店/法人和狀態頁簽和已傳POS否
         LET l_sql = "SELECT azw02 FROM ",cl_get_target_table(l_rtz01,'azw_file'),
                     " WHERE azw01 = '",l_rtz01,"' "
         PREPARE sel_azw02_pre15 FROM l_sql
         EXECUTE sel_azw02_pre15 INTO l_azw02
         #單據自動編號
         IF p_type = '1' THEN
            CALL s_get_defslip('alm','Q4',g_rtz01,'N') RETURNING l_rye04
            CALL s_auto_assign_no('alm',l_rye04,g_today,'Q4',"lrp_file","lrp01",l_rtz01,"","")
               RETURNING li_result,l_lrp07_no
            IF cl_null(l_lrp07_no) THEN
               LET g_msg1 = cl_getmsg("art1117",g_lang)
               LET g_msg2 = cl_getmsg("anm-973",g_lang),0
               CALL s_errmsg(g_msg1,g_msg2,'','art1126',1)     #自動編號出錯
               LET g_success = 'N'
               RETURN
            END IF
         END IF
         IF p_type = '2' THEN
            CALL s_get_defslip('alm','Q5',g_rtz01,'N') RETURNING l_rye04
            CALL s_auto_assign_no('alm',l_rye04,g_today,'Q5',"lrp_file","lrp01",l_rtz01,"","")
               RETURNING li_result,l_lrp07_no
            IF cl_null(l_lrp07_no) THEN
               LET g_msg1 = cl_getmsg("art1118",g_lang)
               LET g_msg2 = cl_getmsg("anm-973",g_lang),0
               CALL s_errmsg(g_msg1,g_msg2,'','art1126',1)     #自動編號出錯   
               LET g_success = 'N'
               RETURN
            END IF
         END IF 
         IF p_type = '3' THEN
            CALL s_get_defslip('alm','Q6',g_rtz01,'N') RETURNING l_rye04
            CALL s_auto_assign_no('alm',l_rye04,g_today,'Q6',"lrp_file","lrp01",l_rtz01,"","")
               RETURNING li_result,l_lrp07_no
            IF cl_null(l_lrp07_no) THEN
               LET g_msg1 = cl_getmsg("art1119",g_lang)
               LET g_msg2 = cl_getmsg("anm-973",g_lang),0
               CALL s_errmsg(g_msg1,g_msg2,'','art1126',1)     #自動編號出錯
               LET g_success = 'N'
               RETURN
            END IF
         END IF
         UPDATE lrp_temp SET lrp07 = l_lrp07_no,lrp08 = 0,lrp06 = l_rtz01,lrppos = '1',lrpplant = l_rtz01,lrplegal = l_azw02,
                             lrpcond = g_today,lrpconf = 'Y',lrpconu = g_user,lrpcrat = g_today,
                             lrpdate = g_today,lrpgrup = g_grup,lrpmodu = g_user,lrporig = g_grup,
                             lrporiu = g_today,lrpuser = g_user
         UPDATE lrq_temp SET lrq12 = l_rtz01,lrqplant = l_rtz01,lrqlegal = l_azw02
         UPDATE lth_temp SET lth13 = l_rtz01,lthdate = g_today,lthgrup = g_grup,lthmodu = g_user,lthorig = g_grup,
                             lthoriu = g_user,lthuser = g_user,lthplant = l_rtz01,lthlegal = l_azw02
         UPDATE lrr_temp SET lrr05 = l_rtz01,lrrplant = l_rtz01,lrrlegal = l_azw02
         UPDATE lso_temp SET lso01 = l_rtz01,lso04 = l_rtz01,lsoplant = l_rtz01,lsolegal = l_azw02 
      ELSE
         LET g_flag = 'N' 
         CALL i200_lrp06_azw07(l_lrp06,l_rtz01)
         IF g_flag = 'N' THEN CONTINUE FOREACH END IF
         IF NOT cl_null(l_lrp06) AND NOT cl_null(l_lrp07) THEN
            #新增积分、折扣、儲值加值规则变更单单头
            LET l_sql = "INSERT INTO lti_temp ",
                        "SELECT * FROM ",cl_get_target_table(l_lrp06,'lti_file'),
                        " WHERE lti06    = '",l_lrp06,"' ",
                        "   AND lti07    = '",l_lrp07,"' ",
                        "   AND lti08    = '",l_lrp08,"' ",
                        "   AND ltiplant = '",l_lrp06,"' "
            PREPARE ins_lti_temp_pre FROM l_sql
            EXECUTE ins_lti_temp_pre
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('ins','lti_temp','',SQLCA.SQLCODE,1)
               LET g_success = 'N'
               CALL i200_set_card_temp('del')
               RETURN
            END IF
            #新增積分、折扣、儲值加值規則變更單單身一
            LET l_sql = "INSERT INTO ltj_temp ",
                        "SELECT * FROM ",cl_get_target_table(l_lrp06,'ltj_file'),
                        " WHERE ltj12    = '",l_lrp06,"' ",
                        "   AND ltj13    = '",l_lrp07,"' ",
                        "   AND ltj14    = '",l_lrp08,"' ",
                        "   AND ltjplant = '",l_lrp06,"' "
            PREPARE ins_ltj_temp_pre FROM l_sql
            EXECUTE ins_ltj_temp_pre
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('ins','ltj_temp','',SQLCA.SQLCODE,1)
               LET g_success = 'N'
               CALL i200_set_card_temp('del')
               RETURN
            END IF
            #新增積分、折扣、儲值加值規則變更單單身二
            LET l_sql = "INSERT INTO ltk_temp ",
                        "SELECT * FROM ",cl_get_target_table(l_lrp06,'ltk_file'),
                        " WHERE ltk13    = '",l_lrp06,"' ",
                        "   AND ltk14    = '",l_lrp07,"' ",
                        "   AND ltk21    = '",l_lrp08,"' ",
                        "   AND ltkplant = '",l_lrp06,"' "
            PREPARE ins_ltk_temp_pre FROM l_sql
            EXECUTE ins_ltk_temp_pre
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('ins','ltk_temp','',SQLCA.SQLCODE,1)
               LET g_success = 'N'
               CALL i200_set_card_temp('del')
               RETURN
            END IF
            #新增積分、折扣、儲值加值規則變更單排除明細變更檔
            LET l_sql = "INSERT INTO ltl_temp ",
                        "SELECT * FROM ",cl_get_target_table(l_lrp06,'ltl_file'),
                        " WHERE ltl05    = '",l_lrp06,"' ",
                        "   AND ltl06    = '",l_lrp07,"' ",
                        "   AND ltl07    = '",l_lrp08,"' ",
                        "   AND ltlplant = '",l_lrp06,"' "
            PREPARE ins_ltl_temp_pre FROM l_sql
            EXECUTE ins_ltl_temp_pre
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('ins','ltl_temp','',SQLCA.SQLCODE,1)
               LET g_success = 'N'
               CALL i200_set_card_temp('del')
               RETURN
            END IF
            #新增積分、折扣、儲值加值規則變更單生效營運中心變更檔
            LET l_sql = "INSERT INTO ltn_temp ",
                        "SELECT * FROM ",cl_get_target_table(l_lrp06,'ltn_file'),
                        " WHERE ltn01    = '",l_lrp06,"' ",
                        "   AND ltn02    = '",l_lrp07,"' ",
                        "   AND ltn08    = '",l_lrp08,"' ",
                        "   AND ltnplant = '",l_lrp06,"' "
            PREPARE ins_ltn_temp_pre FROM l_sql
            EXECUTE ins_ltn_temp_pre
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('ins','ltn_temp','',SQLCA.SQLCODE,1)
               LET g_success = 'N'
               CALL i200_set_card_temp('del')
               RETURN
            END IF
            #新增一筆生效門店為當前門店的資料
            LET l_sql = "SELECT azw02 FROM ",cl_get_target_table(l_lrp06,'azw_file'),
                        " WHERE azw01 = '",l_lrp06,"' "
            PREPARE sel_azw02_pre FROM l_sql
            EXECUTE sel_azw02_pre INTO l_azw02
            INSERT INTO ltn_temp (ltn01,ltn02,ltn03,ltn04,ltn05,ltn06,ltn07,ltn08,ltnlegal,ltnplant)
                           VALUES(l_lrp06,l_lrp07,p_type,l_rtz01,NULL,NULL,'Y',l_lrp08,l_azw02,l_lrp06)
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('ins','ltn_temp','',SQLCA.SQLCODE,1)
               LET g_success = 'N'
               CALL i200_set_card_temp('del')
               RETURN
            END IF
         
         
            #更新對應資料和狀態欄位值
            UPDATE lti_temp 
               SET lti08   = lti08 + 1,      #版本號
                   lti09   = 'N',            #發佈否
                   lti10   = NULL,           #發佈日期
                   lticonf = 'N',            #審核碼
                   lticonu = NULL,           #審核人
                   lticond = NULL,           #審核日期
                   lticrat = g_today,        #資料創建日
                   ltidate = g_today,        #最近修改日
                   ltigrup = g_grup,         #資料所有群
                   ltimodu = g_user,         #資料更改者
                   ltiorig = g_grup,         #資料建立部門
                   ltioriu = g_user,         #資料建立者
                   ltiuser = g_user,         #資料所有者
                   ltipos  = '1'             #已傳POS否

            UPDATE ltj_temp SET ltj14 = ltj14 + 1 #版本號
            UPDATE ltk_temp SET ltk21 = ltk21 + 1 #版本號
            UPDATE ltl_temp SET ltl07 = ltl07 + 1 #版本號
            UPDATE ltn_temp SET ltn08 = ltn08 + 1 #版本號

            #審核/發佈所有變更單
            UPDATE lti_temp SET lti09 = 'Y',lti10 = g_today,lticonf = 'Y',lticonu = g_user,lticond = g_today
         
            #遍歷生效門店
            INITIALIZE l_ltn04,l_azw02 TO NULL #初始化
            LET l_sql = "SELECT DISTINCT ltn04 FROM ltn_temp WHERE ltn04 <> '",l_rtz01,"' "
            PREPARE sel_ltn04_pre FROM l_sql
            DECLARE sel_ltn04_cs CURSOR FOR sel_ltn04_pre
            FOREACH sel_ltn04_cs INTO l_ltn04
               #添加一筆生效門店為當前門店的資料
               LET l_sql = "SELECT azw02 FROM ",cl_get_target_table(l_ltn04,'azw_file'),
                           " WHERE azw01 = '",l_ltn04,"' "
               PREPARE sel_azw02_pre1 FROM l_sql
               EXECUTE sel_azw02_pre1 INTO l_azw02
               LET l_sql = "INSERT INTO ",cl_get_target_table(l_ltn04,'lso_file'),
                           "            (lso01,lso02,lso03,lso04,lso05,lso06,lso07,lsolegal,lsoplant) ",
                           "     VALUES ('",l_lrp06,"', ",
                           "             '",l_lrp07,"', ",
                           "             '",p_type,"', ",
                           "             '",l_rtz01,"', ",
                           "             NULL, ",
                           "             NULL, ",
                           "             'Y', ",
                           "             '",l_azw02,"', ",
                           "             '",l_ltn04,"') "
               PREPARE ins_ltn_ltn04_pre FROM l_sql
               EXECUTE ins_ltn_ltn04_pre
               IF STATUS OR SQLCA.SQLCODE THEN
                  CALL s_errmsg('ins','lso_file','',SQLCA.SQLCODE,1)
                  LET g_success = 'N'
                  CALL i200_set_card_temp('del')
                  RETURN
               END IF
               
               #更新對應版本號
               LET l_sql = "UPDATE ",cl_get_target_table(l_ltn04,'lrp_file'),
                           "   SET lrp08 = lrp08 + 1 ",
                           " WHERE lrp06    = '",l_lrp06,"' ",
                           "   AND lrp07    = '",l_lrp07,"' ",
                           "   AND lrp08    = '",l_lrp08,"' ",
                           "   AND lrpplant = '",l_ltn04,"' "
               PREPARE upd_lrp06_pre FROM l_sql
               EXECUTE upd_lrp06_pre
               IF STATUS OR SQLCA.SQLCODE THEN
                  CALL s_errmsg('upd','lrp_file','',SQLCA.SQLCODE,1)
                  LET g_success = 'N'
                  CALL i200_set_card_temp('del')
                  RETURN
               END IF
            END FOREACH

            #在當前門店新增卡積分規則、折扣規則、儲值加值規則資料
            #Ins lrp_temp
            LET l_sql = "INSERT INTO lrp_temp ",
                        "SELECT * FROM ",cl_get_target_table(g_rtz01,'lrp_file'),
                        " WHERE lrp06    = '",l_lrp06,"' ",
                        "   AND lrp07    = '",l_lrp07,"' ",
                        "   AND lrp08    = '",l_lrp08+1,"' ",
                        "   AND lrpplant = '",g_rtz01,"' "
            PREPARE ins_lrp_temp_pre FROM l_sql
            EXECUTE ins_lrp_temp_pre
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('ins','lrp_temp','',SQLCA.SQLCODE,1)
               LET g_success = 'N'
               CALL i200_set_card_temp('del')
               RETURN
            END IF
            #Ins lrq_temp
            LET l_sql = "INSERT INTO lrq_temp ",
                        "SELECT * FROM ",cl_get_target_table(g_rtz01,'lrq_file'),
                        " WHERE lrq12    = '",l_lrp06,"' ",
                        "   AND lrq13    = '",l_lrp07,"' ",
                        "   AND lrqplant = '",g_rtz01,"' "
            PREPARE ins_lrq_temp_pre FROM l_sql
            EXECUTE ins_lrq_temp_pre
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('ins','lrq_temp','',SQLCA.SQLCODE,1)
               LET g_success = 'N'
               CALL i200_set_card_temp('del')
               RETURN
            END IF
            #Ins lth_temp
            LET l_sql = "INSERT INTO lth_temp ",
                        "SELECT * FROM ",cl_get_target_table(g_rtz01,'lth_file'),
                        " WHERE lth13    = '",l_lrp06,"' ",
                        "   AND lth14    = '",l_lrp07,"' ",
                        "   AND lthplant = '",g_rtz01,"' "
            PREPARE ins_lth_temp_pre FROM l_sql
            EXECUTE ins_lth_temp_pre
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('ins','lth_temp','',SQLCA.SQLCODE,1)
               LET g_success = 'N'
               CALL i200_set_card_temp('del')
               RETURN
            END IF
            #Ins lrr_temp
            LET l_sql = "INSERT INTO lrr_temp ",
                        "SELECT * FROM ",cl_get_target_table(g_rtz01,'lrr_file'),
                        " WHERE lrr05    = '",l_lrp06,"' ",
                        "   AND lrr06    = '",l_lrp07,"' ",
                        "   AND lrrplant = '",g_rtz01,"' "
            PREPARE ins_lrr_temp_pre FROM l_sql
            EXECUTE ins_lrr_temp_pre
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('ins','lrr_temp','',SQLCA.SQLCODE,1)
               LET g_success = 'N'
               CALL i200_set_card_temp('del')
               RETURN
            END IF
            #Ins lso_temp
            LET l_sql = "INSERT INTO lso_temp ",
                        "SELECT * FROM ",cl_get_target_table(g_rtz01,'lso_file'),
                        " WHERE lso01    = '",l_lrp06,"' ",
                        "   AND lso02    = '",l_lrp07,"' ",
                        "   AND lsoplant = '",g_rtz01,"' "
            PREPARE ins_lso_temp_pre FROM l_sql
            EXECUTE ins_lso_temp_pre
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('ins','lso_temp','',SQLCA.SQLCODE,1)
               LET g_success = 'N'
               CALL i200_set_card_temp('del')
               RETURN
            END IF

            #更新所屬門店/法人和狀態頁簽和已傳POS否
            LET l_sql = "SELECT azw02 FROM ",cl_get_target_table(l_rtz01,'azw_file'),
                        " WHERE azw01 = '",l_rtz01,"' "
            PREPARE sel_azw02_pre6 FROM l_sql
            EXECUTE sel_azw02_pre6 INTO l_azw02
            UPDATE lrp_temp SET lrppos = '1',lrpplant = l_rtz01,lrplegal = l_azw02,
                                lrpcond = g_today,lrpconf = 'Y',lrpconu = g_user,lrpcrat = g_today,
                                lrpdate = g_today,lrpgrup = g_grup,lrpmodu = g_user,lrporig = g_grup,
                                lrporiu = g_today,lrpuser = g_user
            UPDATE lrq_temp SET lrqplant = l_rtz01,lrqlegal = l_azw02
            UPDATE lth_temp SET lthdate = g_today,lthgrup = g_grup,lthmodu = g_user,lthorig = g_grup,
                                lthoriu = g_user,lthuser = g_user,lthplant = l_rtz01,lthlegal = l_azw02
            UPDATE lrr_temp SET lrrplant = l_rtz01,lrrlegal = l_azw02
            UPDATE lso_temp SET lsoplant = l_rtz01,lsolegal = l_azw02

            #將臨時表寫入數據庫
            #变更单跨库到制定门店
            LET l_sql = " INSERT INTO ",cl_get_target_table(l_lrp06,'lti_file'),
                        " SELECT * FROM lti_temp"
            PREPARE ins_lti_pre FROM l_sql
            EXECUTE ins_lti_pre
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('ins','lti_file','',SQLCA.SQLCODE,1)
               LET g_success = 'N'
               CALL i200_set_card_temp('del')
               RETURN
            END IF
            LET l_sql = " INSERT INTO ",cl_get_target_table(l_lrp06,'ltj_file'),
                        " SELECT * FROM ltj_temp"
            PREPARE ins_ltj_pre FROM l_sql
            EXECUTE ins_ltj_pre
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('ins','ltj_file','',SQLCA.SQLCODE,1)
               LET g_success = 'N'
               CALL i200_set_card_temp('del')
               RETURN
            END IF
            LET l_sql = " INSERT INTO ",cl_get_target_table(l_lrp06,'ltk_file'),
                        " SELECT * FROM ltk_temp"
            PREPARE ins_ltk_pre FROM l_sql
            EXECUTE ins_ltk_pre
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('ins','ltk_file','',SQLCA.SQLCODE,1)
               LET g_success = 'N'
               CALL i200_set_card_temp('del')
               RETURN
            END IF
            LET l_sql = " INSERT INTO ",cl_get_target_table(l_lrp06,'ltl_file'),
                        " SELECT * FROM ltl_temp"
            PREPARE ins_ltl_pre FROM l_sql
            EXECUTE ins_ltl_pre
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('ins','ltl_file','',SQLCA.SQLCODE,1)
               LET g_success = 'N'
               CALL i200_set_card_temp('del')
               RETURN
            END IF
            LET l_sql = " INSERT INTO ",cl_get_target_table(l_lrp06,'ltn_file'),
                        " SELECT * FROM ltn_temp"
            PREPARE ins_ltn_pre FROM l_sql
            EXECUTE ins_ltn_pre
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('ins','ltn_file','',SQLCA.SQLCODE,1)
               LET g_success = 'N'
               CALL i200_set_card_temp('del')
               RETURN
            END IF
         END IF
      END IF
      #將臨時表寫入數據庫
      #基本资料跨库到当前门店
      LET l_sql = " INSERT INTO ",cl_get_target_table(l_rtz01,'lrp_file'),
                  " SELECT * FROM lrp_temp"
      PREPARE ins_lrp_pre FROM l_sql
      EXECUTE ins_lrp_pre
      LET l_cnt = SQLCA.sqlerrd[3] + l_cnt
      IF STATUS OR SQLCA.SQLCODE THEN
         CALL s_errmsg('ins','lrp_file','',SQLCA.SQLCODE,1)
         LET g_success = 'N'
         CALL i200_set_card_temp('del')
         RETURN
      END IF
      LET l_sql = " INSERT INTO ",cl_get_target_table(l_rtz01,'lrq_file'),
                  " SELECT * FROM lrq_temp"
      PREPARE ins_lrq_pre FROM l_sql
      EXECUTE ins_lrq_pre
      IF STATUS OR SQLCA.SQLCODE THEN
         CALL s_errmsg('ins','lrq_file','',SQLCA.SQLCODE,1)
         LET g_success = 'N'
         CALL i200_set_card_temp('del')
         RETURN
      END IF
      LET l_sql = " INSERT INTO ",cl_get_target_table(l_rtz01,'lth_file'),
                  " SELECT * FROM lth_temp"
      PREPARE ins_lth_pre FROM l_sql
      EXECUTE ins_lth_pre
      IF STATUS OR SQLCA.SQLCODE THEN
         CALL s_errmsg('ins','lth_file','',SQLCA.SQLCODE,1)
         LET g_success = 'N'
         CALL i200_set_card_temp('del')
         RETURN
      END IF
      LET l_sql = " INSERT INTO ",cl_get_target_table(l_rtz01,'lrr_file'),
                  " SELECT * FROM lrr_temp"
      PREPARE ins_lrr_pre FROM l_sql
      EXECUTE ins_lrr_pre
      IF STATUS OR SQLCA.SQLCODE THEN
         CALL s_errmsg('ins','lrr_file','',SQLCA.SQLCODE,1)
         LET g_success = 'N'
         CALL i200_set_card_temp('del')
         RETURN
      END IF
      LET l_sql = " INSERT INTO ",cl_get_target_table(l_rtz01,'lso_file'),
                  " SELECT * FROM lso_temp"
      PREPARE ins_lso_pre FROM l_sql
      EXECUTE ins_lso_pre
      IF STATUS OR SQLCA.SQLCODE THEN
         CALL s_errmsg('ins','lso_file','',SQLCA.SQLCODE,1)
         LET g_success = 'N'
         CALL i200_set_card_temp('del')
         RETURN
      END IF        
   END FOREACH

   IF p_type = '1' THEN
      LET g_msg1 = cl_getmsg("art1117",g_lang)               #卡積分規則設定作業
   ELSE
      IF p_type = '2' THEN
         LET g_msg1 = cl_getmsg("art1118",g_lang)            #卡折扣規則設定作業
      ELSE
         LET g_msg1 = cl_getmsg("art1119",g_lang)            #卡儲值加值規則設定作業
      END IF
   END IF
   LET g_msg2 = cl_getmsg("anm-973",g_lang),l_cnt         #成功筆數:
   IF l_cnt > 0 THEN
      CALL s_errmsg(g_msg1,g_msg2,'INSERT INTO lso_file',SQLCA.sqlcode,2)
   ELSE
      CALL s_errmsg(g_msg1,g_msg2,'','art1113',2)        #參考門店無對應資料
   END IF

END FUNCTION

FUNCTION i200_lrp06_azw07(p_lrp06,p_rtz01)
DEFINE p_lrp06   LIKE lrp_file.lrp06
DEFINE p_rtz01   LIKE rtz_file.rtz01
DEFINE l_azw07   LIKE azw_file.azw07
DEFINE l_sql     STRING

   LET l_sql = " SELECT azw07 FROM ",cl_get_target_table(p_rtz01,'azw_file'),
               "  WHERE azw01 = '",p_rtz01,"' AND azwacti = 'Y' "
   PREPARE sel_azw07_pre FROM l_sql
   EXECUTE sel_azw07_pre INTO l_azw07
   IF l_azw07 = p_lrp06 THEN
      LET g_flag = 'Y'
      RETURN
   ELSE
      IF cl_null(l_azw07) OR l_azw07 = p_rtz01 THEN
         RETURN
      END IF
      CALL i200_lrp06_azw07(p_lrp06,l_azw07)
   END IF

END FUNCTION
 
#券資料
FUNCTION i200_set_coupon(l_rtz01)
DEFINE l_lta  RECORD LIKE lta_file.*
DEFINE l_ltb  RECORD LIKE ltb_file.*
DEFINE l_ltc  RECORD LIKE ltc_file.*
DEFINE l_ltb03       LIKE ltb_file.ltb03
DEFINE l_rtz01       LIKE rtz_file.rtz01
DEFINE l_azw02       LIKE azw_file.azw02
DEFINE l_lpx01       LIKE lpx_file.lpx01
DEFINE l_lpx01_1     LIKE lpx_file.lpx01
DEFINE l_lpxpos      LIKE lpx_file.lpxpos
DEFINE l_n           LIKE type_file.num5
DEFINE l_cnt         LIKE type_file.num5
DEFINE li_result     LIKE type_file.num5
DEFINE l_rye04       LIKE rye_file.rye04
DEFINE l_sql         STRING
DEFINE l_str         STRING

   IF g_set.coupon = 'N' THEN RETURN END IF
   #創建臨時表
   CALL i200_set_coupon_temp('cre')

   BEGIN WORK
   LET g_success = 'Y'

   #檢查當前門店是否存在對應生效券種資料
   LET l_n = 0
   LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_rtz01,'lpx_file'),
               "                    ,",cl_get_target_table(l_rtz01,'lnk_file'),
               " WHERE lpx01 = lnk01 AND lnk03 = '",l_rtz01,"' AND lnk02 = '2' AND lpx15 = 'Y' "
   PREPARE sel_count_coupon_pre FROM l_sql
   EXECUTE sel_count_coupon_pre INTO l_n
   IF l_n < 1 THEN
      #券种资料(almi660)
      INITIALIZE l_lta.lta01 TO NULL #初始化
      LET l_sql = "SELECT DISTINCT lpx01 FROM ",cl_get_target_table(g_rtz01,'lpx_file'),
                  "                 ,",cl_get_target_table(g_rtz01,'lnk_file'),
                  " WHERE lpx01 = lnk01 AND lnk03 = '",g_rtz01,"' AND lnk02 = '2' AND lpx15 = 'Y' ",
                  "   AND lpx03 <= '",g_today,"' AND lpx04 >= '",g_today,"' "
      PREPARE sel_lpx01_pre FROM l_sql
      DECLARE sel_lpx01_cs CURSOR FOR sel_lpx01_pre
      FOREACH sel_lpx01_cs INTO l_lpx01
         #如果券種資料不為空則新增變更單
         IF NOT cl_null(l_lpx01) THEN
            #如果單據號為空則新增變更單單頭和生效門店單身資料
            IF cl_null(l_lta.lta01) THEN
               #單據自動編號
               CALL s_get_defslip('alm','O1',g_rtz01,'N') RETURNING l_rye04
               CALL s_auto_assign_no('alm',l_rye04,g_today,'O1',"lta_file","lta01",l_rtz01,"","")
                  RETURNING li_result,l_lta.lta01
               IF cl_null(l_lta.lta01) THEN
                  LET g_msg1 = cl_getmsg("art1115",g_lang)
                  LET g_msg2 = cl_getmsg("anm-973",g_lang),0
                  CALL s_errmsg(g_msg1,g_msg2,'','art1116',1)     #自動編號出錯
                  ROLLBACK WORK
                  RETURN
               END IF
               #單頭對應欄位賦值
               LET l_lta.lta02 = '2'
               LET l_lta.lta03 = 'N'
               LET l_lta.lta04 = ' '
               LET l_lta.lta05 = ' '
               LET l_lta.lta06 = ' '
               LET l_lta.ltaacti = 'Y'
               LET l_lta.ltacrat = g_today
               LET l_lta.ltadate = ' '
               LET l_lta.ltagrup = g_grup
               LET l_lta.ltamodu = ' '
               LET l_lta.ltaorig = g_grup
               LET l_lta.ltaoriu = g_user
               LET l_lta.ltauser = g_user

               #INSERT 單頭
               INSERT INTO lta_temp VALUES (l_lta.*)
               IF STATUS OR SQLCA.SQLCODE THEN
                  CALL s_errmsg('ins','lta_temp','',SQLCA.SQLCODE,1)
                  LET g_success = 'N'
               END IF

               #單身一對應欄位賦值
               SELECT MAX(ltb03) INTO l_ltb03 FROM ltb_file WHERE ltb01 = l_lta.lta01
               IF cl_null(l_ltb03) THEN
                  LET l_ltb03 = 0
               END IF
               LET l_ltb.ltb01 = l_lta.lta01
               LET l_ltb.ltb02 = '2'
               LET l_ltb.ltb03 = l_ltb03 + 1
               LET l_ltb.ltb04 = l_rtz01
               LET l_ltb.ltb05 = ' '
               LET l_ltb.ltb06 = '1'
               LET l_ltb.ltb07 = 'Y'

               #INSERT 單身一
               INSERT INTO ltb_temp VALUES (l_ltb.*)
               IF STATUS OR SQLCA.SQLCODE THEN
                  CALL s_errmsg('ins','ltb_temp','',SQLCA.SQLCODE,1)
                  LET g_success = 'N'
               END IF
            END IF
         
            #單身二對應欄位賦值 
            LET l_ltc.ltc01 = l_lta.lta01
            LET l_ltc.ltc02 = '2'
            LET l_ltc.ltc03 = l_lpx01
            #INSERT 單身二
            INSERT INTO ltc_temp VALUES (l_ltc.*)
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('ins','ltc_temp','',SQLCA.SQLCODE,1)
               LET g_success = 'N'
            END IF
         END IF
      END FOREACH

      #審核該筆券種生效範圍變更單
      UPDATE lta_temp SET lta03 = 'Y',lta04 = g_user,lta05 = g_today,
                          ltadate = g_today,ltamodu = g_user
      IF STATUS OR SQLCA.SQLCODE THEN
         CALL s_errmsg('upd','lta_temp','',SQLCA.SQLCODE,1)
         LET g_success = 'N'
      END IF
      #將當前門店新增至券種資料的生效範圍中
      LET l_sql = "INSERT INTO lnk_temp ",
                  "SELECT ltc03,'2','",l_rtz01,"',' ','Y' FROM ltc_temp "
      PREPARE ins_lnk_temp_pre1 FROM l_sql
      EXECUTE ins_lnk_temp_pre1
      IF STATUS OR SQLCA.SQLCODE THEN
         CALL s_errmsg('ins','lnk_temp','',SQLCA.SQLCODE,1)
         LET g_success = 'N'
      END IF
      #更新對應券種的已傳POS欄位
      LET l_sql = " SELECT lpx01,lpxpos FROM lnk_temp,",cl_get_target_table(g_rtz01,'lpx_file'),
                  "  WHERE lpx01 = lnk01 "
      PREPARE sel_lpxpos_pre FROM l_sql
      DECLARE sel_lpxpos_curs CURSOR FOR sel_lpxpos_pre
      FOREACH sel_lpxpos_curs INTO l_lpx01_1,l_lpxpos
         IF l_lpxpos <> '1' THEN
            LET l_sql = " UPDATE ",cl_get_target_table(g_rtz01,'lpx_file'),
                        "    SET lpxpos = '2' ",
                        "  WHERE lpx01  = '",l_lpx01_1,"' "
            PREPARE upd_lpxpos_pre FROM l_sql
            EXECUTE upd_lpxpos_pre
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('upd','lpx_file','',SQLCA.SQLCODE,1)
               LET g_success = 'N'
            END IF
         ELSE  
            LET l_sql = " UPDATE ",cl_get_target_table(g_rtz01,'lpx_file'),
                        "    SET lpxpos = '1' ",
                        "  WHERE lpx01  = '",l_lpx01_1,"' "
            PREPARE upd_lpxpos_pre1 FROM l_sql
            EXECUTE upd_lpxpos_pre1
            IF STATUS OR SQLCA.SQLCODE THEN 
               CALL s_errmsg('upd','lpx_file','',SQLCA.SQLCODE,1)
               LET g_success = 'N'
            END IF
         END IF
      END FOREACH
      #將臨時表資料Insert到數據庫
      LET l_sql = " INSERT INTO ",cl_get_target_table(l_rtz01,'lta_file'),
                  " SELECT * FROM lta_temp"
      PREPARE trans_ins_lta1 FROM l_sql
      EXECUTE trans_ins_lta1
      IF STATUS OR SQLCA.SQLCODE THEN
         CALL s_errmsg('ins','lta_file','',SQLCA.SQLCODE,1)
         LET g_success = 'N'
      END IF
      LET l_sql = " INSERT INTO ",cl_get_target_table(l_rtz01,'ltb_file'),
                  " SELECT * FROM ltb_temp"
      PREPARE trans_ins_ltb1 FROM l_sql
      EXECUTE trans_ins_ltb1
      IF STATUS OR SQLCA.SQLCODE THEN
         CALL s_errmsg('ins','ltb_file','',SQLCA.SQLCODE,1)
         LET g_success = 'N' 
      END IF
      LET l_sql = " INSERT INTO ",cl_get_target_table(l_rtz01,'ltc_file'),
                  " SELECT * FROM ltc_temp"
      PREPARE trans_ins_ltc1 FROM l_sql
      EXECUTE trans_ins_ltc1
      IF STATUS OR SQLCA.SQLCODE THEN
         CALL s_errmsg('ins','ltc_file','',SQLCA.SQLCODE,1)
         LET g_success = 'N'
      END IF
      LET l_sql = " INSERT INTO ",cl_get_target_table(l_rtz01,'lnk_file'),
                  " SELECT * FROM lnk_temp"
      PREPARE trans_ins_lnk1 FROM l_sql
      EXECUTE trans_ins_lnk1
      LET l_cnt = SQLCA.sqlerrd[3]
      IF STATUS OR SQLCA.SQLCODE THEN
         CALL s_errmsg('ins','lnk_file','',SQLCA.SQLCODE,1)
         LET g_success = 'N'
      ELSE
         LET g_msg1 = cl_getmsg("art1115",g_lang)         #券資料
         LET g_msg2 = cl_getmsg("anm-973",g_lang),l_cnt   #成功笔数: 
         IF l_cnt > 0 THEN
            CALL s_errmsg(g_msg1,g_msg2,'INSERT INTO lnk_file',SQLCA.sqlcode,2)
         ELSE
            CALL s_errmsg(g_msg1,g_msg2,'','art1113',2)   #參考門店無對應資料
         END IF
      END IF

      #收券規則資料設置
      CALL i200_set_cash_coupon(l_rtz01)
    
   ELSE
      LET l_cnt = 0
      LET g_msg1 = cl_getmsg("art1115",g_lang)
      LET g_msg2 = cl_getmsg("anm-973",g_lang),l_cnt
      CALL s_errmsg(g_msg1,g_msg2,'','art1101',1)         #已经存在此资料
   END IF

   IF g_success = 'Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF

   #刪除臨時表
   CALL i200_set_coupon_temp('del')
   
END FUNCTION

FUNCTION i200_set_cash_coupon(p_rtz01)
DEFINE l_rtz01     LIKE rtz_file.rtz01
DEFINE p_rtz01     LIKE rtz_file.rtz01
DEFINE l_azw02     LIKE azw_file.azw02
DEFINE l_ltp01     LIKE ltp_file.ltp01
DEFINE l_ltp02     LIKE ltp_file.ltp02
DEFINE l_ltp021    LIKE ltp_file.ltp021
DEFINE l_ltppos    LIKE ltp_file.ltppos
DEFINE l_ltn04     LIKE ltn_file.ltn04
DEFINE l_cnt       LIKE type_file.num5
DEFINE l_sql       STRING
DEFINE li_result   LIKE type_file.num5
DEFINE l_rye04     LIKE rye_file.rye04
DEFINE l_ltp02_no  LIKE ltp_file.ltp02

   LET l_rtz01 = p_rtz01

   IF g_success = 'N' THEN RETURN END IF
   
   #收券规则(almi661)
   INITIALIZE l_ltp01,l_ltp02,l_ltp021,l_ltppos TO NULL
   LET l_cnt = 0

   LET l_sql = "SELECT DISTINCT ltp01,ltp02,ltp021,ltppos FROM ",cl_get_target_table(g_rtz01,'ltp_file'),
                  "                                           ,",cl_get_target_table(g_rtz01,'lso_file'),
                  " WHERE lso01 = ltp01 AND lso02 = ltp02 AND lsoplant = ltpplant ",
                  "   AND ltp03 IN (SELECT ltc03 FROM ltc_temp) ",
                  "   AND ltp04 <= '",g_today,"' AND ltp05 >= '",g_today,"' ",
                  "   AND lso04 = '",g_rtz01,"' ",
                  "   AND ltpacti = 'Y' AND ltpconf = 'Y' AND ltp11 = 'Y' ",
                  "   AND ltpplant = '",g_rtz01,"' "
   PREPARE sel_ltp_pre FROM l_sql
   DECLARE sel_ltp_curs CURSOR FOR sel_ltp_pre
   FOREACH sel_ltp_curs INTO l_ltp01,l_ltp02,l_ltp021,l_ltppos
      DELETE FROM lts_temp
      DELETE FROM ltt_temp
      DELETE FROM ltu_temp
      DELETE FROM ltn_temp
      DELETE FROM ltp_temp
      DELETE FROM ltq_temp
      DELETE FROM ltr_temp
      DELETE FROM lso_temp
      #如果參考門店為制定門店，則直接複製資料
      IF l_ltp01 = g_rtz01 THEN
         #Ins ltp_temp
         LET l_sql = "INSERT INTO ltp_temp ",
                     "SELECT * FROM ",cl_get_target_table(g_rtz01,'ltp_file'),
                     " WHERE ltp01    = '",l_ltp01,"' ",
                     "   AND ltp02    = '",l_ltp02,"' ",
                     "   AND ltp021   = '",l_ltp021+1,"' ",
                     "   AND ltpplant = '",g_rtz01,"' "
         PREPARE ins_ltp_temp_pre1 FROM l_sql
         EXECUTE ins_ltp_temp_pre1
         IF STATUS OR SQLCA.SQLCODE THEN
            CALL s_errmsg('ins','ltp_temp','',SQLCA.SQLCODE,1)
            LET g_success = 'N'
            CALL i200_set_coupon_temp('del')
            RETURN
         END IF
         #Ins ltq_temp
         LET l_sql = "INSERT INTO ltq_temp ",
                     "SELECT * FROM ",cl_get_target_table(g_rtz01,'ltq_file'),
                     " WHERE ltq01    = '",l_ltp01,"' ",
                     "   AND ltq02    = '",l_ltp02,"' ",
                     "   AND ltqplant = '",g_rtz01,"' "
         PREPARE ins_ltq_temp_pre1 FROM l_sql
         EXECUTE ins_ltq_temp_pre1
         IF STATUS OR SQLCA.SQLCODE THEN
            CALL s_errmsg('ins','ltq_temp','',SQLCA.SQLCODE,1)
            LET g_success = 'N'
            CALL i200_set_coupon_temp('del')
            RETURN
         END IF
         #Ins ltr_temp
         LET l_sql = "INSERT INTO ltr_temp ",
                     "SELECT * FROM ",cl_get_target_table(g_rtz01,'ltr_file'),
                     " WHERE ltr01    = '",l_ltp01,"' ",
                     "   AND ltr02    = '",l_ltp02,"' ",
                     "   AND ltrplant = '",g_rtz01,"' "
         PREPARE ins_ltr_temp_pre1 FROM l_sql
         EXECUTE ins_ltr_temp_pre1
         IF STATUS OR SQLCA.SQLCODE THEN
            CALL s_errmsg('ins','ltr_temp','',SQLCA.SQLCODE,1)
            LET g_success = 'N'
            CALL i200_set_coupon_temp('del')
            RETURN
         END IF
         #Ins lso_temp
         LET l_sql = "INSERT INTO lso_temp ",
                     "SELECT * FROM ",cl_get_target_table(g_rtz01,'lso_file'),
                     " WHERE lso01    = '",l_ltp01,"' ",
                     "   AND lso02    = '",l_ltp02,"' ",
                     "   AND lsoplant = '",g_rtz01,"' "
         PREPARE ins_lso_temp_pre3 FROM l_sql
         EXECUTE ins_lso_temp_pre3
         IF STATUS OR SQLCA.SQLCODE THEN
            CALL s_errmsg('ins','lso_temp','',SQLCA.SQLCODE,1)
            LET g_success = 'N'
            CALL i200_set_coupon_temp('del')
            RETURN
         END IF 
         LET l_sql = "DELETE FROM lso_temp ",
                     " WHERE lso04 <> '",g_rtz01,"' "
         PREPARE del_lso_temp_pre1 FROM l_sql
         EXECUTE del_lso_temp_pre1
         IF STATUS OR SQLCA.SQLCODE THEN
            CALL s_errmsg('del','lso_temp','',SQLCA.SQLCODE,1)
            LET g_success = 'N'
            CALL i200_set_card_temp('del')
            RETURN
         END IF   

         #更新所屬門店/法人和狀態頁簽和已傳POS否
         LET l_sql = "SELECT azw02 FROM ",cl_get_target_table(l_rtz01,'azw_file'),
                     " WHERE azw01 = '",l_rtz01,"' "
         PREPARE sel_azw02_pre16 FROM l_sql
         EXECUTE sel_azw02_pre16 INTO l_azw02    
         #單據自動編號
         CALL s_get_defslip('alm','Q8',g_rtz01,'N') RETURNING l_rye04
         CALL s_auto_assign_no('alm',l_rye04,g_today,'Q8',"ltp_file","ltp01",l_rtz01,"","")
            RETURNING li_result,l_ltp02_no
         IF cl_null(l_ltp02_no) THEN
            LET g_msg1 = cl_getmsg("art1121",g_lang)
            LET g_msg2 = cl_getmsg("anm-973",g_lang),0
            CALL s_errmsg(g_msg1,g_msg2,'','art1126',1)     #自動編號出錯
            LET g_success = 'N'
            RETURN 
         END IF 
         UPDATE ltp_temp SET ltp02 = l_ltp02_no,ltp021 = 0,ltp01 = l_rtz01,ltppos = '1',ltpplant = l_rtz01,ltplegal = l_azw02,
                             ltpcond = g_today,ltpconf = 'Y',ltpconu = g_user,ltpcrat = g_today,
                             ltpdate = g_today,ltpgrup = g_grup,ltpmodu = g_user,ltporig = g_grup,
                             ltporiu = g_today,ltpuser = g_user
         UPDATE ltq_temp SET ltq01 = l_rtz01,ltqplant = l_rtz01,ltqlegal = l_azw02
         UPDATE ltr_temp SET ltr01 = l_rtz01,ltrplant = l_rtz01,ltrlegal = l_azw02
         UPDATE lso_temp SET lso01 = l_rtz01,lso04 = l_rtz01,lsoplant = l_rtz01,lsolegal = l_azw02
      ELSE
         LET g_flag = 'N'
         CALL i200_ltp01_azw07(l_ltp01,l_rtz01)
         IF g_flag = 'N' THEN CONTINUE FOREACH END IF
 
         IF NOT cl_null(l_ltp01) AND NOT cl_null(l_ltp02) THEN
            #新增收券规则变更单单头
            LET l_sql = "INSERT INTO lts_temp ",
                        "SELECT * FROM ",cl_get_target_table(l_ltp01,'lts_file'),
                        " WHERE lts01    = '",l_ltp01,"' ",
                        "   AND lts02    = '",l_ltp02,"' ",
                        "   AND lts021   = '",l_ltp021,"' ",
                        "   AND ltsplant = '",l_ltp01,"' "
            PREPARE ins_lts_temp_pre FROM l_sql
            EXECUTE ins_lts_temp_pre
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('ins','lts_temp','',SQLCA.SQLCODE,1)
               LET g_success = 'N'
               CALL i200_set_coupon_temp('del')
               RETURN
            END IF
            #新增收券規則變更單單身一
            LET l_sql = "INSERT INTO ltt_temp ",
                        "SELECT * FROM ",cl_get_target_table(l_ltp01,'ltt_file'),
                        " WHERE ltt01    = '",l_ltp01,"' ",
                        "   AND ltt02    = '",l_ltp02,"' ",
                        "   AND ltt021   = '",l_ltp021,"' ",
                        "   AND lttplant = '",l_ltp01,"' "
            PREPARE ins_ltt_temp_pre FROM l_sql
            EXECUTE ins_ltt_temp_pre
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('ins','ltt_temp','',SQLCA.SQLCODE,1)
               LET g_success = 'N'
               CALL i200_set_coupon_temp('del')
               RETURN
            END IF
            #新增收券規則變更單單身二
            LET l_sql = "INSERT INTO ltu_temp ",
                        "SELECT * FROM ",cl_get_target_table(l_ltp01,'ltu_file'),
                        " WHERE ltu01    = '",l_ltp01,"' ",
                        "   AND ltu02    = '",l_ltp02,"' ",
                        "   AND ltu021   = '",l_ltp021,"' ",
                        "   AND ltuplant = '",l_ltp01,"' "
            PREPARE ins_ltu_temp_pre FROM l_sql
            EXECUTE ins_ltu_temp_pre
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('ins','ltu_temp','',SQLCA.SQLCODE,1)
               LET g_success = 'N'
               CALL i200_set_coupon_temp('del')
               RETURN
            END IF
            #新增收券規則變更單生效營運中心變更檔
            LET l_sql = "INSERT INTO ltn_temp ",
                        "SELECT * FROM ",cl_get_target_table(l_ltp01,'ltn_file'),
                        " WHERE ltn01    = '",l_ltp01,"' ",
                        "   AND ltn02    = '",l_ltp02,"' ",
                        "   AND ltn08    = '",l_ltp021,"' ",
                        "   AND ltnplant = '",l_ltp01,"' "
            PREPARE ins_ltn_temp_pre1 FROM l_sql
            EXECUTE ins_ltn_temp_pre1
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('ins','ltn_temp','',SQLCA.SQLCODE,1)
               LET g_success = 'N'
               CALL i200_set_coupon_temp('del')
               RETURN
            END IF
            #新增一筆生效門店為當前門店的資料
            LET l_sql = "SELECT azw02 FROM ",cl_get_target_table(l_ltp01,'azw_file'),
                        " WHERE azw01 = '",l_ltp01,"' "
            PREPARE sel_azw02_pre2 FROM l_sql
            EXECUTE sel_azw02_pre2 INTO l_azw02
            INSERT INTO ltn_temp (ltn01,ltn02,ltn03,ltn04,ltn05,ltn06,ltn07,ltn08,ltnlegal,ltnplant)
                           VALUES(l_ltp01,l_ltp02,'4',l_rtz01,NULL,NULL,'Y',l_ltp021,l_azw02,l_ltp01)
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('ins','ltn_temp','',SQLCA.SQLCODE,1)
               LET g_success = 'N'
               CALL i200_set_coupon_temp('del')
               RETURN
            END IF
         
         
            #更新對應資料和狀態欄位值
            UPDATE lts_temp 
               SET lts021  = lts021 + 1,     #版本號
                   lts11   = 'N',            #發佈否
                   lts12   = NULL,           #發佈日期
                   ltsconf = 'N',            #審核碼
                   ltsconu = NULL,           #審核人
                   ltscond = NULL,           #審核日期
                   ltscrat = g_today,        #資料創建日
                   ltsdate = g_today,        #最近修改日
                   ltsgrup = g_grup,         #資料所有群
                   ltsmodu = g_user,         #資料更改者
                   ltsorig = g_grup,         #資料建立部門
                   ltsoriu = g_user,         #資料建立者
                   ltsuser = g_user          #資料所有者

            UPDATE ltt_temp SET ltt021 = ltt021 + 1 #版本號
            UPDATE ltu_temp SET ltu021 = ltu021 + 1 #版本號
            UPDATE ltn_temp SET ltn08  = ltn08  + 1 #版本號

            #審核/發佈所有變更單
            UPDATE lts_temp SET lts11 = 'Y',lts12 = g_today,ltsconf = 'Y',ltsconu = g_user,ltscond = g_today
            
            #遍歷生效門店
            INITIALIZE l_ltn04,l_azw02 TO NULL #初始化
            LET l_sql = "SELECT DISTINCT ltn04 FROM ltn_temp WHERE ltn04 <> '",l_rtz01,"' "
            PREPARE sel_ltn04_pre1 FROM l_sql
            DECLARE sel_ltn04_cs1 CURSOR FOR sel_ltn04_pre1
            FOREACH sel_ltn04_cs1 INTO l_ltn04
               #添加一筆生效門店為當前門店的資料
               LET l_sql = "SELECT azw02 FROM ",cl_get_target_table(l_ltn04,'azw_file'),
                           " WHERE azw01 = '",l_ltn04,"' "
               PREPARE sel_azw02_pre3 FROM l_sql
               EXECUTE sel_azw02_pre3 INTO l_azw02
               LET l_sql = "INSERT INTO ",cl_get_target_table(l_ltn04,'lso_file'),
                           "            (lso01,lso02,lso03,lso04,lso05,lso06,lso07,lsolegal,lsoplant) ",
                           "     VALUES ('",l_ltp01,"', ",
                           "             '",l_ltp02,"', ",
                           "             '4', ",
                           "             '",l_rtz01,"', ",
                           "             NULL, ",
                           "             NULL, ",
                           "             'Y', ",
                           "             '",l_azw02,"', ",
                           "             '",l_ltn04,"') "
               PREPARE ins_ltn_ltn04_pre1 FROM l_sql
               EXECUTE ins_ltn_ltn04_pre1
               IF STATUS OR SQLCA.SQLCODE THEN
                  CALL s_errmsg('ins','lso_file','',SQLCA.SQLCODE,1)
                  LET g_success = 'N'
                  CALL i200_set_coupon_temp('del')
                  RETURN
               END IF
               
               #更新對應版本號
               LET l_sql = "UPDATE ",cl_get_target_table(l_ltn04,'ltp_file'),
                           "   SET ltp021   = ltp021 + 1 ",
                           " WHERE ltp01    = '",l_ltp01,"' ",
                           "   AND ltp02    = '",l_ltp02,"' ",
                           "   AND ltp021   = '",l_ltp021,"' ",
                           "   AND ltpplant = '",l_ltn04,"' "
               PREPARE upd_ltp01_pre FROM l_sql
               EXECUTE upd_ltp01_pre
               IF STATUS OR SQLCA.SQLCODE THEN
                  CALL s_errmsg('upd','ltp_file','',SQLCA.SQLCODE,1)
                  LET g_success = 'N'
                  CALL i200_set_coupon_temp('del')
                  RETURN
               END IF
            END FOREACH
   
            #在當前門店新增收券規則資料
            #Ins ltp_temp
            LET l_sql = "INSERT INTO ltp_temp ",
                        "SELECT * FROM ",cl_get_target_table(g_rtz01,'ltp_file'),
                        " WHERE ltp01    = '",l_ltp01,"' ",
                        "   AND ltp02    = '",l_ltp02,"' ",
                        "   AND ltp021   = '",l_ltp021+1,"' ",
                        "   AND ltpplant = '",g_rtz01,"' "
            PREPARE ins_ltp_temp_pre FROM l_sql
            EXECUTE ins_ltp_temp_pre
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('ins','ltp_temp','',SQLCA.SQLCODE,1)
               LET g_success = 'N'
               CALL i200_set_coupon_temp('del')
               RETURN
            END IF
            #Ins ltq_temp
            LET l_sql = "INSERT INTO ltq_temp ",
                        "SELECT * FROM ",cl_get_target_table(g_rtz01,'ltq_file'),
                        " WHERE ltq01    = '",l_ltp01,"' ",
                        "   AND ltq02    = '",l_ltp02,"' ",
                        "   AND ltqplant = '",g_rtz01,"' "
            PREPARE ins_ltq_temp_pre FROM l_sql
            EXECUTE ins_ltq_temp_pre
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('ins','ltq_temp','',SQLCA.SQLCODE,1)
               LET g_success = 'N'
               CALL i200_set_coupon_temp('del')
               RETURN
            END IF
            #Ins ltr_temp
            LET l_sql = "INSERT INTO ltr_temp ",
                        "SELECT * FROM ",cl_get_target_table(g_rtz01,'ltr_file'),
                        " WHERE ltr01    = '",l_ltp01,"' ",
                        "   AND ltr02    = '",l_ltp02,"' ",
                        "   AND ltrplant = '",g_rtz01,"' "
            PREPARE ins_ltr_temp_pre FROM l_sql
            EXECUTE ins_ltr_temp_pre
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('ins','ltr_temp','',SQLCA.SQLCODE,1)
               LET g_success = 'N'
               CALL i200_set_coupon_temp('del')
               RETURN
            END IF
            #Ins lso_temp
            LET l_sql = "INSERT INTO lso_temp ",
                        "SELECT * FROM ",cl_get_target_table(g_rtz01,'lso_file'),
                        " WHERE lso01    = '",l_ltp01,"' ",
                        "   AND lso02    = '",l_ltp02,"' ",
                        "   AND lsoplant = '",g_rtz01,"' "
            PREPARE ins_lso_temp_pre1 FROM l_sql
            EXECUTE ins_lso_temp_pre1
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('ins','lso_temp','',SQLCA.SQLCODE,1)
               LET g_success = 'N'
               CALL i200_set_coupon_temp('del')
               RETURN
            END IF
   
            #更新所屬門店/法人和狀態頁簽和已傳POS否
            LET l_sql = "SELECT azw02 FROM ",cl_get_target_table(l_rtz01,'azw_file'),
                        " WHERE azw01 = '",l_rtz01,"' "
            PREPARE sel_azw02_pre7 FROM l_sql
            EXECUTE sel_azw02_pre7 INTO l_azw02
            UPDATE ltp_temp SET ltppos = '1',ltpplant = l_rtz01,ltplegal = l_azw02,
                                ltpcond = g_today,ltpconf = 'Y',ltpconu = g_user,ltpcrat = g_today,
                                ltpdate = g_today,ltpgrup = g_grup,ltpmodu = g_user,ltporig = g_grup,
                                ltporiu = g_today,ltpuser = g_user
            UPDATE ltq_temp SET ltqplant = l_rtz01,ltqlegal = l_azw02
            UPDATE ltr_temp SET ltrplant = l_rtz01,ltrlegal = l_azw02
            UPDATE lso_temp SET lsoplant = l_rtz01,lsolegal = l_azw02
   
            #將臨時表寫入數據庫
            #变更单跨库到制定门店/基本资料跨库到当前门店
            LET l_sql = " INSERT INTO ",cl_get_target_table(l_ltp01,'lts_file'),
                        " SELECT * FROM lts_temp"
            PREPARE ins_lts_pre FROM l_sql
            EXECUTE ins_lts_pre
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('ins','lts_file','',SQLCA.SQLCODE,1)
               LET g_success = 'N'
               CALL i200_set_coupon_temp('del')
               RETURN
            END IF
            LET l_sql = " INSERT INTO ",cl_get_target_table(l_ltp01,'ltt_file'),
                        " SELECT * FROM ltt_temp"
            PREPARE ins_ltt_pre FROM l_sql
            EXECUTE ins_ltt_pre
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('ins','ltt_file','',SQLCA.SQLCODE,1)
               LET g_success = 'N'
               CALL i200_set_coupon_temp('del')
               RETURN
            END IF
            LET l_sql = " INSERT INTO ",cl_get_target_table(l_ltp01,'ltu_file'),
                        " SELECT * FROM ltu_temp"
            PREPARE ins_ltu_pre FROM l_sql
            EXECUTE ins_ltu_pre
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('ins','ltu_file','',SQLCA.SQLCODE,1)
               LET g_success = 'N'
               CALL i200_set_coupon_temp('del')
               RETURN
            END IF
            LET l_sql = " INSERT INTO ",cl_get_target_table(l_ltp01,'ltn_file'),
                        " SELECT * FROM ltn_temp"
            PREPARE ins_ltn_pre1 FROM l_sql
            EXECUTE ins_ltn_pre1
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('ins','ltn_file','',SQLCA.SQLCODE,1)
               LET g_success = 'N'
               CALL i200_set_coupon_temp('del')
               RETURN
            END IF
         END IF
      END IF

      LET l_sql = " INSERT INTO ",cl_get_target_table(l_rtz01,'ltp_file'),
                  " SELECT * FROM ltp_temp"
      PREPARE ins_ltp_pre FROM l_sql
      EXECUTE ins_ltp_pre
      LET l_cnt = SQLCA.sqlerrd[3] + l_cnt
      IF STATUS OR SQLCA.SQLCODE THEN
         CALL s_errmsg('ins','ltp_file','',SQLCA.SQLCODE,1)
         LET g_success = 'N'
         CALL i200_set_coupon_temp('del')
         RETURN
      END IF
      LET l_sql = " INSERT INTO ",cl_get_target_table(l_rtz01,'ltq_file'),
                  " SELECT * FROM ltq_temp"
      PREPARE ins_ltq_pre FROM l_sql
      EXECUTE ins_ltq_pre
      IF STATUS OR SQLCA.SQLCODE THEN
         CALL s_errmsg('ins','ltq_file','',SQLCA.SQLCODE,1)
         LET g_success = 'N'
         CALL i200_set_coupon_temp('del')
         RETURN
      END IF
      LET l_sql = " INSERT INTO ",cl_get_target_table(l_rtz01,'ltr_file'),
                  " SELECT * FROM ltr_temp"
      PREPARE ins_ltr_pre FROM l_sql
      EXECUTE ins_ltr_pre
      IF STATUS OR SQLCA.SQLCODE THEN
         CALL s_errmsg('ins','ltr_file','',SQLCA.SQLCODE,1)
         LET g_success = 'N'
         CALL i200_set_coupon_temp('del')
         RETURN
      END IF
      LET l_sql = " INSERT INTO ",cl_get_target_table(l_rtz01,'lso_file'),
                  " SELECT * FROM lso_temp"
      PREPARE ins_lso_pre1 FROM l_sql
      EXECUTE ins_lso_pre1
      IF STATUS OR SQLCA.SQLCODE THEN
         CALL s_errmsg('ins','lso_file','',SQLCA.SQLCODE,1)
         LET g_success = 'N'
         CALL i200_set_coupon_temp('del')
         RETURN
      END IF
   END FOREACH

   LET g_msg1 = cl_getmsg("art1121",g_lang)               #收券設置作業
   LET g_msg2 = cl_getmsg("anm-973",g_lang),l_cnt         #成功筆數:
   IF l_cnt > 0 THEN
      CALL s_errmsg(g_msg1,g_msg2,'INSERT INTO lso_file',SQLCA.sqlcode,2)
   ELSE
      CALL s_errmsg(g_msg1,g_msg2,'','art1113',2)        #參考門店無對應資料
   END IF

END FUNCTION

FUNCTION i200_ltp01_azw07(p_ltp01,p_rtz01)
DEFINE p_ltp01   LIKE ltp_file.ltp01
DEFINE p_rtz01   LIKE rtz_file.rtz01
DEFINE l_azw07   LIKE azw_file.azw07
DEFINE l_sql     STRING
   LET l_sql = " SELECT azw07 FROM ",cl_get_target_table(p_rtz01,'azw_file'),
               "  WHERE azw01 = '",p_rtz01,"' AND azwacti = 'Y' "
   PREPARE sel_azw07_pre1 FROM l_sql
   EXECUTE sel_azw07_pre1 INTO l_azw07
   IF l_azw07 = p_ltp01 THEN
      LET g_flag = 'Y'
      RETURN
   ELSE
      IF cl_null(l_azw07) OR l_azw07 = p_rtz01 THEN
         RETURN
      END IF
      CALL i200_ltp01_azw07(p_ltp01,l_azw07)
   END IF

END FUNCTION

#促銷資料
FUNCTION i200_set_promote(l_rtz01)
DEFINE l_rbb  RECORD LIKE rbb_file.*
DEFINE l_rab01       LIKE rab_file.rab01
DEFINE l_rab02       LIKE rab_file.rab02
DEFINE l_rab04       LIKE rab_file.rab04
DEFINE l_rab05       LIKE rab_file.rab05
DEFINE l_rab06       LIKE rab_file.rab06
DEFINE l_rab07       LIKE rab_file.rab07
DEFINE l_rab08       LIKE rab_file.rab08
DEFINE l_rab09       LIKE rab_file.rab09
DEFINE l_rab10       LIKE rab_file.rab10
DEFINE l_rbb03       LIKE rbb_file.rbb03
DEFINE l_raq04       LIKE raq_file.raq04
DEFINE l_rtz01       LIKE rtz_file.rtz01
DEFINE l_azw02       LIKE azw_file.azw02
DEFINE l_racpos      LIKE rac_file.racpos
DEFINE l_rakpos      LIKE rak_file.rakpos
DEFINE l_n           LIKE type_file.num5
DEFINE l_cnt         LIKE type_file.num5
DEFINE l_sql         STRING 

   IF g_set.promote = 'N' THEN RETURN END IF

  #一般促銷
   #創建臨時表
   CALL i200_set_promote_temp('cre')
   
   BEGIN WORK
   LET g_success = 'Y'
   #檢查當前門店是否存在對應生效一般促銷資料
   LET l_n = 0
   LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_rtz01,'rab_file'),
               "                    ,",cl_get_target_table(l_rtz01,'raq_file'),
               " WHERE rab01 = raq01 AND rab02 = raq02 AND raq04 = '",l_rtz01,"' AND raq03 = '1' AND rabconf = 'Y' AND rabplant = '",l_rtz01,"' "
   PREPARE sel_count_promote_pre FROM l_sql
   EXECUTE sel_count_promote_pre INTO l_n
   IF l_n < 1 THEN
      #一般促銷资料(artt302)
      INITIALIZE l_rab01,l_rab02 TO NULL #初始化
      LET l_sql = "SELECT DISTINCT rab01,rab02 FROM ",cl_get_target_table(g_rtz01,'rab_file'),
                  "                                ,",cl_get_target_table(g_rtz01,'raq_file'),
                  "                                ,",cl_get_target_table(g_rtz01,'rak_file'),                       
                  " WHERE rab01 = raq01 AND rab02 = raq02 AND raq04 = '",g_rtz01,"' AND rabconf = 'Y' AND raq05 = 'Y' ",
                  "   AND rab01 = rak01 AND rab02 = rak02 AND raq03 = '1' AND rak03 = '1' AND rabplant = '",g_rtz01,"' ",
                  "   AND rak06 <= '",g_today,"' AND rak07 >= '",g_today,"' "
      PREPARE sel_rab01_pre FROM l_sql
      DECLARE sel_rab01_cs  CURSOR FOR sel_rab01_pre
      FOREACH sel_rab01_cs  INTO l_rab01,l_rab02
         DELETE FROM rbb_temp
         DELETE FROM rbq_temp
         DELETE FROM rab_temp
         DELETE FROM rac_temp
         DELETE FROM rak_temp
         DELETE FROM rad_temp
         DELETE FROM rap_temp
         DELETE FROM raq_temp
         #如果一般促銷資料不為空則新增變更單(artt402)
         IF NOT cl_null(l_rab01) AND NOT cl_null(l_rab02) THEN
            #單頭對應欄位賦值
            LET l_sql = "SELECT rab04,rab05,rab06,rab07,rab08,rab09,rab10 FROM ",cl_get_target_table(l_rab01,'rab_file'),
                        " WHERE rab01 = '",l_rab01,"' AND rab02 = '",l_rab02,"' AND rabplant = '",g_rtz01,"' "
            PREPARE sel_rab_pre FROM l_sql
            EXECUTE sel_rab_pre INTO l_rab04,l_rab05,l_rab06,l_rab07,l_rab08,l_rab09,l_rab10
            LET l_sql = "SELECT MAX(rbb03) FROM ",cl_get_target_table(l_rab01,'rbb_file'),
                        " WHERE rbb01 = '",l_rab01,"' AND rbb02 = '",l_rab02,"' AND rbbplant = '",l_rab01,"' "
            PREPARE sel_rbb_pre FROM l_sql
            EXECUTE sel_rbb_pre INTO l_rbb03
            IF cl_null(l_rbb03) THEN
               LET l_rbb03 = 0
            END IF
            LET l_sql = "SELECT azw02 FROM ",cl_get_target_table(l_rab01,'azw_file'),
                        " WHERE azw01 = '",l_rab01,"' "
            PREPARE sel_azw02_pre4 FROM l_sql
            EXECUTE sel_azw02_pre4 INTO l_azw02
            LET l_rbb.rbb01    = l_rab01
            LET l_rbb.rbb02    = l_rab02
            LET l_rbb.rbb03    = l_rbb03 + 1
            LET l_rbb.rbb04    = l_rab04
            LET l_rbb.rbb04t   = l_rab04
            LET l_rbb.rbb05    = l_rab05
            LET l_rbb.rbb05t   = l_rab05
            LET l_rbb.rbb06    = l_rab06
            LET l_rbb.rbb06t   = l_rab06
            LET l_rbb.rbb07    = l_rab07
            LET l_rbb.rbb07t   = l_rab07
            LET l_rbb.rbb08    = l_rab08
            LET l_rbb.rbb08t   = l_rab08
            LET l_rbb.rbb09t   = l_rab09
            LET l_rbb.rbb10    = l_rab10
            LET l_rbb.rbb10t   = l_rab10
            LET l_rbb.rbb11    = ' '
            LET l_rbb.rbb900   = '0'
            LET l_rbb.rbbacti  = 'Y'
            LET l_rbb.rbbcond  = ' '
            LET l_rbb.rbbconf  = 'N'
            LET l_rbb.rbbcont  = ' '
            LET l_rbb.rbbconu  = ' '
            LET l_rbb.rbbcrat  = g_today
            LET l_rbb.rbbdate  = ' '
            LET l_rbb.rbbdays  = ' '
            LET l_rbb.rbbgrup  = g_grup
            LET l_rbb.rbblegal = l_azw02 
            LET l_rbb.rbbmksg  = 'N'
            LET l_rbb.rbbmodu  = ' '
            LET l_rbb.rbborig  = g_grup
            LET l_rbb.rbboriu  = g_user
            LET l_rbb.rbbplant = l_rab01
            LET l_rbb.rbbprit  = ' '
            LET l_rbb.rbbsign  = ' '
            LET l_rbb.rbbsmax  = ' '
            LET l_rbb.rbbsseq  = ' '
            LET l_rbb.rbbuser  = g_user
            LET l_rbb.rbb09    = l_rab09

            #INSERT 單頭
            INSERT INTO rbb_temp VALUES (l_rbb.*)
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('ins','rbb_temp','',SQLCA.SQLCODE,1)
               LET g_success = 'N'
               CALL i200_set_promote_temp('del')
               RETURN
            END IF

            #將當前門店新增至一般促銷資料變更單的生效範圍中
            LET l_sql = "INSERT INTO rbq_temp ",
                        "SELECT rbb01,rbb02,rbb03,'1','1','1','",l_rtz01,"',' ','Y','",l_azw02,"',rbb01,' ' FROM rbb_temp "
            PREPARE ins_rbq_temp_pre FROM l_sql
            EXECUTE ins_rbq_temp_pre
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('ins','rbq_temp','',SQLCA.SQLCODE,1)
               LET g_success = 'N'
               CALL i200_set_promote_temp('del')
               RETURN
            END IF
      
            #審核該筆一般促銷變更單
            UPDATE rbb_temp SET rbb900 = '1',rbbcond = g_today,rbbconf = 'Y',rbbconu = g_user,
                                rbbmodu = g_user,rbbdate = g_today 
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('upd','rbb_temp','',SQLCA.SQLCODE,1)
               LET g_success = 'N'
               CALL i200_set_promote_temp('del')
               RETURN
            END IF
      
            #更新變更生效範圍發佈否欄位值
            UPDATE rbq_temp SET rbq08 = 'Y'
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('upd','rbq_temp','',SQLCA.SQLCODE,1)
               LET g_success = 'N'
               CALL i200_set_promote_temp('del')
               RETURN
            END IF
   
            #遍歷生效門店
            INITIALIZE l_raq04,l_azw02 TO NULL #初始化
            LET l_sql = "SELECT DISTINCT raq04 FROM ",cl_get_target_table(l_rab01,'raq_file'),
                        " WHERE raq01 = '",l_rab01,"' AND raq02 = '",l_rab02,"' AND raq03 = '1' AND raq04 <> '",l_rtz01,"' "
            PREPARE sel_raq04_pre FROM l_sql
            DECLARE sel_raq04_cs CURSOR FOR sel_raq04_pre
            FOREACH sel_raq04_cs INTO l_raq04
               #添加一筆生效門店為當前門店的資料
               LET l_sql = "SELECT azw02 FROM ",cl_get_target_table(l_raq04,'azw_file'),
                           " WHERE azw01 = '",l_raq04,"' "
               PREPARE sel_azw02_pre5 FROM l_sql
               EXECUTE sel_azw02_pre5 INTO l_azw02
               LET l_sql = "INSERT INTO ",cl_get_target_table(l_raq04,'raq_file'),
                           "            (raq01,raq02,raq03,raq04,raq05,raq06,raq07,raq08,raqacti,raqlegal,raqplant) ",
                           "     VALUES ('",l_rab01,"', ",
                           "             '",l_rab02,"', ",
                           "             '1', ",
                           "             '",l_rtz01,"', ",
                           "             'Y', ",
                           "             '",g_today,"', ",
                           "             '",TIME,"', ",
                           "             ' ', ",
                           "             'Y', ",
                           "             '",l_azw02,"', ",
                           "             '",l_raq04,"') "
               PREPARE ins_raq_raq04_pre FROM l_sql
               EXECUTE ins_raq_raq04_pre
               IF STATUS OR SQLCA.SQLCODE THEN
                  CALL s_errmsg('ins','raq_file','',SQLCA.SQLCODE,1)
                  LET g_success = 'N'
                  CALL i200_set_promote_temp('del')
                  RETURN
               END IF
               
               #更新對應一般促銷資料的已傳POS欄位
               LET l_sql = " SELECT racpos FROM ",cl_get_target_table(l_raq04,'rac_file'),
                           "  WHERE rac01 = '",l_rab01,"' AND rac02 = '",l_rab02,"' AND racplant = '",l_raq04,"' "
               PREPARE sel_racpos_pre FROM l_sql
               DECLARE sel_racpos_curs CURSOR FOR sel_racpos_pre
               FOREACH sel_racpos_curs INTO l_racpos
                  IF l_racpos <> '1' THEN
                     LET l_sql = " UPDATE ",cl_get_target_table(l_raq04,'rac_file'),
                                 "    SET racpos = '2' ",
                                 "  WHERE rac01  = '",l_rab01,"' AND rac02 = '",l_rab02,"' AND racplant = '",l_raq04,"' "
                     PREPARE upd_racpos_pre FROM l_sql
                     EXECUTE upd_racpos_pre
                     IF STATUS OR SQLCA.SQLCODE THEN
                        CALL s_errmsg('upd','rac_file','',SQLCA.SQLCODE,1)
                        LET g_success = 'N'
                        CALL i200_set_promote_temp('del')
                        RETURN
                     END IF
                  ELSE
                     LET l_sql = " UPDATE ",cl_get_target_table(l_raq04,'rac_file'),
                                 "    SET racpos = '1' ",
                                 "  WHERE rac01  = '",l_rab01,"' AND rac02 = '",l_rab02,"' AND racplant = '",l_raq04,"' "
                     PREPARE upd_racpos_pre1 FROM l_sql
                     EXECUTE upd_racpos_pre1
                     IF STATUS OR SQLCA.SQLCODE THEN
                        CALL s_errmsg('upd','rac_file','',SQLCA.SQLCODE,1)
                        LET g_success = 'N'
                        CALL i200_set_promote_temp('del')
                        RETURN
                     END IF
                  END IF
               END FOREACH 
            END FOREACH

            #在當前門店新增一般促銷資料
            #Ins rab_temp
            LET l_sql = "INSERT INTO rab_temp ",
                        "SELECT * FROM ",cl_get_target_table(g_rtz01,'rab_file'),
                        " WHERE rab01    = '",l_rab01,"' ",
                        "   AND rab02    = '",l_rab02,"' ",
                        "   AND rabplant = '",g_rtz01,"' "
            PREPARE ins_rab_temp_pre FROM l_sql
            EXECUTE ins_rab_temp_pre
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('ins','rab_temp','',SQLCA.SQLCODE,1)
               LET g_success = 'N'
               CALL i200_set_promote_temp('del')
               RETURN
            END IF
            #Ins rac_temp
            LET l_sql = "INSERT INTO rac_temp ",
                        "SELECT * FROM ",cl_get_target_table(g_rtz01,'rac_file'),
                        " WHERE rac01    = '",l_rab01,"' ",
                        "   AND rac02    = '",l_rab02,"' ",
                        "   AND racplant = '",g_rtz01,"' "
            PREPARE ins_rac_temp_pre FROM l_sql
            EXECUTE ins_rac_temp_pre
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('ins','rac_temp','',SQLCA.SQLCODE,1)
               LET g_success = 'N'
               CALL i200_set_promote_temp('del')
               RETURN
            END IF
            #Ins rak_temp
            LET l_sql = "INSERT INTO rak_temp ",
                        "SELECT * FROM ",cl_get_target_table(g_rtz01,'rak_file'),
                        " WHERE rak01    = '",l_rab01,"' ",
                        "   AND rak02    = '",l_rab02,"' ",
                        "   AND rakplant = '",g_rtz01,"' "
            PREPARE ins_rak_temp_pre FROM l_sql
            EXECUTE ins_rak_temp_pre
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('ins','rak_temp','',SQLCA.SQLCODE,1)
               LET g_success = 'N'
               CALL i200_set_promote_temp('del')
               RETURN
            END IF
            #Ins rad_temp
            LET l_sql = "INSERT INTO rad_temp ",
                        "SELECT * FROM ",cl_get_target_table(g_rtz01,'rad_file'),
                        " WHERE rad01    = '",l_rab01,"' ",
                        "   AND rad02    = '",l_rab02,"' ",
                        "   AND radplant = '",g_rtz01,"' "
            PREPARE ins_rad_temp_pre1 FROM l_sql
            EXECUTE ins_rad_temp_pre1
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('ins','rad_temp','',SQLCA.SQLCODE,1)
               LET g_success = 'N'
               CALL i200_set_promote_temp('del')
               RETURN
            END IF
            #Ins rap_temp
            LET l_sql = "INSERT INTO rap_temp ",
                        "SELECT * FROM ",cl_get_target_table(g_rtz01,'rap_file'),
                        " WHERE rap01    = '",l_rab01,"' ",
                        "   AND rap02    = '",l_rab02,"' ",
                        "   AND rap03    = '1' ",
                        "   AND rapplant = '",g_rtz01,"' "
            PREPARE ins_rap_temp_pre1 FROM l_sql
            EXECUTE ins_rap_temp_pre1
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('ins','rap_temp','',SQLCA.SQLCODE,1)
               LET g_success = 'N'
               CALL i200_set_promote_temp('del')
               RETURN
            END IF
            #Ins raq_temp
            LET l_sql = "INSERT INTO raq_temp ",
                        "SELECT * FROM ",cl_get_target_table(g_rtz01,'raq_file'),
                        " WHERE raq01    = '",l_rab01,"' ",
                        "   AND raq02    = '",l_rab02,"' ",
                        "   AND raqplant = '",g_rtz01,"' "
            PREPARE ins_raq_temp_pre1 FROM l_sql
            EXECUTE ins_raq_temp_pre1
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('ins','raq_temp','',SQLCA.SQLCODE,1)
               LET g_success = 'N'
               CALL i200_set_promote_temp('del')
               RETURN
            END IF
   
            #更新所屬門店/法人和狀態頁簽和已傳POS否
            LET l_sql = "SELECT azw02 FROM ",cl_get_target_table(l_rtz01,'azw_file'),
                     " WHERE azw01 = '",l_rtz01,"' "
            PREPARE sel_azw02_pre8 FROM l_sql
            EXECUTE sel_azw02_pre8 INTO l_azw02
            UPDATE rab_temp SET rabplant = l_rtz01,rablegal = l_azw02,
                                rabcond = g_today,rabconf = 'Y',rabconu = g_user,rabcrat = g_today,
                                rabdate = g_today,rabgrup = g_grup,rabmodu = g_user,raborig = g_grup,
                                raboriu = g_user,rabuser = g_user
            UPDATE rac_temp SET racpos = '1',raclegal = l_azw02,racplant = l_rtz01
            UPDATE rak_temp SET rakcrdate = g_today,rakdate = g_today,rakgrup = g_grup,
                                raklegal = l_azw02,rakmodu = g_user,rakorig = g_grup,
                                rakoriu = g_user,rakplant = l_rtz01,rakuser = g_user,rakpos = '1'
            UPDATE rad_temp SET radlegal = l_azw02,radplant = l_rtz01
            UPDATE rap_temp SET raplegal = l_azw02,rapplant = l_rtz01
            UPDATE raq_temp SET raq06 = g_today,raqlegal = l_azw02,raqplant = l_rtz01

            #將臨時表資料Insert到數據庫
            #变更单跨库到制定门店/基本资料跨库到当前门店
            LET l_sql = " INSERT INTO ",cl_get_target_table(l_rab01,'rbb_file'),
                        " SELECT * FROM rbb_temp"
            PREPARE trans_ins_rbb FROM l_sql
            EXECUTE trans_ins_rbb
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('ins','rbb_file','',SQLCA.SQLCODE,1)
               LET g_success = 'N' 
               CALL i200_set_promote_temp('del')
               RETURN
            END IF
            LET l_sql = " INSERT INTO ",cl_get_target_table(l_rab01,'rbq_file'),
                        " SELECT * FROM rbq_temp"
            PREPARE trans_ins_rbq FROM l_sql
            EXECUTE trans_ins_rbq
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('ins','rbq_file','',SQLCA.SQLCODE,1)
               LET g_success = 'N'
               CALL i200_set_promote_temp('del')
               RETURN
            END IF
            LET l_sql = " INSERT INTO ",cl_get_target_table(l_rtz01,'rab_file'),
                        " SELECT * FROM rab_temp"
            PREPARE trans_ins_rab FROM l_sql
            EXECUTE trans_ins_rab
            LET l_cnt = SQLCA.sqlerrd[3]+l_cnt
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('ins','rab_file','',SQLCA.SQLCODE,1)
               LET g_success = 'N'
               CALL i200_set_promote_temp('del')
               RETURN
            END IF
            LET l_sql = " INSERT INTO ",cl_get_target_table(l_rtz01,'rac_file'),
                        " SELECT * FROM rac_temp"
            PREPARE trans_ins_rac FROM l_sql
            EXECUTE trans_ins_rac
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('ins','rac_file','',SQLCA.SQLCODE,1)
               LET g_success = 'N'
               CALL i200_set_promote_temp('del')
               RETURN
            END IF
            LET l_sql = " INSERT INTO ",cl_get_target_table(l_rtz01,'rak_file'),
                        " SELECT * FROM rak_temp"
            PREPARE trans_ins_rak FROM l_sql
            EXECUTE trans_ins_rak
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('ins','rak_file','',SQLCA.SQLCODE,1)
               LET g_success = 'N'
               CALL i200_set_promote_temp('del')
               RETURN
            END IF
            LET l_sql = " INSERT INTO ",cl_get_target_table(l_rtz01,'rad_file'),
                        " SELECT * FROM rad_temp"
            PREPARE trans_ins_rad FROM l_sql
            EXECUTE trans_ins_rad
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('ins','rad_file','',SQLCA.SQLCODE,1)
               LET g_success = 'N'
               CALL i200_set_promote_temp('del')
               RETURN
            END IF
            LET l_sql = " INSERT INTO ",cl_get_target_table(l_rtz01,'rap_file'),
                        " SELECT * FROM rap_temp"
            PREPARE trans_ins_rap FROM l_sql
            EXECUTE trans_ins_rap
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('ins','rap_file','',SQLCA.SQLCODE,1)
               LET g_success = 'N'
               CALL i200_set_promote_temp('del')
               RETURN
            END IF
            LET l_sql = " INSERT INTO ",cl_get_target_table(l_rtz01,'raq_file'),
                        " SELECT * FROM raq_temp"
            PREPARE trans_ins_raq FROM l_sql
            EXECUTE trans_ins_raq
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('ins','raq_file','',SQLCA.SQLCODE,1)
               LET g_success = 'N'
               CALL i200_set_promote_temp('del')
               RETURN
            END IF
         END IF
      END FOREACH
      LET g_msg1 = cl_getmsg("art1122",g_lang)         #一般促銷資料
      LET g_msg2 = cl_getmsg("anm-973",g_lang),l_cnt   #成功笔数: 
      IF l_cnt > 0 THEN
         CALL s_errmsg(g_msg1,g_msg2,'INSERT INTO rab_file',SQLCA.sqlcode,2)
      ELSE
         CALL s_errmsg(g_msg1,g_msg2,'','art1113',2)   #參考門店無對應資料
      END IF
   ELSE
      LET l_cnt = 0
      LET g_msg1 = cl_getmsg("art1122",g_lang)
      LET g_msg2 = cl_getmsg("anm-973",g_lang),l_cnt
      CALL s_errmsg(g_msg1,g_msg2,'','art1101',1)      #已經存在此資料
   END IF

   IF g_success = 'Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF

   #刪除臨時表
   CALL i200_set_promote_temp('del')
   #組合促銷
   CALL i200_set_promote_comb(l_rtz01)
   #滿額促銷
   CALL i200_set_promote_full(l_rtz01)

END FUNCTION

#組合促銷資料
FUNCTION i200_set_promote_comb(p_rtz01)
DEFINE l_rbe RECORD LIKE rbe_file.*
DEFINE l_rtz01      LIKE rtz_file.rtz01
DEFINE p_rtz01      LIKE rtz_file.rtz01
DEFINE l_azw02      LIKE azw_file.azw02
DEFINE l_raepos     LIKE rae_file.raepos
DEFINE l_rae01      LIKE rae_file.rae01
DEFINE l_rae02      LIKE rae_file.rae02
DEFINE l_rae03      LIKE rae_file.rae03
DEFINE l_rae08      LIKE rae_file.rae08
DEFINE l_rae09      LIKE rae_file.rae09
DEFINE l_rae10      LIKE rae_file.rae10
DEFINE l_rae11      LIKE rae_file.rae11
DEFINE l_rae12      LIKE rae_file.rae12
DEFINE l_rae13      LIKE rae_file.rae13
DEFINE l_rae14      LIKE rae_file.rae14
DEFINE l_rae15      LIKE rae_file.rae15
DEFINE l_rae16      LIKE rae_file.rae16
DEFINE l_rae17      LIKE rae_file.rae17
DEFINE l_rae18      LIKE rae_file.rae18
DEFINE l_rae19      LIKE rae_file.rae19
DEFINE l_rae20      LIKE rae_file.rae20
DEFINE l_rae21      LIKE rae_file.rae21
DEFINE l_rae23      LIKE rae_file.rae23
DEFINE l_rae24      LIKE rae_file.rae24
DEFINE l_rae25      LIKE rae_file.rae25
DEFINE l_rae26      LIKE rae_file.rae26
DEFINE l_rae27      LIKE rae_file.rae27
DEFINE l_rae28      LIKE rae_file.rae28
DEFINE l_rae29      LIKE rae_file.rae29
DEFINE l_rae30      LIKE rae_file.rae30
DEFINE l_rae31      LIKE rae_file.rae31
DEFINE l_rbe03      LIKE rbe_file.rbe03
DEFINE l_raq04      LIKE raq_file.raq04
DEFINE l_n          LIKE type_file.num5
DEFINE l_cnt        LIKE type_file.num5
DEFINE l_sql        STRING

   #組合促銷
   LET l_rtz01 = p_rtz01
   #創建臨時表
   CALL i200_set_promote_comb_temp('cre')
      
   BEGIN WORK
   LET g_success = 'Y'
   #檢查當前門店是否存在對應生效組合促銷資料
   LET l_n = 0
   LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_rtz01,'rae_file'),
               "                    ,",cl_get_target_table(l_rtz01,'raq_file'),
               " WHERE rae01 = raq01 AND rae02 = raq02 AND raq04 = '",l_rtz01,"' AND raq03 = '2' AND raeconf = 'Y' AND raeplant = '",l_rtz01,"' "
   PREPARE sel_count_promote_pre1 FROM l_sql
   EXECUTE sel_count_promote_pre1 INTO l_n
   IF l_n < 1 THEN
      #組合促銷资料(artt303)
      INITIALIZE l_rae01,l_rae02 TO NULL #初始化
      LET l_sql = "SELECT DISTINCT rae01,rae02 FROM ",cl_get_target_table(g_rtz01,'rae_file'),
                  "                                ,",cl_get_target_table(g_rtz01,'raq_file'),
                  "                                ,",cl_get_target_table(g_rtz01,'rak_file'),                       
                  " WHERE rae01 = raq01 AND rae02 = raq02 AND raq04 = '",g_rtz01,"' AND raeconf = 'Y' AND raq05 = 'Y' ",
                  "   AND rae01 = rak01 AND rae02 = rak02 AND raq03 = '2' AND rak03 = '2' AND raeplant = '",g_rtz01,"' ",
                  "   AND rak06 <= '",g_today,"' AND rak07 >= '",g_today,"' "
      PREPARE sel_rae01_pre FROM l_sql
      DECLARE sel_rae01_cs  CURSOR FOR sel_rae01_pre
      FOREACH sel_rae01_cs  INTO l_rae01,l_rae02
         DELETE FROM rbe_temp
         DELETE FROM rbq_temp
         DELETE FROM rae_temp
         DELETE FROM rak_temp
         DELETE FROM raf_temp
         DELETE FROM rag_temp
         DELETE FROM rar_temp
         DELETE FROM ras_temp
         DELETE FROM rap_temp
         DELETE FROM raq_temp
         #如果組合促銷資料不為空則新增變更單(artt403)
         IF NOT cl_null(l_rae01) AND NOT cl_null(l_rae02) THEN
            #單頭對應欄位賦值
            LET l_sql = "SELECT rae03,rae08,rae09,rae10,rae11,rae12,rae13,rae14,rae15,rae16,rae17,rae18,rae19,rae20,rae21,",
                        "       rae23,rae24,rae25,rae26,rae27,rae28,rae29,rae30,rae31 FROM ",cl_get_target_table(l_rae01,'rae_file'),
                        " WHERE rae01 = '",l_rae01,"' AND rae02 = '",l_rae02,"' AND raeplant = '",g_rtz01,"' "
            PREPARE sel_rae_pre FROM l_sql
            EXECUTE sel_rae_pre INTO l_rae03,l_rae08,l_rae09,l_rae10,l_rae11,l_rae12,l_rae13,l_rae14,l_rae15,l_rae16,l_rae17,l_rae18,
                                     l_rae19,l_rae20,l_rae21,l_rae23,l_rae24,l_rae25,l_rae26,l_rae27,l_rae28,l_rae29,l_rae30,l_rae31
            LET l_sql = "SELECT MAX(rbe03) FROM ",cl_get_target_table(l_rae01,'rbe_file'),
                        " WHERE rbe01 = '",l_rae01,"' AND rbe02 = '",l_rae02,"' AND rbeplant = '",l_rae01,"' "
            PREPARE sel_rbe03_pre FROM l_sql
            EXECUTE sel_rbe03_pre INTO l_rbe03
            IF cl_null(l_rbe03) THEN
               LET l_rbe03 = 0
            END IF
            LET l_sql = "SELECT azw02 FROM ",cl_get_target_table(l_rae01,'azw_file'),
                        " WHERE azw01 = '",l_rae01,"' "
            PREPARE sel_azw02_pre9 FROM l_sql
            EXECUTE sel_azw02_pre9 INTO l_azw02
            LET l_rbe.rbe01    = l_rae01
            LET l_rbe.rbe02    = l_rae02
            LET l_rbe.rbe03    = l_rbe03 + 1
            LET l_rbe.rbe04    = ' '
            LET l_rbe.rbe04t   = ' '
            LET l_rbe.rbe05    = ' '
            LET l_rbe.rbe05t   = ' '
            LET l_rbe.rbe06    = ' '
            LET l_rbe.rbe06t   = ' '
            LET l_rbe.rbe07    = ' '
            LET l_rbe.rbe07t   = ' '
            LET l_rbe.rbe08    = l_rae08
            LET l_rbe.rbe08t   = l_rae08
            LET l_rbe.rbe09    = l_rae09
            LET l_rbe.rbe09t   = l_rae09
            LET l_rbe.rbe10    = l_rae10
            LET l_rbe.rbe10t   = l_rae10
            LET l_rbe.rbe11    = l_rae11
            LET l_rbe.rbe11t   = l_rae11
            LET l_rbe.rbe12    = l_rae12
            LET l_rbe.rbe12t   = l_rae12
            LET l_rbe.rbe13    = l_rae13
            LET l_rbe.rbe13t   = l_rae13
            LET l_rbe.rbe14    = l_rae14
            LET l_rbe.rbe14t   = l_rae14
            LET l_rbe.rbe15    = l_rae15
            LET l_rbe.rbe15t   = l_rae15
            LET l_rbe.rbe16    = l_rae16
            LET l_rbe.rbe16t   = l_rae16
            LET l_rbe.rbe17    = l_rae17
            LET l_rbe.rbe17t   = l_rae17
            LET l_rbe.rbe18    = l_rae18
            LET l_rbe.rbe18t   = l_rae18
            LET l_rbe.rbe19    = l_rae19
            LET l_rbe.rbe19t   = l_rae19
            LET l_rbe.rbe20    = l_rae20
            LET l_rbe.rbe20t   = l_rae20
            LET l_rbe.rbe21    = l_rae21
            LET l_rbe.rbe21t   = l_rae21
            LET l_rbe.rbe22    = ' '
            LET l_rbe.rbe23    = l_rae23
            LET l_rbe.rbe23t   = l_rae23
            LET l_rbe.rbe24    = l_rae24
            LET l_rbe.rbe24t   = l_rae24
            LET l_rbe.rbe25    = l_rae25
            LET l_rbe.rbe25t   = l_rae25
            LET l_rbe.rbe26    = l_rae26
            LET l_rbe.rbe26t   = l_rae26
            LET l_rbe.rbe27    = l_rae27
            LET l_rbe.rbe27t   = l_rae27
            LET l_rbe.rbe28    = l_rae28
            LET l_rbe.rbe28t   = l_rae28
            LET l_rbe.rbe29    = l_rae29
            LET l_rbe.rbe29t   = l_rae29
            LET l_rbe.rbe30    = l_rae30
            LET l_rbe.rbe30t   = l_rae30
            LET l_rbe.rbe31    = l_rae31
            LET l_rbe.rbe31t   = l_rae31
            LET l_rbe.rbe32    = l_rae03
            LET l_rbe.rbe900   = '0'
            LET l_rbe.rbeacti  = 'Y'
            LET l_rbe.rbecond  = ' '
            LET l_rbe.rbeconf  = 'N'
            LET l_rbe.rbeconu  = ' '
            LET l_rbe.rbecrat  = g_today
            LET l_rbe.rbedate  = ' '
            LET l_rbe.rbedays  = ' '
            LET l_rbe.rbegrup  = g_grup
            LET l_rbe.rbelegal = l_azw02 
            LET l_rbe.rbemksg  = 'N'
            LET l_rbe.rbemodu  = ' '
            LET l_rbe.rbeorig  = g_grup
            LET l_rbe.rbeoriu  = g_user
            LET l_rbe.rbeplant = l_rae01
            LET l_rbe.rbeprit  = ' '
            LET l_rbe.rbesign  = ' '
            LET l_rbe.rbesmax  = ' '
            LET l_rbe.rbesseq  = ' '
            LET l_rbe.rbeuser  = g_user

            #INSERT 單頭
            INSERT INTO rbe_temp VALUES (l_rbe.*)
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('ins','rbe_temp','',SQLCA.SQLCODE,1)
               LET g_success = 'N'
               CALL i200_set_promote_comb_temp('del')
               RETURN
            END IF

            #將當前門店新增至組合促銷資料變更單的生效範圍中
            LET l_sql = "INSERT INTO rbq_temp ",
                        "SELECT rbe01,rbe02,rbe03,'2','1','1','",l_rtz01,"','N','Y','",l_azw02,"',rbe01,' ' FROM rbe_temp "
            PREPARE ins_rbq_temp_pre1 FROM l_sql
            EXECUTE ins_rbq_temp_pre1
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('ins','rbq_temp','',SQLCA.SQLCODE,1)
               LET g_success = 'N'
               CALL i200_set_promote_comb_temp('del')
               RETURN
            END IF
      
            #審核該筆組合促銷變更單
            UPDATE rbe_temp SET rbe900 = '1',rbecond = g_today,rbeconf = 'Y',rbeconu = g_user,
                                rbemodu = g_user,rbedate = g_today 
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('upd','rbe_temp','',SQLCA.SQLCODE,1)
               LET g_success = 'N'
               CALL i200_set_promote_comb_temp('del')
               RETURN
            END IF
      
            #更新變更生效範圍發佈否欄位值
            UPDATE rbq_temp SET rbq08 = 'Y'
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('upd','rbq_temp','',SQLCA.SQLCODE,1)
               LET g_success = 'N'
               CALL i200_set_promote_comb_temp('del')
               RETURN
            END IF
   
            #遍歷生效門店
            INITIALIZE l_raq04,l_azw02 TO NULL #初始化
            LET l_sql = "SELECT DISTINCT raq04 FROM ",cl_get_target_table(l_rae01,'raq_file'),
                        " WHERE raq01 = '",l_rae01,"' AND raq02 = '",l_rae02,"' AND raq03 = '2' AND raq04 <> '",l_rtz01,"' "
            PREPARE sel_raq04_pre1 FROM l_sql
            DECLARE sel_raq04_cs1  CURSOR FOR sel_raq04_pre1
            FOREACH sel_raq04_cs1  INTO l_raq04
               #添加一筆生效門店為當前門店的資料
               LET l_sql = "SELECT azw02 FROM ",cl_get_target_table(l_raq04,'azw_file'),
                           " WHERE azw01 = '",l_raq04,"' "
               PREPARE sel_azw02_pre10 FROM l_sql
               EXECUTE sel_azw02_pre10 INTO l_azw02
               LET l_sql = "INSERT INTO ",cl_get_target_table(l_raq04,'raq_file'),
                           "            (raq01,raq02,raq03,raq04,raq05,raq06,raq07,raq08,raqacti,raqlegal,raqplant) ",
                           "     VALUES ('",l_rae01,"', ",
                           "             '",l_rae02,"', ",
                           "             '2', ",
                           "             '",l_rtz01,"', ",
                           "             'Y', ",
                           "             '",g_today,"', ",
                           "             '",TIME,"', ",
                           "             ' ', ",
                           "             'Y', ",
                           "             '",l_azw02,"', ",
                           "             '",l_raq04,"') "
               PREPARE ins_raq_raq04_pre1 FROM l_sql
               EXECUTE ins_raq_raq04_pre1
               IF STATUS OR SQLCA.SQLCODE THEN
                  CALL s_errmsg('ins','raq_file','',SQLCA.SQLCODE,1)
                  LET g_success = 'N'
                  CALL i200_set_promote_comb_temp('del')
                  RETURN
               END IF
               
               #更新對應組合促銷資料的已傳POS欄位
               LET l_sql = " SELECT raepos FROM ",cl_get_target_table(l_raq04,'rae_file'),
                           "  WHERE rae01 = '",l_rae01,"' AND rae02 = '",l_rae02,"' AND raeplant = '",l_raq04,"' "
               PREPARE sel_raepos_pre FROM l_sql
               DECLARE sel_raepos_curs CURSOR FOR sel_raepos_pre
               FOREACH sel_raepos_curs INTO l_raepos
                  IF l_raepos <> '1' THEN
                     LET l_sql = " UPDATE ",cl_get_target_table(l_raq04,'rae_file'),
                                 "    SET raepos = '2' ",
                                 "  WHERE rae01  = '",l_rae01,"' AND rae02 = '",l_rae02,"' AND raeplant = '",l_raq04,"' "
                     PREPARE upd_raepos_pre FROM l_sql
                     EXECUTE upd_raepos_pre
                     IF STATUS OR SQLCA.SQLCODE THEN
                        CALL s_errmsg('upd','rae_file','',SQLCA.SQLCODE,1)
                        LET g_success = 'N'
                        CALL i200_set_promote_comb_temp('del')
                        RETURN
                     END IF
                  ELSE
                     LET l_sql = " UPDATE ",cl_get_target_table(l_raq04,'rae_file'),
                                 "    SET raepos = '1' ",
                                 "  WHERE rae01  = '",l_rae01,"' AND rae02 = '",l_rae02,"' AND raeplant = '",l_raq04,"' "
                     PREPARE upd_raepos_pre1 FROM l_sql
                     EXECUTE upd_raepos_pre1
                     IF STATUS OR SQLCA.SQLCODE THEN
                        CALL s_errmsg('upd','rae_file','',SQLCA.SQLCODE,1)
                        LET g_success = 'N'
                        CALL i200_set_promote_comb_temp('del')
                        RETURN
                     END IF
                  END IF
               END FOREACH 
            END FOREACH

            #在當前門店新增組合促銷資料
            #Ins rae_temp
            LET l_sql = "INSERT INTO rae_temp ",
                        "SELECT * FROM ",cl_get_target_table(g_rtz01,'rae_file'),
                        " WHERE rae01    = '",l_rae01,"' ",
                        "   AND rae02    = '",l_rae02,"' ",
                        "   AND raeplant = '",g_rtz01,"' "
            PREPARE ins_rae_temp_pre FROM l_sql
            EXECUTE ins_rae_temp_pre
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('ins','rae_temp','',SQLCA.SQLCODE,1)
               LET g_success = 'N'
               CALL i200_set_promote_comb_temp('del')
               RETURN
            END IF
            #Ins rak_temp
            LET l_sql = "INSERT INTO rak_temp ",
                        "SELECT * FROM ",cl_get_target_table(g_rtz01,'rak_file'),
                        " WHERE rak01    = '",l_rae01,"' ",
                        "   AND rak02    = '",l_rae02,"' ",
                        "   AND rakplant = '",g_rtz01,"' "
            PREPARE ins_rak_temp_pre1 FROM l_sql
            EXECUTE ins_rak_temp_pre1
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('ins','rak_temp','',SQLCA.SQLCODE,1)
               LET g_success = 'N'
               CALL i200_set_promote_comb_temp('del')
               RETURN
            END IF
            #Ins raf_temp
            LET l_sql = "INSERT INTO raf_temp ",
                        "SELECT * FROM ",cl_get_target_table(g_rtz01,'raf_file'),
                        " WHERE raf01    = '",l_rae01,"' ",
                        "   AND raf02    = '",l_rae02,"' ",
                        "   AND rafplant = '",g_rtz01,"' "
            PREPARE ins_raf_temp_pre FROM l_sql
            EXECUTE ins_raf_temp_pre
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('ins','raf_temp','',SQLCA.SQLCODE,1)
               LET g_success = 'N'
               CALL i200_set_promote_comb_temp('del')
               RETURN
            END IF
            #Ins rag_temp
            LET l_sql = "INSERT INTO rag_temp ",
                        "SELECT * FROM ",cl_get_target_table(g_rtz01,'rag_file'),
                        " WHERE rag01    = '",l_rae01,"' ",
                        "   AND rag02    = '",l_rae02,"' ",
                        "   AND ragplant = '",g_rtz01,"' "
            PREPARE ins_rag_temp_pre1 FROM l_sql
            EXECUTE ins_rag_temp_pre1
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('ins','rag_temp','',SQLCA.SQLCODE,1)
               LET g_success = 'N'
               CALL i200_set_promote_comb_temp('del')
               RETURN
            END IF
            #Ins rar_temp
            LET l_sql = "INSERT INTO rar_temp ",
                        "SELECT * FROM ",cl_get_target_table(g_rtz01,'rar_file'),
                        " WHERE rar01    = '",l_rae01,"' ",
                        "   AND rar02    = '",l_rae02,"' ",
                        "   AND rar03    = '2' ",
                        "   AND rarplant = '",g_rtz01,"' "
            PREPARE ins_rar_temp_pre1 FROM l_sql
            EXECUTE ins_rar_temp_pre1
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('ins','rar_temp','',SQLCA.SQLCODE,1)
               LET g_success = 'N'
               CALL i200_set_promote_comb_temp('del')
               RETURN
            END IF
            #Ins ras_temp
            LET l_sql = "INSERT INTO ras_temp ",
                        "SELECT * FROM ",cl_get_target_table(g_rtz01,'ras_file'),
                        " WHERE ras01    = '",l_rae01,"' ",
                        "   AND ras02    = '",l_rae02,"' ",
                        "   AND ras03    = '2' ",
                        "   AND rasplant = '",g_rtz01,"' "
            PREPARE ins_ras_temp_pre1 FROM l_sql
            EXECUTE ins_ras_temp_pre1
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('ins','ras_temp','',SQLCA.SQLCODE,1)
               LET g_success = 'N'
               CALL i200_set_promote_comb_temp('del')
               RETURN
            END IF
            #Ins rap_temp
            LET l_sql = "INSERT INTO rap_temp ",
                        "SELECT * FROM ",cl_get_target_table(g_rtz01,'rap_file'),
                        " WHERE rap01    = '",l_rae01,"' ",
                        "   AND rap02    = '",l_rae02,"' ",
                        "   AND rap03    = '2' ",
                        "   AND rapplant = '",g_rtz01,"' "
            PREPARE ins_rap_temp_pre2 FROM l_sql
            EXECUTE ins_rap_temp_pre2
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('ins','rap_temp','',SQLCA.SQLCODE,1)
               LET g_success = 'N'
               CALL i200_set_promote_comb_temp('del')
               RETURN
            END IF
            #Ins raq_temp
            LET l_sql = "INSERT INTO raq_temp ",
                        "SELECT * FROM ",cl_get_target_table(g_rtz01,'raq_file'),
                        " WHERE raq01    = '",l_rae01,"' ",
                        "   AND raq02    = '",l_rae02,"' ",
                        "   AND raq03    = '2' ",
                        "   AND raqplant = '",g_rtz01,"' "
            PREPARE ins_raq_temp_pre2 FROM l_sql
            EXECUTE ins_raq_temp_pre2
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('ins','raq_temp','',SQLCA.SQLCODE,1)
               LET g_success = 'N'
               CALL i200_set_promote_comb_temp('del')
               RETURN
            END IF
   
            #更新所屬門店/法人和狀態頁簽和已傳POS否
            LET l_sql = "SELECT azw02 FROM ",cl_get_target_table(l_rtz01,'azw_file'),
                        " WHERE azw01 = '",l_rtz01,"' "
            PREPARE sel_azw02_pre11 FROM l_sql
            EXECUTE sel_azw02_pre11 INTO l_azw02
            UPDATE rae_temp SET raeplant = l_rtz01,raelegal = l_azw02,
                                raecond = g_today,raeconf = 'Y',raeconu = g_user,raecrat = g_today,
                                raedate = g_today,raegrup = g_grup,raemodu = g_user,raeorig = g_grup,
                                raeoriu = g_user,raeuser = g_user,raepos = '1'
            UPDATE rak_temp SET rakcrdate = g_today,rakdate = g_today,rakgrup = g_grup,
                                raklegal = l_azw02,rakmodu = g_user,rakorig = g_grup,
                                rakoriu = g_user,rakplant = l_rtz01,rakuser = g_user,rakpos = '1'
            UPDATE raf_temp SET raflegal = l_azw02,rafplant = l_rtz01
            UPDATE rag_temp SET raglegal = l_azw02,ragplant = l_rtz01
            UPDATE rar_temp SET rarlegal = l_azw02,rarplant = l_rtz01
            UPDATE ras_temp SET raslegal = l_azw02,rasplant = l_rtz01
            UPDATE rap_temp SET raplegal = l_azw02,rapplant = l_rtz01
            UPDATE raq_temp SET raq06 = g_today,raqlegal = l_azw02,raqplant = l_rtz01

            #將臨時表資料Insert到數據庫
            #变更单跨库到制定门店/基本资料跨库到当前门店
            LET l_sql = " INSERT INTO ",cl_get_target_table(l_rae01,'rbe_file'),
                        " SELECT * FROM rbe_temp"
            PREPARE trans_ins_rbe FROM l_sql
            EXECUTE trans_ins_rbe
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('ins','rbe_file','',SQLCA.SQLCODE,1)
               LET g_success = 'N' 
               CALL i200_set_promote_comb_temp('del')
               RETURN
            END IF
            LET l_sql = " INSERT INTO ",cl_get_target_table(l_rae01,'rbq_file'),
                        " SELECT * FROM rbq_temp"
            PREPARE trans_ins_rbq_1 FROM l_sql
            EXECUTE trans_ins_rbq_1
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('ins','rbq_file','',SQLCA.SQLCODE,1)
               LET g_success = 'N' 
               CALL i200_set_promote_comb_temp('del')
               RETURN
            END IF
            LET l_sql = " INSERT INTO ",cl_get_target_table(l_rtz01,'rae_file'),
                        " SELECT * FROM rae_temp"
            PREPARE trans_ins_rae FROM l_sql
            EXECUTE trans_ins_rae
            LET l_cnt = SQLCA.sqlerrd[3]+l_cnt
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('ins','rae_file','',SQLCA.SQLCODE,1)
               LET g_success = 'N'
               CALL i200_set_promote_comb_temp('del')
               RETURN
            END IF
            LET l_sql = " INSERT INTO ",cl_get_target_table(l_rtz01,'rak_file'),
                        " SELECT * FROM rak_temp"
            PREPARE trans_ins_rak1 FROM l_sql
            EXECUTE trans_ins_rak1
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('ins','rak_file','',SQLCA.SQLCODE,1)
               LET g_success = 'N'
               CALL i200_set_promote_comb_temp('del')
               RETURN
            END IF
            LET l_sql = " INSERT INTO ",cl_get_target_table(l_rtz01,'raf_file'),
                        " SELECT * FROM raf_temp"
            PREPARE trans_ins_raf FROM l_sql
            EXECUTE trans_ins_raf
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('ins','raf_file','',SQLCA.SQLCODE,1)
               LET g_success = 'N'
               CALL i200_set_promote_comb_temp('del')
               RETURN
            END IF
            LET l_sql = " INSERT INTO ",cl_get_target_table(l_rtz01,'rag_file'),
                        " SELECT * FROM rag_temp"
            PREPARE trans_ins_rag FROM l_sql
            EXECUTE trans_ins_rag
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('ins','rag_file','',SQLCA.SQLCODE,1)
               LET g_success = 'N'
               CALL i200_set_promote_comb_temp('del')
               RETURN
            END IF
            LET l_sql = " INSERT INTO ",cl_get_target_table(l_rtz01,'rar_file'),
                        " SELECT * FROM rar_temp"
            PREPARE trans_ins_rar FROM l_sql
            EXECUTE trans_ins_rar
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('ins','rar_file','',SQLCA.SQLCODE,1)
               LET g_success = 'N'
               CALL i200_set_promote_comb_temp('del')
               RETURN
            END IF
            LET l_sql = " INSERT INTO ",cl_get_target_table(l_rtz01,'ras_file'),
                        " SELECT * FROM ras_temp"
            PREPARE trans_ins_ras FROM l_sql
            EXECUTE trans_ins_ras
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('ins','ras_file','',SQLCA.SQLCODE,1)
               LET g_success = 'N'
               CALL i200_set_promote_comb_temp('del')
               RETURN
            END IF
            LET l_sql = " INSERT INTO ",cl_get_target_table(l_rtz01,'rap_file'),
                        " SELECT * FROM rap_temp"
            PREPARE trans_ins_rap_1 FROM l_sql
            EXECUTE trans_ins_rap_1
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('ins','rap_file','',SQLCA.SQLCODE,1)
               LET g_success = 'N'
               CALL i200_set_promote_comb_temp('del')
               RETURN
            END IF
            LET l_sql = " INSERT INTO ",cl_get_target_table(l_rtz01,'raq_file'),
                        " SELECT * FROM raq_temp"
            PREPARE trans_ins_raq_1 FROM l_sql
            EXECUTE trans_ins_raq_1
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('ins','raq_file','',SQLCA.SQLCODE,1)
               LET g_success = 'N'
               CALL i200_set_promote_comb_temp('del')
               RETURN
            END IF
         END IF
      END FOREACH
      LET g_msg1 = cl_getmsg("art1123",g_lang)         #組合促銷資料
      LET g_msg2 = cl_getmsg("anm-973",g_lang),l_cnt   #成功笔数: 
      IF l_cnt > 0 THEN
         CALL s_errmsg(g_msg1,g_msg2,'INSERT INTO rae_file',SQLCA.sqlcode,2)
      ELSE
         CALL s_errmsg(g_msg1,g_msg2,'','art1113',2)   #參考門店無對應資料
      END IF
   ELSE
      LET l_cnt = 0
      LET g_msg1 = cl_getmsg("art1123",g_lang)
      LET g_msg2 = cl_getmsg("anm-973",g_lang),l_cnt
      CALL s_errmsg(g_msg1,g_msg2,'','art1101',1)      #已經存在此資料
   END IF

   IF g_success = 'Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF

   #刪除臨時表
   CALL i200_set_promote_comb_temp('del')
   
END FUNCTION

#滿額促銷資料
FUNCTION i200_set_promote_full(p_rtz01)
DEFINE l_rbh  RECORD LIKE rbh_file.*
DEFINE l_rtz01       LIKE rtz_file.rtz01
DEFINE p_rtz01       LIKE rtz_file.rtz01
DEFINE l_rah01       LIKE rah_file.rah01
DEFINE l_rah02       LIKE rah_file.rah02
DEFINE l_rah03       LIKE rah_file.rah03
DEFINE l_rah08       LIKE rah_file.rah08
DEFINE l_rah09       LIKE rah_file.rah09
DEFINE l_rah10       LIKE rah_file.rah10
DEFINE l_rah11       LIKE rah_file.rah11
DEFINE l_rah12       LIKE rah_file.rah12
DEFINE l_rah13       LIKE rah_file.rah13
DEFINE l_rah14       LIKE rah_file.rah14
DEFINE l_rah15       LIKE rah_file.rah15
DEFINE l_rah16       LIKE rah_file.rah16
DEFINE l_rah17       LIKE rah_file.rah17
DEFINE l_rah18       LIKE rah_file.rah18
DEFINE l_rah19       LIKE rah_file.rah19
DEFINE l_rah20       LIKE rah_file.rah20
DEFINE l_rah21       LIKE rah_file.rah21
DEFINE l_rah22       LIKE rah_file.rah22
DEFINE l_rah23       LIKE rah_file.rah23
DEFINE l_rah25       LIKE rah_file.rah25
DEFINE l_rbh03       LIKE rbh_file.rbh03
DEFINE l_azw02       LIKE azw_file.azw02
DEFINE l_raq04       LIKE raq_file.raq04
DEFINE l_rahpos      LIKE rah_file.rahpos
DEFINE l_n           LIKE type_file.num5
DEFINE l_cnt         LIKE type_file.num5
DEFINE l_sql         STRING

   #滿額促銷
   LET l_rtz01 = p_rtz01

   #創建臨時表
   CALL i200_set_promote_full_temp('cre')
   
   BEGIN WORK
   LET g_success = 'Y'
   #檢查當前門店是否存在對應生效滿額促銷資料
   LET l_n = 0
   LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_rtz01,'rah_file'),
               "                    ,",cl_get_target_table(l_rtz01,'raq_file'),
               " WHERE rah01 = raq01 AND rah02 = raq02 AND raq04 = '",l_rtz01,"' AND raq03 = '3' AND rahconf = 'Y' AND rahplant = '",l_rtz01,"' "
   PREPARE sel_count_promote_pre2 FROM l_sql
   EXECUTE sel_count_promote_pre2 INTO l_n
   IF l_n < 1 THEN
      #滿額促銷资料(artt304)
      INITIALIZE l_rah01,l_rah02 TO NULL #初始化
      LET l_sql = "SELECT DISTINCT rah01,rah02 FROM ",cl_get_target_table(g_rtz01,'rah_file'),
                  "                                ,",cl_get_target_table(g_rtz01,'raq_file'),
                  "                                ,",cl_get_target_table(g_rtz01,'rak_file'),                       
                  " WHERE rah01 = raq01 AND rah02 = raq02 AND raq04 = '",g_rtz01,"' AND rahconf = 'Y' AND raq05 = 'Y' ",
                  "   AND rah01 = rak01 AND rah02 = rak02 AND raq03 = '3' AND rak03 = '3' AND rahplant = '",g_rtz01,"' ",
                  "   AND rak06 <= '",g_today,"' AND rak07 >= '",g_today,"' "
      PREPARE sel_rah01_pre FROM l_sql
      DECLARE sel_rah01_cs  CURSOR FOR sel_rah01_pre
      FOREACH sel_rah01_cs  INTO l_rah01,l_rah02
         DELETE FROM rbh_temp
         DELETE FROM rbq_temp
         DELETE FROM rah_temp
         DELETE FROM rak_temp
         DELETE FROM rai_temp
         DELETE FROM rar_temp
         DELETE FROM ras_temp
         DELETE FROM rap_temp
         DELETE FROM raq_temp
         #如果滿額促銷資料不為空則新增變更單(artt404)
         IF NOT cl_null(l_rah01) AND NOT cl_null(l_rah02) THEN
            #單頭對應欄位賦值
            LET l_sql = "SELECT rah03,rah08,rah09,rah10,rah11,rah12,rah13,rah14,rah15,rah16,rah17,rah18,rah19,rah20,rah21,",
                        "       rah22,rah23,rah25 FROM ",cl_get_target_table(l_rah01,'rah_file'),
                        " WHERE rah01 = '",l_rah01,"' AND rah02 = '",l_rah02,"' AND rahplant = '",g_rtz01,"' "
            PREPARE sel_rah_pre FROM l_sql
            EXECUTE sel_rah_pre INTO l_rah03,l_rah08,l_rah09,l_rah10,l_rah11,l_rah12,l_rah13,l_rah14,l_rah15,l_rah16,l_rah17,l_rah18,
                                     l_rah19,l_rah20,l_rah21,l_rah22,l_rah23,l_rah25
            LET l_sql = "SELECT MAX(rbh03) FROM ",cl_get_target_table(l_rah01,'rbh_file'),
                        " WHERE rbh01 = '",l_rah01,"' AND rbh02 = '",l_rah02,"' AND rbhplant = '",l_rah01,"' "
            PREPARE sel_rbh03_pre FROM l_sql
            EXECUTE sel_rbh03_pre INTO l_rbh03
            IF cl_null(l_rbh03) THEN
               LET l_rbh03 = 0
            END IF
            LET l_sql = "SELECT azw02 FROM ",cl_get_target_table(l_rah01,'azw_file'),
                        " WHERE azw01 = '",l_rah01,"' "
            PREPARE sel_azw02_pre12 FROM l_sql
            EXECUTE sel_azw02_pre12 INTO l_azw02
            LET l_rbh.rbh01    = l_rah01
            LET l_rbh.rbh02    = l_rah02
            LET l_rbh.rbh03    = l_rbh03 + 1
            LET l_rbh.rbh04    = ' '
            LET l_rbh.rbh04t   = ' '
            LET l_rbh.rbh05    = ' '
            LET l_rbh.rbh05t   = ' '
            LET l_rbh.rbh06    = ' '
            LET l_rbh.rbh06t   = ' '
            LET l_rbh.rbh07    = ' '
            LET l_rbh.rbh07t   = ' '
            LET l_rbh.rbh08    = l_rah08
            LET l_rbh.rbh08t   = l_rah08
            LET l_rbh.rbh09    = l_rah09
            LET l_rbh.rbh09t   = l_rah09
            LET l_rbh.rbh10    = l_rah10
            LET l_rbh.rbh10t   = l_rah10
            LET l_rbh.rbh11    = l_rah11
            LET l_rbh.rbh11t   = l_rah11
            LET l_rbh.rbh12    = l_rah12
            LET l_rbh.rbh12t   = l_rah12
            LET l_rbh.rbh13    = l_rah13
            LET l_rbh.rbh13t   = l_rah13
            LET l_rbh.rbh14    = l_rah14
            LET l_rbh.rbh14t   = l_rah14
            LET l_rbh.rbh15    = l_rah15
            LET l_rbh.rbh15t   = l_rah15
            LET l_rbh.rbh16    = l_rah16
            LET l_rbh.rbh16t   = l_rah16
            LET l_rbh.rbh17    = l_rah17
            LET l_rbh.rbh17t   = l_rah17
            LET l_rbh.rbh18    = l_rah18
            LET l_rbh.rbh18t   = l_rah18
            LET l_rbh.rbh19    = l_rah19
            LET l_rbh.rbh19t   = l_rah19
            LET l_rbh.rbh20    = l_rah20
            LET l_rbh.rbh20t   = l_rah20
            LET l_rbh.rbh21    = l_rah21
            LET l_rbh.rbh21t   = l_rah21
            LET l_rbh.rbh22    = l_rah22
            LET l_rbh.rbh22t   = l_rah22
            LET l_rbh.rbh23    = l_rah23
            LET l_rbh.rbh23t   = l_rah23
            LET l_rbh.rbh24    = ' '
            LET l_rbh.rbh25    = l_rah25
            LET l_rbh.rbh25t   = l_rah25
            LET l_rbh.rbh26    = l_rah03
            LET l_rbh.rbh900   = '0'
            LET l_rbh.rbhacti  = 'Y'
            LET l_rbh.rbhcond  = ' '
            LET l_rbh.rbhconf  = 'N'
            LET l_rbh.rbhcont  = ' '
            LET l_rbh.rbhconu  = ' '
            LET l_rbh.rbhcrat  = g_today
            LET l_rbh.rbhdate  = ' '
            LET l_rbh.rbhdays  = ' '
            LET l_rbh.rbhgrup  = g_grup
            LET l_rbh.rbhlegal = l_azw02 
            LET l_rbh.rbhmksg  = 'N'
            LET l_rbh.rbhmodu  = ' '
            LET l_rbh.rbhorig  = g_grup
            LET l_rbh.rbhoriu  = g_user
            LET l_rbh.rbhplant = l_rah01
            LET l_rbh.rbhprit  = ' '
            LET l_rbh.rbhsign  = ' '
            LET l_rbh.rbhsmax  = ' '
            LET l_rbh.rbhsseq  = ' '
            LET l_rbh.rbhuser  = g_user

            #INSERT 單頭
            INSERT INTO rbh_temp VALUES (l_rbh.*)
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('ins','rbh_temp','',SQLCA.SQLCODE,1)
               LET g_success = 'N'
               CALL i200_set_promote_full_temp('del')
               RETURN
            END IF

            #將當前門店新增至滿額促銷資料變更單的生效範圍中
            LET l_sql = "INSERT INTO rbq_temp ",
                        "SELECT rbh01,rbh02,rbh03,'3','1','1','",l_rtz01,"','N','Y','",l_azw02,"',rbh01,' ' FROM rbh_temp "
            PREPARE ins_rbq_temp_pre2 FROM l_sql
            EXECUTE ins_rbq_temp_pre2
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('ins','rbq_temp','',SQLCA.SQLCODE,1)
               LET g_success = 'N'
               CALL i200_set_promote_full_temp('del')
               RETURN
            END IF
      
            #審核該筆滿額促銷變更單
            UPDATE rbh_temp SET rbh900 = '1',rbhcond = g_today,rbhconf = 'Y',rbhconu = g_user,
                                rbhmodu = g_user,rbhdate = g_today 
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('upd','rbh_temp','',SQLCA.SQLCODE,1)
               LET g_success = 'N'
               CALL i200_set_promote_full_temp('del')
               RETURN
            END IF
      
            #更新變更生效範圍發佈否欄位值
            UPDATE rbq_temp SET rbq08 = 'Y'
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('upd','rbq_temp','',SQLCA.SQLCODE,1)
               LET g_success = 'N'
               CALL i200_set_promote_full_temp('del')
               RETURN
            END IF
   
            #遍歷生效門店
            INITIALIZE l_raq04,l_azw02 TO NULL #初始化
            LET l_sql = "SELECT DISTINCT raq04 FROM ",cl_get_target_table(l_rah01,'raq_file'),
                        " WHERE raq01 = '",l_rah01,"' AND raq02 = '",l_rah02,"' AND raq03 = '3' AND raq04 <> '",l_rtz01,"' "
            PREPARE sel_raq04_pre2 FROM l_sql
            DECLARE sel_raq04_cs2  CURSOR FOR sel_raq04_pre2
            FOREACH sel_raq04_cs2  INTO l_raq04
               #添加一筆生效門店為當前門店的資料
               LET l_sql = "SELECT azw02 FROM ",cl_get_target_table(l_raq04,'azw_file'),
                           " WHERE azw01 = '",l_raq04,"' "
               PREPARE sel_azw02_pre13 FROM l_sql
               EXECUTE sel_azw02_pre13 INTO l_azw02
               LET l_sql = "INSERT INTO ",cl_get_target_table(l_raq04,'raq_file'),
                           "            (raq01,raq02,raq03,raq04,raq05,raq06,raq07,raq08,raqacti,raqlegal,raqplant) ",
                           "     VALUES ('",l_rah01,"', ",
                           "             '",l_rah02,"', ",
                           "             '3', ",
                           "             '",l_rtz01,"', ",
                           "             'Y', ",
                           "             '",g_today,"', ",
                           "             '",TIME,"', ",
                           "             ' ', ",
                           "             'Y', ",
                           "             '",l_azw02,"', ",
                           "             '",l_raq04,"') "
               PREPARE ins_raq_raq04_pre2 FROM l_sql
               EXECUTE ins_raq_raq04_pre2
               IF STATUS OR SQLCA.SQLCODE THEN
                  CALL s_errmsg('ins','raq_file','',SQLCA.SQLCODE,1)
                  LET g_success = 'N'
                  CALL i200_set_promote_full_temp('del')
                  RETURN
               END IF
               
               #更新對應滿額促銷資料的已傳POS欄位
               LET l_sql = " SELECT rahpos FROM ",cl_get_target_table(l_raq04,'rah_file'),
                           "  WHERE rah01 = '",l_rah01,"' AND rah02 = '",l_rah02,"' AND rahplant = '",l_raq04,"' "
               PREPARE sel_rahpos_pre  FROM l_sql
               DECLARE sel_rahpos_curs CURSOR FOR sel_rahpos_pre
               FOREACH sel_rahpos_curs INTO l_rahpos
                  IF l_rahpos <> '1' THEN
                     LET l_sql = " UPDATE ",cl_get_target_table(l_raq04,'rah_file'),
                                 "    SET rahpos = '2' ",
                                 "  WHERE rah01  = '",l_rah01,"' AND rah02 = '",l_rah02,"' AND rahplant = '",l_raq04,"' "
                     PREPARE upd_rahpos_pre FROM l_sql
                     EXECUTE upd_rahpos_pre
                     IF STATUS OR SQLCA.SQLCODE THEN
                        CALL s_errmsg('upd','rah_file','',SQLCA.SQLCODE,1)
                        LET g_success = 'N'
                        CALL i200_set_promote_full_temp('del')
                        RETURN
                     END IF
                  ELSE
                     LET l_sql = " UPDATE ",cl_get_target_table(l_raq04,'rah_file'),
                                 "    SET rahpos = '1' ",
                                 "  WHERE rah01  = '",l_rah01,"' AND rah02 = '",l_rah02,"' AND rahplant = '",l_raq04,"' "
                     PREPARE upd_rahpos_pre1 FROM l_sql
                     EXECUTE upd_rahpos_pre1
                     IF STATUS OR SQLCA.SQLCODE THEN
                        CALL s_errmsg('upd','rah_file','',SQLCA.SQLCODE,1)
                        LET g_success = 'N'
                        CALL i200_set_promote_full_temp('del')
                        RETURN
                     END IF
                  END IF
               END FOREACH 
            END FOREACH

            #在當前門店新增滿額促銷資料
            #Ins rah_temp
            LET l_sql = "INSERT INTO rah_temp ",
                        "SELECT * FROM ",cl_get_target_table(g_rtz01,'rah_file'),
                        " WHERE rah01    = '",l_rah01,"' ",
                        "   AND rah02    = '",l_rah02,"' ",
                        "   AND rahplant = '",g_rtz01,"' "
            PREPARE ins_rah_temp_pre FROM l_sql
            EXECUTE ins_rah_temp_pre
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('ins','rah_temp','',SQLCA.SQLCODE,1)
               LET g_success = 'N'
               CALL i200_set_promote_full_temp('del')
               RETURN
            END IF
            #Ins rak_temp
            LET l_sql = "INSERT INTO rak_temp ",
                        "SELECT * FROM ",cl_get_target_table(g_rtz01,'rak_file'),
                        " WHERE rak01    = '",l_rah01,"' ",
                        "   AND rak02    = '",l_rah02,"' ",
                        "   AND rakplant = '",g_rtz01,"' "
            PREPARE ins_rak_temp_pre2 FROM l_sql
            EXECUTE ins_rak_temp_pre2
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('ins','rak_temp','',SQLCA.SQLCODE,1)
               LET g_success = 'N'
               CALL i200_set_promote_full_temp('del')
               RETURN
            END IF
            #Ins rai_temp
            LET l_sql = "INSERT INTO rai_temp ",
                        "SELECT * FROM ",cl_get_target_table(g_rtz01,'rai_file'),
                        " WHERE rai01    = '",l_rah01,"' ",
                        "   AND rai02    = '",l_rah02,"' ",
                        "   AND raiplant = '",g_rtz01,"' "
            PREPARE ins_rai_temp_pre FROM l_sql
            EXECUTE ins_rai_temp_pre
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('ins','rai_temp','',SQLCA.SQLCODE,1)
               LET g_success = 'N'
               CALL i200_set_promote_full_temp('del')
               RETURN
            END IF
            #Ins rar_temp
            LET l_sql = "INSERT INTO rar_temp ",
                        "SELECT * FROM ",cl_get_target_table(g_rtz01,'rar_file'),
                        " WHERE rar01    = '",l_rah01,"' ",
                        "   AND rar02    = '",l_rah02,"' ",
                        "   AND rar03    = '3' ",
                        "   AND rarplant = '",g_rtz01,"' "
            PREPARE ins_rar_temp_pre2 FROM l_sql
            EXECUTE ins_rar_temp_pre2
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('ins','rar_temp','',SQLCA.SQLCODE,1)
               LET g_success = 'N'
               CALL i200_set_promote_full_temp('del')
               RETURN
            END IF
            #Ins ras_temp
            LET l_sql = "INSERT INTO ras_temp ",
                        "SELECT * FROM ",cl_get_target_table(g_rtz01,'ras_file'),
                        " WHERE ras01    = '",l_rah01,"' ",
                        "   AND ras02    = '",l_rah02,"' ",
                        "   AND ras03    = '3' ",
                        "   AND rasplant = '",g_rtz01,"' "
            PREPARE ins_ras_temp_pre2 FROM l_sql
            EXECUTE ins_ras_temp_pre2
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('ins','ras_temp','',SQLCA.SQLCODE,1)
               LET g_success = 'N'
               CALL i200_set_promote_full_temp('del')
               RETURN
            END IF
            #Ins rap_temp
            LET l_sql = "INSERT INTO rap_temp ",
                        "SELECT * FROM ",cl_get_target_table(g_rtz01,'rap_file'),
                        " WHERE rap01    = '",l_rah01,"' ",
                        "   AND rap02    = '",l_rah02,"' ",
                        "   AND rap03    = '3' ",
                        "   AND rapplant = '",g_rtz01,"' "
            PREPARE ins_rap_temp_pre3 FROM l_sql
            EXECUTE ins_rap_temp_pre3
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('ins','rap_temp','',SQLCA.SQLCODE,1)
               LET g_success = 'N'
               CALL i200_set_promote_full_temp('del')
               RETURN
            END IF
            #Ins raq_temp
            LET l_sql = "INSERT INTO raq_temp ",
                        "SELECT * FROM ",cl_get_target_table(g_rtz01,'raq_file'),
                        " WHERE raq01    = '",l_rah01,"' ",
                        "   AND raq02    = '",l_rah02,"' ",
                        "   AND raq03    = '3' ",
                        "   AND raqplant = '",g_rtz01,"' "
            PREPARE ins_raq_temp_pre3 FROM l_sql
            EXECUTE ins_raq_temp_pre3
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('ins','raq_temp','',SQLCA.SQLCODE,1)
               LET g_success = 'N'
               CALL i200_set_promote_full_temp('del')
               RETURN
            END IF
   
            #更新所屬門店/法人和狀態頁簽和已傳POS否
            LET l_sql = "SELECT azw02 FROM ",cl_get_target_table(l_rtz01,'azw_file'),
                        " WHERE azw01 = '",l_rtz01,"' "
            PREPARE sel_azw02_pre14 FROM l_sql
            EXECUTE sel_azw02_pre14 INTO l_azw02
            UPDATE rah_temp SET rahplant = l_rtz01,rahlegal = l_azw02,
                                rahcond = g_today,rahconf = 'Y',rahconu = g_user,rahcrat = g_today,
                                rahdate = g_today,rahgrup = g_grup,rahmodu = g_user,rahorig = g_grup,
                                rahoriu = g_user,rahuser = g_user,rahpos = '1'
            UPDATE rak_temp SET rakcrdate = g_today,rakdate = g_today,rakgrup = g_grup,
                                raklegal = l_azw02,rakmodu = g_user,rakorig = g_grup,
                                rakoriu = g_user,rakplant = l_rtz01,rakuser = g_user,rakpos = '1'
            UPDATE rai_temp SET railegal = l_azw02,raiplant = l_rtz01
            UPDATE rar_temp SET rarlegal = l_azw02,rarplant = l_rtz01
            UPDATE ras_temp SET raslegal = l_azw02,rasplant = l_rtz01
            UPDATE rap_temp SET raplegal = l_azw02,rapplant = l_rtz01
            UPDATE raq_temp SET raq06 = g_today,raqlegal = l_azw02,raqplant = l_rtz01

            #將臨時表資料Insert到數據庫
            #变更单跨库到制定门店/基本资料跨库到当前门店
            LET l_sql = " INSERT INTO ",cl_get_target_table(l_rah01,'rbh_file'),
                        " SELECT * FROM rbh_temp"
            PREPARE trans_ins_rbh FROM l_sql
            EXECUTE trans_ins_rbh
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('ins','rbh_file','',SQLCA.SQLCODE,1)
               LET g_success = 'N' 
               CALL i200_set_promote_full_temp('del')
               RETURN
            END IF
            LET l_sql = " INSERT INTO ",cl_get_target_table(l_rah01,'rbq_file'),
                        " SELECT * FROM rbq_temp"
            PREPARE trans_ins_rbq_2 FROM l_sql
            EXECUTE trans_ins_rbq_2
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('ins','rbq_file','',SQLCA.SQLCODE,1)
               LET g_success = 'N' 
               CALL i200_set_promote_full_temp('del')
               RETURN
            END IF
            LET l_sql = " INSERT INTO ",cl_get_target_table(l_rtz01,'rah_file'),
                        " SELECT * FROM rah_temp"
            PREPARE trans_ins_rah FROM l_sql
            EXECUTE trans_ins_rah
            LET l_cnt = SQLCA.sqlerrd[3]+l_cnt
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('ins','rah_file','',SQLCA.SQLCODE,1)
               LET g_success = 'N'
               CALL i200_set_promote_full_temp('del')
               RETURN
            END IF
            LET l_sql = " INSERT INTO ",cl_get_target_table(l_rtz01,'rak_file'),
                        " SELECT * FROM rak_temp"
            PREPARE trans_ins_rak2 FROM l_sql
            EXECUTE trans_ins_rak2
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('ins','rak_file','',SQLCA.SQLCODE,1)
               LET g_success = 'N'
               CALL i200_set_promote_full_temp('del')
               RETURN
            END IF
            LET l_sql = " INSERT INTO ",cl_get_target_table(l_rtz01,'rai_file'),
                        " SELECT * FROM rai_temp"
            PREPARE trans_ins_rai FROM l_sql
            EXECUTE trans_ins_rai
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('ins','rai_file','',SQLCA.SQLCODE,1)
               LET g_success = 'N'
               CALL i200_set_promote_full_temp('del')
               RETURN
            END IF
            LET l_sql = " INSERT INTO ",cl_get_target_table(l_rtz01,'rar_file'),
                        " SELECT * FROM rar_temp"
            PREPARE trans_ins_rar_1 FROM l_sql
            EXECUTE trans_ins_rar_1
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('ins','rar_file','',SQLCA.SQLCODE,1)
               LET g_success = 'N'
               CALL i200_set_promote_full_temp('del')
               RETURN
            END IF
            LET l_sql = " INSERT INTO ",cl_get_target_table(l_rtz01,'ras_file'),
                        " SELECT * FROM ras_temp"
            PREPARE trans_ins_ras_1 FROM l_sql
            EXECUTE trans_ins_ras_1
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('ins','ras_file','',SQLCA.SQLCODE,1)
               LET g_success = 'N'
               CALL i200_set_promote_full_temp('del')
               RETURN
            END IF
            LET l_sql = " INSERT INTO ",cl_get_target_table(l_rtz01,'rap_file'),
                        " SELECT * FROM rap_temp"
            PREPARE trans_ins_rap_2 FROM l_sql
            EXECUTE trans_ins_rap_2
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('ins','rap_file','',SQLCA.SQLCODE,1)
               LET g_success = 'N'
               CALL i200_set_promote_full_temp('del')
               RETURN
            END IF
            LET l_sql = " INSERT INTO ",cl_get_target_table(l_rtz01,'raq_file'),
                        " SELECT * FROM raq_temp"
            PREPARE trans_ins_raq_2 FROM l_sql
            EXECUTE trans_ins_raq_2
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('ins','raq_file','',SQLCA.SQLCODE,1)
               LET g_success = 'N'
               CALL i200_set_promote_full_temp('del')
               RETURN
            END IF
         END IF
      END FOREACH
      LET g_msg1 = cl_getmsg("art1124",g_lang)         #滿額促銷資料
      LET g_msg2 = cl_getmsg("anm-973",g_lang),l_cnt   #成功笔数: 
      IF l_cnt > 0 THEN
         CALL s_errmsg(g_msg1,g_msg2,'INSERT INTO rah_file',SQLCA.sqlcode,2)
      ELSE
         CALL s_errmsg(g_msg1,g_msg2,'','art1113',2)   #參考門店無對應資料
      END IF
   ELSE
      LET l_cnt = 0
      LET g_msg1 = cl_getmsg("art1124",g_lang)
      LET g_msg2 = cl_getmsg("anm-973",g_lang),l_cnt
      CALL s_errmsg(g_msg1,g_msg2,'','art1101',1)      #已經存在此資料
   END IF

   IF g_success = 'Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF

   #刪除臨時表
   CALL i200_set_promote_full_temp('del')

END FUNCTION

#卡資料臨時表的創建、刪除
FUNCTION i200_set_card_temp(p_action)
DEFINE p_action LIKE type_file.chr10

   IF p_action = 'cre' THEN
      DROP TABLE lta_temp
      SELECT * FROM lta_file WHERE 1=0 INTO TEMP lta_temp
      DROP TABLE ltb_temp
      SELECT * FROM ltb_file WHERE 1=0 INTO TEMP ltb_temp
      DROP TABLE ltc_temp
      SELECT * FROM ltc_file WHERE 1=0 INTO TEMP ltc_temp
      DROP TABLE lnk_temp
      SELECT * FROM lnk_file WHERE 1=0 INTO TEMP lnk_temp
      DROP TABLE lti_temp
      SELECT * FROM lti_file WHERE 1=0 INTO TEMP lti_temp
      DROP TABLE ltj_temp
      SELECT * FROM ltj_file WHERE 1=0 INTO TEMP ltj_temp
      DROP TABLE ltk_temp
      SELECT * FROM ltk_file WHERE 1=0 INTO TEMP ltk_temp
      DROP TABLE ltl_temp
      SELECT * FROM ltl_file WHERE 1=0 INTO TEMP ltl_temp
      DROP TABLE ltn_temp
      SELECT * FROM ltn_file WHERE 1=0 INTO TEMP ltn_temp
      DROP TABLE lrp_temp
      SELECT * FROM lrp_file WHERE 1=0 INTO TEMP lrp_temp
      DROP TABLE lrq_temp
      SELECT * FROM lrq_file WHERE 1=0 INTO TEMP lrq_temp
      DROP TABLE lth_temp
      SELECT * FROM lth_file WHERE 1=0 INTO TEMP lth_temp
      DROP TABLE lrr_temp
      SELECT * FROM lrr_file WHERE 1=0 INTO TEMP lrr_temp
      DROP TABLE lso_temp
      SELECT * FROM lso_file WHERE 1=0 INTO TEMP lso_temp
   ELSE
      DROP TABLE lta_temp
      DROP TABLE ltb_temp
      DROP TABLE ltc_temp
      DROP TABLE lnk_temp
      DROP TABLE lti_temp
      DROP TABLE ltj_temp
      DROP TABLE ltk_temp
      DROP TABLE ltl_temp
      DROP TABLE ltn_temp
      DROP TABLE lrp_temp
      DROP TABLE lrq_temp
      DROP TABLE lth_temp
      DROP TABLE lrr_temp
      DROP TABLE lso_temp
   END IF
END FUNCTION

#券資料臨時表的創建、刪除
FUNCTION i200_set_coupon_temp(p_action)
DEFINE p_action LIKE type_file.chr10

   IF p_action = 'cre' THEN
      DROP TABLE lta_temp
      SELECT * FROM lta_file WHERE 1=0 INTO TEMP lta_temp
      DROP TABLE ltb_temp
      SELECT * FROM ltb_file WHERE 1=0 INTO TEMP ltb_temp
      DROP TABLE ltc_temp
      SELECT * FROM ltc_file WHERE 1=0 INTO TEMP ltc_temp
      DROP TABLE lnk_temp
      SELECT * FROM lnk_file WHERE 1=0 INTO TEMP lnk_temp
      DROP TABLE lts_temp
      SELECT * FROM lts_file WHERE 1=0 INTO TEMP lts_temp
      DROP TABLE ltt_temp
      SELECT * FROM ltt_file WHERE 1=0 INTO TEMP ltt_temp
      DROP TABLE ltu_temp
      SELECT * FROM ltu_file WHERE 1=0 INTO TEMP ltu_temp
      DROP TABLE ltn_temp
      SELECT * FROM ltn_file WHERE 1=0 INTO TEMP ltn_temp
      DROP TABLE ltp_temp
      SELECT * FROM ltp_file WHERE 1=0 INTO TEMP ltp_temp
      DROP TABLE ltq_temp
      SELECT * FROM ltq_file WHERE 1=0 INTO TEMP ltq_temp
      DROP TABLE ltr_temp
      SELECT * FROM ltr_file WHERE 1=0 INTO TEMP ltr_temp
      DROP TABLE lso_temp
      SELECT * FROM lso_file WHERE 1=0 INTO TEMP lso_temp
   ELSE
      DROP TABLE lta_temp
      DROP TABLE ltb_temp
      DROP TABLE ltc_temp
      DROP TABLE lnk_temp
      DROP TABLE lts_temp
      DROP TABLE ltt_temp
      DROP TABLE ltu_temp
      DROP TABLE ltn_temp
      DROP TABLE ltp_temp
      DROP TABLE ltq_temp
      DROP TABLE ltr_temp
      DROP TABLE lso_temp
   END IF
END FUNCTION

#一般促銷的臨時表的創建、刪除
FUNCTION i200_set_promote_temp(p_action)
DEFINE p_action LIKE type_file.chr10

   IF p_action = 'cre' THEN
      DROP TABLE rbb_temp
      SELECT * FROM rbb_file WHERE 1=0 INTO TEMP rbb_temp
      DROP TABLE rbq_temp
      SELECT * FROM rbq_file WHERE 1=0 INTO TEMP rbq_temp
      DROP TABLE rab_temp
      SELECT * FROM rab_file WHERE 1=0 INTO TEMP rab_temp
      DROP TABLE rac_temp
      SELECT * FROM rac_file WHERE 1=0 INTO TEMP rac_temp
      DROP TABLE rak_temp
      SELECT * FROM rak_file WHERE 1=0 INTO TEMP rak_temp
      DROP TABLE rad_temp
      SELECT * FROM rad_file WHERE 1=0 INTO TEMP rad_temp
      DROP TABLE rap_temp
      SELECT * FROM rap_file WHERE 1=0 INTO TEMP rap_temp
      DROP TABLE raq_temp
      SELECT * FROM raq_file WHERE 1=0 INTO TEMP raq_temp
   ELSE
      DROP TABLE rbb_temp
      DROP TABLE rbq_temp
      DROP TABLE rab_temp
      DROP TABLE rac_temp
      DROP TABLE rak_temp
      DROP TABLE rad_temp
      DROP TABLE rap_temp
      DROP TABLE raq_temp
   END IF

END FUNCTION

#組合促銷的臨時表的創建、刪除
FUNCTION i200_set_promote_comb_temp(p_action)
DEFINE p_action LIKE type_file.chr10

   IF p_action = 'cre' THEN
      DROP TABLE rbe_temp
      SELECT * FROM rbe_file WHERE 1=0 INTO TEMP rbe_temp
      DROP TABLE rbq_temp
      SELECT * FROM rbq_file WHERE 1=0 INTO TEMP rbq_temp
      DROP TABLE rae_temp
      SELECT * FROM rae_file WHERE 1=0 INTO TEMP rae_temp
      DROP TABLE rak_temp
      SELECT * FROM rak_file WHERE 1=0 INTO TEMP rak_temp
      DROP TABLE raf_temp
      SELECT * FROM raf_file WHERE 1=0 INTO TEMP raf_temp
      DROP TABLE rag_temp
      SELECT * FROM rag_file WHERE 1=0 INTO TEMP rag_temp
      DROP TABLE rar_temp
      SELECT * FROM rar_file WHERE 1=0 INTO TEMP rar_temp
      DROP TABLE ras_temp
      SELECT * FROM ras_file WHERE 1=0 INTO TEMP ras_temp
      DROP TABLE rap_temp
      SELECT * FROM rap_file WHERE 1=0 INTO TEMP rap_temp
      DROP TABLE raq_temp
      SELECT * FROM raq_file WHERE 1=0 INTO TEMP raq_temp
   ELSE
      DROP TABLE rbe_temp
      DROP TABLE rbq_temp
      DROP TABLE rae_temp
      DROP TABLE rak_temp
      DROP TABLE raf_temp
      DROP TABLE rag_temp
      DROP TABLE rar_temp
      DROP TABLE ras_temp
      DROP TABLE rap_temp
      DROP TABLE raq_temp
   END IF

END FUNCTION

#滿額促銷的臨時表的創建、刪除
FUNCTION i200_set_promote_full_temp(p_action)
DEFINE p_action LIKE type_file.chr10

   IF p_action = 'cre' THEN
      DROP TABLE rbh_temp
      SELECT * FROM rbh_file WHERE 1=0 INTO TEMP rbh_temp
      DROP TABLE rbq_temp
      SELECT * FROM rbq_file WHERE 1=0 INTO TEMP rbq_temp
      DROP TABLE rah_temp
      SELECT * FROM rah_file WHERE 1=0 INTO TEMP rah_temp
      DROP TABLE rak_temp
      SELECT * FROM rak_file WHERE 1=0 INTO TEMP rak_temp
      DROP TABLE rai_temp
      SELECT * FROM rai_file WHERE 1=0 INTO TEMP rai_temp
      DROP TABLE rar_temp
      SELECT * FROM rar_file WHERE 1=0 INTO TEMP rar_temp
      DROP TABLE ras_temp
      SELECT * FROM ras_file WHERE 1=0 INTO TEMP ras_temp
      DROP TABLE rap_temp
      SELECT * FROM rap_file WHERE 1=0 INTO TEMP rap_temp
      DROP TABLE raq_temp
      SELECT * FROM raq_file WHERE 1=0 INTO TEMP raq_temp
   ELSE
      DROP TABLE rbh_temp
      DROP TABLE rbq_temp
      DROP TABLE rah_temp
      DROP TABLE rak_temp
      DROP TABLE rai_temp
      DROP TABLE rar_temp
      DROP TABLE ras_temp
      DROP TABLE rap_temp
      DROP TABLE raq_temp
   END IF

END FUNCTION

#FUN-D10117--add--end---
   
#更新rtz_file
FUNCTION i200_set_upd(l_rtz01)
DEFINE l_rtz31   LIKE rtz_file.rtz31
DEFINE l_rtz32   LIKE rtz_file.rtz32
DEFINE l_rtz33   LIKE rtz_file.rtz33
DEFINE l_rtz01   LIKE rtz_file.rtz01

   BEGIN WORK
   LET g_success = 'Y'

   IF cl_null(g_rtz.rtz02) THEN
      SELECT rtz02 INTO g_rtz.rtz02 FROM rtz_file WHERE rtz01 = g_rtz01
   END IF
   IF cl_null(g_rtz.rtz03) THEN
      SELECT rtz03 INTO g_rtz.rtz03 FROM rtz_file WHERE rtz01 = g_rtz01
   END IF
   IF cl_null(g_rtz.rtz12) THEN
      SELECT rtz12 INTO g_rtz.rtz12 FROM rtz_file WHERE rtz01 = g_rtz01
   END IF
   IF cl_null(g_rtz.rtz04) THEN
      SELECT rtz04 INTO g_rtz.rtz04 FROM rtz_file WHERE rtz01 = g_rtz01
   END IF
   IF cl_null(g_rtz.rtz05) THEN
      SELECT rtz05 INTO g_rtz.rtz05 FROM rtz_file WHERE rtz01 = g_rtz01
   END IF
   IF cl_null(g_rtz.rtz06) THEN
      SELECT rtz06 INTO g_rtz.rtz06 FROM rtz_file WHERE rtz01 = g_rtz01
   END IF
   IF cl_null(g_rtz.rtz09) THEN
      SELECT rtz09 INTO g_rtz.rtz09 FROM rtz_file WHERE rtz01 = g_rtz01
   END IF
   SELECT rtz31,rtz32,rtz33 INTO l_rtz31,l_rtz32,l_rtz33 FROM rtz_file WHERE rtz01 = g_rtz01
   IF g_rtz.rtz31 = 100 AND l_rtz31 != 100 THEN
      LET g_rtz.rtz31 = l_rtz31
   END IF
   IF g_rtz.rtz32 = 100 AND l_rtz32 != 100 THEN
      LET g_rtz.rtz32 = l_rtz32
   END IF
   IF g_rtz.rtz33 = 100 AND l_rtz33 != 100 THEN
      LET g_rtz.rtz33 = l_rtz33
   END IF

   UPDATE rtz_file SET rtz02 = g_rtz.rtz02,rtz03 = g_rtz.rtz03,rtz12 = g_rtz.rtz12,
                       rtz04 = g_rtz.rtz04,rtz05 = g_rtz.rtz05,rtz06 = g_rtz.rtz06,
                       rtz09 = g_rtz.rtz09,rtz31 = g_rtz.rtz31,rtz32 = g_rtz.rtz32,
                       rtz33 = g_rtz.rtz33
    WHERE rtz01 = l_rtz01
   IF STATUS OR SQLCA.SQLCODE THEN
      CALL s_errmsg('upd','rtz_file','',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   IF g_success = 'Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF

END FUNCTION

#全是
FUNCTION i200_y()

   LET g_set.gys     = 'Y'
   LET g_set.khzl    = 'Y'
   LET g_set.khdj    = 'Y'
   LET g_set.jyjg    = 'Y'
   LET g_set.cgcl    = 'Y'
   LET g_set.ckzl    = 'Y'
   LET g_set.poscs   = 'Y'
   LET g_set.posjh   = 'Y'
   LET g_set.posmdcs = 'Y'
   LET g_set.posmdjh = 'Y'
   LET g_set.card    = 'Y'     #FUN-D10117 add
   LET g_set.coupon  = 'Y'     #FUN-D10117 add
   LET g_set.promote = 'Y'     #FUN-D10117 add
   DISPLAY g_set.* TO gys,khzl,khdj,jyjg,cgcl,ckzl,poscs,posjh,posmdcs,posmdjh,card,coupon,promote     #FUN-D10117 add card,coupon,promote 
END FUNCTION

#全否
FUNCTION i200_n()
   LET g_set.gys     = 'N'
   LET g_set.khzl    = 'N'
   LET g_set.khdj    = 'N'
   LET g_set.jyjg    = 'N'
   LET g_set.cgcl    = 'N'
   LET g_set.ckzl    = 'N'
   LET g_set.poscs   = 'N'
   LET g_set.posjh   = 'N'
   LET g_set.posmdcs = 'N'
   LET g_set.posmdjh = 'N'
   LET g_set.card    = 'N'     #FUN-D10117 add
   LET g_set.coupon  = 'N'     #FUN-D10117 add
   LET g_set.promote = 'N'     #FUN-D10117 add
   DISPLAY g_set.* TO gys,khzl,khdj,jyjg,cgcl,ckzl,poscs,posjh,posmdcs,posmdjh,card,coupon,promote     #FUN-D10117 add card,coupon,promote
END FUNCTION
#FUN-D10021--add--end---

#FUN-A80148--add-end
#FUN-AA0054
