# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Program name...: p_packprog.4gl
# Descriptions...: 打包一支作業 (含畫面與全部系統資料)
# Date & Author..: 2010/09/02 by alex 
# Modify.........: No:FUN-B30038 11/03/24 by jrg542 完成解包及安裝程式

IMPORT os

DATABASE ds

GLOBALS "../../config/top.global"
GLOBALS
DEFINE g_cust_flag       LIKE type_file.chr1          # 客製註記 
DEFINE g_syskeep         LIKE type_file.num5         
END GLOBALS

DEFINE g_target   LIKE zz_file.zz01
DEFINE g_type     LIKE type_file.chr1
DEFINE g_savepath STRING
DEFINE g_temp_file_path STRING #FUN-B30038


MAIN
   LET g_bgjob = "Y"                      #是否背景作業
   LET g_target = ARG_VAL(1)              #作業名稱 EX ： aooi070
   IF cl_null(g_target) THEN CALL p_packprog_error() END IF
   LET g_type = DOWNSHIFT(ARG_VAL(2))     #作業形式 g:純打包(default) p:置放或代換

   IF cl_null(g_type) THEN LET g_type = "g" END IF
   IF g_type = "p" THEN
      #FUN-B30038 start
      #LET g_savepath = FGL_GETENV("TEMPDIR") #out
      LET g_temp_file_path = os.Path.join(FGL_GETENV("TOP"),"tmp") CLIPPED
      LET g_savepath = g_temp_file_path
      DISPLAY "g_savepath:",g_savepath 
      #FUN-B30038 end   
      #LET g_savepath = ARG_VAL(3)         #儲存路徑
      IF cl_null(g_savepath) THEN CALL p_packprog_error() END IF
   END IF

   IF (NOT cl_user()) THEN
      EXIT PROGRAM 
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AZZ")) THEN 
      EXIT PROGRAM 
   END IF

   #強制指定使用ds,以免發生其他意外
   CLOSE DATABASE
   DATABASE ds
   CALL cl_ins_del_sid(1, g_plant)       #非5.2客戶請mark掉本行

   CALL cl_used(g_prog,g_time,1) RETURNING g_time    
   CASE g_type
      WHEN "g"   #打包作業
         #LET g_savepath = "packprog_",g_target CLIPPED,"_",p_packprog_time()    #FUN-B30038
         LET g_savepath = "packprog_",g_target CLIPPED                           #EX packprog_aooi070                          
         #LET g_savepath = os.Path.join(FGL_GETENV("TEMPDIR"),g_savepath.trim())#EX /out3/packprog_aooi070
         LET g_temp_file_path = os.Path.join(FGL_GETENV("TOP"),"tmp") CLIPPED    #EX $TOP/tmp/packprog_aooi070
         LET g_savepath = os.Path.join(g_temp_file_path,g_savepath.trim() )    
         CALL p_packprog_pak_prog()
         CALL p_packprog_pak_data()
         CALL p_packprog_pak_memo()

      WHEN "p"   #解包作業
         CALL p_packprog_update_data()
         CALL p_packprog_update_prog()
   END CASE

   CALL cl_used(g_prog,g_time,2) RETURNING g_time    
END MAIN

FUNCTION p_packprog_time()

   DEFINE ls_tmp   STRING

   LET ls_tmp = CURRENT YEAR TO SECOND
#  LET ls_tmp = ls_tmp.subString(3,4),
   LET ls_tmp = ls_tmp.subString(6,7),ls_tmp.subString(9,10),ls_tmp.subString(12,13),ls_tmp.subString(15,16)
#              ,ls_tmp.subString(18,19)
   RETURN ls_tmp.trim()

END FUNCTION

