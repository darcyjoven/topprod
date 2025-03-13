# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: csft512.4gl
# Descriptions...: 工单发料调拨维护作业
# Date & Author..: 20170508 by nihuan

DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_tc_imm           RECORD LIKE tc_imm_file.*,
    g_tc_imm_t         RECORD LIKE tc_imm_file.*,
    g_tc_imm_o         RECORD LIKE tc_imm_file.*,
    g_tc_imm01_t       LIKE tc_imm_file.tc_imm01,
    g_tc_imn           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        tc_imn02            LIKE tc_imn_file.tc_imn02,          #项次
        tc_imn03            LIKE tc_imn_file.tc_imn03,          #工单单号
        tc_imn04            LIKE tc_imn_file.tc_imn04,          #作业编号
        ecd02               LIKE ecd_file.ecd02,                #作业名称
        tc_imn05            LIKE tc_imn_file.tc_imn05,          #生产料号
        ima02               LIKE ima_file.ima02,                #品名
        ima021              LIKE ima_file.ima021,               #规格
        tc_imn06            LIKE tc_imn_file.tc_imn06,          #生产数量
        tc_imn11            LIKE tc_imn_file.tc_imn11           #发料套数
                    END RECORD,
    g_tc_imn_t         RECORD                     #程式變數 (舊值)
        tc_imn02            LIKE tc_imn_file.tc_imn02,          #项次
        tc_imn03            LIKE tc_imn_file.tc_imn03,          #工单单号
        tc_imn04            LIKE tc_imn_file.tc_imn04,          #作业编号
        ecd02               LIKE ecd_file.ecd02,                #作业名称
        tc_imn05            LIKE tc_imn_file.tc_imn05,          #生产料号
        ima02               LIKE ima_file.ima02,                #品名
        ima021              LIKE ima_file.ima021,               #规格
        tc_imn06            LIKE tc_imn_file.tc_imn06,          #生产数量
        tc_imn11            LIKE tc_imn_file.tc_imn11           #发料套数
                    END RECORD,
    g_tc_imp           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        tc_imp02            LIKE tc_imp_file.tc_imp02,          #项次
        tc_imp03            LIKE tc_imp_file.tc_imp03,
        tc_imp04            LIKE tc_imp_file.tc_imp04,
        tc_imp05            LIKE tc_imp_file.tc_imp05,          #料号
        ima02_1             LIKE ima_file.ima02,                #品名
        ima021_1            LIKE ima_file.ima021,               #规格
        tc_imp06            LIKE tc_imp_file.tc_imp06,          #仓库
        imd02               LIKE imd_file.imd02,                #仓库名称
        tc_imp11           LIKE tc_imp_file.tc_imp11,           #库位  
        tc_imp13           LIKE tc_imp_file.tc_imp13,           
        tc_imp14           LIKE tc_imp_file.tc_imp14,  
        tc_imp07            LIKE tc_imp_file.tc_imp07,          #申请人
        gen02_1             LIKE gen_file.gen02,                #姓名
        tc_imp08            LIKE tc_imp_file.tc_imp08,          #申请数量
        tc_imp09            LIKE tc_imp_file.tc_imp09           #实际领用数量
        ,tc_imp10           LIKE tc_imp_file.tc_imp10           #add by guanyao160909  #单位
          
                    END RECORD,
    g_tc_imp_t         RECORD
        tc_imp02            LIKE tc_imp_file.tc_imp02,          #项次
        tc_imp03            LIKE tc_imp_file.tc_imp03,
        tc_imp04            LIKE tc_imp_file.tc_imp04,
        tc_imp05            LIKE tc_imp_file.tc_imp05,          #料号
        ima02_1             LIKE ima_file.ima02,                #品名
        ima021_1            LIKE ima_file.ima021,               #规格
        tc_imp06            LIKE tc_imp_file.tc_imp06,          #仓库
        imd02               LIKE imd_file.imd02,                #仓库名称
        tc_imp11           LIKE tc_imp_file.tc_imp11,           #库位  
        tc_imp13           LIKE tc_imp_file.tc_imp13,           
        tc_imp14           LIKE tc_imp_file.tc_imp14,  
        tc_imp07            LIKE tc_imp_file.tc_imp07,          #申请人
        gen02_1             LIKE gen_file.gen02,                #姓名
        tc_imp08            LIKE tc_imp_file.tc_imp08,          #申请数量
        tc_imp09            LIKE tc_imp_file.tc_imp09           #实际领用数量
        ,tc_imp10           LIKE tc_imp_file.tc_imp10           #add by guanyao160909  #单位
                    END RECORD,
    g_tc_imq           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        tc_imq02   LIKE tc_imq_file.tc_imq02,                   #项次
        tc_imq03   LIKE tc_imq_file.tc_imq03,                   #工单单号
        tc_imq04   LIKE tc_imq_file.tc_imq04,                   #作业编号
        tc_imq05   LIKE tc_imq_file.tc_imq05,                   #料号
        ima02_2    LIKE ima_file.ima02,                         #品名
        ima021_2   LIKE ima_file.ima021,                        #规格
        tc_imq06   LIKE tc_imq_file.tc_imq06,                   #拨出仓库
        tc_imq07   LIKE tc_imq_file.tc_imq07,                   #储位
        tc_imq08   LIKE tc_imq_file.tc_imq08,                   #批号
        tc_imq09   LIKE tc_imq_file.tc_imq09,                   #拨出单位
        tc_imq10   LIKE tc_imq_file.tc_imq10,                   #拨入仓库
        tc_imq11   LIKE tc_imq_file.tc_imq11,                   #储位
        tc_imq12   LIKE tc_imq_file.tc_imq12,                   #批号
        tc_imq13   LIKE tc_imq_file.tc_imq13,                   #拨入单位
        tc_imq14   LIKE tc_imq_file.tc_imq14,                   #拨出数量
        tc_imq15   LIKE tc_imq_file.tc_imq15,                   #拨入数量
        tc_imq16   LIKE tc_imq_file.tc_imq16,                   #单位转换
        tc_imq17   LIKE tc_imq_file.tc_imq17,                   #理由码
        azf03      LIKE azf_file.azf03,                         #理由码说明
        tc_imq18   LIKE tc_imq_file.tc_imq18                    #备注
                    END RECORD,
    g_tc_imq_t         RECORD
        tc_imq02   LIKE tc_imq_file.tc_imq02,                   #项次
        tc_imq03   LIKE tc_imq_file.tc_imq03,                   #工单单号
        tc_imq04   LIKE tc_imq_file.tc_imq04,                   #作业编号
        tc_imq05   LIKE tc_imq_file.tc_imq05,                   #料号
        ima02_2    LIKE ima_file.ima02,                         #品名
        ima021_2   LIKE ima_file.ima021,                        #规格
        tc_imq06   LIKE tc_imq_file.tc_imq06,                   #拨出仓库
        tc_imq07   LIKE tc_imq_file.tc_imq07,                   #储位
        tc_imq08   LIKE tc_imq_file.tc_imq08,                   #批号
        tc_imq09   LIKE tc_imq_file.tc_imq09,                   #拨出单位
        tc_imq10   LIKE tc_imq_file.tc_imq10,                   #拨入仓库
        tc_imq11   LIKE tc_imq_file.tc_imq11,                   #储位
        tc_imq12   LIKE tc_imq_file.tc_imq12,                   #批号
        tc_imq13   LIKE tc_imq_file.tc_imq13,                   #拨入单位
        tc_imq14   LIKE tc_imq_file.tc_imq14,                   #拨出数量
        tc_imq15   LIKE tc_imq_file.tc_imq15,                   #拨入数量
        tc_imq16   LIKE tc_imq_file.tc_imq16,                   #单位转换
        tc_imq17   LIKE tc_imq_file.tc_imq17,                   #理由码
        azf03      LIKE azf_file.azf03,                         #理由码说明
        tc_imq18   LIKE tc_imq_file.tc_imq18                    #备注
                    END RECORD,
    g_wc,g_wc2,g_wc3,g_wc4,g_wc5,g_sql,g_sql1,g_sql2    STRING,
    g_rec_b1,g_rec_b2,g_rec_b3,g_rec_b4    LIKE type_file.num5, #單身筆數
    g_fic03         LIKE fic_file.fic03,
    g_t1            LIKE type_file.chr3,
    l_ac,l_ac1,l_ac2           LIKE type_file.num5                         #目前處理的ARRAY CNT
DEFINE g_tc_imq05_t    LIKE tc_imq_file.tc_imq05
DEFINE g_error         LIKE type_file.chr1 #add by guanyao160922
DEFINE g_ima906        LIKE ima_file.ima906  #add by guanyao160922
 
#主程式開始
DEFINE  p_row,p_col          LIKE type_file.num5
DEFINE  l_action_flag        STRING    
DEFINE  g_forupd_sql         STRING
DEFINE  g_before_input_done  LIKE type_file.num5
DEFINE  g_chr           LIKE type_file.chr1
DEFINE  g_cnt           LIKE type_file.num10
DEFINE  g_i             LIKE type_file.num5
DEFINE  g_msg           LIKE ze_file.ze03
DEFINE  g_row_count     LIKE type_file.num10
DEFINE  g_curs_index    LIKE type_file.num10
DEFINE  g_jump          LIKE type_file.num10
DEFINE  mi_no_ask       LIKE type_file.num5
DEFINE  g_void          LIKE type_file.chr1
DEFINE g_debit,g_credit    LIKE img_file.img26
DEFINE g_img10,g_img10_2   LIKE img_file.img10
DEFINE l_sum		LIKE	type_file.num5
DEFINE  j_imn_l	DYNAMIC ARRAY OF RECORD		#ADD by huzhou 20170809
	tc_imm01	LIKE tc_imm_file.tc_imm01, 	#调拨单号
	tc_imm02	LIKE tc_imm_file.tc_imm02, 	#调拨日期
	tc_imm04	LIKE tc_imm_file.tc_imm04, 	#调拨审核否
	tc_imm08	LIKE tc_imm_file.tc_imm08, 	#作业编号
	tc_imm10	LIKE tc_imm_file.tc_imm10, 	#所属站别
	tc_imm14	LIKE tc_imm_file.tc_imm14,	#部门
	tc_imm16	LIKE tc_imm_file.tc_imm16, 	#申请人
	tc_immconf	LIKE tc_imm_file.tc_immconf, 	#审核码
	gen02		LIKE gen_file.gen02,	        #姓名
	gem02		LIKE gem_file.gem02
		END RECORD 

MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
   IF (NOT cl_setup("CSF")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1)
         RETURNING g_time 
 
   LET g_forupd_sql = "SELECT * FROM tc_imm_file WHERE tc_imm01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i511_cl CURSOR FROM g_forupd_sql
 
   LET p_row = 4 LET p_col = 5
 
   OPEN WINDOW i511_w AT 2,2 WITH FORM "csf/42f/csft512"
         ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()

   CALL i511_menu()
 
   CLOSE WINDOW i511_w
   CALL  cl_used(g_prog,g_time,2)
         RETURNING g_time
END MAIN
 
#QBE 查詢資料
FUNCTION i511_cs()
DEFINE    l_type          LIKE type_file.chr2
#str----add by huanglf160928
DEFINE    l_tc_imq06      LIKE tc_imq_file.tc_imq06
DEFINE    l_tc_imq07      LIKE tc_imq_file.tc_imq07
DEFINE    l_tc_imq10      LIKE tc_imq_file.tc_imq10
DEFINE    l_tc_imq11      LIKE tc_imq_file.tc_imq11
#str----end by huanglf160928
   CLEAR FORM                                      #清除畫面
   CALL g_tc_imn.clear()
   CALL g_tc_imp.clear()
   CALL g_tc_imq.clear()
   CALL cl_set_head_visible("folder01","YES")
 
   INITIALIZE g_tc_imm.* TO NULL

   CONSTRUCT BY NAME g_wc ON tc_imm01,tc_imm02,tc_immud13,tc_imm14,tc_imm16,
                             tc_imm08,tc_imm10,tc_immconf,tc_imm03,tc_imm09
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(tc_imm01)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_tc_imm"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tc_imm01
               NEXT FIELD tc_imm01
            WHEN INFIELD(tc_imm14)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_gem"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tc_imm14
               NEXT FIELD tc_imm14
            WHEN INFIELD(tc_imm16)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_gen"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tc_imm16
               NEXT FIELD tc_imm16
            WHEN INFIELD(tc_imm08)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_ecd3"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tc_imm08
               NEXT FIELD tc_imm08
            WHEN INFIELD(tc_imm10)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_eca1"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tc_imm10
               NEXT FIELD tc_imm10
            OTHERWISE EXIT CASE
         END CASE
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION controlg
         CALL cl_cmdask()

   END CONSTRUCT
   IF INT_FLAG THEN RETURN END IF
 
   LET g_wc2 = " 1=1"
   CONSTRUCT g_wc2 ON tc_imn02,tc_imn03,tc_imn04,tc_imn05,tc_imn06,tc_imn11
        FROM s_tc_imn[1].tc_imn02,s_tc_imn[1].tc_imn03,s_tc_imn[1].tc_imn04,s_tc_imn[1].tc_imn05,s_tc_imn[1].tc_imn06,s_tc_imn[1].tc_imn11
      
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(tc_imn03)
               #CALL cl_init_qry_var()
               #LET g_qryparam.state = "c"
               #LET g_qryparam.form ="q_sfb"
               #CALL cl_create_qry() RETURNING g_qryparam.multiret
               #DISPLAY g_qryparam.multiret TO tc_imn03
               NEXT FIELD tc_imn03
            WHEN INFIELD(tc_imn04)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_gem"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tc_imn04
               NEXT FIELD tc_imn04
            WHEN INFIELD(tc_imn05)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_ima"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tc_imn05
               NEXT FIELD tc_imn05
            OTHERWISE EXIT CASE
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
   IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
 
   LET g_wc3 = " 1=1"
   CONSTRUCT g_wc3 ON tc_imp02,tc_imp03,tc_imp04,tc_imp05,tc_imp06,tc_imp11,tc_imp13,tc_imp14,tc_imp07,tc_imp08,tc_imp09,tc_imp10     #add tc_imp10 by guanyao160909
         FROM s_tc_imp[1].tc_imp02,s_tc_imp[1].tc_imp03,s_tc_imp[1].tc_imp04,s_tc_imp[1].tc_imp05,s_tc_imp[1].tc_imp06,
              s_tc_imp[1].tc_imp11,s_tc_imp[1].tc_imp13,s_tc_imp[1].tc_imp14,
              s_tc_imp[1].tc_imp07,s_tc_imp[1].tc_imp08,s_tc_imp[1].tc_imp09
              ,s_tc_imp[1].tc_imp10  #add by guanyao160909
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(tc_imp05)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_ima"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tc_imp05
               NEXT FIELD tc_imp05
            WHEN INFIELD(tc_imp06)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.arg1  = 'SW'
               LET g_qryparam.form ="q_imd"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tc_imp06
               NEXT FIELD tc_imp06
            WHEN INFIELD(tc_imp07)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_gen"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tc_imp07
               NEXT FIELD tc_imp07

             
            OTHERWISE EXIT CASE
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
   IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
   	
   LET g_wc4 = " 1=1"
   CONSTRUCT g_wc4 ON tc_imq02,tc_imq03,tc_imq04,tc_imq05,tc_imq06,
                      tc_imq07,tc_imq08,tc_imq09,tc_imq10,tc_imq11,
                      tc_imq12,tc_imq13,tc_imq14,tc_imq15,tc_imq16,
                      tc_imq17,tc_imq18
         FROM s_tc_imq[1].tc_imq02,s_tc_imq[1].tc_imq03,s_tc_imq[1].tc_imq04,s_tc_imq[1].tc_imq05,s_tc_imq[1].tc_imq06,
              s_tc_imq[1].tc_imq07,s_tc_imq[1].tc_imq08,s_tc_imq[1].tc_imq09,s_tc_imq[1].tc_imq10,s_tc_imq[1].tc_imq11,
              s_tc_imq[1].tc_imq12,s_tc_imq[1].tc_imq13,s_tc_imq[1].tc_imq14,s_tc_imq[1].tc_imq15,s_tc_imq[1].tc_imq16,
              s_tc_imq[1].tc_imq17,s_tc_imq[1].tc_imq18
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(tc_imq03)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_sfb"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tc_imq03
               NEXT FIELD tc_imq03
            WHEN INFIELD(tc_imq06)  #modify by huanglf160928
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.arg1  = 'SW'
               LET g_qryparam.form ="q_imd"
               CALL cl_create_qry() RETURNING l_tc_imq06
               DISPLAY l_tc_imq06 TO tc_imq06
               NEXT FIELD tc_imq06
#str----add by huanglf160928
             WHEN INFIELD(tc_imq07)   #撥出儲位
                #No.FUN-AA0049--begin
                CALL cl_init_qry_var()                                                                                              
                LET g_qryparam.form ="q_ime"                                                                                        
                LET g_qryparam.default1 = l_tc_imq07
                LET g_qryparam.arg1     = l_tc_imq06                                                                     
                LET g_qryparam.arg2     = 'SW'        #倉庫類別 #MOD-A20083 add W                                                               
                CALL cl_create_qry() RETURNING l_tc_imq07               
                DISPLAY l_tc_imq07 TO tc_imq07
                #No.FUN-AA0049--end 
                NEXT FIELD tc_imq07
             WHEN INFIELD(tc_imq10)   #撥入倉庫別
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                LET g_qryparam.arg1  = 'SW'
                LET g_qryparam.form ="q_imd"
                CALL cl_create_qry() RETURNING l_tc_imq10
                DISPLAY l_tc_imq10 TO tc_imq10
                NEXT FIELD tc_imq10                                                                                      
             WHEN INFIELD(tc_imq11)   #撥出儲位
                CALL cl_init_qry_var()                                                                                              
                LET g_qryparam.form ="q_ime"                                                                                        
                LET g_qryparam.default1 = l_tc_imq11
                LET g_qryparam.arg1     = l_tc_imq10                                                                     
                LET g_qryparam.arg2     = 'SW'        #倉庫類別 #MOD-A20083 add W                                                               
                CALL cl_create_qry() RETURNING l_tc_imq11               
                DISPLAY l_tc_imq11 TO tc_imq11
                NEXT FIELD tc_imq11
#str----add by huanglf160928
            WHEN INFIELD(tc_imq05)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_ima"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tc_imq05
               NEXT FIELD tc_imq05
#str----add by huanglf160928



#str----end by huanglf160928
            OTHERWISE EXIT CASE
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
   IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF

   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('tc_immuser', 'tc_immgrup')

   LET g_sql  = "SELECT tc_imm01 "
   LET g_sql1 = " FROM tc_imm_file "
   LET g_sql2 = " WHERE ", g_wc CLIPPED
 
   IF g_wc2 <> " 1=1" THEN
      LET g_sql1= g_sql1 CLIPPED,",tc_imn_file"
      LET g_sql2= g_sql2 CLIPPED," AND tc_imm01=tc_imn01",
                                 " AND ",g_wc2 CLIPPED
   END IF
   IF g_wc3 <> " 1=1" THEN
      LET g_sql1= g_sql1 CLIPPED,",tc_imp_file"
      LET g_sql2= g_sql2 CLIPPED," AND tc_imm01=tc_imp01",
                                 " AND ",g_wc3 CLIPPED
   END IF
   IF g_wc4 <> " 1=1" THEN
      LET g_sql1= g_sql1 CLIPPED,",tc_imq_file"
      LET g_sql2= g_sql2 CLIPPED," AND tc_imm01=tc_imq01",
                                 " AND ",g_wc4 CLIPPED
   END IF
   LET g_sql = g_sql  CLIPPED,' ',g_sql1 CLIPPED,' ',
               g_sql2 CLIPPED,' ORDER BY tc_imm01'
 
   PREPARE i511_prepare FROM g_sql
   DECLARE i511_cs SCROLL CURSOR WITH HOLD FOR i511_prepare
 
   LET g_sql  = "SELECT COUNT(UNIQUE tc_imm01) "
   LET g_sql = g_sql  CLIPPED,' ',g_sql1 CLIPPED,' ',
               g_sql2 CLIPPED
 
   PREPARE i511_precount FROM g_sql
   DECLARE i511_count CURSOR FOR i511_precount
END FUNCTION
 
