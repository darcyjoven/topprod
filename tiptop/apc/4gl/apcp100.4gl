# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: "apcp100.4gl"
# Descriptions...: 門店異動資料下傳處理
# Date & Author..: 11/07/04 By liupeng TQC-B70037 FUN-B70105
# Modify.........: No.FUN-B80069 11/08/10 背景作業避免佔用License
# Modify.........: No.FUN-B90049 11/09/22 By huangtao 取消 "產品條碼" 資料的下傳項目.
# Modify.........: No.FUN-BC0015 12/01/30 By pauline p100()增加參數
# Modify.........: No.FUN-C50017 12/05/08 By yangxf 调整画面档及相关逻辑
# Modify.........: No.FUN-CA0074 12/10/15 By xumm 增加门店参数资料栏位
# Modify.........: No.FUN-CB0007 12/11/06 By xumm 增加会员等级和会员类型的下传
# Modify.........: No.FUN-CA0119 12/11/12 By jiangbo 增加s_chk_process判断
# Modify.........: No:FUN-CB0007 12/11/14 By shiwuying 增加进程判断
# Modify.........: No.FUN-CC0116 13/01/14 By xumm 增加专柜抽成资料的下传
# Modify.........: No.FUN-D20020 13/02/20 By dongsz 增加觸屏資料的下傳

DATABASE ds
#TQC-B70037 FUN-B70105
GLOBALS "../../config/top.global"
 
DEFINE  g_ryk   DYNAMIC ARRAY OF RECORD 
                ryk01       LIKE ryk_file.ryk01,
                ryk05       LIKE ryk_file.ryk05
                END RECORD
#FUN-B90049 ---------------STA
DEFINE  g_ryk_t DYNAMIC ARRAY OF RECORD
                ryk01       LIKE ryk_file.ryk01,
                ryk05       LIKE ryk_file.ryk05
                END RECORD
#FUN-B90049 ---------------END
                
DEFINE  g_ryk_o DYNAMIC ARRAY OF RECORD 
                ryk01       LIKE ryk_file.ryk01,
                ryk05       LIKE ryk_file.ryk05
                END RECORD                                                
DEFINE  g_sql   STRING
DEFINE  p_row,p_col     LIKE type_file.num5
DEFINE  l_flag LIKE  type_file.chr1 
DEFINE  g_posstr STRING
DEFINE  g_posway LIKE type_file.chr1
DEFINE  g_choice1   LIKE type_file.chr1 
DEFINE  g_choice2   LIKE type_file.chr1   
DEFINE  g_choice3   LIKE type_file.chr1  
DEFINE  g_choice4   LIKE type_file.chr1
###########################################################
#add by jiangbo  FUN-CA0119
DEFINE  p_apname    LIKE type_file.chr10
DEFINE  p_prog      LIKE type_file.chr10
DEFINE  p_dist      LIKE type_file.chr1
###########################################################
DEFINE  g_msg       STRING                 #FUN-CB0007

