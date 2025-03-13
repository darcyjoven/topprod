# Prog. Version..: '5.25.01-10.05.01(00010)'     #
# Pattern name...: ghri016.4gl
# Descriptions...:
# Date & Author..: 13/5/10 By zhangbo

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_hraz_h       RECORD
           hraz01     LIKE hraz_file.hraz01,    
           hraz04     LIKE hraz_file.hraz04,
           hraz19     LIKE hraz_file.hraz19,
           hraz05     LIKE hraz_file.hraz05,
           hraz31     LIKE hraz_file.hraz31,
           hraz08     LIKE hraz_file.hraz08,
           hrazud02   LIKE hraz_file.hrazud02,
           hrazud03   LIKE hraz_file.hrazud03,
           hraz10     LIKE hraz_file.hraz10,
           hraz41     LIKE hraz_file.hraz41,
           hraz12     LIKE hraz_file.hraz14,
           hraz14     LIKE hraz_file.hraz14,
           hraz16     LIKE hraz_file.hraz16,
           hraz34     LIKE hraz_file.hraz34,
           hrazud06   LIKE hraz_file.hrazud06,
           hraz39     LIKE hraz_file.hraz39,
           hraz37     LIKE hraz_file.hraz37,
           hraz17     LIKE hraz_file.hraz17,
           hraz18     LIKE hraz_file.hraz18,
           hraz23     LIKE hraz_file.hraz23,
           hraz24     LIKE hraz_file.hraz24,
           hraz27     LIKE hraz_file.hraz27,
           hraz28     LIKE hraz_file.hraz28,
           hraz25     LIKE hraz_file.hraz25,
           hraz26     LIKE hraz_file.hraz26,
           hraz44     LIKE hraz_file.hraz44,
           hrazud01   LIKE hraz_file.hrazud01,
           hrazuser   LIKE hraz_file.hrazuser,
           hrazgrup   LIKE hraz_file.hrazgrup,
           hrazmodu   LIKE hraz_file.hrazmodu,
           hrazdate   LIKE hraz_file.hrazdate,
           hrazoriu   LIKE hraz_file.hrazoriu,
           hrazorig   LIKE hraz_file.hrazorig,
           ta_hraz01  LIKE hraz_file.ta_hraz01
           END RECORD, 
           
       g_hraz_h_t     RECORD
           hraz01     LIKE hraz_file.hraz01,    
           hraz04     LIKE hraz_file.hraz04,
           hraz19     LIKE hraz_file.hraz19,
           hraz05     LIKE hraz_file.hraz05,
           hraz31     LIKE hraz_file.hraz31,
           hraz08     LIKE hraz_file.hraz08,
           hrazud02   LIKE hraz_file.hrazud02,
           hrazud03   LIKE hraz_file.hrazud03,
           hraz10     LIKE hraz_file.hraz10,
           hraz41     LIKE hraz_file.hraz41,
           hraz12     LIKE hraz_file.hraz14,
           hraz14     LIKE hraz_file.hraz14,
           hraz16     LIKE hraz_file.hraz16,
           hraz34     LIKE hraz_file.hraz34,
           hrazud06   LIKE hraz_file.hrazud06,
           hraz39     LIKE hraz_file.hraz39,
           hraz37     LIKE hraz_file.hraz37,
           hraz17     LIKE hraz_file.hraz17,
           hraz18     LIKE hraz_file.hraz18,
           hraz23     LIKE hraz_file.hraz23,
           hraz24     LIKE hraz_file.hraz24,
           hraz27     LIKE hraz_file.hraz27,
           hraz28     LIKE hraz_file.hraz28,
           hraz25     LIKE hraz_file.hraz25,
           hraz26     LIKE hraz_file.hraz26,
           hraz44     LIKE hraz_file.hraz44,
           hrazud01   LIKE hraz_file.hrazud01,
           hrazuser   LIKE hraz_file.hrazuser,
           hrazgrup   LIKE hraz_file.hrazgrup,
           hrazmodu   LIKE hraz_file.hrazmodu,
           hrazdate   LIKE hraz_file.hrazdate,
           hrazoriu   LIKE hraz_file.hrazoriu,
           hrazorig   LIKE hraz_file.hrazorig,
           ta_hraz01  LIKE hraz_file.ta_hraz01           
                      END RECORD,
                  
       g_hraz         DYNAMIC ARRAY OF RECORD 
           hraz43          LIKE hraz_file.hraz43,    
           hraz32          LIKE hraz_file.hraz32,    
           hrat02          LIKE hrat_file.hrat02,    
           hraz30          LIKE hraz_file.hraz30,    
           hraz30_desc     LIKE hraa_file.hraa12,    
           hraz07          LIKE hraz_file.hraz07,    
           hraz07_desc     LIKE hrao_file.hrao02,
           hrazud04        LIKE hraz_file.hrazud04,
           hrazud04_desc   LIKE hrao_file.hrao02,
           hrazud05        LIKE hraz_file.hrazud05,
           hrazud05_desc   LIKE hrao_file.hrao02, 
           hrazud07        LIKE hraz_file.hrazud07,
           hrazud07_desc   LIKE hrag_file.hrag07,       
           hraz09          LIKE hraz_file.hraz09,    
           hraz09_desc     LIKE hras_file.hras04,    
           hraz40          LIKE hraz_file.hraz40,    
           hraz33          LIKE hraz_file.hraz33,    
           hraz33_desc     LIKE hrat_file.hrat02,    
           hraz13          LIKE hraz_file.hraz13,
           hraz13_desc     LIKE hraf_file.hraf02,
           hraz15          LIKE hraz_file.hraz15,
           hraz11          LIKE hraz_file.hraz11,
           hraz11_desc     LIKE hrai_file.hrai04,
           hraz38          LIKE hraz_file.hraz38,
           ta_hraz02       LIKE hraz_file.ta_hraz02,
           ta_hraz02_n     LIKE hraz_file.ta_hraz02    
                      END RECORD,
                      
       g_hraz_t       RECORD
           hraz43          LIKE hraz_file.hraz43,    
           hraz32          LIKE hraz_file.hraz32,    
           hrat02          LIKE hrat_file.hrat02,    
           hraz30          LIKE hraz_file.hraz30,    
           hraz30_desc     LIKE hraa_file.hraa12,    
           hraz07          LIKE hraz_file.hraz07,    
           hraz07_desc     LIKE hrao_file.hrao02,
           hrazud04        LIKE hraz_file.hrazud04,
           hrazud04_desc   LIKE hrao_file.hrao02,
           hrazud05        LIKE hraz_file.hrazud05,
           hrazud05_desc   LIKE hrao_file.hrao02,   
           hrazud07        LIKE hraz_file.hrazud07,
           hrazud07_desc   LIKE hrag_file.hrag07,    
           hraz09          LIKE hraz_file.hraz09,    
           hraz09_desc     LIKE hras_file.hras04,    
           hraz40          LIKE hraz_file.hraz40,    
           hraz33          LIKE hraz_file.hraz33,    
           hraz33_desc     LIKE hrat_file.hrat02,    
           hraz13          LIKE hraz_file.hraz13,
           hraz13_desc     LIKE hraf_file.hraf02,
           hraz15          LIKE hraz_file.hraz15,
           hraz11          LIKE hraz_file.hraz11,
           hraz11_desc     LIKE hrai_file.hrai04,
           hraz38          LIKE hraz_file.hraz38,
           ta_hraz02       LIKE hraz_file.ta_hraz02,
           ta_hraz02_n     LIKE hraz_file.ta_hraz02                                  
                     END RECORD,
       g_sql         STRING,                      
       g_wc          STRING,                     
       g_wc2         STRING,                    
       g_rec_b       LIKE type_file.num5,      
       l_ac          LIKE type_file.num5
       
DEFINE g_hraz1       DYNAMIC ARRAY OF RECORD
         jump        LIKE   type_file.num5,
         hraz01      LIKE   hraz_file.hraz01
                     END RECORD       
       
DEFINE g_hraz_1      DYNAMIC ARRAY OF RECORD
         hraz32_1    LIKE  hraz_file.hraz32,
         hrat02_1    LIKE  hrat_file.hrat02,
         hraz31_1    LIKE  hraa_file.hraa12,
         hraz08_1    LIKE  hrao_file.hrao02,
         hraz10_1    LIKE  hras_file.hras04,
         hraz12_1    LIKE  hrai_file.hrai04,
         hraz14_1    LIKE  hraf_file.hraf02,
         hraz16_1    LIKE  hraz_file.hraz16,
         hraz04_1    LIKE  hraz_file.hraz04,
         hraz19_1    LIKE  hraz_file.hraz19,
         hraz05_1    LIKE  hraz_file.hraz05,
         hraz43_1    LIKE  hraz_file.hraz43,
         hraz30_1    LIKE  hraa_file.hraa12,
         hraz07_1    LIKE  hrao_file.hrao02,
         hraz09_1    LIKE  hras_file.hras04,
         hraz11_1    LIKE  hrai_file.hrai04,
         hraz13_1    LIKE  hraf_file.hraf02,
         hraz15_1    LIKE  hraz_file.hraz15,
         hraz38_1    LIKE  hraz_file.hraz38,
         hraz39_1    LIKE  hraz_file.hraz39,
         hraz18_1    LIKE  hraz_file.hraz18,
         hrazud01_1  LIKE  hraz_file.hrazud01,
         ta_hraz01   LIKE hraz_file.ta_hraz02,
         ta_hraz01_n   LIKE hraz_file.ta_hraz02  
                     END RECORD,
         g_rec_b1    LIKE  type_file.num5,
         l_ac1       LIKE  type_file.num5            
                                   
DEFINE g_forupd_sql        STRING               
DEFINE g_before_input_done LIKE type_file.num5 
DEFINE g_cnt               LIKE type_file.num10
DEFINE g_i                 LIKE type_file.num5  
DEFINE g_curs_index        LIKE type_file.num10
DEFINE g_row_count         LIKE type_file.num10
DEFINE g_jump              LIKE type_file.num10
DEFINE g_no_ask            LIKE type_file.num5
DEFINE g_msg               STRING
DEFINE g_chr               LIKE type_file.chr1
DEFINE g_flag              LIKE type_file.chr1
DEFINE g_bp_flag           LIKE type_file.chr1
 
 
MAIN
DEFINE l_name   STRING
DEFINE l_items  STRING
   OPTIONS                              
      INPUT NO WRAP
      
   DEFER INTERRUPT                     
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
   	
   WHENEVER ERROR CALL cl_err_msg_log
   IF (NOT cl_setup("GHR")) THEN
      EXIT PROGRAM
   END IF
 
   OPEN WINDOW i016_w WITH FORM "ghr/42f/ghri016"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
      
   CALL cl_set_combo_items("hraz04",NULL,NULL)
   CALL cl_set_combo_items("hraz41",NULL,NULL)
   CALL cl_set_combo_items("hraz16",NULL,NULL)
   CALL cl_set_combo_items("hraz39",NULL,NULL)
   CALL cl_set_combo_items("hraz18",NULL,NULL)
   CALL cl_set_combo_items("hraz40",NULL,NULL)
   CALL cl_set_combo_items("hraz15",NULL,NULL)
   CALL cl_set_combo_items("hraz38",NULL,NULL)
   CALL cl_set_combo_items("hraz16_1",NULL,NULL)
   CALL cl_set_combo_items("hraz15_1",NULL,NULL)
   CALL cl_set_combo_items("hraz04_1",NULL,NULL)
   CALL cl_set_combo_items("hraz38_1",NULL,NULL)
   CALL cl_set_combo_items("hraz39_1",NULL,NULL)
   CALL cl_set_combo_items("hraz18_1",NULL,NULL) 
   
   #变更类型
   CALL i016_get_items('328') RETURNING l_name,l_items
   CALL cl_set_combo_items("hraz04",l_name,l_items)
   CALL cl_set_combo_items("hraz04_1",l_name,l_items)
   #职位等级
   CALL i016_get_items('205') RETURNING l_name,l_items
   CALL cl_set_combo_items("hraz40",l_name,l_items)
   CALL cl_set_combo_items("hraz41",l_name,l_items)
   #所属厂区
   CALL i016_get_items('325') RETURNING l_name,l_items
   CALL cl_set_combo_items("hraz15",l_name,l_items)
   CALL cl_set_combo_items("hraz16",l_name,l_items)
   CALL cl_set_combo_items("hraz15_1",l_name,l_items)
   CALL cl_set_combo_items("hraz16_1",l_name,l_items)
   #直/间接
   CALL i016_get_items('337') RETURNING l_name,l_items
   CALL cl_set_combo_items("hraz38",l_name,l_items)
   CALL cl_set_combo_items("hraz39",l_name,l_items) 
   CALL cl_set_combo_items("hraz38_1",l_name,l_items)
   CALL cl_set_combo_items("hraz39_1",l_name,l_items)
   #单据状态
   CALL i016_get_items('103') RETURNING l_name,l_items
   CALL cl_set_combo_items("hraz18",l_name,l_items)
   CALL cl_set_combo_items("hraz18_1",l_name,l_items)   
      
   CALL cl_ui_init()
   
   
   
   LET g_forupd_sql =" SELECT hraz01,hraz04,hraz19,hraz05,hraz31,hraz08,hrazud02,hrazud03,",
                     "        hraz10,hraz41,hraz12,hraz14,hraz16,hraz34,hrazud06,",
                     "        hraz39,hraz37,hraz17,hraz18,hraz23,hraz24,",
                     "        hraz27,hraz28,hraz25,hraz26 ",
                     "   FROM hraz_file ",
                     "  WHERE hraz01 = ? FOR UPDATE "
                     
   DECLARE i016_lock_u CURSOR FROM g_forupd_sql                  
    
   CALL i016_menu()
   CLOSE WINDOW i016_w        
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION i016_get_items(p_hrag01)
DEFINE p_hrag01   LIKE  hrag_file.hrag01
DEFINE l_name   STRING
DEFINE l_items  STRING
DEFINE l_hrag06 LIKE  hrag_file.hrag06
DEFINE l_hrag07 LIKE  hrag_file.hrag07
DEFINE l_sql    STRING

       LET l_sql=" SELECT hrag06,hrag07 FROM hrag_file WHERE hrag01='",p_hrag01,"'",
                 "  ORDER BY hrag06"
       PREPARE i016_get_items_pre FROM l_sql
       DECLARE i016_get_items CURSOR FOR i016_get_items_pre
       
       LET l_name=''
       LET l_items=''
       
       FOREACH i016_get_items INTO l_hrag06,l_hrag07
          IF cl_null(l_name) AND cl_null(l_items) THEN
            LET l_name=l_hrag06
            LET l_items=l_hrag07
          ELSE
            LET l_name=l_name CLIPPED,",",l_hrag06 CLIPPED
            LET l_items=l_items CLIPPED,",",l_hrag07 CLIPPED
          END IF
       END FOREACH
       
       RETURN l_name,l_items
END FUNCTION


FUNCTION i016_cs()
DEFINE lc_qbe_sn   LIKE gbm_file.gbm01   
DEFINE l_wc        STRING
   CLEAR FORM 
   CALL g_hraz.clear()
   
   CALL cl_set_head_visible("","YES")
       
   INITIALIZE g_hraz_h.* TO NULL     
   CONSTRUCT BY NAME g_wc ON hraz04,hraz31,hraz08,hraz10,hraz12,hraz14,hrazud06,
                             #hraz34,
                             hraz19,hraz05,hraz41,hraz16,hraz39,hraz37,hraz18,
                             #hraz23,hraz24,hraz27,hraz28,hraz25,hraz26,
                             hraz17,hrazud01,hrazud02,hrazud03,
                             hrazuser,hrazgrup,hrazmodu,hrazdate,hrazoriu,hrazorig,ta_hraz01
      BEFORE CONSTRUCT
         CALL cl_qbe_init()  
      ON ACTION controlp
         CASE
            WHEN INFIELD(hraz31)             
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_hraa01"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO hraz31 
               NEXT FIELD hraz31
            WHEN INFIELD(ta_hraz01)             
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_hrar03_zw"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ta_hraz01 
               NEXT FIELD ta_hraz01
#            WHEN INFIELD(hraz08)             
#               CALL cl_init_qry_var()
#               LET g_qryparam.state = 'c'
#               LET g_qryparam.form ="q_hrao01"
#               CALL cl_create_qry() RETURNING g_qryparam.multiret
#               DISPLAY g_qryparam.multiret TO hraz08 
#               NEXT FIELD hraz08
            WHEN INFIELD(hraz08)
               {CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_hrao01"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO hraz08
               NEXT FIELD hraz08}

               CALL cl_init_qry_var()
                 LET g_qryparam.arg2 = '1'
                 LET g_qryparam.form = "cq_hrao01_1_1"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hraz08
                 NEXT FIELD hraz08

               #课别
            WHEN INFIELD(hrazud02)
               {CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_hrao01"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO hraz08
               NEXT FIELD hraz08}

                  CALL cl_init_qry_var()
                 LET g_qryparam.arg2 = '2'
                 LET g_qryparam.form = "cq_hrao01_1_1"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrazud02
                 NEXT FIELD hrazud02
               #组别
            WHEN INFIELD(hrazud03)
               {CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_hrao01"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO hraz08
               NEXT FIELD hraz08}
               CALL cl_init_qry_var()
                 LET g_qryparam.arg2 = '3'
                 LET g_qryparam.form = "cq_hrao01_1_1"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrazud03
                 NEXT FIELD hrazud03      
            WHEN INFIELD(hrazud06)
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg1 = '313'
                 LET g_qryparam.form = "q_hrag06"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrazud06
                 NEXT FIELD hrazud06     
                       
            WHEN INFIELD(hraz10)             
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_hrap01"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO hraz10 
               NEXT FIELD hraz10
            
            WHEN INFIELD(hraz12)             
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_hrai03"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO hraz12 
               NEXT FIELD hraz12
               
            WHEN INFIELD(hraz14)             
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_hraf01"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO hraz14 
               NEXT FIELD hraz14
               
            WHEN INFIELD(hraz34)             
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_hrat01"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO hraz34 
               NEXT FIELD hraz34
               
            WHEN INFIELD(hraz24)             
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_hrat01"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO hraz24 
               NEXT FIELD hraz24
               
            WHEN INFIELD(hraz26)             
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_hrat01"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO hraz26 
               NEXT FIELD hraz26
               
            WHEN INFIELD(hraz28)             
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_hrat01"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO hraz28 
               NEXT FIELD hraz28
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
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('hrazuser', 'hrazgrup')
   LET g_wc = g_wc CLIPPED
   
   IF INT_FLAG THEN
      RETURN
   END IF


   CONSTRUCT g_wc2 ON hraz43,hraz32,hraz30,hraz07,hrazud04,hrazud05,hraz09,hraz40,
                      #hraz33,
                      hraz13,hraz15,hraz11,hraz38
           FROM s_hraz[1].hraz43,s_hraz[1].hraz32,s_hraz[1].hraz30,s_hraz[1].hraz07,
                s_hraz[1].hrazud04,s_hraz[1].hrazud05,
                s_hraz[1].hraz09,s_hraz[1].hraz40,
                #s_hraz[1].hraz33,
                s_hraz[1].hraz13,
                s_hraz[1].hraz15,s_hraz[1].hraz11,s_hraz[1].hraz38
                
      BEFORE CONSTRUCT
         CALL cl_qbe_display_condition(lc_qbe_sn)  
      ON ACTION CONTROLP
         CASE            
            WHEN INFIELD(hraz43)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_hrat01"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO hraz43                  
               NEXT FIELD hraz43
               
            WHEN INFIELD(hraz30)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_hraa01"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO hraz30                  
               NEXT FIELD hraz30
               
