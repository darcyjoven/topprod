/*
================================================================================
檔案代號:lti_file
檔案名稱:积分/折扣/储值加值规则变更单头文件
檔案目的:
上游檔案:
下游檔案:N
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lti_file
(
lti00       varchar2(1) DEFAULT ' ' NOT NULL, /*规则类型*/
lti01       varchar2(20),            /*卡种编号                               */
lti02       varchar2(1) NOT NULL,    /*规则方式                               */
lti03       varchar2(1) DEFAULT ' ' NOT NULL, /*排除方式*/
lti04       date,                    /*生效日期                               */
lti05       date,                    /*失效日期                               */
lti06       varchar2(10) DEFAULT ' ' NOT NULL, /*制订营运中心*/
lti07       varchar2(20) DEFAULT ' ' NOT NULL, /*规则单号*/
lti08       number(5) DEFAULT '0' NOT NULL, /*版本号*/
lti09       varchar2(1) DEFAULT 'N' NOT NULL, /*发布否*/
lti10       date,                    /*发布日期                               */
lti11       varchar2(1) DEFAULT '1' NOT NULL, /*折扣方式*/
ltiacti     varchar2(1) DEFAULT 'Y' NOT NULL, /*资料有效码*/
lticond     date,                    /*审核日期                               */
lticonf     varchar2(1) DEFAULT 'N' NOT NULL, /*审核否*/
lticonu     varchar2(10),            /*审核人员                               */
lticrat     date,                    /*资料创建日                             */
ltidate     date,                    /*最近更改日                             */
ltigrup     varchar2(10),            /*资料所有群                             */
ltilegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
ltimodu     varchar2(10),            /*资料更改者                             */
ltiorig     varchar2(10),            /*资料建立部门                           */
ltioriu     varchar2(10),            /*资料建立者                             */
ltiplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
ltipos      varchar2(1) NOT NULL,    /*已传POS否                              */
ltiuser     varchar2(10)             /*资料所有者                             */
);

alter table lti_file add  constraint lti_pk primary key  (lti06,lti07,lti08,ltiplant) enable validate;
grant select on lti_file to tiptopgp;
grant update on lti_file to tiptopgp;
grant delete on lti_file to tiptopgp;
grant insert on lti_file to tiptopgp;
grant index on lti_file to public;
grant select on lti_file to ods;
