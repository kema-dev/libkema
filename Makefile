# *******************************    POST-IT    ****************************** #
#                                                                              #
#			## $@ 	Le nom de la cible										   #
#			## $< 	Le nom de la première dépendance						   #
#			## $^ 	La liste des dépendances								   #
#			## $? 	La liste des dépendances plus récentes que la cible		   #
#			## $* 	Le nom du fichier sans suffixe							   #
#                                                                              #
# **************************************************************************** #

#Compiler and Linker
CC			:=	gcc

#The Target Binary Program
TARGET		:=	ft_ping
DEBUGOUT	:=	debug.out

#The Directories, Source, Includes, Objects, Binary and Resources
SRCDIR		:=	src
INCDIR		:=	inc
OBJDIR		:=	obj
TARGETDIR	:=	bin
SRCEXT		:=	c
HDEXT		:=	h
OBJEXT		:=	o
LIBDIR		:=	libs/libkema
ARG			:=	

#Flags, Libraries and Includes
CFLAGS		:=	-Wall -Wextra -Werror
DEBUGFLAG	:=	-Wall -Wextra -fsanitize=address
LIB			:=	$(OBJDIR)/libkema.a
INC			:=	-I$(INCDIR)
SPECIALLIB	:=	

#---------------------------------------------------------------------------------
#DO NOT EDIT BELOW THIS LINE
#---------------------------------------------------------------------------------
HEADERS		:=	$(shell find $(INCDIR) -type f -name *.$(HDEXT))
SOURCES		:=	$(shell find $(SRCDIR) -type f -name *.$(SRCEXT))
OBJECTS		:=	$(patsubst $(SRCDIR)/%,$(OBJDIR)/%,$(SOURCES:.$(SRCEXT)=.$(OBJEXT)))

#Defauilt Make
all:	libs $(TARGETDIR)/$(TARGET)

#Remake
re:	fclean all

libs:	directories
	@make -C $(LIBDIR)
	@cp $(LIBDIR)/*.a $(OBJDIR)/

#Make the Directories
directories:
	@mkdir -p $(TARGETDIR)
	@mkdir -p $(OBJDIR)

#Clean only Objecst
clean:
	@$(RM) -rf $(OBJDIR)
	@make -C $(LIBDIR) clean

#Full Clean, Objects and Binaries
fclean:	clean
	@$(RM) -rf $(TARGETDIR)
	@make -C $(LIBDIR) fclean

clean_main:
	@$(RM) -rf $(OBJDIR)
	@$(RM) -rf $(TARGETDIR)

remain: clean_main all

norme:	fclean
	@printf "\ec"
	@norminette

norme_check:	fclean
	@printf "\ec"
	@norminette | grep "Error" | wc -l

debug:	libs $(OBJECTS)
	$(CC) $(DEBUGFLAG) $(INC) $(SPECIALLIB) -o $(TARGETDIR)/$(DEBUGOUT) $(OBJECTS) $(LIB)
	@clear
	./$(TARGETDIR)/$(DEBUGOUT) $(ARG)

ddebug:	libs $(OBJECTS)
	$(CC) $(DEBUGFLAG) $(INC) $(SPECIALLIB) -o $(TARGETDIR)/$(DEBUGOUT) $(OBJECTS) $(LIB)
	@printf "\ec"
	./$(TARGETDIR)/$(DEBUGOUT) $(ARG)

test:	libs $(OBJECTS)
	$(CC) $(INC) $(SPECIALLIB) -o $(TARGETDIR)/$(TARGET) $(OBJECTS) $(LIB)
	@clear
	./$(TARGETDIR)/$(TARGET)

ttest:	libs $(OBJECTS)
	$(CC) $(INC) $(SPECIALLIB) -o $(TARGETDIR)/$(TARGET) $(OBJECTS) $(LIB)
	@printf "\ec"
	./$(TARGETDIR)/$(TARGET)

valgrind:	libs $(OBJECTS)
	$(CC) $(INC) $(SPECIALLIB) -o $(TARGETDIR)/$(TARGET) $(OBJECTS) $(LIB)
	@clear
	valgrind --leak-check=full --show-leak-kinds=all ./$(TARGETDIR)/$(TARGET) $(ARG) 

leaks:	libs $(OBJECTS)
	$(CC) $(INC) $(SPECIALLIB) -o $(TARGETDIR)/$(TARGET) $(OBJECTS) $(LIB)
	@clear
	leaks --atExit -- ./$(TARGETDIR)/$(TARGET) $(ARG)

#Link
$(TARGETDIR)/$(TARGET): $(OBJECTS)
	$(CC) $(INC) $(SPECIALLIB) -o $(TARGETDIR)/$(TARGET) $^ $(LIB)

#Compile
$(OBJDIR)/%.$(OBJEXT): $(SRCDIR)/%.$(SRCEXT) $(HEADERS)
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) $(INC) -c -o $@ $<

#Non-File Targets
.PHONY: all re libs directories clean fclean clean_main remain norme norme_check debug test valgrind leaks