# Prog. Version..: '5.10.04-08.10.22(00000)'     #
#
# Pattern name...: ghri002.4gl
# Descriptions...: 
# Date & Author..: 03/21/13 by zhangbo

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE 
     g_hrap           DYNAMIC ARRAY OF RECORD    
        hrap04       LIKE hrap_file.hrap04,
        hrap05       LIKE hrap_file.hrap05,
        hrap06       LIKE hrap_file.hrap06,
        hrap07       LIKE hrap_file.hrap07,
        hrap08       LIKE hrap_file.hrap08,
        hrap09       LIKE hrap_file.hrap09,
        hrap10       LIKE hrap_file.hrap10,
        hrap11       LIKE hrap_file.hrap11,
        hrap12       LIKE hrap_file.hrap12,
        hrapacti     LIKE hrap_file.hrapacti
          
                    END RECORD,
    g_hrap_t         RECORD                 
        hrap04       LIKE hrap_file.hrap04,
        hrap05       LIKE hrap_file.hrap05,
        hrap06       LIKE hrap_file.hrap06,
        hrap07       LIKE hrap_file.hrap07,
        hrap08       LIKE hrap_file.hrap08,
        hrap09       LIKE hrap_file.hrap09,
        hrap10       LIKE hrap_file.hrap10,
        hrap11       LIKE hrap_file.hrap11,
        hrap12       LIKE hrap_file.hrap12,        
        hrapacti     LIKE hrap_file.hrapacti
                    END RECORD,
    g_wc2           STRING,
    g_sql           STRING,
    g_cmd           LIKE type_file.chr1000, 
    g_rec_b         LIKE type_file.num5,                
    l_ac            LIKE type_file.num5                 

DEFINE g_hrap01     LIKE hrap_file.hrap01
DEFINE g_hrap01_t   LIKE hrap_file.hrap01
DEFINE g_hrap02     LIKE hrap_file.hrap02
DEFINE g_hrap02_t   LIKE hrap_file.hrap02
DEFINE g_hrap03     LIKE hrap_file.hrap03
DEFINE g_hrap13     LIKE hrap_file.hrap13
DEFINE g_hrap14     LIKE hrap_file.hrap14
DEFINE g_hrap15     LIKE hrap_file.hrap15
DEFINE g_hrap13_t     LIKE hrap_file.hrap13
DEFINE g_hrap14_t     LIKE hrap_file.hrap14
DEFINE g_hrap15_t     LIKE hrap_file.hrap15
DEFINE g_forupd_sql STRING     
DEFINE g_cnt        LIKE type_file.num10      
DEFINE g_before_input_done   LIKE type_file.num5        
DEFINE g_i          LIKE type_file.num5     
DEFINE g_on_change  LIKE type_file.num5      
DEFINE g_row_count  LIKE type_file.num5       
DEFINE g_curs_index LIKE type_file.num5
DEFINE g_jump       LIKE type_file.num10
DEFINE g_no_ask     LIKE type_file.num5      
DEFINE g_str        STRING 
DEFINE g_msg        LIKE type_file.chr1000
DEFINE g_argv1      LIKE hrap_file.hrap01
DEFINE g_argv2      LIKE hrap_file.hrap05


MAIN
DEFINE l_str,l_str1     LIKE  type_file.chr1000
DEFINE i         LIKE  type_file.num5
DEFINE l_i       LIKE  hrde_file.hrde06

    DEFINE p_row,p_col   LIKE type_file.num5    
#130529test
DEFINE l_sql     STRING
DEFINE l_a       LIKE   type_file.chr10
DEFINE l_b       LIKE   type_file.chr10
DEFINE l_x       LIKE   type_file.chr10
DEFINE l_arg     LIKE   type_file.chr1000
#test130621
DEFINE l_res     LIKE   hrdl_file.hrdl11  
DEFINE l_hrdl11  LIKE   hrdl_file.hrdl11
DEFINE l_hrdl12  LIKE   hrdl_file.hrdl12
DEFINE l_hrdl13  LIKE   hrdl_file.hrdl13
DEFINE l_hrdl14  LIKE   hrdl_file.hrdl14
DEFINE l_hrdl15  LIKE   hrdl_file.hrdl15
DEFINE l_hrdl16  LIKE   hrdl_file.hrdl16
DEFINE l_hrdl17  LIKE   hrdl_file.hrdl17
DEFINE l_hrdl18  LIKE   hrdl_file.hrdl18
DEFINE l_hrdl19  LIKE   hrdl_file.hrdl19
DEFINE l_hrdl20  LIKE   hrdl_file.hrdl20  
#test130621
DEFINE l_sql1    STRING
DEFINE a         ARRAY[2] OF  RECORD
       a         LIKE type_file.chr100
                 END RECORD
DEFINE b         ARRAY[2] OF  RECORD
       b         LIKE type_file.chr100
                 END RECORD
DEFINE c         DYNAMIC ARRAY OF LIKE type_file.chr100

DEFINE   l_zb1      LIKE    oeb_file.oeb14   #140116test
DEFINE   l_zb2      LIKE    type_file.num5   #140116test

#130924----for test
DEFINE l_t1,l_t2   INT
LET l_t1=10
#PREPARE test130924 FROM " call cp_test(?,?)"
#EXECUTE test130924 USING l_t1 IN,l_t2 OUT   
#130924----for test
    
    #140116test
    LET l_zb1=123.6
    LET l_zb2=l_zb1
    LET l_zb1=l_zb1-l_zb2
    #140116test   


    LET l_sql="create or replace procedure test_p1(a in varchar2,b in varchar2,x out varchar2,y out varchar2) is ",
              "   begin \n",
              "      if Year(a)=2013 then ",
              "             x := a||','||a; ",
              "      else ",
              "         if a='B' then ",
              "               x := 2+3; ",
              "         end if; ",
              "      end if; ",
              "      if b>0 then ",
              "             y := x; ",
              "      else ",
              "         if b<=0 then ",
              "               y := x+1; ",
              "         end if; ",
              "      end if; ",
              "      case  ",
              "         when b<10 then ",
              "            y := 100; ",
              "         when b<20 then ",
              "            y := 200; ",
              "      end case; ",
              "   end ;"

    PREPARE test1 from l_sql
    EXECUTE test1


    #LET l_a = "B"
    #LET l_b = 12.35

    LET a[1].a = '2013/01/01'
    LET a[2].a = 12.35
    LET l_x="a","||','||","b"
    PREPARE id1 FROM "call test_p1(?,?,?,?)"
    EXECUTE id1 USING a[1].a IN,a[2].a IN,b[1].b OUT,b[2].b OUT
    LET l_x=b[1].b,"/",b[2].b
    DISPLAY "l_x=",l_x