FUNCTION i511_menu()
DEFINE l_cmd  LIKE type_file.chr1000
   WHILE TRUE
	
      CASE
         WHEN (l_action_flag IS NULL) OR (l_action_flag = "page_main")
            CALL i511_bp2("G")
         WHEN (l_action_flag = "Page2")
            CALL i511_bp3("G")
	 WHEN (l_action_flag = "page_list")
	    CALL t511_list_fill()	#资料清单 add by huzhou 20170809
	    CALL i511_bp4("G")
      END CASE

      CASE g_action_choice
      	 WHEN "Page1"
            CALL i511_bp2("G")
         WHEN "Page2"
            CALL i511_bp3("G") 
	 WHEN "page_list"
	    CALL t511_list_fill()
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i511_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i511_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i511_r()
            END IF
         #WHEN "reproduce"
         #   IF cl_chk_act_auth() THEN
         #      CALL i511_copy()
         #   END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i511_u()
            END IF
         #WHEN "invalid"
         #   IF cl_chk_act_auth() THEN
         #      CALL i511_x()
         #   END IF
         WHEN "output"
            IF cl_chk_act_auth()                                           
               THEN CALL i511_out()                                    
            END IF 
         WHEN "del_tc_im"   
            IF cl_chk_act_auth() THEN
            	 #DELETE FROM tc_imq_file WHERE tc_imq01 = g_tc_imm.tc_imm01
            	 CALL del_tc_imq()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()

         WHEN "user_defined_columns"
            IF cl_chk_act_auth() THEN
               CALL i511_b2()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "spare_part"
            IF cl_chk_act_auth() THEN
               CALL i511_b3()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_tc_imm.tc_imm01 IS NOT NULL THEN
                 LET g_doc.column1 = "tc_imm01"
                 LET g_doc.value1 = g_tc_imm.tc_imm01
                 CALL cl_doc()
               END IF
         END IF
         
         WHEN "modify_wo"
            IF cl_chk_act_auth() THEN
               CALL i511_b1()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "create_des"
            IF cl_chk_act_auth() THEN
               CALL create_des()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL i511_y()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL i511_uy()
            ELSE
               LET g_action_choice = NULL
            END IF   
         WHEN "post"
            IF cl_chk_act_auth() THEN
               CALL i511_post()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "undo_post"
            IF cl_chk_act_auth() THEN
               CALL i511_upost()
            ELSE
               LET g_action_choice = NULL
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i511_a()
DEFINE li_result,l_cnt      LIKE type_file.num5
   IF s_shut(0) THEN RETURN END IF
   MESSAGE ""
   CLEAR FORM
   CALL g_tc_imn.clear()
   CALL g_tc_imp.clear()
   CALL g_tc_imq.clear()
   INITIALIZE g_tc_imm.* LIKE tc_imm_file.*             #DEFAULT 設定
   LET g_tc_imm01_t = NULL
   #預設值及將數值類變數清成零
   LET g_tc_imm.tc_immuser=g_user
   LET g_tc_imm.tc_immoriu = g_user
   LET g_tc_imm.tc_immorig = g_grup
   LET g_tc_imm.tc_immgrup=g_grup
   LET g_tc_imm.tc_immdate=g_today
   LET g_tc_imm.tc_immacti='Y'              #資料有效
   LET g_tc_imm.tc_immplant = g_plant
   LET g_tc_imm.tc_immlegal = g_plant
   LET g_tc_imm.tc_imm15 = 0
   LET g_tc_imm.tc_immmksg = 'N'
   LET g_tc_imm.tc_imm03 = 'N'
   LET g_tc_imm.tc_immconf = 'N'
   LET g_tc_imm.tc_imm02 = g_today
   LET g_tc_imm.tc_immud13 = g_today
   LET g_tc_imm.tc_imm14 = g_grup
   LET g_tc_imm.tc_imm16 = g_user
   CALL cl_opmsg('a')
   WHILE TRUE
      CALL i511_i("a")                   #輸入單頭
      IF INT_FLAG THEN                   #使用者不玩了
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         INITIALIZE g_tc_imm.* TO NULL
         EXIT WHILE
      END IF
      SELECT 'DSB-'||to_char(sysdate,'yymmdd')||(MAX(NVL(substr(tc_imm01,11,5),0)) + 1) INTO g_tc_imm.tc_imm01 
        FROM tc_imm_file
       WHERE substr(tc_imm01,1,10) = 'DSB-'||to_char(sysdate,'yymmdd')
      SELECT length(g_tc_imm.tc_imm01) INTO l_cnt FROM DUAL;
      IF l_cnt< 15 THEN
         LET g_tc_imm.tc_imm01 = g_tc_imm.tc_imm01 CLIPPED,'00001'
      END IF
      IF g_tc_imm.tc_imm01 IS NULL THEN                # KEY 不可空白
         CONTINUE WHILE
      END IF
      DISPLAY BY NAME g_tc_imm.tc_imm01
      INSERT INTO tc_imm_file VALUES (g_tc_imm.*)
      IF SQLCA.sqlcode THEN                     #置入資料庫不成功
         CALL cl_err3("ins","tc_imm_file",g_tc_imm.tc_imm01,"",SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      END IF
      SELECT tc_imm01 INTO g_tc_imm.tc_imm01 FROM tc_imm_file
       WHERE tc_imm01 = g_tc_imm.tc_imm01
      LET g_tc_imm01_t = g_tc_imm.tc_imm01        #保留舊值
      LET g_tc_imm_t.* = g_tc_imm.*

      CALL i511_b1_fill(" 1=1")                 #單身
      CALL i511_b1()                   #輸入單身-1
 
      CALL g_tc_imp.clear()
      LET g_rec_b2=0
      LET l_cnt = 0 
      SELECT COUNT(*) INTO l_cnt FROM tc_imn_file WHERE tc_imn01 = g_tc_imm.tc_imm01
      IF l_cnt > 0 THEN
         CALL i511_b2_g()
         CALL i511_b2_fill(" 1=1")
      ELSE
         CALL i511_b2()                   #輸入單身-2
      END IF
 
      #CALL g_tc_imq.clear()
      #LET g_rec_b3=0
      #CALL i511_b3()                   #輸入單身-3
 
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION i511_u()
DEFINE l_msg       STRING               
   IF g_tc_imm.tc_immconf = 'Y' THEN
      LET l_msg = "已审核，不可修改"
      CALL cl_err(l_msg,'!',1)
      RETURN
   END IF
   
   IF g_tc_imm.tc_immconf = 'X' THEN
      LET l_msg = "已作废，不可修改"
      CALL cl_err(l_msg,'!',1)
      RETURN
   END IF
   
   IF g_tc_imm.tc_imm03 = 'Y' THEN
      LET l_msg = "已过账单据，不可修改"
      CALL cl_err(l_msg,'!',1)
      RETURN
   END IF
   IF s_shut(0) THEN RETURN END IF
   IF g_tc_imm.tc_imm01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   SELECT * INTO g_tc_imm.* FROM tc_imm_file
    WHERE tc_imm01=g_tc_imm.tc_imm01
   IF g_tc_imm.tc_immacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_tc_imm.tc_imm01,9027,0)
      RETURN
   END IF
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_tc_imm01_t = g_tc_imm.tc_imm01
   LET g_tc_imm_o.* = g_tc_imm.*
   BEGIN WORK
   LET g_success = 'Y'
   OPEN i511_cl USING g_tc_imm.tc_imm01
   IF STATUS THEN
      CALL cl_err("OPEN i511_cl:", STATUS, 1)
      CLOSE i511_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i511_cl INTO g_tc_imm.*                          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_tc_imm.tc_imm01,SQLCA.sqlcode,0)      # 資料被他人LOCK
      CLOSE i511_cl
      ROLLBACK WORK
      RETURN
   END IF
   CALL i511_show()
   WHILE TRUE
      LET g_tc_imm01_t = g_tc_imm.tc_imm01
      LET g_tc_imm.tc_immmodu=g_user
      LET g_tc_imm.tc_immdate=g_today
      CALL i511_i("u")                                    #欄位更改
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_tc_imm.*=g_tc_imm_t.*
         CALL i511_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
      IF g_tc_imm.tc_imm01 != g_tc_imm01_t THEN            # 更改單號
         UPDATE tc_imn_file SET tc_imn01 = g_tc_imm.tc_imm01 WHERE tc_imn01 = g_tc_imm01_t
         UPDATE tc_imp_file SET tc_imp01 = g_tc_imm.tc_imm01 WHERE tc_imp01 = g_tc_imm01_t
         UPDATE tc_imq_file SET tc_imq01 = g_tc_imm.tc_imm01 WHERE tc_imq01 = g_tc_imm01_t
      END IF
      UPDATE tc_imm_file SET tc_imm_file.* = g_tc_imm.* WHERE tc_imm01 = g_tc_imm01_t 
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","tc_imm_file",g_tc_imm.tc_imm01,"",SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
   CLOSE i511_cl
   COMMIT WORK
END FUNCTION
 
#處理INPUT
FUNCTION i511_i(p_cmd)
DEFINE
    l_flag          LIKE type_file.chr1,                 #判斷必要欄位是否有輸入
    p_cmd           LIKE type_file.chr1,                 #a:輸入 u:更改
    l_pmc03         LIKE pmc_file.pmc03,
    l_yy,l_mm       LIKE type_file.num5,
    l_fii03         LIKE fii_file.fii03
DEFINE   l_n        LIKE type_file.num5
DEFINE l_gem02      LIKE gem_file.gem02
DEFINE l_gen02      LIKE gen_file.gen02
DEFINE l_ecd02      LIKE ecd_file.ecd02
DEFINE l_eca02      LIKE eca_file.eca02
DEFINE l_cnt        LIKE type_file.num5
DEFINE l_msg        STRING
    
    LET l_n = 0
    CALL cl_set_head_visible("folder01","YES")
 
    INPUT BY NAME g_tc_imm.tc_imm01,g_tc_imm.tc_imm02,g_tc_imm.tc_immud13,g_tc_imm.tc_imm14,g_tc_imm.tc_imm16,
                  g_tc_imm.tc_imm08,g_tc_imm.tc_imm10,g_tc_imm.tc_immconf,g_tc_imm.tc_imm03,g_tc_imm.tc_imm09
          
        WITHOUT DEFAULTS
 
       BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL i511_set_entry(p_cmd)
           CALL i511_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
 
        AFTER FIELD tc_imm08
           IF NOT cl_null(g_tc_imm.tc_imm08) THEN
            	 LET l_cnt = 0
            	 SELECT COUNT(*) INTO l_cnt FROM ecd_file WHERE ecd01 = g_tc_imm.tc_imm08
            	 IF l_cnt = 0 THEN
            	    LET l_msg = "不存在的作业编号，请重新录入"
            	    CALL cl_err(l_msg,'!',1)	
            	    NEXT FIELD tc_imm08
            	 END IF
            	 LET l_cnt = 0 
            	 SELECT COUNT(*) INTO l_cnt FROM tc_imn_file WHERE tc_imn01 = g_tc_imm.tc_imm01  AND tc_imn04 <> g_tc_imm.tc_imm08
            	 IF l_cnt > 0 THEN
            	    LET l_msg = "修改后作业编号与单身不符,请重新录入"
            	    CALL cl_err(l_msg,'!',1)	
            	    NEXT FIELD tc_imm08
            	 END IF
                 
               SELECT ecd02,ecd07 INTO l_ecd02,g_tc_imm.tc_imm10 FROM ecd_file WHERE ecd01 = g_tc_imm.tc_imm08
               SELECT eca02 INTO l_eca02 FROM eca_file WHERE eca01 = g_tc_imm.tc_imm10
               DISPLAY l_eca02 TO FORMONLY.eca02
               DISPLAY l_ecd02 TO FORMONLY.ecd021
            ELSE
               DISPLAY '' TO FORMONLY.ecd021
            END IF

        AFTER FIELD tc_imm10
            IF NOT cl_null(g_tc_imm.tc_imm10) THEN
            	 LET l_cnt = 0
            	 SELECT COUNT(*) INTO l_cnt FROM eca_file WHERE eca01 = g_tc_imm.tc_imm10
            	 IF l_cnt = 0 THEN
            	    LET l_msg = "不存在的站别，请重新录入"
            	    CALL cl_err(l_msg,'!',1)	
            	    NEXT FIELD tc_imm10
            	 END IF
               SELECT eca02 INTO l_eca02 FROM eca_file WHERE eca01 = g_tc_imm.tc_imm10
               DISPLAY l_eca02 TO FORMONLY.eca02
            ELSE
               DISPLAY '' TO FORMONLY.eca02
            END IF

        AFTER FIELD tc_imm14
            IF NOT cl_null(g_tc_imm.tc_imm14) THEN
            	 LET l_cnt = 0
            	 SELECT COUNT(*) INTO l_cnt FROM gem_file WHERE gem01 = g_tc_imm.tc_imm14
            	 IF l_cnt = 0 THEN
            	    LET l_msg = "不存在的部门编号，请重新录入"
            	    CALL cl_err(l_msg,'!',1)	
            	    NEXT FIELD tc_imm14
            	 END IF
            	 
               SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01 = g_tc_imm.tc_imm14
               DISPLAY l_gem02 TO FORMONLY.gem02
            ELSE
               DISPLAY '' TO FORMONLY.gem02
            END IF

        AFTER FIELD tc_imm16
            IF NOT cl_null(g_tc_imm.tc_imm16) THEN
            	 LET l_cnt = 0
            	 SELECT COUNT(*) INTO l_cnt FROM gen_file WHERE gen01 = g_tc_imm.tc_imm16
            	 IF l_cnt = 0 THEN
            	    LET l_msg = "不存在的人员，请重新录入"
            	    CALL cl_err(l_msg,'!',1)	
            	    NEXT FIELD tc_imm16
            	 END IF
               SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_tc_imm.tc_imm16
               DISPLAY l_gen02 TO FORMONLY.gen02
            ELSE
               DISPLAY '' TO FORMONLY.gen02
            END IF

        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(tc_imm14)
                 CALL cl_init_qry_var()
                 LET g_qryparam.default1 = g_tc_imm.tc_imm14
                 LET g_qryparam.form ="q_gem"
                 CALL cl_create_qry() RETURNING g_tc_imm.tc_imm14
                 DISPLAY BY NAME g_tc_imm.tc_imm14
                 NEXT FIELD tc_imm14
              WHEN INFIELD(tc_imm16)
                 CALL cl_init_qry_var()
                 LET g_qryparam.default1 = g_tc_imm.tc_imm16
                 LET g_qryparam.form ="q_gen"
                 CALL cl_create_qry() RETURNING g_tc_imm.tc_imm16
                 DISPLAY BY NAME g_tc_imm.tc_imm16
                 NEXT FIELD tc_imm16
              WHEN INFIELD(tc_imm08)
                 CALL cl_init_qry_var()
                 LET g_qryparam.default1 = g_tc_imm.tc_imm08
                 LET g_qryparam.form ="q_ecd3"
                 CALL cl_create_qry() RETURNING g_tc_imm.tc_imm08
                 DISPLAY BY NAME g_tc_imm.tc_imm08
                 NEXT FIELD tc_imm08
              WHEN INFIELD(tc_imm10)
                 CALL cl_init_qry_var()
                 LET g_qryparam.default1 = g_tc_imm.tc_imm10
                 LET g_qryparam.form ="q_eca1"
                 CALL cl_create_qry() RETURNING g_tc_imm.tc_imm10
                 DISPLAY BY NAME g_tc_imm.tc_imm10
                 NEXT FIELD tc_imm10
              OTHERWISE EXIT CASE
        END CASE

       ON ACTION CONTROLF                  #欄位說明
          CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
          CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
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
END FUNCTION

FUNCTION i511_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_tc_imm.* TO NULL
 
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_tc_imn.clear()
   CALL g_tc_imp.clear()
   CALL g_tc_imq.clear()

 
   DISPLAY '   ' TO FORMONLY.cnt
 
   CALL i511_cs()
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
   MESSAGE " SEARCHING ! "
   OPEN i511_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_tc_imm.* TO NULL
   ELSE
      OPEN i511_count
      FETCH i511_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL i511_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
   MESSAGE ""
END FUNCTION
 
#處理資料的讀取
FUNCTION i511_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1                  #處理方式
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     i511_cs INTO g_tc_imm.tc_imm01
      WHEN 'P' FETCH PREVIOUS i511_cs INTO g_tc_imm.tc_imm01
      WHEN 'F' FETCH FIRST    i511_cs INTO g_tc_imm.tc_imm01
      WHEN 'L' FETCH LAST     i511_cs INTO g_tc_imm.tc_imm01
      WHEN '/'
         IF NOT mi_no_ask THEN
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
 
            IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
         END IF
         FETCH ABSOLUTE g_jump i511_cs INTO g_tc_imm.tc_imm01
         LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_tc_imm.tc_imm01,SQLCA.sqlcode,0)
      INITIALIZE g_tc_imm.* TO NULL
      CLEAR FORM
      CALL g_tc_imn.clear()
      CALL g_tc_imp.clear()
      CALL g_tc_imq.clear()
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
   END IF
   SELECT * INTO g_tc_imm.* FROM tc_imm_file WHERE tc_imm01 = g_tc_imm.tc_imm01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","tc_imm_file",g_tc_imm.tc_imm01,"",SQLCA.sqlcode,"","",1)
      INITIALIZE g_tc_imm.* TO NULL
      RETURN
   END IF
   LET g_data_owner = g_tc_imm.tc_immuser 
   LET g_data_group = g_tc_imm.tc_immgrup 
   CALL i511_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i511_show()
DEFINE l_gem02      LIKE gem_file.gem02
DEFINE l_gen02      LIKE gen_file.gen02
DEFINE l_ecd02      LIKE ecd_file.ecd02
DEFINE l_eca02      LIKE eca_file.eca02
   LET g_tc_imm_t.* = g_tc_imm.*                #保存單頭舊值
   DISPLAY BY NAME g_tc_imm.tc_imm01,g_tc_imm.tc_imm02,g_tc_imm.tc_imm03,#g_tc_imm.tc_imm04#,g_tc_imm.tc_immdays,
                   #g_tc_imm.tc_immprit,g_tc_imm.tc_imm05,g_tc_imm.tc_imm06,g_tc_imm.tc_imm07,
                   g_tc_imm.tc_imm08,
                   g_tc_imm.tc_imm09,
                   g_tc_imm.tc_imm10,#g_tc_imm.tc_imm11,g_tc_imm.tc_imm12,g_tc_imm.tc_imm13,
                   #g_tc_imm.tc_immacti,
                   g_tc_imm.tc_immuser,g_tc_imm.tc_immgrup,g_tc_imm.tc_immmodu,g_tc_imm.tc_immdate,
                   g_tc_imm.tc_immconf,
                   g_tc_imm.tc_imm14,#g_tc_imm.tc_immspc,g_tc_imm.tc_immud01,g_tc_imm.tc_immud02,
                   #g_tc_imm.tc_immud03,g_tc_imm.tc_immud04,g_tc_imm.tc_immud05,g_tc_imm.tc_immud06,g_tc_imm.tc_immud07,
                   #g_tc_imm.tc_immud08,g_tc_imm.tc_immud09,g_tc_imm.tc_immud10,g_tc_imm.tc_immud11,g_tc_imm.tc_immud12,
                   #
                   g_tc_imm.tc_immud13,#g_tc_imm.tc_immud14,g_tc_imm.tc_immud15,g_tc_imm.tc_immplant,g_tc_imm.tc_immlegal,
                   g_tc_imm.tc_immoriu,g_tc_imm.tc_immorig,
                   #g_tc_imm.tc_imm15,
                   g_tc_imm.tc_imm16#,g_tc_imm.tc_immmksg

               SELECT ecd02 INTO l_ecd02 FROM ecd_file WHERE ecd01 = g_tc_imm.tc_imm08
               SELECT eca02 INTO l_eca02 FROM eca_file WHERE eca01 = g_tc_imm.tc_imm10
               SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01 = g_tc_imm.tc_imm14
               SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_tc_imm.tc_imm16
               DISPLAY l_gem02 TO FORMONLY.gem02
               DISPLAY l_eca02 TO FORMONLY.eca02
               DISPLAY l_ecd02 TO FORMONLY.ecd021
               DISPLAY l_gen02 TO FORMONLY.gen02
   IF g_tc_imm.tc_immconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   CALL cl_set_field_pic(g_tc_imm.tc_immconf,"","","",g_chr,"")
   CALL i511_b1_fill(g_wc2)                 #單身
   CALL i511_b2_fill(g_wc3)                 #單身
   CALL i511_b3_fill(g_wc4)                 #單身
   CALL cl_show_fld_cont()
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION i511_r()
DEFINE l_msg       STRING               
   IF g_tc_imm.tc_immconf = 'Y' THEN
      LET l_msg = "已审核，不可删除"
      CALL cl_err(l_msg,'!',1)
      RETURN
   END IF
   
   IF g_tc_imm.tc_immconf = 'X' THEN
      LET l_msg = "已作废，不可删除"
      CALL cl_err(l_msg,'!',1)
      RETURN
   END IF
   
   IF g_tc_imm.tc_imm03 = 'Y' THEN
      LET l_msg = "已过账单据，不可删除"
      CALL cl_err(l_msg,'!',1)
      RETURN
   END IF 
   IF s_shut(0) THEN RETURN END IF
   IF g_tc_imm.tc_imm01 IS NULL THEN CALL cl_err("",-400,0) RETURN END IF
   SELECT * INTO g_tc_imm.* FROM tc_imm_file WHERE tc_imm01=g_tc_imm.tc_imm01
   IF g_tc_imm.tc_immacti = 'N' THEN
      CALL cl_err('','abm-950',0)
      RETURN
   END IF

   BEGIN WORK
   OPEN i511_cl USING g_tc_imm.tc_imm01
   IF STATUS THEN
      CALL cl_err("OPEN i511_cl:", STATUS, 1)         
      CLOSE i511_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i511_cl INTO g_tc_imm.*                             # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_tc_imm.tc_imm01,SQLCA.sqlcode,0)         #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
   CALL i511_show()
   IF cl_delh(0,0) THEN                                      #確認一下
       INITIALIZE g_doc.* TO NULL
       LET g_doc.column1 = "tc_imm01"
       LET g_doc.value1 = g_tc_imm.tc_imm01
       CALL cl_del_doc()
      DELETE FROM tc_imn_file WHERE tc_imn01 = g_tc_imm.tc_imm01
      IF STATUS THEN
         CALL cl_err3("del","tc_imn_file",g_tc_imm.tc_imm01,"",STATUS,"","del tc_imn:",1)
         ROLLBACK WORK
         RETURN
      END IF
      DELETE FROM tc_imp_file WHERE tc_imp01 = g_tc_imm.tc_imm01
      IF STATUS THEN
         CALL cl_err3("del","tc_imp_file",g_tc_imm.tc_imm01,"",STATUS,"","del tc_imp:",1)
         ROLLBACK WORK
         RETURN
      END IF
      DELETE FROM tc_imq_file WHERE tc_imq01 = g_tc_imm.tc_imm01
      IF STATUS THEN
         CALL cl_err3("del","tc_imq_file",g_tc_imm.tc_imm01,"",STATUS,"","del tc_imq:",1)
         ROLLBACK WORK
         RETURN
      END IF
      DELETE FROM tc_imm_file WHERE tc_imm01 = g_tc_imm.tc_imm01
      IF STATUS THEN
         CALL cl_err3("del","tc_imm_file",g_tc_imm.tc_imm01,"",STATUS,"","del tc_imm:",1)
         ROLLBACK WORK
         RETURN
      END IF
      INITIALIZE g_tc_imm.* TO NULL
      CLEAR FORM
      CALL g_tc_imn.clear()
      CALL g_tc_imp.clear()
      CALL g_tc_imq.clear()
      OPEN i511_count
      IF STATUS THEN
         CLOSE i511_cs
         CLOSE i511_count
         COMMIT WORK
         RETURN
      END IF
      FETCH i511_count INTO g_row_count
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE i511_cs
         CLOSE i511_count
         COMMIT WORK
         RETURN
      END IF
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN i511_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL i511_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE
         CALL i511_fetch('/')
      END IF
   END IF
   CLOSE i511_cl
   COMMIT WORK
END FUNCTION
 
FUNCTION i511_b1()
DEFINE
   l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT 
   l_n             LIKE type_file.num5,                #檢查重複用        
   l_lock_sw       LIKE type_file.chr1,                #單身鎖住否        
   p_cmd           LIKE type_file.chr1,                #處理狀態          
   l_exit_sw       LIKE type_file.chr1,                               
   l_allow_insert  LIKE type_file.num5,                #可新增否          
   l_allow_delete  LIKE type_file.num5                 #可刪除否 
DEFINE tc_imn03_str     STRING  
DEFINE l_str            STRING
DEFINE l_tc_imn03       LIKE tc_imn_file.tc_imn03  
DEFINE l_cnt            LIKE type_file.num5 
DEFINE bst         base.StringTokenizer
DEFINE temptext    STRING    
DEFINE l_msg       STRING     
#str----add by guanyao160922
DEFINE l_sfb08_1    LIKE sfb_file.sfb08
DEFINE l_sfb08_2    LIKE sfb_file.sfb08
DEFINE l_sfb08_3    LIKE sfb_file.sfb08  #add by guanyao160922
DEFINE l_ta_ecd04   LIKE ecd_file.ta_ecd04  #add by guanyao160922  
DEFINE l_ecm04      LIKE ecm_file.ecm04 


