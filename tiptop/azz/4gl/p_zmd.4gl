# Prog. Version..: '5.30.06-13.04.25(00010)'     #
#
# Pattern name...: p_zmd.4gl
# Descriptions...: 模組代號維護作業                          
# Date & Author..: 03/09/24 Letter
# Modify.........: No.MOD-470041 04/07/20 By Wiky 修改INSERT INTO...
# Modify.........: No.MOD-470562 04/07/27 By Ken 修改p_zmd有關客製部分
# Modify.........: No.MOD-4A0205 04/10/13 By Ken 透過p_zmd新增模組代號自動建立相關目錄在$CUST,$CUST/config/4ad,$CUST/config/4tm下
# Modify.........: No.MOD-4B0063 04/10/13 By Ken 修改程式段落260及263行加入CLIPPED語法
# Modify.........: No.FUN-4C0077 04/12/15 By alex 增加可修改模組名稱功能
# Modify.........: No.MOD-540140 05/04/20 By alex 刪除 HELP FILE
# Modify.........: NO.MOD-580056 05/08/05 By yiting key可更改
# Modify.........: NO.MOD-590314 05/09/14 By Ken 控管當選擇不建立4ad,4tm及模組目錄時,則該筆輸入的單身資料應清除
# Modify.........: No.FUN-660081 06/06/15 By Carrier cl_err-->cl_err3
# Modify.........: No.FUN-680135 06/08/31 By Hellen  欄位類型修改
# Modify.........: No.FUN-6A0096 06/10/26 By johnray l_time轉g_time
# Modify.........: NO.TQC-740035 07/04/22 By alexstar 輸入一筆新的資料，並在畫面上也顯示了該資料，但重新查詢時卻沒有該筆資料
# Modify.........: No.TQC-750162 07/06/01 By joyce 1.mkdir時，也需在doc/help各語言別目錄下分別建立該模組目錄
#                                                  2.mkdir時，5X區中各模組下子目錄需新增4fd與sdd目錄，且3X與5X區皆無za目錄
# Modify.........: No.TQC-760179 07/07/12 By rainy p_gaz_item() 多傳一個參數
# Modify.........: No.FUN-810093 08/02/22 By alex 調整建立目錄功能
# Modify.........: No.FUN-860033 08/06/06 By alex 修正 ON IDLE區段
# Modify.........: No.FUN-970074 09/07/23 By alex 調整MSV產出檔名
# Modify.........: No.FUN-A60016 10/06/04 By johnson 在單身增加一個 CheckBox 欄位(gao_file.gao05),紀錄該筆資料為財務模組否,供建View時參考.
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-A90187 10/09/30 By Dido 欄位代號錯誤 
# Modify.........: No:MOD-B10049 11/01/07 By sabrina AFTER ROW後沒有COMMIT WORK 
# Modify.........: No:FUN-B30122 11/03/16 By jrg542  模組標準路徑新增 4pw  
# Modify.........: No:FUN-B40002 11/04/01 By Johnson CALL cl_set_comp_entry("gao01,gao02,gao04,gao05",FALSE) 改成 CALL cl_set_comp_entry("gao01,gao02,gao04",FALSE)
# Modify.........: No:MOD-B30699 11/03/30 By sabrina 新增時gao02,gao04要可以輸入
# Modify.........: No:FUN-C30214 12/03/15 By Sakura p_zmd建立新模組時，加建立GR相關模組,4rp->語言別目錄、rdd、src、sampledata
# Modify.........: No:TQC-C50159 12/05/18 By laura   1.檢核模組建立gao_file客製模組資料       2.依gao_file客製模組資料mkdir缺漏的客製區實體目錄
#                                                    3.新增標準模組時同時一併建立相對的客製模組  4.各版本模組目錄皆增加sch
# Modify.........: No:FUN-D30034 13/04/18 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

 
IMPORT os
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_gao      DYNAMIC ARRAY of RECORD              #程式變數(Program Variables)
        gao01       LIKE gao_file.gao01,   
        gaz03       LIKE gaz_file.gaz03,  
        gao02       LIKE gao_file.gao02,  
        gao03       LIKE gao_file.gao03,
        gao04       LIKE gao_file.gao04,
        gao05       LIKE gao_file.gao05                #No.FUN-A60016
                    END RECORD,
       g_gao_f   DYNAMIC ARRAY of RECORD               #程式變數(Program Variables)
        gao01       LIKE gao_file.gao01,   
        gaz03       LIKE gaz_file.gaz03,  
        gao02       LIKE gao_file.gao02,  
        gao03       LIKE gao_file.gao03,
        gao04       LIKE gao_file.gao04,
        gao05       LIKE gao_file.gao05                #No.FUN-A60016
                    END RECORD,
       g_gao_t         RECORD                          #程式變數 (舊值)
        gao01       LIKE gao_file.gao01,   
        gaz03       LIKE gaz_file.gaz03,  
        gao02       LIKE gao_file.gao02,  
        gao03       LIKE gao_file.gao03,
        gao04       LIKE gao_file.gao04,
        gao05       LIKE gao_file.gao05                #No.FUN-A60016
                    END RECORD 

DEFINE g_gaocust    DYNAMIC ARRAY of RECORD          #TQC-C50159程式變數 
          gao01     LIKE gao_file.gao01,                              
          gao02     LIKE gao_file.gao02,                              
          gao03     LIKE gao_file.gao03,                              
          gao04     LIKE gao_file.gao04,
          gao05     LIKE gao_file.gao05,          
          datatype  LIKE type_file.chr1          
                    END RECORD  
DEFINE g_gao_c      RECORD                           #TQC-C50159程式變數 
          gao01     LIKE gao_file.gao01,                              
          gao02     LIKE gao_file.gao02,                              
          gao03     LIKE gao_file.gao03,                              
          gao04     LIKE gao_file.gao04,
          gao05     LIKE gao_file.gao05          
                    END RECORD  
                    
                    

DEFINE g_gaocust_mk DYNAMIC ARRAY of  RECORD         #TQC-C50159程式變數 
          gao01     LIKE gao_file.gao01,   
          gao02     LIKE gao_file.gao02,  
          gao03     LIKE gao_file.gao03,
          gao04     LIKE gao_file.gao04,
          gao05     LIKE gao_file.gao05,          
          mtype     LIKE type_file.chr1,
          adtype    LIKE type_file.chr1,   
          tmtype    LIKE type_file.chr1, 
          doctype   LIKE type_file.chr1,
          rptype    LIKE type_file.chr1                                     
                    END RECORD  
                    
                    
                    
DEFINE g_before_input_done LIKE type_file.num5     #NO.MOD-580056 #No.FUN-680135 SMALLINT
DEFINE g_wc2               STRING 
DEFINE g_sql               STRING                  #No.FUN-580092 HCN
DEFINE g_rec_b             LIKE type_file.num5     #單身筆數             #No.FUN-680135 SMALLINT
DEFINE l_ac                LIKE type_file.num5     #目前處理的ARRAY CNT  #No.FUN-680135 SMALLINT
DEFINE g_argv1             LIKE gao_file.gao01     #模組代號
DEFINE g_cnt               LIKE type_file.num10    #No.FUN-680135 INTEGER
DEFINE g_log               LIKE type_file.chr1     #No.FUN-680135 VARCHAR(1)
DEFINE g_forupd_sql        STRING
DEFINE gs_top              STRING
DEFINE gs_cust             STRING
DEFINE gs_tempdir          STRING
 
MAIN
 
   OPTIONS                                         #改變一些系統預設值
       INPUT NO WRAP
   DEFER INTERRUPT                                 #擷取中斷鍵, 由程式處理
 
   LET g_argv1 =ARG_VAL(1)
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time    #No.FUN-6A0096
 
   OPEN WINDOW p_zmd_w WITH FORM "azz/42f/p_zmd"
        ATTRIBUTE(STYLE=g_win_style)
 
   CALL cl_ui_init()
 
   LET gs_top = FGL_GETENV('TOP')
   LET gs_cust = FGL_GETENV('CUST')
   LET gs_tempdir = FGL_GETENV('TEMPDIR')
 
#  CALL p_zmd_load_sys()  #FUN-810093 已刪除使用,查看FUNCTION上方說明
 
   IF g_argv1 IS NOT NULL THEN
       LET g_wc2="gao01 matches '*'" 
       LET g_argv1=NULL
   ELSE
       LET g_wc2 = '1=1'
   END IF
 
   CALL p_zmd_b_fill(g_wc2)
   CALL p_zmd_menu()
   CLOSE WINDOW p_zmd_w                 #結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-6A0096
END MAIN
 
FUNCTION p_zmd_menu()
 
   WHILE TRUE
      CALL p_zmd_bp("G")
      CASE g_action_choice
 
          WHEN "query"
             IF cl_chk_act_auth() THEN
                CALL p_zmd_q()
             END IF
 
          WHEN "detail"
             IF cl_chk_act_auth() THEN
                CALL p_zmd_b()
             ELSE
                LET g_action_choice = ""
             END IF
 
          WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_gao),'','')
             END IF
 
          WHEN "help"
             CALL cl_show_help()
 
          WHEN "exit"
             EXIT WHILE
 
          WHEN "controlg"
             CALL cl_cmdask()

          #No.TQC-C50159  --start--  
          WHEN "custadd"
             IF cl_chk_act_auth() THEN
                CALL p_zmd_custadd()
             END IF

          WHEN "custmkdir"
             IF cl_chk_act_auth() THEN 
                CALL p_zmd_custmk()
             END IF  
          #No.TQC-C50159  --end--               
             
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION p_zmd_q()
   CALL p_zmd_b_askkey()