#130529test
 
    OPTIONS                              
        INPUT NO WRAP
    DEFER INTERRUPT                      
   
   LET l_str1="'A'"
   FOR i=1 TO 5
      LET l_i=0.01*i
      LET l_str=l_i
      IF i=3 THEN
         LET l_str="''"
      END IF
      LET l_str1=l_str1 CLIPPED,",",l_str CLIPPED 
   END FOR   

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("GHR")) THEN
      EXIT PROGRAM
   END IF
 
      CALL  cl_used(g_prog,g_time,1)       
         RETURNING g_time    
   
  #130924---for test
  PREPARE test130924 FROM " call cp_test(?,?)"
  EXECUTE test130924 USING l_t1 IN,l_t2 OUT
  #130924---for test   

   LET g_argv1=ARG_VAL(1)
   LET g_argv2=ARG_VAL(2)

    LET p_row = 4 LET p_col = 3
    OPEN WINDOW i002_w AT p_row,p_col WITH FORM "ghr/42f/ghri002"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) 
      
    CALL cl_ui_init()

    
    LET g_forupd_sql =" SELECT hrap01 FROM hrap_file ",
                      "  WHERE hrap01 = ? ",  #No.FUN-710055
                      " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i002_lock_u CURSOR FROM g_forupd_sql

   LET g_action_choice=""
   LET g_hrap01=''
   LET g_hrap02=''
   #IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) THEN
   #   LET g_wc2=" hrap01='",g_argv1,"' AND hrap05='",g_argv2,"'"
   IF NOT cl_null(g_argv1) THEN
      LET g_wc2=" hrap01='",g_argv1,"'"
      CALL i002_q()
   END IF

    CALL i002_menu()

    CLOSE WINDOW i002_w                 
      CALL  cl_used(g_prog,g_time,2)       
         RETURNING g_time    #No.FUN-6A0081
END MAIN

FUNCTION i002_menu()
 
   WHILE TRUE
      CALL i002_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i002_q()
            END IF
         WHEN "insert" 
            IF cl_chk_act_auth() THEN
               CALL i002_a()
            ELSE
               LET g_action_choice = NULL
            END IF
            	
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i002_b()
            ELSE
               LET g_action_choice = NULL
            END IF
            	
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i002_r()
            ELSE
               LET g_action_choice = NULL
            END IF   	
#add by zhuzw 20140627 start
          WHEN "gx" 
            IF cl_chk_act_auth() THEN
               CALL i002_gx()
            END IF
#add by zhuzw 20140627 end             	        
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
            
          WHEN "related_document"  #No.MOD-470515
            IF cl_chk_act_auth() AND l_ac != 0 THEN #NO.FUN-570199
               IF g_hrap01 IS NOT NULL THEN
                  LET g_doc.column1 = "hrap01"
                  LET g_doc.value1 = g_hrap01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0020
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrap),'','')
            END IF
          WHEN  "ghr_import"
            IF cl_chk_act_auth() THEN
                 CALL i002_import()
             ELSE
               LET g_action_choice = NULL
            END IF
      END CASE
   END WHILE
END FUNCTION
	
FUNCTION i002_q()
   MESSAGE ""
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   CLEAR FORM  #NO.TQC-740075
   CALL g_hrap.clear()
   DISPLAY '' TO FORMONLY.cnt
   CALL i002_b_askkey()
   IF INT_FLAG THEN                            
      LET INT_FLAG = 0
      RETURN
   END IF

   LET g_sql=" SELECT DISTINCT hrap01 FROM hrap_file ",
              "  WHERE ",g_wc2 CLIPPED,
              "  ORDER BY hrap01"
    PREPARE i002_prepare FROM g_sql
    DECLARE i002_curs
      SCROLL CURSOR WITH HOLD FOR i002_prepare

    LET g_sql=" SELECT COUNT(DISTINCT hrap01) FROM hrap_file ",
              "  WHERE ",g_wc2 CLIPPED
    PREPARE i002_count_prepare FROM g_sql
    DECLARE i002_count CURSOR FOR i002_count_prepare

    OPEN i002_count
    FETCH i002_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt	
    OPEN i002_curs
    IF SQLCA.SQLCODE THEN                         
       CALL cl_err('',SQLCA.SQLCODE,0)
       INITIALIZE g_hrap01 TO NULL                 
    ELSE
       CALL i002_fetch('F')                 
    END IF
   	
END FUNCTION	
	
FUNCTION i002_fetch(p_flag)                  
DEFINE   p_flag   LIKE type_file.chr1,         
         l_abso   LIKE type_file.num10         

   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     i002_curs INTO g_hrap01
      WHEN 'P' FETCH PREVIOUS i002_curs INTO g_hrap01
      WHEN 'F' FETCH FIRST    i002_curs INTO g_hrap01
      WHEN 'L' FETCH LAST     i002_curs INTO g_hrap01
      WHEN '/'
         IF (NOT g_no_ask) THEN          #No.FUN-6A0080
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
            PROMPT g_msg CLIPPED,': ' FOR g_jump
                ON IDLE g_idle_seconds
                   CALL cl_on_idle()

                ON ACTION controlp
                   CALL cl_cmdask()

                ON ACTION help
                   CALL cl_show_help()

                ON ACTION about
                   CALL cl_about()

            END PROMPT
            IF INT_FLAG THEN
               LET INT_FLAG = 0
               EXIT CASE
            END IF
         END IF
         FETCH ABSOLUTE g_jump i002_curs INTO g_hrap01
         LET g_no_ask = FALSE    #No.FUN-6A0080
   END CASE

   IF SQLCA.sqlcode THEN
      CALL cl_err(g_hrap01,SQLCA.sqlcode,0)
      INITIALIZE g_hrap01 TO NULL  #TQC-6B0i002
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump          
      END CASE
      
      #SELECT DISTINCT hrap02 INTO g_hrap02 FROM hrap_file WHERE hrap01=g_hrap01
      
      CALL cl_navigator_setting(g_curs_index, g_row_count)

      #CALL i002_show()
   END IF
   LET g_hrap02=''
   SELECT DISTINCT hrap02,hrap13,hrap14,hrap15 INTO g_hrap02,g_hrap13,g_hrap14,g_hrap15 FROM hrap_file WHERE hrap01=g_hrap01
   CALL i002_show()
END FUNCTION
	
