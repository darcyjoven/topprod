/*
================================================================================
檔案代號:ofg_file
檔案名稱:业务员工作日报档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ofg_file
(
ofg01       varchar2(10) DEFAULT ' ' NOT NULL, /*业务员编号*/
                                     /*業務員編號                             */
ofg02       date DEFAULT sysdate NOT NULL, /*日期*/
ofg03       varchar2(10) DEFAULT ' ' NOT NULL, /*潜在客户编号*/
                                     /*潛在客戶編號                           */
ofg04       number(9,4),             /*成交机率                               */
                                     /*成交機率                               */
ofg05       varchar2(255),           /*工作内容1                              */
                                     /*工作內容1                              */
ofg051      varchar2(255),           /*工作内容2                              */
                                     /*工作內容2                              */
ofg052      varchar2(255),           /*工作内容3                              */
                                     /*工作內容3                              */
ofg053      varchar2(255),           /*工作内容4                              */
                                     /*工作內容4                              */
ofg054      varchar2(255),           /*工作内容5                              */
                                     /*工作內容5                              */
ofg06       varchar2(255),           /*客户现况1                              */
                                     /*客戶現況1                              */
ofg061      varchar2(255),           /*客户现况2                              */
                                     /*客戶現況2                              */
ofg062      varchar2(255),           /*客户现况3                              */
                                     /*客戶現況3                              */
ofg063      varchar2(255),           /*客户现况4                              */
                                     /*客戶現況4                              */
ofg064      varchar2(255),           /*客户现况5                              */
                                     /*客戶現況5                              */
ofgacti     varchar2(1),             /*资料有效码                             */
ofguser     varchar2(10),            /*资料所有者                             */
ofggrup     varchar2(10),            /*资料所有群                             */
ofgmodu     varchar2(10),            /*资料更改者                             */
ofgdate     date,                    /*最近更改日                             */
ofgplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
ofglegal    varchar2(10) NOT NULL,   /*所属法人                               */
ofgoriu     varchar2(10),            /*资料建立者                             */
ofgorig     varchar2(10)             /*资料建立部门                           */
);

alter table ofg_file add  constraint ofg_pk primary key  (ofg01,ofg02,ofg03) enable validate;
grant select on ofg_file to tiptopgp;
grant update on ofg_file to tiptopgp;
grant delete on ofg_file to tiptopgp;
grant insert on ofg_file to tiptopgp;
grant index on ofg_file to public;
grant select on ofg_file to ods;