END FUNCTION
 
FUNCTION p_zmd_b()
 
    DEFINE l_ac_t          LIKE type_file.num5,    #未取消的ARRAY CNT        #No.FUN-680135 SMALLINT 
           l_n             LIKE type_file.num5,    #檢查重複用               #No.FUN-680135 SMALLINT
           l_modify_flag   LIKE type_file.chr1,    #單身更改否               #No.FUN-680135 VARCHAR(1)
           l_lock_sw       LIKE type_file.chr1,    #單身鎖住否               #No.FUN-680135 VARCHAR(1)
           l_exit_sw       LIKE type_file.chr1,    #Esc結束INPUT ARRAY 否    #No.FUN-680135 VARCHAR(1)
           p_cmd           LIKE type_file.chr1,    #處理狀態                 #No.FUN-680135 VARCHAR(1)
           l_possible      LIKE type_file.num5,    #用來設定判斷重複的可能性 #No.FUN-680135 SMALLINT
           l_allow_insert  LIKE type_file.num5,    #可新增否                 #No.FUN-680135 VARCHAR(1)
           l_allow_delete  LIKE type_file.num5     #可刪除否                 #No.FUN-680135 VARCHAR(1)
    DEFINE l_gaz01         LIKE gaz_file.gaz01 
    DEFINE ls_tmp          STRING                  #FUN-810039
    DEFINE l_gao01         LIKE gao_file.gao01     #TQC-C50159
    DEFINE l_gao01_cust    LIKE gao_file.gao01     #TQC-C50159
    DEFINE l_gao01_custstr STRING                  #TQC-C50159
    
    LET g_action_choice = NULL
    IF s_shut(0) THEN RETURN END IF
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
    CALL cl_opmsg('b')

    #No.FUN-A60016 -- start --
    #LET g_forupd_sql = " SELECT gao01,'',gao02,gao03,gao04 FROM gao_file ",
    #                    "  WHERE gao01 = ? ",   #g_gao_t.gao01
    #                      " FOR UPDATE "
    LET g_forupd_sql = " SELECT gao01,'',gao02,gao03,gao04,gao05 FROM gao_file ",
                        "  WHERE gao01 = ? ",   #g_gao_t.gao01
                          " FOR UPDATE "
    #No.FUN-A60016 -- end --

    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE p_zmd_bcl CURSOR FROM g_forupd_sql    # LOCK CURSOR
 
    INPUT ARRAY g_gao WITHOUT DEFAULTS FROM s_gao.*
       ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                  INSERT ROW = l_allow_insert, DELETE ROW = l_allow_delete,
                  APPEND ROW = l_allow_insert)
 
       BEFORE INPUT
          IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(l_ac)
          END IF
 
       BEFORE ROW
          LET p_cmd = ''
          LET l_ac = ARR_CURR()
          LET l_lock_sw = 'N'            #DEFAULT
          LET l_n  = ARR_COUNT()
          BEGIN WORK
          #IF g_gao_t.gao01 IS NOT NULL THEN
           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_gao_t.* = g_gao[l_ac].*  #BACKUP
 #No.MOD-580056 --start
              LET g_before_input_done = FALSE
              CALL p_zmd_set_entry_b(p_cmd)
              CALL p_zmd_set_no_entry_b(p_cmd)
              LET g_before_input_done = TRUE
 #No.MOD-580056 --end
              OPEN p_zmd_bcl USING g_gao_t.gao01     #表示更改狀態
              IF SQLCA.sqlcode THEN
                  CALL cl_err('OPEN p_zmd_bcl',SQLCA.sqlcode,1)
                  CLOSE p_zmd_bcl
                  ROLLBACK WORK
                  RETURN
                  #LET l_lock_sw = "Y"
              END IF
 
              FETCH p_zmd_bcl INTO g_gao[l_ac].* 
              IF SQLCA.sqlcode THEN
                  CALL cl_err('FETCH p_zmd_bcl',SQLCA.sqlcode,1)
                  CLOSE p_zmd_bcl
                  ROLLBACK WORK
                  RETURN
              ELSE
                 LET l_gaz01=DOWNSHIFT(g_gao[l_ac].gao01) 
                 SELECT gaz03 INTO g_gao[l_ac].gaz03
                   FROM gaz_file 
                  WHERE gaz01=l_gaz01 AND gaz02 = g_lang
              END IF
              CALL cl_show_fld_cont()     #FUN-550037(smin)
           END IF
 
       BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'
          INITIALIZE g_gao[l_ac].* TO NULL      #900423
          LET g_gao_t.* = g_gao[l_ac].*         #新輸入資料
 #No.MOD-580056 --start
          LET g_before_input_done = FALSE
          CALL p_zmd_set_entry_b(p_cmd)
          CALL p_zmd_set_no_entry_b(p_cmd)
          LET g_before_input_done = TRUE
 #No.MOD-580056 --end
          CALL cl_show_fld_cont()     #FUN-550037(smin)
 
       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CANCEL INSERT
          ELSE
             IF cl_confirm("azz-088") THEN 
                IF NOT p_zmd_mkdir() THEN   #FUN-810039 CALL p_zmd_mkdir()
                   CANCEL INSERT
                END IF
                #No.MOD-590314 --start
                #No.FUN-A60016 --start-- 
                #INSERT INTO gao_file(gao01,gao02,gao03,gao04)  #NO.MOD-470041
                #            VALUES(g_gao[l_ac].gao01,g_gao[l_ac].gao02,
                #                   g_gao[l_ac].gao03,g_gao[l_ac].gao04)

                INSERT INTO gao_file(gao01,gao02,gao03,gao04,gao05) 
                            VALUES(g_gao[l_ac].gao01,g_gao[l_ac].gao02,
                                   g_gao[l_ac].gao03,g_gao[l_ac].gao04,
                                   g_gao[l_ac].gao05)
                #No.FUN-A60016 --end--
                IF SQLCA.sqlcode THEN
                   #CALL cl_err(g_gao[l_ac].gao01,SQLCA.sqlcode,1)  #No.FUN-660081
                   CALL cl_err3("ins","gao_file",g_gao[l_ac].gao01,"",SQLCA.sqlcode,"","",1)    #No.FUN-660081
                   CANCEL INSERT
                ELSE
                   LET g_rec_b=g_rec_b+1
                   DISPLAY g_rec_b TO FORMONLY.cn2  
                END IF        #No.MOD-590314 --end
                
                #TQC-C50159  --start--
                LET l_gao01 = DOWNSHIFT(g_gao[l_ac].gao01)
                LET l_gao01_custstr = l_gao01
                IF l_gao01[1,1] = "a" THEN
                   LET l_gao01_cust = "c",l_gao01_custstr.subString(2,length(l_gao01_custstr))
                ELSE 
                   LET l_gao01_cust = "c",l_gao01_custstr   
                END IF
                #客製gao01
                LET g_gao_c.gao01 = UPSHIFT(l_gao01_cust)
                #客製gao02
                IF cl_null(g_gao_c.gao02) THEN
                   IF DOWNSHIFT(g_gao_c.gao01[1,1]) = "c" THEN
                      LET g_gao_c.gao02 = "CUST"
                   END IF
                   IF cl_get_os_type() = "WINDOWS" THEN
                      LET g_gao_c.gao02 = "%",g_gao_c.gao02,"%/",DOWNSHIFT(g_gao_c.gao01 CLIPPED)
                   ELSE
                      LET g_gao_c.gao02 = "$",g_gao_c.gao02,"/",DOWNSHIFT(g_gao_c.gao01 CLIPPED)
                   END IF
                END IF
                #客製gao03
                IF cl_null(g_gao_c.gao03) THEN
                   LET g_gao_c.gao03 = g_gao_c.gao01 CLIPPED||"i"  
                END IF
                #客製gao04
                IF cl_null(g_gao_c.gao04) THEN    
                   IF g_gao_c.gao01 = "LIB" OR g_gao_c.gao01 = "CLIB" OR
                      g_gao_c.gao01 = "SUB" OR g_gao_c.gao01 = "CSUB" OR
                      g_gao_c.gao01 = "QRY" OR g_gao_c.gao01 = "CQRY" THEN
                      LET g_gao_c.gao04 = g_gao_c.gao02 CLIPPED||"/42m" 
                   ELSE
                      LET g_gao_c.gao04 = g_gao_c.gao02 CLIPPED||"/42r" 
                   END IF
                END IF                    
                #客製gao05
                LET g_gao_c.gao05     = g_gao[l_ac].gao05
                
                LET g_gao[l_ac].gao01 = g_gao_c.gao01 
                LET g_gao[l_ac].gao02 = g_gao_c.gao02
                LET g_gao[l_ac].gao03 = g_gao_c.gao03
                LET g_gao[l_ac].gao04 = g_gao_c.gao04  
                LET g_gao[l_ac].gao05 = g_gao_c.gao05     
                      
                IF NOT p_zmd_mkdir() THEN   
                   CANCEL INSERT
                END IF   
                    INSERT INTO gao_file(gao01,gao02,gao03,gao04,gao05)  
                            VALUES(g_gao[l_ac].gao01,g_gao[l_ac].gao02,
                                   g_gao[l_ac].gao03,g_gao[l_ac].gao04,
                                   g_gao[l_ac].gao05)
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("ins","gao_file",g_gao[l_ac].gao01,"",SQLCA.sqlcode,"","",1)    
                   CANCEL INSERT
                ELSE
                   LET g_rec_b=g_rec_b+1
                   DISPLAY g_rec_b TO FORMONLY.cn2  
                END IF            
                INITIALIZE g_gao_c.* TO NULL      
    
                #TQC-C50159  --end--
                
             ELSE    #FUN-810093
                CALL cl_err_msg(NULL,"azz-280",g_gao[l_ac].gao01,20) 
                CANCEL INSERT
             END IF           #MOD-4C0177  end
          END IF
 
       AFTER FIELD gao01
          IF NOT cl_null(g_gao[l_ac].gao01) THEN
            IF g_gao[l_ac].gao01 != g_gao_t.gao01 OR
               (g_gao[l_ac].gao01 IS NOT NULL AND g_gao_t.gao01 IS NULL) THEN
                SELECT count(*) INTO l_n FROM gao_file
                    WHERE gao01 = g_gao[l_ac].gao01
                IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_gao[l_ac].gao01 = g_gao_t.gao01
                    NEXT FIELD gao01
                END IF
            END IF
          END IF 
          #TQC-740035 ---start---
          LET l_gaz01=DOWNSHIFT(g_gao[l_ac].gao01)
          SELECT gaz03 INTO g_gao[l_ac].gaz03 FROM gaz_file
           WHERE gaz01=l_gaz01 AND gaz02 = g_lang
          DISPLAY g_gao[l_ac].gaz03 TO gaz03
          #TQC-740035 ---end---
 
       BEFORE FIELD gao02      #FUN-810093
          IF cl_null(g_gao[l_ac].gao02) THEN
             IF DOWNSHIFT(g_gao[l_ac].gao01[1,1]) = "c" THEN
                LET g_gao[l_ac].gao02 = "CUST"
             ELSE
                LET g_gao[l_ac].gao02 = "TOP"
             END IF
             IF cl_get_os_type() = "WINDOWS" THEN
                LET g_gao[l_ac].gao02 = "%",g_gao[l_ac].gao02,"%/",DOWNSHIFT(g_gao[l_ac].gao01 CLIPPED)
             ELSE
                LET g_gao[l_ac].gao02 = "$",g_gao[l_ac].gao02,"/",DOWNSHIFT(g_gao[l_ac].gao01 CLIPPED)
             END IF
          END IF
 
       AFTER FIELD gao02
          IF cl_null(g_gao[l_ac].gao02) THEN  #FUN-810093 IS NULL THEN
             CALL cl_err('','aap-099',0)
             NEXT FIELD gao02
          ELSE 
             LET ls_tmp = g_gao[l_ac].gao02 CLIPPED
             IF NOT ls_tmp.getIndexOf("TOP",1) AND NOT ls_tmp.getIndexOf("CUST",1) THEN
                CALL cl_err_msg(NULL,"azz-281",g_gao[l_ac].gao02 CLIPPED,20)
             END IF
             IF cl_null(g_gao[l_ac].gao03) THEN
                LET g_gao[l_ac].gao03 = g_gao[l_ac].gao01 CLIPPED||"i"  #MOD-4B0063
             END IF
             IF cl_null(g_gao[l_ac].gao04) THEN    #FUN-810093
                IF g_gao[l_ac].gao01 = "LIB" OR g_gao[l_ac].gao01 = "CLIB" OR
                   g_gao[l_ac].gao01 = "SUB" OR g_gao[l_ac].gao01 = "CSUB" OR
                   g_gao[l_ac].gao01 = "QRY" OR g_gao[l_ac].gao01 = "CQRY" THEN
                   LET g_gao[l_ac].gao04 = g_gao[l_ac].gao02 CLIPPED||"/42m" 
                ELSE
                   LET g_gao[l_ac].gao04 = g_gao[l_ac].gao02 CLIPPED||"/42r" #MOD-4B0063
                END IF
             END IF