#end----add by guanyao160922        
   IF g_tc_imm.tc_immconf = 'Y' THEN
      LET l_msg = "已审核，不可修改"
      CALL cl_err(l_msg,'!',1)
      RETURN
   END IF
   
   IF g_tc_imm.tc_immconf = 'X' THEN
      LET l_msg = "已作废，不可修改"
      CALL cl_err(l_msg,'!',1)
      RETURN
   END IF
   
   IF g_tc_imm.tc_imm03 = 'Y' THEN
      LET l_msg = "已过账单据，不可修改"
      CALL cl_err(l_msg,'!',1)
      RETURN
   END IF
   LET g_action_choice = ""
 
   IF s_shut(0) THEN RETURN END IF
   IF g_tc_imm.tc_imm01 IS NULL THEN RETURN END IF
   SELECT * INTO g_tc_imm.* FROM tc_imm_file WHERE tc_imm01=g_tc_imm.tc_imm01
   IF g_tc_imm.tc_immacti ='N' THEN CALL cl_err(g_tc_imm.tc_imm01,'9027',0) RETURN END IF
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT tc_imn02,tc_imn03,tc_imn04,'',tc_imn05,'','',tc_imn06,tc_imn11 ",
                      " FROM tc_imn_file",
                      " WHERE tc_imn01=? AND tc_imn02=? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i511_b1_cl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
   
   INPUT ARRAY g_tc_imn WITHOUT DEFAULTS FROM s_tc_imn.*
         ATTRIBUTE(COUNT=g_rec_b1,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
       BEFORE INPUT
           IF g_rec_b1 != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
       BEFORE ROW
          LET p_cmd=''
          LET l_ac = ARR_CURR()
          LET l_lock_sw = 'N'            #DEFAULT
 
          BEGIN WORK
          OPEN i511_cl USING g_tc_imm.tc_imm01
          IF STATUS THEN
             CALL cl_err("OPEN i511_cl:", STATUS, 1)
             CLOSE i511_cl
             ROLLBACK WORK
             RETURN
          END IF
          FETCH i511_cl INTO g_tc_imm.*            # 鎖住將被更改或取消的資料
          IF SQLCA.sqlcode THEN
             CALL cl_err(g_tc_imm.tc_imm01,SQLCA.sqlcode,0)      # 資料被他人LOCK
             CLOSE i511_cl
             ROLLBACK WORK
             RETURN
          END IF
          IF g_rec_b1 >= l_ac THEN
             LET p_cmd='u'
             LET g_tc_imn_t.* = g_tc_imn[l_ac].*  #BACKUP
             OPEN i511_b1_cl USING g_tc_imm.tc_imm01,g_tc_imn_t.tc_imn02
             IF STATUS THEN
                CALL cl_err("OPEN i511_b1_cl:", STATUS, 1)
                LET l_lock_sw = "Y"
             ELSE
                FETCH i511_b1_cl INTO g_tc_imn[l_ac].*
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_tc_imn_t.tc_imn02,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                END IF
                #str----add by guanyao160922
                SELECT ecd02 INTO g_tc_imn[l_ac].ecd02 FROM ecd_file WHERE ecd01 = g_tc_imn[l_ac].tc_imn04
                SELECT ima02,ima021 INTO g_tc_imn[l_ac].ima02,g_tc_imn[l_ac].ima021 
                  FROM ima_file WHERE ima01 = g_tc_imn[l_ac].tc_imn05
                #end----add by guanyao160922
             END IF
          END IF
          
 
       BEFORE INSERT
          LET p_cmd='a'
          LET l_n = ARR_COUNT()
          INITIALIZE g_tc_imn[l_ac].* TO NULL 
          LET g_tc_imn_t.* = g_tc_imn[l_ac].*         #新輸入資料
          LET g_tc_imn[l_ac].tc_imn04 = g_tc_imm.tc_imm08
          SELECT ecd02 INTO g_tc_imn[l_ac].ecd02 FROM ecd_file WHERE ecd01 = g_tc_imn[l_ac].tc_imn04
          DISPLAY BY NAME g_tc_imn[l_ac].tc_imn04,g_tc_imn[l_ac].ecd02
          NEXT FIELD tc_imn02
 
       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CANCEL INSERT
          END IF
          INSERT INTO tc_imn_file(tc_imn01,tc_imn02,tc_imn03,tc_imn04,tc_imn05,tc_imn06,tc_imn11)
          VALUES(g_tc_imm.tc_imm01,g_tc_imn[l_ac].tc_imn02,g_tc_imn[l_ac].tc_imn03,g_tc_imn[l_ac].tc_imn04,
                 g_tc_imn[l_ac].tc_imn05,g_tc_imn[l_ac].tc_imn06,g_tc_imn[l_ac].tc_imn11)
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","tc_imn_file",g_tc_imm.tc_imm01,g_tc_imn[l_ac].tc_imn02,SQLCA.sqlcode,"","",1)
             CANCEL INSERT
          ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b1=g_rec_b1+1
             DISPLAY g_rec_b1 TO FORMONLY.cn2
             COMMIT WORK
          END IF
 
       BEFORE FIELD tc_imn02                        #default 序號
          IF g_tc_imn[l_ac].tc_imn02 IS NULL OR g_tc_imn[l_ac].tc_imn02 = 0 THEN
             SELECT max(tc_imn02)+1
               INTO g_tc_imn[l_ac].tc_imn02
               FROM tc_imn_file
              WHERE tc_imn01 = g_tc_imm.tc_imm01
             IF g_tc_imn[l_ac].tc_imn02 IS NULL THEN
                LET g_tc_imn[l_ac].tc_imn02 = 1
             END IF
          END IF
 
       AFTER FIELD tc_imn02                        #check 序號是否重複
          IF NOT cl_null(g_tc_imn[l_ac].tc_imn02) THEN
             IF g_tc_imn[l_ac].tc_imn02 != g_tc_imn_t.tc_imn02 OR
                g_tc_imn_t.tc_imn02 IS NULL THEN
                SELECT count(*) INTO l_n FROM tc_imn_file
                 WHERE tc_imn01 = g_tc_imm.tc_imm01
                   AND tc_imn02 = g_tc_imn[l_ac].tc_imn02
                IF l_n > 0 THEN
                   CALL cl_err('',-239,0)
                   LET g_tc_imn[l_ac].tc_imn02 = g_tc_imn_t.tc_imn02
                   NEXT FIELD tc_imn02
                END IF
             END IF
          END IF

       #str-----add by guanyao160922
       AFTER FIELD tc_imn03
          IF NOT cl_null(g_tc_imn[l_ac].tc_imn03) THEN 
              #tianry add 170117
    
              SELECT ecm04 INTO l_ecm04 FROM ecm_file WHERE ecm01=g_tc_imn[l_ac].tc_imn03 AND rownum=1  ORDER BY ecm03 
              IF l_ecm04!=g_tc_imm.tc_imm08 THEN 
                 SELECT COUNT(*) INTO l_cnt FROM sfe_file WHERE sfe01=g_tc_imn[l_ac].tc_imn03
                 AND sfe14=l_ecm04 
                 IF l_cnt=0 THEN
                    CALL cl_err('','csf-992',1)
                    NEXT FIELD tc_imn03
                 END IF 
              END IF 



              #tianry add 170117

             IF g_tc_imn[l_ac].tc_imn03 != g_tc_imn_t.tc_imn03 OR
                g_tc_imn_t.tc_imn03 IS NULL THEN
                SELECT COUNT(*) INTO l_n FROM sfa_file 
                 WHERE sfa01 = g_tc_imn[l_ac].tc_imn03 
                   AND sfa08 = g_tc_imm.tc_imm08 
                 # AND sfa11 = 'E'
                IF cl_null(l_n) OR l_n = 0 THEN 
                   CALL cl_err(g_tc_imn[l_ac].tc_imn03,'csf-084',0)
                   NEXT FIELD tc_imn03
                END IF 
                CALL t512_check_sfa(g_tc_imn[l_ac].tc_imn03,g_tc_imm.tc_imm08)
                IF g_error = 'N' THEN 
                   CALL cl_err('','csf-085',0)
                   NEXT FIELD tc_imn03
                END IF 
                SELECT sfb05 INTO g_tc_imn[l_ac].tc_imn05 FROM sfb_file WHERE sfb01 = g_tc_imn[l_ac].tc_imn03
                SELECT ima02,ima021 INTO g_tc_imn[l_ac].ima02,g_tc_imn[l_ac].ima021 FROM ima_file 
                 WHERE ima01 = g_tc_imn[l_ac].tc_imn05
                DISPLAY BY NAME g_tc_imn[l_ac].tc_imn05
                DISPLAY BY NAME g_tc_imn[l_ac].tc_imn05,g_tc_imn[l_ac].ima02,g_tc_imn[l_ac].ima021
             END IF 
          END IF 
       #end-----add by guanyao160922
       
       AFTER FIELD tc_imn06
          #str----mark by guanyao160922
       	  #IF NOT cl_null(g_tc_imn[l_ac].tc_imn06) THEN
       	  #	 IF g_tc_imn[l_ac].tc_imn06 > g_tc_imn_t.tc_imn06 THEN
          #      LET l_msg = "此处数量只允许改小，不可以改大"
          #      CALL cl_err(l_msg,'!',1)
          #      NEXT FIELD tc_imn06
          #   END IF
       	  #END IF
          #end----mark by guanyao160922
       
       AFTER FIELD tc_imn11
          IF NOT cl_null(g_tc_imn[l_ac].tc_imn11) THEN 
          	 LET l_n=0
             SELECT COUNT(*) INTO l_n FROM sfb_file 
             WHERE sfb01 = g_tc_imn[l_ac].tc_imn03 AND sfb08>=g_tc_imn[l_ac].tc_imn11
             IF l_n=0 THEN 
                CALL cl_err('发料套数不得大于工单生产量','!',0)
                LET g_tc_imn[l_ac].tc_imn11=g_tc_imn_t.tc_imn11
                NEXT FIELD tc_imn11
             END IF   
          END IF      
        
       BEFORE DELETE                            #是否取消單身
          IF g_tc_imn_t.tc_imn02 > 0 AND
             g_tc_imn_t.tc_imn02 IS NOT NULL THEN
             IF NOT cl_delb(0,0) THEN
                CANCEL DELETE
             END IF
             IF l_lock_sw = "Y" THEN
                CALL cl_err("", -263, 1)
                CANCEL DELETE
             END IF
             DELETE FROM tc_imn_file
              WHERE tc_imn01 = g_tc_imm.tc_imm01
                AND tc_imn02 = g_tc_imn_t.tc_imn02
             IF SQLCA.sqlcode THEN
                CALL cl_err3("del","tc_imn_file",g_tc_imm.tc_imm01,g_tc_imn_t.tc_imn02,SQLCA.sqlcode,"","",1)
                ROLLBACK WORK
                CANCEL DELETE
             END IF
             LET g_rec_b1=g_rec_b1-1
             DISPLAY g_rec_b1 TO FORMONLY.cn2
             MESSAGE "Delete Ok"
          END IF
          COMMIT WORK
 
       ON ROW CHANGE
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_tc_imn[l_ac].* = g_tc_imn_t.*
             CLOSE i511_b1_cl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          IF l_lock_sw = 'Y' THEN
             CALL cl_err(g_tc_imn[l_ac].tc_imn02,-263,1)
             LET g_tc_imn[l_ac].* = g_tc_imn_t.*
          ELSE
             UPDATE tc_imn_file SET tc_imn02 = g_tc_imn[l_ac].tc_imn02,
                                    tc_imn03 = g_tc_imn[l_ac].tc_imn03,
                                    tc_imn04 = g_tc_imn[l_ac].tc_imn04,
                                    tc_imn05 = g_tc_imn[l_ac].tc_imn05,
                                    tc_imn06 = g_tc_imn[l_ac].tc_imn06,
                                    tc_imn11 = g_tc_imn[l_ac].tc_imn11
              WHERE tc_imn01=g_tc_imm.tc_imm01 AND tc_imn02=g_tc_imn_t.tc_imn02
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","tc_imn_file",g_tc_imm.tc_imm01,g_tc_imn_t.tc_imn02,SQLCA.sqlcode,"","",1)
                LET g_tc_imn[l_ac].* = g_tc_imn_t.*
                CLOSE i511_b1_cl
                ROLLBACK WORK
             ELSE
                MESSAGE 'UPDATE O.K'
                COMMIT WORK
             END IF
          END IF
 
       AFTER ROW
          LET l_ac = ARR_CURR()
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd = 'u' THEN
                LET g_tc_imn[l_ac].* = g_tc_imn_t.*
             ELSE
                CALL g_tc_imn.deleteElement(l_ac)
                IF g_rec_b1 != 0 THEN
                   LET g_action_choice = "accessory"
                   LET l_ac = l_ac_t
                END IF
             END IF
             CLOSE i511_b1_cl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          LET l_ac_t = l_ac
          CLOSE i511_b1_cl
          COMMIT WORK
       
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(tc_imn03)
#                CALL cl_init_qry_var()
#                LET g_qryparam.default1 = g_tc_imn[l_ac].tc_imn03
#                LET g_qryparam.form ="q_sfb011"
#                CALL cl_create_qry() RETURNING g_tc_imn[l_ac].tc_imn03
#                NEXT FIELD tc_imn03

              # CALL cq_sfb(FALSE,FALSE,g_tc_imm.tc_imm08,'','','','') RETURNING tc_imn03_str,l_str
                CALL cq_sfb2(FALSE,FALSE,g_tc_imm.tc_imm08,'','','','') RETURNING tc_imn03_str,l_str
                #NEXT FIELD tc_imn03
                   IF cl_null(tc_imn03_str) THEN
                      LET g_tc_imn[l_ac].tc_imn03 = g_tc_imn_t.tc_imn03
                      NEXT FIELD tc_imn03
                   ELSE
                      LET bst= base.StringTokenizer.create(tc_imn03_str,'|')
                      CALL s_showmsg_init()
                      LET l_cnt = 1
                      WHILE bst.hasMoreTokens()
                         LET l_tc_imn03=bst.nextToken()
                        # LET l_tc_imn03 = temptext.substring(1,temptext.getIndexOf(",",1)-1)
#                         CALL i511_g_b(l_tc_imn03,l_cnt)
#                         LET l_cnt = l_cnt + 1
                          LET g_tc_imn[l_ac].tc_imn03=l_tc_imn03
                      END WHILE
                      LET g_rec_b1 = l_cnt  #防止进入单身后提示Insert重复
#                      CALL i511_b1_fill(" 1=1")
#                      EXIT INPUT
                   END IF
             WHEN INFIELD(tc_imn04)
                CALL cl_init_qry_var()
                LET g_qryparam.default1 = g_tc_imn[l_ac].tc_imn04
                LET g_qryparam.form ="q_ecd3"
                CALL cl_create_qry() RETURNING g_tc_imn[l_ac].tc_imn04
                NEXT FIELD tc_imn04
             WHEN INFIELD(tc_imn05)
                CALL cl_init_qry_var()
                LET g_qryparam.default1 = g_tc_imn[l_ac].tc_imn05
                LET g_qryparam.form ="q_ima"
                CALL cl_create_qry() RETURNING g_tc_imn[l_ac].tc_imn05
                NEXT FIELD tc_imn05
             OTHERWISE EXIT CASE
          END CASE
       
       ON ACTION CONTROLN
          CALL i511_b1_askkey()
          EXIT INPUT
 
       ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(tc_imn02) AND l_ac > 1 THEN
               LET g_tc_imn[l_ac].* = g_tc_imn[l_ac-1].*
               NEXT FIELD tc_imn02
           END IF
 
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
         CALL cl_set_head_visible("folder01","AUTO")
   END INPUT
   LET g_tc_imm.tc_immmodu = g_user
   LET g_tc_imm.tc_immdate = g_today
   UPDATE tc_imm_file SET tc_immmodu = g_tc_imm.tc_immmodu,tc_immdate = g_tc_imm.tc_immdate
    WHERE tc_imm01 = g_tc_imm.tc_imm01
   DISPLAY BY NAME g_tc_imm.tc_immmodu,g_tc_imm.tc_immdate
 
   CLOSE i511_b1_cl
   COMMIT WORK
   IF cl_confirm('csf-512') THEN
   	  CALL i511_b2_g()
      CALL i511_b2_fill(" 1=1")
   END IF
   
END FUNCTION
 
FUNCTION i511_b2()
DEFINE
    p_cmd           LIKE type_file.chr1,                #處理狀態         
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT
    l_n             LIKE type_file.num5,                #檢查重複用        
    l_cnt           LIKE type_file.num5,                              
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否        
    l_allow_insert  LIKE type_file.num5,                #可新增否         
    l_allow_delete  LIKE type_file.num5                 #可刪除否 
#str---add by huanglf161017
DEFINE l_sfb08      LIKE sfb_file.sfb08
DEFINE l_sfb081     LIKE sfb_file.sfb081
DEFINE l_tc_imp08   LIKE tc_imp_file.tc_imp08
#str---end by huanglf161017
DEFINE l_msg       STRING               
DEFINE l_sfa056   LIKE  sfa_file.sfa05
   IF g_tc_imm.tc_immconf = 'Y' THEN
      LET l_msg = "已审核，不可修改"
      CALL cl_err(l_msg,'!',1)
      RETURN
   END IF
   
   IF g_tc_imm.tc_immconf = 'X' THEN
      LET l_msg = "已作废，不可修改"
      CALL cl_err(l_msg,'!',1)
      RETURN
   END IF
   
   IF g_tc_imm.tc_imm03 = 'Y' THEN
      LET l_msg = "已过账单据，不可修改"
      CALL cl_err(l_msg,'!',1)
      RETURN
   END IF      
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN RETURN END IF
    IF g_tc_imm.tc_imm01 IS NULL THEN RETURN END IF
    SELECT * INTO g_tc_imm.* FROM tc_imm_file WHERE tc_imm01=g_tc_imm.tc_imm01
    IF g_tc_imm.tc_immacti ='N' THEN CALL cl_err(g_tc_imm.tc_imm01,'9027',0) RETURN END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT tc_imp02,tc_imp03,tc_imp04,tc_imp05,'','',tc_imp06,'',tc_imp11,tc_imp13,tc_imp14,tc_imp07,'',tc_imp08,tc_imp09,tc_imp10 ",   #add tc_imp10 by guanyao160909
                       "  FROM tc_imp_file",
                       " WHERE tc_imp01=? AND tc_imp02=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i511_b2_cl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_tc_imp WITHOUT DEFAULTS FROM s_tc_imp.*
          ATTRIBUTE(COUNT=g_rec_b2,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           IF g_rec_b2 != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        BEFORE ROW
           LET p_cmd = ''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
 
           BEGIN WORK
           OPEN i511_cl USING g_tc_imm.tc_imm01
           IF STATUS THEN
              CALL cl_err("OPEN i511_cl:", STATUS, 1)
              CLOSE i511_cl
              ROLLBACK WORK
              RETURN
           END IF
           FETCH i511_cl INTO g_tc_imm.*            # 鎖住將被更改或取消的資料
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_tc_imm.tc_imm01,SQLCA.sqlcode,0)      # 資料被他人LOCK
              CLOSE i511_cl
              ROLLBACK WORK
              RETURN
           END IF
           IF g_rec_b2 >= l_ac THEN
              LET p_cmd='u'
              LET g_tc_imp_t.* = g_tc_imp[l_ac].*  #BACKUP
              OPEN i511_b2_cl USING g_tc_imm.tc_imm01,g_tc_imp_t.tc_imp02
              IF STATUS THEN
                 CALL cl_err("OPEN i511_b2_cl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH i511_b2_cl INTO g_tc_imp[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_tc_imp_t.tc_imp02,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
                 #str----add by guanyao160922
                 SELECT ima02,ima021 INTO g_tc_imp[l_ac].ima02_1,g_tc_imp[l_ac].ima021_1
                   FROM ima_file WHERE ima01 = g_tc_imp[l_ac].tc_imp05
                 SELECT imd02 INTO g_tc_imp[l_ac].imd02 FROM imd_file WHERE imd01 = g_tc_imp[l_ac].tc_imp06
                 SELECT gen02 INTO g_tc_imp[l_ac].gen02_1 FROM gen_file WHERE gen01 = g_tc_imp[l_ac].tc_imp07
                 #end----add by guanyao160922
              END IF
           END IF
 
        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_tc_imp[l_ac].* TO NULL
           LET g_tc_imp_t.* = g_tc_imp[l_ac].*         #新輸入資料
           NEXT FIELD tc_imp02
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           INSERT INTO tc_imp_file(tc_imp01,tc_imp02,tc_imp03,tc_imp04,tc_imp05,tc_imp06,tc_imp07,tc_imp08,tc_imp09,tc_imp10,tc_imp11,tc_imp13,tc_imp14)  #add tc_imp10 by guanyao160909
            VALUES(g_tc_imm.tc_imm01,g_tc_imp[l_ac].tc_imp02,g_tc_imp[l_ac].tc_imp03,g_tc_imp[l_ac].tc_imp04,g_tc_imp[l_ac].tc_imp05,g_tc_imp[l_ac].tc_imp06,
                   g_tc_imp[l_ac].tc_imp07,g_tc_imp[l_ac].tc_imp08,g_tc_imp[l_ac].tc_imp09,g_tc_imp[l_ac].tc_imp10,g_tc_imp[l_ac].tc_imp11,g_tc_imp[l_ac].tc_imp13,g_tc_imp[l_ac].tc_imp14)  #add tc_imp10 by guanyao160909
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","tc_imp_file",g_tc_imm.tc_imm01,g_tc_imp[l_ac].tc_imp02,SQLCA.sqlcode,"","",1)
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              LET g_rec_b2=g_rec_b2+1
              DISPLAY g_rec_b2 TO FORMONLY.cn4
              COMMIT WORK
           END IF
 
        AFTER FIELD tc_imp02                        #check 序號是否重複
           IF NOT cl_null(g_tc_imp[l_ac].tc_imp02) THEN
              IF g_tc_imp[l_ac].tc_imp02 != g_tc_imp_t.tc_imp02 OR g_tc_imp_t.tc_imp02 IS NULL THEN
                 SELECT count(*) INTO l_n FROM tc_imp_file
                  WHERE tc_imp01 = g_tc_imm.tc_imm01
                    AND tc_imp02 = g_tc_imp[l_ac].tc_imp02
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_tc_imp[l_ac].tc_imp02 = g_tc_imp_t.tc_imp02
                    NEXT FIELD tc_imp02
                 END IF
              END IF
           END IF
 #str-----add by huanglf161017          
        AFTER FIELD tc_imp08
           IF NOT cl_null(g_tc_imp[l_ac].tc_imp08) THEN
              IF g_tc_imp[l_ac].tc_imp08 != g_tc_imp_t.tc_imp08 OR g_tc_imp_t.tc_imp08 IS NULL THEN
                 { SELECT sfb08,sfb081-sfb12 INTO l_sfb08,l_sfb081 FROM sfb_file  # tianry add sfb08->sfb08+sfb08+12 计算报废数量
                  WHERE sfb01 = g_tc_imp[l_ac].tc_imp03

                  SELECT SUM(tc_imp09) INTO l_tc_imp08 FROM tc_imp_file,tc_imm_file   #tianry add tc_imp08->tc_imp09  按照实际申请量
                  WHERE tc_imp03 = g_tc_imp[l_ac].tc_imp03 AND tc_immconf !='X' AND tc_imp01 = tc_imm01
                  AND tc_imp05=g_tc_imp[l_ac].tc_imp05 #tianry add 料号匹配
                  IF cl_null(g_tc_imp_t.tc_imp08) THEN 
                     LET g_tc_imp_t.tc_imp08 = 0
                  END IF 
                  
                  IF g_tc_imp[l_ac].tc_imp08 = 0 THEN 
                      CALL cl_err('','csf-518',0)
                      NEXT FIELD tc_imp08
                  END IF
                  }
                  SELECT sfa05-sfa06 INTO l_sfa056 FROM sfa_file WHERE sfa01=g_tc_imp[l_ac].tc_imp03 AND sfa03=g_tc_imp[l_ac].tc_imp05
                  IF cl_null(l_sfa056) THEN LET l_sfa056=0 END IF
                  SELECT SUM(tc_imp08) INTO l_tc_imp08 FROM tc_imp_file,tc_imm_file
                  WHERE tc_imp03 = g_tc_imp[l_ac].tc_imp03 AND tc_immconf !='X' AND tc_imp01 = tc_imm01
                  AND tc_imp05=g_tc_imp[l_ac].tc_imp05 AND tc_imm03!='Y' #tianry add 料号匹配
                  IF cl_null(l_tc_imp08) THEN LET l_tc_imp08=0 END IF 


                  IF  g_tc_imp[l_ac].tc_imp08 > l_sfa056-l_tc_imp08 THEN  #l_sfb08 - l_sfb081 THEN  #- l_tc_imp08 + g_tc_imp_t.tc_imp08  THEN 
                      CALL cl_err('','csf-517',0)
                      LET g_tc_imp[l_ac].tc_imp08 = l_sfb08 - l_sfb081 - l_tc_imp08 + g_tc_imp_t.tc_imp08
                      DISPLAY BY NAME g_tc_imp[l_ac].tc_imp08 
                      NEXT FIELD tc_imp08
                  END IF 
              END IF
           END IF
#str----end by huanglf161017
        BEFORE DELETE                            #是否取消單身
           IF g_tc_imp_t.tc_imp02 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM tc_imp_file
               WHERE tc_imp01 = g_tc_imm.tc_imm01
                 AND tc_imp02 = g_tc_imp_t.tc_imp02
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","tc_imp_file",g_tc_imm.tc_imm01,g_tc_imp_t.tc_imp02,SQLCA.sqlcode,"","",1)
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b2=g_rec_b2-1
              DISPLAY g_rec_b2 TO FORMONLY.cn4
              MESSAGE "Delete Ok"
           END IF
           COMMIT WORK
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_tc_imp[l_ac].* = g_tc_imp_t.*
               CLOSE i511_b2_cl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_tc_imp[l_ac].tc_imp02,-263,1)
               LET g_tc_imp[l_ac].* = g_tc_imp_t.*
            ELSE
               UPDATE tc_imp_file SET tc_imp02 = g_tc_imp[l_ac].tc_imp02,
                                      tc_imp03 = g_tc_imp[l_ac].tc_imp03,
                                      tc_imp04 = g_tc_imp[l_ac].tc_imp04,
                                      tc_imp05 = g_tc_imp[l_ac].tc_imp05,
                                      tc_imp06 = g_tc_imp[l_ac].tc_imp06,
                                      tc_imp07 = g_tc_imp[l_ac].tc_imp07,
                                      tc_imp08 = g_tc_imp[l_ac].tc_imp08,
                                      tc_imp09 = g_tc_imp[l_ac].tc_imp09
                                      ,tc_imp10 = g_tc_imp[l_ac].tc_imp10
                                      ,tc_imp11 = g_tc_imp[l_ac].tc_imp11
                                      ,tc_imp13 = g_tc_imp[l_ac].tc_imp13
                                      ,tc_imp14 = g_tc_imp[l_ac].tc_imp14
                WHERE tc_imp01=g_tc_imm.tc_imm01
                  AND tc_imp02=g_tc_imp_t.tc_imp02
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","tc_imp_file",g_tc_imm.tc_imm01,g_tc_imp_t.tc_imp02,SQLCA.sqlcode,"","",1)
                  LET g_tc_imp[l_ac].* = g_tc_imp_t.*
                  CLOSE i511_b2_cl
                  ROLLBACK WORK
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_tc_imp[l_ac].* = g_tc_imp_t.*
               ELSE
                  CALL g_tc_imp.deleteElement(l_ac)
                  IF g_rec_b2 != 0 THEN
                     LET g_action_choice = "user_defined_columns"
                     LET l_ac = l_ac_t
                  END IF
               END IF
               CLOSE i511_b2_cl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac
            CLOSE i511_b2_cl
            COMMIT WORK
 
        ON ACTION CONTROLN
           CALL i511_b2_askkey()
           EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(tc_imp02) AND l_ac > 1 THEN
               LET g_tc_imp[l_ac].* = g_tc_imp[l_ac-1].*
               NEXT FIELD tc_imp02
           END IF
 
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
           CALL cl_set_head_visible("folder01","AUTO")                            
    END INPUT
 
    LET g_tc_imm.tc_immmodu = g_user
    LET g_tc_imm.tc_immdate = g_today
    UPDATE tc_imm_file SET tc_immmodu = g_tc_imm.tc_immmodu,tc_immdate = g_tc_imm.tc_immdate
     WHERE tc_imm01 = g_tc_imm.tc_imm01
    DISPLAY BY NAME g_tc_imm.tc_immmodu,g_tc_imm.tc_immdate
 
    CLOSE i511_b2_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i511_b3()
DEFINE
   l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT
   l_n             LIKE type_file.num5,                #檢查重複用        
   l_lock_sw       LIKE type_file.chr1,                #單身鎖住否        
   p_cmd           LIKE type_file.chr1,                #處理狀態         
   l_exit_sw       LIKE type_file.chr1,                              
   l_allow_insert  LIKE type_file.num5,                #可新增否         
   l_allow_delete  LIKE type_file.num5                 #可刪除否  
DEFINE l_msg       STRING               
DEFINE l_warehouse LIKE type_file.chr1
DEFINE l_msg1,l_msg2 LIKE type_file.chr1000  #add by huanglf160928
DEFINE l_tc_imp08 LIKE tc_imp_file.tc_imp08 #add by huanglf160928
DEFINE l_tc_imq14 LIKE tc_imq_file.tc_imq14 #add by huanglf160928
   #IF g_tc_imm.tc_immconf = 'Y' THEN
   #   LET l_msg = "已审核，不可修改"
   #   CALL cl_err(l_msg,'!',1)
   #   RETURN
   #END IF
   
   IF g_tc_imm.tc_immconf = 'X' THEN
      LET l_msg = "已作废，不可修改"
      CALL cl_err(l_msg,'!',1)
      RETURN
   END IF
   
   IF g_tc_imm.tc_imm03 = 'Y' THEN
      LET l_msg = "已过账单据，不可修改"
      CALL cl_err(l_msg,'!',1)
      RETURN
   END IF       
 
   LET g_action_choice = ""
 
   IF s_shut(0) THEN RETURN END IF
   IF g_tc_imm.tc_imm01 IS NULL THEN RETURN END IF
   SELECT * INTO g_tc_imm.* FROM tc_imm_file WHERE tc_imm01=g_tc_imm.tc_imm01
   IF g_tc_imm.tc_immacti ='N' THEN CALL cl_err(g_tc_imm.tc_imm01,'9027',0) RETURN END IF
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT tc_imq02,tc_imq03,tc_imq04,tc_imq05,'','',tc_imq06,",
                      "       tc_imq07,tc_imq08,tc_imq09,tc_imq10,tc_imq11,",
                      "       tc_imq12,tc_imq13,tc_imq14,tc_imq15,tc_imq16,",
                      "       tc_imq17,'',tc_imq18 ",
                      " FROM tc_imq_file",
                      " WHERE tc_imq01=? AND tc_imq02=? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i511_b3_cl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_tc_imq WITHOUT DEFAULTS FROM s_tc_imq.*
         ATTRIBUTE(COUNT=g_rec_b3,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
       BEFORE INPUT
           IF g_rec_b3 != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
       BEFORE ROW
          LET p_cmd=''
          LET l_ac = ARR_CURR()
          LET l_lock_sw = 'N'            #DEFAULT
 
          BEGIN WORK
          OPEN i511_cl USING g_tc_imm.tc_imm01
          IF STATUS THEN
             CALL cl_err("OPEN i511_cl:", STATUS, 1)
             CLOSE i511_cl
             ROLLBACK WORK
             RETURN
          END IF
          FETCH i511_cl INTO g_tc_imm.*            # 鎖住將被更改或取消的資料
          IF SQLCA.sqlcode THEN
             CALL cl_err(g_tc_imm.tc_imm01,SQLCA.sqlcode,0)      # 資料被他人LOCK
             CLOSE i511_cl
             ROLLBACK WORK
             RETURN
          END IF
          IF g_rec_b3 >= l_ac THEN
             LET p_cmd='u'
             LET g_tc_imq_t.* = g_tc_imq[l_ac].*  #BACKUP
             LET g_tc_imq05_t = g_tc_imq[l_ac].tc_imq05      #FUN-BB0084 
             OPEN i511_b3_cl USING g_tc_imm.tc_imm01,g_tc_imq_t.tc_imq02
             IF STATUS THEN
                CALL cl_err("OPEN i511_b3_cl:", STATUS, 1)
                LET l_lock_sw = "Y"
             ELSE
                FETCH i511_b3_cl INTO g_tc_imq[l_ac].*
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_tc_imq_t.tc_imq02,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                END IF
                #str----add by guanyao160923
                SELECT ima02,ima021 INTO g_tc_imq[l_ac].ima02_2,g_tc_imq[l_ac].ima021_2 FROM ima_file WHERE ima01 = g_tc_imq[l_ac].tc_imq05
                #end----add by guanyao160923
             END IF
          END IF
 
       BEFORE INSERT
          LET p_cmd='a'
          LET l_n = ARR_COUNT()
          INITIALIZE g_tc_imq[l_ac].* TO NULL      #900423
          LET g_tc_imq_t.* = g_tc_imq[l_ac].*         #新輸入資料
          LET g_tc_imq05_t = g_tc_imq[l_ac].tc_imq05     #FUN-BB0084 
          LET g_tc_imq[l_ac].tc_imq06=0
          NEXT FIELD tc_imq02
 
       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CANCEL INSERT
          END IF
          INSERT INTO tc_imq_file(tc_imq01,tc_imq02,tc_imq03,tc_imq04,tc_imq05,tc_imq06,
                                  tc_imq07,tc_imq08,tc_imq09,tc_imq10,tc_imq11,
                                  tc_imq12,tc_imq13,tc_imq14,tc_imq15,tc_imq16,
                                  tc_imq17,tc_imq18)
          VALUES(g_tc_imm.tc_imm01,g_tc_imq[l_ac].tc_imq02,g_tc_imq[l_ac].tc_imq03,g_tc_imq[l_ac].tc_imq04,g_tc_imq[l_ac].tc_imq05,
                 g_tc_imq[l_ac].tc_imq06,g_tc_imq[l_ac].tc_imq07,g_tc_imq[l_ac].tc_imq08,g_tc_imq[l_ac].tc_imq09,g_tc_imq[l_ac].tc_imq10,
                 g_tc_imq[l_ac].tc_imq11,g_tc_imq[l_ac].tc_imq12,g_tc_imq[l_ac].tc_imq13,g_tc_imq[l_ac].tc_imq14,g_tc_imq[l_ac].tc_imq15,
                 g_tc_imq[l_ac].tc_imq16,g_tc_imq[l_ac].tc_imq17,g_tc_imq[l_ac].tc_imq18)

          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","tc_imq_file",g_tc_imm.tc_imm01,g_tc_imq[l_ac].tc_imq02,SQLCA.sqlcode,"","",1)
             CANCEL INSERT
          ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b3=g_rec_b3+1
             DISPLAY g_rec_b3 TO FORMONLY.cn4
             COMMIT WORK
          END IF
 
       BEFORE FIELD tc_imq02                        #default 序號
          IF g_tc_imq[l_ac].tc_imq02 IS NULL OR g_tc_imq[l_ac].tc_imq02 = 0 THEN
             SELECT max(tc_imq02)+1
               INTO g_tc_imq[l_ac].tc_imq02
               FROM tc_imq_file
              WHERE tc_imq01 = g_tc_imm.tc_imm01
             IF g_tc_imq[l_ac].tc_imq02 IS NULL THEN
                LET g_tc_imq[l_ac].tc_imq02 = 1
             END IF
          END IF
 
       AFTER FIELD tc_imq02                        #check 序號是否重複
          IF NOT cl_null(g_tc_imq[l_ac].tc_imq02) THEN
             IF g_tc_imq[l_ac].tc_imq02 != g_tc_imq_t.tc_imq02 OR
                g_tc_imq_t.tc_imq02 IS NULL THEN
                SELECT COUNT(*) INTO l_n FROM tc_imq_file
                 WHERE tc_imq01 = g_tc_imm.tc_imm01
                   AND tc_imq02 = g_tc_imq[l_ac].tc_imq02
                IF l_n > 0 THEN
                   CALL cl_err('',-239,0)
                   LET g_tc_imq[l_ac].tc_imq02 = g_tc_imq_t.tc_imq02
                   NEXT FIELD tc_imq02
                END IF
             END IF
          END IF

#str----add by huanglf160928
      AFTER FIELD tc_imq14
          IF NOT cl_null(g_tc_imq[l_ac].tc_imq14) THEN
             IF g_tc_imq[l_ac].tc_imq14 != g_tc_imq_t.tc_imq14 OR
                g_tc_imq_t.tc_imq14 IS NULL THEN
               --SELECT tc_imp08 INTO l_tc_imp08 FROM tc_imp_file WHERE tc_imp03 = g_tc_imq[l_ac].tc_imq03 
                                                --AND tc_imp04 = g_tc_imq[l_ac].tc_imq04
                                                --AND tc_imp05 = g_tc_imq[l_ac].tc_imq05
                                                --AND tc_imp01 = g_tc_imm.tc_imm01
               --SELECT SUM(tc_imq14) INTO l_tc_imq14 FROM tc_imq_file WHERE tc_imq03 = g_tc_imq[l_ac].tc_imq03 
                                                --AND tc_imq04 = g_tc_imq[l_ac].tc_imq04
                                                --AND tc_imq05 = g_tc_imq[l_ac].tc_imq05
                                                --AND tc_imq01 = g_tc_imm.tc_imm01
                                                --AND tc_imq02 != g_tc_imq[l_ac].tc_imq02
               --IF cl_null(l_tc_imq14) THEN 
                  --LET l_tc_imq14 = 0
               --END IF 
               --IF cl_null(l_tc_imp08) THEN 
                  --LET l_tc_imp08 = 0
               --END IF 
               --IF l_tc_imp08 < (l_tc_imq14 + g_tc_imq[l_ac].tc_imq14) THEN 
                     --LET g_tc_imq[l_ac].tc_imq14 = l_tc_imp08 - l_tc_imq14
                     --DISPLAY BY NAME g_tc_imq[l_ac].tc_imq14
                      --CALL cl_err('','csf-514',0)
                      --NEXT FIELD tc_imq14  
               --END IF        #mark by huanglf160929                           
                LET g_tc_imq[l_ac].tc_imq15 = g_tc_imq[l_ac].tc_imq14  
                DISPLAY BY NAME g_tc_imq[l_ac].tc_imq15
             END IF 
          END IF 
#str----end by huanglf160928

#str----add by huanglf160928 #mark by huanglf160928
    --BEFORE FIELD tc_imq06
    --LET l_warehouse = '1'
--
    --BEFORE FIELD tc_imq10
    --LET l_warehouse = '2'
#str----end by huanglf160928
 
       BEFORE DELETE                            #是否取消單身
          IF g_tc_imq_t.tc_imq02 > 0 AND
             g_tc_imq_t.tc_imq02 IS NOT NULL THEN
             IF NOT cl_delb(0,0) THEN
                CANCEL DELETE
             END IF
             IF l_lock_sw = "Y" THEN
                CALL cl_err("", -263, 1)
                CANCEL DELETE
             END IF
             DELETE FROM tc_imq_file
              WHERE tc_imq01 = g_tc_imm.tc_imm01
                AND tc_imq02 = g_tc_imq_t.tc_imq02
             IF SQLCA.sqlcode THEN
                CALL cl_err3("del","tc_imq_file",g_tc_imm.tc_imm01,g_tc_imq_t.tc_imq02,SQLCA.sqlcode,"","",1)
                ROLLBACK WORK
                CANCEL DELETE
             END IF
             LET g_rec_b3=g_rec_b3-1
             DISPLAY g_rec_b3 TO FORMONLY.cn4
             MESSAGE "Delete Ok"
          END IF
          COMMIT WORK
 
       ON ROW CHANGE
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_tc_imq[l_ac].* = g_tc_imq_t.*
             CLOSE i511_b3_cl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          IF l_lock_sw = 'Y' THEN
             CALL cl_err(g_tc_imq[l_ac].tc_imq02,-263,1)
             LET g_tc_imq[l_ac].* = g_tc_imq_t.*
          ELSE
             UPDATE tc_imq_file SET tc_imq02 = g_tc_imq[l_ac].tc_imq02,
                                    tc_imq03 = g_tc_imq[l_ac].tc_imq03,
                                    tc_imq04 = g_tc_imq[l_ac].tc_imq04,
                                    tc_imq05 = g_tc_imq[l_ac].tc_imq05,
                                    tc_imq06 = g_tc_imq[l_ac].tc_imq06,
                                    tc_imq07 = g_tc_imq[l_ac].tc_imq07,
                                    tc_imq08 = g_tc_imq[l_ac].tc_imq08,
                                    tc_imq09 = g_tc_imq[l_ac].tc_imq09,
                                    tc_imq10 = g_tc_imq[l_ac].tc_imq10,
                                    tc_imq11 = g_tc_imq[l_ac].tc_imq11,
                                    tc_imq12 = g_tc_imq[l_ac].tc_imq12,
                                    tc_imq13 = g_tc_imq[l_ac].tc_imq13,
                                    tc_imq14 = g_tc_imq[l_ac].tc_imq14,
                                    tc_imq15 = g_tc_imq[l_ac].tc_imq15,
                                    tc_imq16 = g_tc_imq[l_ac].tc_imq16,
                                    tc_imq17 = g_tc_imq[l_ac].tc_imq17,
                                    tc_imq18 = g_tc_imq[l_ac].tc_imq18
              WHERE tc_imq01=g_tc_imm.tc_imm01 AND tc_imq02=g_tc_imq_t.tc_imq02
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","tc_imq_file",g_tc_imm.tc_imm01,g_tc_imq_t.tc_imq02,SQLCA.sqlcode,"","",1)
                LET g_tc_imq[l_ac].* = g_tc_imq_t.*
                CLOSE i511_b3_cl
                ROLLBACK WORK
             ELSE
                MESSAGE 'UPDATE O.K'
                COMMIT WORK
             END IF
          END IF
 
       AFTER ROW
          LET l_ac = ARR_CURR()
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd = 'u' THEN
                LET g_tc_imq[l_ac].* = g_tc_imq_t.*
             ELSE
                CALL g_tc_imq.deleteElement(l_ac)
                IF g_rec_b3 != 0 THEN
                   LET g_action_choice = "spare_part"
                   LET l_ac = l_ac_t
                END IF
             END IF
             CLOSE i511_b3_cl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          LET l_ac_t = l_ac
          CLOSE i511_b3_cl
          COMMIT WORK
 
       ON ACTION CONTROLN
          CALL i511_b3_askkey()
          EXIT INPUT
 
       ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(tc_imq02) AND l_ac > 1 THEN
               LET g_tc_imq[l_ac].* = g_tc_imq[l_ac-1].*
               NEXT FIELD tc_imq02
           END IF
 
       ON ACTION CONTROLP
          CASE
            # WHEN INFIELD(tc_imq03)
            #    CALL q_sel_ima(FALSE, "q_ima", "", g_tc_imq[l_ac].tc_imq03 , "", "", "", "" ,"",'' )  RETURNING g_tc_imq[l_ac].tc_imq03 
            #    NEXT FIELD tc_imq03
            # WHEN INFIELD(tc_imq04)
            #    CALL cl_init_qry_var()
            #    LET g_qryparam.default1 = g_tc_imq[l_ac].tc_imq04
            #    LET g_qryparam.form ="q_fiz"
            #    CALL cl_create_qry() RETURNING g_tc_imq[l_ac].tc_imq04
            #    NEXT FIELD tc_imq04
            # WHEN INFIELD(tc_imq05)
            #    CALL cl_init_qry_var()
            #    LET g_qryparam.default1 = g_tc_imq[l_ac].tc_imq04
            #    LET g_qryparam.form ="q_gfe"
            #    CALL cl_create_qry() RETURNING g_tc_imq[l_ac].tc_imq04
            #    NEXT FIELD tc_imq05
            #str-----add by guanyao160923
            WHEN INFIELD(tc_imq06) OR INFIELD(tc_imq07) OR INFIELD(tc_imq08) 
               LET g_ima906 = NULL
               SELECT ima906 INTO g_ima906 FROM ima_file
                WHERE ima01 = g_tc_imq[l_ac].tc_imq05
               CALL q_img4(FALSE,TRUE,g_tc_imq[l_ac].tc_imq05,g_tc_imq[l_ac].tc_imq06,g_tc_imq[l_ac].tc_imq07,g_tc_imq[l_ac].tc_imq08,'A')
                  RETURNING g_tc_imq[l_ac].tc_imq06,g_tc_imq[l_ac].tc_imq07,
                             g_tc_imq[l_ac].tc_imq08
               DISPLAY g_tc_imq[l_ac].tc_imq06 TO tc_imq06
               DISPLAY g_tc_imq[l_ac].tc_imq07 TO tc_imq07
               DISPLAY g_tc_imq[l_ac].tc_imq08 TO tc_imq08
#str---add by huanglf160928
                IF cl_null(g_tc_imq[l_ac].tc_imq07) THEN LET g_tc_imq[l_ac].tc_imq07 = ' ' END IF
                IF cl_null(g_tc_imq[l_ac].tc_imq08) THEN LET g_tc_imq[l_ac].tc_imq08 = ' ' END IF
               LET g_tc_imq[l_ac].tc_imq12 = g_tc_imq[l_ac].tc_imq08
               DISPLAY g_tc_imq[l_ac].tc_imq12 TO tc_imq12
#str---end by huanglf160928
               IF INFIELD(tc_imq06) THEN NEXT FIELD tc_imq06 END IF
               IF INFIELD(tc_imq07) THEN NEXT FIELD tc_imq07 END IF
               IF INFIELD(tc_imq08) THEN NEXT FIELD tc_imq08 END IF
             #end-----add by guanyao160923

          #str-----add by huanglf160928 #mark by huanglf160928
            --WHEN INFIELD(tc_imq10) OR INFIELD(tc_imq11) OR INFIELD(tc_imq12) 
               --LET g_ima906 = NULL
               --SELECT ima906 INTO g_ima906 FROM ima_file
                --WHERE ima01 = g_tc_imq[l_ac].tc_imq05
               --CALL q_img4(FALSE,TRUE,g_tc_imq[l_ac].tc_imq05,g_tc_imq[l_ac].tc_imq10,g_tc_imq[l_ac].tc_imq11,g_tc_imq[l_ac].tc_imq12,'A')
                  --RETURNING g_tc_imq[l_ac].tc_imq10,g_tc_imq[l_ac].tc_imq11,
                             --g_tc_imq[l_ac].tc_imq12
               --DISPLAY g_tc_imq[l_ac].tc_imq10 TO tc_imq10
               --DISPLAY g_tc_imq[l_ac].tc_imq11 TO tc_imq11
               --DISPLAY g_tc_imq[l_ac].tc_imq12 TO tc_imq12
--
               --LET g_tc_imq[l_ac].tc_imq12 = g_tc_imq[l_ac].tc_imq08
               --DISPLAY g_tc_imq[l_ac].tc_imq12 TO tc_imq12
               --
               --IF cl_null(g_imn[l_ac].imn16) THEN LET g_imn[l_ac].imn16 = ' ' END IF
               --IF cl_null(g_imn[l_ac].imn17) THEN LET g_imn[l_ac].imn17 = ' ' END IF
               --IF INFIELD(tc_imq10) THEN NEXT FIELD tc_imq10 END IF
               --IF INFIELD(tc_imq11) THEN NEXT FIELD tc_imq11 END IF
               --IF INFIELD(tc_imq12) THEN NEXT FIELD tc_imq12 END IF
          #end-----add by huanglf160928
             OTHERWISE EXIT CASE
          END CASE

#str----add by huanglf160928
     --ON ACTION q_imd    #查詢倉庫
         --CALL cl_init_qry_var()
         --LET g_qryparam.form ="q_imd"
         --CASE l_warehouse
            --WHEN "1"
                 --LET g_qryparam.default1 = g_tc_imq[l_ac].tc_imq06
                 --LET g_qryparam.arg1 = 'SW'        #倉庫類別
                 --CALL cl_create_qry() RETURNING g_tc_imq[l_ac].tc_imq06
                 --NEXT FIELD tc_imq06
            --WHEN "2"
                 --LET g_qryparam.default1 = g_tc_imq[l_ac].tc_imq10
                 --LET g_qryparam.arg1 = 'SW'        #倉庫類別
                 --CALL cl_create_qry() RETURNING g_tc_imq[l_ac].tc_imq10
                 --NEXT FIELD tc_imq10
            --OTHERWISE
                 --LET g_qryparam.arg1 = 'SW'        #倉庫類別
                 --CALL cl_create_qry() RETURNING l_msg1
         --END CASE
--
     --ON ACTION q_ime    #查詢倉庫儲位
         --CALL cl_init_qry_var()
         --LET g_qryparam.form ="q_ime1"
         --CASE l_warehouse
            --WHEN "1"
                 --LET g_qryparam.arg1     = 'SW'        #倉庫類別
                 --LET g_qryparam.default1 = g_tc_imq[l_ac].tc_imq06
                 --LET g_qryparam.default2 = g_tc_imq[l_ac].tc_imq07
                 --CALL cl_create_qry() RETURNING g_tc_imq[l_ac].tc_imq06,g_tc_imq[l_ac].tc_imq07
                 --NEXT FIELD tc_imq06
            --WHEN "2"
                 --LET g_qryparam.arg1     = 'SW'        #倉庫類別
                 --LET g_qryparam.default1 = g_tc_imq[l_ac].tc_imq10
                 --LET g_qryparam.default2 = g_tc_imq[l_ac].tc_imq11
                 --CALL cl_create_qry() RETURNING g_tc_imq[l_ac].tc_imq10,g_tc_imq[l_ac].tc_imq11
                 --NEXT FIELD tc_imq10
            --OTHERWISE
                 --LET g_qryparam.arg1 = 'SW'        #倉庫類別
                 --CALL cl_create_qry() RETURNING l_msg1,l_msg2
         --END CASE
     #end CHI-A30004 add    
--

#str----end by huanglf160928

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
         CALL cl_set_head_visible("folder01","AUTO")                            

   END INPUT

   LET g_tc_imm.tc_immmodu = g_user
   LET g_tc_imm.tc_immdate = g_today
   UPDATE tc_imm_file SET tc_immmodu = g_tc_imm.tc_immmodu,tc_immdate = g_tc_imm.tc_immdate
    WHERE tc_imm01 = g_tc_imm.tc_imm01
   DISPLAY BY NAME g_tc_imm.tc_immmodu,g_tc_imm.tc_immdate

   CLOSE i511_b3_cl
   COMMIT WORK
 
END FUNCTION

FUNCTION i511_b1_askkey()  
    DEFINE l_wc2           STRING
 
    CONSTRUCT l_wc2 ON tc_imn02,tc_imn03
            FROM s_tc_imn[1].tc_imn02,s_tc_imn[1].tc_imn03

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
         
      ON ACTION qbe_select
         CALL cl_qbe_select()
                 
      ON ACTION qbe_save
		     CALL cl_qbe_save()
    END CONSTRUCT
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL i511_b1_fill(l_wc2)
END FUNCTION
 
FUNCTION i511_b1_fill(p_wc1)
DEFINE  p_wc1           STRING
 
    IF cl_null(p_wc1) THEN LET p_wc1 = ' 1=1' END IF
    LET g_sql = "SELECT tc_imn02,tc_imn03,tc_imn04,'',tc_imn05,'','',tc_imn06,tc_imn11",
                "  FROM tc_imn_file",
                " WHERE tc_imn01 ='",g_tc_imm.tc_imm01,"'",
                "   AND ",p_wc1 CLIPPED,
                " ORDER BY 1"
    PREPARE i511_pb1 FROM g_sql
    DECLARE tc_imn_curs1 CURSOR FOR i511_pb1
 
    CALL g_tc_imn.clear()
    LET l_ac = 1
    FOREACH tc_imn_curs1 INTO g_tc_imn[l_ac].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       	
       SELECT ima02,ima021 INTO g_tc_imn[l_ac].ima02,g_tc_imn[l_ac].ima021 FROM ima_file WHERE ima01 = g_tc_imn[l_ac].tc_imn05
       SELECT ecd02 INTO g_tc_imn[l_ac].ecd02 FROM ecd_file WHERE ecd01 = g_tc_imn[l_ac].tc_imn04
       LET l_ac=l_ac+1
       IF l_ac > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_tc_imn.deleteElement(l_ac)
    DISPLAY ARRAY g_tc_imn TO s_tc_imn.* ATTRIBUTE(COUNT=l_ac-1,UNBUFFERED)
       BEFORE DISPLAY
          EXIT DISPLAY
    END DISPLAY
    LET g_rec_b1 = l_ac-1
    #DISPLAY g_rec_b1 TO FORMONLY.cn2
END FUNCTION
 
FUNCTION i511_b2_askkey() 
    DEFINE l_wc2           STRING    #TQC-630166    
 
    CONSTRUCT l_wc2 ON tc_imp02,tc_imp03
            FROM s_tc_imp[1].tc_imp02,s_tc_imp[1].tc_imp03

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

       ON ACTION qbe_select
         	CALL cl_qbe_select()
                
       ON ACTION qbe_save
		      CALL cl_qbe_save()
 
    END CONSTRUCT
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL i511_b2_fill(l_wc2)
END FUNCTION
 
FUNCTION i511_b2_fill(p_wc2)
DEFINE p_wc2           STRING
 
    IF cl_null(p_wc2) THEN LET p_wc2 = ' 1=1' END IF
    LET g_sql = "SELECT tc_imp02,tc_imp03,tc_imp04,tc_imp05,'','',tc_imp06,'',tc_imp11,tc_imp13,tc_imp14,tc_imp07,'',tc_imp08,tc_imp09,tc_imp10 ",  #add tc_imp10 by guanyao160909
                " FROM tc_imp_file",
                " WHERE tc_imp01 ='",g_tc_imm.tc_imm01,"'",
                "   AND ",p_wc2 CLIPPED,
                " ORDER BY 1"
    PREPARE i511_pb2 FROM g_sql
    DECLARE tc_imp_curs2 CURSOR FOR i511_pb2
 
    CALL g_tc_imp.clear()
    LET g_cnt = 1
    FOREACH tc_imp_curs2 INTO g_tc_imp[g_cnt].*   #單身 ARRAY 填充
    	 SELECT ima02,ima021 INTO g_tc_imp[g_cnt].ima02_1, g_tc_imp[g_cnt].ima021_1 FROM ima_file WHERE ima01 =  g_tc_imp[g_cnt].tc_imp05
       SELECT gen02 INTO g_tc_imp[g_cnt].gen02_1 FROM gen_file WHERE gen01 =  g_tc_imp[g_cnt].tc_imp07
       IF NOT cl_null(g_tc_imp[g_cnt].tc_imp06) THEN 
          SELECT imd02 INTO  g_tc_imp[g_cnt].imd02 FROM imd_file WHERE imd01 =  g_tc_imp[g_cnt].tc_imp06
       END IF 
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
    CALL g_tc_imp.deleteElement(g_cnt)
    LET g_rec_b2 = g_cnt-1
    DISPLAY g_rec_b2 TO FORMONLY.cn2
END FUNCTION
 
FUNCTION i511_b3_askkey()
    DEFINE l_wc2           STRING
 
    CONSTRUCT l_wc2 ON tc_imq02,tc_imq03,tc_imq04,tc_imq05,tc_imq06
         FROM s_tc_imq[1].tc_imq02,s_tc_imq[1].tc_imq03,s_tc_imq[1].tc_imq04,
              s_tc_imq[1].tc_imq05,s_tc_imq[1].tc_imq06

       BEFORE CONSTRUCT
          CALL cl_qbe_init()
 
       ON ACTION CONTROLP
         { CASE
             WHEN INFIELD(tc_imq03)
                CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO tc_imq03
                NEXT FIELD tc_imq03
             WHEN INFIELD(tc_imq04)
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                LET g_qryparam.form ="q_fiz"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO tc_imq04
                NEXT FIELD tc_imq04
             WHEN INFIELD(tc_imq05)
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                LET g_qryparam.form ="q_gfe"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO tc_imq05
                NEXT FIELD tc_imq05
             OTHERWISE EXIT CASE
          END CASE}
 
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
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL i511_b3_fill(l_wc2)
END FUNCTION
 
FUNCTION i511_b3_fill(p_wc3)
DEFINE p_wc3           STRING
 
    IF cl_null(p_wc3) THEN LET p_wc3 = ' 1=1' END IF
    LET g_sql = "SELECT tc_imq02,tc_imq03,tc_imq04,tc_imq05,'','',tc_imq06, ",
                "       tc_imq07,tc_imq08,tc_imq09,tc_imq10,tc_imq11,",
                "       tc_imq12,tc_imq13,tc_imq14,tc_imq15,tc_imq16,",
                "       tc_imq17,'',tc_imq18 ", 
                "  FROM tc_imq_file LEFT OUTER JOIN ima_file ON tc_imq_file.tc_imq05=ima_file.ima01",
                " WHERE tc_imq01 ='",g_tc_imm.tc_imm01,"'",
                "   AND ",p_wc3 CLIPPED,
                " ORDER BY 1"
    PREPARE i511_pb3 FROM g_sql
    DECLARE tc_imq_curs3 CURSOR FOR i511_pb3
 
    CALL g_tc_imq.clear()
    LET l_ac = 1
    FOREACH tc_imq_curs3 INTO g_tc_imq[l_ac].*   #單身 ARRAY 填充
    	 SELECT ima02,ima021 INTO g_tc_imq[l_ac].ima02_2, g_tc_imq[l_ac].ima021_2 FROM ima_file WHERE ima01 =  g_tc_imq[l_ac].tc_imq05
       SELECT azf03 INTO g_tc_imq[l_ac].azf03 FROM azf_file WHERE azf01 = g_tc_imq[l_ac].tc_imq17
       #IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       LET l_ac=l_ac+1
       IF l_ac > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_tc_imq.deleteElement(l_ac)
    LET g_rec_b3 = l_ac-1
    DISPLAY g_rec_b3 TO FORMONLY.cn2
END FUNCTION

FUNCTION i511_bp1(p_ud)
   DEFINE p_ud   LIKE type_file.chr1
   DEFINE l_cmd  LIKE type_file.chr1000

   IF p_ud <> "G" OR g_action_choice = "Page1" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_tc_imn TO s_tc_imn.* ATTRIBUTE(COUNT=g_rec_b1)
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()      
         EXIT DISPLAY
 
      ON ACTION help          
         CALL cl_show_help()  
         EXIT DISPLAY
 
      ON ACTION controlg      
         CALL cl_cmdask()     
         EXIT DISPLAY
 
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
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
      ON ACTION first
         CALL i511_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)
           END IF
         EXIT DISPLAY
      ON ACTION previous
         CALL i511_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)
           END IF
         EXIT DISPLAY
      ON ACTION jump
         CALL i511_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)
           END IF
         EXIT DISPLAY
      ON ACTION next
         CALL i511_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)
           END IF
         EXIT DISPLAY
      ON ACTION last
         CALL i511_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)
           END IF
         EXIT DISPLAY
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION close
         LET g_action_choice="exit"
         EXIT DISPLAY
                                           
      ON ACTION controls                                        
         CALL cl_set_head_visible("folder01","AUTO")                    
         
      ON ACTION related_document
         LET g_action_choice="related_document"          
         EXIT DISPLAY
         
      ON ACTION modify_wo
         LET g_action_choice="modify_wo"  
         LET l_ac = ARR_CURR()        
         EXIT DISPLAY
      
      ON ACTION create_des
         LET g_action_choice="create_des"          
         EXIT DISPLAY
         
      ON ACTION confirm
         LET g_action_choice="confirm"          
         EXIT DISPLAY
      
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"          
         EXIT DISPLAY
      
      ON ACTION post
         LET g_action_choice="post"          
         EXIT DISPLAY
         
      ON ACTION undo_post
         LET g_action_choice="undo_post"          
         EXIT DISPLAY
      
      ON ACTION del_tc_im
         LET g_action_choice="del_tc_im"
         EXIT DISPLAY
      &include "qry_string.4gl"
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION i511_bp2(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1

   IF p_ud <> "G" THEN 
      RETURN
   END IF
   
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel,user_defined_columns", FALSE)
   DISPLAY ARRAY g_tc_imp TO s_tc_imp.* ATTRIBUTE(COUNT=g_rec_b2)
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
     ON ACTION Page2
        LET l_action_flag = "Page2"
     EXIT DISPLAY

      ON ACTION page_list
	LET l_action_flag = "page_list"
      EXIT DISPLAY

      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION controlg      
         CALL cl_cmdask()     
 
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
      ON ACTION first
         CALL i511_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)
           END IF
         EXIT DISPLAY
      ON ACTION previous
         CALL i511_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)
           END IF
         EXIT DISPLAY
      ON ACTION jump
         CALL i511_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)
           END IF
         EXIT DISPLAY
      ON ACTION next
         CALL i511_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)
           END IF
         EXIT DISPLAY
      ON ACTION last
         CALL i511_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)
           END IF
         EXIT DISPLAY
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION close
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION user_defined_columns
         LET g_action_choice="user_defined_columns"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="user_defined_columns"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION related_document                #相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
         
      ON ACTION modify_wo
         LET g_action_choice="modify_wo"   
         LET l_ac = ARR_CURR()       
         EXIT DISPLAY
      
      ON ACTION create_des
         LET g_action_choice="create_des"          
         EXIT DISPLAY
         
      ON ACTION confirm
         LET g_action_choice="confirm"          
         EXIT DISPLAY
      
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"          
         EXIT DISPLAY
      
      ON ACTION post
         LET g_action_choice="post"          
         EXIT DISPLAY
         
      ON ACTION undo_post
         LET g_action_choice="undo_post"          
         EXIT DISPLAY
      
      ON ACTION del_tc_im
         LET g_action_choice="del_tc_im"          
         EXIT DISPLAY
                                                         
      ON ACTION controls                                                        
         CALL cl_set_head_visible("folder01","AUTO")                            
      &include "qry_string.4gl"
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i511_bp3(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1

   IF p_ud <> "G" THEN  #FUN-D40030 add 
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel,spare_part", FALSE)
   DISPLAY ARRAY g_tc_imq TO s_tc_imq.* ATTRIBUTE(COUNT=g_rec_b3)
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
         
     ON ACTION Page1
        LET l_action_flag = "Page1"
     EXIT DISPLAY

     ON ACTION page_list
	LET l_action_flag = "page_list"
     EXIT DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
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
      ON ACTION first
         CALL i511_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)
           END IF
         EXIT DISPLAY
      ON ACTION previous
         CALL i511_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)
           END IF
         EXIT DISPLAY
      ON ACTION jump
         CALL i511_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)
           END IF
         EXIT DISPLAY
      ON ACTION next
         CALL i511_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)
           END IF
         EXIT DISPLAY
      ON ACTION last
         CALL i511_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1) 
           END IF
         EXIT DISPLAY
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION close
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION spare_part
         LET g_action_choice="spare_part"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="spare_part"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
         
      ON ACTION modify_wo
         LET g_action_choice="modify_wo" 
         LET l_ac = ARR_CURR()         
         EXIT DISPLAY
      
      ON ACTION create_des
         LET g_action_choice="create_des"          
         EXIT DISPLAY
         
      ON ACTION confirm
         LET g_action_choice="confirm"          
         EXIT DISPLAY
      
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"          
         EXIT DISPLAY
      
      ON ACTION post
         LET g_action_choice="post"          
         EXIT DISPLAY
         
      ON ACTION undo_post
         LET g_action_choice="undo_post"          
         EXIT DISPLAY
      
      ON ACTION del_tc_im
         LET g_action_choice="del_tc_im"          
         EXIT DISPLAY
      
      ON ACTION related_document                #相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY                                                       
      ON ACTION controls                                                        
         CALL cl_set_head_visible("folder01","AUTO")                            
      &include "qry_string.4gl"
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION i511_out()
DEFINE l_cmd  LIKE type_file.chr1000
DEFINE l_msg  STRING
DEFINE l_wc   STRING
 
   IF g_tc_imm.tc_immconf <> 'Y' THEN
      LET l_msg = "未审核单据不允许列印"
      CALL cl_err(l_msg,'!',1)
      RETURN
   END IF
   LET l_wc = 'tc_imm01= "',g_tc_imm.tc_imm01,'"'
   
   LET l_msg = "csfr009 '",l_wc CLIPPED,"'"
   CALL cl_cmdrun(l_msg)