FUNCTION p_packprog_error()

    DISPLAY " "
    DISPLAY " "
    DISPLAY "USAGE:   exe2 p_packprog pack_program_id [work_type] [pack_path]"
    DISPLAY "Example: exe2 p_packprog axmt410 g                      (pack axmt410 only) "
    #DISPLAY "Example: exe2 p_packprog aapr100 p '/u1/temp/pack_path' (backup old and upgrade to new aapr110 package) " #FUN-B30038
    DISPLAY "Example: exe2 p_packprog aapr100 p  (backup old and upgrade to new aapr110 package) "

    CALL cl_used(g_prog,g_time,2) RETURNING g_time    
    EXIT PROGRAM
END FUNCTION

FUNCTION p_packprog_pak_prog()

    DEFINE lc_gal      RECORD LIKE gal_file.*
    DEFINE lc_gax      RECORD LIKE gax_file.*
    DEFINE ls_cmd      STRING
    DEFINE ls_cmdtmp   STRING
    DEFINE lc_module   LIKE type_file.chr10
    DEFINE lc_filename LIKE type_file.chr20

    #新建一個臨時表，把4gl/4fd資料導入，做交叉比對之用
    SELECT chr10 as module, chr10 as type, chr20 as filename FROM type_file WHERE 1=2
      INTO TEMP item_prog

          
    #FUN-B30038 START 
    IF os.Path.isdirectory(g_savepath) THEN
        LET ls_cmd = "rm -r ",g_savepath CLIPPED
        RUN ls_cmd
        LET ls_cmd = ""
    END IF
    #FUN-B30038 END
    
    IF os.Path.mkdir(g_savepath) THEN
       #找所有註冊在p_link裡的作業，把它打成一包...
       DECLARE p_packprog_pakgal_cur CURSOR FOR
         SELECT * FROM gal_file WHERE gal01 = g_target ORDER BY gal03
       FOREACH p_packprog_pakgal_cur INTO lc_gal.*
          #LET ls_cmd = ls_cmd," ",os.Path.join(os.Path.join(FGL_GETENV(lc_gal.gal02 CLIPPED),"4gl"),lc_gal.gal03 CLIPPED||".4gl") #FUN-B30038
          LET ls_cmd = ls_cmd," ",os.Path.join(os.Path.join(DOWNSHIFT(lc_gal.gal02) CLIPPED,"4gl"),lc_gal.gal03 CLIPPED||".4gl")
          #DISPLAY "ls_cmd:",ls_cmd 
          LET lc_gal.gal02 = DOWNSHIFT(lc_gal.gal02)
          INSERT INTO item_prog(module,type,filename) VALUES(lc_gal.gal02,"4gl",lc_gal.gal03)
       END FOREACH

       #找所有註冊在p_base_per裡的4fd，把它打成一包...
       DECLARE p_packprog_pakgax_cur CURSOR FOR
         SELECT * FROM gax_file WHERE gax01 = g_target ORDER BY gax02
       FOREACH p_packprog_pakgax_cur INTO lc_gax.*
          LET g_cust_flag = lc_gax.gax05
          LET ls_cmdtmp = p_packprog_pak_4fdpath(lc_gax.*)
          LET ls_cmd = ls_cmd," ",ls_cmdtmp
          LET lc_module = os.Path.Basename(os.Path.dirname(os.Path.dirname(ls_cmdtmp)))   #模組名稱 
          LET lc_filename = os.Path.rootname(os.Path.basename(ls_cmdtmp))    #檔案名稱
          INSERT INTO item_prog(module,type,filename) VALUES(lc_module,"4fd",lc_filename)
       END FOREACH

       #42m / 42r都是用重新產生的方式...
       #per / 42f都是用重新產生的方式...
       #4ad檔應用重新產生的方式...
       
       #LET ls_cmd = "tar cvfz ",os.Path.join(g_savepath,"progpack.tar"), ls_cmd CLIPPED
       LET g_savepath = os.Path.join("tmp",g_savepath)
       LET ls_cmd = " cd ",FGL_GETENV("TOP")," ;tar -zcvf ",os.Path.join(g_savepath,"progpack.tar"), ls_cmd CLIPPED
       DISPLAY "ls_cmd:",ls_cmd #"ls_cmd:tar cvfz /out3/packprog_aooi070/progpack.tar /u3/top/aoo/4gl/aooi070.4gl /u3/top/aoo/4fd/aooi070.4fd /u3/top/aoo/4fd/aooi0701.4fd"
       RUN ls_cmd

    END IF