#            NEXT FIELD gao04        
          END IF
 
       AFTER FIELD gao03     #FUN-810039
          IF NOT cl_null(g_gao[l_ac].gao03) THEN
             IF g_gao[l_ac].gao03 CLIPPED <> (g_gao[l_ac].gao01 CLIPPED||"i" CLIPPED ) THEN 
                CALL cl_err_msg(NULL,"azz-282",g_gao[l_ac].gao03||"|"||g_gao[l_ac].gao01 CLIPPED,20)
                NEXT FIELD gao03
             END IF
          END IF
 
       AFTER FIELD gao04     #FUN-810039
          IF NOT cl_null(g_gao[l_ac].gao04) THEN
             IF g_gao[l_ac].gao04 CLIPPED = (g_gao[l_ac].gao02 CLIPPED||"/42r" CLIPPED) THEN
             ELSE
                IF (g_gao[l_ac].gao01 = "LIB" OR g_gao[l_ac].gao01 = "CLIB" OR
                    g_gao[l_ac].gao01 = "SUB" OR g_gao[l_ac].gao01 = "CSUB" OR
                    g_gao[l_ac].gao01 = "QRY" OR g_gao[l_ac].gao01 = "CQRY" ) AND
                   g_gao[l_ac].gao04 CLIPPED = (g_gao[l_ac].gao02 CLIPPED||"/42m" CLIPPED) THEN 
                ELSE
                   CALL cl_err_msg(NULL,"azz-283",g_gao[l_ac].gao04||"|"||g_gao[l_ac].gao02 CLIPPED,20)
                   NEXT FIELD gao04
                END IF
             END IF
          END IF
 
       BEFORE DELETE                            #是否取消單身
          IF g_gao_t.gao01 IS NOT NULL THEN
             IF NOT cl_delete() THEN
                CANCEL DELETE
             END IF
             IF l_lock_sw = "Y" THEN
                CALL cl_err("", -263, 1)
                CANCEL DELETE
             END IF
 
             DELETE FROM gao_file WHERE gao01 = g_gao_t.gao01
             IF SQLCA.sqlcode THEN
                 #CALL cl_err(g_gao_t.gao01,SQLCA.sqlcode,0)  #No.FUN-660081
                 CALL cl_err3("del","gao_file",g_gao_t.gao01,"",SQLCA.sqlcode,"","",0)    #No.FUN-660081
                 ROLLBACK WORK
                 CANCEL DELETE
             END IF
             LET g_rec_b=g_rec_b-1
             DISPLAY g_rec_b TO FORMONLY.cn2  
             CLOSE p_zmd_bcl
             COMMIT WORK
          END IF
 
       ON ROW CHANGE
          IF INT_FLAG THEN                 #新增程式段
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_gao[l_ac].* = g_gao_t.*
             CLOSE p_zmd_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
           
          IF l_lock_sw = 'Y' THEN
             CALL cl_err(g_gao[l_ac].gao01,-263,1)
             LET g_gao[l_ac].* = g_gao_t.*
          ELSE
             #No.FUN-A60016 --start--
             #UPDATE gao_file SET gao01=g_gao[l_ac].gao01, 
             #                    gao02=g_gao[l_ac].gao02,
             #                    gao03=g_gao[l_ac].gao03,
             #                    gao04=g_gao[l_ac].gao04 
             # WHERE gao01=g_gao[l_ac].gao01 

             UPDATE gao_file SET gao01=g_gao[l_ac].gao01,
                                 gao02=g_gao[l_ac].gao02,
                                 gao03=g_gao[l_ac].gao03,
                                 gao04=g_gao[l_ac].gao04,
                                 gao05=g_gao[l_ac].gao05
              WHERE gao01=g_gao[l_ac].gao01
             #No.FUN-A60016 --end--

             IF SQLCA.sqlcode THEN
                #CALL cl_err(g_gao[l_ac].gao01,SQLCA.sqlcode,1)  #No.FUN-660081
                CALL cl_err3("upd","gao_file",g_gao_t.gao01,"",SQLCA.sqlcode,"","",1)    #No.FUN-660081
                LET g_gao[l_ac].* = g_gao_t.*
                CLOSE p_zmd_bcl
                ROLLBACK WORK
             ELSE
                CLOSE p_zmd_bcl
                COMMIT WORK
             END IF
          END IF
 
       AFTER ROW
          LET l_ac = ARR_CURR()
         #LET l_ac_t = l_ac          #FUN-D30034 Mark
 
          IF INT_FLAG THEN           #900423
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_gao[l_ac].* = g_gao_t.*
              #FUN-D30034--add--str--
              ELSE
                 CALL g_gao.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30034--add--end--
              END IF
              CLOSE p_zmd_bcl
              ROLLBACK WORK
              EXIT INPUT
          END IF
          LET l_ac_t = l_ac   #FUN-D30034 Add
          CLOSE p_zmd_bcl
         #ROLLBACK WORK       #MOD-B10049 mark 
          COMMIT WORK         #MOD-B10049 add 
 
       ON ACTION modify_program_name
          LET l_gaz01 = DOWNSHIFT(g_gao[l_ac].gao01) 
          CALL p_gaz_item(l_gaz01,'S')   #TQC-760179
          SELECT gaz03 INTO g_gao[l_ac].gaz03 FROM gaz_file 
           WHERE gaz01=l_gaz01 AND gaz02 = g_lang
          DISPLAY g_gao[l_ac].gaz03 TO gaz03
 
       ON ACTION CONTROLO                        #沿用所有欄位
          IF INFIELD(gao01) AND l_ac > 1 THEN
              LET g_gao[l_ac].* = g_gao[l_ac-1].*
              NEXT FIELD gao01
          END IF
 
       ON ACTION CONTROLF
          CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
          CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
       ON ACTION about         #FUN-860033
          CALL cl_about()      #FUN-860033
 
       ON ACTION controlg      #FUN-860033
          CALL cl_cmdask()     #FUN-860033
 
       ON ACTION help          #FUN-860033
          CALL cl_show_help()  #FUN-860033
 
       ON IDLE g_idle_seconds  #FUN-860033
           CALL cl_on_idle()
           CONTINUE INPUT 
 
    END INPUT
 
    CLOSE p_zmd_bcl
    COMMIT WORK
 
    CALL p_zmd_sync_sys()
 