#            WHEN INFIELD(hraz07)
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_hrao01"
#               LET g_qryparam.state = "c"
#               CALL cl_create_qry() RETURNING g_qryparam.multiret
#               DISPLAY g_qryparam.multiret TO hraz07                  
#               NEXT FIELD hraz07

            WHEN INFIELD(hraz07)
               {CALL cl_init_qry_var()
               LET g_qryparam.form = "q_hrao01"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO hraz07
               NEXT FIELD hraz07}

                 CALL cl_init_qry_var()
                 LET g_qryparam.arg2 = '1'
                 LET g_qryparam.form = "cq_hrao01_1_1"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hraz07
                 NEXT FIELD hraz07

            #课别
             WHEN INFIELD(hrazud04)
               {CALL cl_init_qry_var()
               LET g_qryparam.form = "q_hrao01"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO hrazud04
               NEXT FIELD hrazud04}
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg2 = '2'
                 LET g_qryparam.form = "cq_hrao01_1_1"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrazud04
                 NEXT FIELD hrazud04

             WHEN INFIELD(hrazud05)
              { CALL cl_init_qry_var()
               LET g_qryparam.form = "q_hrao01"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO hrazud05
               NEXT FIELD hrazud05}
               CALL cl_init_qry_var()
                 LET g_qryparam.arg2 = '3'
                 LET g_qryparam.form = "cq_hrao01_1_1"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrazud05
                 NEXT FIELD hrazud05
               
            WHEN INFIELD(hraz09)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_hrap01"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO hraz09                  
               NEXT FIELD hraz09
               
            WHEN INFIELD(hraz33)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_hrat01"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO hraz33                  
               NEXT FIELD hraz33
               
            WHEN INFIELD(hraz13)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_hraf01"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO hraz13                  
               NEXT FIELD hraz13
               
            WHEN INFIELD(hraz11)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_hrai03"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO hraz11                  
               NEXT FIELD hraz11         
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
      ON ACTION qbe_save
         CALL cl_qbe_save()
   END CONSTRUCT
   IF INT_FLAG THEN
      RETURN
   END IF
   #CALL cl_replace_str(g_wc,'hraz34','A.hrat01') RETURNING g_wc   
   #CALL cl_replace_str(g_wc,'hraz24','B.hrat01') RETURNING g_wc
   #CALL cl_replace_str(g_wc,'hraz26','C.hrat01') RETURNING g_wc
   #CALL cl_replace_str(g_wc,'hraz28','D.hrat01') RETURNING g_wc
   #CALL cl_replace_str(g_wc2,'hraz33','E.hrat01') RETURNING g_wc2
   #LET g_sql = "SELECT DISTINCT hraz01 FROM hraz_file,hrat_file A,hrat_file B,",
   #            "                            hrat_file C,hrat_file D,hrat_file E ",
   #            " WHERE ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
   #            "   AND A.hratid=hraz34(+) AND B.hratid=hraz24(+)",
   #            "   AND C.hratid=hraz26(+) AND D.hratid=hraz28(+)",
   #            "   AND E.hratid=hraz33(+) ",
   #            " ORDER BY hraz01"
   LET g_sql = "SELECT DISTINCT hraz01 FROM hraz_file
                left join hrat_file on hratid=hraz03",
               " WHERE ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
               " ORDER BY hraz01"
   PREPARE i016_prepare FROM g_sql
   DECLARE i016_cs SCROLL CURSOR WITH HOLD FOR i016_prepare 
   
   #LET g_sql="SELECT COUNT(DISTINCT hraz01) FROM hraz_file WHERE ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
   #          "   AND A.hratid=hraz34(+) AND B.hratid=hraz24(+)",
   #          "   AND C.hratid=hraz26(+) AND D.hratid=hraz28(+)",
   #          "   AND E.hratid=hraz33(+) "
   LET g_sql="SELECT COUNT(DISTINCT hraz01) FROM hraz_file 
              left join hrat_file on hratid=hraz03
              WHERE ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
   PREPARE i016_precount FROM g_sql
   DECLARE i016_count CURSOR FOR i016_precount
END FUNCTION
	
FUNCTION i016_menu()
#hui chu zhi ding chuang ti 
DEFINE w ui.Window
DEFINE f ui.Form
DEFINE page om.DomNode
#end
   WHILE TRUE
      CALL i016_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i016_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i016_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i016_b()
            ELSE
               LET g_action_choice = NULL
            END IF
            	
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i016_u()
            END IF 

         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i016_r()
            END IF 

         WHEN "ghri016_a"
            IF cl_chk_act_auth() THEN
               CALL i016_confirm()
            END IF

         WHEN "ghri016_b"
            IF cl_chk_act_auth() THEN
               CALL i016_undo_confirm()
            END IF

        WHEN "exporttoexcel"
           IF cl_chk_act_auth() THEN
              LET w = ui.Window.getCurrent()
              LET f = w.getForm()
              LET page = f.FindNode("Page","page2")
              CALL cl_export_to_excel(page,base.TypeInfo.create(g_hraz_1),'','')
             #CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hraz_1),'','')
           END IF
        
         WHEN "ghri016_c"
            IF cl_chk_act_auth() THEN
               CALL i016_guidang()
            END IF
            		
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask() 
      END CASE
   END WHILE
END FUNCTION
	
FUNCTION i016_bp(p_ud)
DEFINE   p_ud   LIKE type_file.chr1    


   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)

   DIALOG ATTRIBUTES(UNBUFFERED)
   
   DISPLAY ARRAY g_hraz TO s_hraz.* ATTRIBUTE(COUNT=g_rec_b)
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()   
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DIALOG
      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG

      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DIALOG

      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DIALOG 

      ON ACTION detail
         LET g_action_choice="detail"
         EXIT DIALOG
      
      ON ACTION accept
         LET g_action_choice="detail"
         EXIT DIALOG

      ON ACTION ghri016_a
         LET g_action_choice="ghri016_a"
         EXIT DIALOG

      ON ACTION ghri016_b
         LET g_action_choice="ghri016_b"
         EXIT DIALOG

      ON ACTION ghri016_c
         LET g_action_choice="guidang"
         EXIT DIALOG
         
      ON ACTION first
         CALL i016_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG
      ON ACTION previous
         CALL i016_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG  
      ON ACTION jump
         CALL i016_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG
      ON ACTION next
         CALL i016_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG
      ON ACTION last
         CALL i016_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG

       ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG
      ON ACTION cancel
         LET INT_FLAG=FALSE      
         LET g_action_choice="exit"
         EXIT DIALOG
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
      ON ACTION about         
         CALL cl_about()     
      AFTER DISPLAY
         CONTINUE DIALOG
      #&include "qry_string.4gl" 
   END DISPLAY
   
   DISPLAY ARRAY g_hraz_1 TO s_hraz_1.* ATTRIBUTE(COUNT=g_rec_b1)
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
      BEFORE ROW
         LET l_ac1 = ARR_CURR()
         CALL cl_show_fld_cont() 
         
       ON ACTION main
         LET g_bp_flag = 'Page1'
         LET l_ac1 = ARR_CURR()
         LET g_no_ask = TRUE
         IF g_rec_b1 >0 THEN
             LET g_jump = g_hraz1[l_ac1].jump
             CALL i016_fetch('/')
         END IF
         CALL cl_set_comp_visible("Page2", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("Page2", TRUE)
         EXIT DIALOG
      
      ON ACTION accept
         LET l_ac1 = ARR_CURR()
         LET g_no_ask = TRUE
         LET g_bp_flag = NULL
         IF g_rec_b1>0 THEN
            LET g_jump = g_hraz1[l_ac1].jump
            CALL i016_fetch('/')
         END IF
         CALL cl_set_comp_visible("Page2", FALSE)
         CALL ui.interface.refresh()                  #NO.FUN-840018 ADD
         CALL cl_set_comp_visible("Page2", TRUE)
         EXIT DIALOG
              
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DIALOG
      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG

      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DIALOG

      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DIALOG
      
      #ON ACTION piliang
      #   LET g_action_choice="piliang"
      #   EXIT DIALOG   
         
      ON ACTION first
         CALL i016_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG
      ON ACTION previous
         CALL i016_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG  
      ON ACTION jump
         CALL i016_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG
      ON ACTION next
         CALL i016_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG
      ON ACTION last
         CALL i016_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG
      
       ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG
      ON ACTION exporttoexcel
         LET g_action_choice="exporttoexcel"
         EXIT DIALOG
         
      ON ACTION cancel
         LET INT_FLAG=FALSE      
         LET g_action_choice="exit"
         EXIT DIALOG
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
      ON ACTION about         
         CALL cl_about()     
      AFTER DISPLAY
         CONTINUE DIALOG
      #&include "qry_string.4gl" 
   END DISPLAY
   
   END DIALOG
   
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION	
	
FUNCTION i016_a()
DEFINE li_result   LIKE type_file.num5    #No.FUN-680136 SMALLINT
DEFINE ls_doc      STRING

   MESSAGE ""
   CLEAR FORM
   CALL g_hraz.clear()
   CALL g_hraz_1.clear()
   LET g_wc = NULL
   LET g_wc2= NULL 
   IF s_shut(0) THEN
      RETURN
   END IF
   INITIALIZE g_hraz_h.*  TO NULL
   LET g_hraz_h.hraz05=g_today
   LET g_hraz_h.hraz19=g_today
   LET g_hraz_h.hraz18='001'
   LET g_hraz_h.hraz44='N'
   LET g_hraz_h.hraz31='1000' 
   LET g_hraz_h.hraz16='000'
   LET g_hraz_h.hraz39='001'
   LET g_hraz_h.hrazud01='N'       
   WHILE TRUE
      CALL i016_i("a")      
      IF INT_FLAG THEN     
         INITIALIZE g_hraz_h.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
     
      LET g_rec_b = 0 
      LET g_rec_b1 = 0
      CALL i016_b() 
      EXIT WHILE
   END WHILE
END FUNCTION
	
FUNCTION i016_i(p_cmd)
DEFINE  p_cmd             LIKE type_file.chr1
DEFINE  l_num,l_n         LIKE type_file.num5
DEFINE  l_hraa12          LIKE hraa_file.hraa12
DEFINE  l_hrao02          LIKE hrao_file.hrao02
DEFINE  l_hras04          LIKE hras_file.hras04
DEFINE  l_hrai04          LIKE hrai_file.hrai04
DEFINE  l_hraf02          LIKE hraf_file.hraf02
DEFINE  l_hraz34_desc,l_hrazud06_n     LIKE hrat_file.hrat02
DEFINE  l_hraz24_desc     LIKE hrat_file.hrat02
DEFINE  l_hraz26_desc     LIKE hrat_file.hrat02
DEFINE  l_hraz28_desc     LIKE hrat_file.hrat02
DEFINE  l_hraa31          LIKE hraa_file.hraa02
DEFINE l_hrap01     LIKE hrap_file.hrap01,
       l_hrap05     LIKE hrap_file.hrap05
DEFINE l_ta_hraz01_n      LIKE hraz_file.ta_hraz01         
   IF s_shut(0) THEN
      RETURN
   END IF
   	
   DISPLAY BY NAME g_hraz_h.hraz04,g_hraz_h.hraz31,g_hraz_h.hraz08,g_hraz_h.hrazud02,g_hraz_h.hrazud03,
                   g_hraz_h.hraz10,g_hraz_h.hraz12,g_hraz_h.hraz14,
                   g_hraz_h.hraz34,g_hraz_h.hrazud06,g_hraz_h.hraz17,g_hraz_h.hraz19,
                   g_hraz_h.hraz05,g_hraz_h.hraz41,g_hraz_h.hraz16,
                   g_hraz_h.hraz39,g_hraz_h.hraz37,g_hraz_h.hraz18,
                   g_hraz_h.hraz23,g_hraz_h.hraz24,g_hraz_h.hraz27,
                   g_hraz_h.hraz28,g_hraz_h.hraz25,g_hraz_h.hraz26,
                   g_hraz_h.hraz44,g_hraz_h.hrazud01,g_hraz_h.ta_hraz01
   
            SELECT hraa02 INTO l_hraa31 FROM hraa_file 
         	  WHERE hraa01=g_hraz_h.hraz31
         	  DISPLAY l_hraa31 TO hraa31                        
   CALL cl_set_head_visible("","YES")
   INPUT BY NAME g_hraz_h.hraz04,g_hraz_h.hraz31,g_hraz_h.hraz08,g_hraz_h.hrazud02,g_hraz_h.hrazud03,
                 g_hraz_h.hraz10,g_hraz_h.hraz12,g_hraz_h.hraz14,
                 g_hraz_h.hraz34,g_hraz_h.hrazud06,g_hraz_h.hraz19,g_hraz_h.hraz05,
                 g_hraz_h.hraz41,g_hraz_h.hraz16,g_hraz_h.hraz39,g_hraz_h.ta_hraz01,
                 g_hraz_h.hraz17,g_hraz_h.hraz44,g_hraz_h.hrazud01
      WITHOUT DEFAULTS 
      
      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
         #mark by nihuan 20160902
#         IF cl_null(g_hraz_h.hraz34) THEN 
#            CALL cl_err('直接主管不能为空','!',1)
#            NEXT FIELD hraz34
#         END IF 
         IF p_cmd='u' THEN
         	  LET l_n=0
#         	  SELECT COUNT(*) INTO l_n FROM hraz_file 
#         	   WHERE hraz01=g_hraz_h.hraz01
#         	     AND hraz07=g_hraz_h.hraz08
#         	     AND hraz09=g_hraz_h.hraz10
#         	  IF l_n>0 THEN
#         	  	 CALL cl_err('变更前的部门职位与变更后相同','!',0)
#         	  	 NEXT FIELD hraz08
#         	  END IF
         END IF	  	 	 

      
      AFTER FIELD hraz31
         IF NOT cl_null(g_hraz_h.hraz31) THEN 
            LET l_num = 0        
            SELECT COUNT(*) INTO l_num FROM hraa_file WHERE hraa01 = g_hraz_h.hraz31
                                                        AND hraaacti='Y'
            IF l_num = 0 THEN 
               CALL cl_err('公司编号不存在','!',0)
               NEXT FIELD hraz31
            END IF 
            SELECT hraa12 INTO l_hraa12 FROM hraa_file WHERE hraa01= g_hraz_h.hraz31
                                                         AND hraaacti='Y' 
            DISPLAY l_hraa12 TO hraa12
            CALL cl_set_comp_entry("hraz08,hraz10",TRUE)
         ELSE
             CALL cl_set_comp_entry("hraz08,hraz10",FALSE)
         	  LET g_hraz_h.hraz08=''
         	  DISPLAY BY NAME g_hraz_h.hraz08   
         END IF
      
      #BEFORE FIELD hraz08
      #   IF NOT cl_null(g_hraz_h.hraz31) THEN
      #   	  CALL cl_set_comp_entry("hraz08",TRUE)
      #   ELSE
      #   	  CALL cl_set_comp_entry("hraz08",FALSE)
      #   END IF
         		  	  
      AFTER FIELD hraz08
         IF NOT cl_null(g_hraz_h.hraz08) THEN
            LET l_num = 0
            SELECT COUNT(*) INTO l_num FROM hrao_file WHERE hrao00 = g_hraz_h.hraz31
                                                        AND hrao01 = g_hraz_h.hraz08
                                                        AND hraoacti = 'Y'
            IF l_num = 0 THEN
               CALL cl_err('部门不存在或者不在所选公司下','!',0)
               NEXT FIELD hraz08
            END IF
            	 	
            SELECT hrao02 INTO l_hrao02 FROM hrao_file WHERE hrao01= g_hraz_h.hraz08
            DISPLAY l_hrao02 TO hrao02
            CALL cl_set_comp_entry("hraz10",TRUE)
         ELSE
            CALL cl_set_comp_entry("hraz10",FALSE)
         	  LET g_hraz_h.hraz10=''
         	  DISPLAY BY NAME g_hraz_h.hraz10   
         END IF
      
      #BEFORE FIELD hraz10
      #   IF NOT cl_null(g_hraz_h.hraz08) THEN
      #   	  CALL cl_set_comp_entry("hraz10",TRUE)
      #   ELSE
      #   	  CALL cl_set_comp_entry("hraz10",FALSE)
      #   END IF
      
      #员工属性
      AFTER FIELD hrazud06
        IF NOT cl_null(g_hraz_h.hrazud06) THEN
          LET l_n = 0
          SELECT COUNT(*) INTO l_n FROM hrag_file WHERE hrag01='313' AND hrag06=g_hraz_h.hrazud06
          IF l_n = 0 THEN
             CALL cl_err(g_hraz_h.hrazud06,'aap990',1)
             NEXT FIELD hrazud06
          END IF
          SELECT hrag07 INTO l_hrazud06_n FROM hrag_file WHERE hrag01='313' AND hrag06=g_hraz_h.hrazud06
          DISPLAY l_hrazud06_n TO hrazud06_desc
        END IF

      #课别
      AFTER FIELD hrazud02
         IF NOT cl_null(g_hraz_h.hrazud02) AND g_hraz_h.hrazud02!='-' THEN
            CALL i016_hrazud02('a')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_hraz_h.hrazud02,g_errno,0)
               NEXT FIELD hrazud02
            END IF
         END IF
