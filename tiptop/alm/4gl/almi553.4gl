# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: almi553.4gl
# Descriptions...: 生效范围作业
# Date & Author..: NO.FUN-960058 09/06/12 By  destiny  
# Modify.........: No.FUN-9B0136 09/11/27 By shiwuying
# Modify.........: No:FUN-A10060 10/01/13 By shiwuying 權限處理
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:FUN-A40015 10/04/06 By shiwuying 門店改抓azw01,lma02->azp02
# Modify.........: No:FUN-A60064 10/06/24 By chenls 非T/S類table中的xxxplant替換成xxxstore
# Modify.........: No:FUN-A60010 10/07/14 By huangtao 小类代号用產品分類代替,刪除大類和中類
# Modify.........: NO:FUN-A80148 10/09/01 By wangxin 因為lma_file已不使用,所以將lma_file改為rtz_file的相應欄位
# Modify.........: NO:FUN-B30174 11/03/35 By huangtao 生效範圍中生效門店編號改為複選
# Modify.........: No.FUN-C50085 12/05/18 By pauline 積分換券優化處理 
# Modify.........: No.FUN-C60089 12/07/20 By pauline 調整lni02分類欄位內容 
# Modify.........: No.CHI-C80047 12/08/21 By pauline 將卡種納入PK值
# Modify.........: No:FUN-D30033 13/04/09 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
#No.FUN-960058--begin 
DEFINE 
     g_lni           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        lniplant    LIKE lni_file.lniplant,
        azp02       LIKE azp_file.azp02,
        lni04       LIKE lni_file.lni04,  
        azp02_1     LIKE azp_file.azp02,    
        lni08       LIKE lni_file.lni08,   
#        lni05       LIKE lni_file.lni05,         #FUN-A60010
#        lmi02       LIKE lmi_file.lmi02,         #FUN-A60010
#        lni06       LIKE lni_file.lni06,         #FUN-A60010 
#        lmj02       LIKE lmj_file.lmj02,         #FUN-A60010
        lni07       LIKE lni_file.lni07,
#        lmk02       LIKE lmk_file.lmk02,         #FUN-A60010
        oba02       LIKE oba_file.oba02,          #FUN-A60010 add
        lni13       LIKE lni_file.lni13
                    END RECORD,
     g_lni_t         RECORD                #程式變數 (舊值)
        lniplant    LIKE lni_file.lniplant,
        azp02       LIKE azp_file.azp02,
        lni04       LIKE lni_file.lni04,  
        azp02_1     LIKE azp_file.azp02,    
        lni08       LIKE lni_file.lni08,   
#        lni05       LIKE lni_file.lni05,         #FUN-A60010
#        lmi02       LIKE lmi_file.lmi02,         #FUN-A60010
#        lni06       LIKE lni_file.lni06,         #FUN-A60010 
#        lmj02       LIKE lmj_file.lmj02,         #FUN-A60010
        lni07       LIKE lni_file.lni07,
#        lmk02       LIKE lmk_file.lmk02,         #FUN-A60010
        oba02       LIKE oba_file.oba02,          #FUN-A60010 add
        lni13       LIKE lni_file.lni13
                    END RECORD,
   #g_wc2,g_sql     LIKE type_file.chr1000,       #FUN-C60089 mark
    g_wc2,g_sql     STRING,                       #FUN-C60089 add   
    g_rec_b         LIKE type_file.num5,                #單身筆數     
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT        
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL       
DEFINE g_argv1      LIKE lni_file.lni01
DEFINE g_argv2      LIKE lni_file.lni02
DEFINE g_cnt        LIKE type_file.num10    
DEFINE g_i          LIKE type_file.num5     #count/index for any purpose        
DEFINE g_before_input_done   LIKE type_file.num5        
DEFINE g_argv3      LIKE lst_file.lst14     #FUN-C50085 add 
DEFINE g_lst00      LIKE lst_file.lst00     #FUN-C60089 add 
DEFINE g_lst03      LIKE lst_file.lst03     #CHI-C80047 add  #卡種
MAIN
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP    #No.FUN-9B0136
    #   FIELD ORDER FORM #No.FUN-9B0136
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理

   LET g_argv1=ARG_VAL(1)                
   LET g_argv2=ARG_VAL(2)               
   LET g_argv3 = ARG_VAL(3)  #FUN-C50085 add  
   LET g_lst03 = ARG_VAL(4)  #CHI-C80047 add 
   
   
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF
   
   CALL cl_used(g_prog,g_time,1) RETURNING g_time    
 
    OPEN WINDOW i553_w WITH FORM "alm/42f/almi553"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    CALL cl_ui_init()
    IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) THEN 
       LET g_wc2 = '1=1' 
       CALL i553_b_fill(g_wc2)
    END IF 
   #FUN-C50085 add START
   #IF g_argv2 = '1' OR g_argv2 = '2' THEN   #FUN-C60089 mark
    IF g_argv2 = '1' OR g_argv2 = '2' OR     #FUN-C60089 add
       g_argv2 = '3' OR g_argv2 = '4' THEN   #FUN-C60089 add
       CALL cl_set_comp_visible("lniplant,azp02,lni07,lni08,oba02",FALSE)
    END IF
    IF cl_null(g_argv3 ) THEN 
       LET g_argv3 = g_plant
    END IF
   #FUN-C50085 add END
   #FUN-C60089 add START
    IF g_argv2 = '1' OR g_argv2 = '3' THEN  #almi590/almi600
       LET g_lst00 = '0'  
    END IF
    IF g_argv2 = '2' OR g_argv2 = '4' THEN  #almi591/almi601
       LET g_lst00 = '1'
    END IF    
   #FUN-C60089 add END
    CALL i553_menu()
    CLOSE WINDOW i553_w                    #結束畫面
 
    CALL cl_used(g_prog,g_time,2) RETURNING g_time    
END MAIN
 
FUNCTION i553_menu()
 DEFINE l_cmd   LIKE type_file.chr1000 
                                
   WHILE TRUE
      CALL i553_bp("G")
      CASE g_action_choice
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i553_b()  
            END IF
