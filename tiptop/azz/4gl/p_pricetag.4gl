# Prog. Version..: '5.30.06-13.03.12(00003)'     #
# Library name...: p_pricetag.4gl
# Descriptions...: The price tag libray
# Date & Author..: 2010/03/31 by David Lee
# Modify.........: TQC-B40146 2011/04/19 by David Lee 价签打印方案分营运中心存储

#No.FUN-A30113
DATABASE ds      

GLOBALS "../../config/top.global"

CONSTANT INI_FILE STRING = "Connect.ini"
CONSTANT CONFIGRATION_TOOL STRING = "TestCon.exe"
#CONSTANT CONFIGRATION_TOOL_VER STRING = "1.0.0.0"  #No.TQC-B40146
CONSTANT CONFIGRATION_TOOL_VER STRING = "1.0.0.1"  #No.TQC-B40146
CONSTANT PRICE_TAG STRING = "DesignTag.exe"
#CONSTANT PRICE_TAG_VER STRING = "1.0.0.0" #No.TQC-B40146
CONSTANT PRICE_TAG_VER STRING = "1.0.0.4"  #No.TQC-B40146
CONSTANT PRICE_TAG_HOME STRING = "$DS4GL/bin" #No.TQC-B40146
CONSTANT PRICE_TAG_BASE STRING = "C:\\TIPTOP"

FUNCTION p_pricetag_conn() 
  DEFINE li_status    SMALLINT
  DEFINE ls_cmd       STRING
  DEFINE ls_str       STRING
  DEFINE ls_result    STRING
  DEFINE lch_pipe     base.Channel
   
  LET ls_cmd=CONFIGRATION_TOOL||' \"Y\"'
  CALL ui.interface.frontCall('standard','execute',[ls_cmd,1],[li_status])
  IF NOT li_status  THEN
    LET ls_str = PRICE_TAG_HOME||"/"||CONFIGRATION_TOOL
    LET lch_pipe = base.Channel.create() 
    LET ls_cmd="test -s "||ls_str||";echo $?"
    CALL lch_pipe.openPipe(ls_cmd,"r")
    IF NOT lch_pipe.read(ls_result) THEN
      RETURN FALSE
    END IF
    IF NOT ls_result.equals("0") THEN 
      RETURN FALSE
    END IF 

    IF NOT cl_download_file(ls_str,CONFIGRATION_TOOL) THEN 
      RETURN FALSE
    END IF 

  ELSE
    CALL ui.interface.frontCall('standard','cbget',[],[ls_result])     
    IF NOT ls_result.equals(CONFIGRATION_TOOL_VER) THEN
      LET ls_str = PRICE_TAG_HOME||"/"||CONFIGRATION_TOOL

      LET lch_pipe = base.Channel.create() 
      LET ls_cmd="test -s "||ls_str||";echo $?"
      CALL lch_pipe.openPipe(ls_cmd,"r")
      IF NOT lch_pipe.read(ls_result) THEN
        RETURN FALSE
      END IF
      IF NOT ls_result.equals("0") THEN 
        RETURN FALSE
      END IF 

      IF NOT cl_download_file(ls_str,CONFIGRATION_TOOL) THEN  
        RETURN FALSE
      END IF      
    END IF

    CALL ui.interface.frontCall('standard','cbclear',[],[li_status])     
  END IF

  #LET ls_cmd=CONFIGRATION_TOOL #No.TQC-B40146
  LET ls_cmd=CONFIGRATION_TOOL||' \"',g_plant,'\"' #No.TQC-B40146
  CALL ui.interface.frontCall('standard','execute',[ls_cmd,1],[li_status])
  IF NOT li_status THEN 
    RETURN FALSE 
  END IF
  
  CALL ui.interface.frontCall('standard','cbget',[],[ls_result])   
  IF ls_result.getindexof(INI_FILE,1)>0 THEN   
    LET ls_str=PRICE_TAG_HOME||"/"||INI_FILE
    IF NOT cl_upload_file(ls_result,ls_str) THEN
      RETURN FALSE
    END IF
    RUN "chmod 666 " || ls_str || " >/dev/null 2>&1" WITHOUT WAITING
    CALL ui.interface.frontCall('standard','cbclear',[],[li_status])     
  END IF