END FUNCTION
 
FUNCTION p_zmd_b_askkey()
    CLEAR FORM
    #No.FUN-A60016 --start--
    #CONSTRUCT g_wc2 ON gao01,gao02,gao03,gao04
    #     FROM s_gao[1].gao01,s_gao[1].gao02,s_gao[1].gao03,
    #          s_gao[1].gao04

    CONSTRUCT g_wc2 ON gao01,gao02,gao03,gao04,gao05
         FROM s_gao[1].gao01,s_gao[1].gao02,s_gao[1].gao03,
              s_gao[1].gao04,s_gao[1].gao05
    #No.FUN-A60016 --end--
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
    END CONSTRUCT
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
 
    CALL p_zmd_b_fill(g_wc2)
END FUNCTION
 
 
FUNCTION p_zmd_b_fill(p_wc2)                  #BODY FILL UP
 
    DEFINE p_wc2       LIKE type_file.chr1000 #No.FUN-680135 VARCHAR(200)
    DEFINE p_gaz01     LIKE gaz_file.gaz01
 
    #No.FUN-A60016 --start--
    #LET g_sql = "SELECT gao01,'',gao02,gao03,gao04",
    #             " FROM gao_file",
    #            " WHERE ", p_wc2 CLIPPED,
    #            " ORDER BY 1"

    LET g_sql = "SELECT gao01,'',gao02,gao03,gao04,gao05",
                 " FROM gao_file",
                " WHERE ", p_wc2 CLIPPED,
                " ORDER BY 1"
    #No.FUN-A60016 --end--

    PREPARE p_zmd_pb FROM g_sql
    DECLARE gao_curs CURSOR FOR p_zmd_pb
 
    CALL g_gao.clear()
    #No.MOD-590314 --start 
    LET g_rec_b = 0
    #No.MOD-590314 --end
    LET g_cnt = 1
 
    FOREACH gao_curs INTO g_gao[g_cnt].*   #單身 ARRAY 填充
        LET g_rec_b = g_rec_b + 1
        IF SQLCA.SQLCODE THEN
           CALL cl_err('foreach:',SQLCA.SQLCODE,1)
           EXIT FOREACH
        ELSE
           LET p_gaz01=DOWNSHIFT(g_gao[g_cnt].gao01) 
           SELECT gaz03 INTO g_gao[g_cnt].gaz03
             FROM gaz_file 
            WHERE gaz01=p_gaz01 AND gaz02 = g_lang
        END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
            CALL cl_err('',9035,0)
            EXIT FOREACH
        END IF
    END FOREACH
    CALL g_gao.deleteElement(g_cnt)
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
END FUNCTION
 
 
FUNCTION p_zmd_bp(p_ud)
 
   DEFINE p_ud  LIKE type_file.chr1        #No.FUN-680135 VARCHAR(1)
 
   IF p_ud<>'G' OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_gao TO s_gao.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY                    # Q.查詢
 
      ON ACTION detail
         LET g_action_choice="detail"
         EXIT DISPLAY                    # B.單身
 
      ON ACTION exporttoexcel  
         LET g_action_choice = "exporttoexcel"
         EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY                    # H.說明
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY                    # Esc.結束
 
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
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---

      # No:TQC-C50159 --start--   
      ON ACTION custadd
         LET g_action_choice="custadd"
         EXIT DISPLAY                    # 檢核並新增客製gao_file       
         
      ON ACTION custmkdir
         LET g_action_choice="custmkdir"
         EXIT DISPLAY                    # 檢核並新增客製mkdir  
      # No:TQC-C50159 --end--        

     
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION p_zmd_set_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680135 VARCHAR(1)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("gao01,gao02,gao04",TRUE)      #MOD-B30699 add gao02,gao04
   END IF
 
END FUNCTION
 
FUNCTION p_zmd_set_no_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680135 VARCHAR(1)
 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
    #CALL cl_set_comp_entry("gao01,goa02,gao04,gao05",FALSE)       #No.FUN-A60016  #MOD-A90187 mark
    # CALL cl_set_comp_entry("gao01,gao02,gao04,gao05",FALSE)       #No.FUN-A60016  #MOD-A90187  #FUN-B40002
      CALL cl_set_comp_entry("gao01,gao02,gao04",FALSE)      #No.FUN-B40002
   END IF
 
END FUNCTION
 
FUNCTION p_zmd_gao02_to_realpath(ls_source)
 
   DEFINE  ls_source   STRING
   DEFINE  ls_target   STRING
   DEFINE  ls_env      STRING
 
   LET ls_target = ""
   WHILE TRUE
      IF ls_source.subString(1,1) = "%" OR ls_source.subString(1,1) = "$" THEN
         IF cl_get_os_type() = "WINDOWS" THEN
            IF ls_source.subString(1,1) = "%" THEN
               LET ls_env = ls_source.subString(2,ls_source.getIndexOf("%",2)-1)
               LET ls_source = ls_source.subString(ls_source.getIndexOf("%",2)+2,ls_source.getLength())
            END IF
         ELSE
            IF ls_source.subString(1,1) = "$" THEN
               LET ls_env = ls_source.subString(2,ls_source.getIndexOf("/",2)-1)
               LET ls_source = ls_source.subString(ls_source.getIndexOf("/",2)+1,ls_source.getLength())
            END IF
         END IF
         LET ls_target = os.Path.join(ls_target,FGL_GETENV(ls_env))
         CONTINUE WHILE
      END IF
      IF ls_source.getIndexOf("/",1) THEN
         LET ls_env = ls_source.subString(1,ls_source.getIndexOf("/",1)-1)
         LET ls_source = ls_source.subString(ls_source.getIndexOf("/",1)+1,ls_source.getLength())
         LET ls_target = os.Path.join(ls_target,ls_env)
         CONTINUE WHILE
      ELSE
         LET ls_target = os.Path.join(ls_target,ls_source)
         EXIT WHILE
      END IF
   END WHILE
       
   RETURN ls_target.trim()
 
END FUNCTION
 
#建立客製系統相關目錄 #建立系統相關目錄 #MOD-4A0205
 
FUNCTION p_zmd_mkdir()
 
   DEFINE l_ind1     LIKE type_file.num5    #No.FUN-680135 SMALLINT
   DEFINE l_ind2     LIKE type_file.num5    #No.FUN-680135 SMALLINT
   DEFINE l_gay01    LIKE gay_file.gay01
   DEFINE l_gao02    LIKE gao_file.gao02
   DEFINE ls_cmd     STRING
   DEFINE ls_tmp     STRING
   DEFINE ls_path    STRING    #FUN-810039
   DEFINE tok        base.StringTokenizer
 
   LET ls_path = g_gao[l_ac].gao02 CLIPPED
   LET l_ind1 = ls_path.getIndexOf("/",1)
   LET l_ind2 = ls_path.getLength()
   LET l_gao02 = ls_path.subString(l_ind1+1,l_ind2)
 
   LET ls_path = p_zmd_gao02_to_realpath(g_gao[l_ac].gao02 CLIPPED)
 
