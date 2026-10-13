/*
================================================================================
檔案代號:zo_file
檔案名稱:公司名称资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:Y
============.========================.==========================================
*/
create table zo_file
(
zo01        varchar2(1) NOT NULL,    /*语言别                                 */
                                     /*語言別(0/1/2)                          */
                                     /*  0:中文                               */
                                     /*  1:英文                               */
zo02        varchar2(80),            /*公司对内全名                           */
                                     /*公司對內全名   char(36)->char(72)      */
zo041       varchar2(255),           /*公司addres一                           */
zo042       varchar2(255),           /*公司addres二                           */
zo05        varchar2(40),            /*电    话                               */
                                     /*電    話                               */
zo06        varchar2(20),            /*税号                                   */
                                     /*統一編號                               */
zo07        varchar2(40),            /*公司简称                               */
                                     /*公司簡稱                               */
zo08        varchar2(1),             /*No Use                                 */
zo09        varchar2(40),            /*传真号码                               */
                                     /*傳真號碼                               */
zo10        varchar2(255),           /*REMARK                                 */
zo11        varchar2(10),            /*税籍号码                               */
                                     /*稅籍號碼                               */
zo12        varchar2(80),            /*公司对外全名                           */
                                     /*公司對外全名   char(36)->char(72)      */
zo13        varchar2(20),            /*开户银行                               */
zo14        varchar2(1),             /*No Use                                 */
zo15        varchar2(1),             /*No Use                                 */
zouser      varchar2(10),            /*OWNER                                  */
zogrup      varchar2(10),            /*GROUP                                  */
zomodu      varchar2(10),            /*MODIFY USER                            */
zodate      date,                    /*MODIFY DATE                            */
zooriu      varchar2(10),            /*资料建立者                             */
zoorig      varchar2(10),            /*资料建立部门                           */
zo16        varchar2(6)              /*上市(柜)公司代号                       */
);

alter table zo_file add  constraint zo_pk primary key  (zo01) enable validate;
grant select on zo_file to tiptopgp;
grant update on zo_file to tiptopgp;
grant delete on zo_file to tiptopgp;
grant insert on zo_file to tiptopgp;
grant index on zo_file to public;
grant select on zo_file to ods;