#         #如果不能通过部门带出新直接主管则通过课别带出
#         #FUN-151112 wangjya
#         IF NOT cl_null(g_hraz_h.hrazud02) AND g_hraz_h.hrazud02!='-'  THEN
#             SELECT DISTINCT hrap01,hrap05 INTO l_hrap01,l_hrap05
#               FROM hrap_file LEFT OUTER JOIN hrat_file ON hrap01=hrat87
#              WHERE hrap07='Y'
#                AND hrap01 = g_hraz_h.hrazud02
#             IF NOT cl_null(l_hrap01) THEN
#                SELECT DISTINCT hrat01 INTO l_hrat01 FROM hrat_file
#                 WHERE hrat04=g_hraz_h.hraz08
#                   AND hrat87=g_hraz_h.hrazud02
#                   AND (hrat05=l_hrap05 OR HRAT07='Y')
#                   AND HRAT77>=SYSDATE
#                   AND hratconf='Y'
#
#             ELSE
#                #如果通过课别找不到就利用兼职课别来带出新直属主管
#                SELECT hrat01 INTO l_hrat01 FROM hrat_file LEFT OUTER JOIN hraw_file ON hratid=hraw01
#                 WHERE hraw08=g_hraz_h.hrazud02
#                   AND (hraw03=l_hrap05 OR HRAT07='Y')
#                   AND HRAT77>=SYSDATE
#                   AND hratconf='Y'
#             END IF
#             LET g_hraz_h.hraz34 =l_hrat01
#             DISPLAY BY NAME g_hraz_h.hraz34
#             IF NOT cl_null(g_hraz_h.hraz34) THEN
#            	  SELECT hrat02 INTO l_hraz34_desc FROM hrat_file
#            	   WHERE hrat01=g_hraz_h.hraz34
#                  AND hratconf='Y'
#            	  DISPLAY l_hraz34_desc TO hraz34_desc
#             END IF
#         END IF
         #FUN-151112 wangjya
      #组别
      AFTER FIELD hrazud03
         IF NOT cl_null(g_hraz_h.hrazud03) AND g_hraz_h.hrazud03!='-'  THEN
            CALL i016_hrazud03('a')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_hraz_h.hrazud03,g_errno,0)
               NEXT FIELD hrazud03
            END IF
         END IF
#         #如果不能通过部门课别带出新直接主管则通过组别带出
#         #FUN-151112 wangjya
#         IF NOT cl_null(g_hraz_h.hrazud03) AND g_hraz_h.hrazud03!='-'  THEN
#             SELECT DISTINCT hrap01,hrap05 INTO l_hrap01,l_hrap05
#               FROM hrap_file LEFT OUTER JOIN hrat_file ON hrap01=hrat88
#              WHERE hrap07='Y'
#                AND hrap01 = g_hraz_h.hrazud03
#             IF NOT cl_null(l_hrap01) THEN
#                SELECT DISTINCT hrat01 INTO l_hrat01 FROM hrat_file
#                 WHERE hrat04=g_hraz_h.hraz08
#                   AND hrat88=g_hraz_h.hrazud03
#                   AND (hrat05=l_hrap05 OR HRAT07='Y')
#                   AND HRAT77>=SYSDATE
#                   AND hratconf='Y'
#             ELSE
#                #如果通过组织找不到就利用兼职组织来带出新直属主管
#                SELECT hrat01 INTO l_hrat01 FROM hrat_file LEFT OUTER JOIN hraw_file ON hratid=hraw01
#                 WHERE hraw09=g_hraz_h.hrazud03
#                   AND (hraw03=l_hrap05 OR HRAT07='Y')
#                   AND HRAT77>=SYSDATE
#                   AND hratconf='Y'
#             END IF
#             LET g_hraz_h.hraz34 =l_hrat01
#             DISPLAY BY NAME g_hraz_h.hraz34
#             IF NOT cl_null(g_hraz_h.hraz34) THEN
#            	  SELECT hrat02 INTO l_hraz34_desc FROM hrat_file
#            	   WHERE hrat01=g_hraz_h.hraz34
#                  AND hratconf='Y'
#            	  DISPLAY l_hraz34_desc TO hraz34_desc
#             END IF
#         END IF
      AFTER FIELD ta_hraz01
        IF NOT cl_null(g_hraz_h.ta_hraz01) THEN
           SELECT COUNT(*) INTO l_n FROM hrar_file WHERE hrar03 = g_hraz_h.ta_hraz01
           IF l_n = 0 THEN 
              CALL cl_err(g_hraz_h.ta_hraz01,'ghr-295',1)
              NEXT FIELD ta_hraz01
           END IF 
           SELECT hrar04 INTO l_ta_hraz01_n FROM hrar_file WHERE hrar03 = g_hraz_h.ta_hraz01
          DISPLAY l_ta_hraz01_n TO ta_hraz01_n
        END IF              	
      AFTER FIELD hraz10
         IF NOT cl_null(g_hraz_h.hraz10) THEN
         	  LET l_num = 0
         	  IF NOT cl_null(g_hraz_h.hrazud03) THEN 
            SELECT COUNT(*) INTO l_num FROM hrap_file WHERE hrap01 = g_hraz_h.hrazud03
                                                        AND hrap05 = g_hraz_h.hraz10
                                                        AND hrapacti = 'Y'
            ELSE 
            IF NOT cl_null(g_hraz_h.hrazud02) THEN 
            SELECT COUNT(*) INTO l_num FROM hrap_file WHERE hrap01 = g_hraz_h.hrazud02
                                                        AND hrap05 = g_hraz_h.hraz10
                                                        AND hrapacti = 'Y' 
            ELSE 
            IF NOT cl_null(g_hraz_h.hraz08) THEN 
            SELECT COUNT(*) INTO l_num FROM hrap_file WHERE hrap01 = g_hraz_h.hraz08
                                                        AND hrap05 = g_hraz_h.hraz10
                                                        AND hrapacti = 'Y' 
                 END IF 
              END IF                                           
            END IF                                             
            IF l_num = 0 THEN
               CALL cl_err('此职位尚未配置在所选部门','!',0)
               NEXT FIELD hraz10
            END IF
            	
            SELECT hras04,hras06 INTO l_hras04,g_hraz_h.hraz41 
              FROM hras_file
             WHERE hras01=g_hraz_h.hraz10
            DISPLAY BY NAME g_hraz_h.hraz41
            DISPLAY l_hras04 TO hras04
         END IF
       
#      BEFORE FIELD hraz12 
#         IF cl_null(g_hraz_h.hraz12) THEN 
#            LET g_hraz_h.hraz12='01'
#            SELECT hrai04 INTO l_hrai04 FROM hrai_file 
#         	   WHERE hrai03=g_hraz_h.hraz12
#         	  DISPLAY BY NAME g_hraz_h.hraz12
#         	  DISPLAY l_hrai04 TO hrai04
#         END IF 
         	
      AFTER FIELD hraz12
         IF NOT cl_null(g_hraz_h.hraz12) THEN
         	  LET l_num = 0
         	  SELECT COUNT(*) INTO l_num FROM hrai_file 
         	   WHERE hrai03=g_hraz_h.hraz12
         	     AND hraiacti='Y'
         	  IF l_num=0 THEN
         	  	 CALL cl_err("无此成本中心","!",0)
         	  	 NEXT FIELD hraz12
         	  END IF
         	  	
         	  SELECT hrai04 INTO l_hrai04 FROM hrai_file 
         	   WHERE hrai03=g_hraz_h.hraz12
         	  DISPLAY l_hrai04 TO hrai04
         END IF
         	
      AFTER FIELD hraz14
         IF NOT cl_null(g_hraz_h.hraz14) THEN
         	  LET l_num = 0
         	  SELECT COUNT(*) INTO l_num FROM hraf_file 
         	   WHERE hraf01=g_hraz_h.hraz14
         	     #AND hrafacti='Y'
         	  IF l_num=0 THEN
         	  	 CALL cl_err("无此区域","!",0)
         	  	 NEXT FIELD hraz14
         	  END IF
         	  	
         	  SELECT hraf02 INTO l_hraf02 FROM hraf_file 
         	   WHERE hraf01=g_hraz_h.hraz14
         	  DISPLAY l_hraf02 TO hraf02
         END IF

      BEFORE FIELD hraz34
     #add by nihuan 20161114 for zhijie zhu guan ------------start---------------------
     IF NOT cl_null(g_hraz_h.hraz08) THEN                               #5
     IF NOT cl_null(g_hraz_h.hrazud03) THEN                              #4
           SELECT DISTINCT hrap01,hrap05 INTO l_hrap01,l_hrap05
            FROM hrap_file LEFT OUTER JOIN hrat_file ON hrap01=hrat88
           WHERE hrap07='Y'
             AND hrap01 = g_hraz_h.hrazud03
          IF NOT cl_null(l_hrap01) THEN
             SELECT DISTINCT hrat01 INTO g_hraz_h.hraz34 FROM hrat_file
              WHERE hrat04=g_hraz_h.hraz08
                AND hrat88=g_hraz_h.hrazud03
                AND (hrat05=l_hrap05 OR HRAT07='Y')
                AND HRAT77>=SYSDATE
                AND hratconf='Y'
           END IF
             IF cl_null(g_hraz_h.hraz34) THEN
                #如果通过组织找不到就利用兼职组织来带出新直属主管
                SELECT hrat01 INTO g_hraz_h.hraz34 FROM hrat_file LEFT OUTER JOIN hraw_file ON hratid=hraw01
                 WHERE hraw09=g_hraz_h.hrazud03
                   AND (hraw03=l_hrap05 OR HRAT07='Y')
                   AND HRAT77>=SYSDATE
                   AND hratconf='Y'     
             END IF
          IF cl_null(g_hraz_h.hraz34) THEN
             IF NOT cl_null(g_hraz_h.hrazud02) THEN                              
                SELECT DISTINCT hrap01,hrap05 INTO l_hrap01,l_hrap05
                 FROM hrap_file LEFT OUTER JOIN hrat_file ON hrap01=hrat87
                WHERE hrap07='Y'
                  AND hrap01 = g_hraz_h.hrazud02
               IF NOT cl_null(l_hrap01) THEN
                  SELECT DISTINCT hrat01 INTO g_hraz_h.hraz34 FROM hrat_file
                   WHERE hrat04=g_hraz_h.hraz08
                     AND hrat87=g_hraz_h.hrazud02
                     AND (hrat05=l_hrap05 OR HRAT07='Y')
                     AND HRAT77>=SYSDATE
                     AND hratconf='Y'
                END IF
               IF cl_null(g_hraz_h.hraz34) THEN
                  #如果通过组织找不到就利用兼职组织来带出新直属主管
                  SELECT hrat01 INTO g_hraz_h.hraz34 FROM hrat_file LEFT OUTER JOIN hraw_file ON hratid=hraw01
                   WHERE hraw09=g_hraz_h.hrazud02
                     AND (hraw03=l_hrap05 OR HRAT07='Y')
                     AND HRAT77>=SYSDATE
                     AND hratconf='Y'
               END IF
              END IF      
          END IF  
          IF cl_null(g_hraz_h.hraz34) THEN
         	  IF NOT cl_null(g_hraz_h.hraz08) THEN                    #2
                 SELECT DISTINCT hrap01,hrap05 INTO l_hrap01,l_hrap05
                   FROM hrap_file LEFT OUTER JOIN hrat_file ON hrap01=hrat04
                   WHERE hrap07='Y'
                   AND hrap01 = g_hraz_h.hraz08
                  IF NOT cl_null(l_hrap01) THEN                      #1
                    SELECT DISTINCT hrat01 INTO g_hraz_h.hraz34 FROM hrat_file
                     WHERE hrat04=g_hraz_h.hraz08
                       AND (hrat05=l_hrap05 OR HRAT07='Y')
                       AND HRAT77>=SYSDATE
                       AND hratconf='Y'
                  END IF                                              #1
                 IF cl_null(g_hraz_h.hraz34) THEN                            #1
                    #如果通过组织找不到就利用兼职组织来带出新直属主管
                   SELECT hrat01 INTO g_hraz_h.hraz34 FROM hrat_file LEFT OUTER JOIN hraw_file ON hratid=hraw01
                    WHERE hraw09=g_hraz_h.hraz08
                     AND (hraw03=l_hrap05 OR HRAT07='Y')
                     AND HRAT77>=SYSDATE
                     AND hratconf='Y'
                 END IF                                               #1
              END IF  
          END IF                
     ELSE 
        IF NOT cl_null(g_hraz_h.hrazud02) THEN                              #3
           SELECT DISTINCT hrap01,hrap05 INTO l_hrap01,l_hrap05
            FROM hrap_file LEFT OUTER JOIN hrat_file ON hrap01=hrat87
           WHERE hrap07='Y'
             AND hrap01 = g_hraz_h.hrazud02
          IF NOT cl_null(l_hrap01) THEN
             SELECT DISTINCT hrat01 INTO g_hraz_h.hraz34 FROM hrat_file
              WHERE hrat04=g_hraz_h.hraz08
                AND hrat87=g_hraz_h.hrazud02
                AND (hrat05=l_hrap05 OR HRAT07='Y')
                AND HRAT77>=SYSDATE
                AND hratconf='Y'
           END IF
             IF cl_null(g_hraz_h.hraz34) THEN
                #如果通过组织找不到就利用兼职组织来带出新直属主管
                SELECT hrat01 INTO g_hraz_h.hraz34 FROM hrat_file LEFT OUTER JOIN hraw_file ON hratid=hraw01
                 WHERE hraw09=g_hraz_h.hrazud02
                   AND (hraw03=l_hrap05 OR HRAT07='Y')
                   AND HRAT77>=SYSDATE
                   AND hratconf='Y'
             END IF
           ELSE 
              IF NOT cl_null(g_hraz_h.hraz08) THEN                    #2
                 SELECT DISTINCT hrap01,hrap05 INTO l_hrap01,l_hrap05
                   FROM hrap_file LEFT OUTER JOIN hrat_file ON hrap01=hrat04
                   WHERE hrap07='Y'
                   AND hrap01 = g_hraz_h.hraz08
                  IF NOT cl_null(l_hrap01) THEN                      #1
                    SELECT DISTINCT hrat01 INTO g_hraz_h.hraz34 FROM hrat_file
                     WHERE hrat04=g_hraz_h.hraz08
                       AND (hrat05=l_hrap05 OR HRAT07='Y')
                       AND HRAT77>=SYSDATE
                       AND hratconf='Y'
                  END IF                                              #1
                 IF cl_null(g_hraz_h.hraz34) THEN                            #1
                    #如果通过组织找不到就利用兼职组织来带出新直属主管
                   SELECT hrat01 INTO g_hraz_h.hraz34 FROM hrat_file LEFT OUTER JOIN hraw_file ON hratid=hraw01
                    WHERE hraw09=g_hraz_h.hraz08
                     AND (hraw03=l_hrap05 OR HRAT07='Y')
                     AND HRAT77>=SYSDATE
                     AND hratconf='Y'
                 END IF                                               #1
              END IF                                                  #2           
        END IF                                                        #3
     END IF                                                            #4
     END IF                                                           #5
       IF NOT cl_null(g_hraz_h.hraz34) THEN 
             SELECT hrat02 INTO l_hraz34_desc FROM hrat_file 
         	   WHERE hrat01=g_hraz_h.hraz34
               AND hratconf='Y'        	     
         	  DISPLAY l_hraz34_desc,g_hraz_h.hraz34 TO hraz34_desc,hraz34
       END IF 
     #add by nihuan 20161114 for zhijie zhu guan ------------end-----------------------         
               	
      AFTER FIELD hraz34
         IF NOT cl_null(g_hraz_h.hraz34) THEN
         	  LET l_num = 0
         	  SELECT COUNT(*) INTO l_num FROM hrat_file 
         	   WHERE hrat01=g_hraz_h.hraz34
         	     AND hratconf='Y'
         	  IF l_num=0 THEN
         	  	 CALL cl_err("无此员工","!",0)
         	  	 NEXT FIELD hraz34
         	  END IF
         	  	
         	  SELECT hrat02 INTO l_hraz34_desc FROM hrat_file 
         	   WHERE hrat01=g_hraz_h.hraz34
               AND hratconf='Y'        	     
         	  DISPLAY l_hraz34_desc TO hraz34_desc
         END IF
         	   	   		      	 	     	    	  		  	     	
      ON ACTION CONTROLZ
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(hraz31)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_hraa01"
               LET g_qryparam.default1 = g_hraz_h.hraz31
               CALL cl_create_qry() RETURNING g_hraz_h.hraz31 
               DISPLAY BY NAME g_hraz_h.hraz31 
               NEXT FIELD hraz31
               
            WHEN INFIELD(hrazud06)
              CALL cl_init_qry_var()
              LET g_qryparam.arg1 = '313'
              LET g_qryparam.form = "q_hrag06"
              LET g_qryparam.construct = 'N'
              LET g_qryparam.default1 = g_hraz_h.hrazud06
              CALL cl_create_qry() RETURNING g_hraz_h.hrazud06
              DISPLAY BY NAME g_hraz_h.hrazud06
              NEXT FIELD hrazud06
              
            WHEN INFIELD(hraz08)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_hrao01"
               LET g_qryparam.default1 = g_hraz_h.hraz08
               LET g_qryparam.arg1 =g_hraz_h.hraz31
               CALL cl_create_qry() RETURNING g_hraz_h.hraz08 
               DISPLAY BY NAME g_hraz_h.hraz08 
               NEXT FIELD hraz08
            WHEN INFIELD(ta_hraz01)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_hrar03_zw"
               LET g_qryparam.default1 = g_hraz_h.hraz08
               LET g_qryparam.arg1 =g_hraz_h.hraz31
               CALL cl_create_qry() RETURNING g_hraz_h.ta_hraz01 
               DISPLAY BY NAME g_hraz_h.ta_hraz01 
               NEXT FIELD ta_hraz01               
            WHEN INFIELD(hraz08)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_hrao01"
               LET g_qryparam.default1 = g_hraz_h.hraz08
               LET g_qryparam.arg1 =g_hraz_h.hraz31
               CALL cl_create_qry() RETURNING g_hraz_h.hraz08 
               DISPLAY BY NAME g_hraz_h.hraz08 
               NEXT FIELD hraz08
                        WHEN INFIELD(hrazud02)
            {
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_hrao01"
               LET g_qryparam.default1 = g_hraz_h.hrazud02
               LET g_qryparam.arg1 =g_hraz_h.hraz31
               CALL cl_create_qry() RETURNING g_hraz_h.hrazud02
               DISPLAY BY NAME g_hraz_h.hrazud02
               NEXT FIELD hrazud02}
             CALL cl_init_qry_var()
              IF NOT cl_null(g_hraz_h.hraz31) AND g_hraz_h.hraz31!='-' THEN
                 CASE
                   WHEN NOT cl_null(g_hraz_h.hraz08) AND g_hraz_h.hraz08!='-'
                     LET g_qryparam.form = "cq_hrao01_0"
                     LET g_qryparam.arg1 = g_hraz_h.hraz31
                     LET g_qryparam.arg2 = '2'
                     LET g_qryparam.arg3 = g_hraz_h.hraz08
                    WHEN cl_null(g_hraz_h.hraz08) OR g_hraz_h.hraz08='-'
                     LET g_qryparam.arg1 = g_hraz_h.hraz31
                     LET g_qryparam.arg2 = '2'
                     LET g_qryparam.form = "cq_hrao01_0_1"
                 END CASE
              ELSE
                LET g_qryparam.form = "cq_hrao01_1_1"
                LET g_qryparam.arg2 = '2'
              END IF
              LET g_qryparam.default1 = g_hraz_h.hrazud02
              CALL cl_create_qry() RETURNING g_hraz_h.hrazud02
              DISPLAY BY NAME g_hraz_h.hrazud02
              NEXT FIELD hrazud02
           { CALL cl_init_qry_var()
              IF NOT cl_null(g_hraz_h.hrazud02) THEN
                IF NOT cl_null(g_hraz_h.hraz08) THEN
                  LET g_qryparam.arg1 = g_hraz_h.hraz31
                  LET g_qryparam.arg2 = '2'
                  LET g_qryparam.arg3 = g_hraz_h.hraz08
                  LET g_qryparam.form = "cq_hrao01_0"
                ELSE
                  LET g_qryparam.arg1 = g_hraz_h.hraz31
                  LET g_qryparam.arg2 = '2'
                  LET g_qryparam.form = "cq_hrao01_0_1"
                END IF
              ELSE
                IF NOT cl_null(g_hraz_h.hraz08) THEN
                  LET g_qryparam.arg1 = g_hraz_h.hraz31
                  LET g_qryparam.arg2 = '2'
                  LET g_qryparam.arg3 = g_hraz_h.hraz08
                  LET g_qryparam.form = "cq_hrao01_1"
                ELSE
                  LET g_qryparam.arg1 = g_hraz_h.hraz31
                  LET g_qryparam.arg2 = '2'
                  LET g_qryparam.form = "cq_hrao01_1_1"

                 END IF
              END IF

              LET g_qryparam.default1 = g_hraz_h.hrazud02
              CALL cl_create_qry() RETURNING g_hraz_h.hrazud02
              DISPLAY BY NAME g_hraz_h.hrazud02
              NEXT FIELD hrazud02}

              #############################################3
            WHEN INFIELD(hrazud03)

             CALL cl_init_qry_var()
              IF NOT cl_null(g_hraz_h.hraz31) AND g_hraz_h.hraz31!='-' THEN
                 CASE
                   WHEN NOT cl_null(g_hraz_h.hrazud02) AND g_hraz_h.hrazud02!='-'
                     LET g_qryparam.form = "cq_hrao01_0"
                     LET g_qryparam.arg1 = g_hraz_h.hraz31
                     LET g_qryparam.arg2 = '3'
                     LET g_qryparam.arg3 = g_hraz_h.hrazud02
                   WHEN NOT cl_null(g_hraz_h.hraz08) AND g_hraz_h.hraz08!='-'
                     LET g_qryparam.form = "cq_hrao01_0"
                     LET g_qryparam.arg1 = g_hraz_h.hraz31
                     LET g_qryparam.arg2 = '3'
                     LET g_qryparam.arg3 = g_hraz_h.hraz08
                    WHEN cl_null(g_hraz_h.hraz08) OR g_hraz_h.hraz08='-'
                     LET g_qryparam.arg1 = g_hraz_h.hraz31
                     LET g_qryparam.arg2 = '3'
                     LET g_qryparam.form = "cq_hrao01_0_1"
                 END CASE
              ELSE
                LET g_qryparam.form = "cq_hrao01_1_1"
                LET g_qryparam.arg2 = '3'
              END IF
              LET g_qryparam.default1 = g_hraz_h.hrazud03
              CALL cl_create_qry() RETURNING g_hraz_h.hrazud03
              DISPLAY BY NAME g_hraz_h.hrazud03
              NEXT FIELD hrazud03   