#  #FUN-810093
   IF g_gao[l_ac].gao02 != g_gao_t.gao02 OR g_gao_t.gao02 IS NULL THEN
      IF NOT os.Path.isdirectory(ls_path) THEN
         IF NOT os.Path.mkdir(ls_path) THEN
            CALL cl_err_msg(NULL,"azz-284",ls_path,20)
         END IF
         IF os.Path.isdirectory(ls_path) THEN   #若排定要做卻失敗則判定失敗
            DISPLAY g_gao[l_ac].gao02," directory (",ls_path,") create success!"
            IF l_gao02 = "lib"  OR l_gao02 = "sub"  OR l_gao02 = "qry" OR
               l_gao02 = 'clib' OR l_gao02 = "csub" OR l_gao02 = "cqry" THEN
               LET ls_cmd = "42f 42m 4gl per 4fd sdd"
            ELSE
              #LET ls_cmd = "42f 42m 42r 4gl per 4fd sdd"     #MOD-590314 #TQC-750162
              #LET ls_cmd = "42f 42m 42r 4pw 4gl per 4fd sdd 4rp" #MOD-590314 #TQC-750162 #FUN-B30122 #FUN-C30214 add 4rp
               LET ls_cmd = "42f 42m 42r 4pw 4gl per 4fd sdd sch 4rp" #MOD-590314 #TQC-750162 #FUN-B30122 #FUN-C30214 add 4rp #TQC-C50159
            END IF
            LET tok = base.StringTokenizer.create(ls_cmd," ")
            WHILE tok.hasMoreTokens()
               LET ls_tmp = os.Path.join(ls_path,tok.nextToken())               
               IF NOT os.Path.mkdir(ls_tmp) THEN
                  CALL cl_err_msg(NULL,"azz-284",ls_tmp,20)
               END IF
               #新增4rp下子目錄：sampledata src rdd  
               #FUN-C30214---Start--add
               IF ls_tmp = os.Path.join(ls_path,"4rp") THEN
                  LET ls_cmd ="sampledata src rdd"
                  LET tok = base.StringTokenizer.create(ls_cmd," ")
                  WHILE tok.hasMoreTokens()
                     LET ls_tmp = os.Path.join(os.Path.join(ls_path,"4rp"),tok.nextToken())
                     IF NOT os.Path.mkdir(ls_tmp) THEN
                        CALL cl_err_msg(NULL,"azz-284",ls_tmp,20)
                     END IF 
                  END WHILE
               END IF
               #FUN-C30214---End--add               
            END WHILE
         ELSE
            RETURN FALSE
         END IF
      ELSE
         CALL cl_err_msg(NULL,"azz-285",ls_path,20)
      END IF
 
      # 04/04/19 現行有 n 個語言別  就要做 n 次
      DECLARE config_lang CURSOR FOR
        SELECT DISTINCT gay01 FROM gay_file ORDER BY gay01
 
      FOREACH config_lang INTO l_gay01
         #4rp
         #FUN-C30214---Start--add       
            LET ls_tmp = os.Path.join(os.Path.join(ls_path,"4rp"),l_gay01)
            IF NOT os.Path.mkdir(ls_tmp) THEN
               CALL cl_err_msg(NULL,"azz-284",ls_tmp,20)
            END IF
         #FUN-C30214---Start--add
         
         IF l_gao02[1] = "c" THEN
            LET ls_cmd = gs_cust CLIPPED
         ELSE
            LET ls_cmd = gs_top CLIPPED
         END IF
 
         #help html file
         LET ls_tmp = os.Path.join(ls_cmd,"doc")
         LET ls_tmp = os.Path.join(os.Path.join(ls_tmp,"help"),l_gay01)
         LET ls_tmp = os.Path.join(ls_tmp,l_gao02)
         IF NOT os.Path.mkdir(ls_tmp) THEN
            CALL cl_err_msg(NULL,"azz-284",ls_tmp,20)
         END IF 
 
         LET ls_cmd = os.Path.join(ls_cmd,"config")
 
         #4ad
         LET ls_tmp = os.Path.join(os.Path.join(ls_cmd,"4ad"),l_gay01)
         LET ls_tmp = os.Path.join(ls_tmp,l_gao02)
         IF NOT os.Path.mkdir(ls_tmp) THEN
            CALL cl_err_msg(NULL,"azz-284",ls_tmp,20)
         END IF
      END FOREACH

            
 
      IF l_gao02[1] = "c" THEN
         LET ls_cmd = gs_cust CLIPPED
      ELSE
         LET ls_cmd = gs_top CLIPPED
      END IF
      LET ls_cmd = os.Path.join(ls_cmd,"config")
 
      #4tm
      LET ls_tmp = os.Path.join(ls_cmd,"4tm")
      LET ls_tmp = os.Path.join(ls_tmp,l_gao02)
      IF NOT os.Path.mkdir(ls_tmp) THEN
         CALL cl_err_msg(NULL,"azz-284",ls_tmp,20)
      END IF 
   END IF
   RETURN TRUE
END FUNCTION
 
# FUN-810093 經IT討論後確認由 GP 5.1版起回歸 p_zmd資料為標準增加模組作法
#            未來不再接受由 tiptop_sys/cust_sys 內變更後回寫 db 作法
#            因為此作法會無法作檢核及控管目錄建立作業
#FUNCTION p_zmd_load_sys()
#
#   DEFINE ch1     base.Channel
#   DEFINE ch2     base.Channel
#   DEFINE buff1   STRING
#   DEFINE buff2   STRING
#   DEFINE l_cmd1  STRING 
#   DEFINE l_cmd2  STRING 
#   DEFINE l_ind1  LIKE type_file.num5    #No.FUN-680135 SMALLINT
#   DEFINE l_ind2  LIKE type_file.num5    #No.FUN-680135 SMALLINT
#   DEFINE l_ind3  LIKE type_file.num5    #No.FUN-680135 SMALLINT
#
#   LET ch1 =base.Channel.create() 
#   LET ch2 =base.Channel.create() 
#
#   #FUN-810039
#   IF cl_get_os_type() <> "WINDOWS" THEN   #for all kind of UNIX
#      LET l_cmd1 = "cat ",os.Path.join(os.Path.join(gs_cust CLIPPED,"bin"),"cust_sys")," ",
#                          os.Path.join(os.Path.join(gs_top CLIPPED,"bin"),"tiptop_sys")," ",
#                     "> ",os.Path.join(gs_tempdir CLIPPED,"all_sys")
#   ELSE                                    #for all versions of WINDOWS
#      LET l_cmd1 = "copy ",os.Path.join(os.Path.join(gs_cust CLIPPED,"bin"),"cust_sys")," +",
#                           os.Path.join(os.Path.join(gs_top CLIPPED,"bin"),"tiptop_sys")," "
#                           os.Path.join(gs_tempdir CLIPPED,"all_sys")
#   END IF
#   CALL ch1.openPipe(l_cmd1,"r")
#
##  LET l_cmd1 = "chmod 777 ",gs_tempdir CLIPPED,"/all_sys"
##  RUN l_cmd1
#   LET l_cmd1 = os.Path.join(gs_tempdir CLIPPED,"all_sys")
#   IF NOT os.Path.chrwx(l_cmd1,511) THEN
#      CALL cl_err("Chmod "||os.Path.rootname(l_cmd1)||" Fail!","!",1)
#   END IF
#   
##  LET l_cmd2 = gs_tempdir CLIPPED,"/all_sys"
#   LET l_cmd2 = os.Path.join(gs_tempdir CLIPPED,"all_sys")
#   CALL ch1.openFile(l_cmd2,"r")
#
#   WHILE ch1.read([buff1])
#      LET g_cnt = 1
#      CALL g_gao.clear()
#
#      LET buff1  = buff1.trim()
#      LET l_ind1 = buff1.getIndexOf("=",1)
#      IF cl_get_os_type() <> "WINDOWS" THEN   #for all kind of UNIX
#         LET l_ind2 = buff1.getIndexOf(";",1)   
#         LET g_gao[g_cnt].gao01 = buff1.subString(1,l_ind1 - 1)
#      END IF
#
#      IF NOT cl_null(g_gao[g_cnt].gao01) AND 
#            (g_gao[g_cnt].gao01 MATCHES 'A??' OR g_gao[g_cnt].gao01 MATCHES 'G??'
#          OR g_gao[g_cnt].gao01 MATCHES 'LIB' OR g_gao[g_cnt].gao01 MATCHES 'SUB'
#          OR g_gao[g_cnt].gao01 MATCHES 'QRY' OR g_gao[g_cnt].gao01 MATCHES 'C??'
#          OR g_gao[g_cnt].gao01 MATCHES 'C???') 
#         AND g_gao[g_cnt].gao01  NOT MATCHES 'C??i' THEN
#         LET g_gao[g_cnt].gao02 = buff1.subString(l_ind1 + 1,l_ind2 - 1)
#         INSERT INTO gao_file(gao01,gao02,gao03,gao04)  #No.MOD-470041
#                      VALUES( g_gao[g_cnt].gao01,g_gao[g_cnt].gao02,
#                              g_gao[g_cnt].gao03,g_gao[g_cnt].gao04)
#         LET l_cmd2 = "cd ",gs_tempdir CLIPPED,";grep -i '",
#                      g_gao[g_cnt].gao01 CLIPPED,"i=' all_sys"
#         CALL ch2.openpipe(l_cmd2,"r")
#         LET g_gao[g_cnt].gao03 = NULL
#         LET g_gao[g_cnt].gao04 = NULL
#
#         WHILE ch2.read(buff2)
#            LET buff2 =buff2.trim()
#            LET l_ind1=buff2.getIndexOf("=",1)
#            LET l_ind2=buff2.getIndexOf(";",1)   
#            LET g_gao[g_cnt].gao03 = buff2.subString(1,l_ind1 - 1)
#            LET g_gao[g_cnt].gao04 = buff2.subString(l_ind1 + 1,l_ind2 - 1)
#            #DISPLAY g_gao[g_cnt].gao01,g_gao[g_cnt].gao02,
#                    #g_gao[g_cnt].gao03,g_gao[g_cnt].gao04
#            UPDATE gao_file SET gao03 = g_gao[g_cnt].gao03,  
#                                gao04 = g_gao[g_cnt].gao04
#                   WHERE gao01 = g_gao[g_cnt].gao01 
#         END WHILE
#         CALL ch2.close()
#      END IF
#      LET g_cnt = g_cnt + 1
#   END WHILE
#   CALL ch1.close()
#
##  LET l_cmd1 = "rm -Rf    ",gs_tempdir CLIPPED,"/all_sys"
##  RUN l_cmd1
#   LET l_cmd1 = os.Path.join(gs_tempdir CLIPPED,"all_sys")
#   IF os.Path.chrwx(l_cmd1,511) THEN
#      IF os.Path.delete(l_cmd1) THEN
#      ELSE
#         CALL cl_err("Remove "||os.Path.rootname(l_cmd1)||" Fail!","!",1)
#      END IF
#   ELSE
#      CALL cl_err("Chmod "||os.Path.rootname(l_cmd1)||" Fail!","!",1)
#   END IF
#
#END FUNCTION
 
 
#將p_zmd紀錄的資料分別寫入tiptop_sys及cust_sys #MOD-4A0205
 
