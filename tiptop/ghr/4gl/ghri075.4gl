# Prog. Version..: '5.30.03-12.09.18(00010)'     #
#
# Pattern name...: ghri075.4gl
# Descriptions...: 班次变更作业
# Date & Author..: 13/07/30 By ye'anping

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE  g_hrdg_t_t     RECORD LIKE hrdg_file.*
DEFINE 
     g_hrdg          DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        sure         LIKE type_file.chr1,
        hrdg01       LIKE hrdg_file.hrdg01,
        hrdg03       LIKE hrdg_file.hrdg03,   #工号
        hrat02       LIKE hrat_file.hrat02,   #姓名
        hrat04       LIKE hrat_file.hrat04,   #部门
        hrat05       LIKE hrat_file.hrat05, 
        hrat25       LIKE hrat_file.hrat25,
      #  hrat19       LIKE hrat_file.hrat19,
        hrat19       LIKE type_file.chr100,
        hrdg02       LIKE hrdg_file.hrdg02,              #No.FUN-680102 VARCHAR(20),              # Modify by Raymon because of "Combo box"
        hrdg04       LIKE hrdg_file.hrdg04, #FUN-670032
        hrdg04_name  LIKE type_file.chr100, #FUN-670032
        hrdg05       LIKE hrdg_file.hrdg05, #FUN-670032
        hrbo15       LIKE hrbo_file.hrbo15, #FUN-670032
        hrdg06       LIKE hrdg_file.hrdg06, #FUN-870100 #FUN-A30097 mark
        hrdg06_name  LIKE type_file.chr100, #FUN-870100 #FUN-A30097 mark
        hrdg07       LIKE hrdg_file.hrdg07,             #No.FUN-680102
        hrbo15_1     LIKE hrbo_file.hrbo15,
        hrdg08       LIKE hrdg_file.hrdg08,
        hrdg09       LIKE hrdg_file.hrdg09
                    END RECORD,
    g_hrdg_t         RECORD                 #程式變數 (舊值)
        sure         LIKE type_file.chr1,
        hrdg01       LIKE hrdg_file.hrdg01,
        hrdg03       LIKE hrdg_file.hrdg03,   #工号
        hrat02       LIKE hrat_file.hrat02,   #姓名
        hrat04       LIKE hrat_file.hrat04,   #部门
        hrat05       LIKE hrat_file.hrat05, 
        hrat25       LIKE hrat_file.hrat25,
      #  hrat19       LIKE hrat_file.hrat19,
        hrat19       LIKE type_file.chr100,
        hrdg02       LIKE hrdg_file.hrdg02,              #No.FUN-680102 VARCHAR(20),              # Modify by Raymon because of "Combo box"
        hrdg04       LIKE hrdg_file.hrdg04, #FUN-670032
        hrdg04_name  LIKE type_file.chr100, #FUN-670032
        hrdg05       LIKE hrdg_file.hrdg05, #FUN-670032\
        hrbo15       LIKE hrbo_file.hrbo15,
        hrdg06       LIKE hrdg_file.hrdg06, #FUN-870100 #FUN-A30097 mark
        hrdg06_name  LIKE type_file.chr100, #FUN-870100 #FUN-A30097 mark
        hrdg07       LIKE hrdg_file.hrdg07,             #No.FUN-680102 VARCHAR(1) 
        hrbo15_1     LIKE hrbo_file.hrbo15,
        hrdg08       LIKE hrdg_file.hrdg08,
        hrdg09       LIKE hrdg_file.hrdg09
                    END RECORD,
     g_hrdg_tt       DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        sure         LIKE type_file.chr1,
        hrdg01       LIKE hrdg_file.hrdg01
#       ,hrdg03       LIKE hrdg_file.hrdg03,   #工号
#        hrat02       LIKE hrat_file.hrat02,   #姓名
#        hrat04       LIKE hrat_file.hrat04,   #部门
#        hrat05       LIKE hrat_file.hrat05, 
#        hrat25       LIKE hrat_file.hrat25,
#        hrat19       LIKE hrat_file.hrat19,
#        hrdg02       LIKE hrdg_file.hrdg02,              #No.FUN-680102 VARCHAR(20),              # Modify by Raymon because of "Combo box"
#        hrdg04       LIKE hrdg_file.hrdg04, #FUN-670032
#        hrdg04_name  LIKE type_file.chr100, #FUN-670032
#        hrdg05       LIKE hrdg_file.hrdg05, #FUN-670032
#        hrbo15       LIKE hrbo_file.hrbo15, #FUN-670032
#        hrdg06       LIKE hrdg_file.hrdg06, #FUN-870100 #FUN-A30097 mark
#        hrdg06_name  LIKE type_file.chr100, #FUN-870100 #FUN-A30097 mark
#        hrdg07       LIKE hrdg_file.hrdg07,             #No.FUN-680102 VARCHAR(1) 
#        hrbo15_1     LIKE hrbo_file.hrbo15,
#        hrdg08       LIKE hrdg_file.hrdg08,
#        hrdg09       LIKE hrdg_file.hrdg09
                    END RECORD,
     g_hrdg_1        DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        sure         LIKE type_file.chr1,
        hrdg01       LIKE hrdg_file.hrdg01,
        hrdg03       LIKE hrdg_file.hrdg03,   #工号
        hrat02       LIKE hrat_file.hrat02,   #姓名
        hrdg02       LIKE hrdg_file.hrdg02,              #No.FUN-680102 VARCHAR(20),              # Modify by Raymon because of "Combo box"
        hrdg04       LIKE hrdg_file.hrdg04, #FUN-670032
        hrdg04_name  LIKE type_file.chr100, #FUN-670032
        hrdg05       LIKE hrdg_file.hrdg05, #FUN-670032
        hrbo15_1     LIKE hrbo_file.hrbo15,
        hrdg06       LIKE hrdg_file.hrdg06,
        hrdg06_name  LIKE type_file.chr100,
        hrdg07       LIKE hrdg_file.hrdg07,
        hrbo15_2     LIKE hrbo_file.hrbo15,
        hrdg08       LIKE hrdg_file.hrdg08,
        hrat04       LIKE hrat_file.hrat04,   #部门
        hrat05       LIKE hrat_file.hrat05, 
        hrat25       LIKE hrat_file.hrat25,
      #  hrat19       LIKE hrat_file.hrat19,
        hrat19       LIKE type_file.chr100
                    END RECORD,
    g_hrdg_1_t       DYNAMIC ARRAY OF RECORD                 #程式變數 (舊值)
        sure         LIKE type_file.chr1,
        hrdg01       LIKE hrdg_file.hrdg01,
        hrdg03       LIKE hrdg_file.hrdg03,   #工号
        hrat02       LIKE hrat_file.hrat02,   #姓名
        hrdg02       LIKE hrdg_file.hrdg02,              #No.FUN-680102 VARCHAR(20),              # Modify by Raymon because of "Combo box"
        hrdg04       LIKE hrdg_file.hrdg04, #FUN-670032
        hrdg04_name  LIKE type_file.chr100, #FUN-670032
        hrdg05       LIKE hrdg_file.hrdg05, #FUN-670032
        hrbo15_1     LIKE hrbo_file.hrbo15,
        hrdg06       LIKE hrdg_file.hrdg06,
        hrdg06_name  LIKE type_file.chr100,
        hrdg07       LIKE hrdg_file.hrdg07,
        hrbo15_2     LIKE hrbo_file.hrbo15,
        hrdg08       LIKE hrdg_file.hrdg08,
        hrat04       LIKE hrat_file.hrat04,   #部门
        hrat05       LIKE hrat_file.hrat05, 
        hrat25       LIKE hrat_file.hrat25,
      #  hrat19       LIKE hrat_file.hrat19,
        hrat19       LIKE type_file.chr100
                    END RECORD,
    g_wc2,g_sql     STRING,                           #No.FUN-580092 HCN
    g_rec_b         LIKE type_file.num5,              #單身筆數  #No.FUN-680102 SMALLINT
    l_ac            LIKE type_file.num5,              #目前處理的ARRAY CNT  #No.FUN-680102 SMALLINT
    g_account       LIKE type_file.num5               #No.FUN-680102 SMALLINT               #FUN-670032 會計維護
DEFINE g_forupd_sql         STRING                  #SELECT ... FOR UPDATE SQL
DEFINE g_forupd_gbo_sql     STRING                  #FOR UPDATE SQL   #FUN-920138
DEFINE g_cnt                LIKE type_file.num10    #No.FUN-680102 INTEGER
DEFINE g_before_input_done  LIKE type_file.num5     #FUN-570110   #No.FUN-680102 SMALLINT
DEFINE g_i                  LIKE type_file.num5     #count/index for any purpose  #No.FUN-680102 SMALLINT
DEFINE g_str                STRING                  #No.FUN-760083
DEFINE g_u_flag             LIKE type_file.chr1     #FUN-870101 add 
DEFINE 
    g_success      LIKE type_file.chr1,
    g_wc            STRING,
    g_wc1           STRING,
    g_cmd           LIKE type_file.chr1000, 
    g_rec_b_1       LIKE type_file.num5,    #added by yeap1 NO.130718
    g_ii            LIKE type_file.num5,    #added by yeap1 NO.130718  
    g_ss            LIKE type_file.chr1,
    g_flag          LIKE type_file.chr1,
	  g_hrcm02        LIKE hrcm_file.hrcm02,  #added by yeap1  NO.130718
    g_hrbm03        LIKE hrbm_file.hrbm03,  #added by yeap1  NO.130718
    g_hrbm04        LIKE hrbm_file.hrbm04,  #added by yeap1  NO.130718 
    g_h1,g_m1       LIKE type_file.num5,    #added by yeap1  NO.130718
    g_h2,g_m2       LIKE type_file.num5     #added by yeap1  NO.130718 
    ,g_1            LIKE type_file.num5 
DEFINE g_cnt1       LIKE type_file.num10      
DEFINE g_on_change  LIKE type_file.num5      
DEFINE g_row_count  LIKE type_file.num5       
DEFINE g_curs_index LIKE type_file.num5       
DEFINE g_chus       LIKE type_file.num5
DEFINE g_max        LIKE type_file.num5
DEFINE g_hrdg01     LIKE hrdg_file.hrdg01
DEFINE g_hrdg04_t   LIKE hrdg_file.hrdg04
DEFINE g_hrdg05_t   LIKE hrdg_file.hrdg05
DEFINE g_hrdg08_t   LIKE hrdg_file.hrdg08
DEFINE g_flag_1     LIKE type_file.chr1
DEFINE g_record     LIKE type_file.chr5
DEFINE g_bdate      LIKE hrdq_file.hrdq05,
       g_edate      LIKE hrdq_file.hrdq05,
       g_xinbc      LIKE hrdg_file.hrdg04
 
MAIN
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("GHR")) THEN
      EXIT PROGRAM
   END IF

   CALL  cl_used(g_prog,g_time,1) RETURNING g_time    #No.FUN-6A0081
 
    OPEN WINDOW i075_w WITH FORM "ghr/42f/ghri075"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
     
    CALL cl_ui_init()
    CALL cl_set_comp_visible("hrdg01,sure",FALSE)
    CALL i075_menu()
    CLOSE WINDOW i075_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-6A0081
END MAIN
 