END FUNCTION
 
 
FUNCTION i511_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("tc_imm01",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION i511_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
 
    #IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("tc_imm01",FALSE)
    #END IF
 
END FUNCTION

#自动生成第一单身
FUNCTION i511_g_b(p_tc_imn03,p_cnt)
DEFINE p_tc_imn03   LIKE tc_imn_file.tc_imn03
DEFINE p_cnt        LIKE type_file.num5
DEFINE l_sql        STRING
DEFINE l_sfb        RECORD LIKE sfb_file.*
DEFINE l_tc_imn     RECORD LIKE tc_imn_file.*
DEFINE l_msg        LIKE type_file.chr100
DEFINE l_sfb08_1    LIKE sfb_file.sfb08
DEFINE l_sfb08_2    LIKE sfb_file.sfb08
DEFINE l_sfb08_3    LIKE sfb_file.sfb08  #add by guanyao160922
DEFINE l_ta_ecd04   LIKE ecd_file.ta_ecd04  #add by guanyao160922

   LET l_sql = "SELECT * ",
               "   FROM sfb_file",
               "   WHERE sfb01 = ? " 
   
   DECLARE i511_sfb_c CURSOR FROM l_sql
   OPEN i511_sfb_c USING p_tc_imn03
   FETCH i511_sfb_c INTO l_sfb.*
   CLOSE i511_sfb_c
   
   LET l_tc_imn.tc_imn01 = g_tc_imm.tc_imm01
   LET l_tc_imn.tc_imn02 = p_cnt
   LET l_tc_imn.tc_imn03 = l_sfb.sfb01
   LET l_tc_imn.tc_imn04 = g_tc_imm.tc_imm08
   LET l_tc_imn.tc_imn05 = l_sfb.sfb05
   #str----mark by guanyao160922
   #LET l_tc_imn.tc_imn06 = l_sfb.sfb08
   #完工数量
   #SELECT SUM(tc_shb12+tc_shb121 +tc_shb122) INTO l_sfb08_1 FROM tc_shb_file WHERE tc_shb01 = '2' AND tc_shb04 = lr_qry.sfb01 AND tc_shb08 = g_where
   #扫入
   #SELECT SUM(tc_shc12) INTO l_sfb08_2 FROM tc_shc_file WHERE tc_shc01 = '1' AND tc_shc04 = lr_qry.sfb01 AND tc_shc08 = g_where 
   #IF cl_null(l_sfb08_1) THEN LET l_sfb08_1 =0 END IF
   #IF cl_null(l_sfb08_2) THEN LET l_sfb08_2 = 0 END IF
   #已申请数量
   #IF l_sfb08_1 > l_sfb08_2 THEN
   #   	 LET l_tc_imn.tc_imn06 = l_sfb.sfb08 - l_sfb08_2
   #   ELSE
   #   	 LET l_tc_imn.tc_imn06 = l_sfb.sfb08 - l_sfb08_1 
   #   END IF
   #end----mark by guanyao160922
   INSERT INTO tc_imn_file VALUES(l_tc_imn.*)
   IF STATUS OR SQLCA.SQLCODE THEN
   	  LET l_msg = g_tc_imm.tc_imm01,'||',p_cnt
      CALL cl_err3("ins","tc_imn_file",l_msg,"",SQLCA.SQLCODE,"","ins tc_imn",1)
   END IF

END FUNCTION

FUNCTION i511_b2_g()
DEFINE l_sql        STRING
DEFINE l_tc_imn     RECORD LIKE tc_imn_file.*
DEFINE l_sfa        RECORD LIKE sfa_file.*
DEFINE l_tc_imp     RECORD LIKE tc_imp_file.*
DEFINE l_msg        LIKE type_file.chr100
DEFINE l_cnt        LIKE type_file.num5
DEFINE l_ima25      LIKE ima_file.ima25
DEFINE l_ima63      LIKE ima_file.ima63
DEFINE l_factor     LIKE pml_file.pml09
DEFINE l_cnt1       LIKE type_file.num5
DEFINE l_imaud11    LIKE ima_file.imaud11
#str----add by guanyao160922
DEFINE l_sum1       LIKE tc_imp_file.tc_imp09
DEFINE l_sum2       LIKE tc_imp_file.tc_imp08
#end----add by guanyao160922
   
   DELETE FROM tc_imp_file WHERE tc_imp01 = g_tc_imm.tc_imm01
   LET l_cnt = 1
   LET l_sql = " SELECT * FROM tc_imn_file WHERE tc_imn01 = '",g_tc_imm.tc_imm01 CLIPPED,"'"
   PREPARE i511_tc_imn_p FROM l_sql
   DECLARE i511_tc_imn_c CURSOR FOR i511_tc_imn_p
   FOREACH i511_tc_imn_c INTO l_tc_imn.*
    # LET l_sql = " SELECT * FROM sfa_file WHERE sfa01 ='",l_tc_imn.tc_imn03 CLIPPED,"' AND sfa08 ='",l_tc_imn.tc_imn04 CLIPPED,"' AND sfa11 ='E'"
      LET l_sql = " SELECT * FROM sfa_file WHERE sfa01 ='",l_tc_imn.tc_imn03 CLIPPED,"' AND sfa08 ='",l_tc_imn.tc_imn04 CLIPPED,"' AND sfa11 ='N'"
      PREPARE i511_sfa_p FROM l_sql
      DECLARE i511_sfa_c CURSOR FOR i511_sfa_p
      FOREACH i511_sfa_c INTO l_sfa.*

         #str----add by guanyao160922
         #已经审核过账的数量
         LET l_sum1 = 0
         SELECT SUM(tc_imp09) INTO l_sum1 FROM tc_imp_file,tc_imm_file 
          WHERE tc_imp03 = l_tc_imn.tc_imn03 
            AND tc_imp05 = l_sfa.sfa03 
            AND tc_imp04 = l_tc_imn.tc_imn04
            AND tc_imm01 = tc_imp01
            AND tc_imm03 = 'Y'
         #已经未审核过账的数量
         LET l_sum2 = 0
         SELECT SUM(tc_imp08) INTO l_sum2 FROM tc_imp_file,tc_imm_file 
          WHERE tc_imp03 = l_tc_imn.tc_imn03 
            AND tc_imp05 = l_sfa.sfa03 
            AND tc_imp04 = l_tc_imn.tc_imn04
            AND tc_imm01 = tc_imp01
            AND tc_imm03 = 'N'
            AND tc_immconf <>'X'
         IF cl_null(l_sum1) THEN LET l_sum1 = 0 END IF 
         IF cl_null(l_sum2) THEN LET l_sum2 = 0 END IF 
         #end----add by guanyao160922
      	 LET l_tc_imp.tc_imp01 = g_tc_imm.tc_imm01
      	 LET l_tc_imp.tc_imp02 = l_cnt
      	 LET l_tc_imp.tc_imp03 = l_tc_imn.tc_imn03
      	 LET l_tc_imp.tc_imp04 = l_tc_imn.tc_imn04
      	 LET l_tc_imp.tc_imp05 = l_sfa.sfa03
      	 
      	 ##add by nihuan 20170508
      	 LET l_tc_imp.tc_imp06 = l_sfa.sfa30
       	 LET l_tc_imp.tc_imp06 = 'XBC'
       # LET l_tc_imp.tc_imp11 = l_sfa.sfa31
         SELECT ecd07 INTO l_tc_imp.tc_imp11 FROM ecd_file where ecd01 = l_sfa.sfa08 
      	 SELECT img10 INTO l_tc_imp.tc_imp13 FROM img_file 
      	 WHERE img01=l_tc_imp.tc_imp05 AND img02=l_tc_imp.tc_imp06
      	 AND img03=l_tc_imp.tc_imp11
      	 IF cl_null(l_tc_imn.tc_imn11) THEN LET l_tc_imn.tc_imn11=0 END IF 
      	 IF cl_null(l_tc_imp.tc_imp13) THEN LET l_tc_imp.tc_imp13=0 END IF	
      # LET l_tc_imp.tc_imp14=l_tc_imn.tc_imn11*l_sfa.sfa161+l_sfa.sfa05-l_sfa.sfa06
      	 LET l_tc_imp.tc_imp14=l_tc_imn.tc_imn11*l_sfa.sfa161
         IF l_tc_imp.tc_imp14 > (l_sfa.sfa05-l_sfa.sfa06)  THEN 
      	   LET l_tc_imp.tc_imp14=l_sfa.sfa05-l_sfa.sfa06
         END IF 
      	 ##add by nihuan 20170508
      	 
#      	 LET l_tc_imp.tc_imp06 = 'XBC'
      	 LET l_tc_imp.tc_imp07 = g_user
      	 SELECT ima25,ima63 INTO l_ima25,l_ima63 FROM ima_file WHERE ima01 = l_sfa.sfa03
      	 CALL s_umfchk(l_sfa.sfa03,l_ima63,l_ima25)
             RETURNING l_cnt1,l_factor
         IF l_cnt1 = 1 THEN
            LET l_factor = 1
         END IF
      	 #LET l_tc_imp.tc_imp08 = l_tc_imn.tc_imn06 * l_sfa.sfa161 * l_factor  #mark by guanyao160922
#         #str----add by guanyao160922
#         LET l_tc_imp.tc_imp08 = l_sfa.sfa05-l_sum1-l_sum2                    
#         IF l_tc_imp.tc_imp08 <=0 THEN 
#            CONTINUE FOREACH 
#         END IF 
#         #end----add by guanyao160922
#         LET l_tc_imp.tc_imp08 = l_tc_imp.tc_imp08 * l_factor #add by donghy 除以转换率
      	 ##add by nihuan 20170508--start
      	 LET l_tc_imp.tc_imp08 = l_tc_imp.tc_imp14-l_tc_imp.tc_imp13
      	 SELECT imaud11 INTO l_imaud11 FROM ima_file WHERE ima01=l_tc_imp.tc_imp05
      	 IF cl_null(l_imaud11) THEN LET l_imaud11=0 END IF	
         IF l_imaud11 <> 0 THEN 
      	   SELECT ceil(l_tc_imp.tc_imp08/l_imaud11)*l_imaud11 INTO l_tc_imp.tc_imp08 FROM dual 
         END IF 
      	 ##add by nihuan 20170508--end
      	 
      	 LET l_tc_imp.tc_imp09 = l_tc_imp.tc_imp08
         LET l_tc_imp.tc_imp10 = l_ima25   #add by guanyao160909
      	 
      	 INSERT INTO tc_imp_file VALUES(l_tc_imp.*)
         IF STATUS OR SQLCA.SQLCODE THEN
         	  LET l_msg = g_tc_imm.tc_imm01,'||',l_cnt
            CALL cl_err3("ins","tc_imp_file",l_msg,"",SQLCA.SQLCODE,"","ins tc_imp",1)
         END IF 
      	 LET l_cnt = l_cnt + 1
      END FOREACH
   END FOREACH
   
END FUNCTION

FUNCTION i511_y()
DEFINE l_cnt       LIKE type_file.num5
DEFINE l_msg       STRING
   IF NOT cl_confirm('axm-108') THEN RETURN END IF
   LET g_success = "Y"
   IF g_tc_imm.tc_immconf = 'Y' THEN
      LET l_msg = "已审核，不可重复审核"
      CALL cl_err(l_msg,'!',1)
      LET g_success = "N"
      RETURN
   END IF
   
   IF g_tc_imm.tc_immconf = 'X' THEN
      LET l_msg = "已作废，不可审核"
      CALL cl_err(l_msg,'!',1)
      LET g_success = "N"
      RETURN
   END IF
   
   IF g_tc_imm.tc_imm03 = 'Y' THEN
      LET l_msg = "已过账单据，无法审核"
      CALL cl_err(l_msg,'!',1)
      LET g_success = "N"
      RETURN
   END IF
   
   SELECT COUNT(*) INTO l_cnt FROM tc_imp_file WHERE tc_imp01 = g_tc_imm.tc_imm01 
   IF l_cnt = 0 THEN  #无申请单身，不可审核
      LET l_msg = "无审核单身，不可审核"
      CALL cl_err(l_msg,'!',1)
      LET g_success = "N"
      RETURN
   END IF 
   
   BEGIN WORK
 
   OPEN i511_cl USING g_tc_imm.tc_imm01
   IF STATUS THEN
      CALL cl_err("OPEN i511_cl:", STATUS, 1)
      CLOSE i511_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i511_cl INTO g_tc_imm.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_tc_imm.tc_imm01,SQLCA.sqlcode,0)
      CLOSE i511_cl ROLLBACK WORK RETURN
   END IF

   UPDATE tc_imm_file SET tc_immconf = 'Y' WHERE tc_imm01 = g_tc_imm.tc_imm01
   IF g_success = 'Y' THEN
      LET g_tc_imm.tc_immconf='Y'
      COMMIT WORK
      CALL cl_flow_notify(g_tc_imm.tc_imm01,'Y')
      DISPLAY BY NAME g_tc_imm.tc_immconf
   ELSE
      LET g_tc_imm.tc_immconf='N'
      ROLLBACK WORK
   END IF
   IF g_tc_imm.tc_immconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   CALL cl_set_field_pic(g_tc_imm.tc_immconf,"","","",g_chr,"")
   