FUNCTION p_zmd_sync_sys()
 
   DEFINE ch1     base.Channel
   DEFINE ch2     base.Channel
   DEFINE l_file1 STRING
   DEFINE l_file2 STRING
   DEFINE sb1     base.StringBuffer
   DEFINE buff1   STRING
   DEFINE buff2   STRING
   DEFINE l_cmd   STRING 
   DEFINE l_n     LIKE type_file.num5    #No.FUN-680135 SMALLINT
   DEFINE l_result LIKE type_file.num5   #No.FUN-680135 SMALLINT 
 
   LET ch1 =base.Channel.create() 
   LET ch2 =base.Channel.create() 
   LET l_file1 = os.Path.join(os.Path.join(gs_cust,"bin"),"cust_sys.std")
   LET l_file2 = os.Path.join(os.Path.join(gs_top,"bin"),"tiptop_sys.std")
   LET l_result = 1
 
   CALL ch1.setDelimiter("")  
   CALL ch1.openFile(l_file1,"w")
   CALL ch2.setDelimiter("")  
   CALL ch2.openFile(l_file2,"w")
 
   DROP TABLE temp_gao
   CREATE TEMP TABLE temp_gao(
       gao01 LIKE gao_file.gao01,
       gao02 LIKE gao_file.gao02)  
    DECLARE gao_curs1 CURSOR FOR 
            SELECT gao01,gao02,gao03,gao04 FROM gao_file 
     LET g_cnt = 1
 
   FOREACH gao_curs1 INTO  g_gao_f[g_cnt].gao01,g_gao_f[g_cnt].gao02,
                           g_gao_f[g_cnt].gao03,g_gao_f[g_cnt].gao04
 
      INSERT INTO temp_gao values (g_gao_f[g_cnt].gao01,g_gao_f[g_cnt].gao02)
      INSERT INTO temp_gao values (g_gao_f[g_cnt].gao03,g_gao_f[g_cnt].gao04)
      LET g_cnt = g_cnt +1
   END FOREACH
 
   CALL g_gao_f.clear()
   LET buff1=NULL
   LET g_cnt = 1
   DECLARE gao_curs2 CURSOR FOR SELECT gao01,gao02 FROM temp_gao
   FOREACH gao_curs2 INTO g_gao_f[g_cnt].gao01,g_gao_f[g_cnt].gao02
    
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      IF NOT cl_null(g_gao_f[g_cnt].gao01) OR NOT cl_null(g_gao_f[g_cnt].gao02) THEN
 
#        #FUN-810093
         IF cl_get_os_type() <> "WINDOWS" THEN   #all kinds of UNIX
           LET buff1=g_gao_f[g_cnt].gao01 CLIPPED,"=",g_gao_f[g_cnt].gao02 CLIPPED,";",
                     "export ",g_gao_f[g_cnt].gao01 CLIPPED
         ELSE                                    #all versions of WINDOWS
           LET buff1="set ",g_gao_f[g_cnt].gao01 CLIPPED,"=",g_gao_f[g_cnt].gao02 CLIPPED
         END IF
 
         IF g_gao_f[g_cnt].gao01[1] = 'C' THEN 
            CALL ch1.openFile(l_file1,"a")
            CALL ch1.write(buff1)
            CALL ch1.close()
         ELSE
            CALL ch2.openFile(l_file2,"a")
            CALL ch2.write(buff1)
            CALL ch2.close()
         END IF 
      END IF
       
      LET g_cnt = g_cnt + 1
   END FOREACH
 
   FOR l_n = 1 TO 2
      CASE 
         WHEN l_n = 1
         LET l_cmd = os.Path.join(os.Path.join(gs_cust,"bin"),"cust_sys.std")
         WHEN l_n = 2
         LET l_cmd = os.Path.join(os.Path.join(gs_top,"bin"),"tiptop_sys.std")
      END CASE
 
      IF cl_get_os_type() <> "WINDOWS" THEN   #FUN-970074
         IF NOT os.Path.chrwx(l_cmd,511) THEN
            CALL cl_err_msg(NULL,"azz-286",os.Path.rootname(l_cmd),20)
         END IF
      END IF
      IF os.Path.exists(l_cmd) AND os.Path.size(l_cmd) > 0 THEN
         IF cl_get_os_type() = "WINDOWS" THEN   #FUN-970074
            IF NOT os.Path.copy(l_cmd,os.Path.rootname(l_cmd)||".bat") THEN
               CALL cl_err_msg(NULL,"azz-287",os.Path.rootname(l_cmd)||".bat"||"|"||l_cmd,20)
            END IF
         ELSE
            IF NOT os.Path.copy(l_cmd,os.Path.rootname(l_cmd)) THEN
               CALL cl_err_msg(NULL,"azz-287",os.Path.rootname(l_cmd)||"|"||l_cmd,20)
            END IF
         END IF
      END IF
   END FOR
 
#   LET l_cmd = "chmod 777 ",gs_cust CLIPPED,"/bin/cust_sys.std"
#   RUN l_cmd
 
#   LET l_cmd = "chmod 777 ",gs_top CLIPPED,"/bin/tiptop_sys.std"
#   RUN l_cmd
    
#   RUN "test -s $TOP/bin/tiptop_sys.std" RETURNING l_result
#   #DISPLAY l_result
#   IF NOT l_result THEN
#      LET l_cmd = "cp ",gs_top CLIPPED,"/bin/tiptop_sys.std"," ",gs_top CLIPPED,"/bin/tiptop_sys"
#      RUN l_cmd
#   END IF
#    
#   LET l_result = 1
#    
#   RUN "test -s $CUST/bin/cust_sys.std" RETURNING l_result
#   IF NOT l_result THEN
#      LET l_cmd = "cp ",gs_cust CLIPPED,"/bin/cust_sys.std"," ",gs_cust CLIPPED,"/bin/cust_sys"
#      RUN l_cmd
#   END IF
 
END FUNCTION

#No.TQC-C50159  --start--
FUNCTION p_zmd_custadd()

   DEFINE ls_gay01        LIKE gay_file.gay01
   DEFINE ls_gr_err       LIKE type_file.num5
   DEFINE ls_cnt          LIKE type_file.num5
   DEFINE ls_gao01        LIKE gao_file.gao01
   DEFINE ls_gao05        LIKE gao_file.gao05   
   DEFINE ls_gao01_str    STRING
   DEFINE ls_find         LIKE gao_file.gao01
   DEFINE lr_gao01        LIKE gao_file.gao01
   DEFINE l_log           STRING   
   DEFINE ls_cmd          STRING
   DEFINE l_cmd           STRING
   DEFINE ls_path         STRING
   DEFINE ls_str          STRING
   DEFINE ls_i            LIKE type_file.num5
   DEFINE result          LIKE type_file.num5
   DEFINE g_forupd_sql    STRING
   DEFINE l_cnt           LIKE type_file.num5
   DEFINE l_rec_cnt       LIKE type_file.num5
   DEFINE l_i             LIKE type_file.num5 
   DEFINE l_str           STRING  
   DEFINE l_n             LIKE type_file.num5   

   LET ls_str = NULL
   LET ls_i   = 1   
   LET l_cnt  = 1 
   LET l_i    = 1
    
   DECLARE p_stdck_gao_curs CURSOR FOR
      SELECT gao01,gao05 FROM gao_file WHERE gao01 NOT LIKE 'C%'
   FOREACH p_stdck_gao_curs INTO ls_gao01,ls_gao05
      IF SQLCA.SQLCODE THEN
         LET ls_cmd = "GR ERROR:select data of gao_file error"
         LET ls_gr_err = TRUE
      END IF

      LET ls_gao01 = DOWNSHIFT(ls_gao01)
      IF ls_gao01 = "lib" OR ls_gao01 = "sub" OR ls_gao01 = "qry"
         OR ls_gao01 = "clib" OR ls_gao01 = "csub" OR ls_gao01 = "cqry"
         OR ls_gao01 = "ain"
         OR ls_gao01 = "apy" OR ls_gao01 = "cpy" OR ls_gao01 = "gpy" OR ls_gao01 = "cgpy"   
         OR ls_gao01 MATCHES "w*" OR ls_gao01 MATCHES "cw*" THEN    
         CONTINUE FOREACH
      END IF
   
      LET ls_gao01_str = ls_gao01
      IF ls_gao01[1,1] = "a" THEN
         LET ls_find = "c",ls_gao01_str.subString(2,length(ls_gao01_str))
      ELSE 
         LET ls_find = "c",ls_gao01_str
      END IF
     
      SELECT COUNT(*) INTO l_n FROM gao_file WHERE gao01 = UPPER(ls_find)
      IF l_n = 0 THEN 
         LET g_gaocust[l_cnt].datatype = 'Y'              
         LET g_gaocust[l_cnt].gao01 = UPSHIFT(ls_find)    
         IF DOWNSHIFT(g_gaocust[l_cnt].gao01[1,1]) = "c" THEN
            LET g_gaocust[l_cnt].gao02 = "CUST"
         ELSE
            LET g_gaocust[l_cnt].gao02 = "TOP"
         END IF
         IF cl_get_os_type() = "WINDOWS" THEN
            LET g_gaocust[l_cnt].gao02 = "%",g_gaocust[l_cnt].gao02,"%/",DOWNSHIFT(g_gaocust[l_cnt].gao01 CLIPPED)
         ELSE
            LET g_gaocust[l_cnt].gao02 = "$",g_gaocust[l_cnt].gao02,"/",DOWNSHIFT(g_gaocust[l_cnt].gao01 CLIPPED)
         END IF

         LET g_gaocust[l_cnt].gao03 = g_gaocust[l_cnt].gao01 CLIPPED||"i"  

         IF g_gaocust[l_cnt].gao01 = "LIB" OR g_gaocust[l_cnt].gao01 = "CLIB" OR
            g_gaocust[l_cnt].gao01 = "SUB" OR g_gaocust[l_cnt].gao01 = "CSUB" OR
            g_gaocust[l_cnt].gao01 = "QRY" OR g_gaocust[l_cnt].gao01 = "CQRY" THEN
            LET g_gaocust[l_cnt].gao04 = g_gaocust[l_cnt].gao02 CLIPPED||"/42m" 
         ELSE
            LET g_gaocust[l_cnt].gao04 = g_gaocust[l_cnt].gao02 CLIPPED||"/42r" 
         END IF

         LET g_gaocust[l_cnt].gao05 = ls_gao05
         
         LET l_str = l_str," ",g_gaocust[l_cnt].gao01
         LET l_cnt = l_cnt +1
         
      END IF
   END FOREACH
   LET l_rec_cnt = l_cnt -1
   CALL g_gaocust.deleteElement(l_cnt)
   IF NOT cl_null(l_str) THEN  
      LET l_str = "下列客製模組gao_file資料尚未建立：\n","共：",l_rec_cnt,"個\n",l_str 
      CALL cl_err(l_str,'!',1)
      #針對尚未建立的客製模組秀出詢問視窗,讓使用者決定是否建立
      IF cl_sure(0,0) THEN      
         FOR l_i=1 TO g_gaocust.getLength()
            IF g_gaocust[l_i].datatype = 'Y' THEN
               INSERT INTO gao_file(gao01,gao02,gao03,gao04,gao05) 
                      VALUES(g_gaocust[l_i].gao01,g_gaocust[l_i].gao02,
                             g_gaocust[l_i].gao03,g_gaocust[l_i].gao04,
                             g_gaocust[l_i].gao05)            
            END IF
         END FOR
      END IF 
      CALL p_zmd_custadd_sync_sys()
   ELSE
     LET l_log = "檢核客製模組gao_file資料無缺漏" 
     CALL cl_err(l_log,'!',1)             
   END IF  
   CALL  g_gaocust.clear()
