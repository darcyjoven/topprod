/*
================================================================================
檔案代號:tsg_file
檔案名稱:集团调拨申请单单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table tsg_file
(
tsg01       varchar2(20) NOT NULL,   /*调拨申请单号                           */
tsg02       date,                    /*申请日期                               */
tsg03       varchar2(10),            /*需求营运中心                           */
tsg04       varchar2(10),            /*需求仓库                               */
tsg05       varchar2(1),             /*状态码                                 */
                                     /*1-Open 2-Reviewed 3-Posted 4-Void      */
tsg06       varchar2(10),            /*来源营运中心                           */
tsg07       varchar2(10),            /*来源仓库                               */
tsg08       varchar2(10),            /*员工                                   */
tsg09       varchar2(10),            /*部门                                   */
tsg10       varchar2(255),           /*备注                                   */
tsg11       varchar2(20),            /*原始单号                               */
tsg12       varchar2(255),           /*地址1                                  */
tsg13       varchar2(255),           /*地址2                                  */
tsg14       varchar2(255),           /*地址3                                  */
tsg15       varchar2(10),            /*客户地址                               */
tsg16       varchar2(1),             /*已打印提单否                           */
tsg17       date,                    /*预计出货日                             */
tsg18       date,                    /*实际出货日                             */
tsg19       varchar2(1),             /*导物流状况码                           */
                                     /*0-Uneduced                             */
tsg20       number(15,3),            /*重量                                   */
tsg21       number(15,3),            /*体积                                   */
tsguser     varchar2(10),            /*资料所有者                             */
tsggrup     varchar2(10),            /*资料所有部门                           */
tsgmodu     varchar2(10),            /*资料更改者                             */
tsgdate     date,                    /*最近更改日                             */
tsgacti     varchar2(1),             /*资料有效否                             */
tsgplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
tsglegal    varchar2(10) NOT NULL,   /*所属法人                               */
tsgoriu     varchar2(10),            /*资料建立者                             */
tsgorig     varchar2(10)             /*资料建立部门                           */
);

alter table tsg_file add  constraint tsg_pk primary key  (tsg01) enable validate;
grant select on tsg_file to tiptopgp;
grant update on tsg_file to tiptopgp;
grant delete on tsg_file to tiptopgp;
grant insert on tsg_file to tiptopgp;
grant index on tsg_file to public;
grant select on tsg_file to ods;
