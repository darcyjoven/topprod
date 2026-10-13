/*
================================================================================
檔案代號:oeqi_file
檔案名稱:订单变更单单身(行业别档)
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table oeqi_file
(
oeqi01      varchar2(20) DEFAULT ' ' NOT NULL, /*订单单号*/
oeqi02      number(5) DEFAULT '0' NOT NULL, /*变更序号*/
oeqi03      number(5) DEFAULT '0' NOT NULL, /*订单项次*/
oeqiicd01a  varchar2(40),            /*变更后内编母体                         */
oeqiicd01b  varchar2(40),            /*变更前内编母体                         */
oeqiicd02a  number(9,4),             /*变更后Spare Part                       */
oeqiicd02b  number(9,4),             /*变更前Spare Part                       */
oeqiicd03a  varchar2(1),             /*变更后Multi Die                        */
oeqiicd03b  varchar2(1),             /*变更前Multi Die                        */
oeqiicd04a  varchar2(10),            /*变更后End User                         */
oeqiicd04b  varchar2(10),            /*变更前End User                         */
oeqiplant   varchar2(10) NOT NULL,   /*所属营运中心                           */
oeqilegal   varchar2(10) NOT NULL    /*所属法人                               */
);

alter table oeqi_file add  constraint oeqi_pk primary key  (oeqi01,oeqi02,oeqi03) enable validate;
grant select on oeqi_file to tiptopgp;
grant update on oeqi_file to tiptopgp;
grant delete on oeqi_file to tiptopgp;
grant insert on oeqi_file to tiptopgp;
grant index on oeqi_file to public;
grant select on oeqi_file to ods;