END FUNCTION


FUNCTION p_zmd_custadd_sync_sys()
 
   DEFINE ch1        base.Channel
   DEFINE ch2        base.Channel
   DEFINE l_file1    STRING
   DEFINE sb1        base.StringBuffer
   DEFINE buff1      STRING
   DEFINE buff2      STRING
   DEFINE l_cmd      STRING    
   DEFINE l_result   LIKE type_file.num5 
   DEFINE lr_gao01   LIKE gao_file.gao01
 

   LET ch1 =base.Channel.create() 
   LET l_file1 = os.Path.join(os.Path.join(gs_cust,"bin"),"cust_sys.std")
   LET l_result = 1
 
   CALL ch1.setDelimiter("")  
   CALL ch1.openFile(l_file1,"w")

   DROP TABLE temp_gao
   CREATE TEMP TABLE temp_gao(
       gao01  LIKE gao_file.gao01,
       gao02  LIKE gao_file.gao02)   
   DECLARE gao_custadd_curs1 CURSOR FOR 
       SELECT gao01,gao02,gao03,gao04 FROM gao_file 
   LET g_cnt = 1
 
   FOREACH gao_custadd_curs1 INTO  g_gao_f[g_cnt].gao01,g_gao_f[g_cnt].gao02,
                           g_gao_f[g_cnt].gao03,g_gao_f[g_cnt].gao04
 
      INSERT INTO temp_gao values (g_gao_f[g_cnt].gao01,g_gao_f[g_cnt].gao02)
      INSERT INTO temp_gao values (g_gao_f[g_cnt].gao03,g_gao_f[g_cnt].gao04)
      LET g_cnt = g_cnt +1
   END FOREACH

   CALL g_gao_f.clear()
 
   LET buff1=NULL
   LET g_cnt = 1
   DECLARE gao_custadd_curs2 CURSOR FOR SELECT gao01,gao02 FROM temp_gao
   FOREACH gao_custadd_curs2 INTO g_gao_f[g_cnt].gao01,g_gao_f[g_cnt].gao02 
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF

      IF NOT cl_null(g_gao_f[g_cnt].gao01) OR NOT cl_null(g_gao_f[g_cnt].gao02) THEN
  
         IF cl_get_os_type() <> "WINDOWS" THEN   #all kinds of UNIX
           LET buff1=g_gao_f[g_cnt].gao01 CLIPPED,"=",g_gao_f[g_cnt].gao02 CLIPPED,";",
                     "export ",g_gao_f[g_cnt].gao01 CLIPPED
         ELSE                                    #all versions of WINDOWS
           LET buff1="set ",g_gao_f[g_cnt].gao01 CLIPPED,"=",g_gao_f[g_cnt].gao02 CLIPPED
         END IF
 
         IF g_gao_f[g_cnt].gao01[1] = 'C' THEN 
            CALL ch1.openFile(l_file1,"a")
            CALL ch1.write(buff1)
            CALL ch1.close()
         END IF 
      END IF
       
      LET g_cnt = g_cnt + 1
   END FOREACH

      LET l_cmd = os.Path.join(os.Path.join(gs_cust,"bin"),"cust_sys.std")
 
      IF cl_get_os_type() <> "WINDOWS" THEN   
         IF NOT os.Path.chrwx(l_cmd,511) THEN
            CALL cl_err_msg(NULL,"azz-286",os.Path.rootname(l_cmd),20)
         END IF
      END IF
      IF os.Path.exists(l_cmd) AND os.Path.size(l_cmd) > 0 THEN
         IF cl_get_os_type() = "WINDOWS" THEN   
            IF NOT os.Path.copy(l_cmd,os.Path.rootname(l_cmd)||".bat") THEN
               CALL cl_err_msg(NULL,"azz-287",os.Path.rootname(l_cmd)||".bat"||"|"||l_cmd,20)
            END IF
         ELSE
            IF NOT os.Path.copy(l_cmd,os.Path.rootname(l_cmd)) THEN
               CALL cl_err_msg(NULL,"azz-287",os.Path.rootname(l_cmd)||"|"||l_cmd,20)
            END IF
         END IF
      END IF


END FUNCTION