END FUNCTION

FUNCTION i511_uy()
DEFINE l_cnt       LIKE type_file.num5
DEFINE l_msg       STRING
   IF NOT cl_confirm('axm-109') THEN RETURN END IF
   LET g_success = "Y"
   
   IF g_tc_imm.tc_immconf = 'N' THEN
      LET l_msg = "单据未审核"
      CALL cl_err(l_msg,'!',1)
      LET g_success = "N"
      RETURN
   END IF
   IF g_tc_imm.tc_immconf = 'X' THEN
      LET l_msg = "已作废，不可取消审核"
      CALL cl_err(l_msg,'!',1)
      LET g_success = "N"
      RETURN
   END IF
   
   IF g_tc_imm.tc_imm03 = 'Y' THEN
      LET l_msg = "已过账单据，无法取消审核"
      CALL cl_err(l_msg,'!',1)
      LET g_success = "N"
      RETURN
   END IF
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM tc_imq_file WHERE tc_imq01 = g_tc_imm.tc_imm01 
   IF l_cnt > 0 THEN
      LET l_msg = "已生成调拨数据，不可取消审核"
      CALL cl_err(l_msg,'!',1)
      LET g_success = "N"
      RETURN
   END IF
   BEGIN WORK
 
   OPEN i511_cl USING g_tc_imm.tc_imm01
   IF STATUS THEN
      CALL cl_err("OPEN i511_cl:", STATUS, 1)
      CLOSE i511_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i511_cl INTO g_tc_imm.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_tc_imm.tc_imm01,SQLCA.sqlcode,0)
      CLOSE i511_cl ROLLBACK WORK RETURN
   END IF

   UPDATE tc_imm_file SET tc_immconf = 'N' WHERE tc_imm01 = g_tc_imm.tc_imm01
   IF g_success = 'Y' THEN
      LET g_tc_imm.tc_immconf='N'
      COMMIT WORK
      CALL cl_flow_notify(g_tc_imm.tc_imm01,'Y')
      DISPLAY BY NAME g_tc_imm.tc_immconf
   ELSE
      LET g_tc_imm.tc_immconf='Y'
      ROLLBACK WORK
   END IF
   IF g_tc_imm.tc_immconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   CALL cl_set_field_pic(g_tc_imm.tc_immconf,"","","",g_chr,"")