FUNCTION i075_menu()
	DEFINE l_record   LIKE type_file.num5
 
   WHILE TRUE
   	  IF g_flag = 'Y' THEN 
   	  	 LET g_action_choice = 'tiaoban'
   	  	 LET g_flag = 'N'
      ELSE 
         CALL i075_bp("G")
      END IF 
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i075_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               LET g_account=FALSE #FUN-670032
               CALL i075_b()
            ELSE
               LET g_action_choice = NULL
            END IF 
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
          WHEN "related_document"  #No.MOD-470515
            IF cl_chk_act_auth() AND l_ac != 0 THEN #NO.FUN-570199
               IF g_hrdg[l_ac].hrdg01 IS NOT NULL THEN
                  LET g_doc.column1 = "hrdg01"
                  LET g_doc.value1 = g_hrdg[l_ac].hrdg01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0020
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrdg),'','')
            END IF
            	
         WHEN "confirm"
             IF cl_chk_act_auth() THEN
             	  CALL i075_b_fill(g_wc2)
                CALL i075_choose('Y')
             END IF

         WHEN "unconfirm"
             IF cl_chk_act_auth() THEN
               	CALL i075_b_fill(g_wc2)
                CALL i075_choose('N')
             END IF
                       
         WHEN "sel_all"
             IF cl_chk_act_auth() THEN
                CALL i075_sel_all('Y')
             END IF
          
         WHEN "can_all"
             IF cl_chk_act_auth() THEN
                CALL i075_sel_all('N')
             END IF
             	
         WHEN "remove"
             IF cl_chk_act_auth() THEN
             CALL i075_remove()
             IF g_record = 1 THEN 
                CLEAR FORM
                CALL g_hrdg.clear()
                LET g_record = 0
                LET l_record = 1
                IF g_rec_b>g_max THEN 
              	   CALL i075_b_fill(g_wc2)
              	END IF 
             ELSE
                CALL cl_err('','ghr-164',0)  
             END IF 
              
             END IF
         
         WHEN "tiaoban"
             IF cl_chk_act_auth() THEN
                CALL i075_tiaoban()
                IF g_chus != 100 THEN 
                    CALL i075_b_fill_1()
                     LET g_chus = 0
                END IF
             END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i075_q()
   CALL i075_b_askkey()
END FUNCTION
 
FUNCTION i075_b()   ######################
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  #No.FUN-680102 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用  #No.FUN-680102 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否  #No.FUN-680102 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                #處理狀態  #No.FUN-680102 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1,                # Prog. Version..: '5.30.03-12.09.18(01),              #可新增否
    l_allow_delete  LIKE type_file.chr1,                # Prog. Version..: '5.30.03-12.09.18(01),              #可刪除否
    l_cnt           LIKE type_file.num10                #No.FUN-680102 INTEGER #FUN-670032
