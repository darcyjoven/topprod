# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: p_zz_proj.4gl
# Descriptions...: 程式專案建立
# Date & Author..: 10/01/11 By alex  #FUN-B30007
# Modify.........: No:FUN-A30035 10/03/09 by dxfwo  GP5.2 使用unix2dos 需區分只有UNIX可用
# Modify.........: No:FUN-B30039 11/03/15 by jrg542 去除原使用T的環境變數CDPATH(無效變數)
# Modify.........: No:FUN-B50030 11/05/17 by jrg542 加入回讀4pw功能

IMPORT os
DATABASE ds

GLOBALS "../../config/top.global"

DEFINE mc_zz01    LIKE zz_file.zz01
DEFINE mc_zz011   LIKE zz_file.zz011
DEFINE ms_path    STRING
DEFINE ms_arg1    STRING

DEFINE gi_4gl_row           LIKE type_file.num10    --4pw 4gl筆數
DEFINE gi_4fd_row           LIKE type_file.num10    --4pw 4fd筆數
DEFINE gi_gal               LIKE type_file.num10    --gal筆數
DEFINE gi_gax               LIKE type_file.num10    --gax筆數
DEFINE   g_gal_4pw          DYNAMIC ARRAY OF RECORD
         gal01              LIKE gal_file.gal01,    --link 程式代碼
         gal02              LIKE gal_file.gal02,    --模組名稱
         gal03              LIKE gal_file.gal03     --程式名稱
                            END RECORD
DEFINE   g_gax_4pw          DYNAMIC ARRAY OF RECORD
         gax01              LIKE gax_file.gax01,    --程式代碼
         gax02              LIKE gax_file.gax02,    --畫面代碼
         gax_module         STRING                  --模組名稱
                            END RECORD   
DEFINE   g_gal              DYNAMIC ARRAY OF RECORD
         gal01              LIKE gal_file.gal01,    --link 程式代碼
         gal02              LIKE gal_file.gal02,    --模組名稱
         gal03              LIKE gal_file.gal03,    --程式名稱
         gal_flag           LIKE type_file.CHR1     --註記                    
                            END RECORD
                            
DEFINE   g_gax              DYNAMIC ARRAY OF RECORD
         gax01              LIKE gax_file.gax01,    --程式代碼
         gax02              LIKE gax_file.gax02,    --畫面代碼
         gax03              LIKE gax_file.gax03,    --是否實際存在
         gax04              LIKE gax_file.gax04,    --是否為help使用
         gax05              LIKE gax_file.gax05,    --客製碼
         gax_flag           LIKE type_file.CHR1,    --註記
         gax_module         STRING                  --模組  
                            END RECORD 
MAIN
   DEFINE l_str              STRING   

   LET mc_zz01 = ARG_VAL(1)          #程式代號
   LET ms_arg1 = ARG_VAL(2)         #g 產生4pw及 r 回讀4pw

   LET g_bgjob = "Y"
   IF cl_null(ms_arg1) THEN
      LET ms_arg1 = "g"              #預設產生4pw  
   END IF
   
   IF (NOT cl_user()) THEN
      EXIT PROGRAM        
   END IF
   
   WHENEVER ERROR CALL cl_err_msg_log
   
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM      
   END IF

   IF p_zz_proj_check() THEN
      IF ms_arg1 = "g" THEN
         CALL p_zz_proj_gen4pw()
         IF os.Path.separator()= "/" THEN   #NO.FUN-A30035
             RUN "unix2dos "||ms_path       #unix2dos: converting file ms_path to DOS format ...        
             LET l_str = cl_getmsg("azz1074",g_lang)   #取得訊息 ze_file            
             --CALL cl_msgany(0,0,l_str)       #提示視窗
             CALL p_zz_proj_msg(l_str)
         END IF                             #NO.FUN-A30035 
      ELSE
         IF ms_arg1 = "r" THEN
            CALL p_zz_proj_reload4pw()
            DISPLAY "Program ",ms_path," Reload successfully !"
            LET l_str = cl_getmsg("azz1074",g_lang)
            --CALL cl_msgany(0,0,l_str)       #提示視窗
            CALL p_zz_proj_msg(l_str)
         END IF
      END IF
         
   END IF     
END MAIN


