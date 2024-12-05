        PROGRAM PoissonMatrix
        IMPLICIT NONE

        INTEGER N, i, j, row, col, size,idx
        PARAMETER (N=5) ! Grid size (NxN) max_size=105
        PARAMETER (size=(N-2)*(N-2)) ! Total size of the matrix
        DOUBLE PRECISION A(size, size),b(size,1),c(size,1),bb(size,1) ! RHS vector b
        DOUBLE PRECISION aa(size,size), wkspce(size), V(size,size)
        REAL g_top, g_bottom, g_left, g_right, h

c      Use nag_library, Only: f04aef, nag_wp
        external f04aef!, nag_wp 
      Integer, Parameter :: nin = 5, nout = 6
!     .. Local Scalars ..
      Integer :: ifail, lda, ldaa, ldb, ldbb, ldc,
     &           m


c      DOUBLE PRECISION  
c     &    aa(3,3), b(3,1),bb(3,1),c(3,1), wkspce(3)
!     .. Executable Statements ..

      lda = size
      ldaa = size
      ldb = size
      ldbb = size
      ldc = size
      m = 1

        ! Initialize boundary condition values
        g_top = 5.0     ! Dirichlet value at the top boundary
        g_bottom = 0.0  ! Dirichlet value at the bottom boundary
        g_left = 0.0    ! Dirichlet value at the left boundary
        g_right = 0.0   ! Dirichlet value at the right boundary
        h = 0.5         ! Neumann derivative value

        ! Initialize the matrix and RHS vector
        DO i = 1, size
           DO j = 1, size
              A(i, j) = 0.0
           END DO
           b(i,1) = 0.0
           c(i,1) = 0.0
        END DO

        do i=1,N
         do j=1,N
            V(i,j)=0.0
         enddo
        enddo    

        i=1
        do j=1,N
         V(i,j)=g_top
        enddo
        
        j=1
        do i=1, N
         V(i,j)=g_left
        enddo
        
        j=N
        do i=1,N
         V(i,j)=g_right
        enddo
        
        i=N
        do j=1,N
         V(i,j)=g_bottom
        enddo 


        ! Fill the matrix using the 5-point stencil
        idx = 0
        DO i = 2, N-1
           DO j = 2, N-1
              idx = idx + 1
              row = idx ! Inside points are indexed sequentially


cccccccccccccccccccccccc  Boundary conditions  cccccccccccccccccccccc  
cc Add contributions from Dirichlet boundaries to the RHS vector cccc

              IF (j-1 == 1) THEN
               b(row,1) = b(row,1) + g_left ! Left boundary (west)
              END IF
              IF (j+1 == N) THEN
                b(row,1) = b(row,1) + g_right ! Right boundary (east)
              END IF
              IF (i-1 == 1) THEN
                b(row,1) = b(row,1) + g_top ! Bottom boundary (south)
              END IF
              IF (i+1 == N) THEN
                b(row,1) = b(row,1) + g_bottom ! Top boundary (north)
              ENDIF                 

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

              ! Set the diagonal element
                A(row, row) = 4.0

              ! Check and set left neighbor
              IF (j > 2) THEN
                 col = row - 1
                 A(row, col) = -1.0
              END IF

              ! Check and set right neighbor
              IF (j < N-1) THEN
                 col = row + 1
                 A(row, col) = -1.0
              END IF

              ! Check and set bottom neighbor
              IF (i > 2) THEN
                 col = row - (N-2)
                 A(row, col) = -1.0
              END IF

              ! Check and set top neighbor
              IF (i < N-1) THEN
                 col = row + (N-2)
                 A(row, col) = -1.0
              END IF
           END DO
        END DO



              ! Handle Neumann boundary conditions (example for top edge)
c              ELSE

c                 A(row, row) = 4.0
                 
c                 IF (j > 1) THEN
c                    col = row - 1
c                    A(row, col) = -1.0
c                 END IF

c                 IF (j < N) THEN
c                    col = row + 1
c                    A(row, col) = -1.0
c                 END IF

c                 IF (i > 1) THEN
c                    col = row - N
c                    A(row, col) = -1.0
c                 END IF

c                 IF (i < N) THEN
c                    col = row + N
c                    A(row, col) = -1.0
c                    IF (i == N-1) THEN
c                       b(row,1) = -h ! Neumann condition at the top edge
c                    END IF
c                 END IF

C              END IF

c           END DO
c        END DO

        ! Output the matrix and RHS vector
c        PRINT *, "Matrix A:"
c        DO i = 1, size
c           WRITE (*, '(10F8.2)') (A(i, j), j = 1, size)
c        END DO
        PRINT *, "RHS b:"
        WRITE (*, '(10F8.2)') (b(i,1), i = 1, size)

        ifail = -1
      Call f04aef(a,lda,b,ldb,n,m,c,ldc,wkspce,aa,ldaa,bb,ldbb,ifail)

      Write (nout,*) ' Solution'
      Write (nout,99999)(c(i,1),i=1,size)


      OPEN(8, FILE='potential.txt') 
      do i=1,size
         write(8,*) c(i,1)
      enddo
      close(8)


99999 Format (1X,F9.4)

        END PROGRAM PoissonMatrix