MAIN
     IF FGL_GETENV("FGLGUI")<>"0" THEN     #FUN-B80069 add
        OPTIONS                            
        INPUT NO WRAP
     END IF                                #FUN-B80069 add
     DEFER INTERRUPT                      
     LET g_posstr = ARG_VAL(1)    #传输的Table 对应的项次
     LET g_bgjob  = ARG_VAL(2)    #背景作业
     LET g_posway = '1'           #1.手工異動下傳 2.初始化下傳
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
###########################################################
#add by jiangbo apcp100 FUN-CA0119
#    LET p_apname = cl_used_ap_hostname()
#    LET p_prog = 'apcp100'
#    CALL s_chk_process_pos(p_apname,p_prog,p_dist)
###########################################################
##add by jiangbo apcp200
#    LET p_apname = cl_used_ap_hostname()
#    LET p_prog = 'apcp200'
#    LET p_dist = 'Y'
#    CALL s_chk_process_pos(p_apname,p_prog,p_dist)
###########################################################
#返回值为TRUE/FALSE
#请增加接收返回值部分
###########################################################
    #FUN-CB0007 Begin---
     LET p_apname = cl_used_ap_hostname()
     IF NOT s_chk_process_pos(p_apname,'apcp100','N') THEN
        IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
           IF cl_confirm('apc-207') THEN
             #LET g_msg =  "apcq070 'apcp100'"
              LET g_msg =  "apcq070 "
              CALL cl_cmdrun(g_msg)
           END IF
        END IF
        EXIT PROGRAM
     END IF
    #FUN-CB0007 End-----

     CALL cl_used(g_prog,g_time,1)      
          RETURNING g_time   
           
    IF g_bgjob = 'Y' THEN
       LET g_success = 'Y'
       CALL p100(g_posstr,'','','',g_posway)
       CALL cl_batch_bg_javamail(g_success) 
    ELSE
       LET p_row = 4 LET p_col = 10
       OPEN WINDOW p100_w AT p_row,p_col WITH FORM "apc/42f/apcp100"
             ATTRIBUTE (STYLE = g_win_style CLIPPED) 
       CALL cl_ui_init()
       CALL cl_set_comp_visible("ryk01",FALSE)
       CALL p100_fill("1 = 1")
       CALL p100_show()
       CALL p100_menu()
       CLOSE WINDOW p100_w                   
    END IF
    CALL  cl_used(g_prog,g_time,2)        
    RETURNING g_time    
END MAIN
 
FUNCTION p100_menu()
   MENU ""
      BEFORE MENU
      
      ON ACTION modify
         LET g_action_choice="modify"
         IF cl_chk_act_auth() THEN
            CALL p100_u()
         END IF
         
      ON ACTION manual_trans
         LET g_action_choice="manual_trans"
         IF cl_chk_act_auth() THEN
            CALL p100_prepare()
         END IF
      
      ON ACTION selectall 
         LET g_action_choice="selectall"
         IF cl_chk_act_auth() THEN
            CALL p100_yn('Y')
         END IF

      ON ACTION cancelall
         LET g_action_choice="cancelall"
         IF cl_chk_act_auth() THEN
            CALL p100_yn('N')
         END IF
      
      ON ACTION pos_trans
         LET g_action_choice="pos_trans"
         IF cl_chk_act_auth() THEN
            CALL cl_cmdrun_wait("apci020")
         END IF

      ON ACTION help
         CALL cl_show_help()
         
      ON ACTION controlg   
         CALL cl_cmdask()
         
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                  
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT MENU       
      
      COMMAND KEY(INTERRUPT)
         LET INT_FLAG=FALSE 	
         LET g_action_choice="exit"
         EXIT MENU 
      
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE MENU
 
      ON ACTION about         
         CALL cl_about()      
            
#FUN-C50017 mark begin ---
#      ON ACTION exporttoexcel   
#         IF cl_chk_act_auth() THEN
#            CALL cl_export_to_excel
#            (ui.Interface.getRootNode(),base.TypeInfo.create(g_ryk),'','')
#         END IF    
#FUN-C50017 mark end ----

   END MENU 
END FUNCTION

FUNCTION p100_fill(p_wc)#加载数据
DEFINE  p_wc        STRING
DEFINE  l_ryk       RECORD
                      ryk01       LIKE ryk_file.ryk01,
                      ryk05       LIKE type_file.chr1
                    END RECORD

      LET g_sql = "SELECT ryk01,ryk05 FROM ryk_file WHERE ",p_wc," ORDER BY ryk01"
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
      LET  g_bgjob = 'N'
