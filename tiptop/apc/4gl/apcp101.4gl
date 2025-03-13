# Prog. Version..: '5.30.06-13.03.29(00010)'     #
#
# Pattern name...: apcp101.4gl
# Descriptions...: 門店初始化數據維護作業
# Date & Author..: 11/07/05 By liupeng #FUN-B70025
# Modify.........: No.FUN-B90049 11/09/08 By huangtao 取消條碼下傳項目。下傳產品資料的時候一併下傳條碼
# Modify.........: No.FUN-BB0129 12/01/12 By pauline 門店基本資料/商品基本資料重複下傳到中間庫
# Modify.........: No.FUN-BC0015 12/01/30 By pauline p100()增加參數
# Modify.........: No.FUN-C50017 12/05/08 By yangxf 更改画面及相关逻辑代码
# Modify.........: No.FUN-CA0074 12/10/15 By xumm 增加门店参数资料栏位
# Modify.........: No.FUN-CB0007 12/11/06 By xumm 增加会员等级和会员类型的下传
# Modify.........: No:FUN-CB0007 12/11/14 By shiwuying 增加进程判断
# Modify.........: No.FUN-CC0116 13/01/14 By xumm 增加专柜抽成资料的下传
# Modify.........: No.FUN-D20020 13/02/20 By dongsz 增加觸屏資料的下傳
# Modify.........: No.FUN-D30093 13/03/26 By dongsz 運行成功后，提示是否繼續點否后應直接退出程序

DATABASE ds
#FUN-B70025
GLOBALS "../../config/top.global"

DEFINE g_pdb       LIKE ryg_file.ryg00
DEFINE g_pplant    STRING
DEFINE g_argv1     STRING
DEFINE g_choice1   LIKE type_file.chr1
DEFINE g_choice2   LIKE type_file.chr1
DEFINE g_flag1     LIKE type_file.chr1
DEFINE g_flag3     LIKE type_file.chr1
DEFINE g_flag4     LIKE type_file.chr1
DEFINE g_flag5     LIKE type_file.chr1
DEFINE g_flag6     LIKE type_file.chr1 #
DEFINE g_flag7     LIKE type_file.chr1 #未使用
DEFINE g_flag8     LIKE type_file.chr1
DEFINE g_flag9     LIKE type_file.chr1
DEFINE g_flag10    LIKE type_file.chr1
DEFINE g_flag11    LIKE type_file.chr1
DEFINE g_flag12    LIKE type_file.chr1

DEFINE g_pdb_t      LIKE ryg_file.ryg00 
DEFINE g_pplant_t   STRING
DEFINE g_choice1_t  LIKE type_file.chr1
DEFINE g_choice2_t  LIKE type_file.chr1
DEFINE g_flag1_t    LIKE type_file.chr1
DEFINE g_flag3_t    LIKE type_file.chr1
DEFINE g_flag4_t    LIKE type_file.chr1
DEFINE g_flag5_t    LIKE type_file.chr1 #
DEFINE g_flag6_t    LIKE type_file.chr1 #
DEFINE g_flag7_t    LIKE type_file.chr1 #
DEFINE g_flag8_t    LIKE type_file.chr1
DEFINE g_flag9_t    LIKE type_file.chr1
DEFINE g_flag10_t   LIKE type_file.chr1
DEFINE g_flag11_t   LIKE type_file.chr1
DEFINE g_flag12_t   LIKE type_file.chr1
#FUN-C50017 add begin ---
DEFINE  g_ryk   DYNAMIC ARRAY OF RECORD
                ryk01       LIKE ryk_file.ryk01,
                ryk05       LIKE ryk_file.ryk05
                END RECORD
DEFINE  g_ryk_t DYNAMIC ARRAY OF RECORD
                ryk01       LIKE ryk_file.ryk01,
                ryk05       LIKE ryk_file.ryk05
                END RECORD
DEFINE  g_ryk_o DYNAMIC ARRAY OF RECORD
                ryk01       LIKE ryk_file.ryk01,
                ryk05       LIKE ryk_file.ryk05
                END RECORD
DEFINE  g_choice3   LIKE type_file.chr1
DEFINE  g_choice4   LIKE type_file.chr1
DEFINE  g_choice3_t LIKE type_file.chr1
DEFINE  g_choice4_t LIKE type_file.chr1
DEFINE  g_sql       STRING
#FUN-C50017 add end -----