#            WHEN INFIELD(hraz10)
#               CALL cl_init_qry_var()
#               LET g_qryparam.form ="q_hrap01"
#               LET g_qryparam.default1 = g_hraz_h.hraz10
#               LET g_qryparam.arg1 =g_hraz_h.hraz08
#               CALL cl_create_qry() RETURNING g_hraz_h.hraz10 
#               DISPLAY BY NAME g_hraz_h.hraz10
#               NEXT FIELD hraz10
#               
            WHEN INFIELD(hraz10)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_hrap01"
               LET g_qryparam.default1 = g_hraz_h.hraz10
              IF NOT cl_null(g_hraz_h.hrazud03) AND g_hraz_h.hrazud03 != '-' THEN
                LET g_qryparam.arg1 = g_hraz_h.hrazud03
              ELSE
                IF NOT cl_null(g_hraz_h.hrazud02) AND g_hraz_h.hrazud02 != '-' THEN
                  LET g_qryparam.arg1 = g_hraz_h.hrazud02
                ELSE
                  LET g_qryparam.arg1 =g_hraz_h.hraz08
                END IF
              END IF
               CALL cl_create_qry() RETURNING g_hraz_h.hraz10
               DISPLAY BY NAME g_hraz_h.hraz10
               NEXT FIELD hraz10
               
            WHEN INFIELD(hraz08)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_hrao01"
               LET g_qryparam.default1 = g_hraz_h.hraz08
               LET g_qryparam.arg1 =g_hraz_h.hraz31
               CALL cl_create_qry() RETURNING g_hraz_h.hraz08 
               DISPLAY BY NAME g_hraz_h.hraz08 
               NEXT FIELD hraz08
               
            WHEN INFIELD(hraz12)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_hrai03"
               LET g_qryparam.default1 = g_hraz_h.hraz12
               CALL cl_create_qry() RETURNING g_hraz_h.hraz12 
               DISPLAY BY NAME g_hraz_h.hraz12
               NEXT FIELD hraz12
               
            WHEN INFIELD(hraz14)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_hraf01"
               LET g_qryparam.default1 = g_hraz_h.hraz14
               CALL cl_create_qry() RETURNING g_hraz_h.hraz14 
               DISPLAY BY NAME g_hraz_h.hraz14
               NEXT FIELD hraz14
               
            WHEN INFIELD(hraz34)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_hrat01"
               LET g_qryparam.default1 = g_hraz_h.hraz34
               CALL cl_create_qry() RETURNING g_hraz_h.hraz34 
               DISPLAY BY NAME g_hraz_h.hraz34
               NEXT FIELD hraz34
                     
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
	
FUNCTION i016_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_hraz.clear()
   DISPLAY ' ' TO FORMONLY.cnt
   CALL i016_cs()
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_hraz_h.* TO NULL
      RETURN
   END IF
   OPEN i016_cs      
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_hraz_h.* TO NULL
   ELSE
      OPEN i016_count
      FETCH i016_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL i016_fetch('F') 
      CALL i016_hraz_fill()            
   END IF
END FUNCTION
 
FUNCTION i016_fetch(p_flag)
DEFINE  p_flag     LIKE type_file.chr1 
    
   CASE p_flag
      WHEN 'N' FETCH NEXT     i016_cs INTO g_hraz_h.hraz01
      WHEN 'P' FETCH PREVIOUS i016_cs INTO g_hraz_h.hraz01 
      WHEN 'F' FETCH FIRST    i016_cs INTO g_hraz_h.hraz01
      WHEN 'L' FETCH LAST     i016_cs INTO g_hraz_h.hraz01
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
      FETCH ABSOLUTE g_jump i016_cs INTO g_hraz_h.hraz01
      LET g_no_ask = FALSE 
   END CASE
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_hraz_h.hraz01,SQLCA.sqlcode,0)
      INITIALIZE g_hraz_h.* TO NULL     
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
   	
   SELECT DISTINCT hraz04,hraz19,hraz05,hraz31,hraz08,hrazud02,hrazud03,hraz10,hraz41,
                   hraz12,hraz14,hraz16,hraz34,hraz39,hraz37,hraz17,
                   hraz18,hraz23,hraz24,hraz27,hraz28,hraz25,hraz26,hraz44,hrazud01,hrazud06,
                   hrazuser,hrazgrup,hrazmodu,hrazdate,hrazoriu,hrazorig,ta_hraz01 
    INTO g_hraz_h.hraz04,g_hraz_h.hraz19,g_hraz_h.hraz05,g_hraz_h.hraz31,
         g_hraz_h.hraz08,g_hraz_h.hrazud02,g_hraz_h.hrazud03,g_hraz_h.hraz10,g_hraz_h.hraz41,g_hraz_h.hraz12,
         g_hraz_h.hraz14,g_hraz_h.hraz16,g_hraz_h.hraz34,g_hraz_h.hraz39,
         g_hraz_h.hraz37,g_hraz_h.hraz17,g_hraz_h.hraz18,g_hraz_h.hraz23,
         g_hraz_h.hraz24,g_hraz_h.hraz27,g_hraz_h.hraz28,g_hraz_h.hraz25,
         g_hraz_h.hraz26,g_hraz_h.hraz44,g_hraz_h.hrazud01,g_hraz_h.hrazud06,
         g_hraz_h.hrazuser,g_hraz_h.hrazgrup,g_hraz_h.hrazmodu,g_hraz_h.hrazdate,g_hraz_h.hrazoriu,g_hraz_h.hrazorig,g_hraz_h.ta_hraz01               
    FROM hraz_file 
   WHERE hraz01=g_hraz_h.hraz01
    
    CALL i016_show()               
   
END FUNCTION
	
FUNCTION i016_show()                      
DEFINE  l_hraa12          LIKE hraa_file.hraa12
DEFINE  l_hrao02          LIKE hrao_file.hrao02
DEFINE  l_hras04          LIKE hras_file.hras04
DEFINE  l_hrai04          LIKE hrai_file.hrai04
DEFINE  l_hraf02          LIKE hraf_file.hraf02
DEFINE  l_hraz34_desc     LIKE hrat_file.hrat02
DEFINE  l_hraz24_desc     LIKE hrat_file.hrat02
DEFINE  l_hraz26_desc     LIKE hrat_file.hrat02
DEFINE  l_hraz28_desc     LIKE hrat_file.hrat02
DEFINE  l_hrao02_1        LIKE hrao_file.hrao02,
        l_hrao02_2        LIKE hrao_file.hrao02,
        l_hrazud06_desc   LIKE hrag_file.hrag07
DEFINE l_ta_hraz01_n      LIKE hraz_file.ta_hraz01
   LET g_hraz_h_t.*=g_hraz_h.*
   
   SELECT hrat01 INTO g_hraz_h.hraz34 FROM hrat_file WHERE hratid=g_hraz_h.hraz34
   #SELECT hrat01 INTO g_hraz_h.hraz24 FROM hrat_file WHERE hratid=g_hraz_h.hraz24
   #SELECT hrat01 INTO g_hraz_h.hraz26 FROM hrat_file WHERE hratid=g_hraz_h.hraz26
   #SELECT hrat01 INTO g_hraz_h.hraz28 FROM hrat_file WHERE hratid=g_hraz_h.hraz28
   
   DISPLAY BY NAME g_hraz_h.hraz04,g_hraz_h.hraz19,g_hraz_h.hraz05,g_hraz_h.hraz31,
                   g_hraz_h.hraz08,g_hraz_h.hrazud02,g_hraz_h.hrazud03,g_hraz_h.hraz10,g_hraz_h.hraz41,g_hraz_h.hraz12,
                   g_hraz_h.hraz14,g_hraz_h.hraz16,g_hraz_h.hraz34,g_hraz_h.hraz39,
                   g_hraz_h.hraz37,g_hraz_h.hraz17,g_hraz_h.hraz18,g_hraz_h.hraz23,
                   g_hraz_h.hraz24,g_hraz_h.hraz27,g_hraz_h.hraz28,g_hraz_h.hraz25,
                   g_hraz_h.hraz26,g_hraz_h.hraz44,g_hraz_h.hrazud01,g_hraz_h.hrazud06,g_hraz_h.ta_hraz01,
                   g_hraz_h.hrazuser,g_hraz_h.hrazgrup,g_hraz_h.hrazmodu,g_hraz_h.hrazdate,g_hraz_h.hrazoriu,g_hraz_h.hrazorig  
   
   
   SELECT hraa12 INTO l_hraa12 FROM hraa_file WHERE hraa01=g_hraz_h.hraz31
   SELECT hrao02 INTO l_hrao02 FROM hrao_file WHERE hrao01=g_hraz_h.hraz08
   SELECT hrao02 INTO l_hrao02_1 FROM hrao_file WHERE hrao01=g_hraz_h.hrazud02
   SELECT hrao02 INTO l_hrao02_2 FROM hrao_file WHERE hrao01=g_hraz_h.hrazud03
   SELECT hras04 INTO l_hras04 FROM hras_file WHERE hras01=g_hraz_h.hraz10
   SELECT hrai04 INTO l_hrai04 FROM hrai_file WHERE hrai03=g_hraz_h.hraz12
   SELECT hraf02 INTO l_hraf02 FROM hraf_file WHERE hraf01=g_hraz_h.hraz14
   SELECT zx02 INTO l_hraz34_desc FROM zx_file WHERE zx01=g_hraz_h.hraz34
   SELECT zx02 INTO l_hraz24_desc FROM zx_file WHERE zx01=g_hraz_h.hraz24
   SELECT zx02 INTO l_hraz26_desc FROM zx_file WHERE zx01=g_hraz_h.hraz26
   SELECT zx02 INTO l_hraz28_desc FROM zx_file WHERE zx01=g_hraz_h.hraz28
   SELECT hrag07 INTO l_hrazud06_desc FROM hrag_file WHERE hrag06=g_hraz_h.hrazud06 AND hrag01='313'
   SELECT hrar04 INTO l_ta_hraz01_n FROM hrar_file WHERE hrar03 = g_hraz_h.ta_hraz01
   DISPLAY l_ta_hraz01_n TO ta_hraz01_n
   DISPLAY l_hrazud06_desc TO hrazud06_desc
   DISPLAY l_hraa12 TO hraa12
   DISPLAY l_hrao02 TO hrao02
   DISPLAY l_hrao02_1 TO hrao02_1
   DISPLAY l_hrao02_2 TO hrao02_2
   DISPLAY l_hras04 TO hras04
   DISPLAY l_hrai04 TO hrai04
   DISPLAY l_hraf02 TO hraf02
   DISPLAY l_hraz34_desc TO hraz34_desc
   DISPLAY l_hraz24_desc TO hraz24_desc
   DISPLAY l_hraz26_desc TO hraz26_desc
   DISPLAY l_hraz28_desc TO hraz28_desc
   
   CALL i016_b_fill(g_wc2)                
   CALL cl_show_fld_cont()                   
END FUNCTION	
	
FUNCTION i016_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                 
    l_n             LIKE type_file.num5,                 
    l_lock_sw       LIKE type_file.chr1,                 
    p_cmd           LIKE type_file.chr1,                 
    l_allow_insert  LIKE type_file.chr1,                 
    l_allow_delete  LIKE type_file.chr1
DEFINE l_hraz03     LIKE hraz_file.hraz03
DEFINE l_hraz33     LIKE hraz_file.hraz33
DEFINE l_hraz34     LIKE hraz_file.hraz34
DEFINE l_year       STRING
DEFINE l_month      STRING 
DEFINE l_day        STRING	
DEFINE l_no         LIKE type_file.chr10
DEFINE l_sql        STRING
DEFINE l_hraz01     LIKE  hraz_file.hraz01      
   
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    	
    IF g_hraz_h.hraz04 IS NULL THEN
    	 CALL cl_err('',-400,0)      
         RETURN
    END IF

    IF g_hraz_h.hraz18='003' OR g_hraz_h.hraz18='004' THEN
       CALL cl_err('资料已审核或者已归档,不可更改','!',0)
       RETURN
    END IF
    		 	
    CALL cl_opmsg('b')
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    LET g_forupd_sql = "SELECT hraz43,hraz32,'',hraz30,'',hraz07,'',hrazud04,'',hrazud05,'',hrazud07,'',hraz09,'',",
                       "       hraz40,hraz33,'',hraz13,'',hraz15,hraz11,'',hraz38,ta_hraz02,'' ",  
                       "  FROM hraz_file WHERE hraz01=? AND hraz43=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i016_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
    
    #WHILE TRUE 
       INPUT ARRAY g_hraz WITHOUT DEFAULTS FROM s_hraz.*
             ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert) 
 
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
#No.FUN-570110 --start                                                          
             LET g_before_input_done = FALSE                                                                              
             LET g_before_input_done = TRUE                                       