END FUNCTION

FUNCTION create_des()
DEFINE l_cnt        LIKE type_file.num5
DEFINE l_msg        STRING
DEFINE l_sql        STRING
DEFINE l_tc_imp     RECORD LIKE tc_imp_file.*
DEFINE l_img        RECORD LIKE img_file.*
DEFINE l_tc_imq     RECORD LIKE tc_imq_file.*
DEFINE l_img10_sum  LIKE img_file.img10
DEFINE l_tc_imq14   LIKE tc_imq_file.tc_imq14
DEFINE l_sy         LIKE img_file.img10
   
   LET g_success = "Y"
   IF g_tc_imm.tc_immconf <>'Y' THEN
      LET l_msg = "单据审核后才可以生成调拨资料"
      CALL cl_err(l_msg,'!',1)
      LET g_success = "N"
      RETURN	
   END IF
   IF g_tc_imm.tc_immconf = 'X' THEN
      LET l_msg = "单据已作废"
      CALL cl_err(l_msg,'!',1)
      LET g_success = "N"
      RETURN
   END IF
   
   IF g_tc_imm.tc_imm03 = 'Y' THEN
      LET l_msg = "单据已过账"
      CALL cl_err(l_msg,'!',1)
      LET g_success = "N"
      RETURN
   END IF
   SELECT COUNT(*) INTO l_cnt FROM tc_imq_file WHERE tc_imq01 = g_tc_imm.tc_imm01
   IF l_cnt > 0 THEN
      IF NOT cl_confirm('agl-400') THEN RETURN END IF
   ELSE
   	  IF NOT cl_confirm('csf-511') THEN RETURN END IF
   END IF
   
   DELETE FROM tc_imq_file WHERE tc_imq01 = g_tc_imm.tc_imm01
   BEGIN WORK
   LET l_cnt = 1
   LET l_sql =" SELECT * from tc_imp_file WHERE tc_imp01 = '",g_tc_imm.tc_imm01 CLIPPED,"'"
   PREPARE i511_tc_imp_p FROM l_sql
   DECLARE i511_tc_imp_c CURSOR FOR i511_tc_imp_p
   FOREACH i511_tc_imp_c INTO l_tc_imp.*
   	  LET l_sql = "SELECT * FROM img_file WHERE img01 ='",l_tc_imp.tc_imp05 CLIPPED,"' ",
                  "   AND img18 >='",g_today,"' ",  #add by guanyao160920
                  "   AND img10 >0",                #add by guanyao160921
                  "   AND img02 NOT IN(SELECT jce02 FROM jce_file) ORDER BY img01,img18"
                
   	  PREPARE i511_img_p FROM l_sql
      DECLARE i511_img_c CURSOR FOR i511_img_p
      LET l_img10_sum = 0
      LET l_sy = l_tc_imp.tc_imp08
      FOREACH i511_img_c INTO l_img.*
      	 INITIALIZE l_tc_imq.* TO NULL
      	 LET l_img10_sum = l_img10_sum + l_img.img10
      	 
      	 SELECT SUM(tc_imq14) INTO l_tc_imq14 FROM tc_imq_file,tc_imm_file WHERE tc_imq01 = tc_imm01 AND tc_imm03 <>'Y' AND tc_immconf <>'X'  
            AND tc_imq05 =l_tc_imp.tc_imp05   #add by guanyao160920
            AND tc_imq01 =g_tc_imm.tc_imm01   #add by guanyao160921
      	 IF cl_null(l_tc_imq14) THEN LET l_tc_imq14 = 0 END IF
      	 IF l_img10_sum <= l_tc_imq14 THEN
      	    CONTINUE FOREACH
      	 ELSE
      	 	  IF l_img10_sum - l_tc_imq14 < l_sy THEN
      	 	     LET l_tc_imq.tc_imq14 = l_img10_sum - l_tc_imq14
      	 	  ELSE
      	 		   LET l_tc_imq.tc_imq14 = l_sy
      	 	  END IF
      	 	  
      	 	  LET l_tc_imq.tc_imq01 = g_tc_imm.tc_imm01
      	 	  LET l_tc_imq.tc_imq02 = l_cnt
      	 	  LET l_tc_imq.tc_imq03 = l_tc_imp.tc_imp03
      	 	  LET l_tc_imq.tc_imq04 = l_tc_imp.tc_imp04
      	 	  LET l_tc_imq.tc_imq05 = l_tc_imp.tc_imp05
      	 	  LET l_tc_imq.tc_imq06 = l_img.img02
      	 	  LET l_tc_imq.tc_imq07 = l_img.img03
      	 	  LET l_tc_imq.tc_imq08 = l_img.img04
      	 	  LET l_tc_imq.tc_imq09 = l_img.img09
      	 	  LET l_tc_imq.tc_imq10 = l_tc_imp.tc_imp06
      	 	  LET l_tc_imq.tc_imq11 = g_tc_imm.tc_imm10
      	 	  LET l_tc_imq.tc_imq12 = l_img.img04
      	 	  LET l_tc_imq.tc_imq13 = l_img.img09
      	 	  LET l_tc_imq.tc_imq15 = l_tc_imq.tc_imq14
      	 	  LET l_tc_imq.tc_imq16 = 1
      	 	  LET l_tc_imq.tc_imq17 = 'X01'
      	 	  INSERT INTO tc_imq_file VALUES(l_tc_imq.*)
      	 	  IF STATUS OR SQLCA.SQLCODE THEN
         	     LET l_msg = g_tc_imm.tc_imm01,'||',l_cnt
         	     LET g_success = "N"
         	     EXIT FOREACH
               CALL cl_err3("ins","tc_imq_file",l_msg,"",SQLCA.SQLCODE,"","ins tc_imq",1)
            END IF
            LET l_cnt = l_cnt + 1
            LET l_sy = l_sy - l_tc_imq.tc_imq14
      	 	  IF l_sy > 0 THEN
      	 	  	 CONTINUE FOREACH #还没领够，就继续领
      	 	  ELSE
      	 	  	 EXIT FOREACH     #领够了就退出，领下一颗料
      	 	  END IF
      	 END IF
      END FOREACH
      IF l_sy > 0 THEN  #剩余未发量大于0，说明库存不够发了，以负数显示到单身中
      	 #LET l_cnt = l_cnt + 1
      	 INITIALIZE l_tc_imq.* TO NULL
      	 LET l_tc_imq.tc_imq01 = g_tc_imm.tc_imm01
      	 LET l_tc_imq.tc_imq02 = l_cnt
      	 LET l_tc_imq.tc_imq03 = l_tc_imp.tc_imp03
      	 LET l_tc_imq.tc_imq04 = l_tc_imp.tc_imp04
      	 LET l_tc_imq.tc_imq05 = l_tc_imp.tc_imp05
      	 #LET l_tc_imq.tc_imq14 = l_sy * -1  #mark by guanyao160922
         LET l_tc_imq.tc_imq14 = l_sy        #add by guanyao160922
      	 LET l_tc_imq.tc_imq15 = l_sy
      	 #LET l_tc_imq.tc_imq18 = '欠量'  #mark by guanyao160922
         LET l_tc_imq.tc_imq06 = '欠量'   #add by guanyao160922
      	 INSERT INTO tc_imq_file VALUES(l_tc_imq.*)
      	 IF STATUS OR SQLCA.SQLCODE THEN
            LET l_msg = g_tc_imm.tc_imm01,'||',l_cnt
            LET g_success = "N"
            EXIT FOREACH
            CALL cl_err3("ins","tc_imq_file",l_msg,"",SQLCA.SQLCODE,"","ins tc_imq",1)
         END IF
         LET l_cnt = l_cnt + 1 
      END IF
   END FOREACH
   LET l_cnt = l_cnt - 1
   IF l_cnt = 0 THEN
      LET l_msg = "无资料生成"
      CALL cl_err(l_msg,'!',1)
   ELSE
   	  LET l_msg = "生成资料成功"	
   	  CALL cl_err(l_msg,'!',1)
   END IF
   IF g_success = "Y" THEN
      COMMIT WORK	
   ELSE
   	  ROLLBACK WORK
   END IF
   
   CALL i511_b3_fill(" 1=1")
   
END FUNCTION

FUNCTION i511_post()
DEFINE l_cnt    LIKE type_file.num10
DEFINE l_sql    LIKE type_file.chr1000
DEFINE p_inTransaction  LIKE type_file.num5
DEFINE l_imn10  LIKE imn_file.imn10
DEFINE l_imn29  LIKE imn_file.imn29
DEFINE l_imn03  LIKE imn_file.imn03
DEFINE l_qcs01  LIKE qcs_file.qcs01
DEFINE l_qcs02  LIKE qcs_file.qcs02
DEFINE l_imd11  LIKE imd_file.imd11
DEFINE l_imd11_1 LIKE imd_file.imd11
DEFINE l_flag    LIKE type_file.num5
DEFINE l_result LIKE type_file.chr1
DEFINE l_date   LIKE type_file.dat    
DEFINE l_img37     LIKE img_file.img37
DEFINE l_cnt_img   LIKE type_file.num5
DEFINE l_cnt_imgg  LIKE type_file.num5
DEFINE l_sel    LIKE type_file.num5   
DEFINE l_t1     LIKE smy_file.smyslip 
DEFINE l_ima906 LIKE ima_file.ima906  
DEFINE p_imm01     LIKE imm_file.imm01   
DEFINE p_argv2     LIKE type_file.chr1
DEFINE p_argv4     STRING
DEFINE l_tc_imm    RECORD LIKE tc_imm_file.*
DEFINE l_tc_imq    RECORD LIKE tc_imq_file.* 
DEFINE l_yy,l_mm   LIKE type_file.num5 
DEFINE l_imm01     LIKE imm_file.imm01
DEFINE l_unit_arr  DYNAMIC ARRAY OF RECORD  
          unit        LIKE ima_file.ima25,
          fac         LIKE img_file.img21,
          qty         LIKE img_file.img10
                   END RECORD
DEFINE l_msg       LIKE type_file.chr1000
DEFINE l_cmd       LIKE type_file.chr1000
DEFINE l_qcs091    LIKE qcs_file.qcs091
DEFINE l_imni      RECORD LIKE imni_file.*
DEFINE l_immud13_t LIKE type_file.dat
   
   WHENEVER ERROR CONTINUE   
   IF NOT cl_confirm('mfg0176') THEN RETURN END IF
   LET g_success = 'Y'

   IF g_tc_imm.tc_immconf = 'N' THEN
      CALL cl_err('','aba-100',0)
      RETURN
   END IF
   IF g_tc_imm.tc_imm03 = 'Y' THEN
      CALL cl_err('','asf-812',0)
      RETURN
   END IF
   IF g_tc_imm.tc_immconf = 'X' THEN
      CALL cl_err('',9024,0)
      RETURN
   END IF
   IF g_tc_imm.tc_imm01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   
   INPUT g_tc_imm.tc_immud13 WITHOUT DEFAULTS FROM tc_immud13
       BEFORE INPUT
            LET g_tc_imm.tc_immud13 = g_today   #add by wangxt170210
           LET l_immud13_t = g_tc_imm.tc_immud13
       AFTER FIELD tc_immud13
          IF NOT cl_null(g_tc_imm.tc_immud13) THEN
             IF g_sma.sma53 IS NOT NULL AND g_tc_imm.tc_immud13 <= g_sma.sma53 THEN
                CALL cl_err('','mfg9999',0)
                NEXT FIELD tc_immud13
             END IF
             CALL s_yp(g_tc_imm.tc_immud13) RETURNING l_yy,l_mm
             IF l_yy > g_sma.sma51 THEN     # 與目前會計年度,期間比較
                CALL cl_err(l_yy,'mfg6090',0)
                RETURN
             ELSE
                IF l_yy=g_sma.sma51 AND l_mm > g_sma.sma52 THEN
                   CALL cl_err(l_mm,'mfg6091',0)
                   RETURN
                END IF
             END IF
          END IF
       AFTER INPUT
          IF INT_FLAG THEN
             LET INT_FLAG = 0
             LET g_tc_imm.tc_immud13=l_immud13_t
             DISPLAY BY NAME g_tc_imm.tc_immud13
             LET g_success = 'N'
             RETURN
          END IF
          IF NOT cl_null(g_tc_imm.tc_immud13) THEN
             IF g_sma.sma53 IS NOT NULL AND g_tc_imm.tc_immud13 <= g_sma.sma53 THEN
                CALL cl_err('','mfg9999',0)
                NEXT FIELD tc_immud13
             END IF
             CALL s_yp(g_tc_imm.tc_immud13) RETURNING l_yy,l_mm
             IF l_yy > g_sma.sma51 THEN     # 與目前會計年度,期間比較
                CALL cl_err(l_yy,'mfg6090',0)
                RETURN
             ELSE
                IF l_yy=g_sma.sma51 AND l_mm > g_sma.sma52 THEN
                   CALL cl_err(l_mm,'mfg6091',0)
                   RETURN
                END IF
             END IF
          ELSE
          	 CONTINUE INPUT
          END IF
       ON ACTION CONTROLG
          CALL cl_cmdask()

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
   END INPUT

   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt
     FROM tc_imq_file
    WHERE tc_imq01 = g_tc_imm.tc_imm01 

   IF l_cnt = 0 OR l_cnt IS NULL THEN
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF

   UPDATE tc_imm_file SET tc_immud13 = g_tc_imm.tc_immud13
    WHERE tc_imm01 = g_tc_imm.tc_imm01

   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL s_errmsg('tc_imm01',g_tc_imm.tc_imm01,'up tc_imm_file',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF

   DECLARE t512sub_s1_c CURSOR FOR
     SELECT * FROM tc_imq_file WHERE tc_imq01=g_tc_imm.tc_imm01
 
   BEGIN WORK

   OPEN i511_cl USING g_tc_imm.tc_imm01
   IF STATUS THEN
      CALL cl_err("OPEN i511_cl:", STATUS, 1)
      CLOSE i511_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i511_cl INTO g_tc_imm.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_tc_imm.tc_imm01,SQLCA.sqlcode,0)
      CLOSE i511_cl ROLLBACK WORK RETURN
   END IF
  
   LET g_success = 'Y'
   
   CALL s_showmsg_init() 

   FOREACH t512sub_s1_c INTO l_tc_imq.*
      IF STATUS THEN EXIT FOREACH END IF

      LET l_cmd= 's_ read parts:',l_tc_imq.tc_imq05
      CALL cl_msg(l_cmd)