DEFINE l_flag       LIKE type_file.chr1 
DEFINE  p_row,p_col     LIKE type_file.num5  
DEFINE  g_apname    LIKE type_file.chr10    #FUN-CB0007
DEFINE  g_msg       STRING                  #FUN-CB0007
MAIN       
    OPTIONS
    INPUT NO WRAP                          #輸入的方式: 不打轉
    DEFER INTERRUPT                            #擷取中斷鍵

    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF

    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("APC")) THEN
       EXIT PROGRAM
    END IF
    IF g_aza.aza88<>'Y' THEN
       CALL cl_err('','apc-120',1)
       EXIT PROGRAM
    END IF
   #FUN-CB0007 Begin---
    LET g_apname = cl_used_ap_hostname()
    IF NOT s_chk_process_pos(g_apname,'apcp101','N') THEN
       IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
          IF cl_confirm('apc-207') THEN
            #LET g_msg =  "apcq070 'apcp101'"
             LET g_msg =  "apcq070 "
             CALL cl_cmdrun(g_msg)
          END IF
       END IF
       EXIT PROGRAM
    END IF
   #FUN-CB0007 End-----
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time
    LET p_row = 5 LET p_col = 10
    OPEN WINDOW p101_w AT p_row,p_col WITH FORM "apc/42f/apcp101"
    ATTRIBUTE (STYLE = g_win_style CLIPPED)
    CALL cl_ui_init()
    CALL cl_set_comp_entry("pdb",FALSE)
    CALL cl_set_comp_visible("pflag6",FALSE)  #POS只做销售 隐藏 6银行资料
    CALL cl_set_comp_visible("pflag7",FALSE)  #POS只做销售 隐藏 7仓库资料
    CALL cl_set_comp_visible("pflag5",FALSE)  #券作废资料
    LET g_action_choice = ""
    CALL p101_default()               
    CALL p101_menu()
    CLOSE WINDOW p101_w
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION p101_menu()
   DEFINE l_cmd  LIKE type_file.chr1000        
    MENU ""

        ON ACTION modify
           LET g_action_choice="modify"
           IF cl_chk_act_auth() THEN
                CALL p101_u()
           END IF
        ON ACTION plant_default
           LET g_action_choice="plant_default"
           IF cl_chk_act_auth() THEN
               CALL p101_prepare()
           END IF
        ON ACTION select_all
           LET g_action_choice="select_all"
           IF cl_chk_act_auth() THEN 
              CALL p101_yn('Y')
           END IF 
        ON ACTION cancel_all
           LET g_action_choice="cancel_all"
           IF cl_chk_act_auth() THEN 
              CALL p101_yn('N')
           END IF 
        ON ACTION help
           CALL cl_show_help()
        ON ACTION exit
           LET g_action_choice = "exit"
           EXIT MENU
        ON ACTION controlg
           CALL cl_cmdask()
        ON ACTION locale
           CALL cl_dynamic_locale()
           CALL cl_show_fld_cont()             
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE MENU
        ON ACTION about         
           CALL cl_about() 
        COMMAND KEY(INTERRUPT)
             LET INT_FLAG=FALSE 		
           LET g_action_choice = "exit"
           EXIT MENU

    END MENU
END FUNCTION