END FUNCTION    


PRIVATE FUNCTION p_packprog_pak_4fdpath(lc_gax)
    DEFINE lc_gax     RECORD LIKE gax_file.*
    RETURN p_preview_path(lc_gax.gax02)
END FUNCTION    


FUNCTION p_packprog_pak_data()

    DEFINE ls_cmd       STRING
    DEFINE ls_result    STRING
    DEFINE ls_ze01      STRING
    DEFINE li_cnt       LIKE type_file.num10
    DEFINE lc_file      LIKE type_file.chr50
    DEFINE lc_sql       LIKE type_file.chr500 
    DEFINE lc_channel   base.Channel

    IF os.Path.chdir(g_savepath) THEN
    END IF

    #新建一個臨時表，把4gl/4fd資料導入，做交叉比對之用
    SELECT num5 as dataid, chr30 as tabid, num10 as row_id FROM type_file WHERE 1=2
      INTO TEMP item_data

    #找出所有與本作業相關的資料，也打成一包...
    # 01 zz / 02 gaz/ 03 gak/ 04 gal/ 05 gax/ 06 gae/ 07 gbs/ 08 gav/ 09 gbf/ 10 zaa
    # 11 zaw/ 12 ze / 13 gap/ 14 gbd

    #Part 1 程式部份 p_zz
    SELECT COUNT(*) INTO li_cnt FROM zz_file WHERE zz01=g_target
    INSERT INTO item_data(dataid,tabid,row_id) VALUES("1","zz_file",li_cnt)
    IF li_cnt > 0 THEN  
       LET lc_file = "01_zz_file.txt"
       LET lc_sql = "SELECT * FROM zz_file WHERE zz01=\'",g_target CLIPPED,"\'"
       UNLOAD TO lc_file lc_sql
    END IF

    #檔案名稱 p_zz_name
    SELECT COUNT(*) INTO li_cnt FROM gaz_file WHERE gaz01=g_target
    INSERT INTO item_data(dataid,tabid,row_id) VALUES("2","gaz_file",li_cnt)
    IF li_cnt > 0 THEN  
       LET lc_file = "02_gaz_file.txt"
       LET lc_sql = "SELECT * FROM gaz_file WHERE gaz01=\'",g_target CLIPPED,"\'"
       UNLOAD TO lc_file lc_sql
    END IF

    #連結資料 p_link (單頭)
    SELECT COUNT(*) INTO li_cnt FROM gak_file WHERE gak01=g_target
    INSERT INTO item_data(dataid,tabid,row_id) VALUES("3","gak_file",li_cnt)
    IF li_cnt > 0 THEN  
       LET lc_file = "03_gak_file.txt"
       LET lc_sql = "SELECT * FROM gak_file WHERE gak01=\'",g_target CLIPPED,"\'"
       UNLOAD TO lc_file lc_sql
    END IF

    #連結資料 p_link (單身)
    SELECT COUNT(*) INTO li_cnt FROM gal_file WHERE gal01=g_target
    INSERT INTO item_data(dataid,tabid,row_id) VALUES("4","gal_file",li_cnt)
    IF li_cnt > 0 THEN  
       LET lc_file = "04_gal_file.txt"
       LET lc_sql = "SELECT * FROM gal_file WHERE gal01=\'",g_target CLIPPED,"\'"
       UNLOAD TO lc_file lc_sql
    END IF

    #呼叫 p_get_act 以取得最新 act_id
    LET ls_cmd = "p_get_act ",g_target CLIPPED," \"1\""
    CALL cl_cmdrun(ls_cmd)
                                     #gap_file 程式與ACTION關係檔   
    SELECT COUNT(*) INTO li_cnt FROM gap_file WHERE gap01=g_target
    INSERT INTO item_data(dataid,tabid,row_id) VALUES("13","gap_file",li_cnt)
    IF li_cnt > 0 THEN  
       LET lc_file = "13_gap_file.txt"
       LET lc_sql = "SELECT * FROM gap_file WHERE gap01=\'",g_target CLIPPED,"\'"
       UNLOAD TO lc_file lc_sql

       #ACTION ID資料 p_all_act         #gbd_file Action Default多語言對照檔
       SELECT COUNT(*) INTO li_cnt FROM gbd_file WHERE gbd01 IN (SELECT gap02 FROM gap_file WHERE gap01=g_target)
       INSERT INTO item_data(dataid,tabid,row_id) VALUES("14","gbd_file",li_cnt)
       IF li_cnt > 0 THEN  
          LET lc_file = "14_gbd_file.txt"
          LET lc_sql = "SELECT * FROM gbd_file WHERE gbd01 IN (SELECT gap02 FROM gap_file WHERE gap01=\'",g_target CLIPPED,"\')"
          UNLOAD TO lc_file lc_sql
       END IF
    END IF

    #呼叫 p_get_ze 以取得最新 error item list
    LET lc_channel = base.Channel.create() 
    LET ls_cmd = "exe2 p_get_ze ",g_target CLIPPED," \"1\""
    CALL lc_channel.openPipe(ls_cmd,"r")
    LET ls_ze01 = ""
    WHILE (lc_channel.read(ls_result))
       IF ls_result.subString(1,1) = "'" THEN      #已與p_get_ze互相串證
          LET ls_ze01 = ls_ze01,ls_result.trim()
       END IF
    END WHILE
    
    IF ls_ze01.getLength() > 0 THEN       #ze_file 錯誤訊息檔
       LET ls_cmd = "SELECT COUNT(*) FROM ze_file WHERE ze01 IN (",ls_ze01.trim(),")"
       PREPARE p_packprog_ze_cnt FROM ls_cmd
       EXECUTE p_packprog_ze_cnt INTO li_cnt
       FREE p_packprog_ze_cnt
       INSERT INTO item_data(dataid,tabid,row_id) VALUES("12","ze_file",li_cnt)
       IF li_cnt > 0 THEN  
          LET lc_file = "12_ze_file.txt"
          LET ls_cmd = "SELECT * FROM ze_file WHERE ze01 IN (",ls_ze01.trim(),")"
          UNLOAD TO lc_file ls_cmd
       END IF
    ELSE
       INSERT INTO item_data(dataid,tabid,row_id) VALUES("12","ze_file",0)
    END IF

    #Part 2: 畫面部份 p_base_per      #4GL與PER關係檔 
    SELECT COUNT(*) INTO li_cnt FROM gax_file WHERE gax01=g_target
    INSERT INTO item_data(dataid,tabid,row_id) VALUES("5","gax_file",li_cnt)
    IF li_cnt > 0 THEN  
       LET lc_file = "05_gax_file.txt"
       LET lc_sql = "SELECT * FROM gax_file WHERE gax01=\'",g_target CLIPPED,"\'"
       UNLOAD TO lc_file lc_sql

       #畫面資料 p_perlang               #gae_file 畫面元件多語言記錄檔
       SELECT COUNT(*) INTO li_cnt FROM gae_file WHERE gae01 IN (SELECT gax02 FROM gax_file WHERE gax01=g_target)
       INSERT INTO item_data(dataid,tabid,row_id) VALUES("6","gae_file",li_cnt)
       IF li_cnt > 0 THEN  
          LET lc_file = "06_gae_file.txt"
          LET lc_sql = "SELECT * FROM gae_file WHERE gae01 IN (SELECT gax02 FROM gax_file WHERE gax01=\'",g_target CLIPPED,"\')"
          UNLOAD TO lc_file lc_sql
       END IF
   
       #畫面附註說明 p_perlang MEMO       #gbs_file 畫面元件多語言備註記錄 
       SELECT COUNT(*) INTO li_cnt FROM gbs_file WHERE gbs01 IN (SELECT gax02 FROM gax_file WHERE gax01=g_target)
       INSERT INTO item_data(dataid,tabid,row_id) VALUES(7,"gbs_file",li_cnt)
       IF li_cnt > 0 THEN  
          LET lc_file = "07_gbs_file.txt"
          LET lc_sql = "SELECT * FROM gbs_file WHERE gbs01 IN (SELECT gax02 FROM gax_file WHERE gax01=\'",g_target CLIPPED,"\')"
          UNLOAD TO lc_file lc_sql
       END IF
   
       #畫面欄位設定 p_per                #gav_file 畫面輸出欄位格式設定檔
       SELECT COUNT(*) INTO li_cnt FROM gav_file WHERE gav01 IN (SELECT gax02 FROM gax_file WHERE gax01=g_target)
       INSERT INTO item_data(dataid,tabid,row_id) VALUES(8,"gav_file",li_cnt)
       IF li_cnt > 0 THEN  
          LET lc_file = "08_gav_file.txt"
          LET lc_sql = "SELECT * FROM gav_file WHERE gav01 IN (SELECT gax02 FROM gax_file WHERE gax01=\'",g_target CLIPPED,"\')"
          UNLOAD TO lc_file lc_sql
       END IF
    END IF

    #Part 3:說明文件部份 p_feature     #gbf_file 程式作業特色維護檔
    SELECT COUNT(*) INTO li_cnt FROM gbf_file WHERE gbf01=g_target
    INSERT INTO item_data(dataid,tabid,row_id) VALUES(9,"gbf_file",li_cnt)
    IF li_cnt > 0 THEN  
       LET lc_file = "09_gbf_file.txt"
       LET lc_sql = "SELECT * FROM gbf_file WHERE gbf01=\'",g_target CLIPPED,"\'"
       UNLOAD TO lc_file lc_sql
    END IF

    #Part 4:報表部份 p_zaa            #zaa_file 報表相關格式設定檔
    SELECT COUNT(*) INTO li_cnt FROM zaa_file WHERE zaa01=g_target
    INSERT INTO item_data(dataid,tabid,row_id) VALUES(10,"zaa_file",li_cnt)
    IF li_cnt > 0 THEN  
       LET lc_file = "10_zaa_file.txt"
       LET lc_sql = "SELECT * FROM zaa_file WHERE zaa01=\'",g_target CLIPPED,"\'"
       UNLOAD TO lc_file lc_sql
    END IF

    #CR報表設定 p_zaw                 #zaw_file CR報表格式設定檔
    SELECT COUNT(*) INTO li_cnt FROM zaw_file WHERE zaw01=g_target
    INSERT INTO item_data(dataid,tabid,row_id) VALUES(11,"zaw_file",li_cnt)
    IF li_cnt > 0 THEN  
       LET lc_file = "11_zaw_file.txt"
       LET lc_sql = "SELECT * FROM zaw_file WHERE zaw01=\'",g_target CLIPPED,"\'"
       UNLOAD TO lc_file lc_sql
    END IF

    #Part 5:整合部份

    #Part 6:打包資料部份
    LET lc_file = "00_item_data.txt"
    LET lc_sql = "SELECT * FROM item_data "
    UNLOAD TO lc_file lc_sql

    #Part 7:打包程式部份
    LET lc_file = "00_item_prog.txt"
    LET lc_sql = "SELECT * FROM item_prog "
    UNLOAD TO lc_file lc_sql