#No.FUN-570110 --end              
             LET g_hraz_t.* = g_hraz[l_ac].*  #BACKUP
             OPEN i016_bcl USING g_hraz_h.hraz01,g_hraz_t.hraz43
             IF STATUS THEN
                CALL cl_err("OPEN i016_bcl:", STATUS, 1)
                LET l_lock_sw = "Y"
             ELSE 
                FETCH i016_bcl INTO g_hraz[l_ac].* 
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_hraz_t.hraz43,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                END IF
                
                SELECT hrat02 INTO g_hraz[l_ac].hrat02 FROM hrat_file 
                 WHERE hrat01=g_hraz[l_ac].hraz43
                SELECT hraa12 INTO g_hraz[l_ac].hraz30_desc FROM hraa_file
                 WHERE hraa01=g_hraz[l_ac].hraz30
                SELECT hrao02 INTO g_hraz[l_ac].hraz07_desc FROM hrao_file
                 WHERE hrao01=g_hraz[l_ac].hraz07
                 
                  #组别
                 SELECT hrao02 INTO g_hraz[l_ac].hrazud04_desc FROM hrao_file
                 WHERE hrao01=g_hraz[l_ac].hrazud04
                 IF cl_null(g_hraz[l_ac].hrazud04) THEN
                    LET g_hraz[l_ac].hrazud04=NULL
                 END IF
                 
                 SELECT hrag07 INTO g_hraz[l_ac].hrazud07_desc FROM hrag_file 
                 WHERE hrag06=g_hraz[l_ac].hrazud07 AND hrag01='313'
                 #组别
                 SELECT hrao02 INTO g_hraz[l_ac].hrazud05_desc FROM hrao_file
                 WHERE hrao01=g_hraz[l_ac].hrazud05
                 IF cl_null(g_hraz[l_ac].hrazud05) THEN
                    LET g_hraz[l_ac].hrazud05_desc=NULL
                 END IF
                SELECT hrar04 INTO g_hraz[l_ac].ta_hraz02_n FROM hrar_file WHERE hrar03 = g_hraz[l_ac].ta_hraz02 
                SELECT hras04 INTO g_hraz[l_ac].hraz09_desc FROM hras_file
                 WHERE hras01=g_hraz[l_ac].hraz09
                SELECT hrat01 INTO g_hraz[l_ac].hraz33 FROM hrat_file
                 WHERE hratid=g_hraz[l_ac].hraz33 
                SELECT hrat02 INTO g_hraz[l_ac].hraz33_desc FROM hrat_file
                 WHERE hrat01=g_hraz[l_ac].hraz33 
                SELECT hraf02 INTO g_hraz[l_ac].hraz13_desc FROM hraf_file
                 WHERE hraf01=g_hraz[l_ac].hraz13
                SELECT hrai04 INTO g_hraz[l_ac].hraz11_desc FROM hrai_file
                 WHERE hrai03=g_hraz[l_ac].hraz11       	
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

           

           INITIALIZE g_hraz[l_ac].* TO NULL      #900423  
           LET g_hraz_t.* = g_hraz[l_ac].*         
           CALL cl_show_fld_cont()     #FUN-550037(smin)
           NEXT FIELD hraz43 
         
       AFTER INSERT
           DISPLAY "AFTER INSERT" 
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CLOSE i016_bcl
              CANCEL INSERT
           END IF
 
           BEGIN WORK                    #FUN-680010  
           
           IF cl_null(g_hraz_h.hraz01) THEN
           	  LET l_year=YEAR(g_today) USING "&&&&"
              LET l_month=MONTH(g_today) USING "&&"
              LET l_day=DAY(g_today) USING "&&"
              LET l_year=l_year.trim()
              LET l_month=l_month.trim()
              LET l_day=l_day.trim()
              LET g_hraz_h.hraz01=l_year CLIPPED,l_month CLIPPED,l_day CLIPPED
              LET l_hraz01=g_hraz_h.hraz01,"%"
              LET l_sql="SELECT MAX(hraz01) FROM hraz_file",
                        " WHERE hraz01 LIKE '",l_hraz01,"'"
              PREPARE i016_hraz01 FROM l_sql
              EXECUTE i016_hraz01 INTO g_hraz_h.hraz01
              IF cl_null(g_hraz_h.hraz01) THEN 
                 LET g_hraz_h.hraz01=l_hraz01[1,8],'0001'
              ELSE
                 LET l_no=g_hraz_h.hraz01[9,12]
                 LET l_no=l_no+1 USING "&&&&"
                 LET g_hraz_h.hraz01=l_hraz01[1,8],l_no
              END IF
           END IF	         	  
           
           SELECT hratid INTO l_hraz03 FROM hrat_file WHERE hrat01=g_hraz[l_ac].hraz43 
           SELECT hratid INTO l_hraz34 FROM hrat_file WHERE hrat01=g_hraz_h.hraz34
           SELECT hratid INTO l_hraz33 FROM hrat_file WHERE hrat01=g_hraz[l_ac].hraz33
 
           INSERT INTO hraz_file(hraz03,hraz01,hraz04,hraz19,hraz05,hraz31,hraz08,hrazud02,hrazud03,hrazud06,hraz10,
                                 hraz41,hraz12,hraz14,hraz16,hraz34,hraz39,hraz37,hraz17,
                                 hraz18,hraz23,hraz24,hraz27,hraz28,hraz25,hraz26,
                                 hraz43,hraz32,hraz30,hraz07,hrazud04,hrazud05,hrazud07,hraz09,hraz40,hraz33,hraz13,
                                 hraz15,hraz11,hraz38,
                                 hrazacti,hrazuser,hrazdate,hrazgrup,hrazoriu,hrazorig,hraz42,hraz44,hrazud01,ta_hraz01,ta_hraz02)    #mod by zhangbo130726             
                  VALUES(l_hraz03,g_hraz_h.hraz01,g_hraz_h.hraz04,g_hraz_h.hraz19,g_hraz_h.hraz05,g_hraz_h.hraz31,g_hraz_h.hraz08,g_hraz_h.hrazud02,g_hraz_h.hrazud03,g_hraz_h.hrazud06,g_hraz_h.hraz10,
                         g_hraz_h.hraz41,g_hraz_h.hraz12,
                         g_hraz_h.hraz14,g_hraz_h.hraz16,l_hraz34,g_hraz_h.hraz39,g_hraz_h.hraz37,g_hraz_h.hraz17,
                         g_hraz_h.hraz18,g_hraz_h.hraz23,g_hraz_h.hraz24,g_hraz_h.hraz27,
                         g_hraz_h.hraz28,g_hraz_h.hraz25,g_hraz_h.hraz26,
                         g_hraz[l_ac].hraz43,g_hraz[l_ac].hraz32,g_hraz[l_ac].hraz30,g_hraz[l_ac].hraz07,g_hraz[l_ac].hrazud04,g_hraz[l_ac].hrazud05,g_hraz[l_ac].hrazud07,                                                              #FUN-A80148--mark--
                         g_hraz[l_ac].hraz09,g_hraz[l_ac].hraz40,l_hraz33,g_hraz[l_ac].hraz13,
                         g_hraz[l_ac].hraz15,g_hraz[l_ac].hraz11,g_hraz[l_ac].hraz38,
                         'Y',g_user,g_today,g_grup,g_user,g_grup,'N',g_hraz_h.hraz44,g_hraz_h.hrazud01,g_hraz_h.ta_hraz01,g_hraz[l_ac].ta_hraz02)                             #mod by zhangbo130726
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","hraz_file",g_hraz_h.hraz01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
              ROLLBACK WORK              #FUN-680010
              CANCEL INSERT
           ELSE  
              LET g_rec_b=g_rec_b+1    
              DISPLAY g_rec_b TO FORMONLY.cn2     
              COMMIT WORK  
           END IF        	  	
      AFTER FIELD ta_hraz02
        IF NOT cl_null(g_hraz[l_ac].ta_hraz02) THEN
           SELECT COUNT(*) INTO l_n FROM hrar_file WHERE hrar03 = g_hraz[l_ac].ta_hraz02
           IF l_n = 0 THEN 
              CALL cl_err(g_hraz_h.ta_hraz01,'ghr-295',1)
              NEXT FIELD ta_hraz02
           END IF 
           SELECT hrar04 INTO g_hraz[l_ac].ta_hraz02_n FROM hrar_file WHERE hrar03 = g_hraz[l_ac].ta_hraz02
        END IF         
           	  		     	
        AFTER FIELD hraz43                        
           IF NOT cl_null(g_hraz[l_ac].hraz43) THEN       	 	  	                                            
              IF g_hraz[l_ac].hraz43 != g_hraz_t.hraz43 OR
                 g_hraz_t.hraz43 IS NULL THEN
                 IF g_hraz_h.hraz01 IS NOT NULL THEN
                    LET l_n=0
                    SELECT COUNT(*) INTO l_n FROM hraz_file
                     WHERE hraz01 = g_hraz_h.hraz01
                       AND hraz43 = g_hraz[l_ac].hraz43
                    IF l_n > 0 THEN
                       CALL cl_err('',-239,0)
                       LET g_hraz[l_ac].hraz43 = g_hraz_t.hraz43
                       NEXT FIELD hraz04
                    END IF 	
                 END IF   	                                           	
              END IF
              
              LET l_n=0
              IF g_hraz_h.hraz01 IS NOT NULL THEN
                 SELECT COUNT(*) INTO l_n FROM hraz_file
                  WHERE hraz01<>g_hraz_h.hraz01
                    AND hraz43=g_hraz[l_ac].hraz43
                    AND (hraz18='001' OR hraz18='002' 
                         OR hraz05>=g_today OR hraz05>g_hraz_h.hraz05)
              ELSE
              	 SELECT COUNT(*) INTO l_n FROM hraz_file
                  WHERE hraz43=g_hraz[l_ac].hraz43
                    AND (hraz18='001' OR hraz18='002' 
                         OR hraz05>=g_today OR hraz05>g_hraz_h.hraz05)
              END IF
              	                      
              IF l_n>0 THEN
              	 CALL cl_err('该员工存在未审核的数据或者未生效的数据或者生效日期大于本次生效日期的数据','!',0)
              	 NEXT FIELD hraz43
              END IF
              	 	               
              SELECT hrat02,hrat03,hrat04,hrat05,hrat64,hrat06,hrat40,hrat41,hrat42,hrat21,hrat87,hrat88,hrat20,hrat60
                INTO g_hraz[l_ac].hrat02,g_hraz[l_ac].hraz30,g_hraz[l_ac].hraz07,g_hraz[l_ac].hraz09,
                     g_hraz[l_ac].hraz40,g_hraz[l_ac].hraz33,g_hraz[l_ac].hraz13,g_hraz[l_ac].hraz15,
                     g_hraz[l_ac].hraz11,g_hraz[l_ac].hraz38,g_hraz[l_ac].hrazud04,g_hraz[l_ac].hrazud05,g_hraz[l_ac].hrazud07,g_hraz[l_ac].ta_hraz02
               FROM hrat_file
              WHERE hrat01=g_hraz[l_ac].hraz43	 
              SELECT hrar04 INTO g_hraz[l_ac].ta_hraz02_n FROM hrar_file
               WHERE hraa01=g_hraz[l_ac].ta_hraz02              
                
              SELECT hraa12 INTO g_hraz[l_ac].hraz30_desc FROM hraa_file
               WHERE hraa01=g_hraz[l_ac].hraz30
              SELECT hrao02 INTO g_hraz[l_ac].hraz07_desc FROM hrao_file
               WHERE hrao01=g_hraz[l_ac].hraz07
              SELECT hras04 INTO g_hraz[l_ac].hraz09_desc FROM hras_file
               WHERE hras01=g_hraz[l_ac].hraz09 
              SELECT hrat02 INTO g_hraz[l_ac].hraz33_desc FROM hrat_file
               WHERE hrat01=g_hraz[l_ac].hraz33 
              SELECT hraf02 INTO g_hraz[l_ac].hraz13_desc FROM hraf_file
               WHERE hraf01=g_hraz[l_ac].hraz13
              SELECT hrai04 INTO g_hraz[l_ac].hraz11_desc FROM hrai_file
               WHERE hrai03=g_hraz[l_ac].hraz11
              
                             #组别        
                 SELECT hrao02 INTO g_hraz[l_ac].hrazud04_desc FROM hrao_file
                 WHERE hrao01=g_hraz[l_ac].hrazud04
                 
                 SELECT hrag07 INTO g_hraz[l_ac].hrazud07_desc FROM hrag_file 
                 WHERE hrag01='313' AND hrag06=g_hraz[l_ac].hrazud07
                              
                 #组别      
                 SELECT hrao02 INTO g_hraz[l_ac].hrazud05_desc FROM hrao_file
                 WHERE hrao01=g_hraz[l_ac].hrazud05
                              
               