#         WHEN "output"
#            IF cl_chk_act_auth() THEN
#               CALL i553_out()                                        
#            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "related_document"  
            IF cl_chk_act_auth() AND l_ac != 0 THEN 
               IF g_lni[l_ac].lni04 IS NOT NULL THEN
                  LET g_doc.column1 = "lni04"
                  LET g_doc.value1 = g_lni[l_ac].lni04
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_lni),'','')
            END IF
 
        #FUN-C50085 add START
         WHEN "del_all_plant"
            IF cl_chk_act_auth() THEN
               CALL i553_del_all_plant()
            END IF
        #FUN-C50085 add END

      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i553_b()
DEFINE
   l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        
   l_n             LIKE type_file.num5,                #檢查重複用       
   l_n1            LIKE type_file.num5,
   l_n2            LIKE type_file.num5,
   l_n3            LIKE type_file.num5,
   l_lock_sw       LIKE type_file.chr1,                #單身鎖住否       
   p_cmd           LIKE type_file.chr1,                #處理狀態        
   l_allow_insert  LIKE type_file.chr1,                #可新增否
   l_allow_delete  LIKE type_file.chr1,                #可刪除否
#   l_lmk05         LIKE lmk_file.lmk05,                #FUN-A60010 
   l_lni02         LIKE lni_file.lni02,
   l_count         LIKE type_file.num5,
   l_cot           LIKE type_file.num5,
   l_lst09         LIKE lst_file.lst09,
   l_lpq08         LIKE lpq_file.lpq08,
   l_azp02         LIKE azp_file.azp02
#FUN-B30174 --------------STA
DEFINE tok         base.StringTokenizer
DEFINE l_plant     LIKE azw_file.azw01
DEFINE l_flag      LIKE type_file.chr1
DEFINE l_azw02     LIKE azw_file.azw02
DEFINE l_lst14     LIKE lst_file.lst14   #FUN-C50085 add  #制定營運中心

   LET l_flag = 'N'