RETURN TRUE
END FUNCTION

FUNCTION p_pricetag_open()
  DEFINE li_status    SMALLINT
  DEFINE ls_cmd       STRING
  DEFINE ls_str       STRING
  DEFINE ls_result    STRING
  DEFINE lch_pipe     base.Channel
   
  LET ls_cmd=PRICE_TAG||' \"Y\"'
  CALL ui.interface.frontCall('standard','execute',[ls_cmd,1],[li_status])
  IF NOT li_status  THEN
    LET ls_str = PRICE_TAG_HOME||"/"||PRICE_TAG

    LET lch_pipe = base.Channel.create() 
    LET ls_cmd="test -s "||ls_str||";echo $?"
    CALL lch_pipe.openPipe(ls_cmd,"r")
    IF NOT lch_pipe.read(ls_result) THEN
      RETURN FALSE
    END IF
    IF NOT ls_result.equals("0") THEN 
      RETURN FALSE
    END IF 

    IF NOT cl_download_file(ls_str,PRICE_TAG) THEN 
      RETURN FALSE
    END IF 

  ELSE
    CALL ui.interface.frontCall('standard','cbget',[],[ls_result])     
    IF NOT ls_result.equals(PRICE_TAG_VER) THEN
      LET ls_str = PRICE_TAG_HOME||"/"||PRICE_TAG

      LET lch_pipe = base.Channel.create() 
      LET ls_cmd="test -s "||ls_str||";echo $?"
      CALL lch_pipe.openPipe(ls_cmd,"r")
      IF NOT lch_pipe.read(ls_result) THEN
        RETURN FALSE
      END IF
      IF NOT ls_result.equals("0") THEN 
        RETURN FALSE
      END IF 

      IF NOT cl_download_file(ls_str,PRICE_TAG) THEN  
        RETURN FALSE
      END IF      
    END IF

    CALL ui.interface.frontCall('standard','cbclear',[],[li_status])     
  END IF

  LET ls_str = PRICE_TAG_HOME||"/"||INI_FILE
  LET lch_pipe = base.Channel.create()
  LET ls_cmd="test -s "||ls_str||";echo $?"
  CALL lch_pipe.openPipe(ls_cmd,"r")
  IF NOT lch_pipe.read(ls_result) THEN
    RETURN FALSE
  END IF
  IF NOT ls_result.equals("0") THEN
   IF NOT p_pricetag_conn() THEN
     RETURN FALSE
   END IF 
  END IF   

  IF NOT cl_download_file(ls_str,INI_FILE) THEN
    RETURN FALSE
  END IF 

  #LET ls_cmd=PRICE_TAG #TQC-B40146
  LET ls_cmd=PRICE_TAG||' \"',g_plant,'\"' #TQC-B40146
  CALL ui.interface.frontCall('standard','execute',[ls_cmd,1],[li_status])
  IF NOT li_status THEN 
    RETURN FALSE 
  END IF

RETURN TRUE
END FUNCTION