--    
      #str-----add by guanyao160922
      IF l_tc_imq.tc_imq06 = '欠量' OR l_tc_imq.tc_imq18 = '欠量'  THEN 
         LET g_success = 'N'
         LET g_showmsg = l_tc_imq.tc_imq02
         CALL s_errmsg("tc_imq02",g_showmsg,'','csf-086',1)
         CONTINUE FOREACH
      END IF  
      #end-----add by guanyao160922
      #撥入倉
      LET l_imd11 = ''
      SELECT imd11 INTO l_imd11 FROM imd_file 
       WHERE imd01 = l_tc_imq.tc_imq10

      #撥出倉
      LET l_imd11_1 = ''
      SELECT imd11 INTO l_imd11_1 FROM imd_file 
       WHERE imd01 = l_tc_imq.tc_imq06
      IF l_imd11_1 = 'Y' AND (l_imd11 = 'N' OR l_imd11 IS NULL) THEN 
         CALL t512sub_chk_avl_stk(l_tc_imq.*)     
         IF g_success='N' THEN
            LET g_totsuccess="N"
            CONTINUE FOREACH   
         END IF    
      END IF   

      #撥出倉庫過賬權限檢查
      CALL s_incchk(l_tc_imq.tc_imq06,l_tc_imq.tc_imq07,g_user) RETURNING l_result
      IF NOT l_result THEN
         LET g_success = 'N'
         LET g_showmsg = l_tc_imq.tc_imq05,"/",l_tc_imq.tc_imq06,"/",l_tc_imq.tc_imq07,"/",g_user
         CALL s_errmsg("tc_imq05/tc_imq06/tc_imq07/inc03",g_showmsg,'','asf-888',1)
         CONTINUE FOREACH
      END IF

      #撥入倉庫過賬權限檢查
      CALL s_incchk(l_tc_imq.tc_imq10,l_tc_imq.tc_imq11,g_user) RETURNING l_result
      IF NOT l_result THEN
         LET g_success = 'N'
         LET g_showmsg = l_tc_imq.tc_imq05,"/",l_tc_imq.tc_imq10,"/",l_tc_imq.tc_imq11,"/",g_user
         CALL s_errmsg("tc_imq05/tc_imq10/tc_imq11/inc03",g_showmsg,'','asf-888',1)
         CONTINUE FOREACH
      END IF

      IF cl_null(l_tc_imq.tc_imq06) THEN CONTINUE FOREACH END IF   
 
      SELECT *
        FROM img_file WHERE img01=l_tc_imq.tc_imq05 AND
                            img02=l_tc_imq.tc_imq10 AND
                            img03=l_tc_imq.tc_imq11 AND
                            img04=l_tc_imq.tc_imq12
      IF SQLCA.sqlcode THEN
         IF l_tc_imq.tc_imq07 IS NULL THEN LET l_tc_imq.tc_imq07 =' ' END IF
         IF l_tc_imq.tc_imq08 IS NULL THEN LET l_tc_imq.tc_imq08 =' ' END IF
            SELECT img18,img37 INTO l_date,l_img37 FROM img_file
             WHERE img01 = l_tc_imq.tc_imq05
               AND img02 = l_tc_imq.tc_imq06
               AND img03 = l_tc_imq.tc_imq07
               AND img04 = l_tc_imq.tc_imq08
           IF STATUS=100 THEN
              CALL cl_err('','mfg6101',1)  
              LET g_success ='N'
              CONTINUE FOREACH
           ELSE
              CALL s_date_record(l_date,'Y')
           END IF
            CALL s_idledate_record(l_img37)
            CALL s_add_img(l_tc_imq.tc_imq05,l_tc_imq.tc_imq10,
                           l_tc_imq.tc_imq11,l_tc_imq.tc_imq12,
                           l_tc_imq.tc_imq01,l_tc_imq.tc_imq02,
                           g_tc_imm.tc_immud13)
      END IF

      #不做sma892[3,3]提示的处理，前FUN-C70087单号已增加
      IF g_sma.sma115 = 'Y' THEN
         LET l_ima906=''
         SELECT ima906 INTO l_ima906 FROM ima_file
          WHERE ima01 = l_tc_imq.tc_imq05
         #母子单位 单位一  --begin
         IF l_ima906 = '2' THEN
            CALL s_chk_imgg(l_tc_imq.tc_imq05,l_tc_imq.tc_imq10,
                            l_tc_imq.tc_imq11,l_tc_imq.tc_imq12,
                            l_tc_imq.tc_imq13) RETURNING l_flag
            IF l_flag = 1 THEN
               CALL s_add_imgg(l_tc_imq.tc_imq05,l_tc_imq.tc_imq10,
                               l_tc_imq.tc_imq11,l_tc_imq.tc_imq12,
                               l_tc_imq.tc_imq13,l_tc_imq.tc_imq13,
                               l_tc_imq.tc_imq01,l_tc_imq.tc_imq02,0)
                    RETURNING l_flag
               IF l_flag = 1 THEN
                  LET g_totsuccess="N"
                  CONTINUE FOREACH
               END IF
            END IF
         END IF
         #母子单位 单位一  --end
         #母子单位&参考单位 单位二  --begin
         IF l_ima906 MATCHES '[23]' THEN
            CALL s_chk_imgg(l_tc_imq.tc_imq05,l_tc_imq.tc_imq10,
                            l_tc_imq.tc_imq11,l_tc_imq.tc_imq12,
                            l_tc_imq.tc_imq13) RETURNING l_flag
            IF l_flag = 1 THEN
               CALL s_add_imgg(l_tc_imq.tc_imq05,l_tc_imq.tc_imq10,
                               l_tc_imq.tc_imq11,l_tc_imq.tc_imq12,
                               l_tc_imq.tc_imq13,l_tc_imq.tc_imq13,
                               l_tc_imq.tc_imq01,l_tc_imq.tc_imq02,0)
                    RETURNING l_flag
               IF l_flag = 1 THEN
                  LET g_totsuccess="N"
                  CONTINUE FOREACH
               END IF
            END IF
         END IF
         #母子单位&参考单位 单位二  --end
      END IF

       IF NOT s_stkminus(l_tc_imq.tc_imq05,l_tc_imq.tc_imq06,l_tc_imq.tc_imq07,l_tc_imq.tc_imq08,
                         l_tc_imq.tc_imq14,1,g_tc_imm.tc_immud13) THEN
         LET g_totsuccess="N"
         CONTINUE FOREACH
      END IF

      #-->撥出更新
      IF t512sub_t(g_tc_imm.*,l_tc_imq.*) THEN
         LET g_totsuccess="N"
         CONTINUE FOREACH
      END IF

      #IF g_sma.sma115 = 'Y' THEN#此处只有一个库存单位
      #   CALL t512sub_upd_s(l_tc_imq.*,g_tc_imm.*)
      #END IF

      IF g_success = 'N' THEN
         LET g_totsuccess="N"
         LET g_success="Y"
         CONTINUE FOREACH
      END IF

      #-->撥入更新
      IF t512sub_t2(g_tc_imm.*,l_tc_imq.*) THEN
         LET g_totsuccess="N"
         CONTINUE FOREACH
      END IF

      #IF g_sma.sma115 = 'Y' THEN
      #   CALL t512sub_upd_t(l_imn.*,l_imm.*)
      #END IF

      CALL s_updsie_sie(l_tc_imq.tc_imq01,l_tc_imq.tc_imq02,'4')

      IF g_success = 'N' THEN 
         LET g_totsuccess="N"
         LET g_success="Y"
         CONTINUE FOREACH
      END IF
 
   END FOREACH

   IF g_totsuccess="N" THEN
      LET g_success="N"
   END IF
   CALL s_showmsg()
   #str----add by guanyao160922
   IF g_success = 'Y' THEN 
      CALL t512sub_t3()
      CALL i511_show()
   END IF 
   #end----add by guanyao160922
  
   UPDATE tc_imm_file SET tc_imm03 = 'Y'
    WHERE tc_imm01 = g_tc_imm.tc_imm01

   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL s_errmsg('tc_imm01',g_tc_imm.tc_imm01,'up tc_imm_file',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF

   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_tc_imm.tc_imm01,'S')
      CALL cl_cmmsg(4)
   ELSE
      ROLLBACK WORK
      CALL cl_rbmsg(4)
   END IF
   

   SELECT tc_imm03 INTO g_tc_imm.tc_imm03 FROM tc_imm_file WHERE tc_imm01 = g_tc_imm.tc_imm01 
   DISPLAY BY NAME g_tc_imm.tc_imm03

END FUNCTION

FUNCTION i511_upost()
DEFINE l_img09      LIKE img_file.img09,
       l_factor     LIKE ima_file.ima31_fac