DEFINE l_hrdgconf   LIKE hrdg_file.hrdgconf,
       l_hrcb01     LIKE hrcb_file.hrcb01,
       l_hratid     LIKE hrat_file.hratid,
       l_hrat03     LIKE hrat_file.hrat03,
       l_hrat04     LIKE hrat_file.hrat04,
       l_hrat05     LIKE hrat_file.hrat05,
       l_hrat25     LIKE hrat_file.hrat25,
       l_hraz05     LIKE hraz_file.hraz05,
       l_hraz08     LIKE hraz_file.hraz08,
       l_hraz31     LIKE hraz_file.hraz31,
       l_hrao02     LIKE hrao_file.hrao02,
       l_hrap06     LIKE hrap_file.hrap06,
       l_hrdg03     LIKE hrdg_file.hrdg03
       
 
    LET g_action_choice = ""    #No:MOD-A60184 add
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
   #LET g_action_choice = ""  #No:MOD-A60184 mark
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    LET g_forupd_sql = "SELECT 'N',hrdg01,hrdg03,'','','','','',hrdg02,hrdg04,'',hrdg05,'',hrdg06,'',hrdg07,'',hrdg08,hrdg09", 
                       "  FROM hrdg_file WHERE hrdg02=?  AND hrdg03=?  FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)

    DECLARE i075_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
     

    INPUT ARRAY g_hrdg WITHOUT DEFAULTS FROM s_hrdg.*
          ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                     INSERT ROW = l_allow_insert,DELETE ROW=FALSE,APPEND ROW=l_allow_insert) 
 
    BEFORE INPUT
       IF g_rec_b != 0 THEN
          CALL fgl_set_arr_curr(l_ac)
       END IF
 
    BEFORE ROW
        LET p_cmd=''
        LET l_ac = ARR_CURR()
        LET l_lock_sw = 'N'            #DEFAULT
        LET l_n  = ARR_COUNT()
        
        IF g_rec_b>=l_ac THEN
           BEGIN WORK
           LET p_cmd='u'
           LET g_before_input_done = FALSE
           CALL i075_set_entry(p_cmd)                                           
           CALL i075_set_no_entry(p_cmd)                                    
           LET g_before_input_done = TRUE
           LET g_hrdg_t.* = g_hrdg[l_ac].*  #BACKUP 
           SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01 = g_hrdg_t.hrdg03
           LET l_hrdg03 = g_hrdg_t.hrdg03
           LET g_hrdg_t.hrdg03 = l_hratid         
           OPEN i075_bcl USING g_hrdg_t.hrdg02,g_hrdg_t.hrdg03 
           IF STATUS THEN
              CALL cl_err("OPEN i075_bcl:", STATUS, 1)
              LET l_lock_sw = "Y"
           ELSE 
              FETCH i075_bcl INTO g_hrdg[l_ac].* 
              IF SQLCA.sqlcode THEN
                  CALL cl_err(g_hrdg_t.hrdg01,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
              END IF
           END IF 
           	   LET g_hrdg[l_ac].hrat02 = g_hrdg_t.hrat02
           	   LET g_hrdg[l_ac].hrat04 = g_hrdg_t.hrat04
           	   LET g_hrdg[l_ac].hrat05 = g_hrdg_t.hrat05
           	   LET g_hrdg[l_ac].hrat25 = g_hrdg_t.hrat25
           	   LET g_hrdg[l_ac].hrat19 = g_hrdg_t.hrat19
           	   LET g_hrdg[l_ac].hrdg04_name = g_hrdg_t.hrdg04_name
           	   LET g_hrdg[l_ac].hrdg06_name = g_hrdg_t.hrdg06_name
           	   LET g_hrdg[l_ac].hrbo15 = g_hrdg_t.hrbo15
           	   LET g_hrdg[l_ac].hrbo15_1 = g_hrdg_t.hrbo15_1
           CALL cl_show_fld_cont()     #FUN-550037(smin)
        END IF
 
     BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'                                                         
         LET g_before_input_done = FALSE                                        
         CALL i075_set_entry(p_cmd)                                             
         CALL i075_set_no_entry(p_cmd)                                          
         LET g_before_input_done = TRUE      
         INITIALIZE g_hrdg[l_ac].* TO NULL      #900423
         LET g_hrdg_t.* = g_hrdg[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         SELECT COUNT(*) INTO l_n FROM hrdg_file 
         IF l_n >0 THEN 
            SELECT MAX(hrdg01) + 1 INTO g_hrdg[l_ac].hrdg01 FROM hrdg_file
         ELSE 
         	  LET g_hrdg[l_ac].hrdg01 = 1
         END IF 
         NEXT FIELD hrdg03
 
     AFTER INSERT
        DISPLAY "AFTER INSERT"
        IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           CLOSE i075_bcl
           CANCEL INSERT
        END IF
  
        BEGIN WORK                    #FUN-680011
 
        INSERT INTO hrdg_file(hrdg01,hrdg02,hrdg03,hrdg04,hrdg05,hrdg06,hrdgacti,
                              hrdguser,hrdggrup,hrdgoriu,hrdgorig) #FUN-670032 #FUN-870100 #FUN-A30097 
        VALUES(g_hrdg[l_ac].hrdg01,g_hrdg[l_ac].hrdg02,l_hratid,
               g_hrdg[l_ac].hrdg04,g_hrdg[l_ac].hrdg05,g_hrdg[l_ac].hrdg06,
               'Y',g_user,g_grup, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
        IF SQLCA.sqlcode THEN 
           CALL cl_err3("ins","hrdg_file",g_hrdg[l_ac].hrdg01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
           CANCEL INSERT
        ELSE
           COMMIT WORK 
        END IF
 
    

      AFTER FIELD hrdg03
         IF NOT cl_null(g_hrdg[l_ac].hrdg03) THEN 
         	  SELECT hrat02,hrat04,hrat05,hrat25,hrat19,hratid
         	    INTO g_hrdg[l_ac].hrat02,l_hrat04,l_hrat05,g_hrdg[l_ac].hrat25,g_hrdg[l_ac].hrat19,l_hratid
         	    FROM hrat_file 
         	   WHERE hrat01 = g_hrdg[l_ac].hrdg03
         	  SELECT hrao02 INTO g_hrdg[l_ac].hrat04 FROM hrao_file WHERE hrao01 = l_hrat04
         	  SELECT hrap06 INTO g_hrdg[l_ac].hrat05 FROM hrap_file WHERE hrap01 = l_hrat04 AND hrap05 = l_hrat05
         	  
         	  IF NOT cl_null(g_hrdg[l_ac].hrdg02) THEN
         	  	SELECT COUNT(*) INTO l_n FROM hrdg_file WHERE hrdg02 = g_hrdg[l_ac].hrdg02 AND hrdg03 = l_hratid
         	  	IF l_n > 0 THEN 
         	  	    	 CALL cl_err('','agl-447',0)
         	  	    	 INITIALIZE g_hrdg[l_ac].* TO NULL
         	  	    	 NEXT FIELD hrdg03
         	  	ELSE
         	  	 SELECT hrcp04,hrbo03,hrcp05,hrcp06   #考勤汇总表
         	  	   INTO g_hrdg[l_ac].hrdg04,g_hrdg[l_ac].hrdg04_name,g_hrdg[l_ac].hrbo15,g_hrdg[l_ac].hrdg05
         	  	   FROM hrcp_file LEFT join hrbo_file ON hrcp04 = hrbo02
         	  	  WHERE hrcp02 = l_hratid AND hrcp03 = g_hrdg[l_ac].hrdg02
         	  	     IF cl_null(g_hrdg[l_ac].hrdg04) THEN 
         	  	     	  LET g_flag_1 = 'N'
         	  	     	  SELECT hrdq06,hrdq07,hrbo15   #排班计划表员工排班记录
         	  	     	    INTO g_hrdg[l_ac].hrdg04,g_hrdg[l_ac].hrdg04_name,g_hrdg[l_ac].hrbo15
         	  	     	    FROM hrdq_file LEFT join hrbo_file ON hrdq06 = hrbo02
         	  	     	   WHERE hrdq02 = 1 AND hrdq03 = l_hratid AND hrdq05 = g_hrdg[l_ac].hrdg02
         	  	     	      IF cl_null(g_hrdg[l_ac].hrdg04) THEN   #排班计划表群组排班记录
         	  	     	      	 CALL cl_err('','ghr-152',1)
          	  	     	       INITIALIZE g_hrdg[l_ac].* TO NULL
          	  	     	       NEXT FIELD hrdg03  
#         	  	     	      	 SELECT hrcb01 INTO l_hrcb01 FROM hrcb_file
#         	  	     	      	  WHERE hrcb05 = g_hrdg[l_ac].hrdg03
#         	  	     	      	    AND hrcb07 >= g_hrdg[l_ac].hrdg02
#         	  	     	      	    AND hrcb06 <= g_hrdg[l_ac].hrdg02
#         	  	     	      	 SELECT hrdq06,hrdq07,hrbo15
#         	  	     	      	   INTO g_hrdg[l_ac].hrdg04,g_hrdg[l_ac].hrdg04_name,g_hrdg[l_ac].hrbo15
#         	  	     	           FROM hrdq_file LEFT join hrbo_file ON hrdq06 = hrbo02
#         	  	     	          WHERE hrdq02 = 4 AND hrdq03 = l_hrcb01 AND hrdq05 = g_hrdg[l_ac].hrdg02
#         	  	     	             IF cl_null(g_hrdg[l_ac].hrdg04) THEN  #员工当天所在公司及部门查询
#         	  	     	             	  SELECT hrat03,hrat04,hrat25   #员工基本信息记录
#         	  	     	             	    INTO l_hrat03,l_hrat04,l_hrat25
#         	  	     	             	    FROM hrat_file WHERE hratid = g_hrdg[l_ac].hrdg03 AND hrat25 <= g_hrdg[l_ac].hrdg02
#         	  	     	             	  SELECT hraz05,hraz07,hraz08,hraz30,hraz31  #职位变更记录
#         	  	     	             	    INTO l_hraz05,l_hraz08,l_hraz31
#         	  	     	             	    FROM hraz_file 
#         	  	     	             	   WHERE hraz03 = g_hrdg[l_ac].hrdg03 
#         	  	     	             	     AND (hraz07<>hraz08 OR hraz<>hraz31)
#         	  	     	             	     AND hraz05 <= g_hrdg[l_ac].hrdg02
#         	  	     	             	     AND hraz18 ='003'
#         	  	     	             	      IF (l_hraz05 < l_hrat25) THEN  
#         	  	     	             	         SELECT hrdq06,hrdq07,hrbo15  #员工当天所在部门排版记录
#         	  	     	      	                 INTO g_hrdg[l_ac].hrdg04,g_hrdg[l_ac].hrdg04_name,g_hrdg[l_ac].hrbo15
#         	  	     	                         FROM hrdq_file LEFT join hrbo_file ON hrdq06 = hrbo02
#         	  	     	                        WHERE hrdq02 = 2 AND hrdq03 = l_hrat04 AND hrdq05 = g_hrdg[l_ac].hrdg02
#         	  	     	                           IF cl_null(g_hrdg[l_ac].hrdg04) THEN
#         	  	     	                           	  SELECT hrdq06,hrdq07,hrbo15  #员工当天所在公司排版记录
#         	  	     	      	                        INTO g_hrdg[l_ac].hrdg04,g_hrdg[l_ac].hrdg04_name,g_hrdg[l_ac].hrbo15
#         	  	     	                                FROM hrdq_file LEFT join hrbo_file ON hrdq06 = hrbo02
#         	  	     	                               WHERE hrdq02 = 3 AND hrdq03 = l_hrat03 AND hrdq05 = g_hrdg[l_ac].hrdg02 
#         	  	     	                           END IF 
#         	  	     	                    ELSE 	 
#         	  	                             SELECT hrdq06,hrdq07,hrbo15   #员工当天所在部门排版记录
#         	  	     	      	                 INTO g_hrdg[l_ac].hrdg04,g_hrdg[l_ac].hrdg04_name,g_hrdg[l_ac].hrbo15
#         	  	     	                         FROM hrdq_file LEFT join hrbo_file ON hrdq06 = hrbo02
#         	  	     	                        WHERE hrdq02 = 2 AND hrdq03 = l_hraz08 AND hrdq05 = g_hrdg[l_ac].hrdg02
#         	  	     	                           IF cl_null(g_hrdg[l_ac].hrdg04) THEN
#         	  	     	                           	  SELECT hrdq06,hrdq07,hrbo15   #员工当天所在部门排版记录
#         	  	     	      	                        INTO g_hrdg[l_ac].hrdg04,g_hrdg[l_ac].hrdg04_name,g_hrdg[l_ac].hrbo15
#         	  	     	                                FROM hrdq_file LEFT join hrbo_file ON hrdq06 = hrbo02
#         	  	     	                               WHERE hrdq02 = 3 AND hrdq03 = l_hraz31 AND hrdq05 = g_hrdg[l_ac].hrdg02
#         	  	     	                                  IF cl_null(g_hrdg[l_ac].hrdg04) THEN
#         	  	     	                                  	 CALL cl_err('','ghr-152',1)
#         	  	     	                                  	 INITIALIZE g_hrdg[l_ac].* TO NULL
#         	  	     	                                  	 NEXT FIELD hrdg03
#         	  	     	                           	      END IF 
#         	  	     	                           END IF
#         	  	     	                    END IF  
#         	  	     	             END IF 
         	  	     	      END IF 
         	  	     ELSE 
         	  	     	LET g_flag_1 = 'Y'
         	  	     END IF
         	  	 END IF 
         	  ELSE
                     NEXT FIELD hrdg02

         	  END IF 
         END IF 
         	
         AFTER FIELD hrdg02
         IF NOT cl_null(g_hrdg[l_ac].hrdg02) THEN 
         	  IF NOT cl_null(g_hrdg[l_ac].hrdg03) THEN
         	  	SELECT COUNT(*) INTO l_n FROM hrdg_file WHERE hrdg02 = g_hrdg[l_ac].hrdg02 AND hrdg03 = l_hratid
         	  	    IF l_n > 0 THEN 
         	  	    	 CALL cl_err('','agl-447',0)
                     INITIALIZE g_hrdg[l_ac].* TO NULL
         	  	    	 NEXT FIELD hrdg03
         	  	    ELSE 
         	  	 SELECT hrcp04,hrbo03,hrcp05,hrcp06   #考勤汇总表
         	  	   INTO g_hrdg[l_ac].hrdg04,g_hrdg[l_ac].hrdg04_name,g_hrdg[l_ac].hrbo15,g_hrdg[l_ac].hrdg05
         	  	   FROM hrcp_file LEFT join hrbo_file ON hrcp04 = hrbo02
         	  	  WHERE hrcp02 = l_hratid AND hrcp03 = g_hrdg[l_ac].hrdg02
         	  	     IF cl_null(g_hrdg[l_ac].hrdg04) THEN
         	  	     	  LET g_flag_1 = 'N' 
         	  	     	  SELECT hrdq06,hrdq07,hrbo15   #排班计划表员工排班记录
         	  	     	    INTO g_hrdg[l_ac].hrdg04,g_hrdg[l_ac].hrdg04_name,g_hrdg[l_ac].hrbo15
         	  	     	    FROM hrdq_file LEFT join hrbo_file ON hrdq06 = hrbo02
         	  	     	   WHERE hrdq02 = 1 AND hrdq03 = l_hratid AND hrdq05 = g_hrdg[l_ac].hrdg02
         	  	     	      IF cl_null(g_hrdg[l_ac].hrdg04) THEN   #排班计划表群组排班记录
         	  	     	      	 CALL cl_err('','ghr-152',1)
          	  	     	       INITIALIZE g_hrdg[l_ac].* TO NULL
          	  	     	       NEXT FIELD hrdg03
#         	  	     	      	 SELECT hrcb01 INTO l_hrcb01 FROM hrcb_file
#         	  	     	      	  WHERE hrcb05 = g_hrdg[l_ac].hrdg03
#         	  	     	      	    AND hrcb07 >= g_hrdg[l_ac].hrdg02
#         	  	     	      	    AND hrcb06 <= g_hrdg[l_ac].hrdg02
#         	  	     	      	 SELECT hrdq06,hrdq07,hrbo15
#         	  	     	      	   INTO g_hrdg[l_ac].hrdg04,g_hrdg[l_ac].hrdg04_name,g_hrdg[l_ac].hrbo15
#         	  	     	           FROM hrdq_file LEFT join hrbo_file ON hrdq06 = hrbo02
#         	  	     	          WHERE hrdq02 = 4 AND hrdq03 = l_hrcb01 AND hrdq05 = g_hrdg[l_ac].hrdg02
#         	  	     	             IF cl_null(g_hrdg[l_ac].hrdg04) THEN  #员工当天所在公司及部门查询
#         	  	     	             	  SELECT hrat03,hrat04,hrat25   #员工基本信息记录
#         	  	     	             	    INTO l_hrat03,l_hrat04,l_hrat25
#         	  	     	             	    FROM hrat_file WHERE hratid = g_hrdg[l_ac].hrdg03 AND hrat25 <= g_hrdg[l_ac].hrdg02
#         	  	     	             	  SELECT hraz05,hraz07,hraz08,hraz30,hraz31  #职位变更记录
#         	  	     	             	    INTO l_hraz05,l_hraz08,l_hraz31
#         	  	     	             	    FROM hraz_file 
#         	  	     	             	   WHERE hraz03 = g_hrdg[l_ac].hrdg03 
#         	  	     	             	     AND (hraz07<>hraz08 OR hraz<>hraz31)
#         	  	     	             	     AND hraz05 <= g_hrdg[l_ac].hrdg02
#         	  	     	             	     AND hraz18 ='003'
#         	  	     	             	      IF (l_hraz05 < l_hrat25) THEN  
#         	  	     	             	         SELECT hrdq06,hrdq07,hrbo15  #员工当天所在部门排版记录
#         	  	     	      	                 INTO g_hrdg[l_ac].hrdg04,g_hrdg[l_ac].hrdg04_name,g_hrdg[l_ac].hrbo15
#         	  	     	                         FROM hrdq_file LEFT join hrbo_file ON hrdq06 = hrbo02
#         	  	     	                        WHERE hrdq02 = 2 AND hrdq03 = l_hrat04 AND hrdq05 = g_hrdg[l_ac].hrdg02
#         	  	     	                           IF cl_null(g_hrdg[l_ac].hrdg04) THEN
#         	  	     	                           	  SELECT hrdq06,hrdq07,hrbo15  #员工当天所在公司排版记录
#         	  	     	      	                        INTO g_hrdg[l_ac].hrdg04,g_hrdg[l_ac].hrdg04_name,g_hrdg[l_ac].hrbo15
#         	  	     	                                FROM hrdq_file LEFT join hrbo_file ON hrdq06 = hrbo02
#         	  	     	                               WHERE hrdq02 = 3 AND hrdq03 = l_hrat03 AND hrdq05 = g_hrdg[l_ac].hrdg02 
#         	  	     	                           END IF 
#         	  	     	                    ELSE 	 
#         	  	                             SELECT hrdq06,hrdq07,hrbo15   #员工当天所在部门排版记录
#         	  	     	      	                 INTO g_hrdg[l_ac].hrdg04,g_hrdg[l_ac].hrdg04_name,g_hrdg[l_ac].hrbo15
#         	  	     	                         FROM hrdq_file LEFT join hrbo_file ON hrdq06 = hrbo02
#         	  	     	                        WHERE hrdq02 = 2 AND hrdq03 = l_hraz08 AND hrdq05 = g_hrdg[l_ac].hrdg02
#         	  	     	                           IF cl_null(g_hrdg[l_ac].hrdg04) THEN
#         	  	     	                           	  SELECT hrdq06,hrdq07,hrbo15   #员工当天所在部门排版记录
#         	  	     	      	                        INTO g_hrdg[l_ac].hrdg04,g_hrdg[l_ac].hrdg04_name,g_hrdg[l_ac].hrbo15
#         	  	     	                                FROM hrdq_file LEFT join hrbo_file ON hrdq06 = hrbo02
#         	  	     	                               WHERE hrdq02 = 3 AND hrdq03 = l_hraz31 AND hrdq05 = g_hrdg[l_ac].hrdg02 
#         	  	     	                                  IF cl_null(g_hrdg[l_ac].hrdg04) THEN
#         	  	     	                                  	 CALL cl_err('','ghr-152',1)
#         	  	     	                                  	 INITIALIZE g_hrdg[l_ac].* TO NULL
#         	  	     	                                  	 NEXT FIELD hrdg03
#         	  	     	                           	      END IF
#         	  	     	                           END IF
#         	  	     	                    END IF  
#         	  	     	             END IF 
         	  	     	      END IF
         	  	     ELSE 
         	  	     	LET g_flag_1 = 'Y' 
         	  	     END IF
         	  	    END IF 
         	  ELSE 
         	  	NEXT FIELD hrdg03 
         	  END IF
         	   
         END IF	
         	
           
         AFTER FIELD hrdg06
            IF cl_null(g_hrdg[l_ac].hrdg06) THEN 
            	 CALL cl_err('','ghr-153',0)
            	 NEXT FIELD hrdg06
            ELSE 
            	 SELECT hrbo03 INTO g_hrdg[l_ac].hrdg06_name FROM hrbo_file WHERE hrbo02 = g_hrdg[l_ac].hrdg06
            	 DISPLAY BY NAME g_hrdg[l_ac].hrdg06_name 
            END IF 
 
    
 
     ON ROW CHANGE
        IF INT_FLAG THEN                 #新增程式段
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           LET g_hrdg[l_ac].* = g_hrdg_t.*
           CLOSE i075_bcl
           ROLLBACK WORK
           EXIT INPUT
        END IF
        
        SELECT hrdgconf INTO l_hrdgconf FROM hrdg_file WHERE hrdg01 = g_hrdg_t.hrdg01	
        IF l_hrdgconf = 'Y' THEN 
           CALL cl_err('','ghr-155',0) 
           LET g_hrdg[l_ac].*=g_hrdg_t.*
           CLOSE i075_bcl
           ROLLBACK WORK
           EXIT INPUT 
        END IF
        	
        IF l_lock_sw="Y" THEN
           CALL cl_err(g_hrdg[l_ac].hrdg03,-263,0)
           LET g_hrdg[l_ac].* = g_hrdg_t.*
        ELSE
           UPDATE hrdg_file 
              SET hrdg06=g_hrdg[l_ac].hrdg06,
                  hrdg07=g_hrdg[l_ac].hrdg07,
                  hrdg08=g_hrdg[l_ac].hrdg08,
                  hrdg09=g_hrdg[l_ac].hrdg09,
                  hrdgmodu=g_user,
                  hrdgdate=g_today
            WHERE hrdg02 = g_hrdg_t.hrdg02
              AND hrdg02 = g_hrdg_t.hrdg02
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","hrdg_file",g_hrdg[l_ac].hrdg01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
                LET g_hrdg[l_ac].* = g_hrdg_t.*
            ELSE
            	 MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
        END IF  

 
     AFTER ROW
        LET l_ac = ARR_CURR()         # 新增
        LET l_ac_t = l_ac             # 新增
 
        IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           IF p_cmd='u' THEN
              LET g_hrdg[l_ac].* = g_hrdg_t.*
           END IF
           CLOSE i075_bcl         # 新增
           ROLLBACK WORK          # 新增
           EXIT INPUT
        END IF
        CLOSE i075_bcl            # 新增
        COMMIT WORK
 
    
 
     ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(hrdg01) AND l_ac > 1 THEN
             LET g_hrdg[l_ac].* = g_hrdg[l_ac-1].*
             NEXT FIELD hrdg03
         END IF
 
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
         
      ON ACTION controlp
         CASE
            WHEN INFIELD(hrdg03)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrat"
              LET g_qryparam.default1 = g_hrdg[l_ac].hrdg03
              CALL cl_create_qry() RETURNING g_hrdg[l_ac].hrdg03
              DISPLAY BY NAME g_hrdg[l_ac].hrdg03
              NEXT FIELD hrdg03
            WHEN INFIELD(hrat04)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrao01"
              LET g_qryparam.default1 = g_hrdg[l_ac].hrat04
              CALL cl_create_qry() RETURNING g_hrdg[l_ac].hrat04
              DISPLAY BY NAME g_hrdg[l_ac].hrat04
              NEXT FIELD hrat04
            WHEN INFIELD(hrat05)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrap01"
              LET g_qryparam.default1 = g_hrdg[l_ac].hrat05
              CALL cl_create_qry() RETURNING g_hrdg[l_ac].hrat05
              DISPLAY BY NAME g_hrdg[l_ac].hrat05
              NEXT FIELD hrat05
            WHEN INFIELD(hrat19)
              CALL cl_init_qry_var() 
              LET g_qryparam.form = "q_hrad02"
              LET g_qryparam.default1 = g_hrdg[l_ac].hrat19
              CALL cl_create_qry() RETURNING g_hrdg[l_ac].hrat19
              DISPLAY BY NAME g_hrdg[l_ac].hrat19
              NEXT FIELD hrat19
            WHEN INFIELD(hrdg04)
              CALL cl_init_qry_var() 
              LET g_qryparam.form = "q_hrbo02"
              LET g_qryparam.default1 = g_hrdg[l_ac].hrdg04
              CALL cl_create_qry() RETURNING g_hrdg[l_ac].hrdg04
              DISPLAY BY NAME g_hrdg[l_ac].hrdg04
              NEXT FIELD hrdg04
            WHEN INFIELD(hrdg06)
              CALL cl_init_qry_var() 
              LET g_qryparam.form = "q_hrbo02"
              LET g_qryparam.default1 = g_hrdg[l_ac].hrdg06
              CALL cl_create_qry() RETURNING g_hrdg[l_ac].hrdg06
              DISPLAY BY NAME g_hrdg[l_ac].hrdg06
              NEXT FIELD hrdg06
            OTHERWISE
              EXIT CASE   

         END CASE
 
     
     END INPUT
 
 
    CLOSE i075_bcl
    COMMIT WORK
END FUNCTION

FUNCTION i075_b_askkey()
	DEFINE l_hrdg03    LIKE hrdg_file.hrdg03,
	       l_hratid    LIKE hrat_file.hratid,
	       l_n         LIKE type_file.num5
 
    CLEAR FORM
   CALL g_hrdg.clear()
 
    CONSTRUCT g_wc2 ON hrdg03,hrat02,hrat04,hrat05,hrat25,hrat19,hrdg02,hrdg04,hrdg05,hrdg06,hrdg07,hrdg08,hrdg09 
         FROM s_hrdg[1].hrdg03,s_hrdg[1].hrat02,s_hrdg[1].hrat04,s_hrdg[1].hrat05,s_hrdg[1].hrat25,s_hrdg[1].hrat19,
              s_hrdg[1].hrdg02,s_hrdg[1].hrdg04,s_hrdg[1].hrdg05,s_hrdg[1].hrdg06,s_hrdg[1].hrdg07,
              s_hrdg[1].hrdg08,s_hrdg[1].hrdg09
              
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
                 
      AFTER FIELD hrdg03
         LET l_hrdg03 = GET_FLDBUF(hrdg03)
         LET g_hrdg[1].hrdg03 = l_hrdg03
          IF NOT cl_null(g_hrdg[1].hrdg03) THEN 
             SELECT COUNT(*) INTO l_n FROM hrat_file WHERE hrat01 = g_hrdg[1].hrdg03
         	   IF l_n > 0 THEN 
           	    SELECT hrat02,hrat04,hrat05,hrat25,hrat19,hratid 
         	        INTO g_hrdg[1].hrat02,g_hrdg[1].hrat04,g_hrdg[1].hrat05,g_hrdg[1].hrat25,g_hrdg[1].hrat19,l_hratid
         	        FROM hrat_file 
         	       WHERE hrat01 = g_hrdg[1].hrdg03
         	         LET g_hrdg[1].hrdg03 = l_hratid
          	  ELSE 
         	    	SELECT hrat02,hrat04,hrat05,hrat25,hrat19 
         	        INTO g_hrdg[1].hrat02,g_hrdg[1].hrat04,g_hrdg[1].hrat05,g_hrdg[1].hrat25,g_hrdg[1].hrat19
         	        FROM hrat_file 
         	       WHERE hratid = g_hrdg[1].hrdg03
         	   END IF 
         	END IF          
          DISPLAY BY NAME  g_hrdg[1].hrat02,g_hrdg[1].hrat04,g_hrdg[1].hrat05,g_hrdg[1].hrat25,g_hrdg[1].hrat19,g_hrdg[1].hrdg03
      

      ON ACTION controlp
         CASE
            WHEN INFIELD(hrdg03)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrat"
              LET g_qryparam.default1 = g_hrdg[1].hrdg03
              CALL cl_create_qry() RETURNING g_hrdg[1].hrdg03
              DISPLAY BY NAME g_hrdg[1].hrdg03
              NEXT FIELD hrdg03
            WHEN INFIELD(hrat04)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrao01"
              LET g_qryparam.default1 = g_hrdg[1].hrat04
              CALL cl_create_qry() RETURNING g_hrdg[1].hrat04
              DISPLAY BY NAME g_hrdg[1].hrat04
              NEXT FIELD hrat04
            WHEN INFIELD(hrat05)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrap01"
              LET g_qryparam.default1 = g_hrdg[1].hrat05
              CALL cl_create_qry() RETURNING g_hrdg[1].hrat05
              DISPLAY BY NAME g_hrdg[1].hrat05
              NEXT FIELD hrat05
            WHEN INFIELD(hrat19)
              CALL cl_init_qry_var() 
              LET g_qryparam.form = "q_hrad02"
              LET g_qryparam.default1 = g_hrdg[1].hrat19
              CALL cl_create_qry() RETURNING g_hrdg[1].hrat19
              DISPLAY BY NAME g_hrdg[1].hrat19
              NEXT FIELD hrat19
            WHEN INFIELD(hrdg04)
              CALL cl_init_qry_var() 
              LET g_qryparam.form = "q_hrbo02"
              LET g_qryparam.default1 = g_hrdg[1].hrdg04
              CALL cl_create_qry() RETURNING g_hrdg[1].hrdg04
              DISPLAY BY NAME g_hrdg[1].hrdg04
              NEXT FIELD hrdg04
            WHEN INFIELD(hrdg06)
              CALL cl_init_qry_var() 
              LET g_qryparam.form = "q_hrbo02"
              LET g_qryparam.default1 = g_hrdg[1].hrdg06
              CALL cl_create_qry() RETURNING g_hrdg[1].hrdg06
              DISPLAY BY NAME g_hrdg[1].hrdg06
              NEXT FIELD hrdg06
            OTHERWISE
              EXIT CASE   

         END CASE 
         	
       	
      
 
      ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      ON ACTION qbe_select
         CALL cl_qbe_select() 
      
      ON ACTION qbe_save
		     CALL cl_qbe_save()
		     
    END CONSTRUCT
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('hrdguser', 'hrdggrup') #FUN-980030
 
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      LET g_rec_b = 0   
      RETURN
   END IF
 
    CALL i075_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION i075_b_fill(p_wc2)              #BODY FILL UP       
DEFINE
    p_wc2           LIKE type_file.chr1000 #No.FUN-680102 VARCHAR(200)
   ,l_hrat04        LIKE hrat_file.hrat04,
    l_hrat05        LIKE hrat_file.hrat05,
    l_hrat01        LIKE hrat_file.hrat01
    
    IF cl_null(p_wc2) THEN 
    	 LET p_wc2 = '1=1'
    END IF 
    
 IF g_flag_1 = 'N' THEN 
    LET g_sql =
        "SELECT '',hrdg01,hrdg03,hrat02,hrat04,hrat05,hrat25,hrat19,hrdg02,hrdg04,'',hrdg05,hrbo15,hrdg06,'',hrdg07,'',hrdg08,hrdg09 ", #FUN-670032 #FUN-A30097 #No.MOD-A60111  #added by yeap NO.130826 新增hrdg07后''
        "  FROM hrdg_file ",
        "  left join hrat_file on hrdg03 = hratid ",
        "  left join hrbo_file on hrdg04 = hrbo02 ",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        " ORDER BY hrdg03"
 ELSE 
    LET g_sql =
        "SELECT '',hrdg01,hrdg03,hrat02,hrat04,hrat05,hrat25,hrat19,hrdg02,hrdg04,'',hrdg05,hrcp05,hrdg06,'',hrdg07,'',hrdg08,hrdg09 ", #FUN-670032 #FUN-A30097 #No.MOD-A60111  #added by yeap NO.130826 新增hrdg07后''
        "  FROM hrdg_file ",
        "  left join hrat_file on hrdg03 = hratid ",
        "  left join hrcp_file on hrdg02 = hrcp03 and hrdg03 = hrcp02 ",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        " ORDER BY hrdg03"
 END IF 
    PREPARE i075_pb FROM g_sql
    DECLARE hrdg_curs CURSOR FOR i075_pb
 
    CALL g_hrdg.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH hrdg_curs INTO g_hrdg[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        	
        	SELECT hrbo03,hrbo15 INTO g_hrdg[g_cnt].hrdg04_name,g_hrdg[g_cnt].hrbo15
        	  FROM hrbo_file
           WHERE hrbo02 = g_hrdg[g_cnt].hrdg04
           
              IF cl_null(g_hrdg[g_cnt].hrbo15) THEN 
              	 LET g_hrdg[g_cnt].hrbo15 = '00:00-00:00|00:00-00:00'
              END IF 
                         
          SELECT hrbo03,hrbo15 INTO g_hrdg[g_cnt].hrdg06_name,g_hrdg[g_cnt].hrbo15_1
            FROM hrbo_file
           WHERE hrbo02 = g_hrdg[g_cnt].hrdg06
              IF cl_null(g_hrdg[g_cnt].hrbo15_1) THEN 
              	 LET g_hrdg[g_cnt].hrbo15_1 = '00:00-00:00|00:00-00:00'
              END IF
           
          SELECT hrat04,hrat05,hrat01
         	  INTO l_hrat04,l_hrat05,l_hrat01
         	  FROM hrat_file 
         	 WHERE hratid = g_hrdg[g_cnt].hrdg03
          SELECT hrao02 INTO g_hrdg[g_cnt].hrat04 FROM hrao_file WHERE hrao01 = l_hrat04
         	SELECT hrap06 INTO g_hrdg[g_cnt].hrat05 FROM hrap_file WHERE hrap01 = l_hrat04 AND hrap05 = l_hrat05      
        	   LET g_hrdg[g_cnt].hrdg03 = l_hrat01

       #   SELECT hrbo15  INTO g_hrdg[g_cnt].hrbo15_1 FROM hrbo_file WHERE hrbo02 = g_hrdg[g_cnt].hrdg06
        	SELECT hrad03 INTO g_hrdg[g_cnt].hrat19 FROM hrad_file WHERE hrad02 = g_hrdg[g_cnt].hrat19
        	   
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_hrdg.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cnt  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i075_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680102 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hrdg TO s_hrdg.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   
      
      
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
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
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION exporttoexcel   #No.FUN-4B0020
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
#@    ON ACTION 相關文件  
       ON ACTION related_document  #No.MOD-470515
         LET g_action_choice="related_document"
         EXIT DISPLAY
           
      ON ACTION tiaoban
         LET g_action_choice="tiaoban"
         EXIT DISPLAY
        
      ON ACTION remove
         LET g_action_choice="remove"
         EXIT DISPLAY
          
       ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY

      ON ACTION unconfirm
         LET g_action_choice="unconfirm"
         EXIT DISPLAY

      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
#No.FUN-570110 --start                                                          
FUNCTION i075_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1           #No.FUN-680102 VARCHAR(1)
                                                                                
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
     CALL cl_set_comp_entry("hrdg03,hrdg02,hrdg06,hrdg07,hrdg08,hrdg09",TRUE)                                       
   END IF
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) THEN          
     CALL cl_set_comp_entry("hrdg06,hrdg07,hrdg08,hrdg09",TRUE)                                      
   END IF                                                                        
                                                                                
END FUNCTION                                                                    
                                                                                
FUNCTION i075_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
  
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
     CALL cl_set_comp_entry("hrat02,hrat04,hrat05,hrat25,hrat19,hrdg04,hrdg05,hrbo15,hrdg04_name,hrdg06_name,hrbo15_1",FALSE)                                       
   END IF                                                                              
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) THEN          
     CALL cl_set_comp_entry("hrdg02,hrdg03,hrat02,hrat04,hrat05,hrat25,hrat19",FALSE)
     CALL cl_set_comp_entry("hrdg04,hrdg05,hrbo15,hrdg04_name,hrdg06_name,hrbo15_1",FALSE)                                       
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
#No.FUN-570110 --end              
 

FUNCTION i075_confirm(p_cmd) 
  DEFINE p_cmd           LIKE type_file.chr1
  DEFINE l_i,l_n         LIKE type_file.num5
  DEFINE l_count         LIKE type_file.num5
  DEFINE l_massage       STRING
  DEFINE l_hrcpconf      LIKE hrcp_file.hrcpconf 
  DEFINE l_hrcp01        LIKE hrcp_file.hrcp01
  DEFINE l_hratid        LIKE hrat_file.hratid
  
  IF g_rec_b = 0 OR cl_null(g_rec_b) THEN
    RETURN
  END IF 
IF p_cmd = 'Y' THEN 
   IF  cl_confirm('aap-222') THEN
       FOR l_i = 1 TO g_rec_b
        IF g_hrdg[l_i].sure = 'Y' THEN   
           UPDATE hrdg_file SET hrdgconf = p_cmd WHERE hrdg01 = g_hrdg[l_i].hrdg01
           IF SQLCA.sqlcode THEN
              CALL cl_err('g_hrdg[l_i].hrdg01',"ghr-135",0)  
           ELSE
           	  SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01 = g_hrdg[l_i].hrdg03
           	  SELECT COUNT(*) INTO l_n FROM hrcp_file WHERE hrcp02 = l_hratid AND hrcp03 =g_hrdg[l_i].hrdg02
              IF l_n > 0 THEN 
              	UPDATE hrcp_file 
              	   SET hrcp04 = g_hrdg[l_i].hrdg06,
              	       hrcp06 = g_hrdg[l_i].hrdg07,
              	       hrcp35 = 'N',
              	       hrcpacti = 'Y',
              	       hrcporiu = g_user,
              	       hrcporig = g_today
              	 WHERE hrcp02 = l_hratid 
              	   AND hrcp03 =g_hrdg[l_i].hrdg02
              	IF SQLCA.sqlcode THEN
                 	 CALL cl_err('g_hrdg[l_i].hrdg01',"ghr-135",0)  
                END IF 
              ELSE
              	SELECT MAX(hrcp01)+ 1 INTO l_hrcp01 FROM hrcp_file  
              	INSERT INTO hrcp_file 
              	 VALUES(l_hrcp01,l_hratid,g_hrdg[l_i].hrdg02,g_hrdg[l_i].hrdg06,g_hrdg[l_i].hrbo15_1,g_hrdg[l_i].hrdg07,
              	        'N','','','','','','','','','','','','','','','','','','','','','','','','','','','','N','','N','Y','',
              	        '','','','','','','','','','','','','','','','','','',g_grup,g_user)
                IF SQLCA.sqlcode THEN
                 	 CALL cl_err('g_hrdg[l_i].hrdg01',"ghr-135",0)  
                END IF 
              END IF 
           END IF 
        END IF
       END FOR
   END IF
END IF 
	
IF p_cmd = 'N' THEN  
	 FOR l_i = 1 TO g_rec_b
	     IF g_hrdg[l_i].sure = 'Y' THEN 
	        LET l_massage = '   ',g_hrdg[l_i].hrat02,' ( ',g_hrdg[l_i].hrdg03,' ) ','   ',g_hrdg[l_i].hrdg02 	
	        SELECT hrcpconf
	        INTO l_hrcpconf 
	        FROM hrcp_file
	        WHERE hrcp01 = g_hrdg[l_i].hrdg03
	      
	        IF l_hrcpconf = 'Y' THEN 
	      	   CALL cl_err(l_massage,'aap-019',1)
	        ELSE 
	      	   IF cl_confirm2('ghr-109',l_massage) THEN
                UPDATE hrdg_file SET hrdgconf = p_cmd WHERE hrdg01 = g_hrdg[l_i].hrdg01
                IF SQLCA.sqlcode THEN
                 	 CALL cl_err('g_hrdg[l_i].hrdg01',"ghr-135",0)  
                ELSE 
                	 SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01 = g_hrdg[l_i].hrdg03
                   UPDATE hrcp_file 
                      SET hrcp04 = g_hrdg[l_i].hrdg04,
                          hrcp06 = g_hrdg[l_i].hrdg05,
                          hrcp35 = 'N', 
                          hrcpmodu = g_user,
                          hrcpdate = g_today
                    WHERE hrcp02 = l_hratid
                      AND hrcp03 = g_hrdg[l_i].hrdg02
                END IF                    
             END IF 
          END IF
       END IF 
   END FOR
END IF   
	
END FUNCTION 
	
FUNCTION i075_tiaoban() 
  DEFINE l_str           STRING
  DEFINE l_i,l_n,l_j     LIKE type_file.num5
  DEFINE l_count         LIKE type_file.num5
  DEFINE l_hour          LIKE type_file.num5
  DEFINE l_numb          LIKE type_file.num5
  DEFINE l_numb1         LIKE type_file.num5
  DEFINE l_year          LIKE type_file.num5
  DEFINE l_year1         LIKE type_file.num5
  DEFINE l_month         LIKE type_file.num5
  DEFINE l_iac           LIKE type_file.num5
  DEFINE l_cnt           LIKE type_file.num5
  DEFINE l_hrdg06        LIKE hrdg_file.hrdg06
  DEFINE l_hrdg07        LIKE hrdg_file.hrdg07
  DEFINE l_hrdg08        LIKE hrdg_file.hrdg08
  DEFINE l_hrdg09        LIKE hrdg_file.hrdg09
  DEFINE l_hrdg06_name   LIKE type_file.chr100
  DEFINE l_date          LIKE type_file.dat
  DEFINE l_bdate         LIKE type_file.dat
  DEFINE l_hrci03        LIKE hrci_file.hrci03
  DEFINE l_flag          LIKE type_file.chr1
  DEFINE l_flag_1        LIKE type_file.chr1
  DEFINE l_allow_insert  LIKE type_file.num5
  DEFINE l_hrcn03        LIKE hrcn_file.hrcn03
  DEFINE l_record        LIKE type_file.chr1
  DEFINE l_hrat04        LIKE hrat_file.hrat04
  DEFINE l_hrat05        LIKE hrat_file.hrat05
  DEFINE l_hrbo15_2      LIKE hrbo_file.hrbo15

 
               
               
   LET l_flag = 'Y'
   INITIALIZE g_bdate TO NULL
   INITIALIZE g_edate TO NULL
   INITIALIZE g_xinbc TO NULL
   
   OPEN WINDOW i075_w1  WITH FORM "ghr/42f/ghri075_1"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   CALL cl_ui_locale("ghri075_1")
   CALL cl_set_label_justify("i075_w1","right")
   CALL cl_set_comp_visible("hrdg01",FALSE) 

  
   CALL i075_1_q()
  
   CALL cl_opmsg('b')
 
   LET l_allow_insert = cl_detail_input_auth("insert")
	
	 CALL i075_tmp()
	 CALL i075_tmp_t()
	 
   CALL cl_set_comp_entry("hrdg01,hrdg03,hrdg02,hrdg04,hrdg05,hrat02,hrat04,hrbo15_1",FALSE)
   CALL cl_set_comp_entry("hrat05,hrat25,hrat19,hrdg04_name,hrdg06_name,hrbo15_2",FALSE)
   CALL cl_set_comp_entry("sure,hrdg06,hrdg07,hrdg08",TRUE)
   
	INPUT ARRAY g_hrdg_1 WITHOUT DEFAULTS FROM s_hrdg_1.*
         ATTRIBUTE (COUNT=g_rec_b_1,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW = l_allow_insert,DELETE ROW=FALSE,APPEND ROW=FALSE) 
 
      BEFORE INPUT
         IF g_rec_b_1 != 0 THEN
            CALL fgl_set_arr_curr(l_iac)
         END IF
         CALL g_hrdg_1_t.clear()
         FOR l_i = 1 TO g_rec_b_1
             LET g_hrdg_1_t[l_i].* = g_hrdg_1[l_i].*
         END FOR  
             
         	
   	          
      BEFORE ROW
          LET l_iac = ARR_CURR()
           
          
          ON ACTION sel_all
             LET l_i = 0
#             IF l_flag_1 = 'Y' THEN 
#                CALL i075_tmp_t()
#                LET l_flag_1 = 'N'
#             END IF 
             FOR l_i = 1 TO g_rec_b_1
                 LET g_hrdg_1[l_i].sure = 'Y'
#                 IF g_hrdg_1[l_i].sure = 'Y' THEN 
#                    IF NOT cl_null(g_hrdg_1[l_i].hrdg01) THEN 
#          	           SELECT hrdg06, hrdg07, hrdg08, hrdg09 INTO l_hrdg06,l_hrdg07,l_hrdg08,l_hrdg09
#          	             FROM hrdg_file
#          	            WHERE hrdg01 = g_hrdg_1[l_i].hrdg01
#          	           SELECT hrbo03,hrbo15 INTO l_hrdg06_name,l_hrbo15_2 FROM hrbo_file WHERE hrbo02 = l_hrdg06
#                       INSERT INTO hrdg_tmp_t
#                       VALUES('N',g_hrdg_1[l_i].hrdg01,g_hrdg_1[l_i].hrdg03,g_hrdg_1[l_i].hrat02,g_hrdg_1[l_i].hrat04,
#                              g_hrdg_1[l_i].hrat05,g_hrdg_1[l_i].hrat25,g_hrdg_1[l_i].hrat19,g_hrdg_1[l_i].hrdg02,
#                              g_hrdg_1[l_i].hrdg04,g_hrdg_1[l_i].hrdg04_name,g_hrdg_1[l_i].hrdg05,g_hrdg_1[l_i].hrbo15_1,
#                              l_hrdg06,l_hrdg06_name,l_hrdg07,l_hrbo15_2,l_hrdg08,l_hrdg09)
#                    ELSE 
#          	           INSERT INTO hrdg_tmp_t
#                       VALUES('N','',g_hrdg_1[l_iac].hrdg03,'','','','','',
#                              g_hrdg_1[l_iac].hrdg02,'','','','','','','','','','')
#                    END IF 
#                 END IF
             END FOR 
          
          ON ACTION sel_none
             LET l_i = 0
             FOR l_i = 1 TO g_rec_b_1
                 LET g_hrdg_1[l_i].sure = 'N'
#                 DROP TABLE hrdg_tmp_t
#                 LET l_flag_1 = 'Y'
             END FOR
                 	  
          ON ACTION xinbanci
             LET l_record = 'N'
             FOR l_i = 1 TO g_rec_b_1
                 IF g_hrdg_1[l_i].sure = 'Y' THEN
                 	 LET l_record = 'Y'
                 	 EXIT FOR    
                 END IF
             END FOR
             IF l_record = 'N' THEN 
             	  CALL cl_err('','ghr-156',0)
             END IF
             IF l_record = 'Y' THEN
                CALL i075_2()
                FOR l_i = 1 TO g_rec_b_1
                    IF g_hrdg_1[l_i].sure = 'Y' THEN
                       LET g_hrdg_1[l_i].hrdg06 = g_hrdg_t_t.hrdg06 
                       LET g_hrdg_1[l_i].hrdg07 = g_hrdg_t_t.hrdg07
                       LET g_hrdg_1[l_i].hrdg08 = g_hrdg_t_t.hrdg08
                       SELECT hrbo03 INTO g_hrdg_1[l_i].hrdg06_name FROM hrbo_file WHERE hrbo02 = g_hrdg_1[l_i].hrdg06
                    END IF
                END FOR
             END IF
             	
          ON ACTION go_on
             LET g_flag = 'Y'	
             EXIT INPUT 
                 
                                                       
      AFTER ROW
         LET l_iac = ARR_CURR()
#         IF l_flag_1 = 'Y' THEN 
#            CALL i075_tmp_t()
#            LET l_flag_1 = 'N'
#         END IF 
#         IF g_hrdg_1[l_iac].sure = 'Y' THEN 
#          IF NOT cl_null(g_hrdg_1[l_iac].hrdg01) THEN 
#          	 SELECT hrdg06, hrdg07, hrdg08, hrdg09 INTO l_hrdg06,l_hrdg07,l_hrdg08,l_hrdg09
#          	   FROM hrdg_file
#          	  WHERE hrdg01 = g_hrdg_1[l_iac].hrdg01
#          	  SELECT hrbo03 INTO l_hrdg06_name FROM hrbo_file WHERE hrbo02 = l_hrdg06
#             INSERT INTO hrdg_tmp_t
#                VALUES('N',g_hrdg_1[l_iac].hrdg01,g_hrdg_1[l_iac].hrdg03,g_hrdg_1[l_iac].hrat02,g_hrdg_1[l_iac].hrat04,
#                       g_hrdg_1[l_iac].hrat05,g_hrdg_1[l_iac].hrat25,g_hrdg_1[l_iac].hrat19,g_hrdg_1[l_iac].hrdg02,
#                       g_hrdg_1[l_iac].hrdg04,g_hrdg_1[l_iac].hrdg04_name,g_hrdg_1[l_iac].hrdg05,g_hrdg_1[l_iac].hrbo15_1,
#                       g_hrdg_1[l_iac].hrdg06,g_hrdg_1[l_iac].hrdg06_name,g_hrdg_1[l_iac].hrdg07,g_hrdg_1[l_iac].hrbo15_2,l_hrdg08,l_hrdg09)
#          ELSE 
#          	 INSERT INTO hrdg_tmp_t
#                VALUES('N','',g_hrdg_1[l_iac].hrdg03,'','','','','',
#                        g_hrdg_1[l_iac].hrdg02,'','','','','','','','','','')
#          END IF 
#         END IF
         LET g_max = 0
         
         AFTER FIELD hrdg06
         IF NOT cl_null(g_hrdg_1[l_iac].hrdg06) THEN 
         	  SELECT hrbo03 INTO g_hrdg_1[l_iac].hrdg06_name FROM hrbo_file WHERE hrbo02 = g_hrdg_1[l_iac].hrdg06
         END IF
         	DISPLAY BY NAME g_hrdg_1[l_iac].hrdg06_name
                   
 	       ON CHANGE hrdg06
 	          LET g_hrdg_1[l_iac].sure = 'Y'
# 	          IF NOT cl_null(g_hrdg_1[l_iac].hrdg01) THEN 
#          	   SELECT hrdg06, hrdg07, hrdg08, hrdg09 INTO l_hrdg06,l_hrdg07,l_hrdg08,l_hrdg09
#          	     FROM hrdg_file
#          	    WHERE hrdg01 = g_hrdg_1[l_iac].hrdg01
#          	   SELECT hrbo03 INTO l_hrdg06_name FROM hrbo_file WHERE hrbo02 = l_hrdg06
#               INSERT INTO hrdg_tmp_t
#               VALUES('N',g_hrdg_1[l_iac].hrdg01,g_hrdg_1[l_iac].hrdg03,g_hrdg_1[l_iac].hrat02,g_hrdg_1[l_iac].hrat04,
#                       g_hrdg_1[l_iac].hrat05,g_hrdg_1[l_iac].hrat25,g_hrdg_1[l_iac].hrat19,g_hrdg_1[l_iac].hrdg02,
#                       g_hrdg_1[l_iac].hrdg04,g_hrdg_1[l_iac].hrdg04_name,g_hrdg_1[l_iac].hrdg05,g_hrdg_1[l_iac].hrbo15_1,
#                       g_hrdg_1[l_iac].hrdg06,g_hrdg_1[l_iac].hrdg06_name,g_hrdg_1[l_iac].hrdg07,g_hrdg_1[l_iac].hrbo15_2,l_hrdg08,l_hrdg09)
#            ELSE 
#          	   INSERT INTO hrdg_tmp_t
#               VALUES('N','',g_hrdg_1[l_iac].hrdg03,'','','','','',
#                        g_hrdg_1[l_iac].hrdg02,'','','','','','','','','','')
#            END IF
 	          DISPLAY BY NAME g_hrdg_1[l_iac].sure
 	          
 	        ON CHANGE hrdg07
 	          LET g_hrdg_1[l_iac].sure = 'Y'
 	          DISPLAY BY NAME g_hrdg_1[l_iac].sure
 	          
 	        ON CHANGE hrdg08
 	          LET g_hrdg_1[l_iac].sure = 'Y'
 	          DISPLAY BY NAME g_hrdg_1[l_iac].sure
          	
          AFTER INPUT 
             IF INT_FLAG THEN              
                CALL cl_err('',9001,0) 
                LET INT_FLAG = 0 
                LET l_flag = 'N' 
                LET g_chus = 100     
                EXIT INPUT
             END IF
         	   LET l_i = 0
             LET l_j = 0
             LET g_rec_b = 0
             FOR l_i = 1 TO g_rec_b_1 
                 IF g_hrdg_1[l_i].sure = 'Y' THEN 
                  	LET l_j = l_j + 1
                 	  
                 	  LET g_hrdg[l_j].hrdg06 = g_hrdg_1[l_i].hrdg06
                 	  LET g_hrdg[l_j].hrdg07 = g_hrdg_1[l_i].hrdg07
                 	  LET g_hrdg[l_j].hrdg08 = g_hrdg_1[l_i].hrdg08
                 	  
                 	     SELECT COUNT(*) INTO l_cnt FROM hrdg_file 
                 	      WHERE hrdg02 = g_hrdg_1[l_i].hrdg02
                 	        AND hrdg03 = g_hrdg_1[l_i].hrdg03 
                 	        
                 	  IF l_cnt > 0 THEN 
                 	  	SELECT hrdg01 INTO g_hrdg_1[l_i].hrdg01 FROM hrdg_file WHERE hrdg02 = g_hrdg_1[l_i].hrdg02 AND hrdg03 = g_hrdg_1[l_i].hrdg03
                 	  	
                 	  	 UPDATE hrdg_file
                 	  	    SET hrdg06 = g_hrdg_1[l_i].hrdg06,
                 	            hrdg07 = g_hrdg_1[l_i].hrdg07,
                 	            hrdg08 = g_hrdg_1[l_i].hrdg08,
                 	            hrdgmodu = g_user,
                 	            hrdgdate = g_today
                        WHERE hrdg01 = g_hrdg_1[l_i].hrdg01
                        
                       IF SQLCA.sqlcode THEN
                 	  	    CALL cl_err('g_hrdg[l_i].hrdg01',"ghr-135",0)  
                       ELSE 
                       	SELECT hrdg03,hrdg02,hrdg09,hrat02,hrat04,hrat05,hrat25,hrat19
                 	        INTO g_hrdg[l_j].hrdg03,g_hrdg[l_j].hrdg02,g_hrdg[l_j].hrdg09,
                 	             g_hrdg[l_j].hrat02,l_hrat04,l_hrat05,
                               g_hrdg[l_j].hrat25,g_hrdg[l_j].hrat19
                          FROM hrdg_file left join hrat_file on hrdg03 = hratid   
                         WHERE hrdg01 = g_hrdg_1[l_i].hrdg01 
                         
                        SELECT hrbo03,hrbo15 INTO g_hrdg[l_j].hrdg06_name,g_hrdg[l_j].hrbo15_1
                          FROM hrbo_file
                         WHERE hrbo02 = g_hrdg[l_j].hrdg06
                         
                        
                        SELECT hrbo03,hrbo15 INTO g_hrdg[l_j].hrdg04_name,g_hrdg[l_j].hrbo15
                          FROM hrbo_file
                         WHERE hrbo02 = g_hrdg_1_t[l_i].hrdg04
                         
                        SELECT hrao02 INTO g_hrdg[l_j].hrat04 FROM hrao_file WHERE hrao01 = l_hrat04      #added NO.130806
                      	SELECT hrap06 INTO g_hrdg[l_j].hrat05 FROM hrap_file WHERE hrap01 = l_hrat04 AND hrap05 = l_hrat05 #added NO.130806

                          INSERT INTO hrdg_tmp 
                 	        VALUES('N',g_hrdg_1[l_i].hrdg01,g_hrdg[l_j].hrdg03,g_hrdg[l_j].hrat02,g_hrdg[l_j].hrat04,g_hrdg[l_j].hrat05,
                 	               g_hrdg[l_j].hrat25,g_hrdg[l_j].hrat19,g_hrdg[l_j].hrdg02,g_hrdg[l_j].hrdg04,
                 	               g_hrdg[l_j].hrdg04_name,g_hrdg[l_j].hrdg05,g_hrdg[l_j].hrbo15,g_hrdg[l_j].hrdg06,g_hrdg[l_j].hrdg06_name,
                 	               g_hrdg[l_j].hrdg07,g_hrdg[l_j].hrbo15_1,g_hrdg[l_j].hrdg08,g_hrdg[l_j].hrdg09)
                 	        INSERT INTO hrdg_tmp_t
                 	        VALUES('N',g_hrdg_1[l_i].hrdg01)
                 	           LET g_max = g_max + 1
                       END IF
                    ELSE
                    	 SELECT to_char(MAX(hrdg01)+1,'fm0000000000') INTO g_hrdg01 FROM hrdg_file
                    	     IF cl_null(g_hrdg01) THEN 
                    	     	  LET g_hrdg01 = '0000000001'
                    	     END IF 
                 	     INSERT INTO hrdg_file 
                 	          VALUES (g_hrdg01,g_hrdg_1[l_i].hrdg02,g_hrdg_1[l_i].hrdg03,g_hrdg_1_t[l_i].hrdg04,
                 	                  g_hrdg_1_t[l_i].hrdg05,g_hrdg_1[l_i].hrdg06,g_hrdg_1[l_i].hrdg07,g_hrdg_1[l_i].hrdg08,
                 	                  '','N','Y','','','','','','','','','','','','','','','',
                 	                  g_user,g_grup,'','',g_grup,g_user)
                 	                  
                 	     IF SQLCA.sqlcode THEN
                 	  	    CALL cl_err('g_dg01',"ghr-135",0)  
                       ELSE          
                 	        SELECT hrdg03,hrdg02,hrdg09,hrat02,hrat04,hrat05,hrat25,hrat19
                 	          INTO g_hrdg[l_j].hrdg03,g_hrdg[l_j].hrdg02,g_hrdg[l_j].hrdg09,
                 	               g_hrdg[l_j].hrat02,l_hrat04,l_hrat05,
                                 g_hrdg[l_j].hrat25,g_hrdg[l_j].hrat19
                            FROM hrdg_file left join hrat_file on hrdg03 = hratid   
                           WHERE hrdg01 = g_hrdg01 
                           
                          SELECT hrbo03,hrbo15 INTO g_hrdg[l_j].hrdg06_name,g_hrdg[l_j].hrbo15_1
                            FROM hrbo_file
                           WHERE hrbo02 = g_hrdg[l_j].hrdg06
                           
                        
                          SELECT hrbo03,hrbo15 INTO g_hrdg[l_j].hrdg04_name,g_hrdg[l_j].hrbo15
                            FROM hrbo_file
                           WHERE hrbo02 = g_hrdg_1_t[l_i].hrdg04
                          
                        SELECT hrao02 INTO g_hrdg[l_j].hrat04 FROM hrao_file WHERE hrao01 = l_hrat04      #added NO.130806
                      	SELECT hrap06 INTO g_hrdg[l_j].hrat05 FROM hrap_file WHERE hrap01 = l_hrat04 AND hrap05 = l_hrat05 #added NO.130806
                      	
                          INSERT INTO hrdg_tmp 
                 	        VALUES('N',g_hrdg01,g_hrdg[l_j].hrdg03,g_hrdg[l_j].hrat02,g_hrdg[l_j].hrat04,g_hrdg[l_j].hrat05,
                 	               g_hrdg[l_j].hrat25,g_hrdg[l_j].hrat19,g_hrdg[l_j].hrdg02,g_hrdg_1_t[l_i].hrdg04,
                 	               g_hrdg[l_j].hrdg04_name,g_hrdg_1_t[l_i].hrdg05,g_hrdg[l_j].hrbo15,g_hrdg[l_j].hrdg06,g_hrdg[l_j].hrdg06_name,
                 	               g_hrdg[l_j].hrdg07,g_hrdg[l_j].hrbo15_1,g_hrdg[l_j].hrdg08,g_hrdg[l_j].hrdg09)
                 	        INSERT INTO hrdg_tmp_t
                 	        VALUES('Y',g_hrdg01)
                 	           LET g_max = g_max + 1
                       END IF 
                    END IF
                 END IF  
             END FOR 
      
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
          
       ON ACTION controlp
          CASE 
          	WHEN INFIELD(hrdg06)
              CALL cl_init_qry_var() 
              LET g_qryparam.form = "q_hrbo02"
              LET g_qryparam.default1 = g_hrdg_1[l_iac].hrdg06
              CALL cl_create_qry() RETURNING g_hrdg_1[l_iac].hrdg06
              DISPLAY BY NAME g_hrdg_1[l_iac].hrdg06
              NEXT FIELD hrdg06
            OTHERWISE
              EXIT CASE 
          END CASE              
 
   END INPUT          
   
     CLOSE WINDOW i075_w1   
     
END FUNCTION
	

	
FUNCTION i075_1_q()     #the point pay more attention
	DEFINE 
    l_ac_t             LIKE type_file.num5,                 
    l_n                LIKE type_file.num5, 
    l_i                LIKE type_file.num5,                 
    l_lock_sw          LIKE type_file.chr1,                 
    p_cmd              LIKE type_file.chr1,                
    l_allow_insert     LIKE type_file.chr1,                 
    l_allow_delete     LIKE type_file.chr1
  DEFINE  l_hrcb01     LIKE hrcb_file.hrcb01,
          l_hrdg02     LIKE hrdg_file.hrdg02,
          l_hrdg03     LIKE hrdg_file.hrdg03,
          l_hrdg04     LIKE hrdg_file.hrdg04,
          l_hratid     LIKE hrat_file.hratid,
          l_hrat03     LIKE hrat_file.hrat03,
          l_hrat04     LIKE hrat_file.hrat04,
          l_hrat05     LIKE hrat_file.hrat05,
          l_hrdgconf   LIKE hrdg_file.hrdgconf,
          l_hrat25     LIKE hrat_file.hrat25,
          l_hraz05     LIKE hraz_file.hraz05,
          l_hraz08     LIKE hraz_file.hraz08,
          l_hraz31     LIKE hraz_file.hraz31,
          l_hrbo03     LIKE hrbo_file.hrbo03
    
    CLEAR FORM
    CALL g_hrdg_1.clear()

    INPUT g_bdate,g_edate,g_xinbc WITHOUT DEFAULTS FROM bdate,edate,xinbc
    
    BEFORE INPUT
       LET g_bdate=g_today
       LET g_edate=g_today
       DISPLAY g_bdate TO bdate
       DISPLAY g_edate TO edate
    
    AFTER FIELD xinbc
       IF NOT cl_null(g_xinbc) THEN
       	  SELECT hrbo03 INTO l_hrbo03 FROM hrbo_file WHERE hrbo02 = g_xinbc
          DISPLAY l_hrbo03 TO FORMONLY.xinbc_name
       END IF 
       	
    AFTER FIELD bdate
       IF cl_null(g_bdate) THEN 
       	  NEXT FIELD bdate
       END IF
       	
    AFTER FIELD edate
       IF cl_null(g_edate) THEN 
       	  NEXT FIELD edate
       END IF
       	  
    ON ACTION controlp
         CASE
            WHEN INFIELD(xinbc)
              CALL cl_init_qry_var() 
              LET g_qryparam.form = "q_hrbo02"
              LET g_qryparam.default1 = g_xinbc
              CALL cl_create_qry() RETURNING g_xinbc
              NEXT FIELD xinbc
            OTHERWISE
              EXIT CASE   

         END CASE    
    ON ACTION CONTROLR
       CALL cl_show_req_fields()
          
    ON ACTION CONTROLG
       CALL cl_cmdask()
          
    ON IDLE g_idle_seconds
       CALL cl_on_idle()
       CONTINUE INPUT
          
    ON ACTION about
       CALL cl_about()
          
    ON ACTION help
       CALL cl_show_help()
       
    END INPUT
    
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLEAR FORM
       RETURN
    END IF
    
    CONSTRUCT g_wc ON hrdg03,hrat02,hrat04,hrat05,hrat25,hrat19
         FROM s_hrdg_1[1].hrdg03,s_hrdg_1[1].hrat02,s_hrdg_1[1].hrat04,
         s_hrdg_1[1].hrat05,s_hrdg_1[1].hrat25,s_hrdg_1[1].hrat19
              
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
         
         
       AFTER FIELD hrdg03
         LET l_hrdg03 = GET_FLDBUF(hrdg03)
         IF NOT cl_null(l_hrdg03) THEN
         	  LET g_hrdg_1[1].hrdg03 = l_hrdg03 
         	  SELECT COUNT(*) INTO l_n FROM hrat_file WHERE hrat01 = g_hrdg_1[1].hrdg03
         	  IF l_n > 0 THEN 
           	   SELECT hrat02,hrat04,hrat05,hrat25,hrat19,hratid  
         	       INTO g_hrdg_1[1].hrat02,g_hrdg_1[1].hrat04,g_hrdg_1[1].hrat05,g_hrdg_1[1].hrat25,g_hrdg_1[1].hrat19,l_hratid
         	       FROM hrat_file 
         	      WHERE hrat01 = g_hrdg_1[1].hrdg03 
         	        LET g_hrdg_1[1].hrdg03 = l_hratid
         	  ELSE 
         	  	 SELECT hrat02,hrat04,hrat05,hrat25,hrat19  
         	       INTO g_hrdg_1[1].hrat02,g_hrdg_1[1].hrat04,g_hrdg_1[1].hrat05,g_hrdg_1[1].hrat25,g_hrdg_1[1].hrat19
         	       FROM hrat_file 
         	      WHERE hratid = g_hrdg_1[1].hrdg03 
         	  END IF 
         END IF
         DISPLAY BY NAME g_hrdg_1[1].hrat02,g_hrdg_1[1].hrat04,g_hrdg_1[1].hrat05,g_hrdg_1[1].hrat25,g_hrdg_1[1].hrat19,g_hrdg_1[1].hrdg03
         
  	     	              
         
         
      ON ACTION controlp
         CASE
            WHEN INFIELD(hrdg03)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrat"
              LET g_qryparam.default1 = g_hrdg_1[1].hrdg03
              CALL cl_create_qry() RETURNING g_hrdg_1[1].hrdg03
              DISPLAY BY NAME g_hrdg_1[1].hrdg03
              SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01 = g_hrdg_1[1].hrdg03
              LET g_hrdg_1[1].hrdg03 = l_hratid
              NEXT FIELD hrdg03
            WHEN INFIELD(hrat04)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrao01"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO hrat04
              NEXT FIELD hrat04
            WHEN INFIELD(hrat05)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrap01"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO hrat05
              NEXT FIELD hrat05
            WHEN INFIELD(hrat19)
              CALL cl_init_qry_var() 
              LET g_qryparam.form = "q_hrad02"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO hrat19
              NEXT FIELD hrat19
            
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
	   CALL i075_1_b_fill(g_wc)
	   
	   IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        LET g_wc = NULL
        RETURN
     END IF 
END FUNCTION
	
FUNCTION i075_1_b_fill(p_wc)   #the point pay more attention
	DEFINE p_wc       STRING
	
	IF cl_null(p_wc) THEN 
		 LET p_wc = "1=1"
	END IF
		 	
	LET p_wc = cl_replace_str(p_wc,'hrdg03','hrcp02')
  
  IF NOT cl_null(g_xinbc) THEN 
     LET g_sql = "  SELECT 'N',hrdg01,hrcp02,hrat02,hrcp03,hrcp04,hrbo03,hrdg05,hrcp05,hrcp04,hrbo03,hrdg05,hrcp05,hrdg08,hrat04,hrat05,hrat25,hrat19  ",
	            "    FROM  hrcp_file  left join hrat_file on hrcp02 = hratid   ",
	            "    left join hrbo_file on hrcp04 = hrbo02 ",
	            "    left join hrdg_file on hrcp03 = hrdg02 and hrcp02 = hrdg03 and hrdgacti = 'Y' and hrdgconf ='N' ",
	            "   WHERE  hrcpconf = 'N'  ",
	            "     AND  hrcpacti = 'Y'  ",
	            "     AND  ",p_wc  CLIPPED,
	            "     AND  hrcp03 >= '",g_bdate,"' ", 
	            "     AND  hrcp03 <= '",g_edate,"' ",
	            "     AND  hrcp04 = '",g_xinbc,"' "
	ELSE 
		 LET g_sql = "  SELECT 'N',hrdg01,hrcp02,hrat02,hrcp03,hrcp04,hrbo03,hrdg05,hrcp05,hrcp04,hrbo03,hrdg05,hrcp05,hrdg08,hrat04,hrat05,hrat25,hrat19  ",
	            "    FROM  hrcp_file  left join hrat_file on hrcp02 = hratid   ",
	            "    left join hrbo_file on hrcp04 = hrbo02 ",
	            "    left join hrdg_file on hrcp03 = hrdg02 and hrcp02 = hrdg03 and hrdgacti = 'Y' and hrdgconf ='N' ",
	            "   WHERE  hrcpconf = 'N'  ",
	            "     AND  hrcpacti = 'Y'  ",
	            "     AND  ",p_wc  CLIPPED,
	            "     AND  hrcp03 >= '",g_bdate,"' ", 
	            "     AND  hrcp03 <= '",g_edate,"' "
	END IF 
	            
	LET p_wc = cl_replace_str(p_wc,'hrcp02','hrdq03')
  
  IF NOT cl_null(g_xinbc) THEN
     LET g_sql = g_sql,  "   union all ",
	                   "  SELECT 'N',hrdg01,hrdq03,hrat02,hrdq05,hrdq06,hrdq07,hrdg05,hrbo15,hrdq06,hrdq07,hrdg05,hrbo15,hrdg08,hrat04,hrat05,hrat25,hrat19  ",
	                   "    FROM  hrdq_file  left join hrat_file on hrdq03 = hratid   ",
	                   "    left join hrbo_file on hrdq06 = hrbo02 ",
	                   "    left join hrdg_file on hrdq05 = hrdg02 and hrdq03 = hrdg03 and hrdgacti = 'Y' and hrdgconf ='N' ",
	                   "   WHERE  ",p_wc  CLIPPED,
	            "     AND  hrdq05 >= '",g_bdate,"' ", 
	            "     AND  hrdq05 <= '",g_edate,"' ",
	            "     AND  hrdq06 = '",g_xinbc,"' ",
	            "     AND  hrdq02 = '1' "
	ELSE 
		 LET g_sql = g_sql,  "   union all ",
	                   "  SELECT 'N',hrdg01,hrdq03,hrat02,hrdq05,hrdq06,hrdq07,hrdg05,hrbo15,hrdq06,hrdq07,hrdg05,hrbo15,hrdg08,hrat04,hrat05,hrat25,hrat19  ",
	                   "    FROM  hrdq_file  left join hrat_file on hrdq03 = hratid   ",
	                   "    left join hrbo_file on hrdq06 = hrbo02 ",
	                   "    left join hrdg_file on hrdq05 = hrdg02 and hrdq03 = hrdg03 and hrdgacti = 'Y' and hrdgconf ='N' ",
	                   "   WHERE  ",p_wc  CLIPPED,
	            "     AND  hrdq05 >= '",g_bdate,"' ", 
	            "     AND  hrdq05 <= '",g_edate,"' ",
	            "     AND  hrdq02 = '1' "
	END IF 

	            
	PREPARE i075_1_pb FROM g_sql
  DECLARE i075_1_curs CURSOR FOR i075_1_pb 
  
   CALL g_hrdg_1.clear()
   LET g_cnt = 1 
   MESSAGE "Searching!" 
   FOREACH i075_1_curs INTO g_hrdg_1[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF
        
        SELECT hrap06 INTO g_hrdg_1[g_cnt].hrat05 FROM hrap_file WHERE hrap01 = g_hrdg_1[g_cnt].hrat04 AND hrap05 = g_hrdg_1[g_cnt].hrat05 #added NO.130806
        SELECT hrao02 INTO g_hrdg_1[g_cnt].hrat04 FROM hrao_file WHERE hrao01 = g_hrdg_1[g_cnt].hrat04      #added NO.130806
        SELECT hrad03 INTO g_hrdg_1[g_cnt].hrat19 FROM hrad_file WHERE hrad02 = g_hrdg_1[g_cnt].hrat19
        	
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
   END FOREACH
   CALL g_hrdg_1.deleteElement(g_cnt)
   
   DISPLAY ARRAY g_hrdg_1 TO s_hrdg_1.* ATTRIBUTE(COUNT=g_max_rec,UNBUFFERED)
   
        BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )
            EXIT DISPLAY 
            
   END DISPLAY 
   
   MESSAGE ""
   LET g_rec_b_1 = g_cnt-1
   DISPLAY g_rec_b_1 TO FORMONLY.cnt1  
   LET g_cnt = 0
	          
END FUNCTION  

FUNCTION i075_b_fill_1()
	
	DECLARE i075_cl CURSOR FOR SELECT * FROM hrdg_tmp
   
    LET g_cnt = 1
    MESSAGE "Searching!"
    CALL g_hrdg.clear() 
    FOREACH i075_cl INTO g_hrdg[g_cnt].*   
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF  
        	      
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    DROP TABLE hrdg_tmp
    CALL g_hrdg.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cnt
 #   LET g_cnt2 = g_cnt-1
    LET g_cnt = 0
    LET g_record = 1
      
END FUNCTION 
	
	
FUNCTION i075_tmp()
   CREATE TEMP TABLE hrdg_tmp
   (
    sure         VARCHAR(1),
    hrdg01       DEC(15), 
    hrdg03       VARCHAR(60), 
    hrat02       VARCHAR(50), 
    hrat04       VARCHAR(20),
    hrat05       VARCHAR(50), 
    hrat25       DATE,
    hrat19       VARCHAR(10),
    hrdg02       DATE, 
    hrdg04       VARCHAR(60), 
    hrdg04_name  VARCHAR(60), 
    hrdg05       VARCHAR(60),
    hrbo15       VARCHAR(255),
    hrdg06       VARCHAR(60), 
    hrdg06_name  VARCHAR(60),
    hrdg07       VARCHAR(60),
    hrbo15_1     VARCHAR(255), 
    hrdg08       VARCHAR(255), 
    hrdg09       VARCHAR(255)
    )
END FUNCTION
	
FUNCTION i075_tmp_t()
   CREATE TEMP TABLE hrdg_tmp_t
   (
    sure         VARCHAR(1),
    hrdg01       DEC(15) 
#   ,hrdg03       VARCHAR(60), 
#    hrat02       VARCHAR(50), 
#    hrat04       VARCHAR(20),
#    hrat05       VARCHAR(50), 
#    hrat25       DATE,
#    hrat19       VARCHAR(10),
#    hrdg02       DATE, 
#    hrdg04       VARCHAR(60), 
#    hrdg04_name  VARCHAR(60), 
#    hrdg05       VARCHAR(60),
#    hrbo15       VARCHAR(255),
#    hrdg06       VARCHAR(60), 
#    hrdg06_name  VARCHAR(60),
#    hrdg07       VARCHAR(60),
#    hrbo15_1     VARCHAR(255), 
#    hrdg08       VARCHAR(255), 
#    hrdg09       VARCHAR(255)  
    )
END FUNCTION
	
FUNCTION i075_sel_all(p_flag)
 DEFINE  p_flag  LIKE type_file.chr1 
 DEFINE  l_i     LIKE type_file.num5
 
  IF cl_null(g_rec_b) OR g_rec_b = 0 THEN
     RETURN
  END IF
  FOR l_i = 1 TO g_rec_b
    LET g_hrdg[l_i].sure = p_flag
    DISPLAY BY NAME g_hrdg[l_i].sure
  END FOR
 
  CALL g_hrdg.deleteElement(l_i)
   
  CALL ui.Interface.refresh()

END FUNCTION
	
FUNCTION i075_2()
	DEFINE l_ac,l_i     LIKE type_file.num5
	DEFINE hrdg06_name  LIKE type_file.chr100
	DEFINE l_flag       LIKE type_file.chr1
	DEFINE l_wc,l_string     STRING
	       
	       
	 LET l_flag = 'Y'
   OPEN WINDOW i075_w2  WITH FORM "ghr/42f/ghri075_2"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   CALL cl_ui_locale("ghri075_2")
   CALL cl_set_label_justify("i075_w2","right")      
	       
	
	 DISPLAY g_hrdg_t_t.hrdg06,g_hrdg_t_t.hrdg07,g_hrdg_t_t.hrdg08
	      TO hrdg06,hrdg07,hrdg08       
	
	 INPUT  g_hrdg_t_t.hrdg06,g_hrdg_t_t.hrdg07,g_hrdg_t_t.hrdg08
          WITHOUT DEFAULTS 
    FROM  hrdg06,hrdg07,hrdg08
    
    AFTER FIELD hrdg06 
       IF NOT cl_null(g_hrdg_t_t.hrdg06) THEN 
       	 SELECT hrbo03 INTO hrdg06_name FROM hrbo_file WHERE hrbo02 = g_hrdg_t_t.hrdg06
         DISPLAY hrdg06_name TO FORMONLY.hrdg06_name
       END IF 
       	
    CASE  	
      WHEN INFIELD(hrdg07) 
        CALL cl_err('','ghr-149',1)
      OTHERWISE
        EXIT CASE 
    END CASE
#added by yeap NO.130822-----str------------    	
    ON ACTION controlp 	         
       CASE 
       	  WHEN INFIELD(hrdg06)
               CALL cl_init_qry_var() 
               LET g_qryparam.form = "q_hrbo02"
               LET g_qryparam.default1 = g_hrdg_t_t.hrdg06
               CALL cl_create_qry() RETURNING g_hrdg_t_t.hrdg06
               DISPLAY BY NAME g_hrdg_t_t.hrdg06
               NEXT FIELD hrdg06
          OTHERWISE 
               EXIT CASE 
       END CASE 
#added by yeap NO.130822-----end------------        	

    END INPUT 
    
    IF INT_FLAG THEN
    	 LET g_chus = 50                     
       LET INT_FLAG = 0 
       CALL cl_err('',9001,0)
       CLOSE WINDOW i075_w2
       RETURN 
    ELSE 
    	 LET g_chus = 10
    	 CLOSE WINDOW i075_w2
       RETURN 
    END IF
    	
  CLOSE WINDOW i075_w2	
END FUNCTION 
	
FUNCTION i075_choose(p_cmd)  #added by yeap NO.130801
	DEFINE
    l_ac_t          LIKE type_file.num5,                 
    l_n             LIKE type_file.num5, 
    l_i             LIKE type_file.num5,                 
    l_lock_sw       LIKE type_file.chr1,                 
    p_cmd           LIKE type_file.chr1,                 
    l_allow_insert  LIKE type_file.chr1,                 
    l_allow_delete  LIKE type_file.chr1 
     
    IF g_rec_b <= 0 THEN 
       CALL cl_err('','ghr-121',1)
       RETURN 
    END IF    
 
    CALL  cl_set_comp_visible('sure',TRUE)
    CALL cl_set_comp_entry("hrdg01,hrdg03,hrat02,hrat04,hrat05,hrat25,hrat19,hrdg02,hrbo15",FALSE)
    CALL cl_set_comp_entry("hrdg04,hrdg04_name,hrdg05,hrdg06,hrdg06_name,hrdg07,hrdg08,hrdg09",FALSE)
    INPUT ARRAY g_hrdg  WITHOUT DEFAULTS FROM s_hrdg.*
          ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_rec_b,  UNBUFFERED,
                     INSERT ROW = FALSE,DELETE ROW=FALSE,APPEND ROW=TRUE) 
 
    BEFORE INPUT
        CALL cl_set_act_visible("accept,cancel",TRUE)
        FOR l_i = 1 TO g_rec_b
            LET g_hrdg[l_i].sure = 'N'
            DISPLAY BY NAME g_hrdg[l_i].sure
        END FOR 		
       	
    BEFORE ROW
        LET l_ac = ARR_CURR()
        LET l_n  = ARR_COUNT()
        
    	
      ON ACTION sel_all
         LET g_action_choice="sel_all" 
         CALL i075_sel_all('Y') 
      ON ACTION sel_none
         LET g_action_choice="sel_none"   
         CALL i075_sel_all('N')
      ON ACTION accept
         CALL i075_confirm(p_cmd)
         EXIT INPUT 
      ON ACTION controlg 
         LET g_action_choice="controlg"
         CALL cl_cmdask() 
         EXIT INPUT                          
     END INPUT 
     FOR l_i = 1 TO g_rec_b
             LET g_hrdg[l_i].sure = 'N'
     END FOR   
     CALL cl_set_comp_visible('sure',FALSE)
     CALL cl_set_comp_entry("hrdg01,hrdg03,hrat02,hrat04,hrat05,hrat25,hrat19,hrdg02,hrbo15",TRUE)
     CALL cl_set_comp_entry("hrdg04,hrdg04_name,hrdg05,hrdg06,hrdg06_name,hrdg07,hrdg08,hrdg09",TRUE)    
END FUNCTION 
	
	
FUNCTION i075_remove()
	DEFINE l_n    LIKE type_file.num5
	DEFINE l_hrdg04 LIKE hrdg_file.hrdg04
	DEFINE l_hrdg05 LIKE hrdg_file.hrdg05
	
	DECLARE i075_cl_1 CURSOR FOR SELECT * FROM hrdg_tmp_t
   
    LET g_cnt = 1
    MESSAGE "Searching!"
    CALL g_hrdg_tt.clear() 
    FOREACH i075_cl_1 INTO g_hrdg_tt[g_cnt].*   
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF 
        	
    IF NOT g_hrdg_tt[g_cnt].sure = 'Y' THEN 
    	SELECT hrdg04,hrdg05 INTO l_hrdg04,l_hrdg05 FROM hrdg_file WHERE hrdg01 = g_hrdg_tt[g_cnt].hrdg01
       UPDATE hrdg_file
          SET hrdg06 = l_hrdg04,
              hrdg07 = l_hrdg05,
              hrdgmodu = g_user,
              hrdgdate = g_today
        WHERE hrdg01 = g_hrdg_tt[g_cnt].hrdg01
    ELSE 
    	 DELETE FROM hrdg_file
    	  WHERE hrdg01 = g_hrdg_tt[g_cnt].hrdg01 
    END IF 

        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max THEN
          # CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    DROP TABLE hrdg_tmp_t
    CALL g_hrdg_tt.deleteElement(g_cnt)
    MESSAGE ""
    LET g_cnt = 0
	
END FUNCTION 