PRIVATE FUNCTION p_zz_proj_check() 

   SELECT zz011 INTO mc_zz011 FROM zz_file WHERE zz01=mc_zz01    #mc_zz011 模組代碼
   IF STATUS OR cl_null(mc_zz011) THEN
      DISPLAY "Program ",mc_zz01," Not Exists!, Please Check and Redo Again!"
      RETURN FALSE
   END IF
                                           #/u3/top/azz / 4pw                  / 程式代號.4pw 
   LET ms_path = os.Path.join(os.Path.join(FGL_GETENV(mc_zz011),"4pw"),mc_zz01 CLIPPED||".4pw")
   RETURN TRUE

END FUNCTION



PRIVATE FUNCTION p_zz_proj_gen4pw()

  DEFINE w om.SaxDocumentHandler                 #interface to write an XML filter
  DEFINE a,n om.SaxAttributes
  DEFINE lc_gax02   LIKE gax_file.gax02
  DEFINE lc_gal02   LIKE gal_file.gal02
  DEFINE lc_gal03   LIKE gal_file.gal03
  DEFINE ls_tmp     STRING

  LET w = om.XmlWriter.createFileWriter(ms_path)      #Creating a SaxDocumentHandler object
  LET a = om.SaxAttributes.create()                   #empty SaxAttributes object
  LET n = om.SaxAttributes.create()

  CALL w.startDocument()                              #the beginning of the document

    CALL n.clear()
    CALL n.addAttribute("defaultApplication","18736") #(屬性,值)
    CALL n.addAttribute("version","2.2")              #(屬性,值)           
    CALL w.startElement("Workspace",n)                #把屬性放進(元素)

      CALL a.clear()
      CALL w.startElement("BuildRuleList",a)

        #Build Rule For 4gl
        CALL p_zz_proj_addBuildRule(w,"4gl")

        #Build Rule For 4fd
        CALL p_zz_proj_addBuildRule(w,"4fd")

        #Build Rule For 4db
        CALL p_zz_proj_addBuildRule(w,"4db")

      CALL w.endElement("BuildRuleList")              #結束tag(元素)

      CALL a.clear()
      CALL a.addAttribute("label",mc_zz01 CLIPPED)
      CALL a.addAttribute("targetDirectory","$(WorkspaceDir)/../../")
      CALL w.startElement("Project",a)

        CALL n.clear()
        CALL n.addAttribute("externalDependencies","lib.42x||sub.42x||qry.42x||libgre.42x||WSHelper.42m")
        CALL n.addAttribute("id","18736")
        CALL n.addAttribute("label",mc_zz01 CLIPPED)
        CALL n.addAttribute("targetDirectory","$(WorkspaceDir)/../42r/")
        CALL w.startElement("Application",n)

           #選出關聯 4fd 檔, 參照 gax
           DECLARE p_zz_proj_4fd_cs CURSOR FOR
           SELECT gax02 FROM gax_file WHERE gax01 = mc_zz01 ORDER BY gax02
           FOREACH p_zz_proj_4fd_cs INTO lc_gax02
              LET ls_tmp = "../../",DOWNSHIFT(mc_zz011) CLIPPED,"/4fd/",lc_gax02,".4fd"
              CALL p_zz_proj_addFile(w,ls_tmp.trim())
           END FOREACH

           #選出關聯 4gl 檔, 參照 gal
           DECLARE p_zz_proj_4gl_cs CURSOR FOR
           SELECT gal02,gal03 FROM gal_file WHERE gal01 = mc_zz01 AND gal04 = "Y" ORDER BY gal02,gal03
           FOREACH p_zz_proj_4gl_cs INTO lc_gal02,lc_gal03
              LET ls_tmp = "../../",DOWNSHIFT(lc_gal02) CLIPPED,"/4gl/",lc_gal03,".4gl"
              CALL p_zz_proj_addFile(w,ls_tmp.trim())
           END FOREACH

        CALL w.endElement("Application") #ap
      CALL w.endElement("Project")       #project
    CALL w.endElement("Workspace")       #4pw
  CALL w.endDocument()

END FUNCTION


