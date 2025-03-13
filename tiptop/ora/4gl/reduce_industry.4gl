# 拆解行業別程式工具(r.p2) 2008 by saki

IMPORT os

DATABASE ds

DEFINE   g_path         STRING
DEFINE   g_prog         STRING
DEFINE   g_sql          STRING
DEFINE   g_cnt          LIKE type_file.num5
DEFINE   g_cmd          STRING
DEFINE   lr_smb01       DYNAMIC ARRAY OF LIKE smb_file.smb01
DEFINE   lr_file        DYNAMIC ARRAY OF STRING
DEFINE   lr_file_ora    DYNAMIC ARRAY OF STRING
DEFINE   lr_file_msv    DYNAMIC ARRAY OF STRING
DEFINE   lr_file_rowid  DYNAMIC ARRAY OF STRING
DEFINE   lr_file_wos    DYNAMIC ARRAY OF STRING

MAIN
   DEFINE   li_result   LIKE type_file.num5
   DEFINE   ls_file     STRING
   DEFINE   lc_channel  base.Channel
   DEFINE   li_uid      LIKE type_file.num10

   LET g_path = ARG_VAL(1)
   LET g_prog = ARG_VAL(2)

   IF NOT os.Path.exists(g_path||os.Path.separator()||g_prog||".src.4gl") THEN
      DISPLAY "Can't find : ",g_path||os.Path.separator()||g_prog||".src.4gl"
      RETURN
   END IF

   IF g_path IS NULL OR g_prog IS NULL THEN
      DISPLAY "Reduce Fail.."
   END IF

   LET lc_channel = base.Channel.create()
   CALL lc_channel.openPipe("id -u","r")
   WHILE lc_channel.read(li_uid)
   END WHILE

   LET g_sql = "SELECT UNIQUE smb01 FROM smb_file"
   PREPARE smb01_pre FROM g_sql
   DECLARE smb01_curs CURSOR FOR smb01_pre

   LET g_cnt = 1
   FOREACH smb01_curs INTO lr_smb01[g_cnt]
      LET g_cnt = g_cnt + 1
   END FOREACH
   CALL lr_smb01.deleteElement(g_cnt)

   IF lr_smb01.getLength() > 0 THEN
      LET g_cmd = "grep -e '&ifdef' -e '&ifndef' ",g_path,os.Path.separator(),g_prog,".src.4gl|"
      FOR g_cnt = 1 TO lr_smb01.getLength()
          LET g_cmd = g_cmd, "grep -v '",UPSHIFT(lr_smb01[g_cnt] CLIPPED),"$'|",
                             "grep -v '",UPSHIFT(lr_smb01[g_cnt] CLIPPED)," '|"
      END FOR
      LET g_cmd = g_cmd.subString(1,g_cmd.getLength()-1)
      LET g_cmd = g_cmd," > /dev/null 2>&1"
      RUN g_cmd RETURNING li_result
      IF NOT li_result THEN   #找出&ifdef與&ifndef後不是跟行業別代碼的程式段
         DISPLAY "在'&ifdef'和'&ifndef'後, 出現不屬於行業別代碼的識別字"
      ELSE
         FOR g_cnt = 1 TO lr_smb01.getLength()
             IF lr_smb01[g_cnt] = "std" THEN
                LET ls_file = g_path,os.Path.separator(),g_prog,".4gl"
             ELSE
                LET g_cmd = "grep -e '&ifdef ",UPSHIFT(lr_smb01[g_cnt] CLIPPED),"$'",
                            "     -e '&ifdef ",UPSHIFT(lr_smb01[g_cnt] CLIPPED)," '",
                            "     -e '&ifndef ",UPSHIFT(lr_smb01[g_cnt] CLIPPED),"$'",
                            "     -e '&ifndef ",UPSHIFT(lr_smb01[g_cnt] CLIPPED)," ' ",
                            g_path,os.Path.separator(),g_prog,".src.4gl > /dev/null 2>&1"
                RUN g_cmd RETURNING li_result
                IF NOT li_result THEN
                   LET ls_file = g_path,os.Path.separator(),g_prog,"_",lr_smb01[g_cnt] CLIPPED,".4gl"
                ELSE
                   CONTINUE FOR
                END IF
             END IF
             #檢查檔案存在的話，是否有權限可寫入, 沒有就什麼都不做
             IF os.Path.exists(ls_file) THEN
                IF os.Path.uid(ls_file) != li_uid OR NOT os.Path.writable(ls_file) THEN
                   DISPLAY ls_file," 無權限可寫入，請檢查是否Booking"
                   CONTINUE FOR
                END IF
             END IF

             CALL include_preprocessor_change(g_prog||".src.4gl","&include","#@include","N")
             #======Delete Space Procedure start======
             LET g_cmd = "sed -e 's/^$/###REMARK-BLANK-LINE###/' ",g_prog,".src.4gl >",g_prog,".rp2.src.4gl"
             RUN g_cmd
             #=======Delete Space Procedure end=======
             LET g_cmd = "cd ",g_path,";fglcomp -E -D ",UPSHIFT(lr_smb01[g_cnt] CLIPPED)," ",g_prog,".rp2.src.4gl | grep -v '^&' > ",ls_file   #Delete Space Attention (.rp2.src.4gl > .src.4gl)
             RUN g_cmd
             CALL include_preprocessor_change(ls_file,"#@include","&include","Y")
             CALL include_preprocessor_change(g_prog||".src.4gl","#@include","&include","Y")
             #======Delete Space Procedure start======
             LET g_cmd = "sed -e '/^$/d' ",ls_file," >",ls_file,".rp2"
             RUN g_cmd
             LET g_cmd = "sed -e 's/###REMARK-BLANK-LINE###//' ",ls_file,".rp2 >",ls_file
             RUN g_cmd
             LET g_cmd = "rm ",ls_file,".rp2;rm ",g_prog,".rp2.src.4gl"
             RUN g_cmd
             #=======Delete Space Procedure end=======
