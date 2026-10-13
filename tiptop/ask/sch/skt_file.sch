/*
================================================================================
檔案代號:skt_file
檔案名稱:裁片移转单单身档
檔案目的:裁片移转单单身档
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table skt_file
(
skt01       varchar2(20) DEFAULT ' ' NOT NULL, /*移转单号*/
skt02       number(10) DEFAULT '0' NOT NULL, /*移转项次*/
skt03       varchar2(20) DEFAULT ' ' NOT NULL, /*工单单号*/
skt04       number(10),              /*工艺序号                               */
skt05       number(10) DEFAULT '0' NOT NULL, /*版片序号*/
skt06       number(15,3) DEFAULT '0' NOT NULL, /*单件片数*/
skt07       number(15,3) DEFAULT '0' NOT NULL, /*移转件数*/
skt08       number(15,3) DEFAULT '0' NOT NULL, /*总片数*/
sktud01     varchar2(255),           /*自订字段-Textedit                      */
sktud02     varchar2(40),            /*自订字段-文字                          */
sktud03     varchar2(40),            /*自订字段-文字                          */
sktud04     varchar2(40),            /*自订字段-文字                          */
sktud05     varchar2(40),            /*自订字段-文字                          */
sktud06     varchar2(40),            /*自订字段-文字                          */
sktud07     number(15,3),            /*自订字段-数值                          */
sktud08     number(15,3),            /*自订字段-数值                          */
sktud09     number(15,3),            /*自订字段-数值                          */
sktud10     number(10),              /*自订字段-整数                          */
sktud11     number(10),              /*自订字段-整数                          */
sktud12     number(10),              /*自订字段-整数                          */
sktud13     date,                    /*自订字段-日期                          */
sktud14     date,                    /*自订字段-日期                          */
sktud15     date,                    /*自订字段-日期                          */
sktplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
sktlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table skt_file add  constraint skt_pk primary key  (skt01,skt02) enable validate;
grant select on skt_file to tiptopgp;
grant update on skt_file to tiptopgp;
grant delete on skt_file to tiptopgp;
grant insert on skt_file to tiptopgp;
grant index on skt_file to public;
grant select on skt_file to ods;