END FUNCTION


FUNCTION p_packprog_pak_memo()

   DISPLAY "Packing Finish....file at:",g_savepath 

END FUNCTION

FUNCTION p_packprog_load_tmp()

   # 01 zz / 02 gaz/ 03 gak/ 04 gal/ 05 gax/ 06 gae/ 07 gbs/ 08 gav/ 09 gbf/ 10 zaa
   # 11 zaw/ 12 ze / 13 gap/ 14 gbd

   DROP TABLE item_prog
   SELECT chr10 as module, chr10 as type, chr20 as filename FROM type_file WHERE 1=2
     INTO TEMP item_prog

   DROP TABLE item_data
   SELECT num5 as dataid, chr30 as tabid, num10 as row_id FROM type_file WHERE 1=2
     INTO TEMP item_data

   SELECT * FROM  zz_file WHERE 1=2 INTO TEMP tmp_zz_file
   SELECT * FROM gaz_file WHERE 1=2 INTO TEMP tmp_gaz_file
   SELECT * FROM gak_file WHERE 1=2 INTO TEMP tmp_gak_file
   SELECT * FROM gal_file WHERE 1=2 INTO TEMP tmp_gal_file
   SELECT * FROM gax_file WHERE 1=2 INTO TEMP tmp_gax_file
   SELECT * FROM gae_file WHERE 1=2 INTO TEMP tmp_gae_file
   SELECT * FROM gbs_file WHERE 1=2 INTO TEMP tmp_gbs_file
   SELECT * FROM gav_file WHERE 1=2 INTO TEMP tmp_gav_file
   SELECT * FROM gbf_file WHERE 1=2 INTO TEMP tmp_gbf_file
   SELECT * FROM zaa_file WHERE 1=2 INTO TEMP tmp_zaa_file
   SELECT * FROM zaw_file WHERE 1=2 INTO TEMP tmp_zaw_file
   SELECT * FROM  ze_file WHERE 1=2 INTO TEMP tmp_ze_file
   SELECT * FROM gap_file WHERE 1=2 INTO TEMP tmp_gap_file
   SELECT * FROM gbd_file WHERE 1=2 INTO TEMP tmp_gbd_file