#            CALL reduce_4gl_file(lr_smb01[g_cnt] CLIPPED,ls_file)
             IF os.Path.exists(ls_file) THEN
                LET lr_file[lr_file.getLength()+1] = ls_file
                CALL reduce_other_file(lr_smb01[g_cnt] CLIPPED,"ora")
                CALL reduce_other_file(lr_smb01[g_cnt] CLIPPED,"msv")
                CALL reduce_other_file(lr_smb01[g_cnt] CLIPPED,"rowid")
                CALL reduce_other_file(lr_smb01[g_cnt] CLIPPED,"wos")
             END IF
         END FOR
      END IF
   END IF

   IF lr_file.getLength() > 0 THEN
      DISPLAY "產生以下的各行業別程式:"
      FOR g_cnt = 1 TO lr_file.getLength()
          DISPLAY lr_file[g_cnt]
      END FOR
   ELSE
      DISPLAY "未產生行業別程式"
   END IF

   IF lr_file_ora.getLength()+lr_file_msv.getLength()+lr_file_rowid.getLength()+lr_file_wos.getLength() > 0 THEN
      DISPLAY "同步產生以下檔案:"
      FOR g_cnt = 1 TO lr_file_ora.getLength()
          DISPLAY lr_file_ora[g_cnt]
      END FOR
      FOR g_cnt = 1 TO lr_file_msv.getLength()
          DISPLAY lr_file_msv[g_cnt]
      END FOR
      FOR g_cnt = 1 TO lr_file_rowid.getLength()
          DISPLAY lr_file_rowid[g_cnt]
      END FOR
      FOR g_cnt = 1 TO lr_file_wos.getLength()
          DISPLAY lr_file_wos[g_cnt]
      END FOR
   END IF
   IF lr_file.getLength() > 0 THEN
      DISPLAY "r.c2 各行業別程式:"
      FOR g_cnt = 1 TO lr_file.getLength()
          LET ls_file = os.Path.basename(lr_file[g_cnt])
          LET ls_file = ls_file.subString(1,ls_file.getIndexOf(".4gl",1)-1)
          LET g_cmd = "r.c2 ",ls_file
          RUN g_cmd
      END FOR
   END IF
END MAIN

FUNCTION include_preprocessor_change(ps_file,ps_keyword,ps_change,ps_kill)
   DEFINE   ps_file      STRING
   DEFINE   ps_keyword   STRING
   DEFINE   ps_change    STRING
   DEFINE   ps_kill      STRING
   DEFINE   li_result    LIKE type_file.num5
   DEFINE   lc_channel   base.Channel
   DEFINE   ls_result    STRING
   DEFINE   lr_progline  DYNAMIC ARRAY OF STRING
   DEFINE   li_cnt       LIKE type_file.num10

   LET g_cmd = "grep '",ps_keyword,"' ",ps_file," > /dev/null 2>&1"
   RUN g_cmd RETURNING li_result
   IF li_result THEN
      RETURN
   END IF

   LET lc_channel = base.Channel.create()
   CALL lc_channel.openFile(ps_file,"r")
   CALL lc_channel.setDelimiter("")
   LET li_cnt = 1
   WHILE lc_channel.read(ls_result)
      IF ls_result.getIndexOf(ps_keyword,1) THEN
         LET ls_result = ls_result.subString(1,ls_result.getIndexOf(ps_keyword,1)-1),
                         ps_change,
                         ls_result.subString(ls_result.getIndexOf(ps_keyword,1)+ps_keyword.getLength(),ls_result.getLength())
      END IF
      LET lr_progline[li_cnt] = ls_result
      LET li_cnt = li_cnt + 1
   END WHILE
   CALL lc_channel.close()

   LET lc_channel = base.Channel.create()
   CALL lc_channel.openFile(ps_file||".tmp","w")
   CALL lc_channel.setDelimiter("")
   FOR li_cnt = 1 TO lr_progline.getLength()
       CALL lc_channel.write(lr_progline[li_cnt])
   END FOR
   CALL lc_channel.close()

   IF os.Path.exists(ps_file||".tmp") THEN
      IF os.Path.copy(ps_file||".tmp",ps_file) THEN
         IF os.Path.delete(ps_file||".tmp") THEN END IF
      END IF
   END IF