#建立客製系統相關目錄 #建立系統相關目錄  
FUNCTION p_zmd_custmk()
 
   DEFINE l_ind1     LIKE type_file.num5    
   DEFINE l_ind2     LIKE type_file.num5    
   DEFINE l_gay01    LIKE gay_file.gay01
   DEFINE li_gay01   LIKE gay_file.gay01
   DEFINE l_gao02    LIKE gao_file.gao02
   DEFINE ls_cmd     STRING
   DEFINE ls_tmp     STRING
   DEFINE ls_path    STRING    
   DEFINE tok        base.StringTokenizer
   DEFINE l_cmd           STRING
   DEFINE l_log           STRING   
   DEFINE l_ac            LIKE type_file.num5 
   DEFINE l_rec_ac        LIKE type_file.num5
   DEFINE l_i             LIKE type_file.num5 
   DEFINE l_mkac          LIKE type_file.num5
   DEFINE ls_modulecmd    STRING     
      

   LET g_sql = "SELECT gao01,gao02,gao03,gao04,gao05,'','','','',''",
                 " FROM gao_file"

   PREPARE p_custck_pb FROM g_sql
   DECLARE gao_curs5 CURSOR FOR p_custck_pb
 
   CALL g_gaocust_mk.clear()

   LET g_rec_b = 0
   LET g_cnt   = 1
   LET l_ac    = 1
   LET l_mkac  = 0
   
   FOREACH gao_curs5 INTO g_gaocust_mk[l_ac].*   
      
      IF SQLCA.SQLCODE THEN
         CALL cl_err('foreach:',SQLCA.SQLCODE,1)
         EXIT FOREACH
      END IF
      LET l_ind1  = 0
      LET l_ind2  = 0
      LET l_gao02 = null
      LET g_gaocust_mk[l_ac].mtype   = 'N'
      LET g_gaocust_mk[l_ac].adtype  = 'N'
      LET g_gaocust_mk[l_ac].tmtype  = 'N'
      LET g_gaocust_mk[l_ac].doctype = 'N'
      LET g_gaocust_mk[l_ac].rptype  = 'N'
           
      LET ls_path = g_gaocust_mk[l_ac].gao02 CLIPPED
      LET l_ind1  = ls_path.getIndexOf("/",1)
      LET l_ind2  = ls_path.getLength()
      LET l_gao02 = ls_path.subString(l_ind1+1,l_ind2)
      
      LET ls_path = p_zmd_gao02_to_realpath(g_gaocust_mk[l_ac].gao02 CLIPPED)
      
      IF l_gao02[1] != "c"  THEN 
         CONTINUE FOREACH
      END IF 
      IF l_gao02[1,2] = "cw" AND g_gaocust_mk[l_ac].gao02[1,6] = "$WCUST"  THEN 
         CONTINUE FOREACH
      END IF  

      IF NOT os.Path.isdirectory(ls_path) THEN
         LET g_gaocust_mk[l_ac].mtype = 'Y'
      END IF

      # 現行有 n 個語言別  就要做 n 次
      DECLARE config_lang1 CURSOR FOR
        SELECT DISTINCT gay01 FROM gay_file ORDER BY gay01
      
      FOREACH config_lang1 INTO l_gay01
         IF l_gao02[1] = "c" THEN
            LET ls_cmd = gs_cust CLIPPED
         END IF

         #4rp
         LET ls_tmp = os.Path.join(os.Path.join(ls_path,"4rp"),l_gay01)
         IF NOT os.Path.isdirectory(ls_tmp) THEN
            LET g_gaocust_mk[l_ac].rptype = 'Y'
         END IF     
 
         #help html file
         LET ls_tmp = os.Path.join(ls_cmd,"doc")
         LET ls_tmp = os.Path.join(os.Path.join(ls_tmp,"help"),l_gay01)
         LET ls_tmp = os.Path.join(ls_tmp,l_gao02)
         IF NOT os.Path.isdirectory(ls_tmp) THEN
            LET g_gaocust_mk[l_ac].doctype = 'Y'
         END IF 
      
         LET ls_cmd = os.Path.join(ls_cmd,"config")
      
         #4ad
         LET ls_tmp = os.Path.join(os.Path.join(ls_cmd,"4ad"),l_gay01)
         LET ls_tmp = os.Path.join(ls_tmp,l_gao02)
         IF NOT os.Path.isdirectory(ls_tmp) THEN
            LET g_gaocust_mk[l_ac].adtype = 'Y'      
         END IF 
      
      END FOREACH
 
      IF l_gao02[1] = "c" THEN
         LET ls_cmd = gs_cust CLIPPED
      END IF
      LET ls_cmd = os.Path.join(ls_cmd,"config")
 
      #4tm
      LET ls_tmp = os.Path.join(ls_cmd,"4tm")
      LET ls_tmp = os.Path.join(ls_tmp,l_gao02)
      IF NOT os.Path.isdirectory(ls_tmp) THEN
         LET g_gaocust_mk[l_ac].tmtype = 'Y' 
      END IF  
      IF g_gaocust_mk[l_ac].mtype = 'Y'  OR g_gaocust_mk[l_ac].adtype = 'Y'  OR
         g_gaocust_mk[l_ac].tmtype = 'Y' OR g_gaocust_mk[l_ac].doctype = 'Y' OR
         g_gaocust_mk[l_ac].rptype = 'Y' THEN 
         LET l_log = l_log," ",g_gaocust_mk[l_ac].gao01
         LET l_mkac = l_mkac + 1
      END IF 
      
      LET l_ac = l_ac + 1
     
   END FOREACH  

     
   LET l_rec_ac = l_ac - 1
   CALL g_gaocust_mk.deleteElement(l_ac)
   IF NOT cl_null(l_log) THEN  
      LET l_log = "下列客製模組實體目錄尚未建立：\n","共：",l_mkac,"個\n",l_log 
      CALL cl_err(l_log,'!',1)
      IF cl_sure(0,0) THEN     
         FOR l_i=1 TO g_gaocust_mk.getLength()
            LET l_ind1  = 0
            LET l_ind2  = 0
            LET l_gao02 = null
            IF g_gaocust_mk[l_i].mtype = 'N'  AND g_gaocust_mk[l_i].adtype = 'N' AND
               g_gaocust_mk[l_i].tmtype = 'N' AND g_gaocust_mk[l_i].doctype = 'N' AND
               g_gaocust_mk[l_i].rptype = 'N' THEN  
               CONTINUE FOR
            END IF
            LET ls_path = g_gaocust_mk[l_i].gao02 CLIPPED
            LET l_ind1  = ls_path.getIndexOf("/",1)
            LET l_ind2  = ls_path.getLength()
            LET l_gao02 = ls_path.subString(l_ind1+1,l_ind2)
            LET ls_path = p_zmd_gao02_to_realpath(g_gaocust_mk[l_i].gao02 CLIPPED)
            IF g_gaocust_mk[l_i].mtype = 'Y'  THEN
               IF NOT os.Path.isdirectory(ls_path) THEN
                  IF NOT os.Path.mkdir(ls_path) THEN
                     CALL cl_err_msg(NULL,"azz-284",ls_path,20)
                  END IF
               END IF

               IF os.Path.isdirectory(ls_path) THEN   #若排定要做卻失敗則判定失敗
                  DISPLAY g_gaocust_mk[l_i].gao02," directory (",ls_path,") create success!"
                  IF l_gao02 = "lib"  OR l_gao02 = "sub"  OR l_gao02 = "qry" OR
                     l_gao02 = 'clib' OR l_gao02 = "csub" OR l_gao02 = "cqry" THEN
                     LET ls_cmd = "42f 42m 4gl per 4fd sdd"
                  ELSE
                     # GP 5.3模組下使用目錄結構,模組目錄增加sch及4rp
                     LET ls_cmd = "42f 42m 42r 4gl per 4fd sdd sch 4rp" 
                  END IF
                  LET tok = base.StringTokenizer.create(ls_cmd," ")
                  WHILE tok.hasMoreTokens()
                     LET ls_tmp = os.Path.join(ls_path,tok.nextToken())
                     IF NOT os.Path.mkdir(ls_tmp) THEN
                        CALL cl_err_msg(NULL,"azz-284",ls_tmp,20)       
                     END IF
                     #新增4rp下子目錄：sampledata src rdd  
                     IF ls_tmp = os.Path.join(ls_path,"4rp") THEN
                        LET ls_cmd ="sampledata src rdd"
                        LET tok = base.StringTokenizer.create(ls_cmd," ")
                        WHILE tok.hasMoreTokens()
                           LET ls_tmp = os.Path.join(os.Path.join(ls_path,"4rp"),tok.nextToken())
                           IF NOT os.Path.mkdir(ls_tmp) THEN
                              CALL cl_err_msg(NULL,"azz-284",ls_tmp,20)
                           END IF 
                        END WHILE
                     END IF                      
                  END WHILE
               END IF
            END IF
            IF g_gaocust_mk[l_i].adtype  = 'Y' OR
               g_gaocust_mk[l_i].doctype = 'Y' OR
               g_gaocust_mk[l_i].rptype  = 'Y' THEN
               
               #現行有 n 個語言別  就要做 n 次
               DECLARE config_lang2 CURSOR FOR
                 SELECT DISTINCT gay01 FROM gay_file ORDER BY gay01
               
               FOREACH config_lang2 INTO li_gay01
                  IF l_gao02[1] = "c" THEN
                     LET ls_cmd = gs_cust CLIPPED
                  END IF

                  #4rp
                  LET ls_modulecmd = os.Path.join(ls_cmd,DOWNSHIFT(g_gaocust_mk[l_i].gao01))
                  LET ls_tmp = os.Path.join(ls_modulecmd,"4rp")
                  IF NOT os.Path.isdirectory(ls_tmp) THEN
                     IF NOT os.Path.mkdir(ls_tmp) THEN
                        CALL cl_err_msg(NULL,"azz-284",ls_tmp,20)
                     ELSE 
                        LET ls_tmp = os.Path.join(os.Path.join(ls_modulecmd,"4rp"),"sampledata")
                        IF NOT os.Path.mkdir(ls_tmp) THEN
                           CALL cl_err_msg(NULL,"azz-284",ls_tmp,20)
                        END IF
                        LET ls_tmp = os.Path.join(os.Path.join(ls_modulecmd,"4rp"),"src")
                        IF NOT os.Path.mkdir(ls_tmp) THEN
                           CALL cl_err_msg(NULL,"azz-284",ls_tmp,20)
                        END IF
                        LET ls_tmp = os.Path.join(os.Path.join(ls_modulecmd,"4rp"),"rdd")
                        IF NOT os.Path.mkdir(ls_tmp) THEN
                           CALL cl_err_msg(NULL,"azz-284",ls_tmp,20)
                        END IF
                     END IF   
                  END IF                  
                  LET ls_tmp = os.Path.join(os.Path.join(ls_modulecmd,"4rp"),li_gay01)
                  IF NOT os.Path.isdirectory(ls_tmp) THEN
                     IF NOT os.Path.mkdir(ls_tmp) THEN
                        CALL cl_err_msg(NULL,"azz-284",ls_tmp,20)
                     END IF
                  END IF
   
                  #help html file
                  LET ls_tmp = os.Path.join(ls_cmd,"doc")
                  LET ls_tmp = os.Path.join(os.Path.join(ls_tmp,"help"),li_gay01)
                  LET ls_tmp = os.Path.join(ls_tmp,DOWNSHIFT(g_gaocust_mk[l_i].gao01))
                  IF NOT os.Path.isdirectory(ls_tmp) THEN
                     IF NOT os.Path.mkdir(ls_tmp) THEN
                        CALL cl_err_msg(NULL,"azz-284",ls_tmp,20)           
                     END IF 
                  END IF
               
                  LET ls_cmd = os.Path.join(ls_cmd,"config")
               
                  #4ad
                  LET ls_tmp = os.Path.join(os.Path.join(ls_cmd,"4ad"),li_gay01)
                  LET ls_tmp = os.Path.join(ls_tmp,DOWNSHIFT(g_gaocust_mk[l_i].gao01))
                  IF NOT os.Path.isdirectory(ls_tmp) THEN
                     IF NOT os.Path.mkdir(ls_tmp) THEN
                        CALL cl_err_msg(NULL,"azz-284",ls_tmp,20)
                     END IF 
                  END IF
               END FOREACH
            END IF
            IF g_gaocust_mk[l_i].tmtype = 'Y' THEN
               IF l_gao02[1] = "c" THEN
                  LET ls_cmd = gs_cust CLIPPED
               END IF
               LET ls_cmd = os.Path.join(ls_cmd,"config")
               
               #4tm
               LET ls_tmp = os.Path.join(ls_cmd,"4tm")
               LET ls_tmp = os.Path.join(ls_tmp,DOWNSHIFT(g_gaocust_mk[l_i].gao01))
               IF NOT os.Path.isdirectory(ls_tmp) THEN
                  IF NOT os.Path.mkdir(ls_tmp) THEN
                     CALL cl_err_msg(NULL,"azz-284",ls_tmp,20)
                  END IF 
               END IF         
            END IF                   
         END FOR
      END IF
   ELSE
      LET l_log = "檢核客製模組實體目錄無缺漏" 
      CALL cl_err(l_log,'!',1)       
   END IF  

   LET l_log = null
   LET ls_tmp = null
   LET ls_path = null
   LET l_mkac  = 0
  
END FUNCTION 
#No.TQC-C50159  --end-- 