#              IF g_hraz[l_ac].hraz07=g_hraz_h.hraz08 
#              	 AND g_hraz[l_ac].hraz09=g_hraz_h.hraz10 THEN
#              	 CALL cl_err('该员工变更前部门职位和变更后部门职位相同','!',0)
#              	 NEXT FIELD hraz43
#              END IF 
                 
           #   IF cl_null(g_hraz[l_ac].hraz32) THEN
              	 LET g_hraz[l_ac].hraz32=g_hraz[l_ac].hraz43
              	 DISPLAY BY NAME g_hraz[l_ac].hraz32
           #   END IF
              	
              IF g_hraz[l_ac].hraz32 != g_hraz[l_ac].hraz43 THEN
              	 LET l_n=0
              	 SELECT COUNT(*) INTO l_n 
              	   FROM hrat_file 
              	  WHERE hrat01=g_hraz[l_ac].hraz32
              	 IF l_n>0 THEN
              	 	  CALL cl_err('该员工编号已存在,不可将新工号变更成此工号','!',0)
              	 	  LET g_hraz[l_ac].hraz32=g_hraz_t.hraz32
              	    NEXT FIELD hraz32
              	 END IF 
              END IF	 	  
              	 	 	 	    	
       	   END IF
       	   	
        AFTER FIELD hraz32
           IF NOT cl_null(g_hraz[l_ac].hraz32) THEN
           	  IF NOT cl_null(g_hraz[l_ac].hraz43) THEN
           	  	 IF g_hraz[l_ac].hraz32 != g_hraz[l_ac].hraz43 THEN
              	    LET l_n=0
              	    SELECT COUNT(*) INTO l_n
              	      FROM hrat_file 
              	     WHERE hrat01=g_hraz[l_ac].hraz32
              	    IF l_n>0 THEN
              	    	 CALL cl_err('该员工编号已存在,不可将新工号变更成此工号','!',0)
              	    	 LET g_hraz[l_ac].hraz32=g_hraz_t.hraz32
              	       NEXT FIELD hraz32
              	    END IF 
                 END IF	
              END IF 	  

           	  IF g_hraz[l_ac].hraz32 != g_hraz_t.hraz32 OR
                 g_hraz_t.hraz32 IS NULL THEN
                 LET l_n=0
                 SELECT COUNT(*) INTO l_n FROM hraz_file 
                  WHERE hraz32=g_hraz[l_ac].hraz32
                    AND (hraz18='001' OR hraz18='002')
                 IF l_n>0 THEN
                 	  CALL cl_err('此工号存在未审核的数据,不可将新工号变更为此工号','!',0)
                 	  LET g_hraz[l_ac].hraz32=g_hraz_t.hraz32
                 	  NEXT FIELD hraz32
                 END IF
              END IF
                 
          	 		     
           END IF
       	AFTER FIELD hrazud04
          IF NOT cl_null(g_hraz[l_ac].hrazud04) THEN
             CALL i016_hrazud04('a')
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_hraz[l_ac].hrazud04,g_errno,0)
                NEXT FIELD hrazud04
             END IF
          END IF

       AFTER FIELD hrazud05
            IF NOT cl_null(g_hraz[l_ac].hrazud05) THEN
               CALL i016_hrazud05('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_hraz[l_ac].hrazud05,g_errno,0)
                  NEXT FIELD hrazud05
               END IF
            END IF
         	
        BEFORE DELETE                           
           IF g_hraz_t.hraz43 IS NOT NULL THEN
              IF NOT cl_delete() THEN
                 ROLLBACK WORK      #FUN-680010
                 CANCEL DELETE
              END IF
              INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
              LET g_doc.column1 = "hraz01"               #No.FUN-9B0098 10/02/24
              LET g_doc.value1 = g_hraz_h.hraz01      #No.FUN-9B0098 10/02/24
              CALL cl_del_doc()                                          #No.FUN-9B0098 10/02/24
              IF l_lock_sw = "Y" THEN 
                 CALL cl_err("", -263, 1) 
                 ROLLBACK WORK      #FUN-680010
                 CANCEL DELETE 
              END IF 
           
              DELETE FROM hraz_file WHERE hraz01 = g_hraz_h.hraz01
                                      AND hraz43 = g_hraz_t.hraz43
            
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","hraz_file",g_hraz_h.hraz01,g_hraz_t.hraz43,SQLCA.sqlcode,"","",1)  #No.FUN-660131
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
              LET g_hraz[l_ac].* = g_hraz_t.*
              CLOSE i016_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw="Y" THEN
              CALL cl_err(g_hraz[l_ac].hraz43,-263,0)
              LET g_hraz[l_ac].* = g_hraz_t.*
           ELSE
            
             #FUN-A30030 END--------------------
              SELECT hratid INTO l_hraz33 FROM hrat_file 
               WHERE hrat01=g_hraz[l_ac].hraz33
              SELECT hratid INTO l_hraz03 FROM hrat_file
               WHERE hrat01=g_hraz[l_ac].hraz43   
              UPDATE hraz_file SET hraz03=l_hraz03,
                                   hraz43=g_hraz[l_ac].hraz43,
                                   hraz32=g_hraz[l_ac].hraz32,
                                   hraz30=g_hraz[l_ac].hraz30,
                                   hraz07=g_hraz[l_ac].hraz07,
                                   hrazud04=g_hraz[l_ac].hrazud04,
                                   hrazud05=g_hraz[l_ac].hrazud05,
                                   hrazud07=g_hraz[l_ac].hrazud07,
                                   hraz09=g_hraz[l_ac].hraz09,
                                   hraz33=l_hraz33,
                                   hraz40=g_hraz[l_ac].hraz40,
                                   hraz13=g_hraz[l_ac].hraz13,
                                   hraz15=g_hraz[l_ac].hraz15,
                                   hraz11=g_hraz[l_ac].hraz11,
                                   hraz38=g_hraz[l_ac].hraz38,    
                                   hrazmodu=g_user,
                                   hrazdate=g_today
                             WHERE hraz01 = g_hraz_h.hraz01
                               AND hraz43 = g_hraz_t.hraz43
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","hraz_file",g_hraz_h.hraz01,g_hraz_t.hraz43,SQLCA.sqlcode,"","",1)  #No.FUN-660131
                 ROLLBACK WORK    #FUN-680010
                 LET g_hraz[l_ac].* = g_hraz_t.*
              END IF
           END IF   
         
          		   	    	
         AFTER ROW
            LET l_ac = ARR_CURR()            
            LET l_ac_t = l_ac                
         
            IF INT_FLAG THEN                 #900423
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_hraz[l_ac].* = g_hraz_t.*
               END IF
               CLOSE i016_bcl                
               ROLLBACK WORK                 
               EXIT INPUT
            END IF
            CLOSE i016_bcl                
            COMMIT WORK      
         
         
         ON ACTION controlp
            CASE
            	 WHEN INFIELD(hraz43)
            	    IF p_cmd='a' THEN
            	       CALL i016_gen()
                     EXIT INPUT
                  ELSE
                  	 CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_hrat01"
                     LET g_qryparam.default1 = g_hraz[l_ac].hraz43
                     CALL cl_create_qry() RETURNING g_hraz[l_ac].hraz43
                     DISPLAY BY NAME g_hraz[l_ac].hraz43
                     NEXT FIELD hraz43
                  END IF   
                                WHEN INFIELD(hrazud04)
                 CALL cl_init_qry_var()
                IF NOT cl_null(g_hraz[l_ac].hraz30) THEN
                 CASE
                   WHEN NOT cl_null(g_hraz[l_ac].hraz07)
                     LET g_qryparam.form = "cq_hrao01_0"
                     LET g_qryparam.arg1 = g_hraz[l_ac].hraz30
                     LET g_qryparam.arg2 = '2'
                     LET g_qryparam.arg3 = g_hraz[l_ac].hraz07
                    WHEN cl_null(g_hraz[l_ac].hraz07)
                     LET g_qryparam.arg1 = g_hraz[l_ac].hraz30
                     LET g_qryparam.arg2 = '2'
                     LET g_qryparam.form = "cq_hrao01_0_1"
                 END CASE
              ELSE
                LET g_qryparam.form = "cq_hrao01_1_1"
                LET g_qryparam.arg2 = '2'
              END IF
              LET g_qryparam.default1 = g_hraz[l_ac].hrazud04
              CALL cl_create_qry() RETURNING g_hraz[l_ac].hrazud04
              DISPLAY BY NAME g_hraz[l_ac].hrazud04
              NEXT FIELD hrazud04





                 WHEN INFIELD(hrazud05)
                   {CALL cl_init_qry_var()
               IF NOT cl_null(g_hraz[l_ac].hraz30) THEN
                IF NOT cl_null(g_hraz[l_ac].hraz07) THEN
                  LET g_qryparam.arg1 = g_hraz[l_ac].hraz30
                  LET g_qryparam.arg2 = '3'
                  LET g_qryparam.arg3 = g_hraz[l_ac].hrazud04
                  LET g_qryparam.form = "cq_hrao01_0"
                ELSE
                  LET g_qryparam.arg1 = g_hraz[l_ac].hraz30
                  LET g_qryparam.arg2 = '3'
                  LET g_qryparam.form = "cq_hrao01_0_1"
                END IF
              ELSE
                IF NOT cl_null(g_hraz[l_ac].hrazud04)  THEN
                  LET g_qryparam.arg1 = g_hraz[l_ac].hraz30
                  LET g_qryparam.arg2 = '3'
                  LET g_qryparam.arg3 = g_hraz[l_ac].hrazud04
                  LET g_qryparam.form = "cq_hrao01_1"
                ELSE
                  IF  NOT cl_null(g_hraz[l_ac].hraz07) THEN
                    LET g_qryparam.arg1 = g_hraz[l_ac].hraz30
                    LET g_qryparam.arg2 = '3'
                    LET g_qryparam.arg3 = g_hraz[l_ac].hraz07
                    LET g_qryparam.form = "cq_hrao01_1"
                  ELSE
                      LET g_qryparam.arg1 = g_hraz[l_ac].hraz30
                      LET g_qryparam.arg2 = '3'
                      LET g_qryparam.form = "cq_hrao01_1_1"
                  END IF
                 END IF
              END IF
              LET g_qryparam.default1 = g_hraz[l_ac].hrazud05
              CALL cl_create_qry() RETURNING g_hraz[l_ac].hrazud05
              DISPLAY BY NAME g_hraz[l_ac].hrazud05
              NEXT FIELD hrazud05}
              CALL cl_init_qry_var()
              IF NOT cl_null(g_hraz[l_ac].hraz30) THEN
                 CASE
                   WHEN NOT cl_null(g_hraz[l_ac].hrazud04)
                     LET g_qryparam.form = "cq_hrao01_0"
                     LET g_qryparam.arg1 = g_hraz[l_ac].hraz30
                     LET g_qryparam.arg2 = '3'
                     LET g_qryparam.arg3 = g_hraz[l_ac].hrazud04
                   WHEN NOT cl_null(g_hraz[l_ac].hraz07)
                     LET g_qryparam.form = "cq_hrao01_0"
                     LET g_qryparam.arg1 = g_hraz[l_ac].hraz30
                     LET g_qryparam.arg2 = '3'
                     LET g_qryparam.arg3 = g_hraz[l_ac].hraz07
                    WHEN cl_null(g_hraz[l_ac].hraz07)
                     LET g_qryparam.arg1 = g_hraz[l_ac].hraz30
                     LET g_qryparam.arg2 = '3'
                     LET g_qryparam.form = "cq_hrao01_0_1"
                 END CASE
              ELSE
                LET g_qryparam.form = "cq_hrao01_1_1"
                LET g_qryparam.arg2 = '3'
              END IF
              LET g_qryparam.default1 = g_hraz[l_ac].hrazud05
              CALL cl_create_qry() RETURNING  g_hraz[l_ac].hrazud05
              DISPLAY BY NAME  g_hraz[l_ac].hrazud05
              NEXT FIELD hrazud05      
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
       		  	 	 	 	 	                                                 
    #END WHILE    
      
    CLOSE i016_bcl
    COMMIT WORK
    IF g_wc IS NOT NULL AND g_wc IS NOT NULL THEN
    	 CALL i016_hraz_fill()
    END IF	 
    CALL i016_b_fill(" 1=1")
END FUNCTION
	
FUNCTION i016_gen()
DEFINE   l_sql      STRING
DEFINE   i,l_i          LIKE   type_file.num5
DEFINE   gs_wc      STRING
DEFINE   lc_qbe_sn  LIKE gbm_file.gbm01
DEFINE   l_hraz   RECORD LIKE  hraz_file.*
DEFINE   l_hrat   DYNAMIC ARRAY OF RECORD
            sel      LIKE type_file.chr1,
            hrat01   LIKE hrat_file.hrat01,
            hrat02   LIKE hrat_file.hrat02,
            hrat03   LIKE hrat_file.hrat03,
            hraa12   LIKE hraa_file.hraa12,
            hrat04   LIKE hrat_file.hrat04,
            hrao02   LIKE hrao_file.hrao02,
            hrat05   LIKE hrat_file.hrat05,
            hras04   LIKE hras_file.hras04
                 END RECORD
DEFINE p_row,p_col  LIKE type_file.num5
DEFINE l_allow_insert  LIKE type_file.num5
DEFINE l_allow_deLETe  LIKE type_file.num5

DEFINE   lr_err       DYNAMIC ARRAY OF RECORD
            line    STRING,
            key1    STRING,
            err     STRING
       END RECORD   
DEFINE li_k                    LIKE type_file.num5
DEFINE l_year       STRING
DEFINE l_month      STRING 
DEFINE l_day        STRING	
DEFINE l_no         LIKE type_file.chr10
DEFINE l_hraz01     LIKE  hraz_file.hraz01
      
      LET gs_wc=NULL        
       
      DROP TABLE i043_tmp
      
      SELECT hrat01,hrat02,hrat03,hrat04,hrat05 FROM hrat_file
       WHERE hratconf='Y'
         AND (hrat04 != g_hraz_h.hraz08 OR hrat05 != g_hraz_h.hraz10 )
         AND hrat01 NOT IN (SELECT hraz43 FROM hraz_file 
                             WHERE hraz18='001' OR hraz18='002' 
                                OR hraz05>=g_today OR hraz05>g_hraz_h.hraz05)         
      INTO TEMP i043_tmp
      
      IF STATUS THEN 
         CALL cl_err('ins i043_tmp:',STATUS,1) 
         RETURN 
      END IF 
       
      LET p_row=3   LET p_col=6

      OPEN WINDOW i043_m_w AT p_row,p_col WITH FORM "ghr/42f/ghri043_m"
              ATTRIBUTE (STYLE = g_win_style CLIPPED)
      CALL cl_ui_locale("ghri043_m")

      CONSTRUCT gs_wc ON hrat01,hrat02,hrat03,hrat04,hrat05
           FROM s_hrat[1].hrat01,s_hrat[1].hrat02,s_hrat[1].hrat03,
                s_hrat[1].hrat04,s_hrat[1].hrat05

      BEFORE CONSTRUCT
           CALL cl_qbe_display_condition(lc_qbe_sn)
           
           

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
               

       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121

       ON ACTION help          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121

       ON ACTION controlg      #MOD-4C0121
          CALL cl_cmdask()

     END CONSTRUCT

     IF INT_FLAG THEN
         LET INT_FLAG=0
         DELETE FROM i043_tmp
         CLOSE WINDOW i043_m_w
         RETURN
     END IF 
      
     LET l_sql=" SELECT 'N',hrat01,hrat02,hrat03,'',hrat04,'',hrat05,'' ",
               "   FROM i043_tmp ",
               "  WHERE ",gs_wc CLIPPED,
               "  ORDER BY hrat01,hrat02"


      PREPARE i043_m_pre FROM l_sql
      DECLARE i043_m_cs CURSOR FOR i043_m_pre

      LET i=1
      CALL l_hrat.clear()
      FOREACH i043_m_cs INTO l_hrat[i].*
        
        SELECT hraa12 INTO l_hrat[i].hraa12 FROM hraa_file 
         WHERE hraa01=l_hrat[i].hrat03
         
        SELECT hrao02 INTO l_hrat[i].hrao02 FROM hrao_file 
         WHERE hrao01=l_hrat[i].hrat04
         
        SELECT hras04 INTO l_hrat[i].hras04 FROM hras_file 
         WHERE hras01=l_hrat[i].hrat05
         
         
        LET i=i+1

      END FOREACH
      
      CALL l_hrat.deleteElement(i)
      LET i=i-1

      INPUT ARRAY l_hrat WITHOUT DEFAULTS FROM s_hrat.*
            ATTRIBUTE(COUNT=i,MAXCOUNT=i,UNBUFFERED,
                      INSERT ROW=l_allow_insert,DELETE ROW=l_allow_deLETe,APPEND ROW=l_allow_insert)

      AFTER INPUT
         FOR g_cnt=1 TO i
            IF l_hrat[g_cnt].sel='Y' AND l_hrat[g_cnt].sel IS NOT NULL
               AND l_hrat[g_cnt].sel <>' ' THEN
               CONTINUE FOR
            END IF
            IF l_hrat[g_cnt].hrat01 IS NULL THEN CONTINUE FOR END IF

            DELETE FROM i043_tmp WHERE hrat01=l_hrat[g_cnt].hrat01

         END FOR
         ON ACTION selall
           LET g_action_choice="selall"
           LET l_i = 0
           FOR l_i = 1 TO i
               LET l_hrat[l_i].sel = 'Y'

           END FOR
         ON action unselall
           LET g_action_choice="unselall"
           LET l_i = 0
           FOR l_i = 1 TO i
               LET l_hrat[l_i].sel = 'N'
           END FOR        

      END INPUT
      
      IF INT_FLAG THEN 
      	 LET INT_FLAG=0 
         #DELETE FROM i043_tmp
         #CLOSE WINDOW i043_m_w
         #RETURN
      END IF
      CLOSE WINDOW i043_m_w

      LET l_sql="  SELECT hrat01 ",
                "  FROM i043_tmp ",
                "  WHERE ",gs_wc CLIPPED,
                " ORDER BY hrat01"

      PREPARE i002_m_pre2 FROM l_sql
      DECLARE i002_m_ins CURSOR FOR i002_m_pre2
      
      LET li_k=1
      LET g_success='Y'
      
      FOREACH i002_m_ins INTO l_hraz.hraz43
         IF cl_null(g_hraz_h.hraz01) THEN
            LET l_year=YEAR(g_today) USING "&&&&"
            LET l_month=MONTH(g_today) USING "&&"
            LET l_day=DAY(g_today) USING "&&"
            LET l_year=l_year.trim()
            LET l_month=l_month.trim()
            LET l_day=l_day.trim()
            LET g_hraz_h.hraz01=l_year CLIPPED,l_month CLIPPED,l_day CLIPPED
            LET l_hraz01=g_hraz_h.hraz01,"%"
            LET l_sql="SELECT MAX(hraz01) FROM hraz_file",
                      " WHERE hraz01 LIKE '",l_hraz01,"'"
            PREPARE i016_g_hraz01 FROM l_sql
            EXECUTE i016_g_hraz01 INTO g_hraz_h.hraz01
            IF cl_null(g_hraz_h.hraz01) THEN 
               LET g_hraz_h.hraz01=l_hraz01[1,8],'0001'
            ELSE
               LET l_no=g_hraz_h.hraz01[9,12]
               LET l_no=l_no+1 USING "&&&&"
               LET g_hraz_h.hraz01=l_hraz01[1,8],l_no
            END IF
         END IF	  
         LET l_hraz.hraz01=g_hraz_h.hraz01
         LET l_hraz.hraz04=g_hraz_h.hraz04
         LET l_hraz.hraz05=g_hraz_h.hraz05
         LET l_hraz.hraz19=g_hraz_h.hraz19
         LET l_hraz.hraz31=g_hraz_h.hraz31
         LET l_hraz.hraz08=g_hraz_h.hraz08
         LET l_hraz.hraz10=g_hraz_h.hraz10
         LET l_hraz.hraz41=g_hraz_h.hraz41
         LET l_hraz.hraz12=g_hraz_h.hraz12
         LET l_hraz.hraz14=g_hraz_h.hraz14
         LET l_hraz.hraz16=g_hraz_h.hraz16
         LET l_hraz.ta_hraz01 = g_hraz_h.ta_hraz01
         SELECT hratid INTO l_hraz.hraz34 FROM hrat_file
          WHERE hrat01=g_hraz_h.hraz34
         LET l_hraz.hraz39=g_hraz_h.hraz39
         LET l_hraz.hraz17=g_hraz_h.hraz17
         LET l_hraz.hraz18=g_hraz_h.hraz18
         LET l_hraz.hrazacti='Y'
         LET l_hraz.hrazuser=g_user
         LET l_hraz.hrazgrup=g_grup
         LET l_hraz.hrazoriu=g_user
         LET l_hraz.hrazorig=g_grup
         
         SELECT hratid,hrat03,hrat04,hrat05,hrat64,hrat06,hrat40,hrat41,hrat42,hrat21,hrat60,hrat20
           INTO l_hraz.hraz03,l_hraz.hraz30,l_hraz.hraz07,l_hraz.hraz09,
                l_hraz.hraz40,l_hraz.hraz33,l_hraz.hraz13,l_hraz.hraz15,
                l_hraz.hraz11,l_hraz.hraz38,l_hraz.ta_hraz02,l_hraz.hrazud07
           FROM hrat_file
          WHERE hrat01=l_hraz.hraz43             
          
          LET l_hraz.hraz32=l_hraz.hraz43           
         
          INSERT INTO hraz_file VALUES (l_hraz.*)  

      END FOREACH

      DROP TABLE i043_tmp
     
      CALL i016_b_fill(" 1=1")
      CALL i016_b() 
END FUNCTION
	
FUNCTION i016_r()        
   DEFINE   l_cnt   LIKE type_file.num5,          #No.FUN-680135 SMALLINT
            l_gae   RECORD LIKE gae_file.*
 
   IF s_shut(0) THEN RETURN END IF
   	
   IF cl_null(g_hraz_h.hraz01) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
   	
   IF g_hraz_h.hraz18 !='001' AND g_hraz_h.hraz18 != '002' THEN
   	  CALL cl_err('资料不是未审核状态','!',0)
   	  RETURN
   END IF
   		  	
   BEGIN WORK
   IF cl_delh(0,0) THEN                   #確認一下
      DELETE FROM hraz_file
       WHERE hraz01 = g_hraz_h.hraz01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","hraz_file",g_hraz_h.hraz01,'',SQLCA.sqlcode,"","BODY DELETE",0)   #No.FUN-660081
      ELSE
         CLEAR FORM
         CALL g_hraz.clear()
         CALL g_hraz_1.clear()
         OPEN i016_count
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i016_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i016_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET g_no_ask = TRUE           #No.FUN-6A0080
            CALL i016_fetch('/')
         END IF
      END IF
   END IF
   COMMIT WORK
   CALL i016_hraz_fill()
END FUNCTION	
	
FUNCTION i016_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(g_hraz_h.hraz01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   IF g_hraz_h.hraz18='003' OR g_hraz_h.hraz18='004' THEN
      CALL cl_err('资料不是未审核状态,不可更改','!',0)
      RETURN
   END IF 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_hraz_h_t.*=g_hraz_h.*
   BEGIN WORK
   OPEN i016_lock_u USING g_hraz_h.hraz01
   IF STATUS THEN
      CALL cl_err("DATA LOCK:",STATUS,1)
      CLOSE i016_lock_u
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i016_lock_u INTO g_hraz_h.*
   IF SQLCA.sqlcode THEN
      CALL cl_err("hraz01 LOCK:",SQLCA.sqlcode,1)
      CLOSE i016_lock_u
      ROLLBACK WORK
      RETURN
   END IF
 
   WHILE TRUE
      CALL i016_i("u")
      IF INT_FLAG THEN
         LET g_hraz_h.* = g_hraz_h_t.*
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         CALL i016_show()
         EXIT WHILE
      END IF
      UPDATE hraz_file SET hraz04=g_hraz_h.hraz04,
                           hraz19=g_hraz_h.hraz19,
                           hraz05=g_hraz_h.hraz05,
                           hraz31=g_hraz_h.hraz31,
                           hraz08=g_hraz_h.hraz08,
                           hraz10=g_hraz_h.hraz10,
                           hraz41=g_hraz_h.hraz41,
                           hraz12=g_hraz_h.hraz12,
                           hraz14=g_hraz_h.hraz14,
                           hraz16=g_hraz_h.hraz16,
                           hraz34=g_hraz_h.hraz34,
                           hraz39=g_hraz_h.hraz39,
                           hraz17=g_hraz_h.hraz17,
                           hraz44=g_hraz_h.hraz44,
                           hrazud01=g_hraz_h.hrazud01,
                           hrazud02=g_hraz_h.hrazud02,
                           hrazud03=g_hraz_h.hrazud03,
                           hrazud06=g_hraz_h.hrazud06,
                           ta_hraz01 = g_hraz_h.ta_hraz01
       WHERE hraz01 = g_hraz_h_t.hraz01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","hraz_file",g_hraz_h_t.hraz01,'',SQLCA.sqlcode,"","",1) #No.FUN-660081
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
   COMMIT WORK
   CALL i016_hraz_fill()
END FUNCTION	
	
FUNCTION i016_b_fill(p_wc2)
DEFINE p_wc2   STRING
DEFINE l_hraz03    LIKE hraz_file.hraz03
   LET g_sql = "SELECT hraz43,hraz32,'',hraz30,'',hraz07,'',hrazud04,'',hrazud05,'',hrazud07,'',hraz09,'',",
               "       hraz40,hraz33,'',hraz13,'',hraz15,hraz11,'',hraz38,ta_hraz02,'' ",
               " FROM hraz_file",   
               " WHERE hraz01 = '",g_hraz_h.hraz01,"'"   
   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   PREPARE i016_pb FROM g_sql
   DECLARE hraz_cs CURSOR FOR i016_pb
   CALL g_hraz.clear()
   LET g_cnt = 1
   FOREACH hraz_cs INTO g_hraz[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       SELECT hraz03 INTO l_hraz03 FROM hraz_file WHERE hraz01 =  g_hraz_h.hraz01 AND hraz43 = g_hraz[g_cnt].hraz43 
       SELECT hrat01 INTO g_hraz[g_cnt].hraz43 FROM hrat_file WHERE hratid = l_hraz03
       SELECT hrar04 INTO g_hraz[g_cnt].ta_hraz02_n FROM hrar_file WHERE  hrar03 = g_hraz[g_cnt].ta_hraz02	
       SELECT hrat02 INTO g_hraz[g_cnt].hrat02 FROM hrat_file 
        WHERE hrat01=g_hraz[g_cnt].hraz43
       SELECT hraa12 INTO g_hraz[g_cnt].hraz30_desc FROM hraa_file
        WHERE hraa01=g_hraz[g_cnt].hraz30
       SELECT hrao02 INTO g_hraz[g_cnt].hraz07_desc FROM hrao_file
        WHERE hrao01=g_hraz[g_cnt].hraz07
        
        SELECT hrao02 INTO g_hraz[g_cnt].hrazud04_desc FROM hrao_file
        WHERE hrao01=g_hraz[g_cnt].hrazud04

        SELECT hrao02 INTO g_hraz[g_cnt].hrazud05_desc FROM hrao_file
        WHERE hrao01=g_hraz[g_cnt].hrazud05 
       
       SELECT hrag07 INTO g_hraz[g_cnt].hrazud07_desc FROM hrag_file 
       WHERE hrag01='313' AND hrag06=g_hraz[g_cnt].hrazud07
        
       SELECT hras04 INTO g_hraz[g_cnt].hraz09_desc FROM hras_file
        WHERE hras01=g_hraz[g_cnt].hraz09
       SELECT hrat01 INTO g_hraz[g_cnt].hraz33 FROM hrat_file
        WHERE hratid=g_hraz[g_cnt].hraz33 
       SELECT hrat02 INTO g_hraz[g_cnt].hraz33_desc FROM hrat_file
        WHERE hrat01=g_hraz[g_cnt].hraz33 
       SELECT hraf02 INTO g_hraz[g_cnt].hraz13_desc FROM hraf_file
        WHERE hraf01=g_hraz[g_cnt].hraz13
       SELECT hrai04 INTO g_hraz[g_cnt].hraz11_desc FROM hrai_file
        WHERE hrai03=g_hraz[g_cnt].hraz11
        	
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_hraz.deleteElement(g_cnt)
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION
	
FUNCTION i016_hraz_fill()
DEFINE l_sql       STRING
DEFINE l_sql2      STRING
DEFINE l_hraz01    LIKE   hraz_file.hraz01
DEFINE l_jump      LIKE   type_file.num5
DEFINE l_hraz03    LIKE hraz_file.hraz03
       
       CALL g_hraz_1.clear()
       CALL g_hraz1.clear()
       LET l_sql = "SELECT DISTINCT hraz01 FROM hraz_file
                    left join hrat_file on hratid=hraz03",
                   " WHERE ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                   " ORDER BY hraz01"	
       PREPARE i016_hraz1_pre FROM l_sql
       DECLARE i016_hraz1_cs CURSOR FOR i016_hraz1_pre
       
       LET l_jump=1
       LET g_cnt=1
       FOREACH i016_hraz1_cs INTO l_hraz01
          LET l_sql=" SELECT hraz32,'',hraz31,hraz08,hraz10,hraz12,hraz14,hraz16,hraz04,",
	     	            "        hraz19,hraz05,hraz43,hraz30,hraz07,hraz09,hraz11,hraz13,",
	     	            "        hraz15,hraz38,hraz39,hraz18,ta_hraz01,'' ",
	     	            "   FROM hraz_file 
	     	                left join hrat_file on hratid=hraz03",
	     	            "  WHERE hraz01='",l_hraz01,"'",
	     	            "    AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
	     	                
	     	  PREPARE i016_hraz_1_pre FROM l_sql
	     	  DECLARE i016_hraz_1_cs CURSOR FOR i016_hraz_1_pre
	     	      
	     	  
	     	  FOREACH i016_hraz_1_cs INTO g_hraz_1[g_cnt].*
	     	     LET g_hraz1[g_cnt].hraz01=l_hraz01
	     	     LET g_hraz1[g_cnt].jump=l_jump
             SELECT hraz03 INTO l_hraz03 FROM hraz_file WHERE hraz01 = l_hraz01 AND hraz43 = g_hraz_1[g_cnt].hraz43_1
             SELECT hrat01 INTO g_hraz_1[g_cnt].hraz43_1 FROM hrat_file WHERE hratid = l_hraz03
	     	     SELECT hrar04 INTO g_hraz_1[g_cnt].ta_hraz01_n FROM hrar_file WHERE hrar03 = g_hraz_1[g_cnt].ta_hraz01
	     	     SELECT hrat02 INTO g_hraz_1[g_cnt].hrat02_1 FROM hrat_file 
	     	      WHERE hrat01=g_hraz_1[g_cnt].hraz43_1
	     	     SELECT hraa12 INTO g_hraz_1[g_cnt].hraz31_1 FROM hraa_file
	     	      WHERE hraa01=g_hraz_1[g_cnt].hraz31_1
	     	     SELECT hraa12 INTO g_hraz_1[g_cnt].hraz30_1 FROM hraa_file
	     	      WHERE hraa01=g_hraz_1[g_cnt].hraz30_1
	     	     SELECT hrao02 INTO g_hraz_1[g_cnt].hraz08_1 FROM hrao_file
	     	      WHERE hrao01=g_hraz_1[g_cnt].hraz08_1
	     	     SELECT hrao02 INTO g_hraz_1[g_cnt].hraz07_1 FROM hrao_file
	     	      WHERE hrao01=g_hraz_1[g_cnt].hraz07_1
	     	     SELECT hras04 INTO g_hraz_1[g_cnt].hraz10_1 FROM hras_file
	     	      WHERE hras01=g_hraz_1[g_cnt].hraz10_1
	     	     SELECT hras04 INTO g_hraz_1[g_cnt].hraz09_1 FROM hras_file
	     	      WHERE hras01=g_hraz_1[g_cnt].hraz09_1  
	     	     SELECT hrai04 INTO g_hraz_1[g_cnt].hraz12_1 FROM hrai_file
	     	      WHERE hrai03=g_hraz_1[g_cnt].hraz12_1
	     	     SELECT hrai04 INTO g_hraz_1[g_cnt].hraz11_1 FROM hrai_file
	     	      WHERE hrai03=g_hraz_1[g_cnt].hraz11_1
	     	     SELECT hraf02 INTO g_hraz_1[g_cnt].hraz14_1 FROM hraf_file
	     	      WHERE hraf01=g_hraz_1[g_cnt].hraz14_1
	     	     SELECT hraf02 INTO g_hraz_1[g_cnt].hraz13_1 FROM hraf_file
	     	      WHERE hraf01=g_hraz_1[g_cnt].hraz13_1     
	     	     LET g_cnt=g_cnt+1
	     	  END FOREACH
	     	  
	     	  LET l_jump=l_jump+1
	     	  
	     END FOREACH
	     
	     CALL g_hraz_1.deleteElement(g_cnt)
             CALL g_hraz1.deleteElement(g_cnt)
	     LET g_rec_b1=g_cnt-1
	     DISPLAY g_rec_b1 TO FORMONLY.bs #add by wangwy 20170209
             LET g_cnt=0
	     
END FUNCTION
	
FUNCTION i016_confirm()
DEFINE l_n,l_n1 LIKE type_file.num5
   IF s_shut(0) THEN
      RETURN
   END IF
   	
   IF cl_null(g_hraz_h.hraz01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   SELECT COUNT(*) INTO l_n FROM hraz_file
    WHERE hraz01 = g_hraz_h.hraz01
   IF g_hraz_h.hraz44 = 'Y' THEN 
      SELECT hrap10 - hrap11 INTO l_n1 FROM hrap_file
       WHERE hrap01 = g_hraz_h.hraz08
         AND hrap05 = g_hraz_h.hraz10
      IF l_n1 < l_n  THEN 
         CALL cl_err('','ghr-261',1)
         RETURN 
      END IF    
   END IF  	
   IF g_hraz_h.hraz18='004' THEN
   	  CALL cl_err('资料已归档不可做任何操作','!',0)
   	  RETURN
   END IF
   	
   IF g_hraz_h.hraz18='003' THEN
   		CALL cl_err('资料已审核不可再次审核','!',0)
   		RETURN
   END IF
           				  	
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_hraz_h_t.*=g_hraz_h.*
   BEGIN WORK
   OPEN i016_lock_u USING g_hraz_h.hraz01
   IF STATUS THEN
      CALL cl_err("DATA LOCK:",STATUS,1)
      CLOSE i016_lock_u
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i016_lock_u INTO g_hraz_h.*
   IF SQLCA.sqlcode THEN
      CALL cl_err("hraz01 LOCK:",SQLCA.sqlcode,1)
      CLOSE i016_lock_u
      ROLLBACK WORK
      RETURN
   END IF
 
    CALL i016_show()
    IF cl_confirm("是否确认审核?") THEN
    	  
       UPDATE hraz_file
          SET hraz18='003',hraz23=g_today,hraz24=g_user
        WHERE hraz01=g_hraz_h.hraz01
       IF SQLCA.SQLERRD[3]=0 THEN
          CALL cl_err(g_hraz_h.hraz01,SQLCA.sqlcode,0)
          ROLLBACK WORK
       #add by zhangbo130726---begin
       ELSE
          IF g_hraz_h.hraz05<=g_today THEN
             UPDATE hraz_file
                SET hraz42='Y'
              WHERE hraz01=g_hraz_h.hraz01
             IF SQLCA.SQLERRD[3]=0 THEN
                CALL cl_err(g_hraz_h.hraz01,SQLCA.sqlcode,0)
                ROLLBACK WORK
             ELSE
                 CALL i016_gx_hrat()
                 IF g_success='N' THEN
                          ROLLBACK WORK
                 END IF
             END IF
          END IF
       #add by zhangbo130726---end
       END IF
    END IF
    COMMIT WORK
    SELECT hraz18,hraz23,hraz24 INTO g_hraz_h.hraz18,g_hraz_h.hraz23,g_hraz_h.hraz24 FROM hraz_file
     WHERE hraz01 = g_hraz_h.hraz01
    DISPLAY BY NAME g_hraz_h.hraz18,g_hraz_h.hraz23,g_hraz_h.hraz24
    CALL i016_hraz_fill()
END FUNCTION
	
FUNCTION i016_undo_confirm()
DEFINE l_n,l_n1 LIKE type_file.num5
DEFINE l_hraz07 LIKE hraz_file.hraz07
DEFINE l_hraz09 LIKE hraz_file.hraz09
DEFINE l_sql STRING
	 IF s_shut(0) THEN
      RETURN
   END IF
   	
   IF cl_null(g_hraz_h.hraz01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   	
   IF g_hraz_h.hraz18='004' THEN
   	  CALL cl_err('资料已归档不可做任何操作','!',0)
   	  RETURN
   END IF
   	
   IF g_hraz_h.hraz18='001' OR g_hraz_h.hraz18='002' THEN
   		CALL cl_err('资料未审核不可取消审核','!',0)
   		RETURN
   END IF
   	
   IF NOT cl_null(g_hraz_h.hraz37) THEN
   	  CALL cl_err('表单单号不为空,不可取消审核','!',0)
   	  RETURN
   END IF	  	
   LET l_sql = " SELECT hrat04,hrat05,count(*) from hraz_file ",
               "  WHERE hraz01 = '",g_hraz_h.hraz01,"' AND hratid = hraz03 and hrat09 = 'Y' ",
               "  group by hrat04,hrat05 "   
   PREPARE i016_js FROM l_sql
   DECLARE i016_js_s CURSOR FOR i016_js
   FOREACH i016_js_s INTO l_hraz07,l_hraz09,l_n
   IF g_hraz_h.hraz44 = 'Y' THEN 
      SELECT hrap10 - hrap11 INTO l_n1 FROM hrap_file
       WHERE hrap01 = l_hraz07
         AND hrap05 = l_hraz09
      IF l_n1 < l_n  THEN 
         CALL cl_err('','ghr-261',1)
         EXIT FOREACH
         RETURN 
      END IF    
   END IF      
   END FOREACH     				  	
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_hraz_h_t.*=g_hraz_h.*
   BEGIN WORK
   OPEN i016_lock_u USING g_hraz_h.hraz01
   IF STATUS THEN
      CALL cl_err("DATA LOCK:",STATUS,1)
      CLOSE i016_lock_u
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i016_lock_u INTO g_hraz_h.*
   IF SQLCA.sqlcode THEN
      CALL cl_err("hraz01 LOCK:",SQLCA.sqlcode,1)
      CLOSE i016_lock_u
      ROLLBACK WORK
      RETURN
   END IF
 
    CALL i016_show()
    IF cl_confirm("是否确认取消审核?") THEN
    	  
       UPDATE hraz_file
          SET hraz18='001',hraz27=g_today,hraz28=g_user,hraz42='N'    #mod by zhangbo130726
        WHERE hraz01=g_hraz_h.hraz01
       IF SQLCA.SQLERRD[3]=0 THEN
          CALL cl_err(g_hraz_h.hraz01,SQLCA.sqlcode,0)
          ROLLBACK WORK
       ELSE
       	  IF g_hraz_h.hraz05<=g_today THEN
       	  	 CALL i016_upd_hrat()
       	  	 IF g_success='N' THEN
       	  	 	  ROLLBACK WORK
       	  	 END IF	  
       	  END IF   
       END IF
    END IF
    COMMIT WORK
    SELECT hraz18,hraz27,hraz28 INTO g_hraz_h.hraz18,g_hraz_h.hraz27,g_hraz_h.hraz28 FROM hraz_file
     WHERE hraz01 = g_hraz_h.hraz01
    DISPLAY BY NAME g_hraz_h.hraz18,g_hraz_h.hraz27,g_hraz_h.hraz28
    CALL i016_hraz_fill()		
	
END FUNCTION	 	
	
FUNCTION i016_guidang()
 	 IF s_shut(0) THEN
      RETURN
   END IF
   	
   IF cl_null(g_hraz_h.hraz01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   	
   IF g_hraz_h.hraz18='004' THEN
   	  CALL cl_err('资料已归档不可做任何操作','!',0)
   	  RETURN
   END IF
   	
   IF g_hraz_h.hraz18='001' OR g_hraz_h.hraz18='002' THEN
   		CALL cl_err('资料未审核不可归档','!',0)
   		RETURN
   END IF
   	 	
   				  	
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_hraz_h_t.*=g_hraz_h.*
   BEGIN WORK
   OPEN i016_lock_u USING g_hraz_h.hraz01
   IF STATUS THEN
      CALL cl_err("DATA LOCK:",STATUS,1)
      CLOSE i016_lock_u
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i016_lock_u INTO g_hraz_h.*
   IF SQLCA.sqlcode THEN
      CALL cl_err("hraz01 LOCK:",SQLCA.sqlcode,1)
      CLOSE i016_lock_u
      ROLLBACK WORK
      RETURN
   END IF
 
    CALL i016_show()
    IF cl_confirm("是否确认归档?") THEN
    	  
       UPDATE hraz_file
          SET hraz18='004',hraz25=g_today,hraz26=g_user
        WHERE hraz01=g_hraz_h.hraz01
       IF SQLCA.SQLERRD[3]=0 THEN
          CALL cl_err(g_hraz_h.hraz01,SQLCA.sqlcode,0)
          ROLLBACK WORK
       END IF
    END IF
    COMMIT WORK
    SELECT hraz18,hraz25,hraz26 INTO g_hraz_h.hraz18,g_hraz_h.hraz25,g_hraz_h.hraz26 FROM hraz_file
     WHERE hraz01 = g_hraz_h.hraz01
    DISPLAY BY NAME g_hraz_h.hraz18,g_hraz_h.hraz25,g_hraz_h.hraz26
    CALL i016_hraz_fill()		
	
END FUNCTION
	
FUNCTION i016_upd_hrat()
DEFINE l_sql   STRING
DEFINE l_hraz  RECORD
         hraz03     LIKE    hraz_file.hraz03,
         hraz43     LIKE    hraz_file.hraz43,
         hraz32     LIKE    hraz_file.hraz32,
         hraz30     LIKE    hraz_file.hraz30,
         hraz07     LIKE    hraz_file.hraz07,
         hraz09     LIKE    hraz_file.hraz09,
         hraz40     LIKE    hraz_file.hraz40,
         hraz33     LIKE    hraz_file.hraz33,
         hraz13     LIKE    hraz_file.hraz13,
         hraz15     LIKE    hraz_file.hraz15,
         hraz11     LIKE    hraz_file.hraz11,
         hraz38     LIKE    hraz_file.hraz38,
         hraz44     LIKE    hraz_file.hraz44,
         hrazud01   LIKE    hraz_file.hrazud01,
         hrazud04   LIKE    hraz_file.hrazud04,
         hrazud05   LIKE    hraz_file.hrazud05,
         hrazud07   LIKE    hraz_file.hrazud07,
         ta_hraz02  LIKE    hraz_file.ta_hraz02
                 END RECORD
DEFINE l_hrat04     LIKE hrat_file.hrat04         
DEFINE l_hrat05     LIKE hrat_file.hrat05         
DEFINE l_hrat06     LIKE hrat_file.hrat06 
DEFINE l_hrat09     LIKE hrat_file.hrat09  
DEFINE l_hrcp01     LIKE hrap_file.hrap01,
       l_hrap05     LIKE hrap_file.hrap05 
       
   LET g_success='Y'
   LET l_sql=" SELECT hraz03,hraz43,hraz32,hraz30,hraz07,hraz09,hraz40,",
             "        hraz33,hraz13,hraz15,hraz11,hraz38,hraz44,hrazud01,hrazud04,hrazud05,hrazud07,ta_hraz02 ",
   	         "   FROM hraz_file ",
   	         "  WHERE hraz01='",g_hraz_h.hraz01,"'"
   PREPARE i016_updhrat_pre FROM l_sql
   DECLARE i016_updhrat_cs CURSOR FOR i016_updhrat_pre
   
   FOREACH i016_updhrat_cs INTO l_hraz.*
      SELECT hrat04,hrat05,hrat09 INTO l_hrat04,l_hrat05,l_hrat09 FROM hrat_file
       WHERE hratid=l_hraz.hraz03
       
      UPDATE hrat_file SET 
                           hrat03=l_hraz.hraz30,
                           hrat04=l_hraz.hraz07,
                           hrat05=l_hraz.hraz09,
                           hrat64=l_hraz.hraz40,
                           hrat06=l_hraz.hraz33,
                           hrat40=l_hraz.hraz13,
                           hrat41=l_hraz.hraz15,
                           hrat42=l_hraz.hraz11,        
                           hrat09=l_hraz.hraz44,
                           hrat21=l_hraz.hraz38,
                           hrat87=l_hraz.hrazud04,
                           hrat88=l_hraz.hrazud05,
                           hrat20=l_hraz.hrazud07,
                           hrat60 = l_hraz.ta_hraz02
                     WHERE hratid=l_hraz.hraz03
                     
      IF SQLCA.sqlcode THEN
      	 CALL cl_err('还原员工信息出错','!',0) 
      	 LET g_success='N'
      	 EXIT FOREACH
     #add by zhuzw 20140627 start 
      ELSE 
      	IF l_hraz.hraz44 = 'Y' THEN 
      	   UPDATE hrap_file 
              SET hrap11 = hrap11 +1 ,
                  hrap12 = hrap12 +1 
           WHERE hrap01 = l_hraz.hraz07
             AND hrap05 = l_hraz.hraz09
           UPDATE hrap_file 
              SET 
                  hrap14 = hrap14 +1 ,
                  hrap15 = hrap15 +1
           WHERE hrap01 = l_hraz.hraz07
        ELSE 
           UPDATE hrap_file 
              SET hrap12 = hrap12 +1        	             
           WHERE hrap01 = l_hraz.hraz07
             AND hrap05 = l_hraz.hraz09                	    	          
           UPDATE hrap_file 
              SET 
                  hrap15 = hrap15 +1
           WHERE hrap01 = l_hraz.hraz07	 
        END IF 
        IF l_hrat09 = 'Y' THEN 
           UPDATE hrap_file 
              SET hrap11 = hrap11 -1 ,
                  hrap12 = hrap12 -1 
           WHERE hrap01 = l_hrat04
             AND hrap05 = l_hrat05   
           UPDATE hrap_file 
              SET 
                  hrap14 = hrap14 -1 ,
                  hrap15 = hrap15 -1
           WHERE hrap01 = l_hrat04
        ELSE 
           UPDATE hrap_file 
              SET hrap12 = hrap12 -1        	             
           WHERE hrap01 = l_hrat04
             AND hrap05 = l_hrat05               	    	          
           UPDATE hrap_file 
              SET 
                  hrap15 = hrap15 -1
           WHERE hrap01 = l_hrat04             	    	          
        END IF         	 	     
        
      #add by zhuzw 20140627 end   
      END IF	 
   END FOREACH                              	         
END FUNCTION		
	
FUNCTION i016_gx_hrat()
DEFINE l_sql   STRING
DEFINE l_sql1   STRING
DEFINE l_hraz  RECORD
         hraz03     LIKE    hraz_file.hraz03,
         hraz43     LIKE    hraz_file.hraz43,
         hraz32     LIKE    hraz_file.hraz32,
         hraz31     LIKE    hraz_file.hraz31,
         hraz08     LIKE    hraz_file.hraz08,
         hrazud02   LIKE    hraz_file.hrazud02,
         hrazud03   LIKE    hraz_file.hrazud03,
         hrazud06   LIKE    hraz_file.hrazud06,
         hraz10     LIKE    hraz_file.hraz10,
         hraz41     LIKE    hraz_file.hraz41,
         hraz34     LIKE    hraz_file.hraz34,
         hraz14     LIKE    hraz_file.hraz14,
         hraz16     LIKE    hraz_file.hraz16,
         hraz12     LIKE    hraz_file.hraz12,
         hraz39     LIKE    hraz_file.hraz39,
         hraz44     LIKE    hraz_file.hraz44,
         hrazud01   LIKE    hraz_file.hrazud01,
         ta_hraz01  LIKE    hraz_file.ta_hraz01
                 END RECORD
DEFINE l_hrat04     LIKE hrat_file.hrat04         
DEFINE l_hrat05     LIKE hrat_file.hrat05        
DEFINE l_hrat06     LIKE hrat_file.hrat06  
DEFINE l_hrat09     LIKE hrat_file.hrat09 
DEFINE l_hraz05,l_hrct08 LIKE hrct_file.hrct08 #add by zhuzw 20150430
DEFINE l_hrap01     LIKE hrap_file.hrap01,
       l_hrap05     LIKE hrap_file.hrap05
       

   LET g_success='Y'
   LET l_sql=" SELECT hraz03,hraz43,hraz32,hraz31,hraz08,hrazud02,hrazud03,hrazud06,hraz10,hraz41, ",
             "        hraz34,hraz14,hraz16,hraz12,hraz39,hraz44,hrazud01,ta_hraz01 ",
                 "   FROM hraz_file ",
                 "   WHERE hraz01='",g_hraz_h.hraz01,"'"
   PREPARE i016_gxhrat_pre FROM l_sql
   DECLARE i016_gxhrat_cs CURSOR FOR i016_gxhrat_pre
   
   FOREACH i016_gxhrat_cs INTO l_hraz.*
      SELECT hrat01 INTO l_hraz.hraz34 FROM hrat_file WHERE hratid=l_hraz.hraz34
      SELECT hrat04,hrat05,hrat09 INTO l_hrat04,l_hrat05,l_hrat09 FROM hrat_file
       WHERE hratid=l_hraz.hraz03
      #add by zhuzw 20150430 str 
      SELECT MIN(hrct08) INTO l_hrct08 FROM hrct_file 
       WHERE hrct06='N'
      SELECT hraz05 INTO l_hraz05 FROM hraz_file 
       WHERE hraz01 = g_hraz_h.hraz01   
      #IF l_hraz05<= l_hrct08 THEN   
      IF l_hraz05<= g_today THEN  
      #add 20150430 end
            LET l_sql1 = "UPDATE hrat_file SET "
     IF l_hraz.hraz31 !='-' OR cl_null(l_hraz.hraz31) THEN LET l_sql1 = l_sql1, " hrat03 = '",l_hraz.hraz31,"'," END IF 
     IF l_hraz.hraz08 !='-' OR cl_null(l_hraz.hraz08) THEN LET l_sql1 = l_sql1, " hrat04 = '",l_hraz.hraz08,"'," END IF 
     IF NOT cl_null(l_hraz.hraz10)   THEN LET l_sql1 = l_sql1, " hrat05 = '",l_hraz.hraz10,"'," END IF 
     IF NOT cl_null(l_hraz.hraz41)   THEN LET l_sql1 = l_sql1, " hrat64 = '",l_hraz.hraz41,"'," END IF 
     IF NOT cl_null(l_hraz.hraz34)   THEN LET l_sql1 = l_sql1, " hrat06 = '",l_hraz.hraz34,"'," END IF 
     IF NOT cl_null(l_hraz.hraz14)   THEN LET l_sql1 = l_sql1, " hrat40 = '",l_hraz.hraz14,"'," END IF 
     IF NOT cl_null(l_hraz.hraz16)   THEN LET l_sql1 = l_sql1, " hrat41 = '",l_hraz.hraz16,"'," END IF 
     IF NOT cl_null(l_hraz.hraz12)   THEN LET l_sql1 = l_sql1, " hrat42 = '",l_hraz.hraz12,"'," END IF 
     IF l_hraz.hrazud02 != '-' OR cl_null(l_hraz.hrazud02) THEN LET l_sql1 = l_sql1, " hrat87 = '",l_hraz.hrazud02,"'," END IF 
     IF l_hraz.hrazud03 != '-' OR cl_null(l_hraz.hrazud03) THEN LET l_sql1 = l_sql1, " hrat88 = '",l_hraz.hrazud03,"'," END IF 
     IF NOT cl_null(l_hraz.hrazud06) THEN LET l_sql1 = l_sql1, "hrat20 = '",l_hraz.hrazud06,"'," END IF 
     IF NOT cl_null(l_hraz.hraz44)   THEN LET l_sql1 = l_sql1, " hrat09 = '",l_hraz.hraz44,"'," END IF 
     IF NOT cl_null(l_hraz.hraz39)   THEN LET l_sql1 = l_sql1, " hrat21 = '",l_hraz.hraz39,"'," END IF 
     IF NOT cl_null(l_hraz.ta_hraz01)   THEN LET l_sql1 = l_sql1, " hrat60 = '",l_hraz.ta_hraz01,"'," END IF 
     LET l_sql1 = l_sql1, " hrat01 = hrat01 WHERE hratid = '",l_hraz.hraz03,"'"
     PREPARE p016_03 FROM l_sql1
     EXECUTE p016_03
#         UPDATE hrat_file SET hrat01=l_hraz.hraz32,
#                           hrat03=l_hraz.hraz31,
#                           hrat04=l_hraz.hraz08,
#                           hrat05=l_hraz.hraz10,
#                           hrat64=l_hraz.hraz41,
#                           hrat06=l_hraz.hraz34,
#                           hrat40=l_hraz.hraz14,
#                           hrat41=l_hraz.hraz16,
#                           hrat42=l_hraz.hraz12,
#                           hrat09=l_hraz.hraz44,
#                           hrat21=l_hraz.hraz39
#                     WHERE hratid=l_hraz.hraz03
#      ELSE 
#         UPDATE hrat_file SET hrat01=l_hraz.hraz32,
#                           hrat03=l_hraz.hraz31,
#                           hrat04=l_hraz.hraz08,
#                           hrat05=l_hraz.hraz10,
#                           hrat64=l_hraz.hraz41,
#                           hrat06=l_hraz.hraz34,
#                           hrat40=l_hraz.hraz14,
#                           hrat41=l_hraz.hraz16,
#                           hrat09=l_hraz.hraz44,
#                           hrat21=l_hraz.hraz39
#                     WHERE hratid=l_hraz.hraz03
      END IF 	               
      IF SQLCA.sqlcode THEN
         CALL cl_err('更新员工信息出错','!',0)
         LET g_success='N'
         EXIT FOREACH
      ELSE 
      	 IF l_hraz.hraz44 = 'Y' THEN 
      	    UPDATE hrap_file 
        	      SET hrap11 = hrap11 +1 ,
        	          hrap12 = hrap12 +1 
        	   WHERE hrap01 = l_hraz.hraz08
        	     AND hrap05 = l_hraz.hraz10
        	   UPDATE hrap_file 
        	      SET 
        	          hrap14 = hrap14 +1 ,
        	          hrap15 = hrap15 +1
        	   WHERE hrap01 = l_hraz.hraz08
        	ELSE 
        	   UPDATE hrap_file 
        	      SET hrap12 = hrap12 +1        	             
        	   WHERE hrap01 = l_hraz.hraz08
        	     AND hrap05 = l_hraz.hraz10                	    	          
        	   UPDATE hrap_file 
        	      SET 
        	          hrap15 = hrap15 +1
        	   WHERE hrap01 = l_hraz.hraz08 
        	END IF 
          IF l_hrat09 = 'Y' THEN 
             UPDATE hrap_file 
                SET hrap11 = hrap11 -1 ,
                    hrap12 = hrap12 -1 
             WHERE hrap01 = l_hrat04
               AND hrap05 = l_hrat05   
             UPDATE hrap_file 
                SET 
                    hrap14 = hrap14 -1 ,
                    hrap15 = hrap15 -1
             WHERE hrap01 = l_hrat04
          ELSE 
             UPDATE hrap_file 
                SET hrap12 = hrap12 -1        	             
             WHERE hrap01 = l_hrat04
               AND hrap05 = l_hrat05               	    	          
             UPDATE hrap_file 
                SET 
                    hrap15 = hrap15 -1
             WHERE hrap01 = l_hrat04             	    	          
          END IF
      END IF
   END FOREACH
END FUNCTION

#课别
FUNCTION i016_hrazud02(p_cmd)
DEFINE p_cmd    LIKE type_file.chr1
DEFINE l_hrao02 LIKE hrao_file.hrao02
DEFINE l_hraoacti LIKE hrao_file.hraoacti

   LET g_errno = ''
   SELECT hrao02,hraoacti INTO l_hrao02,l_hraoacti
     FROM hrao_file
    WHERE hrao01=g_hraz_h.hrazud02
      AND hraoud05='2'
      AND hraoacti='Y'
   CASE WHEN SQLCA.sqlcode = 100
        LET g_errno = 'alm-009'
      WHEN l_hraoacti <> 'Y'
         LET g_errno = 'ghr-270'
      OTHERWISE
         LET g_errno = SQLCA.sqlcode USING '-----'
   END CASE
   IF p_cmd='d' OR p_cmd='u' OR cl_null(g_errno) THEN
      IF cl_null(g_hraz_h.hrazud02) THEN
         LET l_hrao02 = NULL
      END IF
      DISPLAY l_hrao02 TO hrao02_1
   END IF
END FUNCTION

#XIN组别
FUNCTION i016_hrazud03(p_cmd)
DEFINE p_cmd    LIKE type_file.chr1
DEFINE l_hrao02 LIKE hrao_file.hrao02
DEFINE l_hraoacti LIKE hrao_file.hraoacti

   LET g_errno = ''
   SELECT hrao02,hraoacti INTO l_hrao02,l_hraoacti
     FROM hrao_file
    WHERE hrao01=g_hraz_h.hrazud03
      AND hraoud05='3'
      AND hraoacti='Y'
   CASE WHEN SQLCA.sqlcode = 100
        LET g_errno = 'alm-009'
      WHEN l_hraoacti <> 'Y'
         LET g_errno = 'ghr-271'
      OTHERWISE
         LET g_errno = SQLCA.sqlcode USING '-----'
   END CASE
   IF p_cmd='d' OR p_cmd='u' OR  cl_null(g_errno) THEN
      IF cl_null(g_hraz_h.hrazud03) THEN
         LET l_hrao02 = NULL
      END IF
      DISPLAY l_hrao02 TO hrao02_2
   END IF
END FUNCTION

#组别
FUNCTION i016_hrazud04(p_cmd)
DEFINE p_cmd    LIKE type_file.chr1
DEFINE l_hrao02 LIKE hrao_file.hrao02
DEFINE l_hraoacti LIKE hrao_file.hraoacti

   LET g_errno = ''
   SELECT hrao02,hraoacti INTO l_hrao02,l_hraoacti
     FROM hrao_file
    WHERE hrao01=g_hraz[l_ac].hrazud04
      AND hraoud05='2'
      AND hraoacti='Y'
   CASE WHEN SQLCA.sqlcode = 100
        LET g_errno = 'alm-009'
      WHEN l_hraoacti <> 'Y'
         LET g_errno = 'ghr-270'
      OTHERWISE
         LET g_errno = SQLCA.sqlcode USING '-----'
   END CASE
   IF p_cmd='d' OR p_cmd='u' OR cl_null(g_errno) THEN
      IF cl_null(g_hraz[l_ac].hrazud04) THEN
         LET l_hrao02 = NULL
      END IF
      DISPLAY l_hrao02 TO g_hraz[l_ac].hrazud04_desc
   END IF
END FUNCTION

#组别
FUNCTION i016_hrazud05(p_cmd)
DEFINE p_cmd    LIKE type_file.chr1
DEFINE l_hrao02 LIKE hrao_file.hrao02
DEFINE l_hraoacti LIKE hrao_file.hraoacti

   LET g_errno = ''
   SELECT hrao02,hraoacti INTO l_hrao02,l_hraoacti
     FROM hrao_file
    WHERE hrao01=g_hraz[l_ac].hrazud05
      AND hraoud05='3'
      AND hraoacti='Y'
   CASE WHEN SQLCA.sqlcode = 100
        LET g_errno = 'alm-009'
      WHEN l_hraoacti <> 'Y'
         LET g_errno = 'ghr-271'
      OTHERWISE
         LET g_errno = SQLCA.sqlcode USING '-----'
   END CASE
   IF p_cmd='d' OR p_cmd='u' OR cl_null(g_errno) THEN
      IF cl_null(g_hraz[l_ac].hrazud05) THEN
         LET l_hrao02 = NULL
      END IF
      DISPLAY l_hrao02 TO g_hraz[l_ac].hrazud05_desc
   END IF
END FUNCTION