FUNCTION i002_b_askkey()
    CLEAR FORM
    CALL g_hrap.clear()
  IF cl_null(g_argv1) THEN
    CONSTRUCT g_wc2 ON hrap01,hrap02,hrap04,hrap05,hrap06,hrap07,hrap08,hrap09,hrapacti                      
         FROM hrap01,hrap02,                                 
              s_hrap[1].hrap04,s_hrap[1].hrap05,s_hrap[1].hrap06,
              s_hrap[1].hrap07,s_hrap[1].hrap08,s_hrap[1].hrap09,s_hrap[1].hrapacti
              
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
      ON ACTION CONTROLP
         CASE 
               WHEN INFIELD(hrap01)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_hrao02"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO hrap01
               NEXT FIELD hrap01

               WHEN INFIELD(hrap05)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_hras01"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO hrap05
               NEXT FIELD hrap05
         OTHERWISE
              EXIT CASE
         END CASE

      ON ACTION ypzbm
         CALL cl_init_qry_var()
         LET g_qryparam.form  = "q_hrao02_1"
         LET g_qryparam.state = "c"
         LET g_qryparam.where =" hrao01 IN (SELECT hrap01 FROM hrap_file WHERE 1=1 )"
         CALL cl_create_qry() RETURNING g_qryparam.multiret
         DISPLAY g_qryparam.multiret TO hrap01
         NEXT FIELD hrap01

      ON ACTION wpzbm
         CALL cl_init_qry_var()
         LET g_qryparam.form  = "q_hrao02_1"
         LET g_qryparam.state = "c"
         LET g_qryparam.where =" hrao01 NOT IN (SELECT hrap01 FROM hrap_file WHERE 1=1 )"
         CALL cl_create_qry() RETURNING g_qryparam.multiret
         DISPLAY g_qryparam.multiret TO hrap01
         NEXT FIELD hrap01
 
      ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
    
      #No.FUN-580031 --start--
      ON ACTION qbe_select
         CALL cl_qbe_select()
      ON ACTION qbe_save
         CALL cl_qbe_save()
      #No.FUN-580031 ---end---
    END CONSTRUCT
 END IF  
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('hrapuser', 'hrapgrup') #FUN-980030
    IF INT_FLAG THEN RETURN END IF
              	 
END FUNCTION		
	
FUNCTION i002_b_fill(p_wc2)              #BODY FILL UP
 
    DEFINE p_wc2           STRING
       
       LET g_sql = "SELECT hrap04,hrap05,hrap06,hrap07,hrap08,hrap09,hrap10,hrap11,hrap12,hrapacti",
                   " FROM hrap_file",
                   " WHERE ", p_wc2 CLIPPED,
                   "   AND hrap01='",g_hrap01,"'", 
                   " ORDER BY hrap04" 
 
    PREPARE i002_pb FROM g_sql
    DECLARE hrap_curs CURSOR FOR i002_pb
 
    CALL g_hrap.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH hrap_curs INTO g_hrap[g_cnt].*   
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF   
         
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_hrap.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
END FUNCTION


FUNCTION i002_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680102 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
  # CALL cl_set_act_visible("insert",FALSE)
   DISPLAY ARRAY g_hrap TO s_hrap.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY 
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
     
      ON ACTION detail
         LET g_action_choice="detail"
         EXIT DISPLAY    
         
      ON ACTION accept
         LET g_action_choice="detail"
         EXIT DISPLAY   
      
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY   
      ON ACTION gx
         LET g_action_choice="gx"
         EXIT DISPLAY 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
         
      ON ACTION first                            
         CALL i002_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST

      ON ACTION previous                         
         CALL i002_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
        ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST

      ON ACTION jump                             
         CALL i002_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
        ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST

      ON ACTION next                             
         CALL i002_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
        ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST

      ON ACTION last                             
         CALL i002_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
        ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST   
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
   
      ON ACTION related_document  #No.MOD-470515
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel   #No.FUN-4B0020
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      ON ACTION ghr_import
         LET g_action_choice="ghr_import"
         EXIT DISPLAY
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION			
	
FUNCTION i002_show()                         
   DISPLAY g_hrap01 TO hrap01
   DISPLAY g_hrap02 TO hrap02 
   DISPLAY g_hrap13 TO hrap13 
   DISPLAY g_hrap14 TO hrap14 
   DISPLAY g_hrap15 TO hrap15
   
   CALL i002_b_fill(g_wc2)                    
   CALL cl_show_fld_cont()                   
END FUNCTION
	
FUNCTION i002_a()
DEFINE l_n    LIKE   type_file.num5                            
   MESSAGE ""
   CLEAR FORM
   CALL g_hrap.clear()
   INITIALIZE g_hrap01 TO NULL
   INITIALIZE g_hrap02 TO NULL

   CALL cl_opmsg('a')

   WHILE TRUE 
      LET g_hrap13 = 0     
      LET g_hrap14 = 0                
      LET g_hrap15 = 0 
      
      CALL i002_i("a")                       

      IF INT_FLAG THEN                            
         LET g_hrap01=NULL
         LET g_hrap02=NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      ELSE 
         LET g_rec_b=0
         LET l_n=0
         SELECT COUNT(*) INTO l_n FROM hrap_file WHERE hrap01=g_hrap01
         IF l_n>0 THEN
            CALL i002_b_fill(" 1=1")
         ELSE
            CALL g_hrap.clear()
         END IF    
         CALL i002_b()   	
      END IF
      	                    
      LET g_hrap01_t=g_hrap01
      LET g_hrap02_t=g_hrap02
      EXIT WHILE
   END WHILE
   		  	  	
END FUNCTION	
	