#FUN-C50017 MARK BEGIN---
#      CALL p100_chk_choice('0','1',101,112) #组归类变量赋值
#      CALL p100_chk_choice('0','2',201,208) #组归类变量赋值
#      CALL p100_chk_choice('0','3',301,303) #组归类变量赋值
#      CALL p100_chk_choice('0','4',401,403) #组归类变量赋值
#FUN-C50017 MARK END ---
#FUN-C50017 add begin ---
       #CALL p100_chk_choice('0','1',101,109)    #FUN-CA0074 mark
       #CALL p100_chk_choice('0','1',101,110)    #FUN-CA0074 add  #FUN-CC0116 mark
       CALL p100_chk_choice('0','1',101,111)     #FUN-CC0116 add
      #CALL p100_chk_choice('0','2',201,206)     #FUN-D20020 mark
       CALL p100_chk_choice('0','2',201,207)     #FUN-D20020 add                                                             
       CALL p100_chk_choice('0','3',301,303)
       #CALL p100_chk_choice('0','4',401,404)    #FUN-CB0007 mark
       CALL p100_chk_choice('0','4',401,406)     #FUN-CB0007 add
#FUN-C50017 add end -----
END FUNCTION 

FUNCTION p100_show()
DEFINE  l_i         LIKE type_file.chr2
DEFINE  l_ryk   RECORD 
                ryk01       LIKE ryk_file.ryk01,
                ryk05       LIKE type_file.chr1
                END RECORD    
   DISPLAY g_choice1,g_choice2,g_choice3,g_choice4, 
           g_ryk[101].ryk05,g_ryk[102].ryk05,g_ryk[103].ryk05,g_ryk[104].ryk05,g_ryk[105].ryk05,g_ryk[106].ryk05,
           g_ryk[107].ryk05,g_ryk[108].ryk05,g_ryk[109].ryk05,g_ryk[110].ryk05,g_ryk[111].ryk05,                     #FUN-C50017 add  #FUN-CA0074 add g_ryk[110].ryk05  #FUN-CC0116 add g_ryk[111].ryk05
#          g_ryk[107].ryk05,g_ryk[108].ryk05,g_ryk[109].ryk05,g_ryk[110].ryk05,g_ryk[111].ryk05,g_ryk[112].ryk05,    #FUN-C50017 MARK
#          g_ryk[201].ryk05,g_ryk[202].ryk05,g_ryk[203].ryk05,g_ryk[204].ryk05,g_ryk[205].ryk05,g_ryk[206].ryk05,    #FUN-B90049 mark
           g_ryk[201].ryk05,g_ryk[202].ryk05,g_ryk[203].ryk05,g_ryk[204].ryk05,g_ryk[205].ryk05,g_ryk[206].ryk05,    #FUN-B90049 add   #FUN-C50017 add g_ryk[202].ryk05
#          g_ryk[207].ryk05,g_ryk[208].ryk05,                                                                        #FUN-C50017 MARK
           g_ryk[207].ryk05,                                                                                         #FUN-D20020 add
	   g_ryk[301].ryk05,g_ryk[302].ryk05,g_ryk[303].ryk05,
	   g_ryk[401].ryk05,g_ryk[402].ryk05,g_ryk[403].ryk05,
           g_ryk[404].ryk05,g_ryk[405].ryk05,g_ryk[406].ryk05,                                                       #FUN-B90049 add  #FUN-CB0007 add g_ryk[405].ryk05,g_ryk[406].ryk05
	   g_bgjob
        TO pchoice1,pchoice2,pchoice3,pchoice4, 
           ryk05101,ryk05102,ryk05103,ryk05104,ryk05105,ryk05106,
           ryk05107,ryk05108,ryk05109,ryk05110,ryk05111,                                                             #FUN-C50017 add #FUN-CA0074 add ryk05110  #FUN-CC0116 add ryk05111
#          ryk05107,ryk05108,ryk05109,ryk05110,ryk05111,ryk05112,                                                    #FUN-C50017 MARK
#	   ryk05201,ryk05202,ryk05203,ryk05204,ryk05205,ryk05206,                                                    #FUN-B90049 mark
           ryk05201,ryk05202,ryk05203,ryk05204,ryk05205,ryk05206,                                                    #FUN-B90049 add   #FUN-C50017 add  ryk05202
