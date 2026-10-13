/*
================================================================================
檔案代號:idu_file
檔案名稱:ICD制造通知单单头档
檔案目的:
上游檔案:
下游檔案:N
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table idu_file
(
idu01       varchar2(16) DEFAULT ' ' NOT NULL, /*制造通知单号*/
idu02       varchar2(255),           /*说明                                   */
idu08       varchar2(10),            /*部门                                   */
idu11       varchar2(10),            /*加工厂商                               */
idu12       varchar2(255),           /*加工厂商地址                           */
idu13       varchar2(10),            /*作业编号                               */
idu14       varchar2(10),            /*出货厂商                               */
idu15       varchar2(30),            /*厂商联络人                             */
idu16       varchar2(40),            /*厂商联络人电话                         */
idu17       varchar2(255),           /*出货厂商地址                           */
idu18       varchar2(6),             /*委外单别                               */
idu19       date,                    /*单据日期                               */
idu20       date,                    /*扣帐日期                               */
idu21       varchar2(10),            /*委外人员                               */
idu22       varchar2(6),             /*发料单别                               */
idu23       varchar2(10),            /*制程编号(Turnkey使用)                  */
idu24       varchar2(10),            /*出货厂商连络人类别                     */
idu25       varchar2(10),            /*加工厂商连络人类别                     */
idu26       varchar2(255),           /*加工厂商连络人                         */
iduconf     varchar2(1) DEFAULT 'N' NOT NULL, /*审核否*/
idudate     date,                    /*资料录入日                             */
idulegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
idumodd     date,                    /*最近更改日                             */
idumodu     varchar2(10),            /*资料更改者                             */
iduorig     varchar2(10),            /*资料建立部门                           */
iduoriu     varchar2(10),            /*资料建立者                             */
iduplant    varchar2(10) DEFAULT ' ' NOT NULL, /*所属营运中心*/
iduuser     varchar2(10)             /*资料所有者                             */
);

create unique index idu_01 on idu_file (idu01);
alter table idu_file add  constraint idu_pk primary key  (idu01) enable validate;
grant select on idu_file to tiptopgp;
grant update on idu_file to tiptopgp;
grant delete on idu_file to tiptopgp;
grant insert on idu_file to tiptopgp;
grant index on idu_file to public;
grant select on idu_file to ods;