FUNCTION p101_i(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1,     
            l_gen02   LIKE gen_file.gen02,
            l_gen03   LIKE gen_file.gen03,
            l_gen04   LIKE gen_file.gen04,
            l_gem02   LIKE gem_file.gem02,
            l_input   LIKE type_file.chr1,    
            l_n       LIKE type_file.num5    
   DEFINE   gst_pplant base.stringtokenizer,
            gs_pplant  LIKE azw_file.azw01
 
         INPUT   g_pdb,g_pplant,g_choice1,
#FUN-C50017 add begin ---
                 g_ryk[101].ryk05,g_ryk[102].ryk05,g_ryk[103].ryk05,g_ryk[104].ryk05, 
                 #g_ryk[105].ryk05,g_ryk[106].ryk05,g_ryk[107].ryk05,g_ryk[108].ryk05,g_ryk[109].ryk05,g_ryk[110].ryk05,  #FUN-CA0074 add g_ryk[110].ryk05  #FUN-CC0116 mark
                 g_ryk[105].ryk05,g_ryk[106].ryk05,g_ryk[107].ryk05,g_ryk[108].ryk05,                #FUN-CC0116 add
                 g_ryk[109].ryk05,g_ryk[110].ryk05,g_ryk[111].ryk05,                                  #FUN-CC0116 add                
                 g_choice2,                                                            
                 g_ryk[201].ryk05,g_ryk[202].ryk05,g_ryk[203].ryk05,g_ryk[204].ryk05,g_ryk[205].ryk05,g_ryk[206].ryk05,
                 g_ryk[207].ryk05,                                                                    #FUN-D20020 add
                 g_choice3,      
                 g_ryk[301].ryk05,g_ryk[302].ryk05,g_ryk[303].ryk05,
                 g_choice4,       
                 g_ryk[401].ryk05,g_ryk[402].ryk05,g_ryk[403].ryk05,g_ryk[404].ryk05 
                 ,g_ryk[405].ryk05,g_ryk[406].ryk05                    #FUN-CB0007 add
#FUN-C50017 add end ---
#                g_flag1,g_flag4,g_flag5,g_flag3,g_flag6,              #FUN-C50017 mark 
#                g_choice2,g_flag10,g_flag12,g_flag8,g_flag9,g_flag11  #FUN-C50017 mark
                 WITHOUT DEFAULTS
         FROM pdb,pplant,pchoice1,
#             pflag1,pflag4,pflag5,pflag3,pflag6,                   #FUN-C50017 mark
#             pchoice2,pflag10,pflag12,pflag8,pflag9,pflag11        #FUN-C50017 mark
#FUN-C50017 add begin ---
              ryk05101,ryk05102,ryk05103,ryk05104,ryk05105,ryk05106,
              ryk05107,ryk05108,ryk05109,ryk05110,ryk05111,         #FUN-CA0074 add ryk05110  #FUN-CC0116 add ryk05111                                           
              pchoice2,
              ryk05201,ryk05202,ryk05203,ryk05204,ryk05205,ryk05206,ryk05207,                 #FUN-D20020 add ryk05207
              pchoice3,
              ryk05301,ryk05302,ryk05303,
              pchoice4,
              ryk05401,ryk05402,ryk05403,ryk05404
              ,ryk05405,ryk05406                                    #FUN-CB0007 add
       BEFORE INPUT
          CALL p101_set_entry(p_cmd)
#FUN-C50017 add end ---

         AFTER INPUT 
#FUN-C50017 add begin ---
             #CALL p101_chk_choice('0','1',101,109)    #FUN-CA0074 mark
             #CALL p101_chk_choice('0','1',101,110)    #FUN-CA0074 add  #FUN-CC0116 mark
             CALL p101_chk_choice('0','1',101,111)     #FUN-CC0116  add
            #CALL p101_chk_choice('0','2',201,206)     #FUN-D20020 mark
             CALL p101_chk_choice('0','2',201,207)     #FUN-D20020 add
             CALL p101_chk_choice('0','3',301,303)
             #CALL p101_chk_choice('0','4',401,404)    #FUN-CB0007 mark
             CALL p101_chk_choice('0','4',401,406)     #FUN-CB0007 add
#FUN-C50017 add end  -----
#               CALL p101_chk_pchoice1('0')         #FUN-C50017  MARK
#               CALL p101_chk_pchoice2('0')         #FUN-C50017  MARK
         AFTER FIELD pdb
               IF NOT cl_null(g_pdb) THEN
                 IF g_pdb <> g_pdb_t OR g_pdb_t IS NULL THEN
                    SELECT COUNT(*) INTO l_n FROM ryg_file
                    WHERE ryg00=g_pdb
                    IF l_n=0 OR l_n IS NULL THEN
                       CALL cl_err(g_pdb,'apc-118',0)      #当前录入的营运中心DB不存在，请重新输入
                       LET g_pdb=g_pdb_t
                       DISPLAY g_pdb TO pdb
                       NEXT FIELD pdb
                    END IF
                 END IF
                END IF   
        BEFORE FIELD pplant 
               MESSAGE ""
        AFTER FIELD pplant
              IF NOT cl_null(g_pplant) THEN
                 IF g_pplant != g_pplant_t OR g_pplant_t IS NULL THEN
                    LET gst_pplant = base.stringtokenizer.create(g_pplant,"|")
                    WHILE gst_pplant.hasmoretokens()
                          LET gs_pplant = gst_pplant.nexttoken()
                          SELECT COUNT(*) INTO l_n FROM ryg_file
                          WHERE ryg01=gs_pplant AND rygacti='Y'
                          IF l_n=0 OR l_n IS NULL THEN
                             CALL cl_err(gs_pplant,'apc-119',0)  #该营运中心没有设置传输
                             DISPLAY g_pplant TO pplant
                             NEXT FIELD pplant
                          END IF
                    END WHILE           
                 END IF
               END IF
   
       ON CHANGE pchoice1
#         CALL p101_chk_pchoice1('1')              #FUN-C50017 mark
#         CALL p101_chk_choice('1','1',101,109)    #FUN-C50017 add    #FUN-CA0074 mark
#         CALL p101_chk_choice('1','1',101,110)    #FUN-CA0074 add    #FUN-CC0116 mark
          CALL p101_chk_choice('1','1',101,111)    #FUN-CC0116 add
          CALL p101_show()   
            
       ON CHANGE pchoice2
#         CALL p101_chk_pchoice2('1')              #FUN-C50017 mark
         #CALL p101_chk_choice('1','2',201,206)    #FUN-C50017 add    #FUN-D20020 mark
          CALL p101_chk_choice('1','2',201,207)    #FUN-D20020 add
          CALL p101_show() 

#FUN-C50017 add begin ---
       ON CHANGE pchoice3
          CALL p101_chk_choice('1','3',301,303)
          CALL p101_show()

       ON CHANGE pchoice4
#         CALL p101_chk_choice('1','4',401,404)    #FUN-CB0007 mark
          CALL p101_chk_choice('1','4',401,406)    #FUN-CB0007 add
          CALL p101_show()
#FUN-C50017 add end -----

       ON ACTION CONTROLR
          CALL cl_show_req_fields()
   
       ON ACTION controlp                                                       
          CASE                                                                  
             WHEN INFIELD(pplant)                                                 
                CALL cl_init_qry_var()                                          
                LET g_qryparam.state = "c"
                LET g_qryparam.form = "q_ryg01"                                   
                CALL cl_create_qry() RETURNING g_pplant  #qryparam.multiret
                DISPLAY g_pplant TO pplant
                NEXT FIELD pplant
             OTHERWISE EXIT CASE                                                
          END CASE
   
       ON ACTION CONTROLG
          CALL cl_cmdask()
   
       ON ACTION CONTROLF                        # 欄位說明
          CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
          CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
   
   
#FUN-C50017 add begin ---
      ON ACTION select_all
          CALL p101_yn('Y')
                 
       ON ACTION cancel_all
          CALL p101_yn('N')
               
#FUN-C50017 add end -----

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
   
       ON ACTION about         
          CALL cl_about()
   
       ON ACTION help          
          CALL cl_show_help() 

   END INPUT
END FUNCTION
FUNCTION p101_chk_pchoice1(p_type)    #组/内容信息切换回写
DEFINE p_type  LIKE  type_file.chr1   #0 代表根据内容赋值组变量、1代表根据组变量赋值内容变量
DEFINE l_y     LIKE  type_file.chr1
       IF p_type = '0' THEN
            IF g_flag1 = 'Y'  AND g_flag3 = 'Y' AND g_flag4 = 'Y' THEN 
	       LET g_choice1 ='Y' 
	    ELSE 
	       LET g_choice1 ='N' 
	    END IF 
       ELSE 
            IF g_choice1 = 'Y' THEN  LET l_y = 'Y' ELSE LET l_y = 'N' END IF 
            LET g_flag1 = l_y
            LET g_flag3 = l_y
            LET g_flag4 = l_y
       END IF  
END FUNCTION
FUNCTION p101_chk_pchoice2(p_type)    #组/内容信息切换回写
DEFINE p_type  LIKE  type_file.chr1   #0 代表根据内容赋值组变量、1代表根据组变量赋值内容变量
DEFINE l_y     LIKE  type_file.chr1
       IF p_type = '0' THEN
            IF  g_flag8 = 'Y'  AND  g_flag9  = 'Y' AND  g_flag10 = 'Y' AND  
	        g_flag11 = 'Y' AND  g_flag12 = 'Y'  THEN 
		LET g_choice2 ='Y'  
            ELSE 
	        LET g_choice2 ='N'
            END IF
       ELSE 
            IF g_choice2 = 'Y' THEN LET l_y='Y' ELSE  LET l_y = 'N' END IF
            LET g_flag8 = l_y
            LET g_flag9 = l_y
            LET g_flag10= l_y
            LET g_flag11= l_y
            LET g_flag12= l_y     
       END IF  
END FUNCTION 
FUNCTION p101_default()
#FUN-C50017 add begin ---
DEFINE  l_ryk       RECORD
                      ryk01       LIKE ryk_file.ryk01,
                      ryk05       LIKE type_file.chr1
                    END RECORD

      LET g_sql = "SELECT ryk01,ryk05 FROM ryk_file ORDER BY ryk01"
      PREPARE p100_ryk05 FROM g_sql
      DECLARE ryk_cs CURSOR FOR p100_ryk05
      CALL g_ryk.clear()
      FOREACH ryk_cs INTO l_ryk.*
         IF STATUS THEN CALL cl_err('foreach:',STATUS,1)
            EXIT FOREACH
         END IF
         LET g_ryk[l_ryk.ryk01].* = l_ryk.*
         LET g_ryk_o[l_ryk.ryk01].* = g_ryk[l_ryk.ryk01].*
      END FOREACH
      #CALL p101_chk_choice('0','1',101,109)    #FUN-CA0074 mark
      #CALL p101_chk_choice('0','1',101,110)    #FUN-CA0074 add  #FUN-CC0116 mark
      CALL p101_chk_choice('0','1',101,111)     #FUN-CC0116 add
     #CALL p101_chk_choice('0','2',201,206)     #FUN-D20020 mark
      CALL p101_chk_choice('0','2',201,207)     #FUN-D20020 add
      CALL p101_chk_choice('0','3',301,303)
      #CALL p101_chk_choice('0','4',401,404)    #FUN-CB0007 mark
      CALL p101_chk_choice('0','4',401,406)     #FUN-CB0007 add
#FUN-C50017 add end -----
       SELECT DISTINCT ryg00 INTO g_pdb FROM ryg_file  #后面多DB 需要调整
       LET g_pplant = ''  
#FUN-C50017 mark begin ---
#       LET g_choice1= 'Y'
#       LET g_flag1  = 'Y' 
#       LET g_flag3  = 'Y'
#       LET g_flag4  = 'Y'
#       LET g_choice2= 'Y'
#       LET g_flag8  = 'Y'
#       LET g_flag9  = 'Y'
#       LET g_flag10 = 'Y'
#       LET g_flag11 = 'Y'
#       LET g_flag12 = 'Y'
#FUN-C50017 mark end ----
       CALL p101_show() 
       CALL p101_u()
END FUNCTION 
FUNCTION p101_show() 
#FUN-C50017 mark begin ---
#   DISPLAY g_pdb,g_pplant,g_choice1,g_choice2,
#           g_flag1,g_flag3,g_flag4,
#           g_flag8,g_flag9,g_flag10,g_flag11,g_flag12
#        TO pdb,pplant,pchoice1,pchoice2,
#           pflag1,pflag3,pflag4,
#           pflag8,pflag9,pflag10,pflag11,pflag12
#FUN-C50017 mark end ---
#FUN-C50017 add begin ---
    DISPLAY g_pdb,g_pplant,g_choice1,g_choice2,g_choice3,g_choice4,
            g_ryk[101].ryk05,g_ryk[102].ryk05,g_ryk[103].ryk05,g_ryk[104].ryk05,
            g_ryk[105].ryk05,g_ryk[106].ryk05,g_ryk[107].ryk05,g_ryk[108].ryk05,g_ryk[109].ryk05,g_ryk[110].ryk05,    #FUN-CA0074 add g_ryk[110].ryk05
            g_ryk[111].ryk05,                                                                                         #FUN-CC0116 add
            g_ryk[201].ryk05,g_ryk[202].ryk05,g_ryk[203].ryk05,g_ryk[204].ryk05,g_ryk[205].ryk05,g_ryk[206].ryk05,
            g_ryk[207].ryk05,                                                                                         #FUN-D20020 add
            g_ryk[301].ryk05,g_ryk[302].ryk05,g_ryk[303].ryk05,
            g_ryk[401].ryk05,g_ryk[402].ryk05,g_ryk[403].ryk05,g_ryk[404].ryk05
            ,g_ryk[405].ryk05,g_ryk[406].ryk05                                                                        #FUN-CB0007 add
         TO pdb,pplant,pchoice1,pchoice2,pchoice3,pchoice4,
            ryk05101,ryk05102,ryk05103,ryk05104,ryk05105,ryk05106,ryk05107,ryk05108,ryk05109,ryk05110,ryk05111,       #FUN-CA0074 add ryk05110  #FUN-CC0116 add ryk05111
            ryk05201,ryk05202,ryk05203,ryk05204,ryk05205,ryk05206,ryk05207,                                           #FUN-D20020 add                             
            ryk05301,ryk05302,ryk05303,
            ryk05401,ryk05402,ryk05403,ryk05404
            ,ryk05405,ryk05406                                                                                        #FUN-CB0007 add
#FUN-C50017 add end ---

    CALL cl_show_fld_cont() 

END FUNCTION

FUNCTION p101_u()
DEFINE l_max,l_n INTEGER      #FUN-C50017 add
    CALL cl_opmsg('u')
    LET g_pplant_t  = g_pplant
    LET g_choice1_t = g_choice1
    LET g_choice2_t = g_choice2
    LET g_choice3_t = g_choice3    #FUN-C50017 add
    LET g_choice4_t = g_choice4    #FUN-C50017 add
#FUN-C50017 mark begin --
#    LET g_flag1_t   = g_flag1
#    LET g_flag3_t   = g_flag3
#    LET g_flag4_t   = g_flag4
#    LET g_flag8_t   = g_flag8
#    LET g_flag9_t   = g_flag9
#    LET g_flag10_t  = g_flag10
#    LET g_flag11_t  = g_flag11
#    LET g_flag12_t  = g_flag12
#FUN-C50017 mark end ----
#FUN-C50017  add begin --
   CALL g_ryk_t.clear()
   LET l_max = g_ryk.getLength()
   FOR l_n = 1 TO l_max
      LET g_ryk_t[l_n].* = g_ryk[l_n].*
   END FOR
#FUN-C50017 add end ---
    WHILE TRUE
        CALL p101_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_pplant  = g_pplant_t
#FUN-C50017  add begin ---
            FOR l_n = 1 TO l_max
              LET g_ryk[l_n].* = g_ryk_t[l_n].*
            END FOR            
            LET g_choice3 = g_choice3_t
            LET g_choice4 = g_choice4_t
#FUN-C50017 add end ----
            LET g_choice1 = g_choice1_t
            LET g_choice2 = g_choice2_t
#FUN-C50017 mark begin ---
#            LET g_flag1   = g_flag1_t
#            LET g_flag3   = g_flag3_t
#            LET g_flag4   = g_flag4_t
#            LET g_flag8   = g_flag8_t
#            LET g_flag9   = g_flag9_t
#            LET g_flag10  = g_flag10_t
#            LET g_flag11  = g_flag11_t
#            LET g_flag12  = g_flag12_t
#FUN-C50017 mark end ----
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        EXIT WHILE
    END WHILE
    CALL p101_show()                          # 顯示最新資料
END FUNCTION
FUNCTION p101_yn(p_y)
DEFINE p_y  LIKE type_file.chr1
DEFINE i    LIKE type_file.num5    #FUN-C50017 add
          LET g_choice1= p_y
          LET g_choice2= p_y
#FUN-C50017 add begin ---
     LET g_choice3= p_y
     LET g_choice4= p_y
     FOR i=1 TO g_ryk.getLength()
        IF g_ryk_o[i].ryk05='Y' THEN
           LET g_ryk[i].ryk05= p_y
        END IF
     END FOR 
#FUN-C50017 add end ---
#FUN-C50017 MARK begin ---
#          LET g_flag1  = p_y
#          LET g_flag3  = p_y
#          LET g_flag4  = p_y
#          LET g_flag8  = p_y
#          LET g_flag9  = p_y
#          LET g_flag10 = p_y
#          LET g_flag11 = p_y
#          LET g_flag12 = p_y
#FUN-C50017 MARK end ----
#FUN-C50017 add begin ---
    DISPLAY g_choice1,g_choice2,g_choice3,g_choice4,
            g_ryk[101].ryk05,g_ryk[102].ryk05,g_ryk[103].ryk05,g_ryk[104].ryk05,
            g_ryk[105].ryk05,g_ryk[106].ryk05,g_ryk[107].ryk05,g_ryk[108].ryk05,g_ryk[109].ryk05,g_ryk[110].ryk05,    #FUN-CA0074 add g_ryk[110].ryk05
            g_ryk[111].ryk05,                                                                                         #FUN-CC0116 add
            g_ryk[201].ryk05,g_ryk[202].ryk05,g_ryk[203].ryk05,g_ryk[204].ryk05,g_ryk[205].ryk05,g_ryk[206].ryk05,
            g_ryk[207].ryk05,                                                                                         #FUN-D20020 add
            g_ryk[301].ryk05,g_ryk[302].ryk05,g_ryk[303].ryk05,
            g_ryk[401].ryk05,g_ryk[402].ryk05,g_ryk[403].ryk05,g_ryk[404].ryk05
            ,g_ryk[405].ryk05,g_ryk[406].ryk05                                                                        #FUN-CB0007 add
         TO pchoice1,pchoice2,pchoice3,pchoice4,
            ryk05101,ryk05102,ryk05103,ryk05104,ryk05105,ryk05106,ryk05107,ryk05108,ryk05109,ryk05110,ryk05111,       #FUN-CA0074 add ryk05110  #FUN-CC0116 addryk05111
            ryk05201,ryk05202,ryk05203,ryk05204,ryk05205,ryk05206,ryk05207,                                           #FUN-D20020 add
            ryk05301,ryk05302,ryk05303,
            ryk05401,ryk05402,ryk05403,ryk05404
            ,ryk05405,ryk05406                                                                                        #FUN-CB0007 add
#FUN-C50017 add end ---
END FUNCTION
FUNCTION p101_prepare()
DEFINE l_posstr   STRING 
DEFINE i          LIKE type_file.num5
DEFINE l_length   LIKE type_file.num5
DEFINE l_date     LIKE type_file.chr8  #目前未使用
DEFINE l_str      STRING
   LET l_posstr=""
   LET l_date = g_today
#FUN-C50017 MARK BEGIN ---
#   IF g_flag1='Y' THEN #门店基本资料                      
#       LET l_posstr=l_posstr CLIPPED,"|101|110|112"              #101门店基本资料 rtz_file,110公告栏资料ryv_file,112抽成
#   END IF
#   IF g_flag3='Y' THEN #基础编码资料
#       LET l_posstr=l_posstr CLIPPED,"|103|105|106|206|207"    #103POS授权码ryw,105发票档oom,106税种gec,206颜色tqa,207尺寸tqa
#   END IF
#   IF g_flag4='Y' THEN #券、卡种
#       LET l_posstr=l_posstr CLIPPED,"|108|109|111"            #108券类型lpx_file,209联盟卡种rxw_file,111卡种lph_file
#   END IF
#   IF g_flag8='Y' THEN #客户资料
#       LET l_posstr=l_posstr CLIPPED,"|104"                #104客户资料occ_file
#   END IF     
#   IF g_flag9='Y' THEN #会员资料
#       LET l_posstr=l_posstr CLIPPED,"|401|402|403"          #401会员基础资料lpk_file，402卡明细状态档lpj_file,403积分折扣lrp_file
#   END IF    
#   IF g_flag10='Y' THEN #商品基本资料
##      LET l_posstr=l_posstr CLIPPED,"|208|201|202|203|204|205|107"  #208单位档gfe,201产品策略rte,202条码rta,203价格策略rtg,     #FUN-B90049 mark
#       LET l_posstr=l_posstr CLIPPED,"|208|201|203|204|205|107"      #208单位档gfe,201产品策略rte,203价格策略rtg,                #FUN-B90049 add
#   END IF                                                            #204成品款号rte-,205 商户商品关联lmv_file,107合同资料单头档lnt_file
#   IF g_flag11='Y' THEN #pos用户资料
#       LET l_posstr=l_posstr CLIPPED,"|102"                   #102pos使用者资料ryi_file
#   END IF
#   IF g_flag12='Y' THEN #促销资料
#       LET l_posstr=l_posstr CLIPPED,"|301|302|303"             #302一般促销rab_file,303组合促销rae_file,301满额促销rah_file
#   END IF
#FUN-C50017 MARK END ---
#FUN-C50017 add begin ---
   IF g_ryk[101].ryk05='Y' THEN 
       LET l_posstr=l_posstr CLIPPED,"|101"              
   END IF
   IF g_ryk[102].ryk05='Y' THEN 
       LET l_posstr=l_posstr CLIPPED,"|102"    
   END IF
   IF g_ryk[103].ryk05='Y' THEN 
       LET l_posstr=l_posstr CLIPPED,"|103"           
   END IF
   IF g_ryk[104].ryk05='Y' THEN 
       LET l_posstr=l_posstr CLIPPED,"|104"                
   END IF
   IF g_ryk[105].ryk05='Y' THEN 
       LET l_posstr=l_posstr CLIPPED,"|105"          
   END IF
   IF g_ryk[106].ryk05='Y' THEN 
       LET l_posstr=l_posstr CLIPPED,"|106"     
   END IF                                                            
   IF g_ryk[107].ryk05='Y' THEN 
       LET l_posstr=l_posstr CLIPPED,"|107"                   
   END IF
   IF g_ryk[108].ryk05='Y' THEN
       LET l_posstr=l_posstr CLIPPED,"|108"
   END IF  
   IF g_ryk[109].ryk05='Y' THEN
       LET l_posstr=l_posstr CLIPPED,"|109"
   END IF
   #FUN-CA0074---ADD--STR
   IF g_ryk[110].ryk05='Y' THEN
       LET l_posstr=l_posstr CLIPPED,"|110"
   END IF
   #FUN-CA0074---ADD--END
   #FUN-CC0116---ADD--STR
   IF g_ryk[111].ryk05='Y' THEN
       LET l_posstr=l_posstr CLIPPED,"|111"
   END IF
   #FUN-CC0116---ADD--END
   IF g_ryk[201].ryk05='Y' THEN 
       LET l_posstr=l_posstr CLIPPED,"|201"            
   END IF
   IF g_ryk[202].ryk05='Y' THEN 
       LET l_posstr=l_posstr CLIPPED,"|202"            
   END IF
   IF g_ryk[203].ryk05='Y' THEN 
       LET l_posstr=l_posstr CLIPPED,"|203"            
   END IF
   IF g_ryk[204].ryk05='Y' THEN 
       LET l_posstr=l_posstr CLIPPED,"|204"            
   END IF
   IF g_ryk[205].ryk05='Y' THEN 
       LET l_posstr=l_posstr CLIPPED,"|205"            
   END IF
   IF g_ryk[206].ryk05='Y' THEN 
       LET l_posstr=l_posstr CLIPPED,"|206"            
   END IF
  #FUN-D20020--add--str---
   IF g_ryk[207].ryk05='Y' THEN
       LET l_posstr=l_posstr CLIPPED,"|207"
   END IF
  #FUN-D20020--add--end---
   IF g_ryk[301].ryk05='Y' THEN 
       LET l_posstr=l_posstr CLIPPED,"|301"            
   END IF
   IF g_ryk[302].ryk05='Y' THEN 
       LET l_posstr=l_posstr CLIPPED,"|302"            
   END IF
   IF g_ryk[303].ryk05='Y' THEN 
       LET l_posstr=l_posstr CLIPPED,"|303"            
   END IF
   IF g_ryk[401].ryk05='Y' THEN 
       LET l_posstr=l_posstr CLIPPED,"|401"            
   END IF
   IF g_ryk[402].ryk05='Y' THEN 
       LET l_posstr=l_posstr CLIPPED,"|402"            
   END IF
   IF g_ryk[403].ryk05='Y' THEN 
       LET l_posstr=l_posstr CLIPPED,"|403"            
   END IF
   IF g_ryk[404].ryk05='Y' THEN 
       LET l_posstr=l_posstr CLIPPED,"|404"            
   END IF
   #FUN-CB0007------add----str
   IF g_ryk[405].ryk05='Y' THEN
       LET l_posstr=l_posstr CLIPPED,"|405"
   END IF
   IF g_ryk[406].ryk05='Y' THEN
       LET l_posstr=l_posstr CLIPPED,"|406"
   END IF
   #FUN-CB0007------add----end
#FUN-C50017 add end -----

   IF NOT cl_null(l_posstr) THEN
    #FUN-BB0129 add START
      IF (l_posstr.getIndexOf("101", 1) AND l_posstr.getIndexOf("201", 1)) THEN
#         CALL cl_replace_str(l_posstr, "|201|203", "") RETURNING l_posstr   #FUN-C50017 mark
#         CALL cl_replace_str(l_posstr, "|201|202", "") RETURNING l_posstr   #FUN-C50017 add     #FUN-C50017 mark     
      END IF
    #FUN-BB0129 add END
      LET l_length=l_posstr.getlength()
      LET l_posstr=l_posstr.substring(2,l_length)  #cut the first character:'|'
   ELSE 
      CALL cl_err(l_posstr,'apc-100',1)     #需下傳的參數為空，請檢查!
   END IF
   IF NOT cl_null(l_posstr) THEN
      IF cl_confirm("apc-073") THEN                            
        #CALL p100(l_posstr,g_pplant,g_pdb,l_date,'2')         #cmd:sapcp100.4gl.p100()  #FUN-BC0015 mark
        #CALL p100(l_posstr,g_pplant,g_pdb,l_date,'2','','')   #FUN-BC0015 add
         CALL p100(l_posstr,g_pplant,g_pdb,l_date,'2')         #By shi Mod
         IF g_success = 'Y' THEN
            CALL cl_end2(1) RETURNING l_flag
         ELSE
            CALL cl_end2(2) RETURNING l_flag
         END IF
         IF NOT l_flag THEN 
            CLOSE WINDOW p101_w
            CALL  cl_used(g_prog,g_time,2) RETURNING g_time
            EXIT PROGRAM           #FUN-D30093 add
         END IF
      END IF
   END IF

END FUNCTION

#FUN-C50017 add begin ---

FUNCTION p101_set_entry(p_cmd)  #判断是否可以输入栏位
   DEFINE   p_cmd     LIKE type_file.chr1
      CALL cl_set_comp_entry("ryk05101",g_ryk_o[101].ryk05  = 'Y')
      CALL cl_set_comp_entry("ryk05102",g_ryk_o[102].ryk05  = 'Y')
      CALL cl_set_comp_entry("ryk05103",g_ryk_o[103].ryk05  = 'Y')
      CALL cl_set_comp_entry("ryk05104",g_ryk_o[104].ryk05  = 'Y')
      CALL cl_set_comp_entry("ryk05105",g_ryk_o[105].ryk05  = 'Y')
      CALL cl_set_comp_entry("ryk05106",g_ryk_o[106].ryk05  = 'Y')
      CALL cl_set_comp_entry("ryk05107",g_ryk_o[107].ryk05  = 'Y')
      CALL cl_set_comp_entry("ryk05108",g_ryk_o[108].ryk05  = 'Y')
      CALL cl_set_comp_entry("ryk05109",g_ryk_o[109].ryk05  = 'Y')
      CALL cl_set_comp_entry("ryk05110",g_ryk_o[110].ryk05  = 'Y')
      CALL cl_set_comp_entry("ryk05111",g_ryk_o[111].ryk05  = 'Y')
      CALL cl_set_comp_entry("ryk05112",g_ryk_o[112].ryk05  = 'Y')
      CALL cl_set_comp_entry("ryk05201",g_ryk_o[201].ryk05  = 'Y')
      CALL cl_set_comp_entry("ryk05202",g_ryk_o[202].ryk05  = 'Y')    
      CALL cl_set_comp_entry("ryk05203",g_ryk_o[203].ryk05  = 'Y')
      CALL cl_set_comp_entry("ryk05204",g_ryk_o[204].ryk05  = 'Y')
      CALL cl_set_comp_entry("ryk05205",g_ryk_o[205].ryk05  = 'Y')
      CALL cl_set_comp_entry("ryk05206",g_ryk_o[206].ryk05  = 'Y')
      CALL cl_set_comp_entry("ryk05207",g_ryk_o[207].ryk05  = 'Y')
      CALL cl_set_comp_entry("ryk05208",g_ryk_o[208].ryk05  = 'Y')
      CALL cl_set_comp_entry("ryk05301",g_ryk_o[301].ryk05  = 'Y')
      CALL cl_set_comp_entry("ryk05302",g_ryk_o[302].ryk05  = 'Y')
      CALL cl_set_comp_entry("ryk05303",g_ryk_o[303].ryk05  = 'Y')
      CALL cl_set_comp_entry("ryk05401",g_ryk_o[401].ryk05  = 'Y')
      CALL cl_set_comp_entry("ryk05402",g_ryk_o[402].ryk05  = 'Y')
      CALL cl_set_comp_entry("ryk05403",g_ryk_o[403].ryk05  = 'Y')
      CALL cl_set_comp_entry("ryk05404",g_ryk_o[404].ryk05  = 'Y')                      #FUN-C50017  add
      CALL cl_set_comp_entry("ryk05405",g_ryk_o[405].ryk05  = 'Y')                      #FUN-CC0116 add
      CALL cl_set_comp_entry("ryk05406",g_ryk_o[406].ryk05  = 'Y')                      #FUN-CC0116 add
END FUNCTION

FUNCTION p101_chk_choice(p_type,p_z,p_n1,p_n2)
DEFINE  p_type  LIKE  type_file.chr1               #0 代表根据内容赋值组变量、1代表根据组变量赋值内容变量
DEFINE  p_z     LIKE  type_file.chr1               #组类型 1/2/3/4  例如1代表基本资料
DEFINE  p_n1    LIKE  type_file.num5               #开始项次
DEFINE  p_n2    LIKE  type_file.num5               #结束项次
DEFINE  l_y     LIKE  type_file.chr1               #
DEFINE  l_i     LIKE  type_file.num5               #循环遍历

     IF p_type = '0'  THEN            #内容赋值给组
             LET l_y = 'Y'
             FOR l_i = p_n1 TO p_n2
                 IF g_ryk[l_i].ryk05  = "N" THEN
                   LET l_y = "N"
                   EXIT FOR
                 END IF
             END FOR
             CASE p_z
                  WHEN "1"  LET g_choice1 = l_y
                  WHEN "2"  LET g_choice2 = l_y
                  WHEN "3"  LET g_choice3 = l_y
                  WHEN "4"  LET g_choice4 = l_y
             END CASE
     ELSE
            CASE p_z
                  WHEN "1"  LET l_y = g_choice1
                  WHEN "2"  LET l_y = g_choice2
                  WHEN "3"  LET l_y = g_choice3
                  WHEN "4"  LET l_y = g_choice4
             END CASE
             FOR l_i = p_n1 TO p_n2
                 IF g_ryk_o[l_i].ryk05 = 'Y' THEN  LET g_ryk[l_i].ryk05= l_y  END IF
             END FOR
     END IF
END FUNCTION 
#FUN-C50017 add end -----