#          ryk05207,ryk05208,                                                                                        #FUN-C50017 MARK
           ryk05207,                                                                                                 #FUN-D20020 add
	   ryk05301,ryk05302,ryk05303,
	   ryk05401,ryk05402,ryk05403,
           ryk05404,ryk05405,ryk05406,                                                                               #FUN-B90049 add  #FUN-CB0007 add ryk05405,ryk05406
	   g_bgjob
END FUNCTION

FUNCTION p100_u()
   CALL cl_opmsg('u')
   CALL p100_i('u')
   CALL p100_show() 
END FUNCTION

FUNCTION p100_i(p_cmd)
   DEFINE p_cmd     LIKE type_file.chr1 
   DEFINE lc_cmd LIKE type_file.chr1000
   DEFINE l_max,l_n INTEGER    
#FUN-B90049 ---------------STA
   CALL g_ryk_t.clear()
   LET l_max = g_ryk.getLength()
   FOR l_n = 1 TO l_max
      LET g_ryk_t[l_n].* = g_ryk[l_n].*
   END FOR
#FUN-B90049 ---------------END

   INPUT g_choice1,   
         g_ryk[101].ryk05,g_ryk[102].ryk05,g_ryk[103].ryk05,g_ryk[104].ryk05,g_ryk[105].ryk05,g_ryk[106].ryk05,
         g_ryk[107].ryk05,g_ryk[108].ryk05,g_ryk[109].ryk05,g_ryk[110].ryk05,g_ryk[111].ryk05,                   #FUN-C50017 add   #FUN-CA0074 add g_ryk[110].ryk05  #FUN-CC0116 add g_ryk[111].ryk05
#        g_ryk[107].ryk05,g_ryk[108].ryk05,g_ryk[109].ryk05,g_ryk[110].ryk05,g_ryk[111].ryk05,g_ryk[112].ryk05,  #FUN-C50017 mark
         g_choice2,   
#        g_ryk[201].ryk05,g_ryk[202].ryk05,g_ryk[203].ryk05,g_ryk[204].ryk05,g_ryk[205].ryk05,g_ryk[206].ryk05,  #FUN-B90049 mark
         g_ryk[201].ryk05,g_ryk[202].ryk05,g_ryk[203].ryk05,g_ryk[204].ryk05,g_ryk[205].ryk05,g_ryk[206].ryk05,  #FUN-B90049 add   #FUN-C50017 add g_ryk[202].ryk05
#        g_ryk[207].ryk05,g_ryk[208].ryk05,                                                                      #FUN-C50017 mark 
         g_ryk[207].ryk05,                                                                                       #FUN-D20020 add
         g_choice3,   
         g_ryk[301].ryk05,g_ryk[302].ryk05,g_ryk[303].ryk05,
         g_choice4,  
         g_ryk[401].ryk05,g_ryk[402].ryk05,g_ryk[403].ryk05,
         g_ryk[404].ryk05,g_ryk[405].ryk05,g_ryk[406].ryk05,                                                     #FUN-C50017 add  #FUN-CB0007 add g_ryk[405].ryk05,g_ryk[406].ryk05
	 g_bgjob
         WITHOUT DEFAULTS
   FROM  pchoice1,  
         ryk05101,ryk05102,ryk05103,ryk05104,ryk05105,ryk05106,
         ryk05107,ryk05108,ryk05109,ryk05110,ryk05111,                                                           #FUN-C50017 add  #FUN-C50017 add ryk05110  #FUN-CC0116 add ryk05111
#        ryk05107,ryk05108,ryk05109,ryk05110,ryk05111,ryk05112,                                                  #FUN-C50017 mark
         pchoice2,    
#        ryk05201,ryk05202,ryk05203,ryk05204,ryk05205,ryk05206,                                                  #FUN-B90049 mark
         ryk05201,ryk05202,ryk05203,ryk05204,ryk05205,ryk05206,                                                  #FUN-B90049 add   #FUN-C50017 add ryk05202 