FUNCTION i002_i(p_cmd)                       
   DEFINE   p_cmd        LIKE type_file.chr1    
   DEFINE   l_count      LIKE type_file.num5  
   DEFINE   l_str        STRING 
   DEFINE   l_n,l_i      LIKE type_file.num5
   DEFINE   l_check      STRING
   DEFINE   l_date       LIKE type_file.chr10 

   DISPLAY g_hrap01,g_hrap02,g_hrap13,g_hrap14,g_hrap15 TO hrap01,hrap02,hrap13,hrap14,hrap15   
   CALL cl_set_head_visible("","YES")   
   INPUT g_hrap01,g_hrap02 WITHOUT DEFAULTS FROM hrap01,hrap02 
   
   AFTER FIELD hrap01
      IF NOT cl_null(g_hrap01) THEN
         LET l_count=0
         SELECT COUNT(*) INTO l_count FROM hrao_file WHERE hrao01=g_hrap01 AND hraoacti='Y'
         IF l_count=0 THEN
            CALL cl_err(g_hrap01,'ghr-009',0)
            NEXT FIELD hrap01
         END IF

      	 #LET l_count=0
      	 #SELECT COUNT(DISTINCT hrap01) INTO l_count FROM hrap_file WHERE hrap01=g_hrap01
      	 #IF l_count>0 THEN
      	 #	  CALL cl_err(g_hrap01,-239,1)
      	 #	  LET g_hrap01=g_hrap01_t
      	 #	  NEXT FIELD hrap01
      	 #END IF
      	 SELECT hrao02 INTO g_hrap02 FROM hrao_file WHERE hrao01=g_hrap01
      	 DISPLAY g_hrap02 TO hrap02       	  	
      END IF
      	
      AFTER INPUT 
         IF INT_FLAG THEN
            RETURN
         END IF
         IF g_hrap01 IS NULL THEN
         	  NEXT FIELD hrap01
         END IF
         	 		  	
      ON ACTION controlp
         CASE
             WHEN INFIELD(hrap01)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_hrao02"
             LET g_qryparam.default1 = g_hrap01
             CALL cl_create_qry() RETURNING g_hrap01
             DISPLAY g_hrap01 TO hrap01
             NEXT FIELD hrap01
         END CASE

      ON ACTION ypzbm
         CALL cl_init_qry_var()
         LET g_qryparam.form = "q_hrao02_1"
         LET g_qryparam.default1 = g_hrap01
         LET g_qryparam.where = " hrao01 IN (SELECT hrap01 FROM hrap_file WHERE 1=1 )"
         CALL cl_create_qry() RETURNING g_hrap01
         DISPLAY g_hrap01 TO hrap01
         NEXT FIELD hrap01

      ON ACTION wpzbm
         CALL cl_init_qry_var()
         LET g_qryparam.form = "q_hrao02_1"
         LET g_qryparam.default1 = g_hrap01
         LET g_qryparam.where = " hrao01 NOT IN (SELECT hrap01 FROM hrap_file WHERE 1=1 )"
         CALL cl_create_qry() RETURNING g_hrap01
         DISPLAY g_hrap01 TO hrap01
         NEXT FIELD hrap01
      		 		  
      ON ACTION controlf                  
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      ON ACTION about
         CALL cl_about()

      ON ACTION help
         CALL cl_show_help()

      ON ACTION controlg
         CALL cl_cmdask()


   END INPUT
END FUNCTION			
	
FUNCTION i002_r()        
   DEFINE   l_cnt   LIKE type_file.num5,          
            l_hrap   RECORD LIKE hrap_file.*

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_hrap01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
     	
   BEGIN WORK
   IF cl_delh(0,0) THEN                   
      DELETE FROM hrap_file
       WHERE hrap01 = g_hrap01 
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","hrap_file",g_hrap01,g_hrap02,SQLCA.sqlcode,"","BODY DELETE",0)   #No.FUN-660081
      ELSE      
         CALL g_hrap.clear()
         OPEN i002_count
         FETCH i002_count INTO g_row_count
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i002_curs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i002_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET g_no_ask = TRUE           #No.FUN-6A0080
            CALL i002_fetch('/')
         END IF
      END IF
   END IF
   COMMIT WORK
END FUNCTION	
	
FUNCTION i002_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                 
    l_n             LIKE type_file.num5,                 
    l_lock_sw       LIKE type_file.chr1,                 
    p_cmd           LIKE type_file.chr1,                 
    l_allow_insert  LIKE type_file.chr1,                 
    l_allow_delete  LIKE type_file.chr1,
    l_hrap10        LIKE hrap_file.hrap10  
    
    LET g_action_choice=NULL   
    IF cl_null(g_hrap01) THEN
       CALL cl_err('',-400,1)
       RETURN
    END IF

    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET g_action_choice = ""
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    LET g_forupd_sql = "SELECT hrap04,hrap05,hrap06,hrap07,hrap08,hrap09,hrap10,hrap11,hrap12,hrapacti",  
                       "  FROM hrap_file WHERE hrap01=? AND hrap05=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i002_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
    
    WHILE TRUE 
       INPUT ARRAY g_hrap WITHOUT DEFAULTS FROM s_hrap.*
             ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert) 
 
       BEFORE INPUT
          IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(l_ac)
          END IF
          CALL cl_set_comp_entry("hrap11,hrap12",FALSE)		
       	
       BEFORE ROW
          LET p_cmd='' 
          LET l_ac = ARR_CURR()
          LET l_lock_sw = 'N'            #DEFAULT
          LET l_n  = ARR_COUNT()
 
          IF g_rec_b>=l_ac THEN
             BEGIN WORK
             LET p_cmd='u'
#No.FUN-570110 --start                                                          
             LET g_before_input_done = FALSE                                                                              
             LET g_before_input_done = TRUE                                       
#No.FUN-570110 --end              
             LET g_hrap_t.* = g_hrap[l_ac].*  #BACKUP
             OPEN i002_bcl USING g_hrap01,g_hrap_t.hrap05
             IF STATUS THEN
                CALL cl_err("OPEN i002_bcl:", STATUS, 1)
                LET l_lock_sw = "Y"
             ELSE 
                FETCH i002_bcl INTO g_hrap[l_ac].* 
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_hrap_t.hrap05,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                END IF
             END IF
             CALL cl_show_fld_cont()     #FUN-550037(smin)
          END IF 
        	
       BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
#No.FUN-570110 --start                                                          
           LET g_before_input_done = FALSE                                                                                  
           LET g_before_input_done = TRUE                                         