END FUNCTION


FUNCTION p_packprog_load_text(ls_file,ls_tabid)

   DEFINE ls_file   STRING
   DEFINE ls_tabid  STRING
   DEFINE ls_sql    STRING

   # FUN-B30038 start
   DEFINE ls_tempdir    STRING
   DEFINE ls_temp_file    STRING    

   LET ls_temp_file = "packprog_",g_target CLIPPED #EX packprog_aooi070
   LET ls_tempdir = os.Path.join(g_savepath,ls_temp_file)
   LET ls_file = os.Path.join(ls_tempdir,ls_file)
   # end
   
   #LET ls_file = os.Path.join(g_savepath,ls_file) #FUN-B30038
   IF ls_tabid.getIndexOf("item_",1) THEN
      LET ls_sql = "INSERT INTO ",ls_tabid CLIPPED
   ELSE
      LET ls_sql = "INSERT INTO tmp_",ls_tabid CLIPPED
   END IF
   DISPLAY "ls_sql:",ls_sql ,"   ls_file:",ls_file
   LOAD FROM ls_file ls_sql    #將文字檔載入到ORACLE資料庫
   #DISPLAY "SQLCA.sqlcode:",SQLCA.sqlcode

   #FUN-B30038 start
   IF SQLCA.sqlcode THEN
        DISPLAY "not insert DB :",SQLCA.sqlcode
        DISPLAY "file error :",ls_file
        EXIT PROGRAM
   END IF
   # end
   
   #IF STATUS THEN  #FUN-B30038
   #    display "error:",STATUS
   #END IF #FUN-B30038
   

