/*
================================================================================
檔案代號:rtn_file
檔案名稱:自定价调整单单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rtn_file
(
rtn01       varchar2(20) DEFAULT ' ' NOT NULL, /*调整单单号*/
rtn02       number(5) NOT NULL,      /*项次                                   */
rtn03       varchar2(40),            /*产品编号                               */
rtn04       varchar2(4),             /*计价单位                               */
rtn05       number(20,6),            /*原自定售价                             */
rtn06       number(20,6),            /*原自定会员价                           */
rtn07       number(20,6),            /*原自定最低价                           */
rtn08       number(5,2),             /*自定售价调价比例                       */
rtn09       number(5,2),             /*自定会员价调价比例                     */
rtn10       number(5,2),             /*自定最低价调价比例                     */
rtn11       number(20,6),            /*新自定售价                             */
rtn12       number(20,6),            /*新自定会员价                           */
rtn13       number(20,6),            /*新自定最低价                           */
rtn14       varchar2(1),             /*原有效否                               */
rtn15       varchar2(1),             /*新有效否                               */
rtnlegal    varchar2(10) NOT NULL,   /*所属法人                               */
rtnplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
rtn16       varchar2(1) DEFAULT 'N' NOT NULL, /*新開價否*/
rtn17       varchar2(1) DEFAULT ' ' NOT NULL, /*新開價否*/
rtn18       number(20,6)             /*最高退价                               */
);

create        index rtn_02 on rtn_file (rtn03,rtn04);
alter table rtn_file add  constraint rtn_pk primary key  (rtn01,rtn02) enable validate;
grant select on rtn_file to tiptopgp;
grant update on rtn_file to tiptopgp;
grant delete on rtn_file to tiptopgp;
grant insert on rtn_file to tiptopgp;
grant index on rtn_file to public;
grant select on rtn_file to ods;