#No.FUN-570110 --end 
           INITIALIZE g_hrap[l_ac].* TO NULL      #900423  
           LET g_hrap[l_ac].hrapacti = 'Y'       #Body default
           LET g_hrap[l_ac].hrap07='N'
           LET g_hrap[l_ac].hrap08='Y'
           LET g_hrap[l_ac].hrap10=0
           LET g_hrap[l_ac].hrap11=0
           LET g_hrap[l_ac].hrap12=0
           LET g_hrap_t.* = g_hrap[l_ac].*         
           CALL cl_show_fld_cont()     #FUN-550037(smin)
           NEXT FIELD hrap04 
         
       AFTER INSERT
           DISPLAY "AFTER INSERT" 
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CLOSE i002_bcl
              CANCEL INSERT
           END IF
 
           BEGIN WORK                    #FUN-680010
 
           INSERT INTO hrap_file(hrap01,hrap02,hrap03,hrap04,hrap05,hrap06,hrap07,hrap08,hrap09,                          #FUN-A30097
                                 hrapacti,hrapuser,hrapdate,hrapgrup,hraporiu,hraporig,hrap10,hrap11,hrap12,hrap13,hrap14,hrap15)           #FUN-A30030 ADD POS  #FUN-A80148--mod--    
                  VALUES(g_hrap01,g_hrap02,g_hrap03,
                  g_hrap[l_ac].hrap04,g_hrap[l_ac].hrap05,g_hrap[l_ac].hrap06,                      #FUN-A30097                                        #FUN-A80148--mark--
                  g_hrap[l_ac].hrap07,g_hrap[l_ac].hrap08,g_hrap[l_ac].hrap09,
                  g_hrap[l_ac].hrapacti,g_user,g_today,g_grup,g_user,g_grup,g_hrap[l_ac].hrap10,g_hrap[l_ac].hrap11,g_hrap[l_ac].hrap12,g_hrap13,g_hrap14,g_hrap15) #FUN-A30030 ADD POS   #No.FUN-980030 10/01/04  insert columns oriu, orig
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","hrap_file",g_hrap01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
              ROLLBACK WORK              #FUN-680010
              CANCEL INSERT
           ELSE  
              LET g_rec_b=g_rec_b+1    
              DISPLAY g_rec_b TO FORMONLY.cn2     
              COMMIT WORK  
           END IF        	  	
        
        BEFORE FIELD hrap04
           IF cl_null(g_hrap[l_ac].hrap04) THEN
           	  SELECT MAX(hrap04)+1 INTO g_hrap[l_ac].hrap04 
           	    FROM hrap_file WHERE hrap01=g_hrap01
           	  IF cl_null(g_hrap[l_ac].hrap04) THEN
           	  	 LET g_hrap[l_ac].hrap04=1
           	  END IF
           END IF	
           	  		     	
        AFTER FIELD hrap04                        
           IF NOT cl_null(g_hrap[l_ac].hrap04) THEN       	 	  	                                            
              IF g_hrap[l_ac].hrap04 != g_hrap_t.hrap04 OR
                 g_hrap_t.hrap04 IS NULL THEN
                 LET l_n=0
                 SELECT COUNT(*) INTO l_n FROM hrap_file
                  WHERE hrap01 = g_hrap01
                    AND hrap04 = g_hrap[l_ac].hrap04
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_hrap[l_ac].hrap04 = g_hrap_t.hrap04
                    NEXT FIELD hrap04
                 END IF                                            	
              END IF
       	   END IF
       	   	
        AFTER FIELD hrap05
          IF NOT cl_null(g_hrap[l_ac].hrap05) THEN
          	 LET l_n=0
          	 SELECT COUNT(*) INTO l_n FROM hras_file WHERE hras01=g_hrap[l_ac].hrap05
          	                                           AND hrasacti='Y'
          	 IF l_n=0 THEN
          	 	  CALL cl_err(g_hrap[l_ac].hrap05,'ghr-010',0)
          	 	  NEXT FIELD hrap05
          	 END IF
          	 		                                            
             IF g_hrap[l_ac].hrap05 != g_hrap_t.hrap05 OR
                g_hrap_t.hrap05 IS NULL THEN
                LET l_n=0
                SELECT COUNT(*) INTO l_n FROM hrap_file
                 WHERE hrap01 = g_hrap01
                   AND hrap05 = g_hrap[l_ac].hrap05
                IF l_n > 0 THEN
                   CALL cl_err('',-239,0)
                   LET g_hrap[l_ac].hrap05 = g_hrap_t.hrap05
                   NEXT FIELD hrap05
                END IF
             END IF   
             SELECT hras04 INTO g_hrap[l_ac].hrap06 FROM hras_file 
              WHERE hras01=g_hrap[l_ac].hrap05
             DISPLAY BY NAME g_hrap[l_ac].hrap06 		     
          END IF
       	
        AFTER FIELD hrap07                        
           IF NOT cl_null(g_hrap[l_ac].hrap07) THEN
              IF g_hrap[l_ac].hrap07 NOT MATCHES '[YN]' THEN 
                 LET g_hrap[l_ac].hrap07 = g_hrap_t.hrap07
                 NEXT FIELD hrap04
              END IF
              
              IF g_hrap[l_ac].hrap07 != g_hrap_t.hrap07 OR
                g_hrap_t.hrap07 IS NULL THEN
                IF g_hrap[l_ac].hrap07='Y' THEN
                	 LET l_n=0
                	 SELECT COUNT(*) INTO l_n FROM hrap_file 
                	  WHERE hrap01=g_hrap01
                	    AND hrap07=g_hrap[l_ac].hrap07
                	 IF l_n>1 THEN
                	 	  CALL cl_err(g_hrap[l_ac].hrap07,'ghr-011',0)
                	 	  LET g_hrap[l_ac].hrap07=g_hrap_t.hrap07                                            
              	      NEXT FIELD hrap07
              	   END IF
              	END IF  
              END IF 			   
           END IF
        
        AFTER FIELD hrap09
           IF NOT cl_null(g_hrap[l_ac].hrap09) THEN
           	  IF g_hrap[l_ac].hrap09=g_hrap_t.hrap05 THEN
           	  	 CALL cl_err(g_hrap[l_ac].hrap09,'ghr-012',0)
           	  	 NEXT FIELD hrap09
           	  END IF	 
           	  	
           	  LET l_n=0
           	  SELECT COUNT(*) INTO l_n FROM hrap_file WHERE hrap01=g_hrap01
           	                                            AND hrap05=g_hrap[l_ac].hrap09
           	  IF l_n=0 THEN
           	  	 CALL cl_err(g_hrap[l_ac].hrap09,'ghr-013',0)
           	  	 NEXT FIELD hrap09
           	  END IF
           END IF
           		  		                                            
        AFTER FIELD hrapacti
           IF NOT cl_null(g_hrap[l_ac].hrapacti) THEN
              IF g_hrap[l_ac].hrapacti NOT MATCHES '[YN]' THEN 
                 LET g_hrap[l_ac].hrapacti = g_hrap_t.hrapacti
                 NEXT FIELD hrapacti
              END IF
           END IF 
         	
        BEFORE DELETE                           
           IF g_hrap_t.hrap05 IS NOT NULL THEN
              IF NOT cl_delete() THEN
                 ROLLBACK WORK      #FUN-680010
                 CANCEL DELETE
              END IF
              INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
              LET g_doc.column1 = "hrap01"               #No.FUN-9B0098 10/02/24
              LET g_doc.value1 = g_hrap01      #No.FUN-9B0098 10/02/24
              CALL cl_del_doc()                                          #No.FUN-9B0098 10/02/24
              IF l_lock_sw = "Y" THEN 
                 CALL cl_err("", -263, 1) 
                 ROLLBACK WORK      #FUN-680010
                 CANCEL DELETE 
              END IF 
           
              DELETE FROM hrap_file WHERE hrap01 = g_hrap01
                                      AND hrap05 = g_hrap_t.hrap05
            
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","hrap_file",g_hrap01,g_hrap_t.hrap05,SQLCA.sqlcode,"","",1)  #No.FUN-660131
                 ROLLBACK WORK      #FUN-680010
                 CANCEL DELETE
                 EXIT INPUT
              ELSE
                 LET g_rec_b=g_rec_b-1
                 DISPLAY g_rec_b TO cn2
              END IF
      
           END IF
         	
        ON ROW CHANGE
           IF INT_FLAG THEN             
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_hrap[l_ac].* = g_hrap_t.*
              CLOSE i002_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw="Y" THEN
              CALL cl_err(g_hrap[l_ac].hrap05,-263,0)
              LET g_hrap[l_ac].* = g_hrap_t.*
           ELSE
            
             #FUN-A30030 END--------------------
              UPDATE hrap_file SET hrap04=g_hrap[l_ac].hrap04,
                                   hrap05=g_hrap[l_ac].hrap05,
                                   hrap06=g_hrap[l_ac].hrap06,
                                   hrap07=g_hrap[l_ac].hrap07,
                                   hrap08=g_hrap[l_ac].hrap08,
                                   hrap09=g_hrap[l_ac].hrap09, 
                                   hrap10=g_hrap[l_ac].hrap10,    
                                   hrapacti=g_hrap[l_ac].hrapacti,
                                   hrapmodu=g_user,
                                   hrapdate=g_today
                             WHERE hrap01 = g_hrap01
                               AND hrap05 = g_hrap_t.hrap05
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","hrap_file",g_hrap01,g_hrap_t.hrap05,SQLCA.sqlcode,"","",1)  #No.FUN-660131
                 ROLLBACK WORK    #FUN-680010
                 LET g_hrap[l_ac].* = g_hrap_t.*
              END IF
           END IF   
         
          		   	    	
         AFTER ROW
            LET l_ac = ARR_CURR()            
            LET l_ac_t = l_ac                
         
            IF INT_FLAG THEN                 #900423
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_hrap[l_ac].* = g_hrap_t.*
               END IF
               CLOSE i002_bcl                
               ROLLBACK WORK                 
               EXIT INPUT
            END IF
            CLOSE i002_bcl                
            COMMIT WORK      
         
         
         ON ACTION controlp
            CASE
            	 WHEN INFIELD(hrap05)
                    IF p_cmd='a' THEN
            	       CALL i002_gen()
                       EXIT INPUT
                    ELSE
                       CALL cl_init_qry_var()
                       LET g_qryparam.form ="q_hras01"
                       LET g_qryparam.default1 = g_hrap[l_ac].hrap05
                       CALL cl_create_qry() RETURNING g_hrap[l_ac].hrap05
                       DISPLAY BY NAME g_hrap[l_ac].hrap05
                       NEXT FIELD hrap05
                    END IF
                       
            END CASE
            		    
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
      
         ON ACTION CONTROLG
            CALL cl_cmdask()
      
         ON ACTION CONTROLF
            CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
            CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
            
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
      
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
      
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
      
       END INPUT
       LET l_n=0 
       SELECT COUNT(*) INTO l_n FROM hrap_file WHERE hrap01=g_hrap01
       IF l_n>0 THEN
          LET l_n=0 
          SELECT COUNT(*) INTO l_n FROM hrap_file WHERE hrap01=g_hrap01
                                                    AND hrap07='Y'
          IF l_n != 1 THEN   
       	     IF cl_confirm('主职位不为1笔,是否退出删除该部门下所有资料,重新录入!') THEN
       	    	 DELETE FROM hrap_file WHERE hrap01=g_hrap01
       	  	 #LET g_hrap01=''
                 #LET g_hrap02=''
       	  	 EXIT WHILE
       	     ELSE
       	      	 CONTINUE WHILE
       	     END IF
          ELSE
             EXIT WHILE
          END IF
       ELSE
          EXIT WHILE
       END IF
       		  	 	 	 	 	                                                 
    END WHILE    
  
    CLOSE i002_bcl
    COMMIT WORK
    SELECT SUM(hrap10) INTO l_hrap10 FROM hrap_file WHERE hrap01 = g_hrap01
    UPDATE hrap_file SET  hrap13 = l_hrap10  WHERE hrap01 = g_hrap01 
    DISPLAY l_hrap10 TO hrap13
    CALL i002_b_fill(" 1=1")