END FUNCTION


FUNCTION p_packprog_update_data()

   DEFINE li_dataid   LIKE type_file.num5      #資料順序 
   DEFINE lc_tabid    LIKE type_file.chr30     #table 名稱
   DEFINE ls_tmp      STRING

   CALL p_packprog_load_tmp()
   CALL p_packprog_load_text("00_item_prog.txt","item_prog")
   CALL p_packprog_load_text("00_item_data.txt","item_data")
   #從 item_data 內抓出筆數非 0 的, load填入 temp table
   DECLARE p_packprog_data_curs CURSOR WITH HOLD FOR
     SELECT dataid,tabid FROM item_data WHERE row_id > 0

   FOREACH p_packprog_data_curs INTO li_dataid,lc_tabid
      IF NOT cl_null(lc_tabid) THEN
         LET ls_tmp = li_dataid USING "&&","_",lc_tabid CLIPPED,".txt" 
         CALL p_packprog_load_text(ls_tmp, lc_tabid CLIPPED)

   # 01 zz / 02 gaz/ 03 gak/ 04 gal/ 05 gax/ 06 gae/ 07 gbs/ 08 gav/ 09 gbf/ 10 zaa
   # 11 zaw/ 12 ze / 13 gap/ 14 gbd

         CASE lc_tabid
            WHEN "zz_file"
               INSERT INTO zz_file
               SELECT * FROM tmp_zz_file WHERE zz01 NOT IN
                                       (SELECT zz01 FROM zz_file)
            WHEN "gaz_file"
               INSERT INTO gaz_file
               SELECT * FROM tmp_gaz_file WHERE gaz01||gaz02 NOT IN
                                        (SELECT gaz01||gaz02 FROM gaz_file)
            WHEN "gak_file"
               INSERT INTO gak_file
               SELECT * FROM tmp_gak_file WHERE gak01 NOT IN
                                        (SELECT gak01 FROM gak_file)
            WHEN "gal_file"
               INSERT INTO gal_file
               SELECT * FROM tmp_gal_file WHERE gal01||gal02||gal03 NOT IN
                                        (SELECT gal01||gal02||gal03 FROM gal_file)
            WHEN "gax_file"
               INSERT INTO gax_file
               SELECT * FROM tmp_gax_file WHERE gax01||gax02||gax05 NOT IN
                                        (SELECT gax01||gax02||gax05 FROM gax_file)
            WHEN "gae_file"
               INSERT INTO gae_file
               SELECT * FROM tmp_gae_file WHERE gae01||gae02||gae03||gae11||gae12 NOT IN
                                        (SELECT gae01||gae02||gae03||gae11||gae12 FROM gae_file)
            WHEN "gbs_file"
               INSERT INTO gbs_file
               SELECT * FROM tmp_gbs_file WHERE gbs01||gbs02||gbs03||gbs04||gbs05 NOT IN
                                        (SELECT gbs01||gbs02||gbs03||gbs04||gbs05 FROM gbs_file)
            WHEN "gav_file"
               INSERT INTO gav_file
               SELECT * FROM tmp_gav_file WHERE gav01||gav02||gav08||gav11 NOT IN
                                        (SELECT gav01||gav02||gav08||gav11 FROM gav_file)
            WHEN "gbf_file"
               INSERT INTO gbf_file
               SELECT * FROM tmp_gbf_file WHERE gbf01||gbf02||gbf03||gbf04 NOT IN
                                        (SELECT gbf01||gbf02||gbf03||gbf04 FROM gbf_file)
            WHEN "zaa_file"
               INSERT INTO zaa_file
               SELECT * FROM tmp_zaa_file WHERE zaa01||zaa02||zaa03||zaa04||zaa10||zaa11||zaa17 NOT IN
                                        (SELECT zaa01||zaa02||zaa03||zaa04||zaa10||zaa11||zaa17 FROM zaa_file)
            WHEN "zaw_file"
               INSERT INTO zaw_file
               SELECT * FROM tmp_zaw_file WHERE zaw01||zaw02||zaw03||zaw04||zaw05||zaw06||zaw07||zaw10 NOT IN
                                        (SELECT zaw01||zaw02||zaw03||zaw04||zaw05||zaw06||zaw07||zaw10 FROM zaw_file)
            WHEN "ze_file"
               INSERT INTO ze_file
               SELECT * FROM tmp_ze_file WHERE ze01||ze02 NOT IN
                                       (SELECT ze01||ze02 FROM ze_file)
            WHEN "gap_file"
               INSERT INTO gap_file
               SELECT * FROM tmp_gap_file WHERE gap01||gap02 NOT IN
                                        (SELECT gap01||gap02 FROM gap_file)
            WHEN "gbd_file"
               INSERT INTO gbd_file
               SELECT * FROM tmp_gbd_file WHERE gbd01||gbd02||gbd03||gbd07 NOT IN
                                        (SELECT gbd01||gbd02||gbd03||gbd07 FROM gbd_file)
         END CASE
         IF SQLCA.SQLCODE THEN display 'ERROR===',SQLCA.SQLCODE END IF
      END IF
   END FOREACH