FUNCTION p_pricetag_print(p_solution,p_data)
DEFINE p_solution STRING
DEFINE p_data     STRING

  DEFINE li_status    SMALLINT
  DEFINE ls_cmd       STRING
  DEFINE ls_str       STRING
  DEFINE ls_result    STRING
  DEFINE lch_pipe     base.Channel
   
  LET ls_cmd=PRICE_TAG||' \"Y\"'
  CALL ui.interface.frontCall('standard','execute',[ls_cmd,1],[li_status])
  IF NOT li_status  THEN
    LET ls_str = PRICE_TAG_HOME||"/"||PRICE_TAG

    LET lch_pipe = base.Channel.create() 
    LET ls_cmd="test -s "||ls_str||";echo $?"
    CALL lch_pipe.openPipe(ls_cmd,"r")
    IF NOT lch_pipe.read(ls_result) THEN
      RETURN FALSE
    END IF
    IF NOT ls_result.equals("0") THEN 
      RETURN FALSE
    END IF 

    IF NOT cl_download_file(ls_str,PRICE_TAG) THEN 
      RETURN FALSE
    END IF 

  ELSE
    CALL ui.interface.frontCall('standard','cbget',[],[ls_result])     
    IF NOT ls_result.equals(PRICE_TAG_VER) THEN
      LET ls_str = PRICE_TAG_HOME||"/"||PRICE_TAG

      LET lch_pipe = base.Channel.create() 
      LET ls_cmd="test -s "||ls_str||";echo $?"
      CALL lch_pipe.openPipe(ls_cmd,"r")
      IF NOT lch_pipe.read(ls_result) THEN
        RETURN FALSE
      END IF
      IF NOT ls_result.equals("0") THEN 
        RETURN FALSE
      END IF 

      IF NOT cl_download_file(ls_str,PRICE_TAG) THEN  
        RETURN FALSE
      END IF      
    END IF

    CALL ui.interface.frontCall('standard','cbclear',[],[li_status])     
  END IF

  LET ls_str = PRICE_TAG_HOME||"/"||INI_FILE
  LET lch_pipe = base.Channel.create()
  LET ls_cmd="test -s "||ls_str||";echo $?"
  CALL lch_pipe.openPipe(ls_cmd,"r")
  IF NOT lch_pipe.read(ls_result) THEN
    RETURN FALSE
  END IF
  IF NOT ls_result.equals("0") THEN
   IF NOT p_pricetag_conn() THEN
     RETURN FALSE
   END IF 
  END IF   

  IF NOT cl_download_file(ls_str,INI_FILE) THEN
    RETURN FALSE
  END IF 

  LET lch_pipe = base.Channel.create()
  LET ls_cmd="test -s "||p_data||";echo $?"
  CALL lch_pipe.openPipe(ls_cmd,"r")
  IF NOT lch_pipe.read(ls_result) THEN
    RETURN FALSE
  END IF
  IF NOT ls_result.equals("0") THEN
    RETURN FALSE
  END IF

  LET ls_str=PRICE_TAG_BASE||"\\"||get_short_filename(p_data)
  IF cl_null(ls_str) THEN
    RETURN FALSE
  END IF 

  CALL ui.interface.frontCall('standard','getenv',['SystemRoot'],[ls_result])
  IF cl_null(ls_result) THEN
    RETURN FALSE
  END IF

  LET ls_cmd=ls_result||"\\System32\\cmd.exe /C \"IF NOT EXIST "||PRICE_TAG_BASE||" MKDIR "||PRICE_TAG_BASE||"\""
  CALL ui.interface.frontCall('standard','execute',[ls_cmd,1],[li_status])
  IF NOT li_status THEN
   RETURN FALSE
  END IF 

  IF NOT cl_download_file(p_data,ls_str) THEN
    RETURN FALSE
  END IF
  
  #LET ls_cmd=PRICE_TAG||" \"-P\""||" \""||p_solution||"\""||" \""||ls_str||"\"" #TQC-B40146
  LET ls_cmd=PRICE_TAG||' \"',g_plant,'\"'||" \"-P\""||" \""||p_solution||"\""||" \""||ls_str||"\"" #TQC-B40146
  CALL ui.interface.frontCall('standard','execute',[ls_cmd,1],[li_status])
  IF NOT li_status THEN 
    RETURN FALSE 
  END IF
  
RETURN TRUE
END FUNCTION

FUNCTION get_short_filename(fname)
DEFINE fname,tmpStr,sep String
 DEFINE idx Integer

 LET tmpStr=fname
 LET sep=get_file_separator(fname)
 IF sep IS NULL THEN
  RETURN fname
 END IF
 LET idx=1
 WHILE idx<>0
   LET idx=fname.getIndexOf(sep,1)
   IF idx<>0 THEN
     LET fname=fname.subString(idx+1,fname.getLength())
   END IF
 END WHILE
 #DISPLAY "get_short_filename:original \"",tmpStr,"\" short \"",fname,"\""
 RETURN fname
END FUNCTION

FUNCTION get_file_separator(fname)
DEFINE fname,sep String
  IF fname.getIndexOf("/",1) <> 0 THEN
    LET sep="/"
  ELSE 
    IF fname.getIndexOf("\\",1) <> 0 THEN
      LET sep="\\"
    END IF
  END IF
  RETURN sep
END FUNCTION
#No.FUN-A30113