DEFINE l_tc_imq15   LIKE tc_imq_file.tc_imq15
DEFINE l_cnt        LIKE type_file.num10
DEFINE l_flag       LIKE type_file.num5
DEFINE l_tc_imq14   LIKE tc_imq_file.tc_imq14
DEFINE l_imni RECORD LIKE imni_file.* 
DEFINE l_tc_imq     RECORD LIKE tc_imq_file.*
  
  IF NOT cl_confirm('asf-663') THEN RETURN END IF
  LET g_success = "Y"
  BEGIN WORK 
  CALL t512_u_tc_imm()
 
  CALL s_showmsg_init()
 
  DECLARE t512_s1_c CURSOR FOR SELECT * FROM tc_imq_file WHERE tc_imq01 = g_tc_imm.tc_imm01
  FOREACH t512_s1_c INTO l_tc_imq.*
      IF STATUS THEN LET g_success='N' EXIT FOREACH END IF

      MESSAGE '_s1() read imn:',l_tc_imq.tc_imq02 
      CALL ui.Interface.refresh()
      IF cl_null(l_tc_imq.tc_imq05) THEN CONTINUE FOREACH END IF

      SELECT img09 INTO l_img09 FROM img_file
         WHERE img01=l_tc_imq.tc_imq05 AND img02=l_tc_imq.tc_imq10
           AND img03=l_tc_imq.tc_imq11 AND img04=l_tc_imq.tc_imq12
      CALL s_umfchk(l_tc_imq.tc_imq05,l_tc_imq.tc_imq13,l_img09) RETURNING l_cnt,l_factor
      IF l_cnt = 1 THEN
         CALL cl_err('','mfg3075',1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF
      LET l_tc_imq15 = l_tc_imq.tc_imq15 * l_factor

      SELECT img09 INTO l_img09 FROM img_file
         WHERE img01=l_tc_imq.tc_imq05 AND img02=l_tc_imq.tc_imq06
           AND img03=l_tc_imq.tc_imq07 AND img04=l_tc_imq.tc_imq08
      LET l_cnt = 0   LET l_factor = 0
      CALL s_umfchk(l_tc_imq.tc_imq05,l_tc_imq.tc_imq09,l_img09) RETURNING l_cnt,l_factor
      IF l_cnt = 1 THEN
         CALL cl_err('','mfg3075',1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF
      LET l_tc_imq14 = l_tc_imq.tc_imq14 * l_factor

      CALL t512_u_img(l_tc_imq14,+1,l_tc_imq.tc_imq05,l_tc_imq.tc_imq06,
                                  l_tc_imq.tc_imq07,l_tc_imq.tc_imq08,l_tc_imq.tc_imq02,l_tc_imq.*)
      IF g_success='N' THEN
         LET g_totsuccess="N"
         LET g_success="Y"
         CONTINUE FOREACH
      END IF
       CALL t512_u_img(l_tc_imq15,-1,l_tc_imq.tc_imq05,l_tc_imq.tc_imq10,
                      l_tc_imq.tc_imq11,l_tc_imq.tc_imq12,l_tc_imq.tc_imq02,l_tc_imq.*)
 
      IF g_success='N' THEN 
         LET g_totsuccess="N"
         LET g_success="Y"
         CONTINUE FOREACH
      END IF 
      CALL t512_u_tlf(l_tc_imq.*)
      IF g_success='N' THEN
         LET g_totsuccess="N"
         LET g_success="Y"
         CONTINUE FOREACH
      END IF

     CALL t512_u_tlfs(l_tc_imq.*)
     IF g_success='N' THEN
        LET g_totsuccess="N"
        LET g_success="Y"
        CONTINUE FOREACH
     END IF
     
     CALL s_updsie_unsie(l_tc_imq.tc_imq01,l_tc_imq.tc_imq02,'4')
     IF g_success='N' THEN
        LET g_totsuccess="N"
        LET g_success="Y"
        CONTINUE FOREACH
     END IF
 
  END FOREACH
 
  IF g_totsuccess="N" THEN
     LET g_success="N"
  END IF
  CALL s_showmsg()
  IF g_success = "Y" THEN
     COMMIT WORK
  ELSE
  	 ROLLBACK WORK
  END IF
  SELECT tc_imm03 INTO g_tc_imm.tc_imm03 FROM tc_imm_file WHERE tc_imm01 = g_tc_imm.tc_imm01
  DISPLAY BY NAME g_tc_imm.tc_imm03
END FUNCTION

FUNCTION t512sub_chk_avl_stk(p_tc_imq)   
   DEFINE l_avl_stk,l_avl_stk_mpsmrp,l_unavl_stk  LIKE type_file.num15_3
   DEFINE l_oeb12   LIKE oeb_file.oeb12
   DEFINE l_qoh     LIKE oeb_file.oeb12 
   DEFINE p_tc_imq  RECORD LIKE tc_imq_file.*   
   DEFINE l_ima25   LIKE ima_file.ima25
   DEFINE l_sw      LIKE type_file.num5
   DEFINE l_factor  LIKE img_file.img21
   DEFINE l_msg     LIKE type_file.chr1000
   DEFINE l_imd23   LIKE imd_file.imd23

      
   CALL s_getstock(p_tc_imq.tc_imq05,g_plant)
      RETURNING l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk   
   
   LET l_oeb12 = 0
   SELECT SUM(oeb905*oeb05_fac)
    INTO l_oeb12
    FROM oeb_file,oea_file   
   WHERE oeb04=p_tc_imq.tc_imq05
     AND oeb19= 'Y'
     AND oeb70= 'N'  
     AND oea01 = oeb01 AND oeaconf !='X' 
   IF l_oeb12 IS NULL THEN
      LET l_oeb12 = 0
   END IF
   
   LET l_qoh = l_avl_stk - l_oeb12
   
   SELECT ima25 INTO l_ima25 FROM ima_file
     WHERE ima01 = p_tc_imq.tc_imq05
   CALL s_umfchk(p_tc_imq.tc_imq05,p_tc_imq.tc_imq09,l_ima25)
        RETURNING l_sw,l_factor

   INITIALIZE l_imd23 TO NULL 
   CALL s_inv_shrt_by_warehouse(p_tc_imq.tc_imq06,g_plant) RETURNING l_imd23
   IF l_qoh < p_tc_imq.tc_imq14*l_factor AND l_imd23 = 'N' THEN

      LET l_msg = 'Line#',p_tc_imq.tc_imq02 USING '<<<',' ',
                   p_tc_imq.tc_imq05 CLIPPED,'-> QOH < 0 '
      CALL cl_err(l_msg,'mfg-075',1)   
      LET g_success='N' RETURN
   END IF 
END FUNCTION

#-->撥出更新
FUNCTION t512sub_t(p_tc_imm,p_tc_imq)
   DEFINE p_tc_imq         RECORD LIKE tc_imq_file.*,
          l_img            RECORD
          img16            LIKE img_file.img16,
          img23            LIKE img_file.img23,
          img24            LIKE img_file.img24,
          img09            LIKE img_file.img09,
          img21            LIKE img_file.img21
                        END RECORD,
          l_qty         LIKE img_file.img10,
          l_factor      LIKE ima_file.ima31_fac 
   DEFINE l_forupd_sql  STRING              
   DEFINE p_tc_imm      RECORD LIKE tc_imm_file.*
   DEFINE l_cnt         LIKE type_file.num5  
   DEFINE l_ima25       LIKE ima_file.ima25

   CALL cl_msg("update img_file ...")
   IF cl_null(p_tc_imq.tc_imq07) THEN LET p_tc_imq.tc_imq07=' ' END IF
   #IF cl_null(p_tc_imq.tc_imq08) THEN LET p_tc_imq.tc_imq07=' ' END IF  #mark by guanyao160923
   IF cl_null(p_tc_imq.tc_imq08) THEN LET p_tc_imq.tc_imq08=' ' END IF 

   LET l_forupd_sql =
       "SELECT img16,img23,img24,img09,img21,img26,img10 FROM img_file ",
       " WHERE img01= ? AND img02=  ? AND img03= ? AND img04=  ? FOR UPDATE "
   LET l_forupd_sql = cl_forupd_sql(l_forupd_sql)

   DECLARE img_lock CURSOR FROM l_forupd_sql
 
   OPEN img_lock USING p_tc_imq.tc_imq05,p_tc_imq.tc_imq06,p_tc_imq.tc_imq07,p_tc_imq.tc_imq08
   IF SQLCA.sqlcode THEN
      CALL cl_err("img_lock fail:", STATUS, 1)
      LET g_success = 'N'
      RETURN 1
   ELSE
      FETCH img_lock INTO l_img.*,g_debit,g_img10
      IF SQLCA.sqlcode THEN
         CALL cl_err("sel img_file", STATUS, 1)
         LET g_success = 'N'
         RETURN 1
      END IF
   END IF

   CALL s_umfchk(p_tc_imq.tc_imq05,p_tc_imq.tc_imq09,l_img.img09) RETURNING l_cnt,l_factor
   IF l_cnt = 1 THEN
      CALL cl_err('','mfg3075',1)
      LET g_success = 'N'
      RETURN 1
   END IF
   LET l_qty = p_tc_imq.tc_imq14 * l_factor

   #-->更新倉庫庫存明細資料
   CALL s_upimg(p_tc_imq.tc_imq05,p_tc_imq.tc_imq06,p_tc_imq.tc_imq07,p_tc_imq.tc_imq08,-1,l_qty,p_tc_imm.tc_immud13,
       '','','','',p_tc_imq.tc_imq01,p_tc_imq.tc_imq02,'','','','','','','','','','','','')

   IF g_success = 'N' THEN RETURN 1 END IF

   #-->若庫存異動後其庫存量小於等於零時將該筆資料刪除
   CALL s_delimg(p_tc_imq.tc_imq05,p_tc_imq.tc_imq06,p_tc_imq.tc_imq07,p_tc_imq.tc_imq08)
 
   #-->更新庫存主檔之庫存數量 (單位為主檔之庫存單位)
   CALL cl_msg("update ima_file ...")

   LET l_forupd_sql = "SELECT ima25 FROM ima_file WHERE ima01= ?  FOR UPDATE "  
   LET l_forupd_sql = cl_forupd_sql(l_forupd_sql)
   DECLARE ima_lock CURSOR FROM l_forupd_sql

   OPEN ima_lock USING p_tc_imq.tc_imq05
   IF STATUS THEN
      CALL cl_err('lock ima fail',STATUS,1)
       LET g_success='N' RETURN  1
   END IF

   FETCH ima_lock INTO l_ima25
   IF STATUS THEN
      CALL cl_err('lock ima fail',STATUS,1)
       LET g_success='N' RETURN  1
   END IF

   #-->料件庫存單位數量
   LET l_qty=p_tc_imq.tc_imq14 * l_img.img21
   IF cl_null(l_qty)  THEN RETURN 1 END IF

   IF s_udima(p_tc_imq.tc_imq05,             #料件編號
              l_img.img23,             #是否可用倉儲
              l_img.img24,             #是否為MRP可用倉儲
              l_qty,                   #調撥數量(換算為料件庫存單位)
              p_tc_imm.tc_immud13,
              -1)                      #表撥出
    THEN RETURN 1
       END IF
   IF g_success = 'N' THEN RETURN 1 END IF

   #-->將已鎖住之資料釋放出來
   CLOSE img_lock
 
   RETURN 0
END FUNCTION

FUNCTION t512sub_t2(p_tc_imm,p_tc_imq)
   DEFINE p_tc_imq          RECORD LIKE tc_imq_file.*,
          l_img          RECORD
             img16          LIKE img_file.img16,
             img23          LIKE img_file.img23,
             img24          LIKE img_file.img24,
             img09          LIKE img_file.img09,
             img21          LIKE img_file.img21,
             img19          LIKE img_file.img19,
             img27          LIKE img_file.img27,
             img28          LIKE img_file.img28,
             img35          LIKE img_file.img35,
             img36          LIKE img_file.img36
                         END RECORD,
          l_factor       LIKE ima_file.ima31_fac,
          l_qty          LIKE img_file.img10
   DEFINE l_forupd_sql   STRING               
   DEFINE p_tc_imm       RECORD LIKE tc_imm_file.*
   DEFINE l_cnt          LIKE type_file.num5  
   DEFINE l_ima25_2      LIKE ima_file.ima25

   LET l_forupd_sql =
       "SELECT img15,img23,img24,img09,img21,img19,img27,",
              "img28,img35,img36,img26,img10 FROM img_file ",
       " WHERE img01= ? AND img02= ? AND img03= ? AND img04= ? ",
       " FOR UPDATE "
   LET l_forupd_sql = cl_forupd_sql(l_forupd_sql)
   DECLARE img2_lock CURSOR FROM l_forupd_sql

   OPEN img2_lock USING p_tc_imq.tc_imq05,p_tc_imq.tc_imq10,p_tc_imq.tc_imq11,p_tc_imq.tc_imq12
   IF SQLCA.sqlcode THEN
      CALL cl_err('lock img2 fail',STATUS,1)
      LET g_success = 'N' RETURN 1
   END IF

   FETCH img2_lock INTO l_img.*,g_credit,g_img10_2
   IF SQLCA.sqlcode THEN
      CALL cl_err('lock img2 fail',STATUS,1)
      LET g_success = 'N' RETURN 1
   END IF

   #-->更新庫存主檔之庫存數量 (單位為主檔之庫存單位)
   CALL cl_msg("update ima2_file ...")
   LET l_forupd_sql = "SELECT ima25 FROM ima_file WHERE ima01= ? FOR UPDATE "
   LET l_forupd_sql = cl_forupd_sql(l_forupd_sql)
   DECLARE ima2_lock CURSOR FROM l_forupd_sql

   OPEN ima2_lock USING p_tc_imq.tc_imq05
   IF SQLCA.sqlcode THEN
      CALL cl_err('lock ima fail',STATUS,1)
       LET g_success='N' RETURN  1
   END IF
   FETCH ima2_lock INTO l_ima25_2
   IF SQLCA.sqlcode THEN
      CALL cl_err('lock ima fail',STATUS,1)
       LET g_success='N' RETURN  1
   END IF

   CALL s_umfchk(p_tc_imq.tc_imq05,p_tc_imq.tc_imq13,l_img.img09) RETURNING l_cnt,l_factor
   IF l_cnt = 1 THEN
      CALL cl_err('','mfg3075',1)
      LET g_success = 'N'
      RETURN 1
   END IF
   LET l_qty = p_tc_imq.tc_imq15 * l_factor

   CALL s_upimg(p_tc_imq.tc_imq05,p_tc_imq.tc_imq10,p_tc_imq.tc_imq11,p_tc_imq.tc_imq12,+1,l_qty,p_tc_imm.tc_immud13,
      p_tc_imq.tc_imq05,p_tc_imq.tc_imq10,p_tc_imq.tc_imq11,p_tc_imq.tc_imq12,
      p_tc_imq.tc_imq01,p_tc_imq.tc_imq02,l_img.img09,l_qty,      l_img.img09,
      1,  l_img.img21,1,
      g_credit,l_img.img35,l_img.img27,l_img.img28,l_img.img19,
      l_img.img36)

   IF g_success = 'N' THEN RETURN 1 END IF

   #-->更新庫存主檔之庫存數量 (單位為主檔之庫存單位)
   LET l_qty = p_tc_imq.tc_imq15 * l_img.img21
   IF s_udima(p_tc_imq.tc_imq05,            #料件編號
              l_img.img23,            #是否可用倉儲
              l_img.img24,            #是否為MRP可用倉儲
              l_qty,                  #發料數量(換算為料件庫存單位)
              p_tc_imm.tc_immud13,    #FUN-D40053
              +1)                     #表收料
        THEN RETURN  1 END IF
   IF g_success = 'N' THEN RETURN 1 END IF
   
   #-->產生異動記錄檔
   #---- 97/06/20 insert 兩筆至 tlf_file 一出一入
   CALL t512sub_log_2(1,0,'1',p_tc_imq.*,p_tc_imm.*) 
   CALL t512sub_log_2(1,0,'0',p_tc_imq.*,p_tc_imm.*) RETURN 0
END FUNCTION

#處理異動記錄
FUNCTION t512sub_log_2(p_stdc,p_reason,p_code,p_tc_imq,p_tc_imm)
   DEFINE p_stdc      LIKE type_file.num5,      #是否需取得標準成本
          p_reason    LIKE type_file.num5,      #是否需取得異動原因
          p_code      LIKE type_file.chr1,      #出/入庫
          p_tc_imq    RECORD LIKE tc_imq_file.*
   DEFINE l_img09     LIKE img_file.img09,
          l_factor    LIKE ima_file.ima31_fac,
          l_qty       LIKE img_file.img10
   DEFINE p_tc_imm    RECORD LIKE tc_imm_file.*
   DEFINE l_cnt       LIKE type_file.num5

   LET l_qty=0
   SELECT img09 INTO l_img09 FROM img_file
      WHERE img01=p_tc_imq.tc_imq05 AND img02=p_tc_imq.tc_imq10
        AND img03=p_tc_imq.tc_imq11 AND img04=p_tc_imq.tc_imq12
   CALL s_umfchk(p_tc_imq.tc_imq05,p_tc_imq.tc_imq09,l_img09) RETURNING l_cnt,l_factor
   IF l_cnt = 1 THEN
      CALL cl_err('','mfg3075',1)
      LET g_success = 'N'
      RETURN 1
   END IF
   LET l_qty = p_tc_imq.tc_imq14 * l_factor


   #----來源----
   LET g_tlf.tlf01=p_tc_imq.tc_imq05                 #異動料件編號
   LET g_tlf.tlf02=50                                #來源為倉庫(撥出)
   LET g_tlf.tlf020=g_plant                          #工廠別
   LET g_tlf.tlf021=p_tc_imq.tc_imq06                #倉庫別
   LET g_tlf.tlf022=p_tc_imq.tc_imq07                #儲位別
   LET g_tlf.tlf023=p_tc_imq.tc_imq08                #批號
   LET g_tlf.tlf024=g_img10 - p_tc_imq.tc_imq14      #異動後庫存數量
   LET g_tlf.tlf025=p_tc_imq.tc_imq09                #庫存單位(ima_file or img_file)
   LET g_tlf.tlf026=p_tc_imq.tc_imq01                #調撥單號
   LET g_tlf.tlf027=p_tc_imq.tc_imq02                #項次
   #----目的----
   LET g_tlf.tlf03=50                                #資料目的為(撥入)
   LET g_tlf.tlf030=g_plant                          #工廠別
   LET g_tlf.tlf031=p_tc_imq.tc_imq10                #倉庫別
   LET g_tlf.tlf032=p_tc_imq.tc_imq11                #儲位別
   LET g_tlf.tlf033=p_tc_imq.tc_imq12                #批號
    LET g_tlf.tlf034=g_img10_2 + l_qty               #異動後庫存量    #-No:MOD-57002
   LET g_tlf.tlf035=p_tc_imq.tc_imq13                #庫存單位(ima_file or img_file)
   LET g_tlf.tlf036=p_tc_imq.tc_imq01                #參考號碼
   LET g_tlf.tlf037=p_tc_imq.tc_imq02                #項次

   #---- 97/06/20 調撥作業來源目的碼
   IF p_code='1' THEN #-- 出
      LET g_tlf.tlf02=50
      LET g_tlf.tlf03=99
      LET g_tlf.tlf030=' '
      LET g_tlf.tlf031=' '
      LET g_tlf.tlf032=' '
      LET g_tlf.tlf033=' '
      LET g_tlf.tlf034=0
      LET g_tlf.tlf035=' '
      LET g_tlf.tlf036=' '
      LET g_tlf.tlf037=0
      LET g_tlf.tlf10=p_tc_imq.tc_imq14           #調撥數量
      LET g_tlf.tlf11=p_tc_imq.tc_imq09           #撥出單位
      LET g_tlf.tlf12=1                           #撥出/撥入庫存轉換率
      LET g_tlf.tlf930=p_tc_imm.tc_imm14
   ELSE               #-- 入
      LET g_tlf.tlf02=99
      LET g_tlf.tlf03=50
      LET g_tlf.tlf020=' '
      LET g_tlf.tlf021=' '
      LET g_tlf.tlf022=' '
      LET g_tlf.tlf023=' '
      LET g_tlf.tlf024=0
      LET g_tlf.tlf025=' '
      LET g_tlf.tlf026=' '
      LET g_tlf.tlf027=0
      LET g_tlf.tlf10=p_tc_imq.tc_imq15           #調撥數量
      LET g_tlf.tlf11=p_tc_imq.tc_imq13           #撥入單位
      LET g_tlf.tlf12=1                           #撥入/撥出庫存轉換率
      LET g_tlf.tlf930=p_tc_imm.tc_imm14
   END IF

   #--->異動數量
   LET g_tlf.tlf04=' '                         #工作站
   LET g_tlf.tlf05=' '                         #作業序號
   LET g_tlf.tlf06=p_tc_imm.tc_immud13
   LET g_tlf.tlf07=g_today                     #異動資料產生日期
   LET g_tlf.tlf08=TIME                        #異動資料產生時:分:秒
   LET g_tlf.tlf09=g_user                      #產生人
   LET g_tlf.tlf13='csft512'                   #異動命令代號
   LET g_tlf.tlf14=p_tc_imq.tc_imq17           #異動原因
   LET g_tlf.tlf15=g_debit                     #借方會計科目
   LET g_tlf.tlf16=g_credit                    #貸方會計科目
   LET g_tlf.tlf17=p_tc_imm.tc_imm09                 #remark
   CALL s_imaQOH(p_tc_imq.tc_imq05)
        RETURNING g_tlf.tlf18                  #異動後總庫存量
   #LET g_tlf.tlf19= ' '                       #異動廠商/客戶編號      #MOD-A80004 mark
   LET g_tlf.tlf19= p_tc_imm.tc_imm14          #異動廠商/客戶編號      #MOD-A80004 add
   LET g_tlf.tlf20= ' '                        #project no.
   CALL s_tlf(p_stdc,p_reason)
END FUNCTION

FUNCTION t512_u_tc_imm()
    CALL ui.Interface.refresh()
    UPDATE tc_imm_file SET tc_imm03='N' WHERE tc_imm01=g_tc_imm.tc_imm01
    IF STATUS THEN
       CALL cl_err3("upd","tc_imm_file",g_tc_imm.tc_imm01,"",SQLCA.sqlcode,"","upd tc_imm03",1)
       LET g_success='N' RETURN
    END IF
    IF SQLCA.SQLERRD[3]=0 THEN
        CALL cl_err3("upd","tc_imm_file",g_tc_imm.tc_imm01,"","mfg0177","","upd tc_imm03",1)
        LET g_success = 'N'
        RETURN
    END IF
END FUNCTION

FUNCTION t512_u_img(qty,p_type,p1,p2,p3,p4,p5,p_tc_imq) # Update img_file
    DEFINE qty		LIKE img_file.img10
    DEFINE p_tc_imq     RECORD LIKE tc_imq_file.*
    DEFINE p1           LIKE img_file.img01,
           p2           LIKE img_file.img02,
           p3           LIKE img_file.img03,
           p4           LIKE img_file.img04,
           p5           LIKE imn_file.imn02,
           l_str        STRING,
           p_type       LIKE type_file.num5

    MESSAGE "u_img!"
    CALL ui.Interface.refresh()
    IF p2 IS NULL THEN LET p2=' ' END IF
    IF p3 IS NULL THEN LET p3=' ' END IF
    IF p4 IS NULL THEN LET p4=' ' END IF

    MESSAGE "update img_file ..."

    CALL ui.Interface.refresh()
    LET g_forupd_sql =
      " SELECT img01,img02,img03,img04 FROM img_file ",
      "    WHERE img01= ? ", 
      "    AND img02= ? ",
      "    AND img03= ? ",
      "    AND img04= ? ",
      " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE img_lock1 CURSOR FROM g_forupd_sql 
    OPEN img_lock1 USING p1,p2,p3,p4       
    IF STATUS THEN                           
       CALL cl_err("Open img_lock1",STATUS,1)  
       CLOSE img_lock1            
       LET g_success = 'N'        
       RETURN                      
    END IF                          

    FETCH img_lock1 INTO p1,p2,p3,p4
    IF STATUS THEN
       LET l_str = "lock img fail, Line No:",p5 CLIPPED
       CALL cl_err(l_str,STATUS,1) LET g_success='N' RETURN
    END IF
   IF p_type='-1' THEN
      IF NOT s_stkminus(p_tc_imq.tc_imq05,p_tc_imq.tc_imq10,p_tc_imq.tc_imq11,p_tc_imq.tc_imq12,
                        p_tc_imq.tc_imq13,1,g_tc_imm.tc_immud13) THEN 
         LET g_success='N'
         RETURN
      END IF
   END IF
   CALL s_upimg(p1,p2,p3,p4,p_type,qty,g_today,'','','','',
                p_tc_imq.tc_imq01,p_tc_imq.tc_imq02,'','','','','','','','',0,0,'','')
   IF g_success = 'N' THEN
      LET g_msg='parts: ',p1 CLIPPED,' ',p2 CLIPPED,' ',p3 CLIPPED,
                ' ',p4 CLIPPED
      CALL cl_err(g_msg,'9050',1) RETURN
   END IF

END FUNCTION

FUNCTION t512_u_tlf(p_tc_imq) #------------------------------------ Update tlf_file
DEFINE la_tlf  DYNAMIC ARRAY OF RECORD LIKE tlf_file.* 
DEFINE l_sql   STRING                                  
DEFINE l_i     LIKE type_file.num5 
DEFINE p_tc_imq RECORD LIKE tc_imq_file.*                    
    MESSAGE "d_tlf!"
    CALL ui.Interface.refresh()
    LET l_sql =  " SELECT  * FROM tlf_file ", 
                 "  WHERE  tlf01 = '",p_tc_imq.tc_imq05,"'",
                 "    AND ((tlf026='",g_tc_imm.tc_imm01,"' AND tlf027=",p_tc_imq.tc_imq02,") OR ",
                 "        (tlf036='",g_tc_imm.tc_imm01,"' AND tlf037=",p_tc_imq.tc_imq02,")) ",
                 "   AND tlf06 ='",g_tc_imm.tc_immud13,"'"
    DECLARE t512_u_tlf_c CURSOR FROM l_sql
    LET l_i = 0 
    CALL la_tlf.clear()
    FOREACH t512_u_tlf_c INTO g_tlf.*
       LET l_i = l_i + 1
       LET la_tlf[l_i].* = g_tlf.*
    END FOREACH     

    DELETE FROM tlf_file
           WHERE tlf01 =p_tc_imq.tc_imq05
             AND ((tlf026=g_tc_imm.tc_imm01 AND tlf027=p_tc_imq.tc_imq02) OR
                  (tlf036=g_tc_imm.tc_imm01 AND tlf037=p_tc_imq.tc_imq02)) #異動單號/項次 
             AND tlf06 =g_tc_imm.tc_immud13 #異動日期
    IF STATUS THEN
       CALL cl_err3("del","tlf_file",g_tc_imm.tc_immud13,"",STATUS,"","del tlf:",1)
       LET g_success='N' RETURN
       LET g_success='N' RETURN
    END IF
    IF SQLCA.SQLERRD[3]=0 THEN
       CALL cl_err3("del","tlf_file",g_tc_imm.tc_immud13,"","mfg0177","","del tlf:",1)
       LET g_success='N' RETURN
       LET g_success='N' RETURN
    END IF
    FOR l_i = 1 TO la_tlf.getlength()
       LET g_tlf.* = la_tlf[l_i].*
       IF NOT s_untlf1('') THEN 
          LET g_success='N' RETURN
       END IF 
    END FOR          
END FUNCTION

FUNCTION t512_u_tlfs(p_tc_imq) #------------------------------------ Update tlfs_file
   DEFINE l_ima918   LIKE ima_file.ima918
   DEFINE l_ima921   LIKE ima_file.ima921
   DEFINE p_tc_imq RECORD LIKE tc_imq_file.*  
 
   SELECT ima918,ima921 INTO l_ima918,l_ima921 
     FROM ima_file
    WHERE ima01 = p_tc_imq.tc_imq05
      AND imaacti = "Y"
   
   IF cl_null(l_ima918) THEN
      LET l_ima918='N'
   END IF
                                                                                
   IF cl_null(l_ima921) THEN
      LET l_ima921='N'
   END IF
 
   IF l_ima918 = "N" AND l_ima921 = "N" THEN
      RETURN
   END IF
 
   MESSAGE "d_tlfs!"
 
   CALL ui.Interface.refresh()
 
   DELETE FROM tlfs_file
    WHERE tlfs01 = p_tc_imq.tc_imq05
      AND tlfs10 = p_tc_imq.tc_imq01
      AND tlfs11 = p_tc_imq.tc_imq02
      AND tlfs111 = g_tc_imm.tc_immud13
 
   IF STATUS THEN
      IF g_bgerr THEN
         LET g_showmsg = p_tc_imq.tc_imq05,'/',g_tc_imm.tc_immud13
         CALL s_errmsg('tlfs01,tlfs111',g_showmsg,'del tlfs:',STATUS,1)
      ELSE
         CALL cl_err3("del","tlfs_file",g_tc_imm.tc_imm01,"",STATUS,"","del tlfs",1)
      END IF
      LET g_success='N'
      RETURN
   END IF
 
   IF SQLCA.SQLERRD[3]=0 THEN
      IF g_bgerr THEN
         LET g_showmsg = p_tc_imq.tc_imq05,'/',g_tc_imm.tc_immud13
         CALL s_errmsg('tlfs01,tlfs111',g_showmsg,'del tlfs:','mfg0177',1)
      ELSE
         CALL cl_err3("del","tlfs_file",g_tc_imm.tc_imm01,"","mfg0177","","del tlfs",1) 
      END IF
      LET g_success='N'
      RETURN
   END IF
 
END FUNCTION

FUNCTION del_tc_imq()
DEFINE l_cnt       LIKE type_file.num5
DEFINE l_msg       STRING
   IF NOT cl_confirm('csf-513') THEN RETURN END IF

   IF g_tc_imm.tc_imm03 = 'Y' THEN
      LET l_msg = "已过账单据，无法删除"
      CALL cl_err(l_msg,'!',1)
      RETURN
   END IF
   
   DELETE FROM tc_imq_file WHERE tc_imq01 = g_tc_imm.tc_imm01
   CALL i511_b3_fill(" 1=1")
END FUNCTION

#str----add by guanyao160922
FUNCTION t512_check_sfa(p_tc_imn03,p_tc_imm08)
DEFINE p_tc_imn03     LIKE tc_imn_file.tc_imn03
DEFINE p_tc_imm08     LIKE tc_imm_file.tc_imm08
DEFINE l_sfa          RECORD LIKE sfa_file.*
DEFINE l_sum1         LIKE tc_imp_file.tc_imp09
DEFINE l_sum2         LIKE tc_imp_file.tc_imp09
DEFINE l_sql          STRING 

    LET g_error = 'Y'
  # LET l_sql = " SELECT * FROM sfa_file WHERE sfa01 ='",p_tc_imn03 CLIPPED,"' AND sfa08 ='",p_tc_imm08 CLIPPED,"' AND sfa11 ='E'"
    LET l_sql = " SELECT * FROM sfa_file WHERE sfa01 ='",p_tc_imn03 CLIPPED,"' AND sfa08 ='",p_tc_imm08 CLIPPED,"' AND sfa11 ='N'"
    PREPARE i511_sfa_p1 FROM l_sql
    DECLARE i511_sfa_c1 CURSOR FOR i511_sfa_p1
    FOREACH i511_sfa_c1 INTO l_sfa.*
       #已经审核过账的数量
       LET l_sum1 = 0
       SELECT SUM(tc_imp09) INTO l_sum1 FROM tc_imp_file,tc_imm_file 
        WHERE tc_imp03 = l_tc_imn.tc_imn03 
          AND tc_imp05 = l_sfa.sfa03 
          AND tc_imp04 = l_tc_imn.tc_imn04
          AND tc_imm01 = tc_imp01
          AND tc_imm03 = 'Y'
       #已经未审核过账的数量
       LET l_sum2 = 0
       SELECT SUM(tc_imp08) INTO l_sum2 FROM tc_imp_file,tc_imm_file 
        WHERE tc_imp03 = l_tc_imn.tc_imn03 
          AND tc_imp05 = l_sfa.sfa03 
          AND tc_imp04 = l_tc_imn.tc_imn04
          AND tc_imm01 = tc_imp01
          AND tc_imm03 = 'N'
          AND tc_immconf <>'X'
       IF cl_null(l_sum1) THEN LET l_sum1 = 0 END IF 
       IF cl_null(l_sum2) THEN LET l_sum2 = 0 END IF 
       IF (l_sfa.sfa05 - l_sum1 - l_sum2)>0 THEN 
          LET g_error = 'Y'
          RETURN 
       END IF 
    END FOREACH 
    LET g_error = 'N'
END FUNCTION 

FUNCTION t512sub_t3()
DEFINE l_sql   STRING 
DEFINE sr   RECORD 
     tc_imq03    LIKE tc_imq_file.tc_imq03,
     tc_imq04    LIKE tc_imq_file.tc_imq04,
     tc_imq05    LIKE tc_imq_file.tc_imq05,
     tc_imq15    LIKE tc_imq_file.tc_imq15
   END RECORD  
           

     LET l_sql = "SELECT tc_imq03,tc_imq04,tc_imq05,SUM(tc_imq15) ",
                 "  FROM tc_imq_file",
                 " WHERE tc_imq01 = '",g_tc_imm.tc_imm01,"'",
                 " GROUP BY tc_imq03,tc_imq04,tc_imq05"
     PREPARE i511_up_p FROM l_sql
     DECLARE i511_up_c CURSOR FOR i511_up_p
     FOREACH i511_up_c INTO sr.*
        IF sr.tc_imq15 >0 THEN 
           UPDATE tc_imp_file SET tc_imp09 = sr.tc_imq15 
            WHERE tc_imp01 = g_tc_imm.tc_imm01
              AND tc_imp03 = sr.tc_imq03
              AND tc_imp04 = sr.tc_imq04
              AND tc_imp05 = sr.tc_imq05
           IF SQLCA.sqlcode THEN
              CALL cl_err3("upd","tc_imp_file",g_tc_imm.tc_imm01,"",SQLCA.sqlcode,"","",1)
              LET g_success = 'N' 
              RETURN 
           END IF
        END IF 
     END FOREACH 
                  
END FUNCTION 
#end----add by guanyao160922


#str----------add by huzhou20170809
FUNCTION t511_list_fill()

DEFINE	l_tc_imm01	LIKE tc_imm_file.tc_imm01
DEFINE  l_i		LIKE type_file.num10

  	CALL j_imn_l.clear()
	LET l_i = 1
 	FOREACH i511_cs INTO g_tc_imm.tc_imm01
	   IF SQLCA.sqlcode THEN
 	       CALL cl_err('foreach item_cur',SQLCA.sqlcode,1)
	       CONTINUE FOREACH
	   END IF

	SELECT tc_imm01,tc_imm02,tc_imm04,tc_imm08,tc_imm10,tc_imm14,tc_imm16,tc_immconf,'','' 
        INTO j_imn_l[l_i].*
	FROM tc_imm_file WHERE tc_imm01 = g_tc_imm.tc_imm01
	SELECT gen02 INTO j_imn_l[l_i].gen02 FROM gen_file WHERE gen01=j_imn_l[l_i].tc_imm16
        SELECT gem02 INTO j_imn_l[l_i].gem02 FROM gem_file WHERE gem01=j_imn_l[l_i].tc_imm14
	LET l_i = l_i + 1
	END FOREACH
	LET g_rec_b4 = l_i-1
        LET l_i = 0
	DISPLAY ARRAY j_imn_l TO j_imn.* ATTRIBUTE(COUNT=g_rec_b4, UNBUFFERED)
	BEFORE DISPLAY
	   EXIT DISPLAY
	END DISPLAY        


END FUNCTION
#end-------------add by huzhou170808  	

FUNCTION i511_bp4(p_ud)		#add by huzhou20170808
 DEFINE   p_ud   LIKE type_file.chr1

   IF p_ud <> "G" THEN 
      RETURN
   END IF
   
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel,user_defined_columns", FALSE)
   DISPLAY ARRAY j_imn_l TO j_imn.* ATTRIBUTE(COUNT=g_rec_b4)
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
     
      ON ACTION page_main
        LET l_action_flag = "page_main"
        LET l_ac1 = ARR_CURR()
        LET g_jump = l_ac1
        LET mi_no_ask = TRUE
	OPEN i511_cs
        CALL i511_fetch('/')
            
        CALL cl_set_comp_visible("info,page_list", FALSE)
        CALL ui.interface.refresh()
        CALL cl_set_comp_visible("info,page_list", TRUE)
        EXIT DISPLAY

      
      ON ACTION ACCEPT
	LET l_action_flag = "page_main"
	LET l_ac1 = ARR_CURR()
	LET g_jump = l_ac1
	LET mi_no_ask = TRUE
	OPEN i511_cs
	CALL i511_fetch('/')
	
	CALL cl_set_comp_visible("info,page_list", FALSE)
	CALL ui.interface.refresh()
	CALL cl_set_comp_visible("info,page_list", TRUE)
        EXIT DISPLAY

      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION controlg      
         CALL cl_cmdask()     
 
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
{      ON ACTION first
         CALL i511_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)
           END IF
         EXIT DISPLAY
      ON ACTION previous
         CALL i511_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)
           END IF
         EXIT DISPLAY
      ON ACTION jump
         CALL i511_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)
           END IF
         EXIT DISPLAY
      ON ACTION next
         CALL i511_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)
           END IF
         EXIT DISPLAY
      ON ACTION last
         CALL i511_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)
           END IF
         EXIT DISPLAY     }#add by huzhou
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION close
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION user_defined_columns
         LET g_action_choice="user_defined_columns"
         EXIT DISPLAY
 
     # ON ACTION accept
     #    LET g_action_choice="user_defined_columns"
     #    LET l_ac = ARR_CURR()
     #    EXIT DISPLAY
 
      ON ACTION related_document                #相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
         
      ON ACTION modify_wo
         LET g_action_choice="modify_wo"   
         LET l_ac = ARR_CURR()       
         EXIT DISPLAY
      
      ON ACTION create_des
         LET g_action_choice="create_des"          
         EXIT DISPLAY
         
      ON ACTION confirm
         LET g_action_choice="confirm"          
         EXIT DISPLAY
      
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"          
         EXIT DISPLAY
      
      ON ACTION post
         LET g_action_choice="post"          
         EXIT DISPLAY
         
      ON ACTION undo_post
         LET g_action_choice="undo_post"          
         EXIT DISPLAY
      
      ON ACTION del_tc_im
         LET g_action_choice="del_tc_im"          
         EXIT DISPLAY
                                                         
      ON ACTION controls                                                        
         CALL cl_set_head_visible("folder01","AUTO")                            
      &include "qry_string.4gl"
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#str-------------end by huzhou 20170808