END FUNCTION	
	
FUNCTION i002_gen()
DEFINE   l_sql      STRING
DEFINE   i          LIKE   type_file.num5
DEFINE   gs_wc      STRING
DEFINE   l_hrap     RECORD LIKE hrap_file.*
DEFINE   lc_qbe_sn  LIKE gbm_file.gbm01
DEFINE   l_hras   DYNAMIC ARRAY OF RECORD
            sel      LIKE type_file.chr1,
            hras01   LIKE hras_file.hras01,
            hras02   LIKE hras_file.hras02,
            hras03   LIKE hras_file.hras03,
            hras04   LIKE hras_file.hras04,
            hras05   LIKE hras_file.hras05
                 END RECORD
DEFINE   p_row,p_col  LIKE type_file.num5
DEFINE l_allow_insert  LIKE type_file.num5
DEFINE l_allow_deLETe  LIKE type_file.num5	
DEFINE l_check         LIKE type_file.chr1
			 
			 DROP TABLE hrap_tmp
   		 
   		 SELECT hras01,hras02,hras03,hras04,hras05 FROM hras_file
   		  WHERE hras01 NOT IN (SELECT hrap05 FROM hrap_file WHERE hrap01=g_hrap01)
   		 INTO TEMP hrap_tmp
   		 
   		 IF STATUS THEN CALL cl_err('ins hrap_tmp:',STATUS,1) RETURN END IF 
   		 	
   		 LET p_row=3   LET p_col=6

       OPEN WINDOW i002_m_w AT p_row,p_col WITH FORM "ghr/42f/ghri002_m"
              ATTRIBUTE (STYLE = g_win_style CLIPPED)
      CALL cl_ui_locale("ghri002_m")

      WHILE TRUE
      LET l_check='N'
      CLEAR FORM

      CONSTRUCT gs_wc ON hras01,hras02,hras03,hras04,hras05
           FROM s_hrap_m[1].hras01,s_hrap_m[1].hras02,s_hrap_m[1].hras03,
                s_hrap_m[1].hras04,s_hrap_m[1].hras05

      BEFORE CONSTRUCT
           CALL cl_qbe_display_condition(lc_qbe_sn)
           
           

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
          
       ON ACTION controlp
          CASE
          	 WHEN INFIELD(hras02)
          	 LET g_qryparam.form = "q_hraa01"
             LET g_qryparam.state = "c"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO hras02
             NEXT FIELD hras02
          END CASE      

       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121

       ON ACTION help          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121

       ON ACTION controlg      #MOD-4C0121
          CALL cl_cmdask()

     END CONSTRUCT

     IF INT_FLAG THEN
         LET INT_FLAG=0
         DELETE FROM hrap_tmp
         CLOSE WINDOW i002_m_w
         RETURN
     END IF	
     	
     LET l_sql=" SELECT 'N',hras01,hras02,hras03,hras04,hras05 ",
               "   FROM hrap_tmp ",
               "  WHERE ",gs_wc CLIPPED,
               "  ORDER BY hras01,hras02"


      PREPARE i002_m_pre FROM l_sql
      DECLARE i002_m_cs CURSOR FOR i002_m_pre

      LET i=1
      CALL l_hras.clear()
      FOREACH i002_m_cs INTO l_hras[i].*

        LET i=i+1

      END FOREACH
      
      CALL l_hras.deLETeElement(i)
      LET i=i-1

      INPUT ARRAY l_hras WITHOUT DEFAULTS FROM s_hrap_m.*
            ATTRIBUTE(COUNT=i,MAXCOUNT=i,UNBUFFERED,
                      INSERT ROW=l_allow_insert,DELETE ROW=l_allow_deLETe,APPEND ROW=l_allow_insert)

      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
         FOR g_cnt=1 TO i
            IF l_hras[g_cnt].sel='Y' AND l_hras[g_cnt].sel IS NOT NULL
               AND l_hras[g_cnt].sel <>' ' THEN
               CONTINUE FOR
            END IF
            IF l_hras[g_cnt].hras01 IS NULL THEN CONTINUE FOR END IF

            DELETE FROM hrap_tmp WHERE hras01=l_hras[g_cnt].hras01

         END FOR

      ON ACTION reconstruct
         LET l_check='Y'
         EXIT INPUT

      END INPUT

      IF l_check='Y' THEN
         CALL l_hras.clear()
         CONTINUE WHILE
      ELSE
         EXIT WHILE
      END IF

      END WHILE
      
      IF INT_FLAG THEN 
         LET INT_FLAG=0
         #CLOSE WINDOW i002_m_w
         #RETURN 
         DELETE FROM hrap_tmp
      END IF

      CLOSE WINDOW i002_m_w

      LET l_sql="  SELECT hras01,hras02,hras04 ",
                "  FROM hrap_tmp ",
                "  WHERE ",gs_wc CLIPPED,
                " ORDER BY hras01,hras02"

      PREPARE i002_m_pre2 FROM l_sql
      DECLARE i002_m_ins CURSOR FOR i002_m_pre2

      FOREACH i002_m_ins INTO l_hrap.hrap05,l_hrap.hrap03,l_hrap.hrap06

         LET l_hrap.hrap01=g_hrap01
         LET l_hrap.hrap02=g_hrap02
         SELECT MAX(hrap04)+1 INTO l_hrap.hrap04 FROM hrap_file
          WHERE hrap01=l_hrap.hrap01
         IF cl_null(l_hrap.hrap04) THEN LET l_hrap.hrap04=1 END IF
         LET l_hrap.hrap07='N'
         LET l_hrap.hrap08='Y'
         LET l_hrap.hrapacti='Y'
         LET l_hrap.hrapuser=g_user
         LET l_hrap.hrapgrup=g_grup
         LET l_hrap.hraporiu=g_user
         LET l_hrap.hraporig=g_grup
         
         INSERT INTO hrap_file VALUES (l_hrap.*)

      END FOREACH

      DROP TABLE hrap_tmp
     
      CALL i002_b_fill(" 1=1")
      CALL i002_b() 