#FUN-B30174 --------------END 
   
   IF s_shut(0) THEN RETURN END IF
   CALL cl_opmsg('b')
   LET g_action_choice = ""
   IF cl_null(g_argv1) OR cl_null(g_argv2) THEN 
      CALL cl_err('','alm-836',1)
      RETURN 
   END IF 
  #IF g_argv2='1' THEN   #FUN-C60089 mark
   IF g_argv2 = '1' OR g_argv2 = '2' THEN   #FUN-C60089 add 
      SELECT lst09 INTO l_lst09 FROM lst_file WHERE lst01=g_argv1
        AND lst00 = g_lst00    #FUN-C60089 add
        AND lst03 = g_lst03    #CHI-C80047 add
        AND lst14 = g_argv3    #FUN-C50085 add
        AND lstplant = g_plant  #FUN-C60089 ad
      IF l_lst09 ='Y' THEN 
         CALL cl_err(g_argv1,'abm-879',1)
         RETURN 
      END IF 
     #FUN-C50085 add START
      SELECT lst14 INTO l_lst14 FROM lst_file WHERE lst01 = g_argv1 
         AND lst00 = g_lst00      #FUN-C60089 add
         AND lst03 = g_lst03      #CHI-C80047 add
         AND lst14 = g_argv3      #FUN-C50085 add
         AND lstplant = g_plant   #FUN-C60089 add
      IF g_plant <> l_lst14 THEN
         CALL cl_err('','art-977',0)
         RETURN
      END IF
     #FUN-C50085 add END
   ELSE 
      SELECT lpq08 INTO l_lpq08 FROM lpq_file WHERE lpq01=g_argv1
         AND lpq00 = g_lst00     #FUN-C60089 add
         AND lpq03 = g_lst03     #CHI-C80047 add
         AND lpq13 = g_argv3     #FUN-C50085 add
         AND lpqplant = g_plant  #FUN-C60089 add
      IF l_lpq08 ='Y' THEN 
         CALL cl_err(g_argv1,'abm-879',1)
         RETURN 
      END IF 
     #FUN-C50085 add START
      SELECT lpq13 INTO l_lst14 FROM lpq_file WHERE lpq01 = g_argv1
         AND lpq00 = g_lst00      #FUN-C60089 add
         AND lpq03 = g_lst03      #CHI-C80047 add
         AND lpq13 = g_argv3      #FUN-C50085 add
         AND lpqplant = g_plant   #FUN-C60089 add
      IF g_plant <> l_lst14 THEN
         CALL cl_err('','art-977',0)
         RETURN
      END IF
     #FUN-C50085 add END
   END IF    
    
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
 
   LET g_forupd_sql = "SELECT lniplant,'',lni04,'',lni08,lni07,'',lni13 ",    #FUN-A60010 
                      "  FROM lni_file WHERE lni01='",g_argv1,"' AND lni02='",g_argv2,"' ",
                      "  AND lni14 = '",g_argv3,"' ",  #FUN-C50085 add
                      "  AND lni15 = '",g_lst03,"' ",  #CHI-C80047 add
                      "  AND lni04= ? AND lni08= ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i553_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   INPUT ARRAY g_lni WITHOUT DEFAULTS FROM s_lni.*
     ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert) 
 
       BEFORE INPUT
          IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(l_ac)
          END IF
         #FUN-C50085 add START
          IF cl_null(g_argv2 ) THEN
             CALL cl_set_act_visible('del_all_plant',FALSE)
          END IF
         #IF g_argv2 = '1' OR g_argv2 = '2' THEN  #FUN-C60089 mark
          IF g_argv2 = '1' OR g_argv2 = '2' OR g_argv2 = '3' OR g_argv2 = '4' THEN    #FUN-C60089 add
             CALL cl_set_comp_entry("lni13",FALSE) 
          END IF
         #FUN-C50085 add END
 
       BEFORE ROW
          LET p_cmd=''
          LET l_ac = ARR_CURR()
          LET l_lock_sw = 'N'            #DEFAULT
          LET l_n  = ARR_COUNT()
 
          IF g_rec_b>=l_ac THEN 
             BEGIN WORK
             LET p_cmd='u'                                                
             LET g_before_input_done = FALSE                                    
             LET g_before_input_done = TRUE                                             
             LET g_lni_t.* = g_lni[l_ac].*  #BACKUP
             OPEN i553_bcl USING g_lni_t.lni04,g_lni_t.lni08
             IF STATUS THEN
                CALL cl_err("OPEN i553_bcl:",STATUS, 1)
                LET l_lock_sw = "Y"
             ELSE
                FETCH i553_bcl INTO g_lni[l_ac].* 
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_lni_t.lni04,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                ELSE
                   CALL i553_lni08('d')
                   CALL i553_lni04('d')
                END IF
             END IF
             CALL cl_show_fld_cont()   
             SELECT azp02 INTO g_lni[l_ac].azp02 FROM azp_file WHERE azp01=g_lni[l_ac].lniplant
             DISPLAY BY NAME g_lni[l_ac].azp02  
          END IF
 
       BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'                                              
          LET g_before_input_done = FALSE                                       
          LET g_before_input_done = TRUE                                        
          INITIALIZE g_lni[l_ac].* TO NULL   
          LET g_lni[l_ac].lni13 = 'Y'  
          LET g_lni[l_ac].lniplant=g_plant
          SELECT azp02 INTO g_lni[l_ac].azp02 FROM azp_file WHERE azp01=g_lni[l_ac].lniplant
          DISPLAY BY NAME g_lni[l_ac].azp02            
          LET g_lni_t.* = g_lni[l_ac].*         #新輸入資料
          CALL cl_show_fld_cont()    
          NEXT FIELD lni04
 
       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CLOSE i553_bcl
             CANCEL INSERT
          END IF
          IF cl_null(g_lni[l_ac].lni08) THEN LET g_lni[l_ac].lni08 = ' ' END IF  #FUN-C50085 add
          INSERT INTO lni_file(lniplant,lnilegal,lni01,lni02,lni04,lni07,lni08,lni13,lni14,lni15 ) #FUN-A60010  del lni05,lni06  #FUN-C50085 add lni14  #CHI-C80047 add lni15
          VALUES(g_lni[l_ac].lniplant,g_legal,g_argv1,g_argv2,g_lni[l_ac].lni04,        #FUN-A60010
                 g_lni[l_ac].lni07,g_lni[l_ac].lni08,g_lni[l_ac].lni13,g_argv3,g_lst03)         #FUN-C50085 add g_argv3   #CHI-C80047 add lst03
          IF SQLCA.sqlcode THEN   
             CALL cl_err3("ins","lni_file",g_lni[l_ac].lni04,"",SQLCA.sqlcode,"","",1)  
             CANCEL INSERT
          ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.cn2  
             COMMIT WORK
          END IF
              
            
       AFTER FIELD lni04                        #check 門店加攤位是否重複
          IF NOT cl_null(g_lni[l_ac].lni04) THEN 
             IF g_lni[l_ac].lni04 != g_lni_t.lni04 OR
                g_lni_t.lni04 IS NULL THEN
               #FUN-C60089 add START
                CALL i553_lni04('a')  
                IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,1)
                  LET g_lni[l_ac].lni04 = g_lni_t.lni04
                  LET g_errno = ''  #FUN-C60089 add
                  NEXT FIELD lni04
                END IF
               #FUN-C60089 add END
                #IF g_lni[l_ac].lni08 IS NOT NULL THEN 
                #   SELECT count(*) INTO l_n FROM lni_file
                #    WHERE lni04 = g_lni[l_ac].lni04    
                #      AND lni08 = g_lni[l_ac].lni08 
                #    IF l_n>0 THEN 
                #       CALL cl_err('','alm-835',1)  
                #       LET g_lni[l_ac].lni04 = g_lni_t.lni04                                                                             
                #       NEXT FIELD lni04   
                #   END IF 
                #   SELECT COUNT(*) INTO l_n3 FROM lml_file
                #    WHERE lml01=g_lni[l_ac].lni08
                #      AND lmlstore=g_lni[l_ac].lni04
                #   IF l_n3=0 THEN 
                #      CALL cl_err('','alm-837',1)
                #      LET g_lni[l_ac].lni04 = g_lni_t.lni04                                                                             
                #      NEXT FIELD lni04   
                #   END IF 
                #END IF 
               #FUN-C50085 add START
               #IF g_argv2 = '1' OR g_argv2 = '2' THEN  #FUN-C60089 mark
                IF g_argv2 = '1' OR g_argv2 = '2' OR g_argv2 = '3' OR g_argv2 = '4' THEN  #FUN-C60089 add
                   IF p_cmd = 'a' THEN
                      LET l_n1 = 0
                      SELECT COUNT(*) INTO l_n1 FROM lni_file
                         WHERE lni01=g_argv1 AND lni02=g_argv2 AND lni04 = g_lni[l_ac].lni04 
                           AND lni14 = g_argv3   #FUN-C50085 add
                           AND lni15 = g_lst03   #CHI-C80047 add
                      IF l_n1 > 0 THEN
                         CALL cl_err('','-239',0)
                         NEXT FIELD lni04
                      END IF
                   END IF
                   IF p_cmd = 'u' AND g_lni[l_ac].lni04 <> g_lni_t.lni04 THEN
                      SELECT COUNT(*) INTO l_n1 FROM lni_file
                         WHERE lni01=g_argv1 AND lni02=g_argv2 AND lni04 = g_lni[l_ac].lni04 
                           AND lni14 = g_argv3  #FUN-C50085 add
                           AND lni15 = g_lst03  #CHI-C80047 add
                      IF l_n1 > 0 THEN 
                         CALL cl_err('','-239',0)
                         NEXT FIELD lni04
                      END IF
                   END IF
                   CALL i553_chk_lni04()  #判斷營運中心是否符合卡種生效營運中心
                   IF NOT cl_null(g_errno) THEN
                      CALL cl_err('',g_errno,0)
                      LET g_errno = ''  #FUN-C60089 add
                      NEXT FIELD lni04
                   END IF
                END IF
               #FUN-C50085 add END
                CALL i553_check() 
               #CALL i553_lni04('a')  #FUN-C60089 mark 
                IF NOT cl_null(g_errno) THEN 
                  CALL cl_err('',g_errno,1)
                  LET g_lni[l_ac].lni04 = g_lni_t.lni04
                  LET g_errno = ''  #FUN-C60089 add
                  NEXT FIELD lni04
                END IF                                                                                          
             END IF      
          ELSE 
             LET g_lni[l_ac].azp02_1=''
             DISPLAY '' TO g_lni[l_ac].azp02_1
          END IF
           
        AFTER FIELD lni08
           IF g_lni[l_ac].lni08 IS NOT NULL THEN                          
              IF g_lni[l_ac].lni08 != g_lni_t.lni08 OR
                 g_lni_t.lni08 IS NULL THEN
                 CALL i553_check()
                 #IF NOT cl_null(g_lni[l_ac].lni04) THEN           #門店不為空時，檢查此攤位是否在門店下存在
                 #   #SELECT count(*) INTO l_n1 FROM lni_file
                 #   #WHERE lni04 = g_lni[l_ac].lni04    
                 #   #  AND lni08 = g_lni[l_ac].lni08 
                 #   #IF l_n1>0 THEN 
                 #   #   CALL cl_err('','alm-835',1)       
                 #   #   LET g_lni[l_ac].lni08 = g_lni_t.lni08                                                                        
                 #   #   NEXT FIELD lni08   
                 #   #END IF 
                 #   #SELECT COUNT(*) INTO l_n2 FROM lml_file
                 #   # WHERE lml01=g_lni[l_ac].lni08
                 #   #   AND lmlstore=g_lni[l_ac].lni04     
                 #   #IF l_n2=0 THEN 
                 #   #   CALL cl_err('','alm-837',1)
                 #   #   LET g_lni[l_ac].lni08 = g_lni_t.lni08
                 #   #   NEXT FIELD lni08
                 #   #END IF                  
                 #ELSE                                               #門店為空時，從小類與攤位關係檔中帶出門店     
                 #	  SELECT lmlstore INTO g_lni[l_ac].lni04 FROM lml_file 
                 #	   WHERE lml01=g_lni[l_ac].lni08
                 #	  IF NOT cl_null(g_lni[l_ac].lni08) THEN 
                 #	     IF cl_null(g_lni[l_ac].lni04) THEN 
                 #	        CALL cl_err('','alm-840',1)
                 #	        LET g_lni[l_ac].lni08 = g_lni_t.lni08
                 #	        NEXT FIELD lni08
                 #	     END IF  
                 #	  END IF 
                 #	  DISPLAY BY NAME g_lni[l_ac].lni04
                 #	  SELECT lma02 INTO l_lma02 FROM lma_file 
                 #   WHERE lma01=g_lni[l_ac].lni04
                 #     AND lma01 IN (SELECT azw01 FROM azw_file 
                 #     WHERE azw07=g_lni[l_ac].lniplant OR azw01=g_lni[l_ac].lniplant)
                 #	  DISPLAY BY NAME g_lni[l_ac].lma02_1
                 #END IF
                 CALL i553_lni08('a')
                 IF NOT cl_null(g_errno) THEN 
                   CALL cl_err('',g_errno,1)
                   LET g_lni[l_ac].lni08 = g_lni_t.lni08
                   LET g_errno = ''  #FUN-C60089 add
                   NEXT FIELD lni08
                 END IF   
              END IF      
           ELSE 
           	  LET g_lni[l_ac].lni08=' '
           	  CALL i553_check()
              IF NOT cl_null(g_errno) THEN 
                CALL cl_err('',g_errno,1)
                LET g_lni[l_ac].lni08 = g_lni_t.lni08
                LET g_errno = ''  #FUN-C60089 add
                NEXT FIELD lni08
              END IF            	