END FUNCTION

FUNCTION reduce_4gl_file(ps_industry,ps_file)
   DEFINE   ps_industry   STRING
   DEFINE   ps_file       STRING
   DEFINE   lc_channel    base.Channel
   DEFINE   ls_result     STRING
   DEFINE   lr_progline   DYNAMIC ARRAY OF STRING
   DEFINE   li_write      LIKE type_file.num5
   DEFINE   ls_compare    STRING
   DEFINE   li_cnt        LIKE type_file.num10

   LET lc_channel = base.Channel.create()
   CALL lc_channel.openFile(g_path||os.Path.separator()||g_prog||".src.4gl","r")
   CALL lc_channel.setDelimiter("")
   LET li_write = TRUE
   WHILE lc_channel.read(ls_result)
      CASE
         WHEN ls_result MATCHES "&ifdef *"
            LET lr_progline[lr_progline.getLength()+1] = ""
            LET ls_result = ls_result.subString(ls_result.getIndexOf("&ifdef ",1)+7,ls_result.getLength())
            LET ls_compare = UPSHIFT(ps_industry),"*"
            IF ls_result NOT MATCHES ls_compare THEN
               LET li_write = FALSE
            END IF
         WHEN ls_result MATCHES "&ifndef *"
            LET lr_progline[lr_progline.getLength()+1] = ""
            LET ls_result = ls_result.subString(ls_result.getIndexOf("&ifndef ",1)+8,ls_result.getLength())
            LET ls_compare = UPSHIFT(ps_industry),"*"
            IF ls_result MATCHES ls_compare THEN
               LET li_write = FALSE
            END IF
         WHEN ls_result MATCHES "&endif*"
            LET lr_progline[lr_progline.getLength()+1] = ""
            LET li_write = TRUE
         OTHERWISE
            IF li_write THEN
               LET lr_progline[lr_progline.getLength()+1] = ls_result
            ELSE
               LET lr_progline[lr_progline.getLength()+1] = ""
            END IF
      END CASE
   END WHILE
   CALL lc_channel.close()

   LET lc_channel = base.Channel.create()
   CALL lc_channel.openFile(ps_file||".tmp","w")
   CALL lc_channel.setDelimiter("")
   FOR li_cnt = 1 TO lr_progline.getLength()
       CALL lc_channel.write(lr_progline[li_cnt])
   END FOR
   CALL lc_channel.close()

   IF os.Path.exists(ps_file||".tmp") THEN
      IF os.Path.copy(ps_file||".tmp",ps_file) THEN
         IF os.Path.delete(ps_file||".tmp") THEN END IF
      END IF
   END IF
END FUNCTION

FUNCTION reduce_other_file(ps_industry,ps_filetype)
   DEFINE   ps_industry   STRING
   DEFINE   ps_filetype   STRING
   DEFINE   ls_path       STRING
   DEFINE   ls_copyfile   STRING
   DEFINE   li_result     LIKE type_file.num5

   LET ls_path = os.Path.dirname(g_path),os.Path.separator(),ps_filetype,os.Path.separator()
   IF os.Path.exists(ls_path||g_prog||"."||ps_filetype) AND 
      NOT os.Path.exists(ls_path||g_prog||".src."||ps_filetype) THEN
      DISPLAY "請確認此行業別程式對應的",ps_filetype,"有被複製成.src.",ps_filetype,"開發"
      RETURN
   END IF

   IF ps_industry = "std" THEN
      LET ls_copyfile = ls_path,g_prog,".",ps_filetype
   ELSE
      LET ls_copyfile = ls_path,g_prog,"_",ps_industry,".",ps_filetype
   END IF
   IF os.Path.copy(ls_path||g_prog||".src."||ps_filetype,ls_copyfile) THEN
      LET li_result = TRUE
   END IF

   IF li_result THEN
      CASE ps_filetype
         WHEN "ora"
            LET lr_file_ora[lr_file_ora.getLength()+1] = ls_copyfile
         WHEN "msv"
            LET lr_file_msv[lr_file_msv.getLength()+1] = ls_copyfile
         WHEN "rowid"
            LET lr_file_rowid[lr_file_rowid.getLength()+1] = ls_copyfile
         WHEN "wos"
            LET lr_file_wos[lr_file_wos.getLength()+1] = ls_copyfile
      END CASE
   END IF
END FUNCTION