END FUNCTION	
#--->No:100823 begin <---shenran-----
#=================================================================#
# Function name...: i002_import()
# Descriptions...: 打开文件选择窗口允许用户打开本地TXT，EXCEL文件并
# ...............  导入数据到dateBase中
# Input parameter: p_argv1 文件类型 0-TXT 1-EXCEL
# RETURN code....: 'Y' FOR TRUE  : 数据操作成功
#                  'N' FOR FALSE : 数据操作失败
# Date & Author..: 131022 shenran 
#=================================================================#
FUNCTION i002_import()
DEFINE l_file   LIKE  type_file.chr200,
       l_filename LIKE type_file.chr200,
       l_sql    STRING,
       l_data   VARCHAR(300),
       l_hrap04 LIKE hrap_file.hrap04,
       p_argv1  LIKE type_file.num5
DEFINE l_count  LIKE type_file.num5,
       m_tempdir  VARCHAR(240) ,
       m_file     VARCHAR(256) ,
       sr     RECORD    
         hrap03  LIKE hrap_file.hrap03,
         hrap01  LIKE hrap_file.hrap01,
         hrap02  LIKE hrap_file.hrap02,
         hrap05  LIKE hrap_file.hrap05,
         hrap06  LIKE hrap_file.hrap06,
         hrap07  LIKE hrap_file.hrap07,
         hrap08  LIKE hrap_file.hrap08
              END RECORD      
DEFINE    l_tok       base.stringTokenizer 
DEFINE xlapp,iRes,iRow,i,j     INTEGER
DEFINE li_k ,li_i_r   LIKE  type_file.num5
DEFINE l_n     LIKE type_file.num5
DEFINE l_racacti     LIKE rac_file.racacti
DEFINE    l_imaacti  LIKE ima_file.imaacti, 
          l_ima02    LIKE ima_file.ima02,
          l_ima25    LIKE ima_file.ima25

DEFINE    l_obaacti  LIKE oba_file.obaacti,
          l_oba02    LIKE oba_file.oba02