#              LET g_lni[l_ac].lni05=''             #FUN-A60010
#              LET g_lni[l_ac].lni06=''             #FUN-A60010
              LET g_lni[l_ac].lni07=''  
              DISPLAY '' TO lni07
      	      DISPLAY '' TO oba02                  #FUN-A60010  add
#              DISPLAY '' TO lmk02                 #FUN-A60010
#       	   DISPLAY '' TO lni06                 #FUN-A60010
#              DISPLAY '' TO lni05                 #FUN-A60010
#              DISPLAY '' TO lmi02                 #FUN-A60010
#              DISPLAY '' TO lmj02                 #FUN-A60010
           END IF  
           IF cl_null(g_lni[l_ac].lni08) THEN
#              LET g_lni[l_ac].lni05=''            #FUN-A60010
#              LET g_lni[l_ac].lni06=''            #FUN-A60010
              LET g_lni[l_ac].lni07=''
              LET g_lni[l_ac].oba02=''             #FUN-A60010  add
#              LET g_lni[l_ac].lmk02=''            #FUN-A60010
#              LET g_lni[l_ac].lmi02=''            #FUN-A60010
#              LET g_lni[l_ac].lmj02=''            #FUN-A60010
           END IF 

       AFTER FIELD lni13
          IF NOT cl_null(g_lni[l_ac].lni13) THEN
             IF g_lni[l_ac].lni13 NOT MATCHES '[YN]' THEN 
                LET g_lni[l_ac].lni13 = g_lni_t.lni13
                NEXT FIELD lni13
             END IF
          END IF
          
       BEFORE DELETE                            #是否取消單身
          IF g_lni_t.lni04 IS NOT NULL THEN
             IF NOT cl_delete() THEN
                CANCEL DELETE
             END IF
             INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
             LET g_doc.column1 = "lni04"               #No.FUN-9B0098 10/02/24
             LET g_doc.value1 = g_lni[l_ac].lni04      #No.FUN-9B0098 10/02/24
             CALL cl_del_doc()                                           #No.FUN-9B0098 10/02/24
             IF l_lock_sw = "Y" THEN 
                CALL cl_err("", -263, 1) 
                CANCEL DELETE 
             END IF 
             DELETE FROM lni_file WHERE lni04 = g_lni_t.lni04 AND lni08=g_lni_t.lni08 
                                    AND lni01 = g_argv1 AND lni02 = g_argv2
                                    AND lni15 = g_lst03    #CHI-C80047 add
             IF SQLCA.sqlcode THEN
                CALL cl_err3("del","lni_file",g_lni_t.lni04,"",SQLCA.sqlcode,"","",1)  
                EXIT INPUT
             END IF
             LET g_rec_b=g_rec_b-1
             DISPLAY g_rec_b TO FORMONLY.cn2  
             COMMIT WORK
          END IF
 
       ON ROW CHANGE
          IF INT_FLAG THEN                 #新增程式段
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_lni[l_ac].* = g_lni_t.*
             CLOSE i553_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
 
          IF l_lock_sw="Y" THEN
             CALL cl_err(g_lni[l_ac].lni04,-263,0)
             LET g_lni[l_ac].* = g_lni_t.*
          ELSE           
             UPDATE lni_file SET lni04=g_lni[l_ac].lni04,
                                 lni08=g_lni[l_ac].lni08,
