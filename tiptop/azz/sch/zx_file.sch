/*
================================================================================
檔案代號:zx_file
檔案名稱:部门用户档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table zx_file
(
zx01        varchar2(10) NOT NULL,   /*用户编号                               */
                                     /*使用者代號,(Login user name)           */
zx02        varchar2(80),            /*用户名称                               */
                                     /*使用者名稱                             */
zx03        varchar2(10),            /*部门编号                               */
                                     /*部門代號                               */
zx04        varchar2(10),            /*权限类型                               */
                                     /*權限類別                               */
zx05        varchar2(10),            /*自定目录编号                           */
                                     /*自定目錄編號                           */
zx06        varchar2(1),             /*使用语言别                             */
                                     /*使用語言別(0.中文/1.英文/2.簡體中文)   */
zx07        varchar2(1),             /*是否为多营运中心用户                   */
                                     /*Be Multi- Plant User? (Y/N)            */
zx08        varchar2(10),            /*缺省营运中心编号                       */
                                     /*Default Plant No.                      */
zx09        varchar2(80),            /*Email位置                              */
                                     /*Email位址                              */
zx10        varchar2(40),            /*WEB User Password                      */
zx11        varchar2(30),            /*用户流程                               */
zx12        varchar2(1),             /*依照权限调整用户目录                   */
zxuser      varchar2(10),            /*OWNER                                  */
zxgrup      varchar2(10),            /*GROUP                                  */
zxmodu      varchar2(10),            /*MODIFY USER                            */
zxdate      date,                    /*MODIFY DATE                            */
zx13        varchar2(1),             /*No Use                                 */
zx14        varchar2(1),             /*使用多语言功能                         */
zx15        varchar2(1),             /*UI切换语言别方式                       */
zx16        date,                    /*Password 更新日期                      */
zxacti      varchar2(1),             /*资料有效码                             */
zx17        number(5),               /*用户此口令已应用次数                   */
zx18        date,                    /*使用者可用截止日期                     */
zx19        varchar2(1),             /*强制使用者於下次登入更改密             */
zx20        number(5),               /*已试误次数                             */
zxoriu      varchar2(10),            /*资料建立者                             */
zxorig      varchar2(10)             /*资料建立部门                           */
);

alter table zx_file add  constraint zx_pk primary key  (zx01) enable validate;
grant select on zx_file to tiptopgp;
grant update on zx_file to tiptopgp;
grant delete on zx_file to tiptopgp;
grant insert on zx_file to tiptopgp;
grant index on zx_file to public;
grant select on zx_file to ods;