#        ryk05207,ryk05208,                                                                                      #FUN-C50017 mark 
         ryk05207,                                                                                               #FUN-D20020 add
         pchoice3,    
         ryk05301,ryk05302,ryk05303,
         pchoice4,
         ryk05401,ryk05402,ryk05403,
         ryk05404,ryk05405,ryk05406,                                                                             #FUN-C50017 add   #FUN-CB0007 add ryk05405,ryk05406
         g_bgjob
       BEFORE INPUT
          CALL p100_set_entry(p_cmd)           

       AFTER INPUT
          IF INT_FLAG THEN
             LET INT_FLAG = 0
#FUN-C50017 add begin ---
             LET l_max = g_ryk.getLength()
             FOR l_n = 1 TO l_max
                LET g_ryk[l_n].* = g_ryk_t[l_n].*
             END FOR
             #CALL p100_chk_choice('0','1',101,109)   #FUN-CA0074 mark
             #CALL p100_chk_choice('0','1',101,110)   #FUN-CA0074 add  #FUN-CC0116 mark
             CALL p100_chk_choice('0','1',101,111)    #FUN-CC0116 add
            #CALL p100_chk_choice('0','2',201,206)    #FUN-D20020 mark
             CALL p100_chk_choice('0','2',201,207)    #FUN-D20020 add
             CALL p100_chk_choice('0','3',301,303)
             #CALL p100_chk_choice('0','4',401,404)   #FUN-CB0007 mark
             CALL p100_chk_choice('0','4',401,406)    #FUN-CB0007 add
#FUN-C50017 add end  ---
             EXIT INPUT
          END IF
#FUN-C50017 mark begin ---
#         CALL p100_chk_choice('0','1',101,112) 
#         CALL p100_chk_choice('0','2',201,208) 
#         CALL p100_chk_choice('0','3',301,303) 
#         CALL p100_chk_choice('0','4',401,403) 
#FUN-C50017 mark end -----
#FUN-C50017 add begin ---
          #CALL p100_chk_choice('0','1',101,109)    #FUN-CA0074 mark
          #CALL p100_chk_choice('0','1',101,110)    #FUN-CA0074 add  #FUN-CC0116 mark
          CALL p100_chk_choice('0','1',101,111)     #FUN-CC0116 add
         #CALL p100_chk_choice('0','2',201,206)     #FUN-D20020 mark
          CALL p100_chk_choice('0','2',201,207)     #FUN-D20020 add
          CALL p100_chk_choice('0','3',301,303)
          #CALL p100_chk_choice('0','4',401,404)    #FUN-CB0007 mark
          CALL p100_chk_choice('0','4',401,406)     #FUN-CB0007 add
#FUN-C50017 add end  -----
          IF g_bgjob = "Y" THEN
             SELECT zz08 INTO lc_cmd FROM zz_file
             WHERE zz01 = "apcp100"
             IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
                 CALL cl_err('apcp100','9031',1)
             ELSE
	         CALL p100_getstr() RETURNING g_posstr
                 LET lc_cmd = lc_cmd CLIPPED,
                           "'",g_posstr CLIPPED,"' ",
                           "'",g_bgjob CLIPPED,"'"
                 CALL cl_cmdat('apcp100',g_time,lc_cmd CLIPPED)
             END IF
             CLOSE WINDOW p100_w
             CALL cl_used(g_prog,g_time,2) RETURNING g_time
             EXIT PROGRAM
           END IF          
      ON CHANGE pchoice1
#        CALL p100_chk_choice('1','1',101,112)    #FUN-C50017 MARK
#        CALL p100_chk_choice('1','1',101,109)    #FUN-C50017 add   #FUN-CA0074 mark
#        CALL p100_chk_choice('1','1',101,110)    #FUN-CA0074 add   #FUN-CC0116 mark
         CALL p100_chk_choice('1','1',101,111)    #FUN-CC0116 add
         CALL p100_show() 
 
      ON CHANGE pchoice2