#                                 lni05=g_lni[l_ac].lni05,           #FUN-A60010
#                                 lni06=g_lni[l_ac].lni06,           #FUN-A60010
                                 lni07=g_lni[l_ac].lni07,
                                 lni13=g_lni[l_ac].lni13
              WHERE lni04 = g_lni_t.lni04 
                AND lni08 = g_lni_t.lni08
                AND lni01 = g_argv1
                AND lni02 = g_argv2
                AND lni15 = g_lst03   #CHI-C80047 add
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","lni_file",g_lni_t.lni04,"",SQLCA.sqlcode,"","",1) 
                LET g_lni[l_ac].* = g_lni_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                COMMIT WORK
             END IF
          END IF
 
       AFTER ROW
          LET l_ac = ARR_CURR()            # 新增
         #LET l_ac_t = l_ac                # 新增   #FUN-D30033 Mark
 
          IF INT_FLAG THEN 
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd='u' THEN
                LET g_lni[l_ac].* = g_lni_t.*
             #FUN-D30033--add--str--
             ELSE
                CALL g_lni.deleteElement(l_ac)
                IF g_rec_b != 0 THEN
                   LET g_action_choice = "detail"
                   LET l_ac = l_ac_t
                END IF
             #FUN-D30033--add--end--
             END IF
             CLOSE i553_bcl            # 新增
             ROLLBACK WORK             # 新增
             EXIT INPUT
          END IF
 
          LET l_ac_t = l_ac            #FUN-D30033 Add  
          CLOSE i553_bcl               # 新增
          COMMIT WORK
          
       ON ACTION CONTROLP
           CASE
              WHEN INFIELD(lni04)
                 CALL cl_init_qry_var()
               #No.FUN-A40015 -BEGIN-----
               ##LET g_qryparam.form ="q_lma8"  #No.FUN-A10060
               # LET g_qryparam.form ="q_lma7"  #No.FUN-A10060
               # #LET g_qryparam.where=" lma01 IN (SELECT azw01 FROM azw_file WHERE azw07='",g_lni[l_ac].lniplant,"' OR azw01 ='",g_lni[l_ac].lniplant,"'）"
               ##LET g_qryparam.arg1=g_lni[l_ac].lniplant     #No.FUN-A10060
               # LET g_qryparam.where=" lma01 IN ",g_auth," " #No.FUN-A10060
                 LET g_qryparam.form ="q_azw"
                 LET g_qryparam.where=" azw01 IN ",g_auth," "
               #No.FUN-A40015 -END-------
#FUN-B30174 ---------------STA
                #IF NOT cl_null(g_lni[l_ac].lni04) THEN  #FUN-C50085 add  #FUN-C50085 mark 
                 IF cl_null(g_lni[l_ac].lni04) THEN                       #FUN-C50085 add
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    LET tok = base.StringTokenizer.createExt(g_qryparam.multiret,"|",'',TRUE)
                    WHILE tok.hasMoreTokens()
                       LET l_plant = tok.nextToken()
                       IF cl_null(l_plant) THEN
                          CONTINUE WHILE
                       ELSE
                         SELECT COUNT(*) INTO l_count  FROM lni_file
                          WHERE lni01 = g_argv1 AND lni02 = g_argv2
                           AND lni04 = l_plant AND lni08 = ' '
                           AND lni14 = g_argv3   #FUN-C50085 add
                           AND lni15 = g_lst03   #CHI-C80047 add
                         IF l_count > 0 THEN
                            CONTINUE WHILE
                         END IF
                       END IF
                       SELECT azw02 INTO l_azw02 FROM azw_file WHERE azw01= g_plant
                       IF cl_null(g_lni[l_ac].lni08) THEN LET g_lni[l_ac].lni08 = ' ' END IF  #FUN-C50085 add 
                       INSERT INTO lni_file(lni01,lni02,lni03,lni04,lni08,lni13,lnilegal,lniplant,lni14,lni15)  #FUN-C50085 add lni14  #CHI-C80047 add lni15
                                     VALUES (g_argv1,g_argv2,0,l_plant,' ','Y',l_azw02,g_plant,g_argv3,g_lst03)   #FUN-C50085 add g_argv3   #CHI-C80047 add lst03
                    END WHILE
                    LET l_flag = 'Y'
                    EXIT INPUT
                #FUN-C50085 add START
                 ELSE          
                    CALL cl_create_qry() RETURNING g_lni[l_ac].lni04
                 END IF   
                #FUN-C50085 add END
                #LET g_qryparam.default1 = g_lni[l_ac].lni04
                #CALL cl_create_qry() RETURNING g_lni[l_ac].lni04
                #DISPLAY BY NAME g_lni[l_ac].lni04
                #NEXT FIELD lni04