PRIVATE FUNCTION p_zz_proj_addBuildRule(w,ls_type)

  DEFINE w om.SaxDocumentHandler
  DEFINE a om.SaxAttributes
  DEFINE ls_type STRING

  LET a = om.SaxAttributes.create()
  
  CALL a.clear()
  CALL a.addAttribute("additionalDependencies","")
  
  CASE
     WHEN ls_type = "4gl"
        CALL a.addAttribute("commands","fglrun $(InputDir)/../../ds4gl2/bin/gen42m $(InputBaseName) debug") #command line
        CALL a.addAttribute("description","TIPTOP GP5.2 Source Code") #name
        CALL a.addAttribute("enabled","true") #核取方塊
        CALL a.addAttribute("fileType","application/genero-4gl")      #fileType
        CALL a.addAttribute("id","1263177329982")
        CALL a.addAttribute("outputFiles","$(InputDir)/../42m/$(InputBaseName).42m") #outputFiles

     WHEN ls_type = "4fd"
        CALL a.addAttribute("commands","$(4fdcomp) \"$(InputPath)\";$(move) \"$(InputDir)/$(InputBaseName).42f\" \"$(InputDir)/../42f/$(InputBaseName).42f\"") #command line
        CALL a.addAttribute("description","TIPTOP GP5.2 Form Source")  #name
        CALL a.addAttribute("enabled","true") #核取方塊
        CALL a.addAttribute("fileType","application/generostudio-4fd") #fileType
        CALL a.addAttribute("id","1263177384571")
        CALL a.addAttribute("outputFiles","$(InputDir)/../42f/$(InputBaseName).42f") #outputFiles 

     WHEN ls_type = "4db"
        CALL a.addAttribute("commands","$(4dbcomp) $(CompilerOptions) \"$(InputPath)\"")    #command line
        CALL a.addAttribute("description","TIPTOP GP5.2 Database Schema") #name
        CALL a.addAttribute("enabled","false") #核取方塊
        CALL a.addAttribute("fileType","application/genero-4db") #fileType  
        CALL a.addAttribute("id","126318064624")
        CALL a.addAttribute("outputFiles","$(InputtDir)/../../schema/$(InputBaseName).sch") #outputFiles
     OTHERWISE RETURN
  END CASE
  
  CALL w.startElement("BuildRule",a)
  CALL w.endElement("BuildRule")

END FUNCTION


PRIVATE FUNCTION p_zz_proj_addFile(w,ls_filepath)

  DEFINE w om.SaxDocumentHandler
  DEFINE a om.SaxAttributes
  DEFINE ls_filepath  STRING

  LET a = om.SaxAttributes.create()
  
  CALL a.clear()
  CALL a.addAttribute("filePath",ls_filepath)
  CALL w.startElement("File",a)
  CALL w.endElement("File")
  
END FUNCTION