DEFINE    l_tqaacti  LIKE tqa_file.tqaacti,
          l_tqa02    LIKE tqa_file.tqa02,
          l_tqa05    LIKE tqa_file.tqa05,
          l_tqa06    LIKE tqa_file.tqa06
DEFINE l_gfe02     LIKE gfe_file.gfe02
DEFINE l_gfeacti   LIKE gfe_file.gfeacti
DEFINE    l_flag    LIKE type_file.num5,
          l_fac     LIKE ima_file.ima31_fac 

   LET g_errno = ' '
   LET l_n=0
   CALL s_showmsg_init() #初始化
   
   LET l_file = cl_browse_file() 
   LET l_file = l_file CLIPPED
   MESSAGE l_file
   IF NOT cl_null(l_file) THEN 
       LET l_count =  LENGTH(l_file)
          IF l_count = 0 THEN  
             LET g_success = 'N'
             RETURN 
          END IF 
       INITIALIZE sr.* TO NULL
       LET li_k = 1
       LET li_i_r = 1
       LET g_cnt = 1 
       LET l_sql = l_file
     
       CALL ui.interface.frontCall('WinCOM','CreateInstance',
                                   ['Excel.Application'],[xlApp])
       IF xlApp <> -1 THEN
          LET l_file = "C:\\Users\\dcms1\\Desktop\\import.xls"
          CALL ui.interface.frontCall('WinCOM','CallMethod',
                                      [xlApp,'WorkBooks.Open',l_sql],[iRes])
                                    # [xlApp,'WorkBooks.Open',"C:/Users/dcms1/Desktop/import.xls"],[iRes]) 

          IF iRes <> -1 THEN
             CALL ui.interface.frontCall('WinCOM','GetProperty',
                  [xlApp,'ActiveSheet.UsedRange.Rows.Count'],[iRow])
             IF iRow > 0 THEN  
                LET g_success = 'Y'
                BEGIN WORK  
              # CALL s_errmsg_init()
                CALL s_showmsg_init()
                FOR i = 1 TO iRow                                                                                           
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',1).Value'],[sr.hrap03])
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',3).Value'],[sr.hrap01])
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',4).Value'],[sr.hrap02])
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',5).Value'],[sr.hrap05])
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',6).Value'],[sr.hrap06])
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',7).Value'],[sr.hrap07])
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',8).Value'],[sr.hrap08])
                IF NOT cl_null(sr.hrap03) AND NOT cl_null(sr.hrap01) AND NOT cl_null(sr.hrap02) 
                	 AND NOT cl_null(sr.hrap05) AND NOT cl_null(sr.hrap06) AND NOT cl_null(sr.hrap07) AND NOT cl_null(sr.hrap08) THEN 
                	  SELECT MAX(hrap04)+1 INTO l_hrap04 
           	           FROM hrap_file WHERE hrap01=sr.hrap01
           	        IF cl_null(l_hrap04) THEN
           	  	      LET l_hrap04=1
           	        END IF
           	        IF i > 1 THEN
                     INSERT INTO hrap_file(hrap03,hrap01,hrap02,hrap04,hrap05,hrap06,hrap07,hrap08,hrapacti,hrapuser,hrapgrup,hrapdate,hraporig,hraporiu)
                       VALUES (sr.hrap03,sr.hrap01,sr.hrap02,l_hrap04,sr.hrap05,sr.hrap06,sr.hrap07,sr.hrap08,'Y',g_user,g_grup,g_today,g_grup,g_user)
                     IF SQLCA.sqlcode THEN 
                       CALL cl_err3("ins","hrap_file",sr.hrap01,'',SQLCA.sqlcode,"","",1)   
                        LET g_success  = 'N'
                        CONTINUE FOR 
                     END IF 
                    END IF 
                END IF 
                   #LET i = i + 1
                  # LET l_ac = g_cnt 
                                
                END FOR 
                IF g_success = 'N' THEN 
                   ROLLBACK WORK 
                   CALL s_showmsg() 
                ELSE IF g_success = 'Y' THEN 
                        COMMIT WORK 
                        CALL cl_err( '导入成功','!', 1 )
                     END IF 
                END IF 
            END IF
          ELSE 
              DISPLAY 'NO FILE'
          END IF
       ELSE
       	  DISPLAY 'NO EXCEL'
       END IF     
       CALL ui.interface.frontCall('WinCOM','CallMethod',[xlApp,'Quit'],[iRes])
       CALL ui.interface.frontCall('WinCOM','ReleaseInstance',[xlApp],[iRes]) 
       LET g_hrap01=sr.hrap01
       SELECT DISTINCT hrap02 INTO g_hrap02 FROM hrap_file WHERE hrap01=g_hrap01
       LET g_wc2='1=1'
       CALL i002_show()
   END IF 

END FUNCTION 
#TQC-AC0326 add --------------------end-----------------------
#add by zhuzw 20140627 start
FUNCTION i002_gx()
DEFINE l_sql STRING
DEFINE l_hrat04    LIKE  hrat_file.hrat04
DEFINE l_hrat05    LIKE  hrat_file.hrat05
DEFINE l_hrat09    LIKE  hrat_file.hrat09 
   UPDATE  hrap_file SET hrap11=0,hrap12=0
   LET l_sql = " SELECT hrat04,hrat05,hrat09  FROM hrat_file,hrad_file ",
               "  WHERE hrad02=hrat19 AND hrad01<>'003' AND hratconf = 'Y' "
   PREPARE i002_ud  FROM l_sql
   DECLARE i002_ud_s CURSOR FOR  i002_ud      
   FOREACH i002_ud_s INTO l_hrat04,l_hrat05,l_hrat09
      IF l_hrat09 = 'Y' THEN 
         UPDATE hrap_file SET hrap11 = hrap11+1,
                              hrap12 = hrap12+1
          WHERE hrap01 = l_hrat04
            AND hrap05 = l_hrat05                                                  
      ELSE 
         UPDATE hrap_file SET 
                              hrap12 = hrap12+1
          WHERE hrap01 = l_hrat04
            AND hrap05 = l_hrat05
    	END IF 
   END FOREACH  
   LET l_sql = " UPDATE  hrap_file a SET  (hrap13,hrap14,hrap15) = (SELECT SUM(hrap10), SUM(hrap11),SUM(hrap12) FROM hrap_file b WHERE  a.hrap01 = b.hrap01)"
   PREPARE i002_up_hrap FROM l_sql
   EXECUTE i002_up_hrap
   CALL cl_err('','ghr-262',1)     
END FUNCTION 
#add by zhuzw 20140627 end 