#FUN-B30174 ---------------END                    
              WHEN INFIELD(lni08)
                 CALL cl_init_qry_var()
                 IF NOT cl_null(g_lni[l_ac].lni04) THEN 
                    LET g_qryparam.form ="q_lml1"
                    LET g_qryparam.arg1 =g_lni[l_ac].lni04
                 ELSE
                    LET g_qryparam.form ="q_lml"
                 END IF 
                 LET g_qryparam.where=" lmlstore IN ",g_auth," " #No.FUN-A10060
                 LET g_qryparam.default1 = g_lni[l_ac].lni08
                 CALL cl_create_qry() RETURNING g_lni[l_ac].lni08
                 DISPLAY BY NAME g_lni[l_ac].lni08
                 NEXT FIELD lni08   
           END CASE
           
       ON ACTION CONTROLO                        #沿用所有欄位
          IF INFIELD(lni04) AND l_ac > 1 THEN
             LET g_lni[l_ac].* = g_lni[l_ac-1].*
             NEXT FIELD lni04
          END IF
 
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
          
 
       ON ACTION CONTROLG
          CALL cl_cmdask()
 
       ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help         
         CALL cl_show_help() 

     #FUN-C50085 add START
      ON ACTION del_all_plant
         CALL i553_del_all_plant()
         
     #FUN-C50085 add END
 
       
   END INPUT
#FUN-B30174 -----------STA
   IF l_flag = 'Y' THEN
       CALL i553_b_fill(" 1=1")
       CALL i553_b()
   END IF
#FUN-B30174 -----------END 
   CLOSE i553_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i553_b_fill(p_wc2)              