#FUN-B50030 -- START
PRIVATE FUNCTION p_zz_proj_reload4pw()         #回讀4pw    
    
    DEFINE l_i             LIKE type_file.num10
    DEFINE l_j             LIKE type_file.num10
    DEFINE li_index        LIKE type_file.num10 
    DEFINE l_counter       LIKE type_file.num10
    DEFINE lb_4glflag      BOOLEAN
    DEFINE lb_4fdflag      BOOLEAN
    DEFINE l_msg           STRING 
    DEFINE l_gal02         LIKE gal_file.gal02    --模組名稱
            
    
    #讀回 4pw 資料，並分別與 gal / gax 做比對 
    CALL p_zz_proj_get_4pw()       #讀回4pw的資料
    CALL p_zz_proj_get_gal()       #取得4gl的資料
    CALL p_zz_proj_get_gax()       #取得4fd的資料

    LET l_counter = 0
    LET li_index = 0
    #4pw 資料 跟 gal 比對
    FOR l_i = 1 TO gi_4gl_row # 4pw 筆數
        FOR l_j = 1 TO gi_gal   # gal 4gl 筆數  
            IF g_gal_4pw[l_i].gal03 = g_gal[l_j].gal03 THEN    #比對程式
                IF g_gal_4pw[l_i].gal02 = g_gal[l_j].gal02 THEN   #比對模組
                      LET g_gal[l_j].gal_flag = 'V'  #不用異動
                      CONTINUE FOR
                ELSE
                     LET g_gal[l_j].gal_flag = 'U'   #update
                     LET g_gal[l_j].gal02 = g_gal_4pw[l_i].gal02  
                END IF
            ELSE
                LET l_counter = l_counter + 1
                IF l_counter =  gi_gal THEN

                    --CALL g_gal.insertElement(gi_gal)
                    CALL g_gal.appendElement()
                    LET g_gal[gi_gal+1].gal01 = g_gal_4pw[l_i].gal01
                    LET g_gal[gi_gal+1].gal02 = g_gal_4pw[l_i].gal02
                    LET g_gal[gi_gal+1].gal03 = g_gal_4pw[l_i].gal03
                    LET g_gal[gi_gal+1].gal_flag = 'I'   #insert
                    LET li_index = gi_gal+1
                END IF                        
            END IF
        END FOR
        IF l_counter = gi_gal THEN
            LET gi_gal = li_index
        END IF
        LET l_counter = 0
    END FOR

    LET l_counter = 0
    LET li_index = 0
    
    #gal 資料 跟 4pw 比對
    FOR l_i = 1 TO gi_gal             # gal 筆數  
        FOR l_j = 1 TO gi_4gl_row   # 4pw 4gl 筆數        
            IF g_gal[l_j].gal03  =  g_gal_4pw[l_i].gal03 THEN    #比對程式
                IF g_gal[l_j].gal02 = DOWNSHIFT(g_gal_4pw[l_i].gal02)   THEN   #比對模組
                      IF g_gal[l_i].gal_flag = 'V' OR g_gal[l_i].gal_flag = 'I' THEN
                        CONTINUE FOR
                      END IF
                END IF                    
            END IF
        END FOR
    END FOR
    
    #判斷 gal 資料註記 
    FOR l_i = 1 TO gi_gal
         
        IF g_gal[l_i].gal_flag IS null OR  g_gal[l_i].gal_flag = '' THEN
            LET g_gal[l_i].gal_flag = 'D'  #刪除 
        END IF  
    END FOR 

    LET l_counter = 0
    
    #4pw 4fd 資料 跟 gax 比對
    FOR l_i = 1 TO gi_4fd_row # 4pw 4fd 筆數 
        FOR l_j = 1 TO gi_gax   # gax 筆數 
            IF g_gax_4pw[l_i].gax02 = g_gax[l_j].gax02 THEN    #比對程式

                IF g_gax_4pw[l_i].gax_module = g_gax[l_j].gax_module THEN   #比對模組                        
                      LET g_gax[l_j].gax_flag = 'V'  #不用異動
                      CONTINUE FOR
                ELSE
                     LET g_gax[l_j].gax_flag = 'U'   #update  
                
                END IF
            ELSE
                LET l_counter = l_counter + 1
                IF l_counter =  gi_gax THEN
                    --CALL g_gax.insertElement(gi_gax)
                    CALL g_gax.appendElement()
                    LET g_gax[gi_gax+1].gax01 = g_gax_4pw[l_i].gax01   #程式代碼
                    LET g_gax[gi_gax+1].gax02 = g_gax_4pw[l_i].gax02   #畫面檔代碼
                    LET g_gax[gi_gax+1].gax03 = "Y"                    #是否實際存在
                    LET g_gax[gi_gax+1].gax04 = "Y"                    #是否help

                    IF g_gax_4pw[l_i].gax_module.subString(1,2) = "c" THEN
                        LET g_gax[gi_gax+1].gax05 = "Y"    #客製碼 
                    ELSE
                        LET g_gax[gi_gax+1].gax05 = "N"    #客製碼
                    END IF
                    LET g_gax[gi_gax+1].gax_flag = 'I'   #insert
                    LET li_index = gi_gax+1
                END IF
                              
            END IF
        END FOR
        IF l_counter = gi_gax THEN
            LET gi_gax = li_index
        END IF 
        
        LET l_counter = 0
    END FOR
    LET li_index = 0
    LET l_counter = 0
    
    #gax 資料 跟 4pw 比對
    FOR l_i = 1 TO gi_gal             # gax 筆數  
        FOR l_j = 1 TO gi_4gl_row   # 4pw 4fd 筆數 
            IF g_gax[l_j].gax02  =  g_gax_4pw[l_i].gax02 THEN    #比對程式
                IF g_gax[l_j].gax_module = g_gax_4pw[l_i].gax_module   THEN   #比對模組
                    IF g_gax[l_i].gax_flag = 'V' OR g_gax[l_i].gax_flag = 'I' THEN
                        CONTINUE FOR
                    END IF
                END IF                  
            END IF
        END FOR
    END FOR
    
   #判斷 gax 資料註記 
    FOR l_i = 1 TO gi_gax               
        IF g_gax[l_i].gax_flag IS NULL OR g_gax[l_i].gax_flag = '' THEN
            LET g_gax[l_i].gax_flag = 'D'  #刪除 
        END IF
    END FOR 

    LET lb_4glflag = false
    IF gi_gal > 0 THEN        #判斷4gl是否需要異動 
        FOR l_i = 1 TO gi_gal 
            CASE
            WHEN g_gal[l_i].gal_flag = 'U' OR g_gal[l_i].gal_flag = 'I' OR g_gal[l_i].gal_flag = 'D'
                LET g_gal[l_i].gal02 = UPSHIFT(g_gal[l_i].gal02)
                LET lb_4glflag = TRUE
                EXIT FOR
            END CASE 
        END FOR
    END IF

    IF gi_gax > 0 THEN        #判斷4fd是否需要異動 
        FOR l_i = 1 TO gi_gax  
            CASE
            WHEN g_gax[l_i].gax_flag = 'U' OR g_gax[l_i].gax_flag = 'I' OR g_gax[l_i].gax_flag = 'D'
                LET lb_4fdflag = TRUE
                EXIT FOR
            END CASE
        END FOR
    END IF
    
    IF lb_4glflag OR  lb_4fdflag THEN
        IF NOT cl_confirm("azz1075") THEN  #是否更新
            EXIT PROGRAM 
        END IF
        
        #更新 gal (4gl)
        IF lb_4glflag THEN
            BEGIN WORK    
            FOR l_i = 1 TO gi_gal  # 4gl 
                LET l_gal02 = UPSHIFT(g_gal[l_i].gal02)
                CASE g_gal[l_i].gal_flag                    
                    WHEN  'U'                    
                         UPDATE gal_file SET gal02 = l_gal02
                        WHERE gal01 = g_gal[l_i].gal01 AND gal03 = g_gal[l_i].gal03         
                        IF SQLCA.SQLCODE = 0 THEN
                            COMMIT WORK
                        ELSE
                            LET l_msg = g_gal[l_i].gal01," ",g_gal[l_i].gal02," ",g_gal[l_i].gal03     
                            CALL cl_err3("upd","gal_file",l_msg ,"",SQLCA.sqlcode,"","",1)
                            ROLLBACK WORK
                        END IF 
                    WHEN  'I'
                        INSERT INTO gal_file (gal01,gal02,gal03,gal04)
                            VALUES (g_gal[l_i].gal01,l_gal02,g_gal[l_i].gal03,"Y")
                        IF SQLCA.SQLCODE = 0 THEN
                            COMMIT WORK
                        ELSE
                            LET l_msg = g_gal[l_i].gal01," ",g_gal[l_i].gal02," ",g_gal[l_i].gal03     
                            CALL cl_err3("ins","gal_file",l_msg ,"",SQLCA.sqlcode,"","",1)
                            ROLLBACK WORK
                        END IF
                    WHEN  'D'
                        DELETE FROM gal_file 
                            WHERE gal01 = g_gal[l_i].gal01 AND gal03 = g_gal[l_i].gal03

                        IF SQLCA.SQLCODE = 0 THEN
                            COMMIT WORK
                        ELSE
                            LET l_msg = g_gal[l_i].gal01," ",g_gal[l_i].gal02," ",g_gal[l_i].gal03      
                            CALL cl_err3("del","gal_file",l_msg ,"",SQLCA.sqlcode,"","",1)
                            ROLLBACK WORK
                        END IF     
                END CASE
                
            END FOR
        END IF 

        #更新 gax (4fd)
        IF lb_4fdflag THEN
            BEGIN WORK
            FOR l_i = 1 TO gi_gax  # 4fd 
                CASE g_gax[l_i].gax_flag
                    WHEN 'U'
                        UPDATE gax_file SET gax01 = g_gax[l_i].gax01  
                            WHERE gax01 = g_gax[l_i].gax01 AND gax02 = g_gax[l_i].gax02 
                        
                        IF SQLCA.SQLCODE = 0 THEN
                            COMMIT WORK
                        ELSE
                            LET l_msg = g_gax[l_i].gax01 
                            CALL cl_err3("upd","gax_file",l_msg,"",SQLCA.sqlcode,"","",1)
                            ROLLBACK WORK
                        END IF 
                    WHEN 'I'
                        INSERT INTO gax_file (gax01,gax02,gax03,gax04,gax05)
                            VALUES (g_gax[l_i].gax01,g_gax[l_i].gax02,g_gax[l_i].gax03,
                                g_gax[l_i].gax04,g_gax[l_i].gax05)
                        IF SQLCA.SQLCODE = 0 THEN
                            COMMIT WORK
                        ELSE
                            LET l_msg = g_gax[l_i].gax01," ",g_gax[l_i].gax02," ",g_gax[l_i].gax03, " ",
                                g_gax[l_i].gax04," ", g_gax[l_i].gax05     
                            CALL cl_err3("ins","gax_file",l_msg ,"",SQLCA.sqlcode,"","",1)
                            ROLLBACK WORK
                        END IF         
                    WHEN 'D'
                        DELETE FROM gax_file 
                            WHERE gax01 = g_gax[l_i].gax01 AND gax02 = g_gax[l_i].gax02

                        IF SQLCA.SQLCODE = 0 THEN
                            COMMIT WORK
                        ELSE
                            LET l_msg = g_gax[l_i].gax01," ",g_gax[l_i].gax02," ",g_gax[l_i].gax03, " ",
                                g_gax[l_i].gax04," ", g_gax[l_i].gax05
                            CALL cl_err3("del","gax_file",l_msg ,"",SQLCA.sqlcode,"","",1)    
                            ROLLBACK WORK
                        END IF

                END CASE
                                                                       
            END FOR
        END IF 
    END IF