END FUNCTION


FUNCTION p_packprog_update_prog()

   DEFINE lc_module   LIKE type_file.chr10
   DEFINE lc_type     LIKE type_file.chr10
   DEFINE lc_filename LIKE type_file.chr20
   DEFINE ls_pwd      STRING
   DEFINE ls_current  STRING
   DEFINE ls_cmd      STRING

   # #FUN-B30038 start
   DEFINE ls_tempdir      STRING
   DEFINE ls_temp_file    STRING   
   # end
   
   LET ls_pwd = os.Path.pwd()
   #解開打包檔
   #FUN-B30038 start
   LET ls_temp_file = "packprog_",g_target CLIPPED #EX packprog_aooi070
   LET ls_tempdir = os.Path.join(g_savepath,ls_temp_file)
   #LET ls_file = os.Path.join(ls_tempdir,ls_file)     
   --LET g_savepath = os.Path.join(ls_tempdir,g_savepath.trim() )    FUN-B30038 
   --LET ls_cmd = "tar xzvf ",os.Path.join(g_savepath,"progpack.tar"), ls_cmd CLIPPED  FUN-B30038 
   LET ls_cmd = "cd " ,FGL_GETENV("TOP") ,"; tar -zxvf ",os.Path.join(ls_tempdir,"progpack.tar"), ls_cmd CLIPPED
   DISPLAY "ls_cmd:",ls_cmd
   RUN ls_cmd
   # #FUN-B30038 end
   
   #從 item_prog 內逐支做 r.c2 及 r.f2
   DECLARE p_packprog_prog_curs CURSOR FOR
     SELECT * FROM item_prog ORDER BY type,module,filename
   FOREACH p_packprog_prog_curs INTO lc_module,lc_type,lc_filename
      IF NOT cl_null(lc_filename) THEN
         LET ls_current = os.Path.join(FGL_GETENV(UPSHIFT(lc_module)),lc_type)
         DISPLAY "FGL_GETENV:",FGL_GETENV(lc_module) 
         IF os.Path.chdir(ls_current) THEN END IF
         CASE lc_type     #檔案格式
            WHEN "4gl"
               LET ls_cmd = "r.c2 ",lc_filename
            WHEN "4fd"
               LET ls_cmd = "r.f2 ",lc_filename
         END CASE
         DISPLAY "4.ls_cmd:",ls_cmd
         RUN ls_cmd
      END IF
   END FOREACH

   #完成前加作 r.l2
   IF os.Path.chdir(ls_pwd) THEN END IF
   LET ls_cmd = "r.l2 ",g_target CLIPPED
   DISPLAY "5.ls_cmd:",ls_cmd
   RUN ls_cmd

   #呼叫 p_gen4ad 以更新 4ad/4tm 資料
   LET ls_cmd = "p_gen4ad ",g_target CLIPPED," \"Y\""
   CALL cl_cmdrun(ls_cmd)

   #呼叫 p_get_zr 以更新 p_zr 資料     #程式檔案關聯建立
   LET ls_cmd = "p_get_zr ",g_target CLIPPED," \"1\""
   CALL cl_cmdrun(ls_cmd)

   DISPLAY "......"
   DISPLAY "Program: ",g_target CLIPPED," Installed Succfussfully."

END FUNCTION