DEFINE
    p_wc2           LIKE type_file.chr1000      
 
    LET g_sql =
        "SELECT lniplant,'',lni04,'',lni08,lni07,'',lni13 ",    #FUN-A60010  del lni05,lni06
        " FROM lni_file ",
        " WHERE lni01='",g_argv1,"' AND lni02='",g_argv2,"' AND ", g_wc2 CLIPPED,        #單身
       #"   AND lniplant IN ",g_auth," ",  #No.FUN-A10060   #FUN-C60089 mark
        "   AND lniplant = '",g_plant,"' ",                 #FUN-C60089 add
        "   AND lni14 = '",g_argv3,"'",  #FUN-C50085 add
        "   AND lni15 = '",g_lst03,"'",  #CHI-C80047 add 
        " ORDER BY lni04"
    PREPARE i553_pb FROM g_sql
    DECLARE lni_curs CURSOR FOR i553_pb
 
    CALL g_lni.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH lni_curs INTO g_lni[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        SELECT azp02 INTO g_lni[g_cnt].azp02 FROM azp_file
           WHERE azp01 =g_lni[g_cnt].lniplant       
        SELECT azp02 INTO g_lni[g_cnt].azp02_1 FROM azp_file
           WHERE azp01 =g_lni[g_cnt].lni04   
#        SELECT lmi02 INTO g_lni[g_cnt].lmi02 FROM lmi_file 
#         WHERE lmi01 = g_lni[g_cnt].lni05        
#        SELECT lmj02 INTO g_lni[g_cnt].lmj02 FROM lmj_file 
#         WHERE lmj01 = g_lni[g_cnt].lni06
#        SELECT lmk02 INTO g_lni[g_cnt].lmk02 FROM lmk_file 
#         WHERE lmk01 = g_lni[g_cnt].lni07
         SELECT oba02 INTO g_lni[g_cnt].oba02 FROM oba_file
          WHERE oba01 = g_lni[g_cnt].lni07                     #FUN-A60010  add 
                 
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_lni.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i553_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_lni TO s_lni.* ATTRIBUTE(COUNT=g_rec_b)

     #FUN-C50085 add START
      BEFORE DISPLAY  
         IF cl_null(g_argv2 ) THEN
            CALL cl_set_act_visible('del_all_plant',FALSE)
         END IF
     #FUN-C50085 add END
  
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         LET l_ac = 1
         EXIT DISPLAY
#      ON ACTION output
#         LET g_action_choice="output"
#         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
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
 
   
 
       ON ACTION related_document  
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel   
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

     #FUN-C50085 add START
      ON ACTION del_all_plant
         LET g_action_choice = 'del_all_plant'
         EXIT DISPLAY
     #FUN-C50085 add END
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
#FUNCTION i553_out()
#DEFINE l_cmd LIKE type_file.chr1000
#
#    IF g_wc2 IS NULL THEN 
#       CALL cl_err('','9057',0)
#       RETURN
#    END IF
#    LET l_cmd = 'p_query "alni200" "',g_wc2 CLIPPED,'"'                                                                               
#    CALL cl_cmdrun(l_cmd) 
#    RETURN
#END FUNCTION 

FUNCTION i553_check()
DEFINE    l_n             LIKE type_file.num5,        
          l_n1            LIKE type_file.num5,
          l_n2            LIKE type_file.num5
          
    IF NOT cl_null(g_lni[l_ac].lni04) AND g_lni[l_ac].lni08 IS NOT NULL  THEN 
       SELECT count(*) INTO l_n FROM lni_file
        WHERE lni01=g_argv1 AND lni02=g_argv2 AND lni04 = g_lni[l_ac].lni04    
          AND lni08 = g_lni[l_ac].lni08 
          AND lni14 = g_argv3  #FUN-C50085 add
          AND lni15 = g_lst03  #CHI-C80047 add
       IF l_n>0 THEN 
           LET g_errno='alm-835'
           RETURN 
       END IF 
    END IF  
    IF NOT cl_null(g_lni[l_ac].lni04) AND NOT cl_null(g_lni[l_ac].lni08) THEN  
       SELECT COUNT(*) INTO l_n1 FROM lml_file
        WHERE lml01=g_lni[l_ac].lni08
          AND lmlstore=g_lni[l_ac].lni04
       IF l_n1=0 THEN 
          LET g_errno='alm-837'
          RETURN 
       END IF 
    END IF           
    #IF NOT cl_null(g_lni[l_ac].lni04) THEN 
    #   SELECT COUNT(*) INTO l_n2 FROM lma_file 
    #    WHERE lma01=g_lni[l_ac].lni04
    #      AND lma01 IN (SELECT azw01 FROM azw_file 
    #      WHERE azw07=g_lni[l_ac].lniplant OR azw01=g_lni[l_ac].lniplant)
    #   IF l_n2=0 THEN 
    #      LET g_errno='art-500'
    #      RETURN
    #   END IF    
    #END IF     
END FUNCTION    
 
FUNCTION i553_lni04(p_cmd)
    DEFINE   p_cmd     LIKE type_file.chr1
    DEFINE   l_azp02   LIKE azp_file.azp02 
    DEFINE   l_rtz28   LIKE rtz_file.rtz28  #FUN-A80148 add
    
    IF NOT cl_null(g_errno) AND p_cmd !='d'THEN 
       RETURN 
    END IF    
  #No.FUN-A40015 -BEGIN-----
  ##No.FUN-A10060 -BEGIN-----
  ##SELECT lma02,l_lma25 INTO l_lma02,l_lma25 FROM lma_file 
  ## WHERE lma01=g_lni[l_ac].lni04
  ##   AND lma01 IN (SELECT azw01 FROM azw_file 
  ##   WHERE azw07=g_lni[l_ac].lniplant OR azw01=g_lni[l_ac].lniplant)
  # LET g_sql = " SELECT lma02,lma25 FROM lma_file",
  #             "  WHERE lma01='",g_lni[l_ac].lni04,"'",
  #             "    AND lma01 IN ",g_auth," "
  # PREPARE sel_lma_pre01 FROM g_sql
  # EXECUTE sel_lma_pre01 INTO l_lma02,l_lma25
  ##No.FUN-A10060 -END-------
  # CASE
  #    WHEN SQLCA.sqlcode=100   LET g_errno='art-500'
  #                             LET l_lma02=NULL
  #    WHEN l_lma25 !='Y'       LET g_errno='9029'
  #    OTHERWISE
  #         LET g_errno=SQLCA.sqlcode USING '------'
  # END CASE
 
  # IF cl_null(g_errno) OR p_cmd ='d' THEN 
  #    LET g_lni[l_ac].lma02_1=l_lma02
  #    DISPLAY BY NAME g_lni[l_ac].lma02_1
  # END IF
    LET g_sql = " SELECT azp02 FROM azp_file,azw_file",
                "  WHERE azp01='",g_lni[l_ac].lni04,"'",
                "    AND azw01=azp01",
                "    AND azp01 IN ",g_auth," "
    PREPARE sel_azp_pre01 FROM g_sql
    EXECUTE sel_azp_pre01 INTO l_azp02
    CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='art-500'
                                LET l_azp02=NULL
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
    END CASE
    
    IF cl_null(g_errno) OR p_cmd ='d' THEN
       LET g_lni[l_ac].azp02_1=l_azp02
       DISPLAY BY NAME g_lni[l_ac].azp02_1
    END IF
  #No.FUN-A40015 -END-------
END FUNCTION 
 
FUNCTION i553_lni08(p_cmd)
DEFINE p_cmd        LIKE type_file.chr1
DEFINE l_azp02      LIKE azp_file.azp02
DEFINE l_lml02      LIKE lml_file.lml02
DEFINE l_lml06      LIKE lml_file.lml06

    IF NOT cl_null(g_errno) THEN 
       RETURN 
    END IF     
    IF cl_null(g_lni[l_ac].lni04) AND p_cmd !='d' THEN
       SELECT lmlstore INTO g_lni[l_ac].lni04 FROM lml_file 
        WHERE lml01=g_lni[l_ac].lni08
       IF SQLCA.sqlcode=100 THEN 
          LET g_errno='alm-840'
          RETURN 
       END IF 
     #No.FUN-A40015 -BEGIN-----
     ##No.FUN-A10060 -BEGIN----
     ##SELECT lma02 INTO l_lma02 FROM lma_file 
     ##WHERE lma01=g_lni[l_ac].lni04
     ##  AND lma01 IN (SELECT azw01 FROM azw_file 
     ##  WHERE azw07=g_lni[l_ac].lniplant OR azw01=g_lni[l_ac].lniplant)
     # LET g_sql = " SELECT lma02 FROM lma_file",
     #             "  WHERE lma01='",g_lni[l_ac].lni04,"'",
     #             "    AND lma01 IN ",g_auth," "
     # PREPARE sel_lma_pre02 FROM g_sql
     # EXECUTE sel_lma_pre02 INTO l_lma02
     ##No.FUN-A10060 -END-------
       LET g_sql = " SELECT azp02 FROM azp_file",
                   "  WHERE azp01='",g_lni[l_ac].lni04,"'",
                   "    AND azp01 IN ",g_auth," "
       PREPARE sel_azp_pre02 FROM g_sql
       EXECUTE sel_azp_pre02 INTO l_azp02
     #No.FUN-A40015 -END-------
       IF SQLCA.sqlcode=100 THEN 
          LET g_lni[l_ac].lni04 = g_lni_t.lni04
          LET g_errno='art-500'
          RETURN 
       END IF 
       LET g_lni[l_ac].azp02_1=l_azp02
       DISPLAY BY NAME g_lni[l_ac].azp02_1   
       DISPLAY BY NAME g_lni[l_ac].lni04
    END IF 
    SELECT lml02,lml06
      INTO l_lml02,l_lml06
      FROM lml_file 
     WHERE lml01=g_lni[l_ac].lni08
             
      CASE WHEN SQLCA.sqlcode=100 LET g_errno='anm-027'
                                  LET l_lml02=NULL 
           WHEN l_lml06='N'       LET g_errno='9028'
      OTHERWISE              LET g_errno=SQLCA.SQLCODE USING '-------'
      END CASE 
      
    IF cl_null(g_errno) OR p_cmd= 'd' THEN  
       LET g_lni[l_ac].lni07=l_lml02 
#       SELECT lmk02,lmk03,lmk04 
#         INTO g_lni[l_ac].lmk02,g_lni[l_ac].lni06,g_lni[l_ac].lni05
#         FROM lmk_file 
#        WHERE lmk01=g_lni[l_ac].lni07  
#       SELECT lmi02 INTO g_lni[l_ac].lmi02 FROM lmi_file 
#        WHERE lmi01 = g_lni[l_ac].lni05
#       SELECT lmj02 INTO g_lni[l_ac].lmj02 FROM lmj_file 
#        WHERE lmj01 = g_lni[l_ac].lni06  
#       DISPLAY BY NAME g_lni[l_ac].lni07
#       DISPLAY BY NAME g_lni[l_ac].lmk02
#       DISPLAY BY NAME g_lni[l_ac].lni06         
#       DISPLAY BY NAME g_lni[l_ac].lni05
#       DISPLAY BY NAME g_lni[l_ac].lmj02
#       DISPLAY BY NAME g_lni[l_ac].lmi02

#FUN-A60010 add-----------start---------------------------
        SELECT oba02
          INTO g_lni[l_ac].oba02
          FROM oba_file
         WHERE oba01 =g_lni[l_ac].lni07  
        DISPLAY BY NAME g_lni[l_ac].lni07 
        DISPLAY BY NAME g_lni[l_ac].oba02
#FUN-A60010 add-----------end-----------------------------
    END IF 
           
END FUNCTION 
 
                                                
FUNCTION i553_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1                                                             
                                                                                
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
     CALL cl_set_comp_entry("lni04,lni02",TRUE)                                       
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
                                                                                
FUNCTION i553_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1
                                    
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN          
     CALL cl_set_comp_entry("lni04,lni02",FALSE)                                      
   END IF                                                                       
                                                                                
END FUNCTION
#FUN-A60064 10/06/24 By chenls 非T/S類table中的xxxplant替換成xxxstore
#FUN-C50085 add START
#整批刪除生效營運中心
FUNCTION i553_del_all_plant()
DEFINE l_lst09     LIKE lst_file.lst09
DEFINE l_lst14     LIKE lst_file.lst14
DEFINE l_lpq08     LIKE lpq_file.lpq08

   IF cl_null(g_argv1) OR cl_null(g_argv2) THEN
      RETURN
   END IF
  #判斷確認碼以及制定營運中心是否相同 
  #IF g_argv2='1' THEN
   IF g_argv2 = '1' OR g_argv2 = '2' THEN   #almi590/almi591 
      SELECT lst09,lst14 INTO l_lst09,l_lst14 FROM lst_file WHERE lst01=g_argv1
        AND lst00 = g_lst00      #FUN-C60089 add
        AND lst03 = g_lst03      #CHI-C80047 add
        AND lst14 = g_argv3      #FUN-C50085 add
        AND lstplant = g_plant   #FUN-C60089 add
      IF l_lst09 ='Y' THEN
         CALL cl_err(g_argv1,'abm-879',1)
         RETURN
      END IF
      IF l_lst14 <> g_plant THEN
         CALL cl_err('','art-977',1)
         RETURN
      END IF
   ELSE
      SELECT lpq08 INTO l_lpq08 FROM lpq_file WHERE lpq01=g_argv1
         AND lpq00 = g_lst00      #FUN-C60089 add
         AND lpq03 = g_lst03      #CHI-C80047 add
         AND lpq13 = g_argv3      #FUN-C50085 add
         AND lpqplant = g_plant   #FUN-C60089 add   
      IF l_lpq08 ='Y' THEN
         CALL cl_err(g_argv1,'abm-879',1)
         RETURN
      END IF
   END IF
   IF NOT cl_confirm('art-772') THEN
      RETURN
   ELSE 
      BEGIN WORK
      DELETE FROM lni_file 
          WHERE lni01 = g_argv1 AND lni02 = g_argv2
            AND lni14 = g_argv3  #FUN-C60089 add
            AND lni15 = g_lst03  #CHI-C80047 add
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","lni_file",g_lni_t.lni04,"",SQLCA.sqlcode,"","",1)
         ROLLBACK WORK
      ELSE
         COMMIT WORK
         LET g_rec_b= 0
         DISPLAY g_rec_b TO FORMONLY.cn2
      END IF
   END IF
   CALL i553_b_fill(g_wc2)   
END FUNCTION

FUNCTION i553_chk_lni04()  #判斷營運中心是否符合卡種生效營運中心 
DEFINE l_lst03          LIKE lst_file.lst03   #卡種    
DEFINE l_n              LIKE type_file.num5
DEFINE l_sql            STRING

   LET l_lst03 = g_lst03  #CHI-C80047 add
 #CHI-C80047 mark START
 ##IF g_argv2 = '1' THEN
 # IF g_argv2 = '1' OR g_argv2 = '2' THEN
 #    SELECT lst03 INTO l_lst03 FROM lst_file WHERE lst01 = g_argv1
 #        AND lst00 = g_lst00   #FUN-C60089 add
 #        AND lst14 = g_argv3   #FUN-C50085 add
 #        AND lstplant = g_plant   #FUN-C60089 add
 # ELSE 
 #    SELECT lpq03 INTO l_lst03 FROM lpq_file WHERE lpq01 = g_argv1
 #        AND lpq00 = g_lst00   #FUN-C60089 add
 #        AND lpq13 = g_argv3   #FUN-C50085 add
 #        AND lpqplant = g_plant   #FUN-C60089 add
 # END IF
 # IF cl_null(l_lst03) THEN RETURN END IF
 #   
 ##SELECT COUNT(*) INTO l_n FROM lnk_file 
 ##   WHERE lnk03 = l_lst03 AND lnk02 = '1' AND lnk05 = 'Y'
 ##     AND lnk03 = g_lni[l_ac].lni04 
 #CHI-C80047 mark END

   LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_lni[l_ac].lni04, 'lnk_file'),
               "   WHERE lnk01 = '",l_lst03,"'  AND lnk02 = '1' AND lnk05 = 'Y' ",
               "      AND lnk03 = '",g_lni[l_ac].lni04,"' "
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   CALL cl_parse_qry_sql(l_sql, g_lni[l_ac].lni04) RETURNING l_sql
   PREPARE trans_cnt FROM l_sql
   EXECUTE trans_cnt INTO l_n

   IF l_n = 0 OR cl_null(l_n) THEN
      LET g_errno = 'alm-h33'
      RETURN
   END IF

END FUNCTION
#FUN-C50085 add END