END FUNCTION


PRIVATE FUNCTION p_zz_proj_get_gal()

   
   DEFINE lc_gal01     LIKE gal_file.gal01
   DEFINE lc_gal02     LIKE gal_file.gal02
   DEFINE lc_gal03     LIKE gal_file.gal03
   DEFINE l_row        LIKE type_file.num10

   LET l_row = 0
   
   #選出關聯 4gl 檔, 參照 gal
    DECLARE p_zz_proj_4gl_cs1 CURSOR FOR
        SELECT gal01,gal02,gal03 FROM gal_file WHERE gal01 = mc_zz01 
        AND gal04 = "Y" ORDER BY gal02,gal03
    FOREACH p_zz_proj_4gl_cs1 INTO lc_gal01,lc_gal02,lc_gal03 #程式代碼,模組,程式名稱
        
        CALL g_gal.appendElement()
        
        LET g_gal[l_row+1].gal01 = lc_gal01              #程式代碼
        LET g_gal[l_row+1].gal02 = DOWNSHIFT(lc_gal02)   #模組
        LET g_gal[l_row+1].gal03 = lc_gal03              #程式名稱
                        
        LET l_row = l_row + 1 
        LET gi_gal = l_row
    END FOREACH
END FUNCTION

PRIVATE FUNCTION p_zz_proj_get_gax()
   
   DEFINE lc_gax01     LIKE gax_file.gax01
   DEFINE lc_gax02     LIKE gax_file.gax02
   DEFINE lc_gax03     LIkE gax_file.gax03
   DEFINE lc_gax04     LIKE gax_file.gax04
   DEFINE lc_gax05     LIKE gax_file.gax05
   DEFINE l_row        LIKE type_file.num10
   
   LET l_row = 0
    #選出關聯 4fd 檔, 參照 gax
    DECLARE p_zz_proj_4fd_cs1 CURSOR FOR
        SELECT gax01,gax02,gax03,gax04,gax05 FROM gax_file WHERE gax01 = mc_zz01 
        ORDER BY gax02
    FOREACH p_zz_proj_4fd_cs1 INTO lc_gax01,lc_gax02,lc_gax03,lc_gax04,lc_gax05

        CALL g_gal.appendElement()
        
        LET g_gax[l_row+1].gax01 = lc_gax01               #程式代碼
        LET g_gax[l_row+1].gax02 = lc_gax02               #畫面代碼    
        LET g_gax[l_row+1].gax03 = lc_gax03               #是否實際存在
        LET g_gax[l_row+1].gax04 = lc_gax04               #是否為help使用
        LET g_gax[l_row+1].gax05 = lc_gax05               #客製碼
        LET g_gax[l_row+1].gax_module = DOWNSHIFT(mc_zz011)    #模組
        LET l_row = l_row + 1
        LET gi_gax = l_row
    END FOREACH

