/*
================================================================================
檔案代號:hray_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:M
多語系檔案:N
============.========================.==========================================
*/
create table hray_file
(
hray01      varchar2(20) NOT NULL,   /*工号                                   */
hray02      date,                    /*转正日期                               */
hray03      varchar2(20),            /* 转岗部门编码                          */
hray04      varchar2(20),            /* 转岗职位编码                          */
hray05      varchar2(20),            /*审核人编码                             */
hray06      date,                    /* 审核日期                              */
hray07      varchar2(20),            /*审核结果编码                           */
hray08      varchar2(20),            /*员工状态                               */
hray09      varchar2(1),             /*EF标示                                 */
hray10      varchar2(20),            /*状态编码                               */
hray11      varchar2(50),            /*表单单号                               */
hray12      varchar2(1000),          /*直接主管意见                           */
hray13      varchar2(1000),          /*部门经理意见                           */
hray14      varchar2(1000),          /*总经理意见                             */
hray15      varchar2(20),            /* 原部门编码                            */
hray16      varchar2(20),            /* 原职位编码                            */
hray17      varchar2(1),             /*ESS标示                                */
hray18      date,                    /* 提交日期                              */
hray19      varchar2(20),            /*提交人编码                             */
hray20      date,                    /* 归档日期                              */
hray21      varchar2(20),            /*归档人编码                             */
hray22      date,                    /* 撤销日期                              */
hray23      varchar2(20),            /*撤销人编码                             */
hrayacti    varchar2(1),             /*资料有效码                             */
                                     /*系统维护                               */
hrayuser    varchar2(10),            /*资料所有者                             */
                                     /*系统维护                               */
hraygrup    varchar2(10),            /*资料所有群                             */
                                     /*系统维护                               */
hraymodu    varchar2(10),            /*资料更改者                             */
                                     /*系统维护                               */
hraydate    date,                    /*最近修改日                             */
                                     /*系统维护                               */
hrayoriu    varchar2(10),            /*资料建立者                             */
hrayorig    varchar2(10)             /*资料建立部门                           */
);

alter table hray_file add  constraint tpc_hray_pk primary key  (hray01) enable validate;
grant select on hray_file to tiptopgp;
grant update on hray_file to tiptopgp;
grant delete on hray_file to tiptopgp;
grant insert on hray_file to tiptopgp;
grant index on hray_file to public;
grant select on hray_file to ods;