#        CALL p100_chk_choice('1','2',201,208)    #FUN-C50017 MARK
        #CALL p100_chk_choice('1','2',201,206)    #FUN-C50017 add   #FUN-D20020 mark
         CALL p100_chk_choice('1','2',201,207)    #FUN-D20020 add
         CALL p100_show()
   
      ON CHANGE pchoice3
         CALL p100_chk_choice('1','3',301,303) 
         CALL p100_show()

      ON CHANGE pchoice4
#        CALL p100_chk_choice('1','4',401,403)    #FUN-C50017 MARK 
#        CALL p100_chk_choice('1','4',401,404)    #FUN-C50017 add   #FUN-CB0007 mark
         CALL p100_chk_choice('1','4',401,406)    #FUN-CB0007 add
         CALL p100_show()  
       
      AFTER FIELD g_bgjob
         IF g_bgjob NOT MATCHES '[YN]' OR g_bgjob IS NULL THEN
            NEXT FIELD g_bgjob
         END IF

#FUN-C50017 add begin ---
      ON ACTION selectall
          CALL p100_yn('Y')        

       ON ACTION cancelall
          CALL p100_yn('N')        

#FUN-C50017 add end -----
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
 
       ON ACTION help          
          CALL cl_show_help()  
 
       ON ACTION controls                    
          CALL cl_set_head_visible("","AUTO")	 
   END INPUT
   
END FUNCTION

FUNCTION p100_yn(p_y)
DEFINE i     LIKE type_file.num5
DEFINE p_y   LIKE type_file.chr1 
     FOR i=1 TO g_ryk.getLength()
        IF g_ryk_o[i].ryk05='Y' THEN
           LET g_ryk[i].ryk05= p_y
        END IF
     END FOR
     LET g_choice1= p_y
     LET g_choice2= p_y
     LET g_choice3= p_y
     LET g_choice4= p_y
     CALL p100_show()
END FUNCTION
FUNCTION p100_getstr()
DEFINE i   LIKE type_file.num5
DEFINE l_ryk01 LIKE type_file.chr50     #主要是定义字符类型 使l_str字符串无空白
DEFINE l_str STRING 
   LET l_str =''
   FOR i=1 TO g_ryk.getLength()
       IF g_ryk[i].ryk05 = 'Y' THEN  
          LET l_ryk01 = g_ryk[i].ryk01 
          IF cl_null(l_str) THEN 
             LET l_str = l_ryk01 CLIPPED
          ELSE  
             LET l_str = l_str CLIPPED,'|',l_ryk01 CLIPPED
          END IF
       END IF
   END FOR
   LET l_str = l_str.toLowerCase() 
   LET l_str = l_str.trim()
RETURN l_str 
END FUNCTION 
FUNCTION p100_prepare()
  CALL p100_getstr() RETURNING g_posstr
  IF NOT cl_null(g_posstr) THEN
     IF cl_sure(0,0) THEN
        CALL p100(g_posstr,'','','',g_posway)
        IF g_success ='Y' THEN 
           CALL cl_end2(1) RETURNING l_flag
        ELSE 
           CALL cl_end2(2) RETURNING l_flag
        END IF
        IF NOT l_flag THEN
           CLOSE WINDOW p100_w
           CALL cl_used(g_prog,g_time,2) RETURNING g_time     
           EXIT PROGRAM
        END IF
     END IF 
  ELSE
     CALL cl_err(g_posstr,'apc-100',0)   #下传参数为空，请检查!
  END IF   
END FUNCTION
                                                   
FUNCTION p100_set_entry(p_cmd)  #判断是否可以输入栏位
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
#     CALL cl_set_comp_entry("ryk05202",g_ryk_o[202].ryk05  = 'Y')                      #FUN-B90049  mark
      CALL cl_set_comp_entry("ryk05202",g_ryk_o[202].ryk05  = 'Y')                      #FUN-C50017  add
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

FUNCTION p100_chk_choice(p_type,p_z,p_n1,p_n2)     #组/内容信息切换回写 
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