END FUNCTION

PRIVATE FUNCTION p_zz_proj_get_4pw()

    DEFINE  li_4gl_index        LIKE type_file.num10,
            li_4fd_index        LIKE type_file.num10,   
            lxml_reader       om.XmlReader,
            ls_data           STRING,
            lsax_attrib       om.SaxAttributes,
            ls_name           STRING,
            ls_path           STRING, 
            ls_4gl            STRING,
            ls_4gl_no         STRING,
            ls_4fd_no         STRING,
            ls_temp           STRING,
            ls_4fd            STRING,
            ls_dir_name       STRING,
            ls_root_name      STRING,
            ls_module_name    STRING,
            lsax_tag_name     STRING
            
   CALL g_gal_4pw.clear() 
   CALL g_gax_4pw.clear()
   
   LET ls_path = ms_path 
   LET li_4gl_index = 0
   LET li_4fd_index = 0
   LET lxml_reader = om.XmlReader.createFileReader(ls_path ) 
   LET ls_data = lxml_reader.read()
   
   WHILE ls_data IS NOT NULL
   
      CASE ls_data
         WHEN "StartElement"
            LET lsax_attrib = lxml_reader.getAttributes()
            LET lsax_tag_name = lxml_reader.getTagName()

            CASE lsax_tag_name
                WHEN "File"
                    LET ls_name = lsax_attrib.getValue("filePath")

                IF (NOT cl_null(ls_name)) THEN
                
                    LET ls_name = ls_name.trim()
                    LET ls_temp = os.Path.extension(ls_name)
                    
                    IF ls_temp = "4fd" THEN
                    
                        LET ls_4fd = os.Path.basename(ls_name)
                        LET ls_4fd_no = os.Path.rootname(ls_4fd)
                        LET ls_root_name = os.Path.dirName(ls_name)
                        LET ls_dir_name = os.Path.dirName(ls_root_name)
                        LET ls_module_name = os.Path.basename(ls_dir_name) 
                                                                       
                        LET g_gax_4pw[li_4fd_index+1].gax01 = mc_zz01       #程式代碼
                        LET g_gax_4pw[li_4fd_index+1].gax02 = ls_4fd_no     #畫面代碼 
                        LET g_gax_4pw[li_4fd_index+1].gax_module = ls_module_name     #模組 
                        LET li_4fd_index = li_4fd_index + 1
                        LET gi_4fd_row = li_4fd_index
                        
                    END IF

                    IF ls_temp = "4gl" THEN
                    
                        LET ls_4gl = os.Path.basename(ls_name)
                        LET ls_4gl_no = os.Path.rootname(ls_4gl) 
                        LET ls_root_name = os.Path.dirName(ls_name)
                        LET ls_dir_name = os.Path.dirName(ls_root_name)
                        LET ls_module_name = os.Path.basename(ls_dir_name) 
                        LET g_gal_4pw[li_4gl_index+1].gal01 = mc_zz01
                        LET g_gal_4pw[li_4gl_index+1].gal02 = ls_module_name #模組名稱
                        LET g_gal_4pw[li_4gl_index+1].gal03 = ls_4gl_no      #程式名稱 
                        LET li_4gl_index = li_4gl_index + 1
                        LET gi_4gl_row = li_4gl_index
                    END IF
                    
                END IF
                
            END CASE
            
      END CASE 
      
      LET ls_data = lxml_reader.read()
      
   END WHILE    
   
END FUNCTION

PRIVATE FUNCTION p_zz_proj_msg(p_msg)
    
  DEFINE p_msg     STRING  
  DEFINE  lc_title STRING 
  LET lc_title = cl_getmsg("lib-041",g_lang) CLIPPED
   IF cl_null(lc_title) THEN
      LET lc_title="Information"
   END IF   
  MENU lc_title ATTRIBUTE (STYLE="dialog", COMMENT=p_msg.trim() CLIPPED, IMAGE="information")
      ON ACTION ok
         EXIT MENU
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE MENU

   END MENU

END FUNCTION
#FUN-B50030 -- END

